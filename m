Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88C2A7F9F
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:26:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 77373304089
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:26:51 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	rMIow4C78C5BPXFH for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:46 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkVn-0003vF-Sr
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:35 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVm-0001LB-Hc
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 22/48] xfsprogs: Add verifiers to libxfs buffer interfaces.
Date: Fri,  7 Jun 2013 10:25:45 +1000
Message-Id: <1370564771-4929-23-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

Verifiers need to be used everywhere to enable calculation of CRCs
during writeback of modified metadata. Add then to the libxfs buffer
interfaces conver the internal use of devices to be buftarg aware.

Verifiers also require that the buffer has a back pointer to the
struct xfs_mount. To make this source level comaptible between
kernel and userspace, convert userspace to pass struct xfs_buftargs
around rather than a "device".

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 copy/xfs_copy.c        |    4 +-
 db/sb.c                |    8 +-
 include/libxfs.h       |   96 ++++++++++++++----------
 include/libxlog.h      |    2 +-
 include/xfs_dir2.h     |    7 ++
 libxfs/init.c          |   84 ++++++++++++++++++---
 libxfs/logitem.c       |    4 +-
 libxfs/rdwr.c          |  195 ++++++++++++++++++++++++++++++++----------------
 libxfs/trans.c         |   16 ++--
 libxfs/xfs.h           |   11 +--
 libxfs/xfs_dir2_priv.h |    8 --
 logprint/logprint.c    |    4 +-
 mkfs/proto.c           |    4 +-
 mkfs/xfs_mkfs.c        |   56 ++++++++------
 repair/attr_repair.c   |   10 +--
 repair/dino_chunks.c   |    8 +-
 repair/dinode.c        |   10 ++-
 repair/dir2.c          |   15 ++--
 repair/phase2.c        |    7 +-
 repair/phase3.c        |    2 +-
 repair/phase6.c        |   13 ++--
 repair/prefetch.c      |    4 +-
 repair/rt.c            |    4 +-
 repair/scan.c          |   15 ++--
 repair/xfs_repair.c    |    6 +-
 25 files changed, 381 insertions(+), 212 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 7f65de3..39517da 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -674,8 +674,10 @@ main(int argc, char **argv)
 
 	/* prepare the mount structure */
 
-	sbp = libxfs_readbuf(xargs.ddev, XFS_SB_DADDR, 1, 0);
 	memset(&mbuf, 0, sizeof(xfs_mount_t));
+	libxfs_buftarg_init(&mbuf, xargs.ddev, xargs.logdev, xargs.rtdev);
+	sbp = libxfs_readbuf(mbuf.m_ddev_targp, XFS_SB_DADDR, 1, 0,
+							&xfs_sb_buf_ops);
 	sb = &mbuf.m_sb;
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
 
diff --git a/db/sb.c b/db/sb.c
index 4da1f6a..54ca7dd 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -231,15 +231,14 @@ sb_logcheck(void)
 	}
 
 	memset(&log, 0, sizeof(log));
-	if (!x.logdev)
-		x.logdev = x.ddev;
+	libxfs_buftarg_init(mp, x.ddev, x.logdev, x.rtdev);
 	x.logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 	x.logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
 	x.lbsize = BBSIZE;
 	if (xfs_sb_version_hassector(&mp->m_sb))
 		x.lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
 
-	log.l_dev = (mp->m_sb.sb_logstart == 0) ? x.logdev : x.ddev;
+	log.l_dev = mp->m_logdev_targp;
 	log.l_logsize = BBTOB(log.l_logBBsize);
 	log.l_logBBsize = x.logBBsize;
 	log.l_logBBstart = x.logBBstart;
@@ -271,8 +270,7 @@ sb_logzero(uuid_t *uuidp)
 
 	dbprintf(_("Clearing log and setting UUID\n"));
 
-	if (libxfs_log_clear(
-			(mp->m_sb.sb_logstart == 0) ? x.logdev : x.ddev,
+	if (libxfs_log_clear(mp->m_logdev_targp,
 			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
 			(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
 			uuidp,
diff --git a/include/libxfs.h b/include/libxfs.h
index 972d850..d5131c1 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -116,12 +116,25 @@ typedef struct {
 #define LIBXFS_EXCLUSIVELY	0x0010	/* disallow other accesses (O_EXCL) */
 #define LIBXFS_DIRECT		0x0020	/* can use direct I/O, not buffered */
 
+/*
+ * IO verifier callbacks need the xfs_mount pointer, so we have to behave
+ * somewhat like the kernel now for userspace IO in terms of having buftarg
+ * based devices...
+ */
+struct xfs_buftarg {
+	struct xfs_mount	*bt_mount;
+	dev_t			dev;
+};
+
+extern void	libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
+				    dev_t logdev, dev_t rtdev);
+
 extern char	*progname;
 extern int	libxfs_init (libxfs_init_t *);
 extern void	libxfs_destroy (void);
 extern int	libxfs_device_to_fd (dev_t);
 extern dev_t	libxfs_device_open (char *, int, int, int);
-extern void	libxfs_device_zero (dev_t, xfs_daddr_t, uint);
+extern void	libxfs_device_zero(struct xfs_buftarg *, xfs_daddr_t, uint);
 extern void	libxfs_device_close (dev_t);
 extern int	libxfs_device_alignment (void);
 extern void	libxfs_report(FILE *);
@@ -130,11 +143,12 @@ extern void	platform_findsizes(char *path, int fd, long long *sz, int *bsz);
 /* check or write log footer: specify device, log size in blocks & uuid */
 typedef xfs_caddr_t (libxfs_get_block_t)(xfs_caddr_t, int, void *);
 
-extern int	libxfs_log_clear (dev_t, xfs_daddr_t, uint, uuid_t *,
-				int, int, int);
+extern int	libxfs_log_clear (struct xfs_buftarg *, xfs_daddr_t, uint,
+				uuid_t *, int, int, int);
 extern int	libxfs_log_header (xfs_caddr_t, uuid_t *, int, int, int,
 				libxfs_get_block_t *, void *);
 
+
 /*
  * Define a user-level mount structure with all we need
  * in order to make use of the numerous XFS_* macros.
@@ -151,9 +165,12 @@ typedef struct xfs_mount {
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
-	dev_t			m_dev;
-	dev_t			m_logdev;
-	dev_t			m_rtdev;
+	struct xfs_buftarg	*m_ddev_targp;
+	struct xfs_buftarg	*m_logdev_targp;
+	struct xfs_buftarg	*m_rtdev_targp;
+#define m_dev		m_ddev_targp
+#define m_logdev	m_logdev_targp
+#define m_rtdev		m_rtdev_targp
 	__uint8_t		m_dircook_elog;	/* log d-cookie entry bits */
 	__uint8_t		m_blkbit_log;	/* blocklog + NBBY */
 	__uint8_t		m_blkbb_log;	/* blocklog - BBSHIFT */
@@ -218,11 +235,6 @@ extern void	libxfs_rtmount_destroy (xfs_mount_t *);
 /*
  * Simple I/O interface
  */
-typedef struct xfs_buftarg {
-	struct xfs_mount	*bt_mount;
-	dev_t			dev;
-} xfs_buftarg_t;
-
 #define XB_PAGES        2
 
 struct xfs_buf_map {
@@ -244,7 +256,8 @@ typedef struct xfs_buf {
 	xfs_daddr_t		b_bn;
 	unsigned		b_bcount;
 	unsigned int		b_length;
-	dev_t			b_dev;
+	struct xfs_buftarg	*b_target;
+#define b_dev		b_target->dev
 	pthread_mutex_t		b_lock;
 	pthread_t		b_holder;
 	unsigned int		b_recur;
@@ -254,7 +267,6 @@ typedef struct xfs_buf {
 	void			*b_addr;
 	int			b_error;
 	const struct xfs_buf_ops *b_ops;
-	struct xfs_buftarg	*b_target;
 	struct xfs_perag	*b_pag;
 	struct xfs_buf_map	*b_map;
 	int			b_nmaps;
@@ -315,12 +327,12 @@ extern struct cache_operations	libxfs_bcache_operations;
 
 #ifdef XFS_BUF_TRACING
 
-#define libxfs_readbuf(dev, daddr, len, flags) \
+#define libxfs_readbuf(dev, daddr, len, flags, ops) \
 	libxfs_trace_readbuf(__FUNCTION__, __FILE__, __LINE__, \
-			    (dev), (daddr), (len), (flags))
-#define libxfs_readbuf_map(dev, map, nmaps, flags) \
+			    (dev), (daddr), (len), (flags), (ops))
+#define libxfs_readbuf_map(dev, map, nmaps, flags, ops) \
 	libxfs_trace_readbuf_map(__FUNCTION__, __FILE__, __LINE__, \
-			    (dev), (map), (nmaps), (flags))
+			    (dev), (map), (nmaps), (flags), (ops))
 #define libxfs_writebuf(buf, flags) \
 	libxfs_trace_writebuf(__FUNCTION__, __FILE__, __LINE__, \
 			      (buf), (flags))
@@ -337,28 +349,34 @@ extern struct cache_operations	libxfs_bcache_operations;
 	libxfs_trace_putbuf(__FUNCTION__, __FILE__, __LINE__, (buf))
 
 extern xfs_buf_t *libxfs_trace_readbuf(const char *, const char *, int,
-			dev_t, xfs_daddr_t, int, int);
+			struct xfs_buftarg *, xfs_daddr_t, int, int,
+			const struct xfs_buf_ops *);
 extern xfs_buf_t *libxfs_trace_readbuf_map(const char *, const char *, int,
-			dev_t, struct xfs_buf_map *, int, int);
+			struct xfs_buftarg *, struct xfs_buf_map *, int, int,
+			const struct xfs_buf_ops *);
 extern int	libxfs_trace_writebuf(const char *, const char *, int,
 			xfs_buf_t *, int);
 extern xfs_buf_t *libxfs_trace_getbuf(const char *, const char *, int,
-			dev_t, xfs_daddr_t, int);
+			struct xfs_buftarg *, xfs_daddr_t, int);
 extern xfs_buf_t *libxfs_trace_getbuf_map(const char *, const char *, int,
-			dev_t, struct xfs_buf_map *, int);
+			struct xfs_buftarg *, struct xfs_buf_map *, int);
 extern xfs_buf_t *libxfs_trace_getbuf_flags(const char *, const char *, int,
-			dev_t, xfs_daddr_t, int, unsigned int);
+			struct xfs_buftarg *, xfs_daddr_t, int, unsigned int);
 extern void	libxfs_trace_putbuf (const char *, const char *, int,
 			xfs_buf_t *);
 
 #else
 
-extern xfs_buf_t *libxfs_readbuf(dev_t, xfs_daddr_t, int, int);
-extern xfs_buf_t *libxfs_readbuf_map(dev_t, struct xfs_buf_map *, int, int);
+extern xfs_buf_t *libxfs_readbuf(struct xfs_buftarg *, xfs_daddr_t, int, int,
+			const struct xfs_buf_ops *);
+extern xfs_buf_t *libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
+			int, int, const struct xfs_buf_ops *);
 extern int	libxfs_writebuf(xfs_buf_t *, int);
