Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 308A48107
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:03:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 04640304053
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:17 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 1nb0XKPnTPS36GKe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:16 -0800 (PST)
Subject: [PATCH 61/76] xfs: copy-on-write reflinked blocks when zeroing
	ranges of blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:03:13 -0800
Message-ID: <20151219090313.12713.34369.stgit@birch.djwong.org>
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

When we're writing zeroes to a reflinked block (such as when we're
punching a reflinked range), we need to fork the the block and write
to that, otherwise we can corrupt the other reflinks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c      |   17 +++++++++++++++++
 fs/xfs/xfs_bmap_util.c |   34 ++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_reflink.h   |    3 +++
 3 files changed, 52 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4b77d07..185415a 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -374,6 +374,23 @@ xfs_map_blocks(
 	return 0;
 }
 
+/*
+ * xfs_map_cow_blocks() -- Find a CoW mapping and ensure that blocks have been
+ *			   allocated to it.
+ * @inode: VFS inode.
+ * @offset: File offset to allocate.
+ * @imap: (out) Block mapping.
+ */
+int
+xfs_map_cow_blocks(
+	struct inode		*inode,
+	xfs_off_t		offset,
+	struct xfs_bmbt_irec	*imap)
+{
+	return xfs_map_blocks(inode, offset, imap, XFS_IO_OVERWRITE,
+			false, true);
+}
+
 STATIC int
 xfs_imap_valid(
 	struct inode		*inode,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ad4eca7..983d8f6 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -41,6 +41,8 @@
 #include "xfs_icache.h"
 #include "xfs_log.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_iomap.h"
+#include "xfs_reflink.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -1138,7 +1140,8 @@ xfs_zero_remaining_bytes(
 	xfs_buf_t		*bp;
 	xfs_mount_t		*mp = ip->i_mount;
 	int			nimap;
-	int			error = 0;
+	int			error = 0, err2;
+	bool			should_fork = false;
 
 	/*
 	 * Avoid doing I/O beyond eof - it's not necessary
@@ -1151,6 +1154,11 @@ xfs_zero_remaining_bytes(
 	if (endoff > XFS_ISIZE(ip))
 		endoff = XFS_ISIZE(ip);
 
+	error = xfs_reflink_reserve_cow_range(ip, startoff,
+			endoff - startoff + 1);
+	if (error)
+		return error;
+
 	for (offset = startoff; offset <= endoff; offset = lastoffset + 1) {
 		uint lock_mode;
 
@@ -1159,6 +1167,10 @@ xfs_zero_remaining_bytes(
 
 		lock_mode = xfs_ilock_data_map_shared(ip);
 		error = xfs_bmapi_read(ip, offset_fsb, 1, &imap, &nimap, 0);
+
+		/* Do we need to CoW this block? */
+		if (error == 0 && nimap == 1)
+			should_fork = xfs_reflink_is_cow_pending(ip, offset);
 		xfs_iunlock(ip, lock_mode);
 
 		if (error || nimap < 1)
@@ -1180,7 +1192,7 @@ xfs_zero_remaining_bytes(
 			lastoffset = endoff;
 
 		/* DAX can just zero the backing device directly */
-		if (IS_DAX(VFS_I(ip))) {
+		if (IS_DAX(VFS_I(ip)) && !should_fork) {
 			error = dax_zero_page_range(VFS_I(ip), offset,
 						    lastoffset - offset + 1,
 						    xfs_get_blocks_direct);
@@ -1201,8 +1213,26 @@ xfs_zero_remaining_bytes(
 				(offset - XFS_FSB_TO_B(mp, imap.br_startoff)),
 		       0, lastoffset - offset + 1);
 
+		if (should_fork) {
+			xfs_fsblock_t	new_fsbno;
+
+			error = xfs_map_cow_blocks(VFS_I(ip), offset, &imap);
+			if (error)
+				return error;
+			new_fsbno = imap.br_startblock +
+					(offset_fsb - imap.br_startoff);
+			XFS_BUF_SET_ADDR(bp, XFS_FSB_TO_DADDR(mp, new_fsbno));
+		}
+
 		error = xfs_bwrite(bp);
 		xfs_buf_relse(bp);
+		if (error) {
+			err2 = xfs_reflink_end_cow_failed(ip, offset,
+					lastoffset - offset + 1);
+			return error;
+		}
+		error = xfs_reflink_end_cow(ip, offset,
+				lastoffset - offset + 1);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index d356c00..2d2832b 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -33,4 +33,7 @@ extern int xfs_reflink_end_cow_failed(struct xfs_inode *ip, xfs_off_t offset,
 extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 		size_t count);
 
+int	xfs_map_cow_blocks(struct inode *inode, xfs_off_t offset,
+			   struct xfs_bmbt_irec	*imap);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
