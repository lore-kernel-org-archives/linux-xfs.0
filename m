Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A98129E51
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 17:03:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FA33AC006
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 15:03:31 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	6eGKJwhyR738AX8h for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 15:03:29 -0800 (PST)
Date: Thu, 7 Nov 2013 10:02:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/37 V2] libxfs: fix root inode handling inconsistencies
Message-ID: <20131106230257.GJ6188@dastard>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
	<1383700043-32305-16-git-send-email-david@fromorbit.com>
	<20131106102334.GB614@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131106102334.GB614@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

libxfs: fix root inode handling inconsistencies

From: Dave Chinner <dchinner@redhat.com>

When "mounting" a filesystem via libxfs_mount(), callers can tell
libxfs to read the root and realtime inodes into cache. However,
when unmounting the filesystem, libxfs_unmount() used to
unconditionally free root inodes if they were present.

This leads to interesting issues like in mkfs, when it handles
creation, reading and freeing of the root and rt inodes itself.
It, however, passes in the flag to tell libxfs_mount() to read the
root inodes and so can result in unbalanced freeing of inodes when
cleaning up during the unmount proceedure.

As it turns out, nothing ever uses mp->m_rootip and so we don't need
to read it in or free it, or even have a pointer to it in the struct
xfs_mount. Similarly, the only user of the realtime inodes is mkfs,
and it initialises them itself. Hence we can kill the m_rootip and
the realtime inode mounting code.

This leaves one user of LIBXFS_MOUNT_ROOTINOS - xfs_db - and that is
only used to initialise the in-core superblock counter values from
the ag header for xfs_check. Move this code to the xfs_db init
functions so we can get rid of the mount parameter previously used
to trigger all these behavours (LIBXFS_MOUNT_ROOTINOS) completely.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
V2: removed the exit() from the case where the perag data could not
be read so that we maintain the behaviour of xfs_db being able to
mount corrupted filesystems.

 copy/xfs_copy.c  |   2 +-
 db/init.c        |  26 +++++++----
 include/libxfs.h |  12 +++---
 libxfs/init.c    | 128 -------------------------------------------------------
 mkfs/proto.c     |   1 -
 mkfs/xfs_mkfs.c  |   4 +-
 repair/phase6.c  |   2 -
 7 files changed, 26 insertions(+), 149 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index bb37279..9986fbf 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -684,7 +684,7 @@ main(int argc, char **argv)
 	sb = &mbuf.m_sb;
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
 
-	mp = libxfs_mount(&mbuf, sb, xargs.ddev, xargs.logdev, xargs.rtdev, 1);
+	mp = libxfs_mount(&mbuf, sb, xargs.ddev, xargs.logdev, xargs.rtdev, 0);
 	if (mp == NULL) {
 		do_log(_("%s: %s filesystem failed to initialize\n"
 			"%s: Aborting.\n"), progname, source_name, progname);
diff --git a/db/init.c b/db/init.c
index 2932e51..d73d549 100644
--- a/db/init.c
+++ b/db/init.c
@@ -149,18 +149,28 @@ init(
 	}
 
 	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
-				LIBXFS_MOUNT_ROOTINOS | LIBXFS_MOUNT_DEBUGGER);
+			  LIBXFS_MOUNT_DEBUGGER);
 	if (!mp) {
-		mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
-				LIBXFS_MOUNT_DEBUGGER);
-		if (!mp) {
-			fprintf(stderr, _("%s: device %s unusable (not an XFS "
-				"filesystem?)\n"), progname, fsdevice);
-			exit(1);
-		}
+		fprintf(stderr,
+			_("%s: device %s unusable (not an XFS filesystem?)\n"),
+			progname, fsdevice);
+		exit(1);
 	}
 	blkbb = 1 << mp->m_blkbb_log;
 
+	/*
+	 * xfs_check needs corrected incore superblock values
+	 */
+	if (sbp->sb_rootino != NULLFSINO &&
+	    xfs_sb_version_haslazysbcount(&mp->m_sb)) {
+		int error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
+		if (error) {
+			fprintf(stderr,
+	_("%s: cannot init perag data (%d). Continuing anyway.\n"),
+				progname, error);
+		}
+	}
+
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		type_set_tab_crc();
 