-extern xfs_buf_t *libxfs_getbuf(dev_t, xfs_daddr_t, int);
-extern xfs_buf_t *libxfs_getbuf_map(dev_t, struct xfs_buf_map *, int);
-extern xfs_buf_t *libxfs_getbuf_flags(dev_t, xfs_daddr_t, int, unsigned int);
+extern xfs_buf_t *libxfs_getbuf(struct xfs_buftarg *, xfs_daddr_t, int);
+extern xfs_buf_t *libxfs_getbuf_map(struct xfs_buftarg *,
+			struct xfs_buf_map *, int);
+extern xfs_buf_t *libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t,
+			int, unsigned int);
 extern void	libxfs_putbuf (xfs_buf_t *);
 
 #endif
@@ -371,11 +389,11 @@ extern int	libxfs_bcache_overflowed(void);
 extern int	libxfs_bcache_usage(void);
 
 /* Buffer (Raw) Interfaces */
-extern xfs_buf_t *libxfs_getbufr(dev_t, xfs_daddr_t, int);
+extern xfs_buf_t *libxfs_getbufr(struct xfs_buftarg *, xfs_daddr_t, int);
 extern void	libxfs_putbufr(xfs_buf_t *);
 
 extern int	libxfs_writebuf_int(xfs_buf_t *, int);
-extern int	libxfs_readbufr(dev_t, xfs_daddr_t, xfs_buf_t *, int, int);
+extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, xfs_buf_t *, int, int);
 
 extern int libxfs_bhash_size;
 extern int libxfs_ihash_size;
@@ -461,24 +479,26 @@ extern int	libxfs_trans_read_buf (xfs_mount_t *, xfs_trans_t *, dev_t,
 				xfs_daddr_t, int, uint, struct xfs_buf **);
 */
 
-struct xfs_buf	*libxfs_trans_get_buf_map(struct xfs_trans *tp, dev_t dev,
-				       struct xfs_buf_map *map, int nmaps,
-				       uint flags);
+struct xfs_buf	*libxfs_trans_get_buf_map(struct xfs_trans *tp,
+					struct xfs_buftarg *btp,
+					struct xfs_buf_map *map, int nmaps,
+					uint flags);
 
 static inline struct xfs_buf *
 libxfs_trans_get_buf(
 	struct xfs_trans	*tp,
-	dev_t			dev,
+	struct xfs_buftarg	*btp,
 	xfs_daddr_t		blkno,
 	int			numblks,
 	uint			flags)
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return libxfs_trans_get_buf_map(tp, dev, &map, 1, flags);
+	return libxfs_trans_get_buf_map(tp, btp, &map, 1, flags);
 }
 
 int		libxfs_trans_read_buf_map(struct xfs_mount *mp,
-				       struct xfs_trans *tp, dev_t dev,
+				       struct xfs_trans *tp,
+				       struct xfs_buftarg *btp,
 				       struct xfs_buf_map *map, int nmaps,
 				       uint flags, struct xfs_buf **bpp,
 				       const struct xfs_buf_ops *ops);
@@ -487,7 +507,7 @@ static inline int
 libxfs_trans_read_buf(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	dev_t			dev,
+	struct xfs_buftarg	*btp,
 	xfs_daddr_t		blkno,
 	int			numblks,
 	uint			flags,
@@ -495,7 +515,7 @@ libxfs_trans_read_buf(
 	const struct xfs_buf_ops *ops)
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return libxfs_trans_read_buf_map(mp, tp, dev, &map, 1,
+	return libxfs_trans_read_buf_map(mp, tp, btp, &map, 1,
 				      flags, bpp, ops);
 }
 
@@ -507,7 +527,7 @@ typedef struct xfs_inode {
 	xfs_mount_t		*i_mount;	/* fs mount struct ptr */
 	xfs_ino_t		i_ino;		/* inode number (agno/agino) */
 	struct xfs_imap		i_imap;		/* location for xfs_imap() */
-	dev_t			i_dev;		/* dev for this inode */
+	struct xfs_buftarg			i_dev;		/* dev for this inode */
 	xfs_ifork_t		*i_afp;		/* attribute fork pointer */
 	xfs_ifork_t		i_df;		/* data fork */
 	xfs_trans_t		*i_transp;	/* ptr to owning transaction */
diff --git a/include/libxlog.h b/include/libxlog.h
index 36ede59..b101a6e 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -28,7 +28,7 @@ struct xlog {
 	xfs_lsn_t	l_tail_lsn;     /* lsn of 1st LR w/ unflush buffers */
 	xfs_lsn_t	l_last_sync_lsn;/* lsn of last LR on disk */
 	xfs_mount_t	*l_mp;	        /* mount point */
-	dev_t		l_dev;	        /* dev_t of log */
+	struct xfs_buftarg *l_dev;	        /* dev_t of log */
 	xfs_daddr_t	l_logBBstart;   /* start block of log */
 	int		l_logsize;      /* size of log in bytes */
 	int		l_logBBsize;    /* size of log in 512 byte chunks */
diff --git a/include/xfs_dir2.h b/include/xfs_dir2.h
index 8ab59b5..75e8596 100644
--- a/include/xfs_dir2.h
+++ b/include/xfs_dir2.h
@@ -104,4 +104,11 @@ extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
 extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
 		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_unused *dup);
 
+extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
+extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
+extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
+extern const struct xfs_buf_ops xfs_dir3_free_buf_ops;
+extern const struct xfs_buf_ops xfs_dir3_data_buf_ops;
+
+
 #endif	/* __XFS_DIR2_H__ */
diff --git a/libxfs/init.c b/libxfs/init.c
index 71da69b..e62f26a 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -457,7 +457,7 @@ rtmount_init(
 	sbp = &mp->m_sb;
 	if (sbp->sb_rblocks == 0)
 		return 0;
-	if (mp->m_rtdev == 0 && !(flags & LIBXFS_MOUNT_DEBUGGER)) {
+	if (mp->m_rtdev_targp->dev == 0 && !(flags & LIBXFS_MOUNT_DEBUGGER)) {
 		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
 			progname);
 		return -1;
@@ -486,7 +486,7 @@ rtmount_init(
 		return -1;
 	}
 	bp = libxfs_readbuf(mp->m_rtdev,
-			d - XFS_FSB_TO_BB(mp, 1), XFS_FSB_TO_BB(mp, 1), 0);
+			d - XFS_FSB_TO_BB(mp, 1), XFS_FSB_TO_BB(mp, 1), 0, NULL);
 	if (bp == NULL) {
 		fprintf(stderr, _("%s: realtime size check failed\n"),
 			progname);
@@ -599,6 +599,72 @@ out_unwind:
 	return error;
 }
 
+static struct xfs_buftarg *
+libxfs_buftarg_alloc(
+	struct xfs_mount	*mp,
+	dev_t			dev)
+{
+	struct xfs_buftarg	*btp;
+
+	btp = malloc(sizeof(*btp));
+	if (!btp) {
+		fprintf(stderr, _("%s: buftarg init failed\n"),
+			progname);
+		exit(1);
+	}
+	btp->bt_mount = mp;
+	btp->dev = dev;
+	return btp;
+}
+
+void
+libxfs_buftarg_init(
+	struct xfs_mount	*mp,
+	dev_t			dev,
+	dev_t			logdev,
+	dev_t			rtdev)
+{
+	if (mp->m_ddev_targp) {
+		/* should already have all buftargs initialised */
+		if (mp->m_ddev_targp->dev != dev ||
+		    mp->m_ddev_targp->bt_mount != mp) {
+			fprintf(stderr,
+				_("%s: bad buftarg reinit, ddev\n"),
+				progname);
+			exit(1);
+		}
+		if (!logdev || logdev == dev) {
+			if (mp->m_logdev_targp != mp->m_ddev_targp) {
+				fprintf(stderr,
+				_("%s: bad buftarg reinit, ldev mismatch\n"),
+					progname);
+				exit(1);
+			}
+		} else if (mp->m_logdev_targp->dev != logdev ||
+			   mp->m_logdev_targp->bt_mount != mp) {
+			fprintf(stderr,
+				_("%s: bad buftarg reinit, logdev\n"),
+				progname);
+			exit(1);
+		}
+		if (rtdev && (mp->m_rtdev_targp->dev != rtdev ||
+			      mp->m_rtdev_targp->bt_mount != mp)) {
+			fprintf(stderr,
+				_("%s: bad buftarg reinit, rtdev\n"),
+				progname);
+			exit(1);
+		}
+		return;
+	}
+
+	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, dev);
+	if (!logdev || logdev == dev)
+		mp->m_logdev_targp = mp->m_ddev_targp;
+	else
+		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, logdev);
+	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, rtdev);
+}
+
 /*
  * Mount structure initialization, provides a filled-in xfs_mount_t
  * such that the numerous XFS_* macros can be used.  If dev is zero,
@@ -618,9 +684,8 @@ libxfs_mount(
 	xfs_sb_t	*sbp;
 	int		error;
 
-	mp->m_dev = dev;
-	mp->m_rtdev = rtdev;
-	mp->m_logdev = logdev;
+	libxfs_buftarg_init(mp, dev, logdev, rtdev);
+
 	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
 	mp->m_sb = *sb;
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
@@ -705,7 +770,7 @@ libxfs_mount(
 
 	bp = libxfs_readbuf(mp->m_dev,
 			d - XFS_FSS_TO_BB(mp, 1), XFS_FSS_TO_BB(mp, 1),
-			!(flags & LIBXFS_MOUNT_DEBUGGER));
+			!(flags & LIBXFS_MOUNT_DEBUGGER), NULL);
 	if (!bp) {
 		fprintf(stderr, _("%s: data size check failed\n"), progname);
 		if (!(flags & LIBXFS_MOUNT_DEBUGGER))
@@ -713,13 +778,14 @@ libxfs_mount(
 	} else
 		libxfs_putbuf(bp);
 
-	if (mp->m_logdev && mp->m_logdev != mp->m_dev) {
+	if (mp->m_logdev_targp->dev &&
+	    mp->m_logdev_targp->dev != mp->m_ddev_targp->dev) {
 		d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 		if ( (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) ||
-		     (!(bp = libxfs_readbuf(mp->m_logdev,
+		     (!(bp = libxfs_readbuf(mp->m_logdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
 					XFS_FSB_TO_BB(mp, 1),
-					!(flags & LIBXFS_MOUNT_DEBUGGER)))) ) {
+					!(flags & LIBXFS_MOUNT_DEBUGGER), NULL))) ) {
 			fprintf(stderr, _("%s: log size checks failed\n"),
 					progname);
 			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 84e4c14..73d5a9e 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -32,7 +32,7 @@ kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
 xfs_buf_t *
 xfs_trans_buf_item_match(
 	xfs_trans_t		*tp,
-	dev_t			dev,
+	struct xfs_buftarg	*btp,
 	struct xfs_buf_map	*map,
 	int			nmaps)
 {
@@ -47,7 +47,7 @@ xfs_trans_buf_item_match(
         list_for_each_entry(lidp, &tp->t_items, lid_trans) {
                 blip = (struct xfs_buf_log_item *)lidp->lid_item;
                 if (blip->bli_item.li_type == XFS_LI_BUF &&
-		    blip->bli_buf->b_dev == dev &&
+		    blip->bli_buf->b_target->dev == btp->dev &&
 		    XFS_BUF_ADDR(blip->bli_buf) == map[0].bm_bn &&
 		    blip->bli_buf->b_bcount == BBTOB(len)) {
 			ASSERT(blip->bli_buf->b_map_count == nmaps);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index e9cc7b1..f91a5d0 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -27,7 +27,7 @@
 #define IO_BCOMPARE_CHECK
 
 void
-libxfs_device_zero(dev_t dev, xfs_daddr_t start, uint len)
+libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 {
 	xfs_off_t	start_offset, end_offset, offset;
 	ssize_t		zsize, bytes;
@@ -43,7 +43,7 @@ libxfs_device_zero(dev_t dev, xfs_daddr_t start, uint len)
 	}
 	memset(z, 0, zsize);
 
-	fd = libxfs_device_to_fd(dev);
+	fd = libxfs_device_to_fd(btp->dev);
 	start_offset = LIBXFS_BBTOOFF64(start);
 
 	if ((lseek64(fd, start_offset, SEEK_SET)) < 0) {
@@ -102,7 +102,7 @@ static xfs_caddr_t next(xfs_caddr_t ptr, int offset, void *private)
 
 int
 libxfs_log_clear(
-	dev_t			device,
+	struct xfs_buftarg	*btp,
 	xfs_daddr_t		start,
 	uint			length,
 	uuid_t			*fs_uuid,
@@ -113,16 +113,16 @@ libxfs_log_clear(
 	xfs_buf_t		*bp;
 	int			len;
 
-	if (!device || !fs_uuid)
+	if (!btp->dev || !fs_uuid)
 		return -EINVAL;
 
 	/* first zero the log */
