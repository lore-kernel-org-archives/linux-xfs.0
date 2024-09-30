Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2B6196C86
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 16:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727714565; cv=none; b=ep+diWJS0x+OSrzjlwrQec/xI9GMxDHx8tHcDYl0w3l+nzAg1B3rFfCfYW/Cd8zqOPsn75lhoFoYJS93JpkZGa+SuCGlJ2kC0Apa+EIOcymTukitObpZ9W0h3jm1YBRueONnQ6HG8hZM3pw4m3r/l/DJApchHGvB+/MbwnMeBZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727714565; c=relaxed/simple;
	bh=JRUD9U3wuFjNwZEtSaEtZ+FpoVECqVfWWDDd7vR4zfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mba7EhdIJ1Snxz8Js4JoKm5SMERQPnyphYIC/OU2YR1rFI+XgGrAw5N37mS425Q915iGEZOMRjcai7xgdmsi7px2QEltLqi3pJXQ1poyWeRRwT5WVb2XrNtwmn1mc++NkBAZI+4Hvq21sro8JDXQYyNEzd3j4Csklpz9PXZVzPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cti+5wab; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cti+5wab"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+RVOHMpOS6TCmWb6iGFWCN/DMBxgN1D3NBjaMrA0/Tg=; b=cti+5wabwh44K9EhsCly7idI3e
	ppshi6gG55ad+R7fiKFb8CiCJEXnaFd4j5VeQ9cy7qPczPH26TVcBwtYPexTI1z5JXK8Vy4889w0p
	V9jktxUchw/tFEKF8ztsgGSKTw2fJrbtSLAC2Y3GWCLivth+RVbZS2N/fTfxcER0ywd1LxlzumdFM
	X3KkporTNMh23KC550wz4Kv8IKCIkxbFW1kALbi0y+yOa3DzHx+HOxkaQ/Gg5+Egzb7eWJABHVCY2
	rZVCu7AMIyV2AeSLsdBy/Nav0DElbWD7GASCbCIi6ksSkmanNo2nU6qzM9HG2PjdN0PRJiKbQf7so
	5AwMOcFA==;
Received: from 2a02-8389-2341-5b80-2b91-e1b6-c99c-08ea.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2b91:e1b6:c99c:8ea] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1svJTu-00000000Ggl-2io8;
	Mon, 30 Sep 2024 16:42:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 7/7] xfs: split xfs_trans_mod_sb
Date: Mon, 30 Sep 2024 18:41:48 +0200
Message-ID: <20240930164211.2357358-8-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240930164211.2357358-1-hch@lst.de>
References: <20240930164211.2357358-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split xfs_trans_mod_sb into separate helpers for the different counts.
While the icount and ifree counters get their own helpers, the handling
for fdblocks and frextents merges the delalloc and non-delalloc cases
to keep the related code together.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag_resv.c  |  18 +++--
 fs/xfs/libxfs/xfs_ialloc.c   |  14 ++--
 fs/xfs/libxfs/xfs_rtbitmap.c |   3 +-
 fs/xfs/libxfs/xfs_shared.h   |  10 ---
 fs/xfs/xfs_fsops.c           |   2 +-
 fs/xfs/xfs_rtalloc.c         |   6 +-
 fs/xfs/xfs_trans.c           | 130 +++++++++++++++--------------------
 fs/xfs/xfs_trans.h           |   7 +-
 fs/xfs/xfs_trans_dquot.c     |   2 +-
 9 files changed, 82 insertions(+), 110 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 216423df939e5c..bb518d6a2dcecd 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -341,7 +341,6 @@ xfs_ag_resv_alloc_extent(
 {
 	struct xfs_ag_resv		*resv;
 	xfs_extlen_t			len;
-	uint				field;
 
 	trace_xfs_ag_resv_alloc_extent(pag, type, args->len);
 
@@ -356,9 +355,8 @@ xfs_ag_resv_alloc_extent(
 		ASSERT(0);
 		fallthrough;
 	case XFS_AG_RESV_NONE:
-		field = args->wasdel ? XFS_TRANS_SB_RES_FDBLOCKS :
-				       XFS_TRANS_SB_FDBLOCKS;
-		xfs_trans_mod_sb(args->tp, field, -(int64_t)args->len);
+		xfs_trans_mod_fdblocks(args->tp, -(int64_t)args->len,
+				args->wasdel);
 		return;
 	}
 
@@ -367,11 +365,11 @@ xfs_ag_resv_alloc_extent(
 	if (type == XFS_AG_RESV_RMAPBT)
 		return;
 	/* Allocations of reserved blocks only need on-disk sb updates... */
-	xfs_trans_mod_sb(args->tp, XFS_TRANS_SB_RES_FDBLOCKS, -(int64_t)len);
+	xfs_trans_mod_fdblocks(args->tp, -(int64_t)len, true);
 	/* ...but non-reserved blocks need in-core and on-disk updates. */
 	if (args->len > len)
-		xfs_trans_mod_sb(args->tp, XFS_TRANS_SB_FDBLOCKS,
-				-((int64_t)args->len - len));
+		xfs_trans_mod_fdblocks(args->tp, -((int64_t)args->len - len),
+				false);
 }
 
 /* Free a block to the reservation. */
@@ -398,7 +396,7 @@ xfs_ag_resv_free_extent(
 		ASSERT(0);
 		fallthrough;
 	case XFS_AG_RESV_NONE:
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (int64_t)len);
+		xfs_trans_mod_fdblocks(tp, (int64_t)len, false);
 		fallthrough;
 	case XFS_AG_RESV_IGNORE:
 		return;
@@ -409,8 +407,8 @@ xfs_ag_resv_free_extent(
 	if (type == XFS_AG_RESV_RMAPBT)
 		return;
 	/* Freeing into the reserved pool only requires on-disk update... */
-	xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FDBLOCKS, len);
+	xfs_trans_mod_fdblocks(tp, len, true);
 	/* ...but freeing beyond that requires in-core and on-disk update. */
 	if (len > leftover)
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, len - leftover);
+		xfs_trans_mod_fdblocks(tp, len - leftover, false);
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 271855227514cb..ad28823debb6f1 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -970,8 +970,8 @@ xfs_ialloc_ag_alloc(
 	/*
 	 * Modify/log superblock values for inode count and inode free count.
 	 */
-	xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, (long)newlen);
-	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, (long)newlen);
+	xfs_trans_mod_icount(tp, (long)newlen);
+	xfs_trans_mod_ifree(tp, (long)newlen);
 	return 0;
 }
 
