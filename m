Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751049AbdBOPks (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Feb 2017 10:40:48 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/5] xfs: bypass dquot reclaim to avoid quotacheck deadlock
Date: Wed, 15 Feb 2017 10:40:43 -0500
Message-Id: <1487173247-5965-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
References: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>, Dave Chinner <david@fromorbit.com>

Reclaim during quotacheck can lead to deadlocks on the dquot flush lock:

 - Quotacheck populates a local delwri queue with the physical dquot
   buffers.
 - Quotacheck performs the xfs_qm_dqusage_adjust() bulkstat and dirties
   all of the dquots.
 - Reclaim kicks in and attempts to flush a dquot whose buffer is
   already queud on the quotacheck queue. The flush succeeds but
   queueing to the reclaim delwri queue fails as the backing buffer is
   already queued. The flush unlock is now deferred to I/O completion of
   the buffer from the quotacheck queue.
 - Quotacheck proceeds to the xfs_qm_flush_one() walk which requires the
   flush lock to update the backing buffers with the in-core
   recalculated values. This deadlocks as the flush lock was acquired by
   reclaim but the buffer never submitted for I/O as it already resided
   on the quotacheck queue.

This is reproduced by running quotacheck on a filesystem with a couple
million inodes in low memory (512MB-1GB) situations.

Quotacheck first resets and collects the physical dquot buffers in a
delwri queue. Then, it traverses the filesystem inodes via bulkstat,
updates the in-core dquots, flushes the corrected dquots to the backing
buffers and finally submits the delwri queue for I/O. Since the backing
buffers are queued across the entire quotacheck operation, dquot reclaim
cannot possibly complete a dquot flush before quotacheck completes.
Therefore, dquot reclaim provides no real value during quotacheck.

Lock out dquot reclaim during quotacheck to avoid the deadlock. Define
and set a new quotainfo flag when quotacheck is in progress that reclaim
can use to bypass processing as appropriate.

Reported-by: Martin Svec <martin.svec@zoner.cz>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_qm.c | 11 +++++++++++
 fs/xfs/xfs_qm.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b669b12..7c44a6e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -527,6 +527,8 @@ xfs_qm_shrink_scan(
 
 	if ((sc->gfp_mask & (__GFP_FS|__GFP_DIRECT_RECLAIM)) != (__GFP_FS|__GFP_DIRECT_RECLAIM))
 		return 0;
+	if (qi->qi_quotacheck)
+		return 0;
 
 	INIT_LIST_HEAD(&isol.buffers);
 	INIT_LIST_HEAD(&isol.dispose);
@@ -623,6 +625,7 @@ xfs_qm_init_quotainfo(
 	INIT_RADIX_TREE(&qinf->qi_gquota_tree, GFP_NOFS);
 	INIT_RADIX_TREE(&qinf->qi_pquota_tree, GFP_NOFS);
 	mutex_init(&qinf->qi_tree_lock);
+	qinf->qi_quotacheck = false;
 
 	/* mutex used to serialize quotaoffs */
 	mutex_init(&qinf->qi_quotaofflock);
@@ -1294,6 +1297,12 @@ xfs_qm_quotacheck(
 	ASSERT(uip || gip || pip);
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
+	/*
+	 * Set a flag to lock out dquot reclaim during quotacheck. The dquot
+	 * shrinker can cause flush lock deadlocks by attempting to flush dquots
+	 * whose backing buffers are already on the quotacheck delwri queue.
+	 */
+	mp->m_quotainfo->qi_quotacheck = true;
 	xfs_notice(mp, "Quotacheck needed: Please wait.");
 
 	/*
@@ -1384,6 +1393,8 @@ xfs_qm_quotacheck(
 	mp->m_qflags |= flags;
 
  error_return:
+	mp->m_quotainfo->qi_quotacheck = false;
+
 	while (!list_empty(&buffer_list)) {
 		struct xfs_buf *bp =
 			list_first_entry(&buffer_list, struct xfs_buf, b_list);
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 2975a82..d5a443d 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -89,6 +89,7 @@ typedef struct xfs_quotainfo {
 	struct xfs_def_quota	qi_grp_default;
 	struct xfs_def_quota	qi_prj_default;
 	struct shrinker  qi_shrinker;
+	bool			qi_quotacheck;	/* quotacheck is running */
 } xfs_quotainfo_t;
 
 static inline struct radix_tree_root *
-- 
2.7.4