-	libxfs_device_zero(device, start, length);
+	libxfs_device_zero(btp, start, length);
 
 	/* then write a log record header */
 	len = ((version == 2) && sunit) ? BTOBB(sunit) : 2;
 	len = MAX(len, 2);
-	bp = libxfs_getbufr(device, start, len);
+	bp = libxfs_getbufr(btp, start, len);
 	libxfs_log_header(XFS_BUF_PTR(bp),
 			  fs_uuid, version, sunit, fmt, next, bp);
 	bp->b_flags |= LIBXFS_B_DIRTY;
@@ -200,12 +200,15 @@ libxfs_log_header(
 #undef libxfs_getbuf_flags
 #undef libxfs_putbuf
 
-xfs_buf_t	*libxfs_readbuf(dev_t, xfs_daddr_t, int, int);
-xfs_buf_t	*libxfs_readbuf_map(dev_t, struct xfs_buf_map *, int, int);
+xfs_buf_t	*libxfs_readbuf(struct xfs_buftarg *, xfs_daddr_t, int, int,
+				const struct xfs_buf_map *);
+xfs_buf_t	*libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
+				int, int, const struct xfs_buf_map *);
 int		libxfs_writebuf(xfs_buf_t *, int);
-xfs_buf_t	*libxfs_getbuf(dev_t, xfs_daddr_t, int);
-xfs_buf_t	*libxfs_getbuf_map(dev_t, struct xfs_buf_map *, int);
-xfs_buf_t	*libxfs_getbuf_flags(dev_t, xfs_daddr_t, int, unsigned int);
+xfs_buf_t	*libxfs_getbuf(struct xfs_buftarg *, xfs_daddr_t, int);
+xfs_buf_t	*libxfs_getbuf_map(struct xfs_buftarg *, struct xfs_buf_map *, int);
+xfs_buf_t	*libxfs_getbuf_flags(struct xfs_buftarg *, xfs_daddr_t, int,
+				unsigned int);
 void		libxfs_putbuf (xfs_buf_t *);
 
 #define	__add_trace(bp, func, file, line)	\