@@ -1357,7 +1357,7 @@ xfs_dialloc_ag_inobt(
 		goto error0;
 
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
-	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
+	xfs_trans_mod_ifree(tp, -1);
 	*inop = ino;
 	return 0;
 error1:
@@ -1660,7 +1660,7 @@ xfs_dialloc_ag(
 	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
 	pag->pagi_freecount--;
 
-	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
+	xfs_trans_mod_ifree(tp, -1);
 
 	error = xfs_check_agi_freecount(icur);
 	if (error)
@@ -2139,8 +2139,8 @@ xfs_difree_inobt(
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
 		pag->pagi_freecount -= ilen - 1;
 		pag->pagi_count -= ilen;
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, -ilen);
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));
+		xfs_trans_mod_icount(tp, -ilen);
+		xfs_trans_mod_ifree(tp, -(ilen - 1));
 
 		if ((error = xfs_btree_delete(cur, &i))) {
 			xfs_warn(mp, "%s: xfs_btree_delete returned error %d.",
@@ -2167,7 +2167,7 @@ xfs_difree_inobt(
 		be32_add_cpu(&agi->agi_freecount, 1);
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
 		pag->pagi_freecount++;
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, 1);
+		xfs_trans_mod_ifree(tp, 1);
 	}
 
 	error = xfs_check_agi_freecount(cur);
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 27a4472402bacd..d0c693a69e0001 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -989,7 +989,8 @@ xfs_rtfree_extent(
 	/*
 	 * Mark more blocks free in the superblock.
 	 */
-	xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, (long)len);
+	xfs_trans_mod_frextents(tp, (long)len, false);
+
 	/*
 	 * If we've now freed all the blocks, reset the file sequence
 	 * number to 0.
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 45a32ea426164a..6b5a7bfc32dbb8 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -140,16 +140,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 /* Transaction has locked the rtbitmap and rtsum inodes */
 #define XFS_TRANS_RTBITMAP_LOCKED	(1u << 9)
 
-/*
- * Field values for xfs_trans_mod_sb.
- */
-#define	XFS_TRANS_SB_ICOUNT		0x00000001
-#define	XFS_TRANS_SB_IFREE		0x00000002
-#define	XFS_TRANS_SB_FDBLOCKS		0x00000004
-#define	XFS_TRANS_SB_RES_FDBLOCKS	0x00000008
-#define	XFS_TRANS_SB_FREXTENTS		0x00000010
-#define	XFS_TRANS_SB_RES_FREXTENTS	0x00000020
-
 /*
  * Here we centralize the specification of XFS meta-data buffer reference count
  * values.  This determines how hard the buffer cache tries to hold onto the
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 4168ccf21068cb..ac88a38c6cd522 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -212,7 +212,7 @@ xfs_growfs_data_private(
 		goto out_trans_cancel;
 
 	if (id.nfree)
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
+		xfs_trans_mod_fdblocks(tp, id.nfree, false);
 
 	error = xfs_growfs_data_update_sb(tp, nagcount, nb, nagimax);
 	if (error)
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 994e5efedab20f..07f6008db322cb 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -838,7 +838,7 @@ xfs_growfs_rt_bmblock(
 	xfs_rtbuf_cache_relse(&nargs);
 	if (error)
 		goto out_cancel;
-	xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_FREXTENTS, freed_rtx);
+	xfs_trans_mod_frextents(args.tp, freed_rtx, false);
 
 	error = xfs_growfs_rt_update_sb(args.tp, mp, nmp, freed_rtx);
 	if (error)
@@ -1335,9 +1335,7 @@ xfs_rtallocate(
 	if (error)
 		goto out_release;
 
-	xfs_trans_mod_sb(tp, wasdel ?
-			XFS_TRANS_SB_RES_FREXTENTS : XFS_TRANS_SB_FREXTENTS,
-			-(long)len);
+	xfs_trans_mod_frextents(tp, -(long)len, wasdel);
 	*bno = xfs_rtx_to_rtb(args.mp, rtx);
 	*blen = xfs_rtxlen_to_extlen(args.mp, len);
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 56505cb94f877d..fa133535235d4c 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -334,48 +334,43 @@ xfs_trans_alloc_empty(
 	return xfs_trans_alloc(mp, &resv, 0, 0, XFS_TRANS_NO_WRITECOUNT, tpp);
 }
 
-/*
- * Record the indicated change to the given field for application
- * to the file system's superblock when the transaction commits.
- * For now, just store the change in the transaction structure.
- *
- * Mark the transaction structure to indicate that the superblock
- * needs to be updated before committing.
- *
- * Because we may not be keeping track of allocated/free inodes and
- * used filesystem blocks in the superblock, we do not mark the
- * superblock dirty in this transaction if we modify these fields.
- * We still need to update the transaction deltas so that they get
- * applied to the incore superblock, but we don't want them to
- * cause the superblock to get locked and logged if these are the
- * only fields in the superblock that the transaction modifies.
- */
 void
-xfs_trans_mod_sb(
-	xfs_trans_t	*tp,
-	uint		field,
-	int64_t		delta)
+xfs_trans_mod_icount(
+	struct xfs_trans	*tp,
+	int64_t			delta)
+{
+	tp->t_icount_delta += delta;
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	if (!xfs_has_lazysbcount(tp->t_mountp))
+		tp->t_flags |= XFS_TRANS_SB_DIRTY;
+}
+
+void
+xfs_trans_mod_ifree(
+	struct xfs_trans	*tp,
+	int64_t			delta)
 {
-	uint32_t	flags = (XFS_TRANS_DIRTY|XFS_TRANS_SB_DIRTY);
-	xfs_mount_t	*mp = tp->t_mountp;
-
-	switch (field) {
-	case XFS_TRANS_SB_ICOUNT:
-		tp->t_icount_delta += delta;
-		if (xfs_has_lazysbcount(mp))
-			flags &= ~XFS_TRANS_SB_DIRTY;
-		break;
-	case XFS_TRANS_SB_IFREE:
-		tp->t_ifree_delta += delta;
-		if (xfs_has_lazysbcount(mp))
-			flags &= ~XFS_TRANS_SB_DIRTY;
-		break;
-	case XFS_TRANS_SB_FDBLOCKS:
+	tp->t_ifree_delta += delta;
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	if (!xfs_has_lazysbcount(tp->t_mountp))
+		tp->t_flags |= XFS_TRANS_SB_DIRTY;
+}
+
+void
+xfs_trans_mod_fdblocks(
+	struct xfs_trans	*tp,
+	int64_t			delta,
+	bool			wasdel)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+
+	if (wasdel) {
 		/*
-		 * Track the number of blocks allocated in the transaction.
-		 * Make sure it does not exceed the number reserved. If so,
-		 * shutdown as this can lead to accounting inconsistency.
+		 * The allocation has already been applied to the in-core
+		 * counter, only apply it to the on-disk superblock.
 		 */
+		tp->t_res_fdblocks_delta += delta;
+	} else {
 		if (delta < 0) {
 			tp->t_blk_res_used += (uint)-delta;
 			if (tp->t_blk_res_used > tp->t_blk_res)
@@ -396,55 +391,40 @@ xfs_trans_mod_sb(
 			delta -= blkres_delta;
 		}
 		tp->t_fdblocks_delta += delta;
-		if (xfs_has_lazysbcount(mp))
-			flags &= ~XFS_TRANS_SB_DIRTY;
-		break;
-	case XFS_TRANS_SB_RES_FDBLOCKS:
-		/*
-		 * The allocation has already been applied to the
-		 * in-core superblock's counter.  This should only
-		 * be applied to the on-disk superblock.
-		 */
-		tp->t_res_fdblocks_delta += delta;
-		if (xfs_has_lazysbcount(mp))
-			flags &= ~XFS_TRANS_SB_DIRTY;
-		break;
-	case XFS_TRANS_SB_FREXTENTS:
+	}
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	if (!xfs_has_lazysbcount(mp))
+		tp->t_flags |= XFS_TRANS_SB_DIRTY;
+}
+
+void
+xfs_trans_mod_frextents(
+	struct xfs_trans	*tp,
+	int64_t			delta,
+	bool			wasdel)
+{
+	if (wasdel) {
 		/*
-		 * Track the number of blocks allocated in the
-		 * transaction.  Make sure it does not exceed the
-		 * number reserved.
+		 * The allocation has already been applied to the in-core
+		 * counter, only apply it to the on-disk superblock.
 		 */
+		ASSERT(delta < 0);
+		tp->t_res_frextents_delta += delta;
+	} else {
 		if (delta < 0) {
 			tp->t_rtx_res_used += (uint)-delta;
 			ASSERT(tp->t_rtx_res_used <= tp->t_rtx_res);
 		}
 		tp->t_frextents_delta += delta;
-		break;
-	case XFS_TRANS_SB_RES_FREXTENTS:
-		/*
-		 * The allocation has already been applied to the
-		 * in-core superblock's counter.  This should only
-		 * be applied to the on-disk superblock.
-		 */
-		ASSERT(delta < 0);
-		tp->t_res_frextents_delta += delta;
-		break;
-	default:
-		ASSERT(0);
-		return;
 	}
 
-	tp->t_flags |= flags;
+	tp->t_flags |= (XFS_TRANS_DIRTY | XFS_TRANS_SB_DIRTY);
 }
 
 /*
- * xfs_trans_apply_sb_deltas() is called from the commit code
- * to bring the superblock buffer into the current transaction
- * and modify it as requested by earlier calls to xfs_trans_mod_sb().
- *
- * For now we just look at each field allowed to change and change
- * it if necessary.
+ * Called from the commit code to bring the superblock buffer into the current
+ * transaction and modify it as based on earlier calls to  xfs_trans_mod_*().
  */
 STATIC void
 xfs_trans_apply_sb_deltas(
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index e5911cf09be444..a2cee42368bd25 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -162,7 +162,12 @@ int		xfs_trans_reserve_more(struct xfs_trans *tp,
 			unsigned int blocks, unsigned int rtextents);
 int		xfs_trans_alloc_empty(struct xfs_mount *mp,
 			struct xfs_trans **tpp);
-void		xfs_trans_mod_sb(xfs_trans_t *, uint, int64_t);
+void		xfs_trans_mod_icount(struct xfs_trans *tp, int64_t delta);
+void		xfs_trans_mod_ifree(struct xfs_trans *tp, int64_t delta);
+void		xfs_trans_mod_fdblocks(struct xfs_trans *tp, int64_t delta,
+			bool wasdel);
+void		xfs_trans_mod_frextents(struct xfs_trans *tp, int64_t delta,
+			bool wasdel);
 
 int xfs_trans_get_buf_map(struct xfs_trans *tp, struct xfs_buftarg *target,
 		struct xfs_buf_map *map, int nmaps, xfs_buf_flags_t flags,
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index b368e13424c4f4..839eb1780d4694 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -288,7 +288,7 @@ xfs_trans_get_dqtrx(
 
 /*
  * Make the changes in the transaction structure.
- * The moral equivalent to xfs_trans_mod_sb().
+ *
  * We don't touch any fields in the dquot, so we don't care
  * if it's locked or not (most of the time it won't be).
  */
-- 
2.45.2

