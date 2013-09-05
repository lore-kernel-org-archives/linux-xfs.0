Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7D2647F5E
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 07:13:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6BB4C8F8040
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 05:13:46 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	t3Dk1k7eLQfIbsSC for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 05:13:43 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHYRM-0001GN-KY
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 22:13:36 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHYRM-0004EI-JY
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 22:13:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 03/12] db: rewrite IO engine to use libxfs
Date: Thu,  5 Sep 2013 22:13:24 +1000
Message-Id: <1378383213-16155-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1378383213-16155-1-git-send-email-david@fromorbit.com>
References: <1378383213-16155-1-git-send-email-david@fromorbit.com>
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
 db/bmap.c        |   1 +
 db/init.c        |  25 ++++++--
 db/io.c          | 170 +++++++++++++------------------------------------------
 db/io.h          |   5 +-
 include/libxfs.h |   3 +
 libxfs/init.c    |   5 ++
 libxfs/rdwr.c    |  61 +++++++++++++-------
 7 files changed, 112 insertions(+), 158 deletions(-)

diff --git a/db/bmap.c b/db/bmap.c
index eb5db66..4ac9632 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -299,6 +299,7 @@ make_bbmap(
 		bbmap->b[i].bm_bn = XFS_FSB_TO_DADDR(mp, bmp[i].startblock);
 		bbmap->b[i].bm_bn = XFS_FSB_TO_BB(mp, bmp[i].blockcount);
 	}
+	bbmap->nmaps = nex;
 }
 
 static xfs_fsblock_t
diff --git a/db/init.c b/db/init.c
index 0e88b56..b1cddca 100644
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
@@ -201,6 +212,12 @@ main(
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
index 01a5970..abfbca4 100644
--- a/db/io.c
+++ b/db/io.c
@@ -104,8 +104,12 @@ pop_cur(void)
 		dbprintf(_("can't pop anything from I/O stack\n"));
 		return;
 	}
-	if (iocur_top->buf)
-		xfree(iocur_top->buf);
+	if (iocur_top->bp)
+		libxfs_putbuf(iocur_top->bp);
+	if (iocur_top->bbmap) {
+		free(iocur_top->bbmap);
+		iocur_top->bbmap = NULL;
+	}
 	if (--iocur_sp >= 0) {
 		iocur_top = iocur_base + iocur_sp;
 		cur_typ = iocur_top->typ;
@@ -147,10 +151,11 @@ print_iocur(
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
@@ -238,7 +243,7 @@ push_f(
 	else
 		set_cur(iocur_top[-1].typ, iocur_top[-1].bb,
 			iocur_top[-1].blen, DB_RING_IGN,
-			iocur_top[-1].use_bbmap ? &iocur_top[-1].bbmap : NULL);
+			iocur_top[-1].bbmap);
 
 	/* run requested command */
 	if (argc>1)
@@ -280,8 +285,7 @@ forward_f(
 		iocur_ring[ring_current].bb,
 		iocur_ring[ring_current].blen,
 		DB_RING_IGN,
-		iocur_ring[ring_current].use_bbmap ?
-			&iocur_ring[ring_current].bbmap : NULL);
+		iocur_ring[ring_current].bbmap);
 
 	return 0;
 }
@@ -321,8 +325,7 @@ back_f(
 		iocur_ring[ring_current].bb,
 		iocur_ring[ring_current].blen,
 		DB_RING_IGN,
-		iocur_ring[ring_current].use_bbmap ?
-			&iocur_ring[ring_current].bbmap : NULL);
+		iocur_ring[ring_current].bbmap);
 
 	return 0;
 }
@@ -362,7 +365,7 @@ ring_f(
 		iocur_ring[index].bb,
 		iocur_ring[index].blen,
 		DB_RING_IGN,
-		iocur_ring[index].use_bbmap ? &iocur_ring[index].bbmap : NULL);
+		iocur_ring[index].bbmap);
 
 	return 0;
 }
@@ -417,132 +420,37 @@ ring_add(void)
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
 
@@ -554,7 +462,7 @@ write_cur(void)
 		return;
 	}
 
-	if (iocur_top->use_bbmap)
+	if (iocur_top->bbmap)
 		write_cur_bbs();
 	else
 		write_cur_buf();