@@ -219,18 +222,20 @@ do {						\
 
 xfs_buf_t *
 libxfs_trace_readbuf(const char *func, const char *file, int line,
-		dev_t dev, xfs_daddr_t blkno, int len, int flags)
+		struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
+		const struct xfs_buf_ops *ops)
 {
-	xfs_buf_t	*bp = libxfs_readbuf(dev, blkno, len, flags);
+	xfs_buf_t	*bp = libxfs_readbuf(btp, blkno, len, flags, ops);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
 
 xfs_buf_t *
 libxfs_trace_readbuf_map(const char *func, const char *file, int line,
-		dev_t dev, struct xfs_buf_map *map, int nmaps, int flags)
+		struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps, int flags,
+		const struct xfs_buf_ops *ops)
 {
-	xfs_buf_t	*bp = libxfs_readbuf_map(dev, map, nmaps, flags);
+	xfs_buf_t	*bp = libxfs_readbuf_map(btp, map, nmaps, flags, ops);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
@@ -244,27 +249,27 @@ libxfs_trace_writebuf(const char *func, const char *file, int line, xfs_buf_t *b
 
 xfs_buf_t *
 libxfs_trace_getbuf(const char *func, const char *file, int line,
-		dev_t device, xfs_daddr_t blkno, int len)
+		struct xfs_buftarg *btp, xfs_daddr_t blkno, int len)
 {
-	xfs_buf_t	*bp = libxfs_getbuf(device, blkno, len);
+	xfs_buf_t	*bp = libxfs_getbuf(btp, blkno, len);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
 
 xfs_buf_t *
 libxfs_trace_getbuf_map(const char *func, const char *file, int line,
-		dev_t device, struct xfs_buf_map *map, int nmaps)
+		struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps)
 {
-	xfs_buf_t	*bp = libxfs_getbuf_map(device, map, nmaps);
+	xfs_buf_t	*bp = libxfs_getbuf_map(btp, map, nmaps);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
 
 xfs_buf_t *
 libxfs_trace_getbuf_flags(const char *func, const char *file, int line,
-		dev_t device, xfs_daddr_t blkno, int len, unsigned int flags)
+		struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, unsigned int flags)
 {
-	xfs_buf_t	*bp = libxfs_getbuf_flags(device, blkno, len, flags);
+	xfs_buf_t	*bp = libxfs_getbuf_flags(btp, blkno, len, flags);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
@@ -283,8 +288,8 @@ libxfs_trace_putbuf(const char *func, const char *file, int line, xfs_buf_t *bp)
 xfs_buf_t *
 libxfs_getsb(xfs_mount_t *mp, int flags)
 {
-	return libxfs_readbuf(mp->m_dev, XFS_SB_DADDR,
-				XFS_FSS_TO_BB(mp, 1), flags);
+	return libxfs_readbuf(mp->m_ddev_targp, XFS_SB_DADDR,
+				XFS_FSS_TO_BB(mp, 1), flags, &xfs_sb_buf_ops);
 }
 
 kmem_zone_t			*xfs_buf_zone;
@@ -302,7 +307,7 @@ static struct cache_mru		xfs_buf_freelist =
  * buffer initialisation instead of a contiguous buffer.
  */
 struct xfs_bufkey {
-	dev_t			device;
+	struct xfs_buftarg	*buftarg;
 	xfs_daddr_t		blkno;
 	unsigned int		bblen;
 	struct xfs_buf_map	*map;
@@ -322,7 +327,7 @@ libxfs_bcompare(struct cache_node *node, cache_key_t key)
 	struct xfs_bufkey *bkey = (struct xfs_bufkey *)key;
 
 #ifdef IO_BCOMPARE_CHECK
-	if (bp->b_dev == bkey->device &&
+	if (bp->b_target->dev == bkey->buftarg->dev &&
 	    bp->b_bn == bkey->blkno &&
 	    bp->b_bcount != BBTOB(bkey->bblen))
 		fprintf(stderr, "%lx: Badness in key lookup (length)\n"
@@ -332,7 +337,7 @@ libxfs_bcompare(struct cache_node *node, cache_key_t key)
 			(unsigned long long)bkey->blkno, BBTOB(bkey->bblen));
 #endif
 
-	return (bp->b_dev == bkey->device &&
+	return (bp->b_target->dev == bkey->buftarg->dev &&
 		bp->b_bn == bkey->blkno &&
 		bp->b_bcount == BBTOB(bkey->bblen));
 }
@@ -346,13 +351,14 @@ libxfs_bprint(xfs_buf_t *bp)
 }
 
 static void
-__initbuf(xfs_buf_t *bp, dev_t device, xfs_daddr_t bno, unsigned int bytes)
+__initbuf(xfs_buf_t *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
+		unsigned int bytes)
 {
 	bp->b_flags = 0;
 	bp->b_bn = bno;
 	bp->b_bcount = bytes;
 	bp->b_length = BTOBB(bytes);
-	bp->b_dev = device;
+	bp->b_target = btp;
 	bp->b_error = 0;
 	if (!bp->b_addr)
 		bp->b_addr = memalign(libxfs_device_alignment(), bytes);
@@ -369,16 +375,19 @@ __initbuf(xfs_buf_t *bp, dev_t device, xfs_daddr_t bno, unsigned int bytes)
 	pthread_mutex_init(&bp->b_lock, NULL);
 	bp->b_holder = 0;
 	bp->b_recur = 0;
+	bp->b_ops = NULL;
 }
 
 static void
-libxfs_initbuf(xfs_buf_t *bp, dev_t device, xfs_daddr_t bno, unsigned int bytes)
+libxfs_initbuf(xfs_buf_t *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
+		unsigned int bytes)
 {
-	__initbuf(bp, device, bno, bytes);
+	__initbuf(bp, btp, bno, bytes);
 }
 
 static void
-libxfs_initbuf_map(xfs_buf_t *bp, dev_t device, struct xfs_buf_map *map, int nmaps)
+libxfs_initbuf_map(xfs_buf_t *bp, struct xfs_buftarg *btp,
+		struct xfs_buf_map *map, int nmaps)
 {
 	unsigned int bytes = 0;
 	int i;
@@ -401,7 +410,7 @@ libxfs_initbuf_map(xfs_buf_t *bp, dev_t device, struct xfs_buf_map *map, int nma
 		bytes += BBTOB(map[i].bm_len);
 	}
 
-	__initbuf(bp, device, map[0].bm_bn, bytes);
+	__initbuf(bp, btp, map[0].bm_bn, bytes);
 	bp->b_flags |= LIBXFS_B_DISCONTIG;
 }
 
@@ -441,14 +450,14 @@ __libxfs_getbufr(int blen)
 }
 
 xfs_buf_t *
-libxfs_getbufr(dev_t device, xfs_daddr_t blkno, int bblen)
+libxfs_getbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen)
 {
 	xfs_buf_t	*bp;
 	int		blen = BBTOB(bblen);
 
 	bp =__libxfs_getbufr(blen);
 	if (bp)
-		libxfs_initbuf(bp, device, blkno, blen);
+		libxfs_initbuf(bp, btp, blkno, blen);
 #ifdef IO_DEBUG
 	printf("%lx: %s: allocated %u bytes buffer, key=0x%llx(0x%llx), %p\n",
 		pthread_self(), __FUNCTION__, blen,
@@ -459,7 +468,7 @@ libxfs_getbufr(dev_t device, xfs_daddr_t blkno, int bblen)
 }
 
 xfs_buf_t *
-libxfs_getbufr_map(dev_t device, xfs_daddr_t blkno, int bblen,
+libxfs_getbufr_map(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen,
 		struct xfs_buf_map *map, int nmaps)
 {
 	xfs_buf_t	*bp;
@@ -481,7 +490,7 @@ libxfs_getbufr_map(dev_t device, xfs_daddr_t blkno, int bblen,
 
 	bp =__libxfs_getbufr(blen);
 	if (bp)
-		libxfs_initbuf_map(bp, device, map, nmaps);
+		libxfs_initbuf_map(bp, btp, map, nmaps);
 #ifdef IO_DEBUG
 	printf("%lx: %s: allocated %u bytes buffer, key=0x%llx(0x%llx), %p\n",
 		pthread_self(), __FUNCTION__, blen,
@@ -552,11 +561,12 @@ out_put:
 }
 
 struct xfs_buf *
-libxfs_getbuf_flags(dev_t device, xfs_daddr_t blkno, int len, unsigned int flags)
+libxfs_getbuf_flags(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len,
+		unsigned int flags)
 {
 	struct xfs_bufkey key = {0};
 
-	key.device = device;
+	key.buftarg = btp;
 	key.blkno = blkno;
 	key.bblen = len;
 
@@ -564,18 +574,18 @@ libxfs_getbuf_flags(dev_t device, xfs_daddr_t blkno, int len, unsigned int flags
 }
 
 struct xfs_buf *
-libxfs_getbuf(dev_t device, xfs_daddr_t blkno, int len)
+libxfs_getbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len)
 {
-	return libxfs_getbuf_flags(device, blkno, len, 0);
+	return libxfs_getbuf_flags(btp, blkno, len, 0);
 }
 
 struct xfs_buf *
-libxfs_getbuf_map(dev_t device, struct xfs_buf_map *map, int nmaps)
+libxfs_getbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps)
 {
 	struct xfs_bufkey key = {0};
 	int i;
 
-	key.device = device;
+	key.buftarg = btp;
 	key.blkno = map[0].bm_bn;
 	for (i = 0; i < nmaps; i++) {
 		key.bblen += map[i].bm_len;
@@ -612,9 +622,9 @@ libxfs_purgebuf(xfs_buf_t *bp)
 {
 	struct xfs_bufkey key = {0};
 
-	key.device = bp->b_dev;
+	key.buftarg = bp->b_target;
 	key.blkno = bp->b_bn;
-	key.bblen = bp->b_bcount >> BBSHIFT;
+	key.bblen = bp->b_length;
 
 	cache_node_purge(libxfs_bcache, &key, (struct cache_node *)bp);
 }
@@ -626,10 +636,10 @@ libxfs_balloc(cache_key_t key)
 
 	if (bufkey->map)
 		return (struct cache_node *)
-		       libxfs_getbufr_map(bufkey->device,
+		       libxfs_getbufr_map(bufkey->buftarg,
 					  bufkey->blkno, bufkey->bblen,
 					  bufkey->map, bufkey->nmaps);
-	return (struct cache_node *)libxfs_getbufr(bufkey->device,
+	return (struct cache_node *)libxfs_getbufr(bufkey->buftarg,
 					  bufkey->blkno, bufkey->bblen);
 }
 
@@ -658,9 +668,10 @@ __read_buf(int fd, void *buf, int len, off64_t offset, int flags)
 }
 
 int
-libxfs_readbufr(dev_t dev, xfs_daddr_t blkno, xfs_buf_t *bp, int len, int flags)
+libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, xfs_buf_t *bp,
+		int len, int flags)
 {
-	int	fd = libxfs_device_to_fd(dev);
+	int	fd = libxfs_device_to_fd(btp->dev);
 	int	bytes = BBTOB(len);
 	int	error;
 
@@ -668,7 +679,7 @@ libxfs_readbufr(dev_t dev, xfs_daddr_t blkno, xfs_buf_t *bp, int len, int flags)
 
 	error = __read_buf(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno), flags);
 	if (!error &&
-	    bp->b_dev == dev &&
+	    bp->b_target->dev == btp->dev &&
 	    bp->b_bn == blkno &&
 	    bp->b_bcount == bytes)
 		bp->b_flags |= LIBXFS_B_UPTODATE;
@@ -681,22 +692,38 @@ libxfs_readbufr(dev_t dev, xfs_daddr_t blkno, xfs_buf_t *bp, int len, int flags)
 }
 
 xfs_buf_t *
-libxfs_readbuf(dev_t dev, xfs_daddr_t blkno, int len, int flags)
+libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
+		const struct xfs_buf_ops *ops)
 {
 	xfs_buf_t	*bp;
 	int		error;
 
-	bp = libxfs_getbuf(dev, blkno, len);
-	if (bp && !(bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY))) {
-		error = libxfs_readbufr(dev, blkno, bp, len, flags);
-		if (error)
-			bp->b_error = error;
-	}
+	bp = libxfs_getbuf(btp, blkno, len);
+	if (!bp)
+		return NULL;
+	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY)))
+		return bp;
+
+	/*
+	 * only set the ops on a cache miss (i.e. first physical read) as the
+	 * verifier may change the ops to match the typ eof buffer it contains.
+	 * A cache hit might reset the verifier to the original type if we set
+	 * it again, but it won't get called again and set to match the buffer
+	 * contents. *cough* xfs_da_node_buf_ops *cough*.
+	 */
+	bp->b_error = 0;
+	bp->b_ops = ops;
+	error = libxfs_readbufr(btp, blkno, bp, len, flags);
+	if (error)
+		bp->b_error = error;
+	else if (bp->b_ops)
+		bp->b_ops->verify_read(bp);
 	return bp;
 }
 
 struct xfs_buf *
