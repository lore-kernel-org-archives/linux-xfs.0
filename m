Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E8837F3F
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 02:40:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0CEF6AC003
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 00:40:02 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id jPhZ2eIVpiXsM8b2 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Nov 2013 00:40:01 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VmJcG-0000An-Pb
	for xfs@oss.sgi.com; Fri, 29 Nov 2013 08:40:00 +0000
Message-Id: <20131129084000.669357715@bombadil.infradead.org>
Date: Fri, 29 Nov 2013 00:39:23 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/10] xfs: refactor xfs_inode_item_format
References: <20131129083919.207915844@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0004-xfs-refactor-xfs_inode_item_format.patch
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

Split out a function to handle the data and attr fork, as well as a helper
for the really old v1 inodes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode_item.c |  165 +++++++++++++++++++++++++----------------------
 1 file changed, 89 insertions(+), 76 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 050d254..96554a3 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -180,63 +180,41 @@ xfs_inode_item_format_extents(
 }
 
 /*
- * This is called to fill in the vector of log iovecs for the
- * given inode log item.  It fills the first item with an inode
- * log format structure, the second with the on-disk inode structure,
- * and a possible third and/or fourth with the inode data/extents/b-tree
- * root and inode attributes data/extents/b-tree root.
+ * If this is a v1 format inode, then we need to log it as such.  This means
+ * that we have to copy the link count from the new field to the old.  We
+ * don't have to worry about the new fields, because nothing trusts them as
+ * long as the old inode version number is there.
  */
 STATIC void
-xfs_inode_item_format(
-	struct xfs_log_item	*lip,
-	struct xfs_log_iovec	*vecp)
+xfs_inode_item_format_v1_inode(
+	struct xfs_inode	*ip)
+{
+	if (!xfs_sb_version_hasnlink(&ip->i_mount->m_sb)) {
+		/*
+		 * Convert it back.
+		 */
+		ASSERT(ip->i_d.di_nlink <= XFS_MAXLINK_1);
+		ip->i_d.di_onlink = ip->i_d.di_nlink;
+	} else {
+		/*
+		 * The superblock version has already been bumped,
+		 * so just make the conversion to the new inode
+		 * format permanent.
+		 */
+		ip->i_d.di_version = 2;
+		ip->i_d.di_onlink = 0;
+		memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
+	}
+}
+	
+STATIC struct xfs_log_iovec *
+xfs_inode_item_format_data_fork(
+	struct xfs_inode_log_item *iip,
+	struct xfs_log_iovec	*vecp,
+	int			*nvecs)
 {
-	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
-	uint			nvecs;
 	size_t			data_bytes;
-	xfs_mount_t		*mp;
-
-	vecp->i_addr = &iip->ili_format;
-	vecp->i_len  = sizeof(xfs_inode_log_format_t);
-	vecp->i_type = XLOG_REG_TYPE_IFORMAT;
-	vecp++;
-	nvecs	     = 1;
-
-	vecp->i_addr = &ip->i_d;
-	vecp->i_len  = xfs_icdinode_size(ip->i_d.di_version);
-	vecp->i_type = XLOG_REG_TYPE_ICORE;
-	vecp++;
-	nvecs++;
-
-	/*
-	 * If this is really an old format inode, then we need to
-	 * log it as such.  This means that we have to copy the link
-	 * count from the new field to the old.  We don't have to worry
-	 * about the new fields, because nothing trusts them as long as
-	 * the old inode version number is there.  If the superblock already
-	 * has a new version number, then we don't bother converting back.
-	 */
-	mp = ip->i_mount;
-	ASSERT(ip->i_d.di_version == 1 || xfs_sb_version_hasnlink(&mp->m_sb));
-	if (ip->i_d.di_version == 1) {
-		if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
-			/*
-			 * Convert it back.
-			 */
-			ASSERT(ip->i_d.di_nlink <= XFS_MAXLINK_1);
-			ip->i_d.di_onlink = ip->i_d.di_nlink;
-		} else {
-			/*
-			 * The superblock version has already been bumped,
-			 * so just make the conversion to the new inode
-			 * format permanent.
-			 */
-			ip->i_d.di_version = 2;
-			ip->i_d.di_onlink = 0;
-			memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
-		}
-	}
 
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
@@ -271,12 +249,11 @@ xfs_inode_item_format(
 			ASSERT(vecp->i_len <= ip->i_df.if_bytes);
 			iip->ili_format.ilf_dsize = vecp->i_len;
 			vecp++;
-			nvecs++;
+			(*nvecs)++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_DEXT;
 		}
 		break;
-
 	case XFS_DINODE_FMT_BTREE:
 		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT |
@@ -289,7 +266,7 @@ xfs_inode_item_format(
 			vecp->i_len = ip->i_df.if_broot_bytes;
 			vecp->i_type = XLOG_REG_TYPE_IBROOT;
 			vecp++;
-			nvecs++;
+			(*nvecs)++;
 			iip->ili_format.ilf_dsize = ip->i_df.if_broot_bytes;
 		} else {
 			ASSERT(!(iip->ili_fields &
@@ -297,7 +274,6 @@ xfs_inode_item_format(
 			iip->ili_fields &= ~XFS_ILOG_DBROOT;
 		}
 		break;
-
 	case XFS_DINODE_FMT_LOCAL:
 		iip->ili_fields &=
 			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT |
@@ -319,13 +295,12 @@ xfs_inode_item_format(
 			vecp->i_len = (int)data_bytes;
 			vecp->i_type = XLOG_REG_TYPE_ILOCAL;
 			vecp++;
-			nvecs++;
+			(*nvecs)++;
 			iip->ili_format.ilf_dsize = (unsigned)data_bytes;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_DDATA;
 		}
 		break;
-
 	case XFS_DINODE_FMT_DEV:
 		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
@@ -335,7 +310,6 @@ xfs_inode_item_format(
 				ip->i_df.if_u2.if_rdev;
 		}
 		break;
-
 	case XFS_DINODE_FMT_UUID:
 		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT |
@@ -345,20 +319,22 @@ xfs_inode_item_format(
 				ip->i_df.if_u2.if_uuid;
 		}
 		break;
-
 	default:
 		ASSERT(0);
 		break;
 	}
 
-	/*
-	 * If there are no attributes associated with the file, then we're done.
-	 */
-	if (!XFS_IFORK_Q(ip)) {
-		iip->ili_fields &=
-			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);
-		goto out;
-	}
+	return vecp;
+}
+
+STATIC struct xfs_log_iovec *
+xfs_inode_item_format_attr_fork(
+	struct xfs_inode_log_item *iip,
+	struct xfs_log_iovec	*vecp,
+	int			*nvecs)
+{
+	struct xfs_inode	*ip = iip->ili_inode;
+	size_t			data_bytes;
 
 	switch (ip->i_d.di_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
@@ -386,12 +362,11 @@ xfs_inode_item_format(
 #endif
 			iip->ili_format.ilf_asize = vecp->i_len;
 			vecp++;
-			nvecs++;
+			(*nvecs)++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_AEXT;
 		}
 		break;
-
 	case XFS_DINODE_FMT_BTREE:
 		iip->ili_fields &=
 			~(XFS_ILOG_ADATA | XFS_ILOG_AEXT);
@@ -404,13 +379,12 @@ xfs_inode_item_format(
 			vecp->i_len = ip->i_afp->if_broot_bytes;
 			vecp->i_type = XLOG_REG_TYPE_IATTR_BROOT;
 			vecp++;
-			nvecs++;
+			(*nvecs)++;
 			iip->ili_format.ilf_asize = ip->i_afp->if_broot_bytes;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_ABROOT;
 		}
 		break;
-
 	case XFS_DINODE_FMT_LOCAL:
 		iip->ili_fields &=
 			~(XFS_ILOG_AEXT | XFS_ILOG_ABROOT);
@@ -431,19 +405,59 @@ xfs_inode_item_format(
 			vecp->i_len = (int)data_bytes;
 			vecp->i_type = XLOG_REG_TYPE_IATTR_LOCAL;
 			vecp++;
-			nvecs++;
+			(*nvecs)++;
 			iip->ili_format.ilf_asize = (unsigned)data_bytes;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_ADATA;
 		}
 		break;
-
 	default:
 		ASSERT(0);
 		break;
 	}
 
-out:
+	return vecp;
+}
+
+/*
+ * This is called to fill in the vector of log iovecs for the given inode
+ * log item.  It fills the first item with an inode log format structure,
+ * the second with the on-disk inode structure, and a possible third and/or
+ * fourth with the inode data/extents/b-tree root and inode attributes
+ * data/extents/b-tree root.
+ */
+STATIC void
+xfs_inode_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_iovec	*vecp)
+{
+	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+	struct xfs_inode	*ip = iip->ili_inode;
+	uint			nvecs;
+
+	vecp->i_addr = &iip->ili_format;
+	vecp->i_len  = sizeof(xfs_inode_log_format_t);
+	vecp->i_type = XLOG_REG_TYPE_IFORMAT;
+	vecp++;
+	nvecs	     = 1;
+
+	vecp->i_addr = &ip->i_d;
+	vecp->i_len  = xfs_icdinode_size(ip->i_d.di_version);
+	vecp->i_type = XLOG_REG_TYPE_ICORE;
+	vecp++;
+	nvecs++;
+
+	if (ip->i_d.di_version == 1)
+		xfs_inode_item_format_v1_inode(ip);
+
+	vecp = xfs_inode_item_format_data_fork(iip, vecp, &nvecs);
+	if (XFS_IFORK_Q(ip)) {
+		vecp = xfs_inode_item_format_attr_fork(iip, vecp, &nvecs);
+	} else {
+		iip->ili_fields &=
+			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);
+	}
+
 	/*
 	 * Now update the log format that goes out to disk from the in-core
 	 * values.  We always write the inode core to make the arithmetic
@@ -455,7 +469,6 @@ out:
 	iip->ili_format.ilf_size = nvecs;
 }
 
-
 /*
  * This is called to pin the inode associated with the inode log
  * item in memory so it cannot be written out.
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
