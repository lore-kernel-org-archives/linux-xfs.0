Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D2D329E05
	for <xfs@oss.sgi.com>; Fri, 25 Jul 2014 03:31:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D6568F804C
	for <xfs@oss.sgi.com>; Fri, 25 Jul 2014 01:31:43 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id hVkStmdwZG68hIDv (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 Jul 2014 01:31:41 -0700 (PDT)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/5] fiemap: add EXTENT_DATA_COMPRESSED flag
Date: Fri, 25 Jul 2014 10:31:39 +0200
Message-Id: <a3e808f2552e36f226adb10482f5bb0b6e6933f9.1406229792.git.dsterba@suse.cz>
In-Reply-To: <cover.1406229792.git.dsterba@suse.cz>
References: <cover.1406229792.git.dsterba@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: adilger@dilger.ca, linux-nilfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, mfasheh@suse.com, David Sterba <dsterba@suse.cz>, xfs@oss.sgi.com, hch@infradead.org, Chris Mason <clm@fb.com>, Ben Myers <bpm@sgi.com>, linux-btrfs@vger.kernel.org, viro@zeniv.linux.org.uk, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com

This flag was not accepted when fiemap was proposed [2] due to lack of
in-kernel users. Btrfs has compression for a long time and we'd like to
see that an extent is compressed in the output of 'filefrag' utility
once it's taught about it.

For that purpose, a reserved field from fiemap_extent is used to let the
filesystem store along the physcial extent length when the flag is set.
This keeps compatibility with applications that use FIEMAP.

Extend arguments of fiemap_fill_next_extent and update all users.

[1] http://article.gmane.org/gmane.comp.file-systems.ext4/8871
[2] http://thread.gmane.org/gmane.comp.file-systems.ext4/8870
[3] http://thread.gmane.org/gmane.linux.file-systems/77632 (v1)
[4] http://www.spinics.net/lists/linux-fsdevel/msg69078.html (v2)

Cc: Al Viro <viro@zeniv.linux.org.uk>
CC: Andreas Dilger <adilger@dilger.ca>
CC: Chris Mason <clm@fb.com>
CC: Christoph Hellwig <hch@infradead.org>
CC  KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
CC: Mark Fasheh <mfasheh@suse.com>
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Ben Myers <bpm@sgi.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.c        |  2 +-
 fs/ext4/extents.c           |  3 ++-
 fs/ext4/inline.c            |  2 +-
 fs/gfs2/inode.c             |  2 +-
 fs/ioctl.c                  | 27 +++++++++++++++++++++------
 fs/nilfs2/inode.c           |  8 +++++---
 fs/ocfs2/extent_map.c       |  4 ++--
 fs/xfs/xfs_iops.c           |  2 +-
 include/linux/fs.h          |  2 +-
 include/uapi/linux/fiemap.h |  8 +++++++-
 10 files changed, 42 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a389820d158b..eec118bf77ae 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4357,7 +4357,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			end = 1;
 		}
 		ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
-					      em_len, flags);
+					      em_len, em_len, flags);
 		if (ret)
 			goto out_free;
 	}
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4da228a0e6d0..0bdd173ac728 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2253,6 +2253,7 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
 				(__u64)es.es_lblk << blksize_bits,
 				(__u64)es.es_pblk << blksize_bits,
 				(__u64)es.es_len << blksize_bits,
+				(__u64)es.es_len << blksize_bits,
 				flags);
 			if (err < 0)
 				break;
