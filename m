Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6064C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D4F922EBE
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbhAWSxs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:53:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbhAWSx2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:53:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4946822D2B;
        Sat, 23 Jan 2021 18:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427951;
        bh=OgDyN8OaGFlJ/OXdm36/gXOI3XN0MYZxrZvevNJZ+L0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CfDAy0lZu202yRUO80P3Qp43eMxRSA4r60EnhqnEBjcmdkx1dO3Zzdmlfbe8gIh5C
         NSCQO8Waquwa0OPg6joZpxguFoSsFMZetP0mnBPcaQLYb4JsxZ9YJlPIOtYSuAnUbc
         nkFcE3gPTbPKgZ95UtD4eoA+GeT+Jd1NKT2T1VrmTD+VyYoPEh/24LgGmtrdrjwqAP
         D1SC/Y3zz+x+3bH2FUBTWAX32ZPA/1YuOADewPpWpJpdgkAOrLB7PCu0DWH3MRSt0U
         GfRNO7yNI7ZmehNGWQKFjIu9zu7QXtBz+QBVeqIXWetdJ+C3HPc1P9Ooh6avMLgDg/
         icrxOpeWZpw2A==
Subject: [PATCH 06/11] xfs: flush eof/cowblocks if we can't reserve quota for
 file blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:52:33 -0800
Message-ID: <161142795294.2171939.2305516748220731694.stgit@magnolia>
In-Reply-To: <161142791950.2171939.3320927557987463636.stgit@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_attr.c |    8 +++++-
 fs/xfs/libxfs/xfs_bmap.c |    8 +++++-
 fs/xfs/xfs_bmap_util.c   |   17 ++++++++++----
 fs/xfs/xfs_iomap.c       |   19 ++++++++++++---
 fs/xfs/xfs_quota.h       |   20 ++++++++++------
 fs/xfs/xfs_reflink.c     |   16 ++++++++++---
 fs/xfs/xfs_trans_dquot.c |   57 ++++++++++++++++++++++++++++++++++++----------
 7 files changed, 108 insertions(+), 37 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index be51e7068dcd..af835ea0ca80 100644
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
@@ -478,10 +480,12 @@ xfs_attr_set(
 
 		if (rsvd)
 			quota_flags |= XFS_QMOPT_FORCE_RES;
-		error = xfs_trans_reserve_quota_nblks(args->trans, dp,
-				args->total, 0, quota_flags);
+		error = xfs_trans_reserve_quota_nblks(&args->trans, dp,
+				args->total, 0, quota_flags, &quota_retry);
 		if (error)
 			goto out_trans_cancel;
+		if (quota_retry)
+			goto retry;
 
 		error = xfs_has_attr(args);
 		if (error == -EEXIST && (args->attr_flags & XATTR_CREATE))
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 908b7d49da60..0247763dfac3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1070,6 +1070,7 @@ xfs_bmap_add_attrfork(
 	int			blks;		/* space reservation */
 	int			version = 1;	/* superblock attr version */
 	int			logflags;	/* logging flags */
+	bool			quota_retry = false;
 	int			error;		/* error return value */
 
 	ASSERT(XFS_IFORK_Q(ip) == 0);
@@ -1079,17 +1080,20 @@ xfs_bmap_add_attrfork(
 
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
 
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_addafork, blks, 0,
 			rsvd ? XFS_TRANS_RESERVE : 0, &tp);
 	if (error)
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
+	error = xfs_trans_reserve_quota_nblks(&tp, ip, blks, 0, rsvd ?
 			XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
-			XFS_QMOPT_RES_REGBLKS);
+			XFS_QMOPT_RES_REGBLKS, &quota_retry);
 	if (error)
 		goto trans_cancel;
+	if (quota_retry)
+		goto retry;
 	if (XFS_IFORK_Q(ip))
 		goto trans_cancel;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 792809debaaa..6eaf92bf8fc6 100644
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
 
@@ -817,10 +819,12 @@ xfs_alloc_file_space(
 			break;
 		}
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks,
-						      0, quota_flag);
+		error = xfs_trans_reserve_quota_nblks(&tp, ip, qblocks, 0,
+				quota_flag, &quota_retry);
 		if (error)
 			goto error1;
