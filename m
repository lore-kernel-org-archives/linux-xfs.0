Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B2F07F50
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 02:40:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8D722AC002
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 00:40:05 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 5Fa2uYwwkwcevfSG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Nov 2013 00:40:01 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VmJcG-0000AE-Jp
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 08:40:00 +0000
Message-Id: <20131129084000.509159807@bombadil.infradead.org>
Date: Fri, 29 Nov 2013 00:39:22 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/10] xfs: refactor xfs_inode_item_size
References: <20131129083919.207915844@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0003-xfs-refactor-xfs_inode_item_size.patch
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

Split out two helpers to size the data and attribute to make the
function more readable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode_item.c |   62 ++++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 7c0d391f..050d254 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -39,27 +39,14 @@ static inline struct xfs_inode_log_item *INODE_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_inode_log_item, ili_item);
 }
 
-
-/*
- * This returns the number of iovecs needed to log the given inode item.
- *
- * We need one iovec for the inode log format structure, one for the
- * inode core, and possibly one for the inode data/extents/b-tree root
- * and one for the inode attribute data/extents/b-tree root.
- */
 STATIC void
-xfs_inode_item_size(
-	struct xfs_log_item	*lip,
+xfs_inode_item_data_fork_size(
+	struct xfs_inode_log_item *iip,
 	int			*nvecs,
 	int			*nbytes)
 {
-	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
 
-	*nvecs += 2;
-	*nbytes += sizeof(struct xfs_inode_log_format) +
-		   xfs_icdinode_size(ip->i_d.di_version);
-
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		if ((iip->ili_fields & XFS_ILOG_DEXT) &&
@@ -70,7 +57,6 @@ xfs_inode_item_size(
 			*nvecs += 1;
 		}
 		break;
-
 	case XFS_DINODE_FMT_BTREE:
 		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
 		    ip->i_df.if_broot_bytes > 0) {
@@ -78,7 +64,6 @@ xfs_inode_item_size(
 			*nvecs += 1;
 		}
 		break;
-
 	case XFS_DINODE_FMT_LOCAL:
 		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
 		    ip->i_df.if_bytes > 0) {
@@ -90,19 +75,20 @@ xfs_inode_item_size(
 	case XFS_DINODE_FMT_DEV:
 	case XFS_DINODE_FMT_UUID:
 		break;
-
 	default:
 		ASSERT(0);
 		break;
 	}
+}
 
-	if (!XFS_IFORK_Q(ip))
-		return;
-
+STATIC void
+xfs_inode_item_attr_fork_size(
+	struct xfs_inode_log_item *iip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	struct xfs_inode	*ip = iip->ili_inode;
 
-	/*
-	 * Log any necessary attribute data.
-	 */
 	switch (ip->i_d.di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
 		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
@@ -113,7 +99,6 @@ xfs_inode_item_size(
 			*nvecs += 1;
 		}
 		break;
-
 	case XFS_DINODE_FMT_BTREE:
 		if ((iip->ili_fields & XFS_ILOG_ABROOT) &&
 		    ip->i_afp->if_broot_bytes > 0) {
@@ -121,7 +106,6 @@ xfs_inode_item_size(
 			*nvecs += 1;
 		}
 		break;
-
 	case XFS_DINODE_FMT_LOCAL:
 		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
 		    ip->i_afp->if_bytes > 0) {
@@ -129,7 +113,6 @@ xfs_inode_item_size(
 			*nvecs += 1;
 		}
 		break;
-
 	default:
 		ASSERT(0);
 		break;
@@ -137,6 +120,31 @@ xfs_inode_item_size(
 }
 
 /*
+ * This returns the number of iovecs needed to log the given inode item.
+ *
+ * We need one iovec for the inode log format structure, one for the
+ * inode core, and possibly one for the inode data/extents/b-tree root
+ * and one for the inode attribute data/extents/b-tree root.
+ */
+STATIC void
+xfs_inode_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+	struct xfs_inode	*ip = iip->ili_inode;
+
+	*nvecs += 2;
+	*nbytes += sizeof(struct xfs_inode_log_format) +
+		   xfs_icdinode_size(ip->i_d.di_version);
+
+	xfs_inode_item_data_fork_size(iip, nvecs, nbytes);
+	if (XFS_IFORK_Q(ip))
+		xfs_inode_item_attr_fork_size(iip, nvecs, nbytes);
+}
+
+/*
  * xfs_inode_item_format_extents - convert in-core extents to on-disk form
  *
  * For either the data or attr fork in extent format, we need to endian convert
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
