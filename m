Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6R5qheF168338 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 00:52:43 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C10412BB618
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 23:03:05 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	0rlWmoI7SktPW102 for <xfs@oss.sgi.com>;
	Mon, 26 Jul 2010 23:03:05 -0700 (PDT)
Received: from dastard (unverified [121.44.18.238])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	32777496-1927428
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 15:25:45 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Odd8Y-0004Hz-Ga
	for xfs@oss.sgi.com; Tue, 27 Jul 2010 15:55:34 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Odd8V-0002rI-Gs
	for xfs@oss.sgi.com; Tue, 27 Jul 2010 15:55:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: Introduce XFS_IOC_ZERO_RANGE
Date: Tue, 27 Jul 2010 15:55:29 +1000
Message-Id: <1280210129-10925-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1280210129-10925-1-git-send-email-david@fromorbit.com>
References: <1280210129-10925-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

XFS_IOC_ZERO_RANGE is the equivalent of an atomic XFS_IOC_UNRESVSP/
XFS_IOC_RESVSP call pair. It enabled ranges of written data to be
turned into zeroes without requiring IO or having to free and
reallocate the extents in the range given as would occur if we had
to punch and then preallocate them separately.  This enables
applications to zero parts of files very quickly without changing
the layout of the files in any way.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_ioctl.c   |    3 ++-
 fs/xfs/linux-2.6/xfs_ioctl32.c |    1 +
 fs/xfs/xfs_bmap.c              |   14 +++++++++++---
 fs/xfs/xfs_bmap.h              |    9 ++++++---
 fs/xfs/xfs_fs.h                |    1 +
 fs/xfs/xfs_vnodeops.c          |   13 +++++++++++--
 6 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index 237f5ff..a9c4810 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -1292,7 +1292,8 @@ xfs_file_ioctl(
 	case XFS_IOC_ALLOCSP64:
 	case XFS_IOC_FREESP64:
 	case XFS_IOC_RESVSP64:
-	case XFS_IOC_UNRESVSP64: {
+	case XFS_IOC_UNRESVSP64:
+	case XFS_IOC_ZERO_RANGE: {
 		xfs_flock64_t		bf;
 
 		if (copy_from_user(&bf, arg, sizeof(bf)))
diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.c b/fs/xfs/linux-2.6/xfs_ioctl32.c
index 6c83f7f..464bcc7 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -574,6 +574,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_FSGEOMETRY_V1:
 	case XFS_IOC_FSGROWFSDATA:
 	case XFS_IOC_FSGROWFSRT:
+	case XFS_IOC_ZERO_RANGE:
 		return xfs_file_ioctl(filp, cmd, p);
 #else
 	case XFS_IOC_ALLOCSP_32:
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 23f14e5..581e646 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4744,8 +4744,14 @@ xfs_bmapi(
 		 * Check if writing previously allocated but
 		 * unwritten extents.
 		 */
-		if (wr && mval->br_state == XFS_EXT_UNWRITTEN &&
-		    ((flags & (XFS_BMAPI_PREALLOC|XFS_BMAPI_DELAY)) == 0)) {
+		if (wr &&
+		    ((mval->br_state == XFS_EXT_UNWRITTEN &&
+		      ((flags & (XFS_BMAPI_PREALLOC|XFS_BMAPI_DELAY)) == 0)) ||
+		     (mval->br_state == XFS_EXT_NORM &&
+		      ((flags & (XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT)) ==
+				(XFS_BMAPI_PREALLOC|XFS_BMAPI_CONVERT))))) {
+
+			printk("extent conversion\n");
 			/*
 			 * Modify (by adding) the state flag, if writing.
 			 */
@@ -4757,7 +4763,9 @@ xfs_bmapi(
 					*firstblock;
 				cur->bc_private.b.flist = flist;
 			}
-			mval->br_state = XFS_EXT_NORM;
+			mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
+						? XFS_EXT_NORM
+						: XFS_EXT_UNWRITTEN;
 			error = xfs_bmap_add_extent(ip, lastx, &cur, mval,
 				firstblock, flist, &tmp_logflags,
 				whichfork, (flags & XFS_BMAPI_RSVBLOCKS));
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index b13569a..71ec9b6 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -74,9 +74,12 @@ typedef	struct xfs_bmap_free
 #define	XFS_BMAPI_IGSTATE	0x080	/* Ignore state - */
 					/* combine contig. space */
 #define	XFS_BMAPI_CONTIG	0x100	/* must allocate only one extent */
-#define XFS_BMAPI_CONVERT	0x200	/* unwritten extent conversion - */
-					/* need write cache flushing and no */
-					/* additional allocation alignments */
+/*
+ * unwritten extent conversion - this needs write cache flushing and no additional
+ * allocation alignments. When specified with XFS_BMAPI_PREALLOC it converts
+ * from written to unwritten, otherwise convert from unwritten to written.
+ */
+#define XFS_BMAPI_CONVERT	0x200
 
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_WRITE,	"WRITE" }, \
diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 7cf7220..6af6518 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -446,6 +446,7 @@ typedef struct xfs_handle {
 /*	XFS_IOC_SETBIOSIZE ---- deprecated 46	   */
 /*	XFS_IOC_GETBIOSIZE ---- deprecated 47	   */
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
+#define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 3ac137d..9f82422 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2270,7 +2270,7 @@ xfs_alloc_file_space(
 	count = len;
 	imapp = &imaps[0];
 	nimaps = 1;
-	bmapi_flag = XFS_BMAPI_WRITE | (alloc_type ? XFS_BMAPI_PREALLOC : 0);
+	bmapi_flag = XFS_BMAPI_WRITE | alloc_type;
 	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
 	allocatesize_fsb = XFS_B_TO_FSB(mp, count);
 
@@ -2702,7 +2702,9 @@ xfs_change_file_space(
 	xfs_off_t	llen;
 	xfs_trans_t	*tp;
 	struct iattr	iattr;
+	int		prealloc_type;
 
+	printk("type 0x%x\n", bf->l_type);
 	if (!S_ISREG(ip->i_d.di_mode))
 		return XFS_ERROR(EINVAL);
 
@@ -2744,12 +2746,19 @@ xfs_change_file_space(
 	 * size to be changed.
 	 */
 	setprealloc = clrprealloc = 0;
+	prealloc_type = XFS_BMAPI_PREALLOC;
 
 	switch (cmd) {
+	case XFS_IOC_ZERO_RANGE:
+		prealloc_type |= XFS_BMAPI_CONVERT;
+		printk("force prealloc off 0x%llx len 0x%llx\n",
+				startoffset, bf->l_len);
+		xfs_tosspages(ip, startoffset, startoffset + bf->l_len, 0);
+		/* FALLTHRU */
 	case XFS_IOC_RESVSP:
 	case XFS_IOC_RESVSP64:
 		error = xfs_alloc_file_space(ip, startoffset, bf->l_len,
-								1, attr_flags);
+						prealloc_type, attr_flags);
 		if (error)
 			return error;
 		setprealloc = 1;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
