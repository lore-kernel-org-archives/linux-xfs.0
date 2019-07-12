Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7152 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728071AbfGLVga (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jul 2019 17:36:30 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ECC8681E07
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 21:36:29 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C111819C67
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 21:36:29 +0000 (UTC)
Subject: [PATCH 2/4] xfsprogs: cosmetic changes to libxfs/trans.c
References: <a40115ca-93e2-6dd2-7940-5911988f8fe4@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <5c8fe68f-c5dd-4f23-de03-fa886cd57641@redhat.com>
Date: Fri, 12 Jul 2019 16:36:29 -0500
MIME-Version: 1.0
In-Reply-To: <a40115ca-93e2-6dd2-7940-5911988f8fe4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Make some completely trivial changes to libxfs/trans.c to more
closely match kernelspace xfs_trans.c:

- remove some typedefs
- alter whitespace
- rename some variables

No functional changes.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/trans.c b/libxfs/trans.c
index 8954f0fe..fecefc7a 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -361,7 +361,7 @@ _libxfs_trans_bjoin(
 
 	ASSERT(bp->b_transp == NULL);
 
-        /*
+	/*
 	 * The xfs_buf_log_item pointer is stored in b_log_item.  If
 	 * it doesn't have one yet, then allocate one and initialize it.
 	 * The checks to see if one is there are in xfs_buf_item_init().
@@ -389,21 +389,21 @@ libxfs_trans_bjoin(
 	trace_xfs_trans_bjoin(bp->b_log_item);
 }
 
-xfs_buf_t *
+struct xfs_buf *
 libxfs_trans_get_buf_map(
-	xfs_trans_t		*tp,
-	struct xfs_buftarg	*btp,
+	struct xfs_trans	*tp,
+	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
-	uint			f)
+	uint			flags)
 {
 	xfs_buf_t		*bp;
-	xfs_buf_log_item_t	*bip;
+	struct xfs_buf_log_item	*bip;
 
 	if (tp == NULL)
-		return libxfs_getbuf_map(btp, map, nmaps, 0);
+		return libxfs_getbuf_map(target, map, nmaps, 0);
 
-	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
+	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
 	if (bp != NULL) {
 		ASSERT(bp->b_transp == tp);
 		bip = bp->b_log_item;
@@ -412,7 +412,7 @@ libxfs_trans_get_buf_map(
 		return bp;
 	}
 
-	bp = libxfs_getbuf_map(btp, map, nmaps, 0);
+	bp = libxfs_getbuf_map(target, map, nmaps, 0);
 	if (bp == NULL)
 		return NULL;
 
@@ -424,11 +424,11 @@ libxfs_trans_get_buf_map(
 xfs_buf_t *
 libxfs_trans_getsb(
 	xfs_trans_t		*tp,
-	xfs_mount_t		*mp,
+	struct xfs_mount	*mp,
 	int			flags)
 {
 	xfs_buf_t		*bp;
-	xfs_buf_log_item_t	*bip;
+	struct xfs_buf_log_item	*bip;
 	int			len = XFS_FSS_TO_BB(mp, 1);
 	DEFINE_SINGLE_BUF_MAP(map, XFS_SB_DADDR, len);
 
@@ -454,23 +454,23 @@ libxfs_trans_getsb(
 
 int
 libxfs_trans_read_buf_map(
-	xfs_mount_t		*mp,
-	xfs_trans_t		*tp,
-	struct xfs_buftarg	*btp,
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
 	uint			flags,
-	xfs_buf_t		**bpp,
+	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
-	xfs_buf_t		*bp;
-	xfs_buf_log_item_t	*bip;
+	struct xfs_buf		*bp;
+	struct xfs_buf_log_item	*bip;
 	int			error;
 
 	*bpp = NULL;
 
 	if (tp == NULL) {
-		bp = libxfs_readbuf_map(btp, map, nmaps, flags, ops);
+		bp = libxfs_readbuf_map(target, map, nmaps, flags, ops);
 		if (!bp) {
 			return (flags & XBF_TRYLOCK) ?  -EAGAIN : -ENOMEM;
 		}
@@ -479,7 +479,7 @@ libxfs_trans_read_buf_map(
 		goto done;
 	}
 
-	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
+	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
 	if (bp != NULL) {
 		ASSERT(bp->b_transp == tp);
 		ASSERT(bp->b_log_item != NULL);
@@ -489,7 +489,7 @@ libxfs_trans_read_buf_map(
 		goto done;
 	}
 
-	bp = libxfs_readbuf_map(btp, map, nmaps, flags, ops);
+	bp = libxfs_readbuf_map(target, map, nmaps, flags, ops);
 	if (!bp) {
 		return (flags & XBF_TRYLOCK) ?  -EAGAIN : -ENOMEM;
 	}
@@ -509,10 +509,10 @@ out_relse:
 
 void
 libxfs_trans_brelse(
-	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
 {
-	xfs_buf_log_item_t	*bip;
+	struct xfs_buf_log_item	*bip;
 
 	if (tp == NULL) {
 		ASSERT(bp->b_transp == NULL);
@@ -524,19 +524,23 @@ libxfs_trans_brelse(
 	ASSERT(bp->b_transp == tp);
 	bip = bp->b_log_item;
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
+
 	if (bip->bli_recur > 0) {
 		bip->bli_recur--;
 		return;
 	}
+
 	/* If dirty/stale, can't release till transaction committed */
 	if (bip->bli_flags & XFS_BLI_STALE)
 		return;
 	if (test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags))
 		return;
+
 	xfs_trans_del_item(&bip->bli_item);
 	if (bip->bli_flags & XFS_BLI_HOLD)
 		bip->bli_flags &= ~XFS_BLI_HOLD;
 	xfs_buf_item_put(bip);
+
 	bp->b_transp = NULL;
 	libxfs_putbuf(bp);
 }
@@ -552,7 +556,7 @@ libxfs_trans_bhold(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
 {
-	xfs_buf_log_item_t	*bip = bp->b_log_item;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
@@ -599,6 +603,7 @@ libxfs_trans_log_buf(
 	ASSERT((first <= last) && (last < bp->b_bcount));
 
 	xfs_trans_dirty_buf(tp, bp);
+
 	xfs_buf_item_log(bip, first, last);
 }
 
@@ -607,7 +612,7 @@ libxfs_trans_binval(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
 {
-	xfs_buf_log_item_t	*bip = bp->b_log_item;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
@@ -618,6 +623,7 @@ libxfs_trans_binval(
 		return;
 	XFS_BUF_UNDELAYWRITE(bp);
 	xfs_buf_stale(bp);
+
 	bip->bli_flags |= XFS_BLI_STALE;
 	bip->bli_flags &= ~XFS_BLI_DIRTY;
 	bip->__bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
@@ -631,7 +637,7 @@ libxfs_trans_inode_alloc_buf(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
 {
-	xfs_buf_log_item_t	*bip = bp->b_log_item;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
