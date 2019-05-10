Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36092 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbfEJUSn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 May 2019 16:18:43 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 06/11] libxfs: create new file trans_buf.c
Date: Fri, 10 May 2019 15:18:25 -0500
Message-Id: <1557519510-10602-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Pull functions out of libxfs/*.c into trans_buf.c, if they roughly match
the kernel's xfs_trans_buf.c file.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/Makefile      |   1 +
 libxfs/libxfs_priv.h |   1 +
 libxfs/logitem.c     |  36 ------
 libxfs/trans.c       | 301 -------------------------------------------
 libxfs/trans_buf.c   | 354 +++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 356 insertions(+), 337 deletions(-)
 create mode 100644 libxfs/trans_buf.c

diff --git a/libxfs/Makefile b/libxfs/Makefile
index 160498d..da0ce79 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -58,6 +58,7 @@ CFILES = cache.c \
 	logitem.c \
 	rdwr.c \
 	trans.c \
+	trans_buf.c \
 	util.c \
 	xfs_ag.c \
 	xfs_ag_resv.c \
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index d668a15..7c07188 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -519,6 +519,7 @@ void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
 /* xfs_buf_item.c */
 void xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
+void xfs_buf_item_put(struct xfs_buf_log_item *bip);
 
 /* xfs_trans_buf.c */
 struct xfs_buf *xfs_trans_buf_item_match(struct xfs_trans *,
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 4da9bc1..ce34c68 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -20,42 +20,6 @@ kmem_zone_t	*xfs_buf_item_zone;
 kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
 
 /*
- * Following functions from fs/xfs/xfs_trans_buf.c
- */
-
-/*
- * Check to see if a buffer matching the given parameters is already
- * a part of the given transaction.
- */
-xfs_buf_t *
-xfs_trans_buf_item_match(
-	xfs_trans_t		*tp,
-	struct xfs_buftarg	*btp,
-	struct xfs_buf_map	*map,
-	int			nmaps)
-{
-	struct xfs_log_item	*lip;
-	struct xfs_buf_log_item *blip;
-	int			len = 0;
-	int			i;
-
-	for (i = 0; i < nmaps; i++)
-		len += map[i].bm_len;
-
-	list_for_each_entry(lip, &tp->t_items, li_trans) {
-		blip = (struct xfs_buf_log_item *)lip;
-		if (blip->bli_item.li_type == XFS_LI_BUF &&
-		    blip->bli_buf->b_target->dev == btp->dev &&
-		    XFS_BUF_ADDR(blip->bli_buf) == map[0].bm_bn &&
-		    blip->bli_buf->b_bcount == BBTOB(len)) {
-			ASSERT(blip->bli_buf->b_map_count == nmaps);
-			return blip->bli_buf;
-		}
-	}
-
-	return NULL;
-}
-/*
  * The following are from fs/xfs/xfs_buf_item.c
  */
 
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 85c3a50..295f167 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -374,19 +374,6 @@ xfs_trans_ijoin_ref(
 #endif
 }
 
-void
-xfs_trans_inode_alloc_buf(
-	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
-{
-	xfs_buf_log_item_t	*bip = bp->b_log_item;
-
-	ASSERT(bp->b_transp == tp);
-	ASSERT(bip != NULL);
-	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
-	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
-}
-
 /*
  * This is called to mark the fields indicated in fieldmask as needing
  * to be logged when the transaction is committed.  The inode must
@@ -435,72 +422,7 @@ xfs_trans_roll_inode(
 	return error;
 }
 
-
-/*
- * Mark a buffer dirty in the transaction.
- */
-void
-xfs_trans_dirty_buf(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	ASSERT(bp->b_transp == tp);
-	ASSERT(bip != NULL);
-
-#ifdef XACT_DEBUG
-	fprintf(stderr, "dirtied buffer %p, transaction %p\n", bp, tp);
-#endif
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
-}
-
-/*
- * This is called to mark bytes first through last inclusive of the given
- * buffer as needing to be logged when the transaction is committed.
- * The buffer must already be associated with the given transaction.
- *
- * First and last are numbers relative to the beginning of this buffer,
- * so the first byte in the buffer is numbered 0 regardless of the
- * value of b_blkno.
- */
 void
-xfs_trans_log_buf(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*bp,
-	uint			first,
-	uint			last)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	ASSERT((first <= last) && (last < bp->b_bcount));
-
-	xfs_trans_dirty_buf(tp, bp);
-	xfs_buf_item_log(bip, first, last);
-}
-
-/*
- * For userspace, ordered buffers just need to be marked dirty so
- * the transaction commit will write them and mark them up-to-date.
- * In essence, they are just like any other logged buffer in userspace.
- *
- * If the buffer is already dirty, trigger the "already logged" return condition.
- */
-bool
-xfs_trans_ordered_buf(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-	bool			ret;
-
-	ret = test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
-	libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount);
-	return ret;
-}
-
-static void
 xfs_buf_item_put(
 	struct xfs_buf_log_item	*bip)
 {
@@ -510,229 +432,6 @@ xfs_buf_item_put(
 	kmem_zone_free(xfs_buf_item_zone, bip);
 }
 
-void
-xfs_trans_brelse(
-	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
-{
-	xfs_buf_log_item_t	*bip;
-#ifdef XACT_DEBUG
-	fprintf(stderr, "released buffer %p, transaction %p\n", bp, tp);
-#endif
-
-	if (tp == NULL) {
-		ASSERT(bp->b_transp == NULL);
-		libxfs_putbuf(bp);
-		return;
-	}
-	ASSERT(bp->b_transp == tp);
-	bip = bp->b_log_item;
-	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
-	if (bip->bli_recur > 0) {
-		bip->bli_recur--;
-		return;
-	}
-	/* If dirty/stale, can't release till transaction committed */
-	if (bip->bli_flags & XFS_BLI_STALE)
-		return;
-	if (test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags))
-		return;
-	xfs_trans_del_item(&bip->bli_item);
-	if (bip->bli_flags & XFS_BLI_HOLD)
-		bip->bli_flags &= ~XFS_BLI_HOLD;
-	xfs_buf_item_put(bip);
-	bp->b_transp = NULL;
-	libxfs_putbuf(bp);
-}
-
-void
-xfs_trans_binval(
-	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
-{
-	xfs_buf_log_item_t	*bip = bp->b_log_item;
-#ifdef XACT_DEBUG
-	fprintf(stderr, "binval'd buffer %p, transaction %p\n", bp, tp);
-#endif
-
-	ASSERT(bp->b_transp == tp);
-	ASSERT(bip != NULL);
-
-	if (bip->bli_flags & XFS_BLI_STALE)
-		return;
-	XFS_BUF_UNDELAYWRITE(bp);
-	xfs_buf_stale(bp);
-	bip->bli_flags |= XFS_BLI_STALE;
-	bip->bli_flags &= ~XFS_BLI_DIRTY;
-	bip->bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
-	bip->bli_format.blf_flags |= XFS_BLF_CANCEL;
-	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
-	tp->t_flags |= XFS_TRANS_DIRTY;
-}
-
-void
-xfs_trans_bjoin(
-	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
-{
-	xfs_buf_log_item_t	*bip;
-
-	ASSERT(bp->b_transp == NULL);
-#ifdef XACT_DEBUG
-	fprintf(stderr, "bjoin'd buffer %p, transaction %p\n", bp, tp);
-#endif
-
-	xfs_buf_item_init(bp, tp->t_mountp);
-	bip = bp->b_log_item;
-	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
-	bp->b_transp = tp;
-}
-
-void
-xfs_trans_bhold(
-	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
-{
-	xfs_buf_log_item_t	*bip = bp->b_log_item;
-
-	ASSERT(bp->b_transp == tp);
-	ASSERT(bip != NULL);
-#ifdef XACT_DEBUG
-	fprintf(stderr, "bhold'd buffer %p, transaction %p\n", bp, tp);
-#endif
-
-	bip->bli_flags |= XFS_BLI_HOLD;
-}
-
-xfs_buf_t *
-xfs_trans_get_buf_map(
-	xfs_trans_t		*tp,
-	struct xfs_buftarg	*btp,
-	struct xfs_buf_map	*map,
-	int			nmaps,
-	uint			f)
-{
-	xfs_buf_t		*bp;
-	xfs_buf_log_item_t	*bip;
-
-	if (tp == NULL)
-		return libxfs_getbuf_map(btp, map, nmaps, 0);
-
-	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
-	if (bp != NULL) {
-		ASSERT(bp->b_transp == tp);
-		bip = bp->b_log_item;
-		ASSERT(bip != NULL);
-		bip->bli_recur++;
-		return bp;
-	}
-
-	bp = libxfs_getbuf_map(btp, map, nmaps, 0);
-	if (bp == NULL)
-		return NULL;
-#ifdef XACT_DEBUG
-	fprintf(stderr, "trans_get_buf buffer %p, transaction %p\n", bp, tp);
-#endif
-
-	libxfs_trans_bjoin(tp, bp);
-	bip = bp->b_log_item;
-	bip->bli_recur = 0;
-	return bp;
-}
-
-xfs_buf_t *
-xfs_trans_getsb(
-	xfs_trans_t		*tp,
-	xfs_mount_t		*mp,
-	int			flags)
-{
-	xfs_buf_t		*bp;
-	xfs_buf_log_item_t	*bip;
-	int			len = XFS_FSS_TO_BB(mp, 1);
-	DEFINE_SINGLE_BUF_MAP(map, XFS_SB_DADDR, len);
-
-	if (tp == NULL)
-		return libxfs_getsb(mp, flags);
-
-	bp = xfs_trans_buf_item_match(tp, mp->m_dev, &map, 1);
-	if (bp != NULL) {
-		ASSERT(bp->b_transp == tp);
-		bip = bp->b_log_item;
-		ASSERT(bip != NULL);
-		bip->bli_recur++;
-		return bp;
-	}
-
-	bp = libxfs_getsb(mp, flags);
-#ifdef XACT_DEBUG
-	fprintf(stderr, "trans_get_sb buffer %p, transaction %p\n", bp, tp);
-#endif
-
-	libxfs_trans_bjoin(tp, bp);
-	bip = bp->b_log_item;
-	bip->bli_recur = 0;
-	return bp;
-}
-
-int
-xfs_trans_read_buf_map(
-	xfs_mount_t		*mp,
-	xfs_trans_t		*tp,
-	struct xfs_buftarg	*btp,
-	struct xfs_buf_map	*map,
-	int			nmaps,
-	uint			flags,
-	xfs_buf_t		**bpp,
-	const struct xfs_buf_ops *ops)
-{
-	xfs_buf_t		*bp;
-	xfs_buf_log_item_t	*bip;
-	int			error;
-
-	*bpp = NULL;
-
-	if (tp == NULL) {
-		bp = libxfs_readbuf_map(btp, map, nmaps, flags, ops);
-		if (!bp) {
-			return (flags & XBF_TRYLOCK) ?  -EAGAIN : -ENOMEM;
-		}
-		if (bp->b_error)
-			goto out_relse;
-		goto done;
-	}
-
-	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
-	if (bp != NULL) {
-		ASSERT(bp->b_transp == tp);
-		ASSERT(bp->b_log_item != NULL);
-		bip = bp->b_log_item;
-		bip->bli_recur++;
-		goto done;
-	}
-
-	bp = libxfs_readbuf_map(btp, map, nmaps, flags, ops);
-	if (!bp) {
-		return (flags & XBF_TRYLOCK) ?  -EAGAIN : -ENOMEM;
-	}
-	if (bp->b_error)
-		goto out_relse;
-
-#ifdef XACT_DEBUG
-	fprintf(stderr, "trans_read_buf buffer %p, transaction %p\n", bp, tp);
-#endif
-
-	xfs_trans_bjoin(tp, bp);
-	bip = bp->b_log_item;
-	bip->bli_recur = 0;
-done:
-	*bpp = bp;
-	return 0;
-out_relse:
-	error = bp->b_error;
-	xfs_buf_relse(bp);
-	return error;
-}
-
 /*
  * Record the indicated change to the given field for application
  * to the file system's superblock when the transaction commits.
diff --git a/libxfs/trans_buf.c b/libxfs/trans_buf.c
new file mode 100644
index 0000000..9c2c36e
--- /dev/null
+++ b/libxfs/trans_buf.c
@@ -0,0 +1,354 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2001,2005-2006 Silicon Graphics, Inc.
+ * Copyright (C) 2010 Red Hat, Inc.
+ * All Rights Reserved.
+ */
+
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+
+/*
+ * Following functions from fs/xfs/xfs_trans_buf.c
+ */
+
+/*
+ * Check to see if a buffer matching the given parameters is already
+ * a part of the given transaction.
+ */
+xfs_buf_t *
+xfs_trans_buf_item_match(
+	xfs_trans_t		*tp,
+	struct xfs_buftarg	*btp,
+	struct xfs_buf_map	*map,
+	int			nmaps)
+{
+	struct xfs_log_item	*lip;
+	struct xfs_buf_log_item *blip;
+	int			len = 0;
+	int			i;
+
+	for (i = 0; i < nmaps; i++)
+		len += map[i].bm_len;
+
+	list_for_each_entry(lip, &tp->t_items, li_trans) {
+		blip = (struct xfs_buf_log_item *)lip;
+		if (blip->bli_item.li_type == XFS_LI_BUF &&
+		    blip->bli_buf->b_target->dev == btp->dev &&
+		    XFS_BUF_ADDR(blip->bli_buf) == map[0].bm_bn &&
+		    blip->bli_buf->b_bcount == BBTOB(len)) {
+			ASSERT(blip->bli_buf->b_map_count == nmaps);
+			return blip->bli_buf;
+		}
+	}
+
+	return NULL;
+}
+
+void
+xfs_trans_bjoin(
+	xfs_trans_t		*tp,
+	xfs_buf_t		*bp)
+{
+	xfs_buf_log_item_t	*bip;
+
+	ASSERT(bp->b_transp == NULL);
+#ifdef XACT_DEBUG
+	fprintf(stderr, "bjoin'd buffer %p, transaction %p\n", bp, tp);
+#endif
+
+	xfs_buf_item_init(bp, tp->t_mountp);
+	bip = bp->b_log_item;
+	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
+	bp->b_transp = tp;
+}
+
+xfs_buf_t *
+xfs_trans_get_buf_map(
+	xfs_trans_t		*tp,
+	struct xfs_buftarg	*btp,
+	struct xfs_buf_map	*map,
+	int			nmaps,
+	uint			f)
+{
+	xfs_buf_t		*bp;
+	xfs_buf_log_item_t	*bip;
+
+	if (tp == NULL)
+		return libxfs_getbuf_map(btp, map, nmaps, 0);
+
+	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
+	if (bp != NULL) {
+		ASSERT(bp->b_transp == tp);
+		bip = bp->b_log_item;
+		ASSERT(bip != NULL);
+		bip->bli_recur++;
+		return bp;
+	}
+
+	bp = libxfs_getbuf_map(btp, map, nmaps, 0);
+	if (bp == NULL)
+		return NULL;
+#ifdef XACT_DEBUG
+	fprintf(stderr, "trans_get_buf buffer %p, transaction %p\n", bp, tp);
+#endif
+
+	libxfs_trans_bjoin(tp, bp);
+	bip = bp->b_log_item;
+	bip->bli_recur = 0;
+	return bp;
+}
+
+xfs_buf_t *
+xfs_trans_getsb(
+	xfs_trans_t		*tp,
+	xfs_mount_t		*mp,
+	int			flags)
+{
+	xfs_buf_t		*bp;
+	xfs_buf_log_item_t	*bip;
+	int			len = XFS_FSS_TO_BB(mp, 1);
+	DEFINE_SINGLE_BUF_MAP(map, XFS_SB_DADDR, len);
+
+	if (tp == NULL)
+		return libxfs_getsb(mp, flags);
+
+	bp = xfs_trans_buf_item_match(tp, mp->m_dev, &map, 1);
+	if (bp != NULL) {
+		ASSERT(bp->b_transp == tp);
+		bip = bp->b_log_item;
+		ASSERT(bip != NULL);
+		bip->bli_recur++;
+		return bp;
+	}
+
+	bp = libxfs_getsb(mp, flags);
+#ifdef XACT_DEBUG
+	fprintf(stderr, "trans_get_sb buffer %p, transaction %p\n", bp, tp);
+#endif
+
+	libxfs_trans_bjoin(tp, bp);
+	bip = bp->b_log_item;
+	bip->bli_recur = 0;
+	return bp;
+}
+
+int
+xfs_trans_read_buf_map(
+	xfs_mount_t		*mp,
+	xfs_trans_t		*tp,
+	struct xfs_buftarg	*btp,
+	struct xfs_buf_map	*map,
+	int			nmaps,
+	uint			flags,
+	xfs_buf_t		**bpp,
+	const struct xfs_buf_ops *ops)
+{
+	xfs_buf_t		*bp;
+	xfs_buf_log_item_t	*bip;
+	int			error;
+
+	*bpp = NULL;
+
+	if (tp == NULL) {
+		bp = libxfs_readbuf_map(btp, map, nmaps, flags, ops);
+		if (!bp) {
+			return (flags & XBF_TRYLOCK) ?  -EAGAIN : -ENOMEM;
+		}
+		if (bp->b_error)
+			goto out_relse;
+		goto done;
+	}
+
+	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
+	if (bp != NULL) {
+		ASSERT(bp->b_transp == tp);
+		ASSERT(bp->b_log_item != NULL);
+		bip = bp->b_log_item;
+		bip->bli_recur++;
+		goto done;
+	}
+
+	bp = libxfs_readbuf_map(btp, map, nmaps, flags, ops);
+	if (!bp) {
+		return (flags & XBF_TRYLOCK) ?  -EAGAIN : -ENOMEM;
+	}
+	if (bp->b_error)
+		goto out_relse;
+
+#ifdef XACT_DEBUG
+	fprintf(stderr, "trans_read_buf buffer %p, transaction %p\n", bp, tp);
+#endif
+
+	xfs_trans_bjoin(tp, bp);
+	bip = bp->b_log_item;
+	bip->bli_recur = 0;
+done:
+	*bpp = bp;
+	return 0;
+out_relse:
+	error = bp->b_error;
+	xfs_buf_relse(bp);
+	return error;
+}
+
+void
+xfs_trans_brelse(
+	xfs_trans_t		*tp,
+	xfs_buf_t		*bp)
+{
+	xfs_buf_log_item_t	*bip;
+#ifdef XACT_DEBUG
+	fprintf(stderr, "released buffer %p, transaction %p\n", bp, tp);
+#endif
+
+	if (tp == NULL) {
+		ASSERT(bp->b_transp == NULL);
+		libxfs_putbuf(bp);
+		return;
+	}
+	ASSERT(bp->b_transp == tp);
+	bip = bp->b_log_item;
+	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
+	if (bip->bli_recur > 0) {
+		bip->bli_recur--;
+		return;
+	}
+	/* If dirty/stale, can't release till transaction committed */
+	if (bip->bli_flags & XFS_BLI_STALE)
+		return;
+	if (test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags))
+		return;
+	xfs_trans_del_item(&bip->bli_item);
+	if (bip->bli_flags & XFS_BLI_HOLD)
+		bip->bli_flags &= ~XFS_BLI_HOLD;
+	xfs_buf_item_put(bip);
+	bp->b_transp = NULL;
+	libxfs_putbuf(bp);
+}
+
+void
+xfs_trans_bhold(
+	xfs_trans_t		*tp,
+	xfs_buf_t		*bp)
+{
+	xfs_buf_log_item_t	*bip = bp->b_log_item;
+
+	ASSERT(bp->b_transp == tp);
+	ASSERT(bip != NULL);
+#ifdef XACT_DEBUG
+	fprintf(stderr, "bhold'd buffer %p, transaction %p\n", bp, tp);
+#endif
+
+	bip->bli_flags |= XFS_BLI_HOLD;
+}
+
+/*
+ * Mark a buffer dirty in the transaction.
+ */
+void
+xfs_trans_dirty_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+
+	ASSERT(bp->b_transp == tp);
+	ASSERT(bip != NULL);
+
+#ifdef XACT_DEBUG
+	fprintf(stderr, "dirtied buffer %p, transaction %p\n", bp, tp);
+#endif
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
+}
+
+/*
+ * This is called to mark bytes first through last inclusive of the given
+ * buffer as needing to be logged when the transaction is committed.
+ * The buffer must already be associated with the given transaction.
+ *
+ * First and last are numbers relative to the beginning of this buffer,
+ * so the first byte in the buffer is numbered 0 regardless of the
+ * value of b_blkno.
+ */
+void
+xfs_trans_log_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	uint			first,
+	uint			last)
+{
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+
+	ASSERT((first <= last) && (last < bp->b_bcount));
+
+	xfs_trans_dirty_buf(tp, bp);
+	xfs_buf_item_log(bip, first, last);
+}
+
+void
+xfs_trans_binval(
+	xfs_trans_t		*tp,
+	xfs_buf_t		*bp)
+{
+	xfs_buf_log_item_t	*bip = bp->b_log_item;
+#ifdef XACT_DEBUG
+	fprintf(stderr, "binval'd buffer %p, transaction %p\n", bp, tp);
+#endif
+
+	ASSERT(bp->b_transp == tp);
+	ASSERT(bip != NULL);
+
+	if (bip->bli_flags & XFS_BLI_STALE)
+		return;
+	XFS_BUF_UNDELAYWRITE(bp);
+	xfs_buf_stale(bp);
+	bip->bli_flags |= XFS_BLI_STALE;
+	bip->bli_flags &= ~XFS_BLI_DIRTY;
+	bip->bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
+	bip->bli_format.blf_flags |= XFS_BLF_CANCEL;
+	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
+	tp->t_flags |= XFS_TRANS_DIRTY;
+}
+
+void
+xfs_trans_inode_alloc_buf(
+	xfs_trans_t		*tp,
+	xfs_buf_t		*bp)
+{
+	xfs_buf_log_item_t	*bip = bp->b_log_item;
+
+	ASSERT(bp->b_transp == tp);
+	ASSERT(bip != NULL);
+	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
+}
+
+/*
+ * For userspace, ordered buffers just need to be marked dirty so
+ * the transaction commit will write them and mark them up-to-date.
+ * In essence, they are just like any other logged buffer in userspace.
+ *
+ * If the buffer is already dirty, trigger the "already logged" return condition.
+ */
+bool
+xfs_trans_ordered_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+	bool			ret;
+
+	ret = test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
+	libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount);
+	return ret;
+}
-- 
1.8.3.1