-libxfs_readbuf_map(dev_t dev, struct xfs_buf_map *map, int nmaps, int flags)
+libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
+		int flags, const struct xfs_buf_ops *ops)
 {
 	xfs_buf_t	*bp;
 	int		error = 0;
@@ -705,15 +732,21 @@ libxfs_readbuf_map(dev_t dev, struct xfs_buf_map *map, int nmaps, int flags)
 	char		*buf;
 
 	if (nmaps == 1)
-		return libxfs_readbuf(dev, map[0].bm_bn, map[0].bm_len, flags);
+		return libxfs_readbuf(btp, map[0].bm_bn, map[0].bm_len,
+					flags, ops);
 
-	bp = libxfs_getbuf_map(dev, map, nmaps);
-	if (!bp || (bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY)))
+	bp = libxfs_getbuf_map(btp, map, nmaps);
+	if (!bp)
+		return NULL;
+
+	bp->b_error = 0;
+	bp->b_ops = ops;
+	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY)))
 		return bp;
 
 	ASSERT(bp->b_nmaps = nmaps);
 
-	fd = libxfs_device_to_fd(dev);
+	fd = libxfs_device_to_fd(btp->dev);
 	buf = bp->b_addr;
 	for (i = 0; i < bp->b_nmaps; i++) {
 		off64_t	offset = LIBXFS_BBTOOFF64(bp->b_map[i].bm_bn);
@@ -731,8 +764,11 @@ libxfs_readbuf_map(dev_t dev, struct xfs_buf_map *map, int nmaps, int flags)
 		offset += len;
 	}
 
