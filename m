Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CEB957CA7
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 02:53:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 409A4AC003
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 00:53:01 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id y3mb1HQRXaaTPPIp (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 24 Jun 2016 00:52:58 -0700 (PDT)
Received: from [91.114.64.3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bGLv7-0002rM-J6
	for xfs@oss.sgi.com; Fri, 24 Jun 2016 07:52:58 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] xfs: kill xfs_dir2_inou_t
Date: Fri, 24 Jun 2016 09:52:46 +0200
Message-Id: <1466754767-10657-3-git-send-email-hch@lst.de>
In-Reply-To: <1466754767-10657-1-git-send-email-hch@lst.de>
References: <1466754767-10657-1-git-send-email-hch@lst.de>
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

And use an array of unsigned char values directly to avoid problems
with architectures that pad the size of structures.  This also gets
rid of the xfs_dir2_ino4_t and xfs_dir2_ino8_t types, and introduces
new constants for the size of 4 and 8 bytes as well as the size
difference between the two.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c | 31 +++++++++++++------------------
 fs/xfs/libxfs/xfs_da_format.h | 27 +++++++--------------------
 fs/xfs/libxfs/xfs_dir2_sf.c   | 25 ++++++-------------------
 fs/xfs/xfs_ondisk.h           |  3 ---
 4 files changed, 26 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 9d624a6..f1e8d4d 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -40,8 +40,7 @@ xfs_dir2_sf_entsize(
 	int count = sizeof(struct xfs_dir2_sf_entry);	/* namelen + offset */
 
 	count += len;					/* name */
-	count += hdr->i8count ? sizeof(xfs_dir2_ino8_t) :
-				sizeof(xfs_dir2_ino4_t); /* ino # */
+	count += hdr->i8count ? XFS_INO64_SIZE : XFS_INO32_SIZE; /* ino # */
 	return count;
 }
 
@@ -125,33 +124,33 @@ xfs_dir3_sfe_put_ftype(
 static xfs_ino_t
 xfs_dir2_sf_get_ino(
 	struct xfs_dir2_sf_hdr	*hdr,
-	xfs_dir2_inou_t		*from)
+	__uint8_t		*from)
 {
 	if (hdr->i8count)
-		return get_unaligned_be64(&from->i8.i) & 0x00ffffffffffffffULL;
+		return get_unaligned_be64(from) & 0x00ffffffffffffffULL;
 	else
-		return get_unaligned_be32(&from->i4.i);
+		return get_unaligned_be32(from);
 }
 
 static void
 xfs_dir2_sf_put_ino(
 	struct xfs_dir2_sf_hdr	*hdr,
-	xfs_dir2_inou_t		*to,
+	__uint8_t		*to,
 	xfs_ino_t		ino)
 {
 	ASSERT((ino & 0xff00000000000000ULL) == 0);
 
 	if (hdr->i8count)
-		put_unaligned_be64(ino, &to->i8.i);
+		put_unaligned_be64(ino, to);
 	else
-		put_unaligned_be32(ino, &to->i4.i);
+		put_unaligned_be32(ino, to);
 }
 
 static xfs_ino_t
 xfs_dir2_sf_get_parent_ino(
 	struct xfs_dir2_sf_hdr	*hdr)
 {
-	return xfs_dir2_sf_get_ino(hdr, &hdr->parent);
+	return xfs_dir2_sf_get_ino(hdr, hdr->parent);
 }
 
 static void
@@ -159,7 +158,7 @@ xfs_dir2_sf_put_parent_ino(
 	struct xfs_dir2_sf_hdr	*hdr,
 	xfs_ino_t		ino)
 {
-	xfs_dir2_sf_put_ino(hdr, &hdr->parent, ino);
+	xfs_dir2_sf_put_ino(hdr, hdr->parent, ino);
 }
 
 /*
@@ -173,8 +172,7 @@ xfs_dir2_sfe_get_ino(
 	struct xfs_dir2_sf_hdr	*hdr,
 	struct xfs_dir2_sf_entry *sfep)
 {
-	return xfs_dir2_sf_get_ino(hdr,
-				(xfs_dir2_inou_t *)&sfep->name[sfep->namelen]);
+	return xfs_dir2_sf_get_ino(hdr, &sfep->name[sfep->namelen]);
 }
 
 static void
@@ -183,8 +181,7 @@ xfs_dir2_sfe_put_ino(
 	struct xfs_dir2_sf_entry *sfep,
 	xfs_ino_t		ino)
 {
-	xfs_dir2_sf_put_ino(hdr,
-			    (xfs_dir2_inou_t *)&sfep->name[sfep->namelen], ino);
+	xfs_dir2_sf_put_ino(hdr, &sfep->name[sfep->namelen], ino);
 }
 
 static xfs_ino_t
@@ -192,8 +189,7 @@ xfs_dir3_sfe_get_ino(
 	struct xfs_dir2_sf_hdr	*hdr,
 	struct xfs_dir2_sf_entry *sfep)
 {
-	return xfs_dir2_sf_get_ino(hdr,
-			(xfs_dir2_inou_t *)&sfep->name[sfep->namelen + 1]);
+	return xfs_dir2_sf_get_ino(hdr, &sfep->name[sfep->namelen + 1]);
 }
 
 static void
@@ -202,8 +198,7 @@ xfs_dir3_sfe_put_ino(
 	struct xfs_dir2_sf_entry *sfep,
 	xfs_ino_t		ino)
 {
-	xfs_dir2_sf_put_ino(hdr,
-			(xfs_dir2_inou_t *)&sfep->name[sfep->namelen + 1], ino);
+	xfs_dir2_sf_put_ino(hdr, &sfep->name[sfep->namelen + 1], ino);
 }
 
 
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index a5f4d6e..f877bb1 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -208,22 +208,10 @@ typedef	xfs_off_t	xfs_dir2_off_t;
  */
 typedef	__uint32_t	xfs_dir2_db_t;
 
-/*
- * Inode number stored as 8 8-bit values.
- */
-typedef	struct { __uint8_t i[8]; } xfs_dir2_ino8_t;
-
-/*
- * Inode number stored as 4 8-bit values.
- * Works a lot of the time, when all the inode numbers in a directory
- * fit in 32 bits.
- */
-typedef struct { __uint8_t i[4]; } xfs_dir2_ino4_t;
+#define XFS_INO32_SIZE	4
+#define XFS_INO64_SIZE	8
+#define XFS_INO64_DIFF	(XFS_INO64_SIZE - XFS_INO32_SIZE)
 
-typedef union {
-	xfs_dir2_ino8_t	i8;
-	xfs_dir2_ino4_t	i4;
-} xfs_dir2_inou_t;
 #define	XFS_DIR2_MAX_SHORT_INUM	((xfs_ino_t)0xffffffffULL)
 
 /*
@@ -240,7 +228,7 @@ typedef union {
 typedef struct xfs_dir2_sf_hdr {
 	__uint8_t		count;		/* count of entries */
 	__uint8_t		i8count;	/* count of 8-byte inode #s */
-	xfs_dir2_inou_t		parent;		/* parent dir inode number */
+	__uint8_t		parent[8];	/* parent dir inode number */
 } __arch_pack xfs_dir2_sf_hdr_t;
 
 typedef struct xfs_dir2_sf_entry {
@@ -251,16 +239,15 @@ typedef struct xfs_dir2_sf_entry {
 	 * A single byte containing the file type field follows the inode
 	 * number for version 3 directory entries.
 	 *
-	 * A xfs_dir2_ino8_t or xfs_dir2_ino4_t follows here, at a
-	 * variable offset after the name.
+	 * A 64-bit or 32-bit inode number follows here, at a variable offset
+	 * after the name.
 	 */
 } xfs_dir2_sf_entry_t;
 
 static inline int xfs_dir2_sf_hdr_size(int i8count)
 {
 	return sizeof(struct xfs_dir2_sf_hdr) -
-		(i8count == 0) *
-		(sizeof(xfs_dir2_ino8_t) - sizeof(xfs_dir2_ino4_t));
+		(i8count == 0) * XFS_INO64_DIFF;
 }
 
 static inline xfs_dir2_data_aoff_t
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index f8ccfd5a..c6809ff 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -130,8 +130,8 @@ xfs_dir2_block_sfsize(
 		       count * 3 * sizeof(u8) +		/* namelen + offset */
 		       namelen +			/* name */
 		       (i8count ?			/* inumber */
-				(uint)sizeof(xfs_dir2_ino8_t) * count :
-				(uint)sizeof(xfs_dir2_ino4_t) * count);
+				count * XFS_INO64_SIZE :
+				count * XFS_INO32_SIZE);
 		if (size > XFS_IFORK_DSIZE(dp))
 			return size;		/* size value is a failure */
 	}
