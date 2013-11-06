Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2BD2A29E3D
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 19:07:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E09948F808F
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 17:07:45 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	mS7njjeWVnTDgIc5 for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 17:07:43 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vdrak-0003OQ-B4
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vdrak-0008VW-AX
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 20/37] db: rewrite IO engine to use libxfs
Date: Wed,  6 Nov 2013 12:07:06 +1100
Message-Id: <1383700043-32305-21-git-send-email-david@fromorbit.com>
In-Reply-To: <1383700043-32305-1-git-send-email-david@fromorbit.com>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now that we have buffers and xfs_buf_maps, it is relatively easy to
convert the IO engine to use libxfs routines. This gets rid of the
most of the differences between mapped and straight buffer reads,
and tracks xfs_bufs directly in the IO context that is being used.

This is not yet a perfect solution, as xfs_db does different sized
IOs for the same block range which will throw warnings like:

xfs_db> inode 64
7ffff7fde740: Badness in key lookup (length)
bp=(bno 0x40, len 8192 bytes) key=(bno 0x40, len 4096 bytes)
xfs_db>

This is when first displaying an inode in the root inode chunk.
These will need to be dealt with on a case by case basis.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/init.c |  25 +++++++--
 db/io.c   | 178 +++++++++++++++++---------------------------------------------
 db/io.h   |   4 +-
 3 files changed, 70 insertions(+), 137 deletions(-)

diff --git a/db/init.c b/db/init.c
index b93a194..48b8dd1 100644
--- a/db/init.c
+++ b/db/init.c
@@ -54,8 +54,8 @@ init(
 	int		argc,
 	char		**argv)
 {
-	xfs_sb_t	*sbp;
-	char		bufp[BBSIZE];
+	struct xfs_sb	*sbp;
+	struct xfs_buf	*bp;
 	int		c;
 
 	setlocale(LC_ALL, "");
@@ -115,14 +115,25 @@ init(
 		exit(1);
 	}
 
-	if (read_buf(XFS_SB_DADDR, 1, bufp)) {
+	/*
+	 * Read the superblock, but don't validate it - we are a diagnostic
+	 * tool and so need to be able to mount busted filesystems.
+	 */
+	memset(&xmount, 0, sizeof(struct xfs_mount));
+	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
+	bp = libxfs_readbuf(xmount.m_ddev_targp, XFS_SB_DADDR,
+			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
+
+	if (!bp || bp->b_error) {
 		fprintf(stderr, _("%s: %s is invalid (cannot read first 512 "
 			"bytes)\n"), progname, fsdevice);
 		exit(1);
 	}
 
 	/* copy SB from buffer to in-core, converting architecture as we go */
-	libxfs_sb_from_disk(&xmount.m_sb, (struct xfs_dsb *)bufp);
+	libxfs_sb_from_disk(&xmount.m_sb, XFS_BUF_TO_SBP(bp));
+	libxfs_putbuf(bp);
+	libxfs_purgebuf(bp);
 
 	sbp = &xmount.m_sb;
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
@@ -211,6 +222,12 @@ main(
 	}
 
 close_devices:
+	/*
+	 * make sure that we pop the last buffer context we held so that the
+	 * buffer is released before purge the caches during unmount.
+	 */
+	pop_cur();
+	libxfs_umount(mp);
 	if (x.ddev)
 		libxfs_device_close(x.ddev);
 	if (x.logdev && x.logdev != x.ddev)
diff --git a/db/io.c b/db/io.c
index 01a5970..ca89354 100644
--- a/db/io.c
+++ b/db/io.c
@@ -104,8 +104,14 @@ pop_cur(void)
 		dbprintf(_("can't pop anything from I/O stack\n"));
 		return;
 	}
-	if (iocur_top->buf)
-		xfree(iocur_top->buf);
+	if (iocur_top->bp) {
+		libxfs_putbuf(iocur_top->bp);
+		iocur_top->bp = NULL;
+	}
+	if (iocur_top->bbmap) {
+		free(iocur_top->bbmap);
+		iocur_top->bbmap = NULL;
+	}
 	if (--iocur_sp >= 0) {
 		iocur_top = iocur_base + iocur_sp;
 		cur_typ = iocur_top->typ;
@@ -147,10 +153,11 @@ print_iocur(
 	dbprintf(_("\tbuffer block %lld (fsbno %lld), %d bb%s\n"), ioc->bb,
 		(xfs_dfsbno_t)XFS_DADDR_TO_FSB(mp, ioc->bb), ioc->blen,
 		ioc->blen == 1 ? "" : "s");
-	if (ioc->use_bbmap) {
+	if (ioc->bbmap) {
 		dbprintf(_("\tblock map"));
-		for (i = 0; i < ioc->blen; i++)
-			dbprintf(" %d:%lld", i, ioc->bbmap.b[i]);
+		for (i = 0; i < ioc->bbmap->nmaps; i++)
+			dbprintf(" %lld:%d", ioc->bbmap->b[i].bm_bn,
+					     ioc->bbmap->b[i].bm_len);
 		dbprintf("\n");
 	}
 	dbprintf(_("\tinode %lld, dir inode %lld, type %s\n"), ioc->ino,
@@ -238,7 +245,7 @@ push_f(
 	else
 		set_cur(iocur_top[-1].typ, iocur_top[-1].bb,
 			iocur_top[-1].blen, DB_RING_IGN,
-			iocur_top[-1].use_bbmap ? &iocur_top[-1].bbmap : NULL);
+			iocur_top[-1].bbmap);
 
 	/* run requested command */
 	if (argc>1)
@@ -280,8 +287,7 @@ forward_f(
 		iocur_ring[ring_current].bb,
 		iocur_ring[ring_current].blen,
 		DB_RING_IGN,
-		iocur_ring[ring_current].use_bbmap ?
-			&iocur_ring[ring_current].bbmap : NULL);
+		iocur_ring[ring_current].bbmap);
 
 	return 0;
 }
@@ -321,8 +327,7 @@ back_f(
 		iocur_ring[ring_current].bb,
 		iocur_ring[ring_current].blen,
 		DB_RING_IGN,
-		iocur_ring[ring_current].use_bbmap ?
-			&iocur_ring[ring_current].bbmap : NULL);
+		iocur_ring[ring_current].bbmap);
 
 	return 0;
 }
@@ -362,7 +367,7 @@ ring_f(
 		iocur_ring[index].bb,
 		iocur_ring[index].blen,
 		DB_RING_IGN,
-		iocur_ring[index].use_bbmap ? &iocur_ring[index].bbmap : NULL);
+		iocur_ring[index].bbmap);
 
 	return 0;
 }