@@ -568,6 +476,7 @@ set_cur(
 	int             ring_flag,
 	bbmap_t		*bbmap)
 {
+	struct xfs_buf	*bp;
 	xfs_ino_t	dirino;
 	xfs_ino_t	ino;
 	__uint16_t	mode;
@@ -587,21 +496,20 @@ set_cur(
 #ifdef DEBUG
 		printf(_("xfs_db got a bbmap for %lld\n"), (long long)d);
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
index 0f7c018..2c47ccc 100644
--- a/db/io.h
+++ b/db/io.h
@@ -20,6 +20,7 @@ struct typ;
 
 #define	BBMAP_SIZE		(XFS_MAX_BLOCKSIZE / BBSIZE)
 typedef struct bbmap {
+	int			nmaps;
 	struct xfs_buf_map	b[BBMAP_SIZE];
 } bbmap_t;
 
@@ -35,8 +36,8 @@ typedef struct iocur {
 	__uint16_t		mode;	/* current inode's mode */
 	xfs_off_t		off;	/* fs offset of "data" in bytes */
 	const struct typ	*typ;	/* type of "data" */
-	int			use_bbmap; /* set if bbmap is valid */
-	bbmap_t			bbmap;	/* map daddr if fragmented */
+	bbmap_t			*bbmap;	/* map daddr if fragmented */
+	struct xfs_buf		*bp;	/* underlying buffer */
 } iocur_t;
 
 #define DB_RING_ADD 1                   /* add to ring on set_cur */
diff --git a/include/libxfs.h b/include/libxfs.h
index ffd83bf..bee0663 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -437,7 +437,10 @@ extern xfs_buf_t *libxfs_getbufr(struct xfs_buftarg *, xfs_daddr_t, int);
 extern void	libxfs_putbufr(xfs_buf_t *);
 
 extern int	libxfs_writebuf_int(xfs_buf_t *, int);
+extern int	libxfs_writebufr(struct xfs_buf *);
 extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, xfs_buf_t *, int, int);
+extern int	libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *,
+				    struct xfs_buf_map *, int, int);
 
 extern int libxfs_bhash_size;
 extern int libxfs_ihash_size;
diff --git a/libxfs/init.c b/libxfs/init.c
index db7eeea..229aa50 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -688,6 +688,9 @@ libxfs_mount(
 	libxfs_buftarg_init(mp, dev, logdev, rtdev);
 
 	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
+	if (flags & LIBXFS_MOUNT_ROOTINOS)
+		mp->m_flags |= LIBXFS_MOUNT_ROOTINOS;
+
 	mp->m_sb = *sb;
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
 	sbp = &(mp->m_sb);
@@ -866,6 +869,8 @@ libxfs_umount(xfs_mount_t *mp)
 	int			agno;
 
 	libxfs_rtmount_destroy(mp);
+	if ((mp->m_flags & LIBXFS_MOUNT_ROOTINOS) && mp->m_rootip)
+		libxfs_iput(mp->m_rootip, 0);
 	libxfs_icache_purge();
 	libxfs_bcache_purge();
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 13dbd23..8d8bcfc 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -719,30 +719,18 @@ libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
 	return bp;
 }
 
-struct xfs_buf *
-libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
-		int flags, const struct xfs_buf_ops *ops)
+int
+libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp,
+		    struct xfs_buf_map *map, int nmaps, int flags)
 {
-	xfs_buf_t	*bp;
-	int		error = 0;
-	int		fd;
-	int		i;
-	char		*buf;
-
-	if (nmaps == 1)
-		return libxfs_readbuf(btp, map[0].bm_bn, map[0].bm_len,
-					flags, ops);
-
-	bp = libxfs_getbuf_map(btp, map, nmaps);
-	if (!bp)
-		return NULL;
+	int	fd = libxfs_device_to_fd(btp->dev);
+	int	error = 0;
+	char	*buf;
+	int	i;
 
-	bp->b_error = 0;
-	bp->b_ops = ops;
-	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY)))
-		return bp;
+	ASSERT(BBTOB(len) <= bp->b_bcount);
 
-	ASSERT(bp->b_nmaps = nmaps);
+	ASSERT(bp->b_nmaps == nmaps);
 
 	fd = libxfs_device_to_fd(btp->dev);
 	buf = bp->b_addr;
@@ -762,6 +750,37 @@ libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 		offset += len;
 	}
 
+	if (!error);
+		bp->b_flags |= LIBXFS_B_UPTODATE;
+#ifdef IO_DEBUG
+	printf("%lx: %s: read %u bytes, error %d, blkno=0x%llx(0x%llx), %p\n",
+		pthread_self(), __FUNCTION__, , error,
+		(long long)LIBXFS_BBTOOFF64(blkno), (long long)blkno, bp);
+#endif
+	return error;
+}
+
+struct xfs_buf *
+libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
+		int flags, const struct xfs_buf_ops *ops)
+{
+	struct xfs_buf	*bp;
+	int		error = 0;
+
+	if (nmaps == 1)
+		return libxfs_readbuf(btp, map[0].bm_bn, map[0].bm_len,
+					flags, ops);
+
+	bp = libxfs_getbuf_map(btp, map, nmaps);
+	if (!bp)
+		return NULL;
+
+	bp->b_error = 0;
+	bp->b_ops = ops;
+	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY)))
+		return bp;
+
+	error = libxfs_readbufr_map(btp, bp, map, nmaps, flags);
 	if (!error) {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
 		if (bp->b_ops)
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