diff --git a/include/libxfs.h b/include/libxfs.h
index f10ab59..3df8c07 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -167,7 +167,6 @@ typedef struct xfs_mount {
 	uint			m_rsumsize;	/* size of rt summary, bytes */
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
-	struct xfs_inode	*m_rootip;	/* pointer to root directory */
 	struct xfs_buftarg	*m_ddev_targp;
 	struct xfs_buftarg	*m_logdev_targp;
 	struct xfs_buftarg	*m_rtdev_targp;
@@ -259,12 +258,11 @@ typedef struct xfs_perag {
 	int		pagb_count;	/* pagb slots in use */
 } xfs_perag_t;
 
-#define LIBXFS_MOUNT_ROOTINOS		0x0001
-#define LIBXFS_MOUNT_DEBUGGER		0x0002
-#define LIBXFS_MOUNT_32BITINODES	0x0004
-#define LIBXFS_MOUNT_32BITINOOPT	0x0008
-#define LIBXFS_MOUNT_COMPAT_ATTR	0x0010
-#define LIBXFS_MOUNT_ATTR2		0x0020
+#define LIBXFS_MOUNT_DEBUGGER		0x0001
+#define LIBXFS_MOUNT_32BITINODES	0x0002
+#define LIBXFS_MOUNT_32BITINOOPT	0x0004
+#define LIBXFS_MOUNT_COMPAT_ATTR	0x0008
+#define LIBXFS_MOUNT_ATTR2		0x0010
 
 #define LIBXFS_IHASHSIZE(sbp)		(1<<10)
 #define LIBXFS_BHASHSIZE(sbp) 		(1<<10)
diff --git a/libxfs/init.c b/libxfs/init.c
index db7eeea..ee6165e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -409,94 +409,6 @@ manage_zones(int release)
 	xfs_dir_startup();
 }
 