@@ -417,132 +422,37 @@ ring_add(void)
 	}
 }
 
-int
-read_buf(
-	xfs_daddr_t	bbno,
-	int		count,
-	void		*bufp)
-{
-	int		err;
-
-	err = pread64(x.dfd, bufp, BBTOB(count), BBTOB(bbno));
-	if (err < 0)
-		err = errno;
-	else if (err < count)
-		err = -1;
-	return err;
-}
-
-static int
-write_buf(
-	xfs_daddr_t	bbno,
-	int		count,
-	void		*bufp)
-{
-	int		err;
-
-	err = pwrite64(x.dfd, bufp, BBTOB(count), BBTOB(bbno));
-	if (err < 0)
-		err = errno;
-	else if (err < count)
-		err = -1;
-	return err;
-}
-
 static void
 write_cur_buf(void)
 {
 	int ret;
 
-	ret = write_buf(iocur_top->bb, iocur_top->blen, iocur_top->buf);
-
-	if (ret == -1)
-		dbprintf(_("incomplete write, block: %lld\n"),
-			 (iocur_base + iocur_sp)->bb);
-	else if (ret != 0)
+	ret = libxfs_writebufr(iocur_top->bp);
+	if (ret != 0)
 		dbprintf(_("write error: %s\n"), strerror(ret));
 
 	/* re-read buffer from disk */
-	ret = read_buf(iocur_top->bb, iocur_top->blen, iocur_top->buf);
-	if (ret == -1)
-		dbprintf(_("incomplete read, block: %lld\n"),
-			 (iocur_base + iocur_sp)->bb);
-	else if (ret != 0)
+	ret = libxfs_readbufr(mp->m_ddev_targp, iocur_top->bb, iocur_top->bp,
+			      iocur_top->blen, 0);
+	if (ret != 0)
 		dbprintf(_("read error: %s\n"), strerror(ret));
 }
 