@@ -5125,7 +5126,7 @@ static int ext4_xattr_fiemap(struct inode *inode,
 
 	if (physical)
 		error = fiemap_fill_next_extent(fieinfo, 0, physical,
-						length, flags);
+						length, length, flags);
 	return (error < 0 ? error : 0);
 }
 
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 645205d8ada6..3825ff9dc40d 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1825,7 +1825,7 @@ int ext4_inline_data_fiemap(struct inode *inode,
 
 	if (physical)
 		error = fiemap_fill_next_extent(fieinfo, 0, physical,
-						length, flags);
+						length, length, flags);
 	brelse(iloc.bh);
 out:
 	up_read(&EXT4_I(inode)->xattr_sem);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index e62e59477884..5b45cf4e5465 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1931,7 +1931,7 @@ static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			len = size - start;
 		if (start < size)
 			ret = fiemap_fill_next_extent(fieinfo, start, phys,
-						      len, flags);
+						      len, len, flags);
 		if (ret == 1)
 			ret = 0;
 	} else {
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 8ac3fad36192..24a9d912d1e6 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -70,20 +70,26 @@ static int ioctl_fibmap(struct file *filp, int __user *p)
  * @logical:	Extent logical start offset, in bytes
  * @phys:	Extent physical start offset, in bytes
  * @len:	Extent length, in bytes
+ * @phys_len:   Physical extent length in bytes
  * @flags:	FIEMAP_EXTENT flags that describe this extent
  *
  * Called from file system ->fiemap callback. Will populate extent
  * info as passed in via arguments and copy to user memory. On
  * success, extent count on fieinfo is incremented.
  *
+ * Extents without any encoding must set the physical and logical length
+ * to the same value. Otherwise, set flags to FIEMAP_EXTENT_ENCODED
+ * and possibly specify encoding type.
+ *
  * Returns 0 on success, -errno on error, 1 if this was the last
  * extent that will fit in user array.
  */
 #define SET_UNKNOWN_FLAGS	(FIEMAP_EXTENT_DELALLOC)
-#define SET_NO_UNMOUNTED_IO_FLAGS	(FIEMAP_EXTENT_DATA_ENCRYPTED)
+#define SET_NO_UNMOUNTED_IO_FLAGS	(FIEMAP_EXTENT_DATA_ENCRYPTED | \
+					 FIEMAP_EXTENT_DATA_COMPRESSED)
 #define SET_NOT_ALIGNED_FLAGS	(FIEMAP_EXTENT_DATA_TAIL|FIEMAP_EXTENT_DATA_INLINE)
 int fiemap_fill_next_extent(struct fiemap_extent_info *fieinfo, u64 logical,
-			    u64 phys, u64 len, u32 flags)
+			    u64 phys, u64 len, u64 phys_len, u32 flags)
 {
 	struct fiemap_extent extent;
 	struct fiemap_extent __user *dest = fieinfo->fi_extents_start;
@@ -110,6 +116,14 @@ int fiemap_fill_next_extent(struct fiemap_extent_info *fieinfo, u64 logical,
 	extent.fe_length = len;
 	extent.fe_flags = flags;
 
+	WARN_ONCE((flags & FIEMAP_EXTENT_DATA_COMPRESSED)
+		&& !(flags & FIEMAP_EXTENT_ENCODED));
+	WARN_ONCE(phys_len != len && !(flags & FIEMAP_EXTENT_DATA_COMPRESSED),
+		"physical length %llu != logical length %llu without = DATA_COMPRESSED\n",
+		phys_len, len);
+
+	extent.fe_phys_length = phys_len;
+
 	dest += fieinfo->fi_extents_mapped;
 	if (copy_to_user(dest, &extent, sizeof(extent)))
 		return -EFAULT;
@@ -318,10 +332,11 @@ int __generic_block_fiemap(struct inode *inode,
 				flags = FIEMAP_EXTENT_MERGED|FIEMAP_EXTENT_LAST;
 				ret = fiemap_fill_next_extent(fieinfo, logical,
 							      phys, size,
-							      flags);
+							      size, flags);
 			} else if (size) {
 				ret = fiemap_fill_next_extent(fieinfo, logical,
-							      phys, size, flags);
+							      phys, size,
+							      size, flags);
 				size = 0;
 			}
 
@@ -347,7 +362,7 @@ int __generic_block_fiemap(struct inode *inode,
 			if (start_blk > last_blk && !whole_file) {
 				ret = fiemap_fill_next_extent(fieinfo, logical,
 							      phys, size,
-							      flags);
+							      size, flags);
 				break;
 			}
 
