Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 760287CA0
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 02:52:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 48FC48F8035
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 00:52:58 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id KfMMb1Nda6snmyPL (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 24 Jun 2016 00:52:55 -0700 (PDT)
Received: from [91.114.64.3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bGLv4-0002rI-Af
	for xfs@oss.sgi.com; Fri, 24 Jun 2016 07:52:54 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] xfs: kill xfs_dir2_sf_off_t
Date: Fri, 24 Jun 2016 09:52:45 +0200
Message-Id: <1466754767-10657-2-git-send-email-hch@lst.de>
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

Just use an array of two unsigned chars directly to avoid problems
with architectures that pad the size of structures.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.h | 14 ++++----------
 fs/xfs/libxfs/xfs_dir2_sf.c   | 13 ++++++-------
 fs/xfs/xfs_ondisk.h           |  1 -
 3 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 8d4d8bc..a5f4d6e 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -192,12 +192,6 @@ typedef	__uint16_t	xfs_dir2_data_off_t;
 typedef uint		xfs_dir2_data_aoff_t;	/* argument form */
 
 /*
- * Normalized offset (in a data block) of the entry, really xfs_dir2_data_off_t.
- * Only need 16 bits, this is the byte offset into the single block form.
- */
-typedef struct { __uint8_t i[2]; } __arch_pack xfs_dir2_sf_off_t;
-
-/*
  * Offset in data space of a data entry.
  */
 typedef	__uint32_t	xfs_dir2_dataptr_t;
@@ -251,7 +245,7 @@ typedef struct xfs_dir2_sf_hdr {
 
 typedef struct xfs_dir2_sf_entry {
 	__u8			namelen;	/* actual name length */
-	xfs_dir2_sf_off_t	offset;		/* saved offset */
+	__u8			offset[2];	/* saved offset */
 	__u8			name[];		/* name, variable size */
 	/*
 	 * A single byte containing the file type field follows the inode
@@ -260,7 +254,7 @@ typedef struct xfs_dir2_sf_entry {
 	 * A xfs_dir2_ino8_t or xfs_dir2_ino4_t follows here, at a
 	 * variable offset after the name.
 	 */
-} __arch_pack xfs_dir2_sf_entry_t;
+} xfs_dir2_sf_entry_t;
 
 static inline int xfs_dir2_sf_hdr_size(int i8count)
 {
@@ -272,13 +266,13 @@ static inline int xfs_dir2_sf_hdr_size(int i8count)
 static inline xfs_dir2_data_aoff_t
 xfs_dir2_sf_get_offset(xfs_dir2_sf_entry_t *sfep)
 {
-	return get_unaligned_be16(&sfep->offset.i);
+	return get_unaligned_be16(sfep->offset);
 }
 
 static inline void
 xfs_dir2_sf_put_offset(xfs_dir2_sf_entry_t *sfep, xfs_dir2_data_aoff_t off)
 {
-	put_unaligned_be16(off, &sfep->offset.i);
+	put_unaligned_be16(off, sfep->offset);
 }
 
 static inline struct xfs_dir2_sf_entry *
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index e5bb9cc..f8ccfd5a 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -126,11 +126,10 @@ xfs_dir2_block_sfsize(
 		/*
 		 * Calculate the new size, see if we should give up yet.
 		 */
-		size = xfs_dir2_sf_hdr_size(i8count) +		/* header */
-		       count +					/* namelen */
-		       count * (uint)sizeof(xfs_dir2_sf_off_t) + /* offset */
-		       namelen +				/* name */
-		       (i8count ?				/* inumber */
+		size = xfs_dir2_sf_hdr_size(i8count) +	/* header */
+		       count * 3 * sizeof(u8) +		/* namelen + offset */
+		       namelen +			/* name */
+		       (i8count ?			/* inumber */
 				(uint)sizeof(xfs_dir2_ino8_t) * count :
 				(uint)sizeof(xfs_dir2_ino4_t) * count);
 		if (size > XFS_IFORK_DSIZE(dp))
@@ -1048,7 +1047,7 @@ xfs_dir2_sf_toino4(
 	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep),
 		  oldsfep = dp->d_ops->sf_nextentry(oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
-		sfep->offset = oldsfep->offset;
+		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
 		dp->d_ops->sf_put_ino(sfp, sfep,
 				      dp->d_ops->sf_get_ino(oldsfp, oldsfep));
@@ -1124,7 +1123,7 @@ xfs_dir2_sf_toino8(
 	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep),
 		  oldsfep = dp->d_ops->sf_nextentry(oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
-		sfep->offset = oldsfep->offset;
+		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
 		dp->d_ops->sf_put_ino(sfp, sfep,
 				      dp->d_ops->sf_get_ino(oldsfp, oldsfep));
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 0272301..3cbc1f8 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -116,7 +116,6 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
-	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_off_t,		2);
 
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
