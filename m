Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94935C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E99A2072C
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313066AbhAZXCl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:02:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729019AbhAZEyy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Jan 2021 23:54:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCAE322B3F;
        Tue, 26 Jan 2021 04:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611636839;
        bh=yv8XbBGsJmyYIJfsnS1DjUXe+8ztQRg2Sz8qJ0fH7vg=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=t8n3N7RFgKWWBDePxKa/+jBD9+dgIr3yfkLulN+wC5JsaqZypLrU9gR1l17vUeALp
         bx+jF+u5ALZM2QXOmraPmnQzk56AsLCfRUqfbAIU35QdhjROUBMhcLwCJzGQIFjahf
         LtI7DBbmiWp++0MUAAzpmES1+mOkCi+OJr1sEMUGtW70wlNjzENSfO55pMf6+8PgRK
         v8QM4kX/xHj8LqgPEHXDSv9UjxA2aBn5t9hQeobkfAVLGBxewrb+TqpnclxPM/Iqne
         /QlHeGhY1ZSFwdr6bk989L+az1VaMCFMdgmZ27n6VfNNMdlsJQR+0cLDpIRDaBfHGa
         DarMSg0hHszqg==
Date:   Mon, 25 Jan 2021 20:53:59 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4.1 06/11] xfs: flush eof/cowblocks if we can't reserve
 quota for file blocks
Message-ID: <20210126045359.GN7698@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142795294.2171939.2305516748220731694.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142795294.2171939.2305516748220731694.stgit@magnolia>
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
v4.1: move all the retry code to a helper so that we don't have the
unconventional return conventions
---
 fs/xfs/libxfs/xfs_attr.c |    9 +++++++-
 fs/xfs/libxfs/xfs_bmap.c |    8 ++++++-
 fs/xfs/xfs_bmap_util.c   |   19 +++++++++++++---
 fs/xfs/xfs_iomap.c       |   21 +++++++++++++++---
 fs/xfs/xfs_quota.h       |   22 ++++++++++++++----
 fs/xfs/xfs_reflink.c     |   16 ++++++++++++-
 fs/xfs/xfs_trans_dquot.c |   55 ++++++++++++++++++++++++++++++++++++----------
 7 files changed, 122 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index be51e7068dcd..57054460d07b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -395,6 +395,7 @@ xfs_attr_set(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
 	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
+	bool			quota_retry = false;
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
@@ -458,6 +459,7 @@ xfs_attr_set(
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
+retry:
 	error = xfs_trans_alloc(mp, &tres, total, 0,
 			rsvd ? XFS_TRANS_RESERVE : 0, &args->trans);
 	if (error)
@@ -479,9 +481,14 @@ xfs_attr_set(
 		if (rsvd)
 			quota_flags |= XFS_QMOPT_FORCE_RES;
 		error = xfs_trans_reserve_quota_nblks(args->trans, dp,
-				args->total, 0, quota_flags);
+				args->total, 0, quota_flags, &quota_retry);
 		if (error)
 			goto out_trans_cancel;
+		if (quota_retry) {
+			xfs_trans_cancel_qretry(args->trans, dp);
+			args->trans = NULL;
+			goto retry;
+		}
 
 		error = xfs_has_attr(args);
 		if (error == -EEXIST && (args->attr_flags & XATTR_CREATE))
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 908b7d49da60..65b53ba4d0b4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1070,6 +1070,7 @@ xfs_bmap_add_attrfork(
 	int			blks;		/* space reservation */
 	int			version = 1;	/* superblock attr version */
 	int			logflags;	/* logging flags */
+	bool			quota_retry = false;
 	int			error;		/* error return value */
 
 	ASSERT(XFS_IFORK_Q(ip) == 0);
@@ -1079,6 +1080,7 @@ xfs_bmap_add_attrfork(
 
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
 
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_addafork, blks, 0,
 			rsvd ? XFS_TRANS_RESERVE : 0, &tp);
 	if (error)
@@ -1087,9 +1089,13 @@ xfs_bmap_add_attrfork(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
 			XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
-			XFS_QMOPT_RES_REGBLKS);
+			XFS_QMOPT_RES_REGBLKS, &quota_retry);
 	if (error)
 		goto trans_cancel;
+	if (quota_retry) {
+		xfs_trans_cancel_qretry(tp, ip);
+		goto retry;
+	}
 	if (XFS_IFORK_Q(ip))
 		goto trans_cancel;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 792809debaaa..9cfb097e632f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -761,6 +761,7 @@ xfs_alloc_file_space(
 	 */
 	while (allocatesize_fsb && !error) {
 		xfs_fileoff_t	s, e;
+		bool		quota_retry = false;
 
 		/*
 		 * Determine space reservations for data/realtime.
@@ -803,6 +804,7 @@ xfs_alloc_file_space(
 		/*
 		 * Allocate and setup the transaction.
 		 */
+retry:
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
 				resrtextents, 0, &tp);
 
@@ -817,10 +819,14 @@ xfs_alloc_file_space(
 			break;
 		}
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks,
-						      0, quota_flag);
+		error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0,
+				quota_flag, &quota_retry);
 		if (error)
 			goto error1;
+		if (quota_retry) {
+			xfs_trans_cancel_qretry(tp, ip);
+			goto retry;
+		}
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
@@ -858,7 +864,6 @@ xfs_alloc_file_space(
 
 error0:	/* unlock inode, unreserve quota blocks, cancel trans */
 	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
-
 error1:	/* Just cancel transaction */
 	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -875,8 +880,10 @@ xfs_unmap_extent(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+	bool			quota_retry = false;
 	int			error;
 
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	if (error) {
 		ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
@@ -885,9 +892,13 @@ xfs_unmap_extent(
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
-			XFS_QMOPT_RES_REGBLKS);
+			XFS_QMOPT_RES_REGBLKS, &quota_retry);
 	if (error)
 		goto out_trans_cancel;
+	if (quota_retry) {
+		xfs_trans_cancel_qretry(tp, ip);
+		goto retry;
+	}
 
 	xfs_trans_ijoin(tp, ip, 0);
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 514e6ae010e0..bb972ad09ccd 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -27,7 +27,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
-
+#include "xfs_icache.h"
 
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
@@ -197,6 +197,7 @@ xfs_iomap_write_direct(
 	int			quota_flag;
 	uint			qblocks, resblks;
 	unsigned int		resrtextents = 0;
+	bool			quota_retry = false;
 	int			error;
 	int			bmapi_flags = XFS_BMAPI_PREALLOC;
 	uint			tflags = 0;
@@ -239,6 +240,7 @@ xfs_iomap_write_direct(
 			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
 		}
 	}
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, resrtextents,
 			tflags, &tp);
 	if (error)
@@ -246,9 +248,14 @@ xfs_iomap_write_direct(
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
+	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0, quota_flag,
+			&quota_retry);
 	if (error)
 		goto out_trans_cancel;
+	if (quota_retry) {
+		xfs_trans_cancel_qretry(tp, ip);
+		goto retry;
+	}
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
@@ -544,6 +551,8 @@ xfs_iomap_write_unwritten(
 		return error;
 
 	do {
+		bool	quota_retry = false;
+
 		/*
 		 * Set up a transaction to convert the range of extents
 		 * from unwritten to real. Do allocations in a loop until
@@ -553,6 +562,7 @@ xfs_iomap_write_unwritten(
 		 * here as we might be asked to write out the same inode that we
 		 * complete here and might deadlock on the iolock.
 		 */
+retry:
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
 				XFS_TRANS_RESERVE, &tp);
 		if (error)
@@ -562,9 +572,14 @@ xfs_iomap_write_unwritten(
 		xfs_trans_ijoin(tp, ip, 0);
 
 		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
-				XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES);
+				XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES,
+				&quota_retry);
 		if (error)
 			goto error_on_bmapi_transaction;
+		if (quota_retry) {
+			xfs_trans_cancel_qretry(tp, ip);
+			goto retry;
+		}
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_WRITE_UNWRITTEN_CNT);
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 4cafc1c78879..321c093459a1 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -81,14 +81,16 @@ extern void xfs_trans_mod_dquot_byino(struct xfs_trans *, struct xfs_inode *,
 		uint, int64_t);
 extern void xfs_trans_apply_dquot_deltas(struct xfs_trans *);
 extern void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *);
-extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
-		struct xfs_inode *, int64_t, long, uint);
+int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
+		int64_t nblocks, long ninos, unsigned int flags,
+		bool *retry);
 extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_mount *, struct xfs_dquot *,
 		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
 int xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_inode *dp,
 		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
 		struct xfs_dquot *pdqp, int64_t nblks);
+int xfs_trans_cancel_qretry(struct xfs_trans *tp, struct xfs_inode *ip);
 
 extern int xfs_qm_vop_dqalloc(struct xfs_inode *, kuid_t, kgid_t,
 		prid_t, uint, struct xfs_dquot **, struct xfs_dquot **,
@@ -115,7 +117,8 @@ static inline int
 xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t nblks, bool isrt)
 {
 	return xfs_trans_reserve_quota_nblks(NULL, ip, nblks, 0,
-			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
+			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS,
+			NULL);
 }
 #else
 static inline int
@@ -134,7 +137,8 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
 #define xfs_trans_apply_dquot_deltas(tp)
 #define xfs_trans_unreserve_and_mod_dquots(tp)
 static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
-		struct xfs_inode *ip, int64_t nblks, long ninos, uint flags)
+		struct xfs_inode *ip, int64_t nblks, long ninos,
+		unsigned int flags, bool *retry)
 {
 	return 0;
 }
@@ -160,6 +164,13 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_inode *dp,
 	return 0;
 }
 
