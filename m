Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227150234.zxjzddngwjw7cp45@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mx1.redhat.com ([209.132.183.28]:56404 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751513AbdBXTxW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Feb 2017 14:53:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/3] [RFC] xfs: release buffer list after quotacheck buf reset
Date: Fri, 24 Feb 2017 14:53:21 -0500
Message-Id: <1487966001-63263-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
References: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Martin Svec <martin.svec@zoner.cz>

XXX: This patch is broken and should not be merged.

This purpose of this patch is to consider the notion of reducing
quotacheck memory consumption requirements via earlier release of
the buffer list. The intent is to allow dquot and buffer reclaim to
operate as normal during the subsequent bulkstat (dqadjust) and
dquot flush walk. In turn, this allows quotacheck to complete in
environments with tight memory constraints.

As it is, this approach has several unresolved tradeoffs/problems:

- The change is limited in effectiveness to situations where the
total dquot allocation requirements are the difference between OOM
and a successful mount. OOM is still possible as we still allocate
the entire dquot buffer space.

- In limited but non-OOM situations, this can cause quotacheck to
take significantly longer than normal. On a filesystem with ~4
million inodes and ~600k project quotas, a quotacheck typically runs
for ~50s in a local vm limited to 1GB RAM. With this change, the
same quotacheck requires anywhere from ~9-12m in my tests.

- By releasing the buffer list and allowing reclaim to do some of
the work, quotacheck has lost serialization against I/O completion
of the adjusted dquots. This creates the potential for corruption if
the filesystem crashes after quotacheck completion status has been
logged but before dquot I/O has fully completed. IOWs, release of
the buffer list as such requires the addition of a new, so far
undefined post-quotacheck serialization sequence.

One option here may be a post delwri submit walk of in-core dquots
purely to cycle the flush locks, the idea being that dquots can't be
fully reclaimed until the flush lock is unlocked and thus buffer I/O
has completed. Another option may be a post-quotacheck
xfs_wait_buftarg().

- This patch leads to some apparent buffer refcounting issues
(unrelated to the pushbuf bits). I reproduce _XBF_DELWRI_Q buffer
release time asserts and unmount hangs that need to be tracked down
and resolved. It is not yet clear whether these are generic problems
or require further changes in the quotacheck implementation to deal
with the fact that quotacheck can no longer assume exclusive access
to the dquot buffers.
---
 fs/xfs/xfs_qm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3815ed3..b072495 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1267,10 +1267,9 @@ xfs_qm_flush_one(
 	 * cycle the flush lock.
 	 */
 	if (!xfs_dqflock_nowait(dqp)) {
-		/* buf is pinned in-core by delwri list */
-		DEFINE_SINGLE_BUF_MAP(map, dqp->q_blkno,
-				      mp->m_quotainfo->qi_dqchunklen);
-		bp = _xfs_buf_find(mp->m_ddev_targp, &map, 1, 0, NULL);
+		bp = xfs_buf_read(mp->m_ddev_targp, dqp->q_blkno,
+				  mp->m_quotainfo->qi_dqchunklen, 0,
+				  &xfs_dquot_buf_ops);
 		if (!bp) {
 			error = -EINVAL;
 			goto out_unlock;
@@ -1351,6 +1350,10 @@ xfs_qm_quotacheck(
 		flags |= XFS_PQUOTA_CHKD;
 	}
 
+	error = xfs_buf_delwri_submit(&buffer_list);
+	if (error)
+		goto error_return;
+
 	do {
 		/*
 		 * Iterate thru all the inodes in the file system,
-- 
2.7.4

