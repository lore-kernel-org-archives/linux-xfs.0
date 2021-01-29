Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7791DC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AEE564DF5
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhA2CTL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 21:19:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:57962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbhA2CTI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 21:19:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94F5864DF5;
        Fri, 29 Jan 2021 02:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886706;
        bh=LuIgLf/EMCcJy17c12HZF5qW/N+9sirXUGwSNtB0BKs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lRVIsjCbpFqWHOvFYRQTwXkJn9eX94PF5nxMsm0545J9MfmKTRkyLTlR9tz3SVKJl
         lc/jq5242fv/oUi8xRiHDute72mLBa1J/4VoBPL+e+wM7f77RJTHShwbzFm1F4E8CJ
         63Ex9HrHmlhwF1wWtuGHGM7yB24rSrxC6gPY2eQS1VjwchPy1EnRliPxpezkQdqUJC
         A/WPsRjRhIOubInUhOOx1w3F0dSy2YlDL2wiVa2BP/xST0OSy1hSqIe4QKGjLz4xyx
         ifidshtFRqePg4o4+eebX2UqV7nb0rXW/fRWF9qBjxxJZpbdgPYogxgUwn55wIxAqt
         5qrb95NyMR63g==
Subject: [PATCH 07/12] xfs: flush eof/cowblocks if we can't reserve quota for
 file blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Thu, 28 Jan 2021 18:18:26 -0800
Message-ID: <161188670620.1943978.10940674429363795194.stgit@magnolia>
In-Reply-To: <161188666613.1943978.971196931920996596.stgit@magnolia>
References: <161188666613.1943978.971196931920996596.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a fs modification (data write, reflink, xattr set, fallocate, etc.)
is unable to reserve enough quota to handle the modification, try
clearing whatever space the filesystem might have been hanging onto in
the hopes of speeding up the filesystem.  The flushing behavior will
become particularly important when we add deferred inode inactivation
because that will increase the amount of space that isn't actively tied
to user data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_quota.h       |    7 +++--
 fs/xfs/xfs_reflink.c     |    7 ++++-
 fs/xfs/xfs_trans.c       |   12 +++++++-
 fs/xfs/xfs_trans_dquot.c |   69 ++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 84 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index f95a92d7ceaf..dd74a3e789bd 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -82,7 +82,8 @@ extern void xfs_trans_mod_dquot_byino(struct xfs_trans *, struct xfs_inode *,
 extern void xfs_trans_apply_dquot_deltas(struct xfs_trans *);
 extern void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *);
 int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
-		int64_t dblocks, int64_t rblocks, bool force);
+		int64_t dblocks, int64_t rblocks, bool force,
+		unsigned int *retry);
 extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_mount *, struct xfs_dquot *,
 		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
@@ -114,7 +115,7 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 static inline int
 xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
 {
-	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
+	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false, NULL);
 }
 #else
 static inline int
@@ -134,7 +135,7 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
 #define xfs_trans_unreserve_and_mod_dquots(tp)
 static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
 		struct xfs_inode *ip, int64_t dblocks, int64_t rblocks,
-		bool force)
+		bool force, unsigned int *retry)
 {
 	return 0;
 }
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 086866f6e71f..9659adf5f182 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1092,10 +1092,15 @@ xfs_reflink_remap_extent(
 	 * count.  This is suboptimal, but the VFS flushed the dest range
 	 * before we started.  That should have removed all the delalloc
 	 * reservations, but we code defensively.
+	 *
+	 * xfs_trans_alloc_inode above already tried to grab an even larger
+	 * quota reservation, and kicked off a blockgc scan if it couldn't.
+	 * If we can't get a potentially smaller quota reservation now, we're
+	 * done.
 	 */
 	if (!quota_reserved && !smap_real && dmap_written) {
 		error = xfs_trans_reserve_quota_nblks(tp, ip,
-				dmap->br_blockcount, 0, false);
+				dmap->br_blockcount, 0, false, NULL);
 		if (error)
 			goto out_cancel;
 	}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 6c68635cc6ac..1217e6c41aa5 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -23,6 +23,7 @@
 #include "xfs_inode.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
+#include "xfs_icache.h"
 
 kmem_zone_t	*xfs_trans_zone;
 