-	if (!error)
+	if (!error) {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
+		if (bp->b_ops)
+			bp->b_ops->verify_read(bp);
+	}
 #ifdef IO_DEBUG
 	printf("%lx: %s: read %lu bytes, error %d, blkno=%llu(%llu), %p\n",
 		pthread_self(), __FUNCTION__, buf - (char *)bp->b_addr, error,
@@ -767,9 +803,42 @@ __write_buf(int fd, void *buf, int len, off64_t offset, int flags)
 int
 libxfs_writebufr(xfs_buf_t *bp)
 {
-	int	fd = libxfs_device_to_fd(bp->b_dev);
+	int	fd = libxfs_device_to_fd(bp->b_target->dev);
 	int	error = 0;
 
+	/*
+	 * we never write buffers that are marked stale. This indicates they
+	 * contain data that has been invalidated, and even if the buffer is
+	 * dirty it must *never* be written. Verifiers are wonderful for finding
+	 * bugs like this. Make sure the error is obvious as to the cause.
+	 */
+	if (bp->b_flags & LIBXFS_B_STALE) {
+		bp->b_error = ESTALE;
+		return bp->b_error;
+	}
+
+	/*
+	 * clear any pre-existing error status on the buffer. This can occur if
+	 * the buffer is corrupt on disk and the repair process doesn't clear
+	 * the error before fixing and writing it back.
+	 */
+	bp->b_error = 0;
+	if (bp->b_ops) {
+		bp->b_ops->verify_write(bp);
+		if (bp->b_error) {
+			fprintf(stderr,
+	_("%s: write verifer failed on bno 0x%llx/0x%x\n"),
+				__func__, (long long)bp->b_bn, bp->b_bcount);
+			return bp->b_error;
+		}
+	}
+
+	if (bp->b_ops) {
+		bp->b_ops->verify_write(bp);
+		if (bp->b_error)
+			return bp->b_error;
+	}
+
 	if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
 		error = __write_buf(fd, bp->b_addr, bp->b_bcount,
 				    LIBXFS_BBTOOFF64(bp->b_bn), bp->b_flags);
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 831e42a..97220e7 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -386,7 +386,7 @@ libxfs_trans_bhold(
 xfs_buf_t *
 libxfs_trans_get_buf_map(
 	xfs_trans_t		*tp,
-	dev_t			dev,
+	struct xfs_buftarg	*btp,
 	struct xfs_buf_map	*map,
 	int			nmaps,
 	uint			f)
@@ -395,9 +395,9 @@ libxfs_trans_get_buf_map(
 	xfs_buf_log_item_t	*bip;
 
 	if (tp == NULL)
-		return libxfs_getbuf_map(dev, map, nmaps);
+		return libxfs_getbuf_map(btp, map, nmaps);
 
-	bp = xfs_trans_buf_item_match(tp, dev, map, nmaps);
+	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
 	if (bp != NULL) {
 		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 		bip = XFS_BUF_FSPRIVATE(bp, xfs_buf_log_item_t *);
@@ -406,7 +406,7 @@ libxfs_trans_get_buf_map(
 		return bp;
 	}
 
-	bp = libxfs_getbuf_map(dev, map, nmaps);
+	bp = libxfs_getbuf_map(btp, map, nmaps);
 	if (bp == NULL)
 		return NULL;
 #ifdef XACT_DEBUG
@@ -465,7 +465,7 @@ int
 libxfs_trans_read_buf_map(
 	xfs_mount_t		*mp,
 	xfs_trans_t		*tp,
-	dev_t			dev,
+	struct xfs_buftarg	*btp,
 	struct xfs_buf_map	*map,
 	int			nmaps,
 	uint			flags,
@@ -479,7 +479,7 @@ libxfs_trans_read_buf_map(
 	*bpp = NULL;
 
 	if (tp == NULL) {
-		bp = libxfs_readbuf_map(dev, map, nmaps, flags);
+		bp = libxfs_readbuf_map(btp, map, nmaps, flags, ops);
 		if (!bp) {
 			return (flags & XBF_TRYLOCK) ?
 				EAGAIN : XFS_ERROR(ENOMEM);
@@ -489,7 +489,7 @@ libxfs_trans_read_buf_map(
 		goto done;
 	}
 
-	bp = xfs_trans_buf_item_match(tp, dev, map, nmaps);
+	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
 	if (bp != NULL) {
 		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 		ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
@@ -498,7 +498,7 @@ libxfs_trans_read_buf_map(
 		goto done;
 	}
 
-	bp = libxfs_readbuf_map(dev, map, nmaps, flags);
+	bp = libxfs_readbuf_map(btp, map, nmaps, flags, ops);
 	if (!bp) {
 		return (flags & XBF_TRYLOCK) ?
 			EAGAIN : XFS_ERROR(ENOMEM);
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index 6bec18e..9246f36 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -55,9 +55,6 @@ typedef __uint32_t		inst_t;		/* an instruction */
 #define EWRONGFS	EINVAL
 #endif
 
-#define m_ddev_targp			m_dev
-#define m_logdev_targp			m_logdev
-#define m_rtdev_targp			m_rtdev
 #define xfs_error_level			0
 
 #define STATIC				static
@@ -187,11 +184,7 @@ roundup_pow_of_two(uint v)
 	NULL;						\
 })
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
-#define xfs_read_buf(mp,devp,blkno,len,f,bpp)	\
-					(*(bpp) = libxfs_readbuf((devp), \
-							(blkno), (len), 1), 0)
-#define xfs_buf_get(devp,blkno,len,f)	\
-					(libxfs_getbuf((devp), (blkno), (len)))
+#define xfs_buf_get(devp,blkno,len,f)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
 
 #define XBRW_READ			LIBXFS_BREAD
@@ -372,7 +365,7 @@ void xfs_buf_item_init (xfs_buf_t *, xfs_mount_t *);
 void xfs_buf_item_log (xfs_buf_log_item_t *, uint, uint);
 
 /* xfs_trans_buf.c */
-xfs_buf_t *xfs_trans_buf_item_match(xfs_trans_t *, dev_t,
+xfs_buf_t *xfs_trans_buf_item_match(xfs_trans_t *, struct xfs_buftarg *,
 			struct xfs_buf_map *, int);
 
 /* local source files */
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 7cf573c..6743eda 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -30,8 +30,6 @@ extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
 				const unsigned char *name, int len);
 
 /* xfs_dir2_block.c */
-extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
-
 extern int xfs_dir2_block_addname(struct xfs_da_args *args);
 extern int xfs_dir2_block_getdents(struct xfs_inode *dp, void *dirent,
 		xfs_off_t *offset, filldir_t filldir);
@@ -48,9 +46,6 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 #define	xfs_dir3_data_check(dp,bp)
 #endif
 
-extern const struct xfs_buf_ops xfs_dir3_data_buf_ops;
-extern const struct xfs_buf_ops xfs_dir3_free_buf_ops;
-
 extern int __xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 extern int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
@@ -78,9 +73,6 @@ extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
 		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
 
 /* xfs_dir2_leaf.c */
-extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
-extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
-
 extern int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
 extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
diff --git a/logprint/logprint.c b/logprint/logprint.c
index 3fbcdba..7a56462 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -140,6 +140,7 @@ main(int argc, char **argv)
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
+	memset(&mount, 0, sizeof(mount));
 
 	progname = basename(argv[0]);
 	while ((c = getopt(argc, argv, "bC:cdefl:iqnors:tDVv")) != EOF) {
@@ -220,6 +221,7 @@ main(int argc, char **argv)
 		exit(1);
 
 	logstat(&mount);
+	libxfs_buftarg_init(&mount, x.ddev, x.logdev, x.rtdev);
 
 	logfd = (x.logfd < 0) ? x.dfd : x.logfd;
 
@@ -236,7 +238,7 @@ main(int argc, char **argv)
 
 	ASSERT(x.logBBsize <= INT_MAX);
 
-	log.l_dev         = x.logdev;
+	log.l_dev = mount.m_logdev_targp;
 	log.l_logsize     = BBTOB(x.logBBsize);
 	log.l_logBBstart  = x.logBBstart;
 	log.l_logBBsize   = x.logBBsize;
diff --git a/mkfs/proto.c b/mkfs/proto.c
index f201096..ee84699 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -676,7 +676,7 @@ rtinit(
 				error);
 		}
 		for (i = 0, ep = map; i < nmap; i++, ep++) {
-			libxfs_device_zero(mp->m_dev,
+			libxfs_device_zero(mp->m_ddev_targp,
 				XFS_FSB_TO_DADDR(mp, ep->br_startblock),
 				XFS_FSB_TO_BB(mp, ep->br_blockcount));
 			bno += ep->br_blockcount;
@@ -713,7 +713,7 @@ rtinit(
 				error);
 		}
 		for (i = 0, ep = map; i < nmap; i++, ep++) {
-			libxfs_device_zero(mp->m_dev,
+			libxfs_device_zero(mp->m_ddev_targp,
 				XFS_FSB_TO_DADDR(mp, ep->br_startblock),
 				XFS_FSB_TO_BB(mp, ep->br_blockcount));
 			bno += ep->br_blockcount;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a393607..3864932 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2435,13 +2435,15 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	 * swap (somewhere around the page size), jfs (32k),
 	 * ext[2,3] and reiserfs (64k) - and hopefully all else.
 	 */
-	buf = libxfs_getbuf(xi.ddev, 0, BTOBB(WHACK_SIZE));
+	libxfs_buftarg_init(mp, xi.ddev, xi.logdev, xi.rtdev);
+	buf = libxfs_getbuf(mp->m_ddev_targp, 0, BTOBB(WHACK_SIZE));
 	memset(XFS_BUF_PTR(buf), 0, WHACK_SIZE);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 	libxfs_purgebuf(buf);
 
 	/* OK, now write the superblock */
-	buf = libxfs_getbuf(xi.ddev, XFS_SB_DADDR, XFS_FSS_TO_BB(mp, 1));
+	buf = libxfs_getbuf(mp->m_ddev_targp, XFS_SB_DADDR, XFS_FSS_TO_BB(mp, 1));
+	buf->b_ops = &xfs_sb_buf_ops;
 	memset(XFS_BUF_PTR(buf), 0, sectorsize);
 	libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp, XFS_SB_ALL_BITS);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
@@ -2460,10 +2462,11 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	/*
 	 * Zero out the end of the device, to obliterate any
 	 * old MD RAID (or other) metadata at the end of the device.
- 	 * (MD sb is ~64k from the end, take out a wider swath to be sure)
+	 * (MD sb is ~64k from the end, take out a wider swath to be sure)
 	 */
 	if (!xi.disfile) {
-		buf = libxfs_getbuf(xi.ddev, (xi.dsize - BTOBB(WHACK_SIZE)),
+		buf = libxfs_getbuf(mp->m_ddev_targp,
+				    (xi.dsize - BTOBB(WHACK_SIZE)),
 				    BTOBB(WHACK_SIZE));
 		memset(XFS_BUF_PTR(buf), 0, WHACK_SIZE);
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
@@ -2471,14 +2474,12 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	}
 
 	/*
-	 * Zero the log if there is one.
+	 * Zero the log....
 	 */
-	if (loginternal)
-		xi.logdev = xi.ddev;
-	if (xi.logdev)
-		libxfs_log_clear(xi.logdev, XFS_FSB_TO_DADDR(mp, logstart),
-			(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
-			&sbp->sb_uuid, logversion, lsunit, XLOG_FMT);
+	libxfs_log_clear(mp->m_logdev_targp,
+		XFS_FSB_TO_DADDR(mp, logstart),
+		(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
+		&sbp->sb_uuid, logversion, lsunit, XLOG_FMT);
 
 	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 1);
 	if (mp == NULL) {
@@ -2487,13 +2488,19 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		exit(1);
 	}
 
+	/*
+	 * XXX: this code is effectively shared with the kernel growfs code.
+	 * These initialisations should be pulled into libxfs to keep the
+	 * kernel/userspace header initialisation code the same.
+	 */
 	for (agno = 0; agno < agcount; agno++) {
 		/*
 		 * Superblock.
 		 */
-		buf = libxfs_getbuf(xi.ddev,
+		buf = libxfs_getbuf(mp->m_ddev_targp,
 				XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
 				XFS_FSS_TO_BB(mp, 1));
+		buf->b_ops = &xfs_sb_buf_ops;
 		memset(XFS_BUF_PTR(buf), 0, sectorsize);
 		libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp, XFS_SB_ALL_BITS);
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
@@ -2501,9 +2508,10 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		/*
 		 * AG header block: freespace
 		 */
-		buf = libxfs_getbuf(mp->m_dev,
+		buf = libxfs_getbuf(mp->m_ddev_targp,
 				XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 				XFS_FSS_TO_BB(mp, 1));
+		buf->b_ops = &xfs_agf_buf_ops;
 		agf = XFS_BUF_TO_AGF(buf);
 		memset(agf, 0, sectorsize);
 		if (agno == agcount - 1)
@@ -2534,10 +2542,11 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		/*
 		 * AG header block: inodes
 		 */
-		buf = libxfs_getbuf(mp->m_dev,
+		buf = libxfs_getbuf(mp->m_ddev_targp,
 				XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
 				XFS_FSS_TO_BB(mp, 1));
 		agi = XFS_BUF_TO_AGI(buf);
+		buf->b_ops = &xfs_agi_buf_ops;
 		memset(agi, 0, sectorsize);
 		agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
 		agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
@@ -2556,9 +2565,10 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		/*
 		 * BNO btree root block
 		 */
-		buf = libxfs_getbuf(mp->m_dev,
+		buf = libxfs_getbuf(mp->m_ddev_targp,
 				XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
 				bsize);
+		buf->b_ops = &xfs_allocbt_buf_ops;
 		block = XFS_BUF_TO_BLOCK(buf);
 		memset(block, 0, blocksize);
 		block->bb_magic = cpu_to_be32(XFS_ABTB_MAGIC);
@@ -2608,9 +2618,10 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		/*
 		 * CNT btree root block
 		 */
-		buf = libxfs_getbuf(mp->m_dev,
+		buf = libxfs_getbuf(mp->m_ddev_targp,
 				XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
 				bsize);
+		buf->b_ops = &xfs_allocbt_buf_ops;
 		block = XFS_BUF_TO_BLOCK(buf);
 		memset(block, 0, blocksize);
 		block->bb_magic = cpu_to_be32(XFS_ABTC_MAGIC);
@@ -2650,9 +2661,10 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		/*
 		 * INO btree root block
 		 */
-		buf = libxfs_getbuf(mp->m_dev,
+		buf = libxfs_getbuf(mp->m_ddev_targp,
 				XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
 				bsize);
+		buf->b_ops = &xfs_inobt_buf_ops;
 		block = XFS_BUF_TO_BLOCK(buf);
 		memset(block, 0, blocksize);
 		block->bb_magic = cpu_to_be32(XFS_IBT_MAGIC);
@@ -2666,7 +2678,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	/*
 	 * Touch last block, make fs the right size if it's a file.
 	 */
-	buf = libxfs_getbuf(mp->m_dev,
+	buf = libxfs_getbuf(mp->m_ddev_targp,
 		(xfs_daddr_t)XFS_FSB_TO_BB(mp, dblocks - 1LL), bsize);
 	memset(XFS_BUF_PTR(buf), 0, blocksize);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
@@ -2674,8 +2686,8 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	/*
 	 * Make sure we can write the last block in the realtime area.
 	 */
-	if (mp->m_rtdev && rtblocks > 0) {
-		buf = libxfs_getbuf(mp->m_rtdev,
+	if (mp->m_rtdev_targp->dev && rtblocks > 0) {
+		buf = libxfs_getbuf(mp->m_rtdev_targp,
 				XFS_FSB_TO_BB(mp, rtblocks - 1LL), bsize);
 		memset(XFS_BUF_PTR(buf), 0, blocksize);
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
@@ -2728,7 +2740,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 				XFS_AGB_TO_DADDR(mp, mp->m_sb.sb_agcount-1,
 					XFS_SB_DADDR),
 				XFS_FSS_TO_BB(mp, 1),
-				LIBXFS_EXIT_ON_FAILURE);
+				LIBXFS_EXIT_ON_FAILURE, &xfs_sb_buf_ops);
 		XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(
 							mp->m_sb.sb_rootino);
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
@@ -2740,7 +2752,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 				XFS_AGB_TO_DADDR(mp, (mp->m_sb.sb_agcount-1)/2,
 					XFS_SB_DADDR),
 				XFS_FSS_TO_BB(mp, 1),
-				LIBXFS_EXIT_ON_FAILURE);
+				LIBXFS_EXIT_ON_FAILURE, &xfs_sb_buf_ops);
 			XFS_BUF_TO_SBP(buf)->sb_rootino = cpu_to_be64(
 							mp->m_sb.sb_rootino);
 			libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 331cbb3..13e9034 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -170,7 +170,7 @@ traverse_int_dablock(xfs_mount_t	*mp,
 			goto error_out;
 
 		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
-				XFS_FSB_TO_BB(mp, 1), 0);
+				XFS_FSB_TO_BB(mp, 1), 0, &xfs_da3_node_buf_ops);
 		if (!bp) {
 			if (whichfork == XFS_DATA_FORK)
 				do_warn(
@@ -552,7 +552,7 @@ verify_da_path(xfs_mount_t	*mp,
 		}
 
 		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
-				XFS_FSB_TO_BB(mp, 1), 0);
+				XFS_FSB_TO_BB(mp, 1), 0, &xfs_da3_node_buf_ops);
 		if (!bp) {
 			do_warn(
 	_("can't read block %u (%" PRIu64 ") for directory inode %" PRIu64 "\n"),
@@ -986,7 +986,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 			break;
 		}
 		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
-				XFS_FSB_TO_BB(mp, 1), 0);
+				XFS_FSB_TO_BB(mp, 1), 0, NULL);
 		if (!bp) {
 			do_warn(
 	_("can't read remote block for attributes of inode %" PRIu64 "\n"), ino);
@@ -1315,7 +1315,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		}
 
 		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, dev_bno),
-					XFS_FSB_TO_BB(mp, 1), 0);
+					XFS_FSB_TO_BB(mp, 1), 0, NULL);
 		if (!bp) {
 			do_warn(
 	_("can't read file block %u (fsbno %" PRIu64 ") for attribute fork of inode %" PRIu64 "\n"),
@@ -1497,7 +1497,7 @@ process_longform_attr(
 	}
 
 	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
-				XFS_FSB_TO_BB(mp, 1), 0);
+				XFS_FSB_TO_BB(mp, 1), 0, NULL);
 	if (!bp) {
 		do_warn(
 	_("can't read block 0 of inode %" PRIu64 " attribute fork\n"),
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index b625109..21078d0 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -52,7 +52,7 @@ check_aginode_block(xfs_mount_t	*mp,
 	 * so no one else will overlap them.
 	 */
 	bp = libxfs_readbuf(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, agbno),
-			XFS_FSB_TO_BB(mp, 1), 0);
+			XFS_FSB_TO_BB(mp, 1), 0, NULL);
 	if (!bp) {
 		do_warn(_("cannot read agbno (%u/%u), disk block %" PRId64 "\n"),
 			agno, agbno, XFS_AGB_TO_DADDR(mp, agno, agbno));
@@ -65,6 +65,8 @@ check_aginode_block(xfs_mount_t	*mp,
 				XFS_OFFBNO_TO_AGINO(mp, agbno, i)))
 			cnt++;
 	}
+	if (cnt)
+		bp->b_ops = &xfs_inode_buf_ops;
 
 	libxfs_putbuf(bp);
 	return(cnt);
@@ -625,7 +627,8 @@ process_inode_chunk(
 
 		bplist[bp_index] = libxfs_readbuf(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp, blks_per_cluster), 0);
+					XFS_FSB_TO_BB(mp, blks_per_cluster), 0,
+					NULL);
 		if (!bplist[bp_index]) {
 			do_warn(_("cannot read inode %" PRIu64 ", disk block %" PRId64 ", cnt %d\n"),
 				XFS_AGINO_TO_INO(mp, agno, first_irec->ino_startnum),
@@ -639,6 +642,7 @@ process_inode_chunk(
 			return(1);
 		}
 		agbno += blks_per_cluster;
+		bplist[bp_index]->b_ops = &xfs_inode_buf_ops;
 
 		pftrace("readbuf %p (%llu, %d) in AG %d", bplist[bp_index],
 			(long long)XFS_BUF_ADDR(bplist[bp_index]),
diff --git a/repair/dinode.c b/repair/dinode.c
index 1906ceb..66eedc2 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -836,7 +836,8 @@ get_agino_buf(xfs_mount_t	 *mp,
 
 	size = XFS_FSB_TO_BB(mp, MAX(1, XFS_INODES_PER_CHUNK/inodes_per_block));
 	bp = libxfs_readbuf(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno,
-		XFS_AGINO_TO_AGBNO(mp, irec->ino_startnum)), size, 0);
+		XFS_AGINO_TO_AGBNO(mp, irec->ino_startnum)), size, 0,
+		&xfs_inode_buf_ops);
 	if (!bp) {
 		do_warn(_("cannot read inode (%u/%u), disk block %" PRIu64 "\n"),
 			agno, irec->ino_startnum,
@@ -947,7 +948,7 @@ getfunc_btree(xfs_mount_t		*mp,
 	ASSERT(verify_dfsbno(mp, fsbno));
 
 	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
-				XFS_FSB_TO_BB(mp, 1), 0);
+				XFS_FSB_TO_BB(mp, 1), 0, NULL);
 	if (!bp) {
 		do_error(_("cannot read bmap block %" PRIu64 "\n"), fsbno);
 		return(NULLDFSBNO);
@@ -1004,7 +1005,7 @@ _("- # of bmap records in inode %" PRIu64 " less than minimum (%u, min - %u), pr
 		 */
 		libxfs_putbuf(bp);
 		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
-					XFS_FSB_TO_BB(mp, 1), 0);
+					XFS_FSB_TO_BB(mp, 1), 0, NULL);
 		if (!bp) {
 			do_error(_("cannot read bmap block %" PRIu64 "\n"),
 				fsbno);
@@ -1510,7 +1511,8 @@ process_symlink(
 			if (fsbno != NULLDFSBNO)
 				bp = libxfs_readbuf(mp->m_dev,
 						XFS_FSB_TO_DADDR(mp, fsbno),
-						XFS_FSB_TO_BB(mp, 1), 0);
+						XFS_FSB_TO_BB(mp, 1), 0,
+						&xfs_symlink_buf_ops);
 			if (!bp || fsbno == NULLDFSBNO) {
 				do_warn(
 _("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
diff --git a/repair/dir2.c b/repair/dir2.c
index ae80a6b..a71a276 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -103,7 +103,8 @@ static struct xfs_buf *
 da_read_buf(
 	xfs_mount_t	*mp,
 	int		nex,
-	bmap_ext_t	*bmp)
+	bmap_ext_t	*bmp,
+	const struct xfs_buf_ops *ops)
 {
 #define MAP_ARRAY_SZ 4
 	struct xfs_buf_map map_array[MAP_ARRAY_SZ];
@@ -125,7 +126,7 @@ da_read_buf(
 		map[i].bm_bn = XFS_FSB_TO_DADDR(mp, bmp[i].startblock);
 		map[i].bm_len = XFS_FSB_TO_BB(mp, bmp[i].blockcount);
 	}
-	bp = libxfs_readbuf_map(mp->m_dev, map, nex, 0);
+	bp = libxfs_readbuf_map(mp->m_dev, map, nex, 0, ops);
 	if (map != map_array)
 		free(map);
 	return bp;
@@ -172,7 +173,7 @@ traverse_int_dir2block(xfs_mount_t	*mp,
 		if (nex == 0)
 			goto error_out;
 
-		bp = da_read_buf(mp, nex, bmp);
+		bp = da_read_buf(mp, nex, bmp, &xfs_da3_node_buf_ops);
 		if (bmp != &lbmp)
 			free(bmp);
 		if (bp == NULL) {
@@ -536,7 +537,7 @@ _("can't get map info for block %u of directory inode %" PRIu64 "\n"),
 			return(1);
 		}
 
-		bp = da_read_buf(mp, nex, bmp);
+		bp = da_read_buf(mp, nex, bmp, &xfs_da3_node_buf_ops);
 		if (bmp != &lbmp)
 			free(bmp);
 
@@ -1581,7 +1582,7 @@ _("block %u for directory inode %" PRIu64 " is missing\n"),
 			mp->m_dirdatablk, ino);
 		return 1;
 	}
-	bp = da_read_buf(mp, nex, bmp);
+	bp = da_read_buf(mp, nex, bmp, &xfs_dir3_block_buf_ops);
 	if (bmp != &lbmp)
 		free(bmp);
 	if (bp == NULL) {
@@ -1711,7 +1712,7 @@ _("can't map block %u for directory inode %" PRIu64 "\n"),
 				da_bno, ino);
 			goto error_out;
 		}
-		bp = da_read_buf(mp, nex, bmp);
+		bp = da_read_buf(mp, nex, bmp, &xfs_dir3_leafn_buf_ops);
 		if (bmp != &lbmp)
 			free(bmp);
 		bmp = NULL;
@@ -1897,7 +1898,7 @@ _("block %" PRIu64 " for directory inode %" PRIu64 " is missing\n"),
 				dbno, ino);
 			continue;
 		}
-		bp = da_read_buf(mp, nex, bmp);
+		bp = da_read_buf(mp, nex, bmp, &xfs_dir3_data_buf_ops);
 		if (bmp != &lbmp)
 			free(bmp);
 		if (bp == NULL) {
diff --git a/repair/phase2.c b/repair/phase2.c
index 382cd7b..2817fed 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -40,18 +40,15 @@ zero_log(xfs_mount_t *mp)
 	int error;
 	struct xlog	log;
 	xfs_daddr_t head_blk, tail_blk;
-	dev_t logdev = (mp->m_sb.sb_logstart == 0) ? x.logdev : x.ddev;
 
 	memset(&log, 0, sizeof(log));
-	if (!x.logdev)
-		x.logdev = x.ddev;
 	x.logBBsize = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 	x.logBBstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
 	x.lbsize = BBSIZE;
 	if (xfs_sb_version_hassector(&mp->m_sb))
 		x.lbsize <<= (mp->m_sb.sb_logsectlog - BBSHIFT);
 
-	log.l_dev = logdev;
+	log.l_dev = mp->m_logdev_targp;
 	log.l_logsize = BBTOB(x.logBBsize);
 	log.l_logBBsize = x.logBBsize;
 	log.l_logBBstart = x.logBBstart;
@@ -96,7 +93,7 @@ zero_log(xfs_mount_t *mp)
 		}
 	}
 
-	libxfs_log_clear(logdev,
+	libxfs_log_clear(log.l_dev,
 		XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
 		(xfs_extlen_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks),
 		&mp->m_sb.sb_uuid,
diff --git a/repair/phase3.c b/repair/phase3.c
index 80c66b5..3e43938 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -40,7 +40,7 @@ process_agi_unlinked(
 
 	bp = libxfs_readbuf(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			mp->m_sb.sb_sectsize/BBSIZE, 0);
+			mp->m_sb.sb_sectsize/BBSIZE, 0, &xfs_agi_buf_ops);
 	if (!bp)
 		do_error(_("cannot read agi block %" PRId64 " for ag %u\n"),
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)), agno);
diff --git a/repair/phase6.c b/repair/phase6.c
index bd1fad4..8b8df10 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -510,7 +510,7 @@ mk_rbmino(xfs_mount_t *mp)
 				error);
 		}
 		for (i = 0, ep = map; i < nmap; i++, ep++) {
-			libxfs_device_zero(mp->m_dev,
+			libxfs_device_zero(mp->m_ddev_targp,
 				XFS_FSB_TO_DADDR(mp, ep->br_startblock),
 				XFS_FSB_TO_BB(mp, ep->br_blockcount));
 			bno += ep->br_blockcount;
@@ -765,7 +765,7 @@ mk_rsumino(xfs_mount_t *mp)
 				error);
 		}
 		for (i = 0, ep = map; i < nmap; i++, ep++) {
-			libxfs_device_zero(mp->m_dev,
+			libxfs_device_zero(mp->m_ddev_targp,
 				      XFS_FSB_TO_DADDR(mp, ep->br_startblock),
 				      XFS_FSB_TO_BB(mp, ep->br_blockcount));
 			bno += ep->br_blockcount;
@@ -1829,7 +1829,8 @@ longform_dir2_check_leaf(
 	struct xfs_dir2_leaf_entry *ents;
 
 	da_bno = mp->m_dirleafblk;
-	if (libxfs_da_read_buf(NULL, ip, da_bno, -1, &bp, XFS_DATA_FORK, NULL)) {
+	if (libxfs_da_read_buf(NULL, ip, da_bno, -1, &bp, XFS_DATA_FORK,
+				&xfs_dir3_leaf1_buf_ops)) {
 		do_error(
 	_("can't read block %u for directory inode %" PRIu64 "\n"),
 			da_bno, ip->i_ino);
@@ -1906,7 +1907,7 @@ longform_dir2_check_node(
 		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
 			break;
 		if (libxfs_da_read_buf(NULL, ip, da_bno, -1, &bp,
-				XFS_DATA_FORK, NULL)) {
+				XFS_DATA_FORK, &xfs_dir3_leafn_buf_ops)) {
 			do_warn(
 	_("can't read leaf block %u for directory inode %" PRIu64 "\n"),
 				da_bno, ip->i_ino);
@@ -1953,7 +1954,7 @@ longform_dir2_check_node(
 		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
 			break;
 		if (libxfs_da_read_buf(NULL, ip, da_bno, -1, &bp,
-				XFS_DATA_FORK, NULL)) {
+				XFS_DATA_FORK, &xfs_dir3_free_buf_ops)) {
 			do_warn(
 	_("can't read freespace block %u for directory inode %" PRIu64 "\n"),
 				da_bno, ip->i_ino);
@@ -2075,7 +2076,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 					num_bps * sizeof(struct xfs_buf*));
 		}
 		if (libxfs_da_read_buf(NULL, ip, da_bno, -1, &bplist[db],
-				XFS_DATA_FORK, NULL)) {
+				XFS_DATA_FORK, &xfs_dir3_data_buf_ops)) {
 			do_warn(
 	_("can't read data block %u for directory inode %" PRIu64 "\n"),
 				da_bno, ino);
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 3a8177e..93b4146 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -221,7 +221,7 @@ pf_scan_lbtree(
 	int			rc;
 
 	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, dbno),
-			XFS_FSB_TO_BB(mp, 1), 0);
+			XFS_FSB_TO_BB(mp, 1), 0, NULL);
 	if (!bp)
 		return 0;
 
@@ -720,7 +720,7 @@ init_prefetch(
 	xfs_mount_t		*pmp)
 {
 	mp = pmp;
-	mp_fd = libxfs_device_to_fd(mp->m_dev);
+	mp_fd = libxfs_device_to_fd(mp->m_ddev_targp->dev);
 	pf_max_bytes = sysconf(_SC_PAGE_SIZE) << 7;
 	pf_max_bbs = pf_max_bytes >> BBSHIFT;
 	pf_max_fsbs = pf_max_bytes >> mp->m_sb.sb_blocklog;
diff --git a/repair/rt.c b/repair/rt.c
index d6ecd56..042ff46 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -206,7 +206,7 @@ process_rtbitmap(xfs_mount_t	*mp,
 			continue;
 		}
 		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
-				XFS_FSB_TO_BB(mp, 1));
+				XFS_FSB_TO_BB(mp, 1), NULL);
 		if (!bp) {
 			do_warn(_("can't read block %d for rtbitmap inode\n"),
 					bmbno);
@@ -268,7 +268,7 @@ process_rtsummary(xfs_mount_t	*mp,
 			continue;
 		}
 		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
-				XFS_FSB_TO_BB(mp, 1));
+				XFS_FSB_TO_BB(mp, 1), NULL);
 		if (!bp) {
 			do_warn(_("can't read block %d for rtsummary inode\n"),
 					sumbno);
diff --git a/repair/scan.c b/repair/scan.c
index f79342a..0b5ab1b 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -85,7 +85,7 @@ scan_sbtree(
 	xfs_buf_t	*bp;
 
 	bp = libxfs_readbuf(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, root),
-			XFS_FSB_TO_BB(mp, 1), 0);
+			XFS_FSB_TO_BB(mp, 1), 0, NULL);
 	if (!bp) {
 		do_error(_("can't read btree block %d/%d\n"), agno, root);
 		return;
@@ -130,7 +130,7 @@ scan_lbtree(
 	int		dirty = 0;
 
 	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, root),
-		      XFS_FSB_TO_BB(mp, 1), 0);
+		      XFS_FSB_TO_BB(mp, 1), 0, NULL);
 	if (!bp)  {
 		do_error(_("can't read btree block %d/%d\n"),
 			XFS_FSB_TO_AGNO(mp, root),
@@ -1060,7 +1060,7 @@ scan_freelist(
 
 	agflbuf = libxfs_readbuf(mp->m_dev,
 				 XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
-				 XFS_FSS_TO_BB(mp, 1), 0);
+				 XFS_FSS_TO_BB(mp, 1), 0, &xfs_agfl_buf_ops);
 	if (!agflbuf)  {
 		do_abort(_("can't read agfl block for ag %d\n"), agno);
 		return;
@@ -1207,7 +1207,7 @@ scan_ag(
 	int		status;
 
 	sbbuf = libxfs_readbuf(mp->m_dev, XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
-				XFS_FSS_TO_BB(mp, 1), 0);
+				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
 	if (!sbbuf)  {
 		do_error(_("can't get root superblock for ag %d\n"), agno);
 		return;
@@ -1223,7 +1223,7 @@ scan_ag(
 
 	agfbuf = libxfs_readbuf(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0);
+			XFS_FSS_TO_BB(mp, 1), 0, &xfs_agf_buf_ops);
 	if (!agfbuf)  {
 		do_error(_("can't read agf block for ag %d\n"), agno);
 		libxfs_putbuf(sbbuf);
@@ -1234,7 +1234,7 @@ scan_ag(
 
 	agibuf = libxfs_readbuf(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0);
+			XFS_FSS_TO_BB(mp, 1), 0, &xfs_agi_buf_ops);
 	if (!agibuf)  {
 		do_error(_("can't read agi block for ag %d\n"), agno);
 		libxfs_putbuf(agfbuf);
@@ -1353,7 +1353,8 @@ scan_ags(
 	}
 	memset(agcnts, 0, mp->m_sb.sb_agcount * sizeof(*agcnts));
 
-	create_work_queue(&wq, mp, scan_threads);
+	create_work_queue(&wq, mp, 1);
+	//create_work_queue(&wq, mp, scan_threads);
 
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, scan_ag, i, &agcnts[i]);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 67a7446..7623560 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -558,9 +558,11 @@ main(int argc, char **argv)
 	}
 
 	/* prepare the mount structure */
-	sbp = libxfs_readbuf(x.ddev, XFS_SB_DADDR,
-				1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0);
 	memset(&xfs_m, 0, sizeof(xfs_mount_t));
+	libxfs_buftarg_init(&xfs_m, x.ddev, x.logdev, x.rtdev);
+	sbp = libxfs_readbuf(xfs_m.m_ddev_targp, XFS_SB_DADDR,
+				1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0,
+				&xfs_sb_buf_ops);
 	libxfs_sb_from_disk(&xfs_m.m_sb, XFS_BUF_TO_SBP(sbp));
 
 	/*
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
