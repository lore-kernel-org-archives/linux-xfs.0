Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35352 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752087AbdF1T0D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jun 2017 15:26:03 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 549A53D96D
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2017 19:25:57 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-121-88.rdu2.redhat.com [10.10.121.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 029F87ABEC
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2017 19:25:56 +0000 (UTC)
From: Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH v2] xfs_db: improve argument naming in set_cur and set_iocur_type
Date: Wed, 28 Jun 2017 14:25:56 -0500
Message-Id: <20170628192556.9464-1-billodo@redhat.com>
In-Reply-To: <20170628150913.15934-1-billodo@redhat.com>
References: <20170628150913.15934-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

In set_cur and set_iocur_type, the current naming for arguments
type, block number, and length are t, d, and c, respectively.
Replace these with more intuitive and descriptive names:
type, blknum, and len. Fix type of blknum (xfs_daddr_t) to be
consistent with that of libxfs_readbuf where it's used.
Additionally remove extra blank line in io.c.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
v2: Fix type of blknum (xfs_daddr_t) to be consistent with that of
    libxfs_readbuf. Rebase this patch on recently submitted
    xfs_db patch touching the same file.
    (https://www.spinics.net/lists/linux-xfs/msg07909.html)


 db/io.c | 38 +++++++++++++++++++-------------------
 db/io.h |  6 +++---
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/db/io.c b/db/io.c
index b97b710d..9a893932 100644
--- a/db/io.c
+++ b/db/io.c
@@ -536,9 +536,9 @@ write_cur(void)
 
 void
 set_cur(
-	const typ_t	*t,
-	__int64_t	d,
-	int		c,
+	const typ_t	*type,
+	xfs_daddr_t	blknum,
+	int		len,
 	int		ring_flag,
 	bbmap_t		*bbmap)
 {
@@ -546,14 +546,13 @@ set_cur(
 	xfs_ino_t	dirino;
 	xfs_ino_t	ino;
 	__uint16_t	mode;
-	const struct xfs_buf_ops *ops = t ? t->bops : NULL;
+	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
 
 	if (iocur_sp < 0) {
 		dbprintf(_("set_cur no stack element to set\n"));
 		return;
 	}
 
-
 	ino = iocur_top->ino;
 	dirino = iocur_top->dirino;
 	mode = iocur_top->mode;
@@ -563,7 +562,7 @@ set_cur(
 	if (bbmap) {
 #ifdef DEBUG_BBMAP
 		int i;
-		printf(_("xfs_db got a bbmap for %lld\n"), (long long)d);
+		printf(_("xfs_db got a bbmap for %lld\n"), (long long)blknum);
 		printf(_("\tblock map"));
 		for (i = 0; i < bbmap->nmaps; i++)
 			printf(" %lld:%d", (long long)bbmap->b[i].bm_bn,
@@ -577,7 +576,7 @@ set_cur(
 		bp = libxfs_readbuf_map(mp->m_ddev_targp, bbmap->b,
 					bbmap->nmaps, 0, ops);
 	} else {
-		bp = libxfs_readbuf(mp->m_ddev_targp, d, c, 0, ops);
+		bp = libxfs_readbuf(mp->m_ddev_targp, blknum, len, 0, ops);
 		iocur_top->bbmap = NULL;
 	}
 
@@ -593,13 +592,13 @@ set_cur(
 	if (!ops)
 		bp->b_flags |= LIBXFS_B_UNCHECKED;
 
-	iocur_top->bb = d;
-	iocur_top->blen = c;
+	iocur_top->bb = blknum;
+	iocur_top->blen = len;
 	iocur_top->boff = 0;
 	iocur_top->data = iocur_top->buf;
-	iocur_top->len = BBTOB(c);
-	iocur_top->off = d << BBSHIFT;
-	iocur_top->typ = cur_typ = t;
+	iocur_top->len = BBTOB(len);
+	iocur_top->off = blknum << BBSHIFT;
+	iocur_top->typ = cur_typ = type;
 	iocur_top->ino = ino;
 	iocur_top->dirino = dirino;
 	iocur_top->mode = mode;
@@ -613,22 +612,23 @@ set_cur(
 
 void
 set_iocur_type(
-	const typ_t	*t)
+	const typ_t	*type)
 {
 	struct xfs_buf	*bp = iocur_top->bp;
 	int bb_count;
 
 	/* adjust cursor for types that contain fields */
-	if (t->fields) {
-		bb_count = BTOBB(byteize(fsize(t->fields, iocur_top->data, 0, 0)));
-		set_cur(t, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
+	if (type->fields) {
+		bb_count = BTOBB(byteize(fsize(type->fields,
+					       iocur_top->data, 0, 0)));
+		set_cur(type, iocur_top->bb, bb_count, DB_RING_IGN, NULL);
 	}
-	iocur_top->typ = t;
+	iocur_top->typ = type;
 
 	/* verify the buffer if the type has one. */
 	if (!bp)
 		return;
-	if (!t->bops) {
+	if (!type->bops) {
 		bp->b_ops = NULL;
 		bp->b_flags |= LIBXFS_B_UNCHECKED;
 		return;
@@ -636,7 +636,7 @@ set_iocur_type(
 	if (!(bp->b_flags & LIBXFS_B_UPTODATE))
 		return;
 	bp->b_error = 0;
-	bp->b_ops = t->bops;
+	bp->b_ops = type->bops;
 	bp->b_ops->verify_read(bp);
 	bp->b_flags &= ~LIBXFS_B_UNCHECKED;
 }
diff --git a/db/io.h b/db/io.h
index b415b82d..99730048 100644
--- a/db/io.h
+++ b/db/io.h
@@ -59,10 +59,10 @@ extern void	print_iocur(char *tag, iocur_t *ioc);
 extern void	push_cur(void);
 extern int	read_buf(__int64_t daddr, int count, void *bufp);
 extern void     write_cur(void);
-extern void	set_cur(const struct typ *t, __int64_t d, int c, int ring_add,
-			bbmap_t *bbmap);
+extern void	set_cur(const struct typ *type, xfs_daddr_t blknum,
+			int len, int ring_add, bbmap_t *bbmap);
 extern void     ring_add(void);
-extern void	set_iocur_type(const struct typ *t);
+extern void	set_iocur_type(const struct typ *type);
 extern void	xfs_dummy_verify(struct xfs_buf *bp);
 extern void	xfs_verify_recalc_inode_crc(struct xfs_buf *bp);
 extern void	xfs_verify_recalc_dquot_crc(struct xfs_buf *bp);
-- 
2.13.0

