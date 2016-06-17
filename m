Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D900E7E23
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:27:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 975F8304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:27:07 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ejw0LLDXK1sCjLZm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:27:05 -0700 (PDT)
Subject: [PATCH 085/119] xfs: copy-on-write reflinked blocks when zeroing
	ranges of blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:26:56 -0700
Message-ID: <146612681688.12839.10527590239958274522.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

When we're writing zeroes to a reflinked block (such as when we're
punching a reflinked range), we need to fork the the block and write
to that, otherwise we can corrupt the other reflinks.

v2: Only call the end_cow functions if we had set should_fork, and
release the buffer if xfs_map_cow_blocks fails.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch@lst.de: Only call the end_cow functions if we had set should_fork]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c      |   12 ++++++++++++
 fs/xfs/xfs_bmap_util.c |   38 ++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_reflink.h   |    4 ++++
 3 files changed, 52 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 31318b3..812bae5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -394,6 +394,18 @@ xfs_map_blocks(
 	return 0;
 }
 
+/*
+ * Find a CoW mapping and ensure that blocks have been allocated to it.
+ */
+int
+xfs_map_cow_blocks(
+	struct inode		*inode,
+	xfs_off_t		offset,
+	struct xfs_bmbt_irec	*imap)
+{
+	return xfs_map_blocks(inode, offset, imap, XFS_IO_COW);
+}
+
 STATIC bool
 xfs_imap_valid(
 	struct inode		*inode,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8666873..79225fb 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -42,6 +42,8 @@
 #include "xfs_icache.h"
 #include "xfs_log.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_iomap.h"
+#include "xfs_reflink.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -1042,7 +1044,8 @@ xfs_zero_remaining_bytes(
 	xfs_buf_t		*bp;
 	xfs_mount_t		*mp = ip->i_mount;
 	int			nimap;
-	int			error = 0;
+	int			error = 0, err2;
+	bool			should_fork = false;
 
 	/*
 	 * Avoid doing I/O beyond eof - it's not necessary
@@ -1055,6 +1058,11 @@ xfs_zero_remaining_bytes(
 	if (endoff > XFS_ISIZE(ip))
 		endoff = XFS_ISIZE(ip);
 
+	error = xfs_reflink_reserve_cow_range(ip, startoff,
+			endoff - startoff + 1);
+	if (error)
+		return error;
+
 	for (offset = startoff; offset <= endoff; offset = lastoffset + 1) {
 		uint lock_mode;
 
@@ -1063,6 +1071,10 @@ xfs_zero_remaining_bytes(
 
 		lock_mode = xfs_ilock_data_map_shared(ip);
 		error = xfs_bmapi_read(ip, offset_fsb, 1, &imap, &nimap, 0);
+
+		/* Do we need to CoW this block? */
+		if (error == 0 && nimap == 1)
+			should_fork = xfs_reflink_is_cow_pending(ip, offset);
 		xfs_iunlock(ip, lock_mode);
 
 		if (error || nimap < 1)
@@ -1084,7 +1096,7 @@ xfs_zero_remaining_bytes(
 			lastoffset = endoff;
 
 		/* DAX can just zero the backing device directly */
-		if (IS_DAX(VFS_I(ip))) {
+		if (IS_DAX(VFS_I(ip)) && !should_fork) {
 			error = dax_zero_page_range(VFS_I(ip), offset,
 						    lastoffset - offset + 1,
 						    xfs_get_blocks_direct);
@@ -1105,8 +1117,30 @@ xfs_zero_remaining_bytes(
 				(offset - XFS_FSB_TO_B(mp, imap.br_startoff)),
 		       0, lastoffset - offset + 1);
 
+		if (should_fork) {
+			xfs_fsblock_t	new_fsbno;
+
+			error = xfs_map_cow_blocks(VFS_I(ip), offset, &imap);
+			if (error) {
+				xfs_buf_relse(bp);
+				return error;
+			}
+			new_fsbno = imap.br_startblock +
+					(offset_fsb - imap.br_startoff);
+			XFS_BUF_SET_ADDR(bp, XFS_FSB_TO_DADDR(mp, new_fsbno));
+		}
+
 		error = xfs_bwrite(bp);
 		xfs_buf_relse(bp);
+		if (should_fork) {
+			if (error) {
+				err2 = xfs_reflink_cancel_cow_range(ip, offset,
+						lastoffset - offset + 1);
+				return error;
+			}
+			error = xfs_reflink_end_cow(ip, offset,
+					lastoffset - offset + 1);
+		}
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index fb128dd..2f3c829 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -41,4 +41,8 @@ extern int xfs_reflink_cancel_cow_range(struct xfs_inode *ip, xfs_off_t offset,
 extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t count);
 
+/* xfs_aops.c */
+extern int xfs_map_cow_blocks(struct inode *inode, xfs_off_t offset,
+		struct xfs_bmbt_irec *imap);
+
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
