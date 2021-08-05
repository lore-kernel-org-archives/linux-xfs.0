Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48D8C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B811B61078
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbhHECHP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 22:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238097AbhHECHP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 22:07:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1EA16105A;
        Thu,  5 Aug 2021 02:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628129221;
        bh=/87HWDdI+42icW1eQ5KDpPAI2ge94eeUQul9mS+whV8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vL9LvN11yz9+NfkEZE5sjoNO8dupO7EA6c+FkhHVau26B3012PqKo1qaRhpRbr6hN
         3LrjwUeyiaMRZSXwo8yez8Mu6f9MXNxRLpffyYzFIWVfFta+rPeFOY0YwE3KrHMmR7
         rX2ZrmGT06UVyHhcA5gF52NIysQW/yzHeOZV3en3UmK5elmfY/uCVbRoRQU0ALGcsY
         CrY8qpmf9LL3uqF6ONMPxIhBp4k5qlFQ8dcc5o2J6Skgy2r+BXzdpDUe4Jso3qeei1
         gXlQWOT5PGZF0cSCDCVCNjeqkp0L03NRuu83ZJe37aZDSy+MfX2G9HofldpB7Mlr3v
         RQTIFRdyiK15A==
Subject: [PATCH 07/14] xfs: queue inactivation immediately when quota is
 nearing enforcement
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 04 Aug 2021 19:07:01 -0700
Message-ID: <162812922142.2589546.1431900603501424659.stgit@magnolia>
In-Reply-To: <162812918259.2589546.16599271324044986858.stgit@magnolia>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have made the inactivation of unlinked inodes a background
task to increase the throughput of file deletions, we need to be a
little more careful about how long of a delay we can tolerate.

Specifically, if the dquots attached to the inode being inactivated are
nearing any kind of enforcement boundary, we want to queue that
inactivation work immediately so that users don't get EDQUOT/ENOSPC
errors even after they deleted a bunch of files to stay within quota.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.h  |   10 ++++++++++
 fs/xfs/xfs_icache.c |   10 ++++++++++
 fs/xfs/xfs_qm.c     |   34 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_quota.h  |    2 ++
 4 files changed, 56 insertions(+)


diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index f642884a6834..6b5e3cf40c8b 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -54,6 +54,16 @@ struct xfs_dquot_res {
 	xfs_qwarncnt_t		warnings;
 };
 
+static inline bool
+xfs_dquot_res_over_limits(
+	const struct xfs_dquot_res	*qres)
+{
+	if ((qres->softlimit && qres->softlimit < qres->reserved) ||
+	    (qres->hardlimit && qres->hardlimit < qres->reserved))
+		return true;
+	return false;
+}
+
 /*
  * The incore dquot structure
  */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0332acaad6f3..e5e90f09bcc6 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1929,6 +1929,7 @@ xfs_inodegc_start(
  *
  *  - We've accumulated more than one inode cluster buffer's worth of inodes.
  *  - There is less than 5% free space left.
+ *  - Any of the quotas for this inode are near an enforcement limit.
  */
 static inline bool
 xfs_inodegc_want_queue_work(
@@ -1945,6 +1946,15 @@ xfs_inodegc_want_queue_work(
 				XFS_FDBLOCKS_BATCH) < 0)
 		return true;
 
+	if (xfs_inode_near_dquot_enforcement(ip, XFS_DQTYPE_USER))
+		return true;
+
+	if (xfs_inode_near_dquot_enforcement(ip, XFS_DQTYPE_GROUP))
+		return true;
+
+	if (xfs_inode_near_dquot_enforcement(ip, XFS_DQTYPE_PROJ))
+		return true;
+
 	return false;
 }
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 351d99bc52e5..2bef4735d030 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1882,3 +1882,37 @@ xfs_qm_vop_create_dqattach(
 	}
 }
 
+/* Decide if this inode's dquot is near an enforcement boundary. */
+bool
+xfs_inode_near_dquot_enforcement(
+	struct xfs_inode	*ip,
+	xfs_dqtype_t		type)
+{
+	struct xfs_dquot	*dqp;
+	int64_t			freesp;
+
+	/* We only care for quotas that are enabled and enforced. */
+	dqp = xfs_inode_dquot(ip, type);
+	if (!dqp || !xfs_dquot_is_enforced(dqp))
+		return false;
+
+	if (xfs_dquot_res_over_limits(&dqp->q_ino) ||
+	    xfs_dquot_res_over_limits(&dqp->q_rtb))
+		return true;
+
+	/* For space on the data device, check the various thresholds. */
+	if (!dqp->q_prealloc_hi_wmark)
+		return false;
+
+	if (dqp->q_blk.reserved < dqp->q_prealloc_lo_wmark)
+		return false;
+
+	if (dqp->q_blk.reserved >= dqp->q_prealloc_hi_wmark)
+		return true;
+
+	freesp = dqp->q_prealloc_hi_wmark - dqp->q_blk.reserved;
+	if (freesp < dqp->q_low_space[XFS_QLOWSP_5_PCNT])
+		return true;
+
+	return false;
+}
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index d00d01302545..dcc785fdd345 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -113,6 +113,7 @@ xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
 {
 	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
 }
+bool xfs_inode_near_dquot_enforcement(struct xfs_inode *ip, xfs_dqtype_t type);
 #else
 static inline int
 xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
@@ -168,6 +169,7 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 #define xfs_qm_mount_quotas(mp)
 #define xfs_qm_unmount(mp)
 #define xfs_qm_unmount_quotas(mp)
+#define xfs_inode_near_dquot_enforcement(ip, type)			(false)
 #endif /* CONFIG_XFS_QUOTA */
 
 static inline int

