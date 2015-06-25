Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 67F897F9B
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 18:40:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2874AC003
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 16:40:12 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id gUi4RQd2l5JBhJs0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 16:40:10 -0700 (PDT)
Subject: [PATCH 08/14] xfs: teach fiemap about reflink'd extents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jun 2015 16:40:03 -0700
Message-ID: <20150625234003.4992.43384.stgit@birch.djwong.org>
In-Reply-To: <20150625233909.4992.68314.stgit@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
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
 fs/xfs/xfs_bmap_util.c |    2 +-
 fs/xfs/xfs_bmap_util.h |    3 ++
 fs/xfs/xfs_ioctl.c     |    4 ++-
 fs/xfs/xfs_iops.c      |   62 +++++++++++++++++++++++++++++++++++++++---------
 4 files changed, 55 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 17975fe..090cf75 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -689,7 +689,7 @@ xfs_getbmap(
 		int full = 0;	/* user array is full */
 
 		/* format results & advance arg */
-		error = formatter(&arg, &out[i], &full);
+		error = formatter(ip, &arg, &out[i], &full);
 		if (error || full)
 			break;
 	}
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index af97d9a..9919b9a 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -37,7 +37,8 @@ int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
 		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
 
 /* bmap to userspace formatter - copy to user & advance pointer */
-typedef int (*xfs_bmap_format_t)(void **, struct getbmapx *, int *);
+typedef int (*xfs_bmap_format_t)(xfs_inode_t *ip, void **, struct getbmapx *,
+		int *);
 int	xfs_getbmap(struct xfs_inode *ip, struct getbmapx *bmv,
 		xfs_bmap_format_t formatter, void *arg);
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index efc6e8d..c590786 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1352,7 +1352,7 @@ out_drop_write:
 }
 
 STATIC int
-xfs_getbmap_format(void **ap, struct getbmapx *bmv, int *full)
+xfs_getbmap_format(xfs_inode_t *ip, void **ap, struct getbmapx *bmv, int *full)
 {
 	struct getbmap __user	*base = (struct getbmap __user *)*ap;
 
@@ -1396,7 +1396,7 @@ xfs_ioc_getbmap(
 }
 
 STATIC int
-xfs_getbmapx_format(void **ap, struct getbmapx *bmv, int *full)
+xfs_getbmapx_format(xfs_inode_t *ip, void **ap, struct getbmapx *bmv, int *full)
 {
 	struct getbmapx __user	*base = (struct getbmapx __user *)*ap;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2923419..0336fed 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -38,6 +38,8 @@
 #include "xfs_dir2.h"
 #include "xfs_trans_space.h"
 #include "xfs_pnfs.h"
+#include "xfs_bit.h"
+#include "xfs_reflink.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -1017,14 +1019,21 @@ xfs_vn_update_time(
  */
 STATIC int
 xfs_fiemap_format(
+	xfs_inode_t		*ip,
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
+	xfs_extlen_t		elen;
+	xfs_nlink_t		nr;
+	xfs_fsblock_t		fsbno;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	xfs_mount_t		*mp = ip->i_mount;
 
 	/* Do nothing for a hole */
 	if (bmv->bmv_block == -1LL)
@@ -1032,7 +1041,7 @@ xfs_fiemap_format(
 
 	logical = BBTOB(bmv->bmv_offset);
 	physical = BBTOB(bmv->bmv_block);
-	length = BBTOB(bmv->bmv_length);
+	length = loop_len = BBTOB(bmv->bmv_length);
 
 	if (bmv->bmv_oflags & BMV_OF_PREALLOC)
 		fiemap_flags |= FIEMAP_EXTENT_UNWRITTEN;
@@ -1041,16 +1050,45 @@ xfs_fiemap_format(
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
+		} else if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+			fsbno = XFS_DADDR_TO_FSB(mp, BTOBB(physical));
+			agno = XFS_FSB_TO_AGNO(mp, fsbno);
+			agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+			error = xfs_reflink_get_refcount(mp, agno, agbno,
+					&elen, &nr);
+			if (error)
+				goto out;
+			len = XFS_FSB_TO_B(mp, elen);
+			if (len == 0 || len > loop_len)
+				len = loop_len;
+			if (nr >= 2)
+				ext_flags |= FIEMAP_EXTENT_SHARED;
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
