Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A2C87CA3
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 02:42:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04061AC003
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 00:42:35 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 3OHdHFQpatoRUfTA (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 22 Jun 2016 00:42:33 -0700 (PDT)
Date: Wed, 22 Jun 2016 00:42:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [xfs:xfs-4.8-misc-fixes-2 3/9] fs/xfs/xfs_ondisk.h:116:2: error:
	call to '__compiletime_assert_116' declared with attribute error: XFS:
	offsetof(xfs_dir2_sf_entry_t, offset) is wrong, expected 1
Message-ID: <20160622074230.GA9508@infradead.org>
References: <201606221448.UGgis4S6%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201606221448.UGgis4S6%fengguang.wu@intel.com>
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
To: kbuild test robot <fengguang.wu@intel.com>
Cc: jonas@southpole.se, xfs@oss.sgi.com, kbuild-all@01.org, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Jun 22, 2016 at 02:06:49PM +0800, kbuild test robot wrote:
> config: openrisc-allmodconfig (attached as .config)
> compiler: or32-linux-gcc (GCC) 4.5.1-or32-1.0rc1

This looks openrisc copied it's weird packing rules from the old ARM
ABI and would need to define __arch_pack similar to ARM.  Alternatively
we could try to get rid of our struct types that wrap the char
arrays for the unaligned fields.   For the SF dir offset that would
looks something like this (untested):

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 8d4d8bc..e1d8e59 100644
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
index e5bb9cc..18cc6c7 100644
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
@@ -1048,7 +1047,8 @@ xfs_dir2_sf_toino4(
 	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep),
 		  oldsfep = dp->d_ops->sf_nextentry(oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
-		sfep->offset = oldsfep->offset;
+		sfep->offset[0] = oldsfep->offset[0];
+		sfep->offset[1] = oldsfep->offset[1];
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
 		dp->d_ops->sf_put_ino(sfp, sfep,
 				      dp->d_ops->sf_get_ino(oldsfp, oldsfep));
@@ -1124,7 +1124,8 @@ xfs_dir2_sf_toino8(
 	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep),
 		  oldsfep = dp->d_ops->sf_nextentry(oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
-		sfep->offset = oldsfep->offset;
+		sfep->offset[0] = oldsfep->offset[0];
+		sfep->offset[1] = oldsfep->offset[1];
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