+static inline int
+xfs_trans_cancel_qretry(struct xfs_trans *tp, struct xfs_inode *ip)
+{
+	ASSERT(0);
+	return 0;
+}
+
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
@@ -179,7 +190,8 @@ static inline int
 xfs_trans_unreserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
 		int64_t nblks, long ninos, unsigned int flags)
 {
-	return xfs_trans_reserve_quota_nblks(tp, ip, -nblks, -ninos, flags);
+	return xfs_trans_reserve_quota_nblks(tp, ip, -nblks, -ninos, flags,
+			NULL);
 }
 
 static inline int
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0da1a603b7d8..c7712e7ad6ca 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -355,6 +355,7 @@ xfs_reflink_allocate_cow(
 	xfs_filblks_t		count_fsb = imap->br_blockcount;
 	struct xfs_trans	*tp;
 	int			nimaps, error = 0;
+	bool			quota_retry = false;
 	bool			found;
 	xfs_filblks_t		resaligned;
 	xfs_extlen_t		resblks = 0;
@@ -376,6 +377,7 @@ xfs_reflink_allocate_cow(
 	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
 
 	xfs_iunlock(ip, *lockmode);
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	*lockmode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, *lockmode);
@@ -399,9 +401,13 @@ xfs_reflink_allocate_cow(
 	}
 
 	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
-			XFS_QMOPT_RES_REGBLKS);
+			XFS_QMOPT_RES_REGBLKS, &quota_retry);
 	if (error)
 		goto out_trans_cancel;
+	if (quota_retry) {
+		xfs_trans_cancel_qretry(tp, ip);
+		goto retry;
+	}
 
 	xfs_trans_ijoin(tp, ip, 0);
 
@@ -1006,10 +1012,12 @@ xfs_reflink_remap_extent(
 	unsigned int		resblks;
 	bool			smap_real;
 	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
+	bool			quota_retry = false;
 	int			iext_delta = 0;
 	int			nimaps;
 	int			error;
 
+retry:
 	/* Start a rolling transaction to switch the mappings */
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
@@ -1095,9 +1103,13 @@ xfs_reflink_remap_extent(
 		qres += dmap->br_blockcount;
 	if (qres > 0) {
 		error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
-				XFS_QMOPT_RES_REGBLKS);
+				XFS_QMOPT_RES_REGBLKS, &quota_retry);
 		if (error)
 			goto out_cancel;
+		if (quota_retry) {
+			xfs_trans_cancel_qretry(tp, ip);
+			goto retry;
+		}
 	}
 
 	if (smap_real)
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 3315498a6fa1..4b679b9f2da7 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -16,6 +16,7 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
 
@@ -770,11 +771,15 @@ xfs_trans_reserve_quota_bydquots(
 	return error;
 }
 
-
 /*
- * Lock the dquot and change the reservation if we can.
- * This doesn't change the actual usage, just the reservation.
- * The inode sent in is locked.
+ * Lock the dquot and change the reservation if we can.  This doesn't change
+ * the actual usage, just the reservation.  The caller must hold ILOCK_EXCL on
+ * the inode.  If @retry is not a NULL pointer, the caller must ensure that
+ * *retry is set to false before the first time this function is called.
+ *
+ * If the quota reservation fails because we hit a quota limit (and retry is
+ * not a NULL pointer, and *retry is false), this function will set *retry to
+ * true and return zero.
  */
 int
 xfs_trans_reserve_quota_nblks(
@@ -782,9 +787,11 @@ xfs_trans_reserve_quota_nblks(
 	struct xfs_inode	*ip,
 	int64_t			nblks,
 	long			ninos,
-	uint			flags)
+	unsigned int		flags,
+	bool			*retry)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
@@ -795,13 +802,37 @@ xfs_trans_reserve_quota_nblks(
 	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_RTBLKS ||
 	       (flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_BLKS);
 
-	/*
-	 * Reserve nblks against these dquots, with trans as the mediator.
-	 */
-	return xfs_trans_reserve_quota_bydquots(tp, mp,
-						ip->i_udquot, ip->i_gdquot,
-						ip->i_pdquot,
-						nblks, ninos, flags);
+	/* Reserve nblks against these dquots, with trans as the mediator. */
+	error = xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
+			ip->i_gdquot, ip->i_pdquot, nblks, ninos, flags);
+	if (retry == NULL)
+		return error;
+	/* We only allow one retry for EDQUOT/ENOSPC. */
+	if (*retry || (error != -EDQUOT && error != -ENOSPC)) {
+		*retry = false;
+		return error;
+	}
+
+	*retry = true;
+	return 0;
+}
+
+/*
+ * Cancel a transaction and try to clear some space so that we can reserve some
+ * quota.  The caller must hold the ILOCK; when this function returns, the
+ * transaction will be cancelled and the ILOCK will have been released.
+ */
+int
+xfs_trans_cancel_qretry(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	return xfs_blockgc_free_quota(ip, 0);
 }
 
 /* Change the quota reservations for an inode creation activity. */
