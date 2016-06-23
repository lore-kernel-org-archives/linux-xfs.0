Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D3A787CA1
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 22:17:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 982EB8F8037
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 20:17:29 -0700 (PDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [119.145.14.65])
	by cuda.sgi.com with ESMTP id Q3qXb05W3yoOpxs2 (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2016 20:17:26 -0700 (PDT)
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH] xfs: remove the magic numbers in xfs_btree_block-related len
	macros
Date: Thu, 23 Jun 2016 11:10:20 +0800
Message-ID: <1466651420-126472-1-git-send-email-houtao1@huawei.com>
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
To: xfs@oss.sgi.com

replace the magic numbers by offsetof(...) and sizeof(...), and add two
extra checks on xfs_check_ondisk_structs()

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/libxfs/xfs_format.h | 66 ++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_ondisk.h        |  2 ++
 2 files changed, 43 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index dc97eb21..d3069be 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1435,41 +1435,57 @@ typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_ptr_t;
  * with the crc feature bit, and all accesses to them must be conditional on
  * that flag.
  */
+/* short form block */
+struct xfs_btree_sblock_part {
+	__be32		bb_leftsib;
+	__be32		bb_rightsib;
+
+	__be64		bb_blkno;
+	__be64		bb_lsn;
+	uuid_t		bb_uuid;
+	__be32		bb_owner;
+	__le32		bb_crc;
+};
+
+/* long form block */
+struct xfs_btree_lblock_part {
+	__be64		bb_leftsib;
+	__be64		bb_rightsib;
+
+	__be64		bb_blkno;
+	__be64		bb_lsn;
+	uuid_t		bb_uuid;
+	__be64		bb_owner;
+	__le32		bb_crc;
+	__be32		bb_pad; /* padding for alignment */
+};
+
 struct xfs_btree_block {
 	__be32		bb_magic;	/* magic number for block type */
 	__be16		bb_level;	/* 0 is a leaf */
 	__be16		bb_numrecs;	/* current # of data records */
 	union {
-		struct {
-			__be32		bb_leftsib;
-			__be32		bb_rightsib;
-
-			__be64		bb_blkno;
-			__be64		bb_lsn;
-			uuid_t		bb_uuid;
-			__be32		bb_owner;
-			__le32		bb_crc;
-		} s;			/* short form pointers */
-		struct	{
-			__be64		bb_leftsib;
-			__be64		bb_rightsib;
-
-			__be64		bb_blkno;
-			__be64		bb_lsn;
-			uuid_t		bb_uuid;
-			__be64		bb_owner;
-			__le32		bb_crc;
-			__be32		bb_pad; /* padding for alignment */
-		} l;			/* long form pointers */
+		struct xfs_btree_sblock_part s;
+		struct xfs_btree_lblock_part l;
 	} bb_u;				/* rest */
 };
 
-#define XFS_BTREE_SBLOCK_LEN	16	/* size of a short form block */
-#define XFS_BTREE_LBLOCK_LEN	24	/* size of a long form block */
+/* size of a short form block */
+#define XFS_BTREE_SBLOCK_LEN \
+	(offsetof(struct xfs_btree_block, bb_u) + \
+	 offsetof(struct xfs_btree_sblock_part, bb_blkno))
+/* size of a long form block */
+#define XFS_BTREE_LBLOCK_LEN \
+	(offsetof(struct xfs_btree_block, bb_u) + \
+	 offsetof(struct xfs_btree_lblock_part, bb_blkno))
 
 /* sizes of CRC enabled btree blocks */
-#define XFS_BTREE_SBLOCK_CRC_LEN	(XFS_BTREE_SBLOCK_LEN + 40)
-#define XFS_BTREE_LBLOCK_CRC_LEN	(XFS_BTREE_LBLOCK_LEN + 48)
+#define XFS_BTREE_SBLOCK_CRC_LEN \
+	(offsetof(struct xfs_btree_block, bb_u) + \
+	 sizeof(struct xfs_btree_sblock_part))
+#define XFS_BTREE_LBLOCK_CRC_LEN \
+	(offsetof(struct xfs_btree_block, bb_u) + \
+	 sizeof(struct xfs_btree_lblock_part))
 
 #define XFS_BTREE_SBLOCK_CRC_OFF \
 	offsetof(struct xfs_btree_block, bb_u.s.bb_crc)
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 184c44e..6f06c48 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -34,6 +34,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_sblock_part,	48);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_lblock_part,	64);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block,		72);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