-/*
- * Get the bitmap and summary inodes into the mount structure
- * at mount time.
- */
-static int
-rtmount_inodes(xfs_mount_t *mp)
-{
-	int		error;
-	xfs_sb_t	*sbp;
-
-	sbp = &mp->m_sb;
-	if (sbp->sb_rbmino == NULLFSINO)
-		return 0;
-	error = libxfs_iget(mp, NULL, sbp->sb_rbmino, 0, &mp->m_rbmip, 0);
-	if (error) {
-		fprintf(stderr,
-			_("%s: cannot read realtime bitmap inode (%d)\n"),
-			progname, error);
-		return error;
-	}
-	ASSERT(mp->m_rbmip != NULL);
-	ASSERT(sbp->sb_rsumino != NULLFSINO);
-	error = libxfs_iget(mp, NULL, sbp->sb_rsumino, 0, &mp->m_rsumip, 0);
-	if (error) {
-		libxfs_iput(mp->m_rbmip, 0);
-		fprintf(stderr,
-			_("%s: cannot read realtime summary inode (%d)\n"),
-			progname, error);
-		return error;
-	}
-	ASSERT(mp->m_rsumip != NULL);
-	return 0;
-}
-
-/*
- * Initialize realtime fields in the mount structure.
- */
-static int
-rtmount_init(
-	xfs_mount_t	*mp,	/* file system mount structure */
-	int		flags)
-{
-	xfs_buf_t	*bp;	/* buffer for last block of subvolume */
-	xfs_daddr_t	d;	/* address of last block of subvolume */
-	xfs_sb_t	*sbp;	/* filesystem superblock copy in mount */
-
-	sbp = &mp->m_sb;
-	if (sbp->sb_rblocks == 0)
-		return 0;
-	if (mp->m_rtdev_targp->dev == 0 && !(flags & LIBXFS_MOUNT_DEBUGGER)) {
-		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
-			progname);
-		return -1;
-	}
-	mp->m_rsumlevels = sbp->sb_rextslog + 1;
-	mp->m_rsumsize =
-		(uint)sizeof(xfs_suminfo_t) * mp->m_rsumlevels *
-		sbp->sb_rbmblocks;
-	mp->m_rsumsize = roundup(mp->m_rsumsize, sbp->sb_blocksize);
-	mp->m_rbmip = mp->m_rsumip = NULL;
-
-	/*
-	 * Allow debugger to be run without the realtime device present.
-	 */
-	if (flags & LIBXFS_MOUNT_DEBUGGER)
-		return 0;
-
-	/*
-	 * Check that the realtime section is an ok size.
-	 */
-	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
-	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_rblocks) {
-		fprintf(stderr, _("%s: realtime init - %llu != %llu\n"),
-			progname, (unsigned long long) XFS_BB_TO_FSB(mp, d),
-			(unsigned long long) mp->m_sb.sb_rblocks);
-		return -1;
-	}
-	bp = libxfs_readbuf(mp->m_rtdev,
-			d - XFS_FSB_TO_BB(mp, 1), XFS_FSB_TO_BB(mp, 1), 0, NULL);
-	if (bp == NULL) {
-		fprintf(stderr, _("%s: realtime size check failed\n"),
-			progname);
-		return -1;
-	}
-	libxfs_putbuf(bp);
-	return 0;
-}
-
 static int
 libxfs_initialize_perag(
 	xfs_mount_t	*mp,
@@ -796,13 +708,6 @@ libxfs_mount(
 			libxfs_putbuf(bp);
 	}
 
-	/* Initialize realtime fields in the mount structure */
-	if (rtmount_init(mp, flags)) {
-		fprintf(stderr, _("%s: realtime device init failed\n"),
-			progname);
-			return NULL;
-	}
-
 	error = libxfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
 	if (error) {
 		fprintf(stderr, _("%s: perag init failed\n"),
@@ -810,39 +715,6 @@ libxfs_mount(
 		exit(1);
 	}
 
-	/*
-	 * mkfs calls mount before the root inode is allocated.
-	 */
-	if ((flags & LIBXFS_MOUNT_ROOTINOS) && sbp->sb_rootino != NULLFSINO) {
-		error = libxfs_iget(mp, NULL, sbp->sb_rootino, 0,
-				&mp->m_rootip, 0);
-		if (error) {
-			fprintf(stderr, _("%s: cannot read root inode (%d)\n"),
-				progname, error);
-			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
-				return NULL;
-		}
-		ASSERT(mp->m_rootip != NULL);
-	}
-	if ((flags & LIBXFS_MOUNT_ROOTINOS) && rtmount_inodes(mp)) {
-		if (mp->m_rootip)
-			libxfs_iput(mp->m_rootip, 0);
-		return NULL;
-	}
-
-	/*
-	 * mkfs calls mount before the AGF/AGI structures are written.
-	 */
-	if ((flags & LIBXFS_MOUNT_ROOTINOS) && sbp->sb_rootino != NULLFSINO &&
-	    xfs_sb_version_haslazysbcount(&mp->m_sb)) {
-		error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
-		if (error) {
-			fprintf(stderr, _("%s: cannot init perag data (%d)\n"),
-				progname, error);
-			return NULL;
-		}
-	}
-
 	return mp;
 }
 
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 0cdef41..4cc0df6 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -543,7 +543,6 @@ parseproto(
 			pip = ip;
 			mp->m_sb.sb_rootino = ip->i_ino;
 			libxfs_mod_sb(tp, XFS_SB_ROOTINO);
-			mp->m_rootip = ip;
 			isroot = 1;
 		} else {
 			libxfs_trans_ijoin(tp, pip, 0);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 355708c..d37e948 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2582,6 +2582,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	memset(XFS_BUF_PTR(buf), 0, sectorsize);
 	libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp, XFS_SB_ALL_BITS);
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_purgebuf(buf);
 
 	/*
 	 * If the data area is a file, then grow it out to its final size
@@ -2616,7 +2617,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
 		&sbp->sb_uuid, logversion, lsunit, XLOG_FMT);
 
-	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 1);
+	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 0);
 	if (mp == NULL) {
 		fprintf(stderr, _("%s: filesystem failed to initialize\n"),
 			progname);
@@ -2887,7 +2888,6 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	/*
 	 * Allocate the root inode and anything else in the proto file.
 	 */
-	mp->m_rootip = NULL;
 	parse_proto(mp, &fsx, &protostring);
 
 	/*
diff --git a/repair/phase6.c b/repair/phase6.c
index 2a37438..5307acf 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -856,8 +856,6 @@ mk_root_dir(xfs_mount_t *mp)
 	ip->i_df.if_bytes = ip->i_df.if_real_bytes = 0;
 	ip->i_df.if_u1.if_extents = NULL;
 
-	mp->m_rootip = ip;
-
 	/*
 	 * initialize the directory
 	 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