@@ -318,10 +318,7 @@ xfs_dir2_sf_addname(
 		/*
 		 * Yes, adjust the inode size.  old count + (parent + new)
 		 */
-		incr_isize +=
-			(sfp->count + 2) *
-			((uint)sizeof(xfs_dir2_ino8_t) -
-			 (uint)sizeof(xfs_dir2_ino4_t));
+		incr_isize += (sfp->count + 2) * XFS_INO64_DIFF;
 		objchange = 1;
 	}
 
@@ -896,11 +893,7 @@ xfs_dir2_sf_replace(
 		int	error;			/* error return value */
 		int	newsize;		/* new inode size */
 
-		newsize =
-			dp->i_df.if_bytes +
-			(sfp->count + 1) *
-			((uint)sizeof(xfs_dir2_ino8_t) -
-			 (uint)sizeof(xfs_dir2_ino4_t));
+		newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
 		/*
 		 * Won't fit as shortform, convert to block then do replace.
 		 */
@@ -1021,10 +1014,7 @@ xfs_dir2_sf_toino4(
 	/*
 	 * Compute the new inode size.
 	 */
-	newsize =
-		oldsize -
-		(oldsfp->count + 1) *
-		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t));
+	newsize = oldsize - (oldsfp->count + 1) * XFS_INO64_DIFF;
 	xfs_idata_realloc(dp, -oldsize, XFS_DATA_FORK);
 	xfs_idata_realloc(dp, newsize, XFS_DATA_FORK);
 	/*
@@ -1097,10 +1087,7 @@ xfs_dir2_sf_toino8(
 	/*
 	 * Compute the new inode size (nb: entry count + 1 for parent)
 	 */
-	newsize =
-		oldsize +
-		(oldsfp->count + 1) *
-		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t));
+	newsize = oldsize + (oldsfp->count + 1) * XFS_INO64_DIFF;
 	xfs_idata_realloc(dp, -oldsize, XFS_DATA_FORK);
 	xfs_idata_realloc(dp, newsize, XFS_DATA_FORK);
 	/*
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 3cbc1f8..673a50b 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -104,9 +104,6 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(xfs_dir2_data_unused_t, length,	2);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_hdr_t,		16);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_t,			16);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_ino4_t,			4);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_ino8_t,			8);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_inou_t,			8);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_entry_t,		8);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_hdr_t,		16);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_t,			16);
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
