Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F17C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E31CD64DD1
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhA1GDp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:03:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229804AbhA1GDk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:03:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C95EC64DD8;
        Thu, 28 Jan 2021 06:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813778;
        bh=FiQBKBbRlJioc+/SUbKeUYhQMTMkFu1pi8WunyZNsEI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bD2cFCIcSjPs6t56+lEkChWMZFzhlxON1Ul2CsTr/Yqu76QKS7RIREKDUp5xfSBc6
         PjLp0XgyQ6VPjmcshVXY39xwEavwU9e63Ekkpb6Py90WjWD5hlmXAIlPNXEU66pV7v
         hoZhxJGuJ87KJBITiJV6pn3YlBCEhXjNM3UPhJOxq2YbaB2Leyq+ZK2qfrZf3hisZZ
         owcFkmPhjEV4PkLeBXytoYAMGVZbA+OcetnpAcfNlunLrR2bRQ0k9FEtDQXvly6Sgt
         q0uS0c30Z3rvbuVhjE6rNBYsJw4Rh5Aol6FyKiEthkEIGZZlFdLYxyCJZvs1i3iVlB
         cLob7pMHkhK7Q==
Subject: [PATCH 06/11] xfs: flush eof/cowblocks if we can't reserve quota for
 file blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:02:55 -0800
Message-ID: <161181377500.1525026.4807452419379444724.stgit@magnolia>
In-Reply-To: <161181374062.1525026.14717838769921652940.stgit@magnolia>
References: <161181374062.1525026.14717838769921652940.stgit@magnolia>
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
 fs/xfs/xfs_quota.h       |   15 ++++++--
 fs/xfs/xfs_reflink.c     |    7 +++-
 fs/xfs/xfs_trans.c       |    9 ++++-
 fs/xfs/xfs_trans_dquot.c |   87 +++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 107 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index c3a5b48f5860..dcdc3cd0361a 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -82,7 +82,9 @@ extern void xfs_trans_mod_dquot_byino(struct xfs_trans *, struct xfs_inode *,
 extern void xfs_trans_apply_dquot_deltas(struct xfs_trans *);
 extern void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *);
 int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
-		int64_t dblocks, int64_t rblocks, bool force);
+		int64_t dblocks, int64_t rblocks, bool force,
+		unsigned int *retry);
+void xfs_trans_cancel_qretry_nblks(struct xfs_trans *tp, struct xfs_inode *ip);
 extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_mount *, struct xfs_dquot *,
 		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
@@ -114,7 +116,8 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 static inline int
 xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t dblocks)
 {
-	return xfs_trans_reserve_quota_nblks(NULL, ip, dblocks, 0, false);
+	return xfs_trans_reserve_quota_nblks(NULL, ip, dblocks, 0, false,
+			NULL);
 }
 #else
 static inline int
@@ -134,7 +137,7 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
 #define xfs_trans_unreserve_and_mod_dquots(tp)
 static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
 		struct xfs_inode *ip, int64_t dblocks, int64_t rblocks,
-		bool force)
+		bool force, unsigned int *retry)
 {
 	return 0;
 }
@@ -159,6 +162,12 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 	return 0;
 }
 
+static inline void
+xfs_trans_cancel_qretry_nblks(struct xfs_trans *tp, struct xfs_inode *ip)
+{
+	ASSERT(0);
+}
+
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index c6296fd1512f..068e70d7a3bc 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1093,10 +1093,15 @@ xfs_reflink_remap_extent(
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
index bfb8b2a1594f..3d1f745b721a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1046,8 +1046,10 @@ xfs_trans_alloc_inode(
 {
 	struct xfs_trans	*tp;
 	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		qretry = 0;
 	int			error;
 
+retry:
 	error = xfs_trans_alloc(mp, resv, dblocks,
 			rblocks / mp->m_sb.sb_rextsize,
 			force ? XFS_TRANS_RESERVE : 0, &tp);
@@ -1064,9 +1066,14 @@ xfs_trans_alloc_inode(
 		goto out_cancel;
 	}
 
-	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
+	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force,
+			&qretry);
 	if (error)
 		goto out_cancel;
+	if (qretry) {
+		xfs_trans_cancel_qretry_nblks(tp, ip);
+		goto retry;
+	}
 
 	*tpp = tp;
 	return 0;
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 73ef5994d09d..229e2a20889f 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -16,6 +16,7 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
 
@@ -770,11 +771,67 @@ xfs_trans_reserve_quota_bydquots(
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
+	if (error)
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
@@ -782,7 +839,8 @@ xfs_trans_reserve_quota_nblks(
 	struct xfs_inode	*ip,
 	int64_t			dblocks,
 	int64_t			rblocks,
-	bool			force)
+	bool			force,
+	unsigned int		*retry)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	unsigned int		qflags = 0;
@@ -801,14 +859,14 @@ xfs_trans_reserve_quota_nblks(
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
@@ -818,6 +876,23 @@ xfs_trans_reserve_quota_nblks(
 	return 0;
 }
 
+/*
+ * Cancel a transaction and try to clear some space so that we can reserve some
+ * quota.  The caller must hold the ILOCK; when this function returns, the
+ * transaction will be cancelled and the ILOCK will have been released.
+ */
+void
+xfs_trans_cancel_qretry_nblks(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_blockgc_free_quota(ip, 0);
+}
+
 /* Change the quota reservations for an inode creation activity. */
 int
 xfs_trans_reserve_quota_icreate(

