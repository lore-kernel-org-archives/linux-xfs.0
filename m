Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 73F508136
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:03:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 65DA130405F
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:56 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id FVq5z9IrDUFf2gaF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:55 -0800 (PST)
Subject: [PATCH 67/76] xfs: teach fiemap about reflink'd extents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:03:51 -0800
Message-ID: <20151219090351.12713.32090.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Teach FIEMAP to report shared (i.e. reflinked) extents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |    2 +
 fs/xfs/xfs_bmap_util.h |    3 +-
 fs/xfs/xfs_ioctl.c     |   12 +++++++-
 fs/xfs/xfs_iops.c      |   68 ++++++++++++++++++++++++++++++++++++++++--------
 4 files changed, 69 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 3e274f6..61d616e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -742,7 +742,7 @@ xfs_getbmap(
 		int full = 0;	/* user array is full */
 
 		/* format results & advance arg */
-		error = formatter(&arg, &out[i], &full);
+		error = formatter(ip, &arg, &out[i], &full);
 		if (error || full)
 			break;
 	}
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index af97d9a..d0dc504 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -37,7 +37,8 @@ int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
 		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
 
 /* bmap to userspace formatter - copy to user & advance pointer */
-typedef int (*xfs_bmap_format_t)(void **, struct getbmapx *, int *);
+typedef int (*xfs_bmap_format_t)(struct xfs_inode *, void **, struct getbmapx *,
+		int *);
 int	xfs_getbmap(struct xfs_inode *ip, struct getbmapx *bmv,
 		xfs_bmap_format_t formatter, void *arg);
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 07c4eb6..cf712641 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1362,7 +1362,11 @@ out_drop_write:
 }
 
 STATIC int
-xfs_getbmap_format(void **ap, struct getbmapx *bmv, int *full)
+xfs_getbmap_format(
+	struct xfs_inode	*ip,
+	void			**ap,
+	struct getbmapx		*bmv,
+	int			*full)
 {
 	struct getbmap __user	*base = (struct getbmap __user *)*ap;
 
@@ -1406,7 +1410,11 @@ xfs_ioc_getbmap(
 }
 
 STATIC int
-xfs_getbmapx_format(void **ap, struct getbmapx *bmv, int *full)
+xfs_getbmapx_format(
+	struct xfs_inode	*ip,
+	void			**ap,
+	struct getbmapx		*bmv,
+	int			*full)
 {
 	struct getbmapx __user	*base = (struct getbmapx __user *)*ap;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 245268a..ff1341c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -38,6 +38,8 @@
 #include "xfs_dir2.h"
 #include "xfs_trans_space.h"
 #include "xfs_pnfs.h"
+#include "xfs_bit.h"
+#include "xfs_refcount.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -1014,14 +1016,23 @@ xfs_vn_update_time(
  */
 STATIC int
 xfs_fiemap_format(
+	struct xfs_inode	*ip,
 	void			**arg,
 	struct getbmapx		*bmv,
 	int			*full)
 {
-	int			error;
+	int			error = 0;
 	struct fiemap_extent_info *fieinfo = *arg;
 	u32			fiemap_flags = 0;
-	u64			logical, physical, length;
+	u64			logical, physical, length, loop_len, len;
+	xfs_agblock_t		ebno;
+	xfs_extlen_t		elen;
+	xfs_nlink_t		nr;
+	xfs_fsblock_t		fsbno;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	xfs_extlen_t		aglen;
+	struct xfs_mount	*mp = ip->i_mount;
 
 	/* Do nothing for a hole */
 	if (bmv->bmv_block == -1LL)
@@ -1029,7 +1040,7 @@ xfs_fiemap_format(
 
 	logical = BBTOB(bmv->bmv_offset);
 	physical = BBTOB(bmv->bmv_block);
-	length = BBTOB(bmv->bmv_length);
+	length = loop_len = BBTOB(bmv->bmv_length);
 
 	if (bmv->bmv_oflags & BMV_OF_PREALLOC)
 		fiemap_flags |= FIEMAP_EXTENT_UNWRITTEN;
@@ -1038,16 +1049,49 @@ xfs_fiemap_format(
 				 FIEMAP_EXTENT_UNKNOWN);
 		physical = 0;   /* no block yet */
 	}
-	if (bmv->bmv_oflags & BMV_OF_LAST)
-		fiemap_flags |= FIEMAP_EXTENT_LAST;
-
-	error = fiemap_fill_next_extent(fieinfo, logical, physical,
-					length, fiemap_flags);
-	if (error > 0) {
-		error = 0;
-		*full = 1;	/* user array now full */
-	}
 
+	while (loop_len > 0) {
+		u32 ext_flags = 0;
+
+		if (bmv->bmv_oflags & BMV_OF_DELALLOC) {
+			physical = 0;
+			len = loop_len;
+			nr = 1;
+		} else if (xfs_is_reflink_inode(ip)) {
+			fsbno = XFS_DADDR_TO_FSB(mp, BTOBB(physical));
+			agno = XFS_FSB_TO_AGNO(mp, fsbno);
+			agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+			aglen = XFS_B_TO_FSB(mp, loop_len);
+			error = xfs_refcount_find_shared(mp, agno, agbno, aglen,
+							 &ebno, &elen, true);
+			if (error)
+				goto out;
+			if (elen == 0) {
+				len = loop_len;
+			} else if (ebno == agbno) {
+				len = XFS_FSB_TO_B(mp, elen);
+				ext_flags |= FIEMAP_EXTENT_SHARED;
+			} else {
+				len = XFS_FSB_TO_B(mp, ebno - agbno);
+			}
+		} else
+			len = loop_len;
+		if ((bmv->bmv_oflags & BMV_OF_LAST) &&
+		    len == loop_len)
+			ext_flags |= FIEMAP_EXTENT_LAST;
+
+		error = fiemap_fill_next_extent(fieinfo, logical, physical,
+						len, fiemap_flags | ext_flags);
+		if (error > 0) {
+			error = 0;
+			*full = 1;	/* user array now full */
+			goto out;
+		}
+		logical += len;
+		physical += len;
+		loop_len -= len;
+	}
+out:
 	return error;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
