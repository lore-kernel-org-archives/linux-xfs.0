Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC2ED7F4E
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 13:14:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BB028304062
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 11:14:40 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id 9KxfPkImvlCy5VlR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2014 11:14:38 -0800 (PST)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xti2u-0002p3-JG
	for xfs@oss.sgi.com; Wed, 26 Nov 2014 19:14:36 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/5] xfs: move acl structures to xfs_format.h
Date: Wed, 26 Nov 2014 20:14:24 +0100
Message-Id: <1417029267-20149-2-git-send-email-hch@lst.de>
In-Reply-To: <1417029267-20149-1-git-send-email-hch@lst.de>
References: <1417029267-20149-1-git-send-email-hch@lst.de>
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

Move the on-disk ACL format to xfs_format.h, so that repair can
use the common defintion.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h | 36 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_acl.h           | 36 ------------------------------------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 3be17ee..e99d329 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -627,4 +627,40 @@ struct xfs_btree_block {
 #define XFS_BTREE_LBLOCK_CRC_OFF \
 	offsetof(struct xfs_btree_block, bb_u.l.bb_crc)
 
+/*
+ * On-disk XFS access control list structure.
+ */
+struct xfs_acl_entry {
+	__be32	ae_tag;
+	__be32	ae_id;
+	__be16	ae_perm;
+	__be16	ae_pad;		/* fill the implicit hole in the structure */
+};
+
+struct xfs_acl {
+	__be32			acl_cnt;
+	struct xfs_acl_entry	acl_entry[0];
+};
+
+/*
+ * The number of ACL entries allowed is defined by the on-disk format.
+ * For v4 superblocks, that is limited to 25 entries. For v5 superblocks, it is
+ * limited only by the maximum size of the xattr that stores the information.
+ */
+#define XFS_ACL_MAX_ENTRIES(mp)	\
+	(xfs_sb_version_hascrc(&mp->m_sb) \
+		?  (XATTR_SIZE_MAX - sizeof(struct xfs_acl)) / \
+						sizeof(struct xfs_acl_entry) \
+		: 25)
+
+#define XFS_ACL_MAX_SIZE(mp) \
+	(sizeof(struct xfs_acl) + \
+		sizeof(struct xfs_acl_entry) * XFS_ACL_MAX_ENTRIES((mp)))
+
+/* On-disk XFS extended attribute names */
+#define SGI_ACL_FILE		(unsigned char *)"SGI_ACL_FILE"
+#define SGI_ACL_DEFAULT		(unsigned char *)"SGI_ACL_DEFAULT"
+#define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
+#define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
+
 #endif /* __XFS_FORMAT_H__ */
diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 5dc1637..3841b07 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -22,42 +22,6 @@ struct inode;
 struct posix_acl;
 struct xfs_inode;
 
-#define XFS_ACL_NOT_PRESENT (-1)
-
-/* On-disk XFS access control list structure */
-struct xfs_acl_entry {
-	__be32	ae_tag;
-	__be32	ae_id;
-	__be16	ae_perm;
-	__be16	ae_pad;		/* fill the implicit hole in the structure */
-};
-
-struct xfs_acl {
-	__be32			acl_cnt;
-	struct xfs_acl_entry	acl_entry[0];
-};
-
-/*
- * The number of ACL entries allowed is defined by the on-disk format.
- * For v4 superblocks, that is limited to 25 entries. For v5 superblocks, it is
- * limited only by the maximum size of the xattr that stores the information.
- */
-#define XFS_ACL_MAX_ENTRIES(mp)	\
-	(xfs_sb_version_hascrc(&mp->m_sb) \
-		?  (XATTR_SIZE_MAX - sizeof(struct xfs_acl)) / \
-						sizeof(struct xfs_acl_entry) \
-		: 25)
-
-#define XFS_ACL_MAX_SIZE(mp) \
-	(sizeof(struct xfs_acl) + \
-		sizeof(struct xfs_acl_entry) * XFS_ACL_MAX_ENTRIES((mp)))
-
-/* On-disk XFS extended attribute names */
-#define SGI_ACL_FILE		(unsigned char *)"SGI_ACL_FILE"
-#define SGI_ACL_DEFAULT		(unsigned char *)"SGI_ACL_DEFAULT"
-#define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
-#define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
-
 #ifdef CONFIG_XFS_POSIX_ACL
 extern struct posix_acl *xfs_get_acl(struct inode *inode, int type);
 extern int xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