-static int
-write_bbs(
-	__int64_t       bbno,
-	int             count,
-	void            *bufp,
-	bbmap_t		*bbmap)
-{
-	int		j;
-	int		rval = EINVAL;	/* initialize for zero `count' case */
-
-	for (j = 0; j < count;) {
-		rval = write_buf(bbmap->b[j].bm_bn, bbmap->b[j].bm_len,
-			     (char *)bufp + BBTOB(j));
-		if (rval)
-			break;
-
-		j += bbmap->b[j].bm_len;
-	}
-	return rval;
-}
-
-static int
-read_bbs(
-	__int64_t	bbno,
-	int		count,
-	void		**bufp,
-	bbmap_t		*bbmap)
-{
-	void		*buf;
-	int		j;
-	int		rval = EINVAL;
-
-	if (count <= 0)
-		count = 1;
-
-	if (*bufp == NULL)
-		buf = xmalloc(BBTOB(count));
-	else
-		buf = *bufp;
-	for (j = 0; j < count;) {
-		rval = read_buf(bbmap->b[j].bm_bn, bbmap->b[j].bm_len,
-			     (char *)buf + BBTOB(j));
-		if (rval)
-			break;
-
-		j += bbmap->b[j].bm_len;
-	}
-	if (*bufp == NULL)
-		*bufp = buf;
-	return rval;
-}
-
 static void
 write_cur_bbs(void)
 {
 	int ret;
 
-	ret = write_bbs(iocur_top->bb, iocur_top->blen, iocur_top->buf,
-			&iocur_top->bbmap);
-	if (ret == -1)
-		dbprintf(_("incomplete write, block: %lld\n"),
-			 (iocur_base + iocur_sp)->bb);
-	else if (ret != 0)
+	ret = libxfs_writebufr(iocur_top->bp);
+	if (ret != 0)
 		dbprintf(_("write error: %s\n"), strerror(ret));
 
+
 	/* re-read buffer from disk */
-	ret = read_bbs(iocur_top->bb, iocur_top->blen, &iocur_top->buf,
-		iocur_top->use_bbmap ? &iocur_top->bbmap : NULL);
-	if (ret == -1)
-		dbprintf(_("incomplete read, block: %lld\n"),
-			 (iocur_base + iocur_sp)->bb);
-	else if (ret != 0)
+	ret = libxfs_readbufr_map(mp->m_ddev_targp, iocur_top->bp,
+				  iocur_top->bbmap->b, iocur_top->bbmap->nmaps,
+				  0);
+	if (ret != 0)
 		dbprintf(_("read error: %s\n"), strerror(ret));
 }
 
@@ -554,7 +464,7 @@ write_cur(void)
 		return;
 	}
 
-	if (iocur_top->use_bbmap)
+	if (iocur_top->bbmap)
 		write_cur_bbs();
 	else
 		write_cur_buf();
@@ -568,6 +478,7 @@ set_cur(
 	int             ring_flag,
 	bbmap_t		*bbmap)
 {
+	struct xfs_buf	*bp;
 	xfs_ino_t	dirino;
 	xfs_ino_t	ino;
 	__uint16_t	mode;
@@ -585,23 +496,28 @@ set_cur(
 
 	if (bbmap) {
 #ifdef DEBUG
+		int i;
 		printf(_("xfs_db got a bbmap for %lld\n"), (long long)d);
+		printf(_("\tblock map"));
+		for (i = 0; i < bbmap->nmaps; i++)
+			printf(" %lld:%d", (long long)bbmap->b[i].bm_bn,
+					   bbmap->b[i].bm_len);
+		printf("\n");
 #endif
-
-		if (read_bbs(d, c, &iocur_top->buf, bbmap))
+		iocur_top->bbmap = malloc(sizeof(struct bbmap));
+		if (!iocur_top->bbmap)
 			return;
-		iocur_top->bbmap = *bbmap;
-		iocur_top->use_bbmap = 1;
+		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
+		bp = libxfs_readbuf_map(mp->m_ddev_targp, bbmap->b,
+					bbmap->nmaps, 0, NULL);
 	} else {
-		if (!iocur_top->buf) {
-			iocur_top->buf = malloc(BBTOB(c));
-			if (!iocur_top->buf)
-				return;
-		}
-		if (read_buf(d, c, iocur_top->buf))
-			return;
-		iocur_top->use_bbmap = 0;
+		bp = libxfs_readbuf(mp->m_ddev_targp, d, c, 0, NULL);
+		iocur_top->bbmap = NULL;
 	}
+	if (!bp || bp->b_error)
+		return;
+	iocur_top->buf = bp->b_addr;
+	iocur_top->bp = bp;
 
 	iocur_top->bb = d;
 	iocur_top->blen = c;
diff --git a/db/io.h b/db/io.h
index c7641d5..2c47ccc 100644
--- a/db/io.h
+++ b/db/io.h
@@ -36,8 +36,8 @@ typedef struct iocur {
 	__uint16_t		mode;	/* current inode's mode */
 	xfs_off_t		off;	/* fs offset of "data" in bytes */
 	const struct typ	*typ;	/* type of "data" */
-	int			use_bbmap; /* set if bbmap is valid */
-	bbmap_t			bbmap;	/* map daddr if fragmented */
+	bbmap_t			*bbmap;	/* map daddr if fragmented */
+	struct xfs_buf		*bp;	/* underlying buffer */
 } iocur_t;
 
 #define DB_RING_ADD 1                   /* add to ring on set_cur */
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