+		if (quota_retry)
+			goto retry;
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
@@ -858,7 +862,6 @@ xfs_alloc_file_space(
 
 error0:	/* unlock inode, unreserve quota blocks, cancel trans */
 	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
-
 error1:	/* Just cancel transaction */
 	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -875,8 +878,10 @@ xfs_unmap_extent(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+	bool			quota_retry = false;
 	int			error;
 
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	if (error) {
 		ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
@@ -884,10 +889,12 @@ xfs_unmap_extent(
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
-			XFS_QMOPT_RES_REGBLKS);
+	error = xfs_trans_reserve_quota_nblks(&tp, ip, resblks, 0,
+			XFS_QMOPT_RES_REGBLKS, &quota_retry);
 	if (error)
 		goto out_trans_cancel;
+	if (quota_retry)
+		goto retry;
 
 	xfs_trans_ijoin(tp, ip, 0);
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 514e6ae010e0..294d819c30c6 100644
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
@@ -246,9 +248,12 @@ xfs_iomap_write_direct(
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
+	error = xfs_trans_reserve_quota_nblks(&tp, ip, qblocks, 0, quota_flag,
+			&quota_retry);
 	if (error)
 		goto out_trans_cancel;
+	if (quota_retry)
+		goto retry;
 
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
@@ -544,6 +549,8 @@ xfs_iomap_write_unwritten(
 		return error;
 
 	do {
+		bool	quota_retry = false;
+
 		/*
 		 * Set up a transaction to convert the range of extents
 		 * from unwritten to real. Do allocations in a loop until
@@ -553,6 +560,7 @@ xfs_iomap_write_unwritten(
 		 * here as we might be asked to write out the same inode that we
 		 * complete here and might deadlock on the iolock.
 		 */
+retry:
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
 				XFS_TRANS_RESERVE, &tp);
 		if (error)
@@ -561,10 +569,13 @@ xfs_iomap_write_unwritten(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, 0);
 
-		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
-				XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES);
+		error = xfs_trans_reserve_quota_nblks(&tp, ip, resblks, 0,
+				XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES,
+				&quota_retry);
 		if (error)
 			goto error_on_bmapi_transaction;
+		if (quota_retry)
+			goto retry;
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_WRITE_UNWRITTEN_CNT);
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 16a2e7adf4da..1c083b5267d9 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -81,8 +81,9 @@ extern void xfs_trans_mod_dquot_byino(struct xfs_trans *, struct xfs_inode *,
 		uint, int64_t);
 extern void xfs_trans_apply_dquot_deltas(struct xfs_trans *);
 extern void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *);
-extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
-		struct xfs_inode *, int64_t, long, uint);
+int xfs_trans_reserve_quota_nblks(struct xfs_trans **tpp, struct xfs_inode *ip,
+		int64_t nblocks, long ninos, unsigned int flags,
+		bool *retry);
 extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_mount *, struct xfs_dquot *,
 		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
@@ -114,8 +115,11 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 static inline int
 xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t nblks, bool isrt)
 {
-	return xfs_trans_reserve_quota_nblks(NULL, ip, nblks, 0,
-			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
+	struct xfs_trans	*tp = NULL;
+
+	return xfs_trans_reserve_quota_nblks(&tp, ip, nblks, 0,
+			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS,
+			NULL);
 }
 #else
 static inline int
@@ -133,8 +137,9 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
 #define xfs_trans_mod_dquot_byino(tp, ip, fields, delta)
 #define xfs_trans_apply_dquot_deltas(tp)
 #define xfs_trans_unreserve_and_mod_dquots(tp)
-static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
-		struct xfs_inode *ip, int64_t nblks, long ninos, uint flags)
+static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans **tpp,
+		struct xfs_inode *ip, int64_t nblks, long ninos,
+		unsigned int flags, bool *retry)
 {
 	return 0;
 }
@@ -179,7 +184,8 @@ static inline int
 xfs_trans_unreserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
 		int64_t nblks, long ninos, unsigned int flags)
 {
-	return xfs_trans_reserve_quota_nblks(tp, ip, -nblks, -ninos, flags);
+	return xfs_trans_reserve_quota_nblks(&tp, ip, -nblks, -ninos, flags,
+			NULL);
 }
 
 static inline int
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0da1a603b7d8..0afd74f35ab7 100644
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
@@ -398,10 +400,12 @@ xfs_reflink_allocate_cow(
 		goto convert;
 	}
 
-	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
-			XFS_QMOPT_RES_REGBLKS);
+	error = xfs_trans_reserve_quota_nblks(&tp, ip, resblks, 0,
+			XFS_QMOPT_RES_REGBLKS, &quota_retry);
 	if (error)
 		goto out_trans_cancel;
+	if (quota_retry)
+		goto retry;
 
 	xfs_trans_ijoin(tp, ip, 0);
 
@@ -1006,10 +1010,12 @@ xfs_reflink_remap_extent(
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
@@ -1094,10 +1100,12 @@ xfs_reflink_remap_extent(
 	if (!smap_real && dmap_written)
 		qres += dmap->br_blockcount;
 	if (qres > 0) {
-		error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
-				XFS_QMOPT_RES_REGBLKS);
+		error = xfs_trans_reserve_quota_nblks(&tp, ip, qres, 0,
+				XFS_QMOPT_RES_REGBLKS, &quota_retry);
 		if (error)
 			goto out_cancel;
+		if (quota_retry)
+			goto retry;
 	}
 
 	if (smap_real)
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 3315498a6fa1..adc7331ff182 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -16,6 +16,7 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
 
@@ -770,21 +771,38 @@ xfs_trans_reserve_quota_bydquots(
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
+ * not a NULL pointer, and *retry is false), this function will try to invoke
+ * the speculative preallocation gc scanner to reduce quota usage.  In order to
+ * do that, we cancel the transaction, NULL out tpp, drop the ILOCK, and set
+ * *retry to true.
+ *
+ * This function ends one of two ways:
+ *
+ *  1) To signal the caller to try again, *retry is set to true; *tpp is
+ *     cancelled and set to NULL; the inode is unlocked; and the return value
+ *     is zero.
+ *
+ *  2) Otherwise, *tpp is still set; the inode is still locked; and the return
+ *     value is zero or the usual negative error code.
  */
 int
 xfs_trans_reserve_quota_nblks(
-	struct xfs_trans	*tp,
+	struct xfs_trans	**tpp,
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
@@ -795,13 +813,26 @@ xfs_trans_reserve_quota_nblks(
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
+	error = xfs_trans_reserve_quota_bydquots(*tpp, mp, ip->i_udquot,
+			ip->i_gdquot, ip->i_pdquot, nblks, ninos, flags);
+	if (retry == NULL)
+		return error;
+	/* We only allow one retry for EDQUOT/ENOSPC. */
+	if (*retry || (error != -EDQUOT && error != -ENOSPC)) {
+		*retry = false;
+		return error;
+	}
+
+	/* Release resources, prepare for scan. */
+	xfs_trans_cancel(*tpp);
+	*tpp = NULL;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	/* Try to free some quota for this file's dquots. */
+	*retry = true;
+	xfs_blockgc_free_quota(ip, 0);
+	return 0;
 }
 
 /* Change the quota reservations for an inode creation activity. */