@@ -1046,8 +1047,10 @@ xfs_trans_alloc_inode(
 {
 	struct xfs_trans	*tp;
 	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		qretry = 0;
 	int			error;
 
+retry:
 	error = xfs_trans_alloc(mp, resv, dblocks,
 			rblocks / mp->m_sb.sb_rextsize,
 			force ? XFS_TRANS_RESERVE : 0, &tp);
@@ -1064,9 +1067,16 @@ xfs_trans_alloc_inode(
 		goto out_cancel;
 	}
 
-	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
+	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force,
+			&qretry);
 	if (error)
 		goto out_cancel;
+	if (qretry) {
+		xfs_trans_cancel(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_blockgc_free_quota(ip, 0);
+		goto retry;
+	}
 
 	*tpp = tp;
 	return 0;
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 73ef5994d09d..cb1fa4b047d6 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -770,11 +770,67 @@ xfs_trans_reserve_quota_bydquots(
 	return error;
 }
 
+/*
+ * Decide what to do after an attempt to reserve some quota.  This will set
+ * the retry and error parameters as needed, and returns true if the quota
+ * reservation succeeded.
+ */
+static inline bool
+reservation_success(
+	unsigned int		qflag,
+	unsigned int		*retry,
+	int			*error)
+{
+	/*
+	 * The caller is not interested in retries.  Return whether or not we
+	 * got an error code.
+	 */
+	if (retry == NULL)
+		return *error == 0;
+
+	if (*error == -EDQUOT || *error == -ENOSPC) {
+		/*
+		 * There isn't enough quota left to allow the reservation.
+		 *
+		 * If none of the retry bits are set, this is the first time
+		 * that we failed a quota reservation.  Zero the error code and
+		 * set the appropriate quota flag in *retry to encourage the
+		 * xfs_trans_reserve_quota_nblks caller to clear some space and
+		 * call back.
+		 *
+		 * If any of the retry bits are set, this means that we failed
+		 * the quota reservation once before, tried to free some quota,
+		 * and have now failed the second quota reservation attempt.
+		 * Pass the error back to the caller; we're done.
+		 */
+		if (!(*retry))
+			*error = 0;
+
+		*retry |= qflag;
+		return false;
+	}
+
+	/* A non-quota error occurred; there is no retry. */
+	if (*error)
+		return false;
+
+	/*
+	 * The reservation succeeded.  Clear the quota flag from the retry
+	 * state because there is nothing to retry.
+	 */
+	*retry &= ~qflag;
+	return true;
+}
 
 /*
- * Lock the dquot and change the reservation if we can.
- * This doesn't change the actual usage, just the reservation.
- * The inode sent in is locked.
+ * Lock the dquot and change the reservation if we can.  This doesn't change
+ * the actual usage, just the reservation.  The caller must hold ILOCK_EXCL on
+ * the inode.  If @retry is not a NULL pointer, the caller must ensure that
+ * *retry is set to 0 before the first time this function is called.
+ *
+ * If the quota reservation fails because we hit a quota limit (and retry is
+ * not a NULL pointer, and *retry is zero), this function will set *retry to
+ * nonzero and return zero.
  */
 int
 xfs_trans_reserve_quota_nblks(
@@ -782,7 +838,8 @@ xfs_trans_reserve_quota_nblks(
 	struct xfs_inode	*ip,
 	int64_t			dblocks,
 	int64_t			rblocks,
-	bool			force)
+	bool			force,
+	unsigned int		*retry)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	unsigned int		qflags = 0;
@@ -801,14 +858,14 @@ xfs_trans_reserve_quota_nblks(
 	error = xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
 			ip->i_gdquot, ip->i_pdquot, dblocks, 0,
 			XFS_QMOPT_RES_REGBLKS | qflags);
-	if (error)
+	if (!reservation_success(XFS_QMOPT_RES_REGBLKS, retry, &error))
 		return error;
 
 	/* Do the same but for realtime blocks. */
 	error = xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
 			ip->i_gdquot, ip->i_pdquot, rblocks, 0,
 			XFS_QMOPT_RES_RTBLKS | qflags);
-	if (error) {
+	if (!reservation_success(XFS_QMOPT_RES_RTBLKS, retry, &error)) {
 		xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
 				ip->i_gdquot, ip->i_pdquot, -dblocks, 0,
 				XFS_QMOPT_RES_REGBLKS);