@@ -358,7 +373,7 @@ int __generic_block_fiemap(struct inode *inode,
 			if (size) {
 				ret = fiemap_fill_next_extent(fieinfo, logical,
 							      phys, size,
-							      flags);
+							      size, flags);
 				if (ret)
 					break;
 			}
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6252b173a465..a74d3a0e670a 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -1017,7 +1017,8 @@ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			if (size) {
 				/* End of the current extent */
 				ret = fiemap_fill_next_extent(
-					fieinfo, logical, phys, size, flags);
+					fieinfo, logical, phys, size, size,
+					flags);
 				if (ret)
 					break;
 			}
@@ -1067,7 +1068,8 @@ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 					flags |= FIEMAP_EXTENT_LAST;
 
 				ret = fiemap_fill_next_extent(
-					fieinfo, logical, phys, size, flags);
+					fieinfo, logical, phys, size,
+					size, flags);
 				if (ret)
 					break;
 				size = 0;
@@ -1083,7 +1085,7 @@ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 					/* Terminate the current extent */
 					ret = fiemap_fill_next_extent(
 						fieinfo, logical, phys, size,
-						flags);
+						size, flags);
 					if (ret || blkoff > end_blkoff)
 						break;
 
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 767370b656ca..45c95aa2a00f 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -736,7 +736,7 @@ static int ocfs2_fiemap_inline(struct inode *inode, struct buffer_head *di_bh,
 					 id2.i_data.id_data);
 
 		ret = fiemap_fill_next_extent(fieinfo, 0, phys, id_count,
-					      flags);
+					      id_count, flags);
 		if (ret < 0)
 			return ret;
 	}
@@ -809,7 +809,7 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		virt_bytes = (u64)le32_to_cpu(rec.e_cpos) << osb->s_clustersize_bits;
 
 		ret = fiemap_fill_next_extent(fieinfo, virt_bytes, phys_bytes,
-					      len_bytes, fe_flags);
+					      len_bytes, len_bytes, fe_flags);
 		if (ret)
 			break;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 205613a06068..eeef5381debb 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1030,7 +1030,7 @@ xfs_fiemap_format(
 		fiemap_flags |= FIEMAP_EXTENT_LAST;
 
 	error = fiemap_fill_next_extent(fieinfo, logical, physical,
-					length, fiemap_flags);
+					length, length, fiemap_flags);
 	if (error > 0) {
 		error = 0;
 		*full = 1;	/* user array now full */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e11d60cc867b..609e1d72c3e0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1412,7 +1412,7 @@ struct fiemap_extent_info {
 							fiemap_extent array */
 };
 int fiemap_fill_next_extent(struct fiemap_extent_info *info, u64 logical,
-			    u64 phys, u64 len, u32 flags);
+			    u64 phys, u64 len, u64 phys_len, u32 flags);
 int fiemap_check_flags(struct fiemap_extent_info *fieinfo, u32 fs_flags);
 
 /*
diff --git a/include/uapi/linux/fiemap.h b/include/uapi/linux/fiemap.h
index 93abfcd9ac47..11b51887b94a 100644
--- a/include/uapi/linux/fiemap.h
+++ b/include/uapi/linux/fiemap.h
@@ -19,7 +19,9 @@ struct fiemap_extent {
 	__u64 fe_physical; /* physical offset in bytes for the start
 			    * of the extent from the beginning of the disk */
 	__u64 fe_length;   /* length in bytes for this extent */
-	__u64 fe_reserved64[2];
+	__u64 fe_phys_length; /* physical length in bytes, may be different from
+                               * fe_length and sets additional extent flags */
+	__u64 fe_reserved64;
 	__u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
 	__u32 fe_reserved[3];
 };
@@ -50,6 +52,10 @@ struct fiemap {
 						    * Sets EXTENT_UNKNOWN. */
 #define FIEMAP_EXTENT_ENCODED		0x00000008 /* Data can not be read
 						    * while fs is unmounted */
+#define FIEMAP_EXTENT_DATA_COMPRESSED	0x00000040 /* Data is compressed by fs.
+						    * Sets EXTENT_ENCODED and
+						    * the compressed size is
+						    * stored in fe_phys_length */
 #define FIEMAP_EXTENT_DATA_ENCRYPTED	0x00000080 /* Data is encrypted by fs.
 						    * Sets EXTENT_ENCODED */
 #define FIEMAP_EXTENT_NOT_ALIGNED	0x00000100 /* Extent offsets may not be
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
