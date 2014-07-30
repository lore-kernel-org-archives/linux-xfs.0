Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EF05E7F67
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 12:18:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8AF24AC005
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 10:18:40 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 9MLo8pfCwFLi8InF (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Jul 2014 10:18:38 -0700 (PDT)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/6] fiemap: add fe_phys_length and EXTENT_PHYS_LENGTH flag
Date: Wed, 30 Jul 2014 19:18:36 +0200
Message-Id: <f257ce29393707293c0ce056bd8c6a7b3daa6082.1406739708.git.dsterba@suse.cz>
In-Reply-To: <cover.1406739708.git.dsterba@suse.cz>
References: <cover.1406739708.git.dsterba@suse.cz>
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
Cc: adilger@dilger.ca, linux-nilfs@vger.kernel.org, mfasheh@suse.com, David Sterba <dsterba@suse.cz>, xfs@oss.sgi.com, hch@infradead.org, linux-btrfs@vger.kernel.org, viro@zeniv.linux.org.uk, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

Add a new member to fiemap_extent that represents the physical extent
length. This value is undefined if the flag EXTENT_PHYS_LENGTH is not
set.

No functional change to existing fiemap users.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.c        |  2 +-
 fs/ext4/extents.c           |  4 ++--
 fs/ext4/inline.c            |  2 +-
 fs/gfs2/inode.c             |  2 +-
 fs/ioctl.c                  | 13 ++++++++-----
 fs/nilfs2/inode.c           |  8 +++++---
 fs/ocfs2/extent_map.c       |  4 ++--
 fs/xfs/xfs_iops.c           |  2 +-
 include/linux/fs.h          |  2 +-
 include/uapi/linux/fiemap.h |  6 +++++-
 10 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a389820d158b..c85da2e54ce7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4357,7 +4357,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			end = 1;
 		}
 		ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
-					      em_len, flags);
+					      em_len, 0, flags);
 		if (ret)
 			goto out_free;
 	}
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4da228a0e6d0..a194024e96a2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2253,7 +2253,7 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
 				(__u64)es.es_lblk << blksize_bits,
 				(__u64)es.es_pblk << blksize_bits,
 				(__u64)es.es_len << blksize_bits,
-				flags);
+				0, flags);
 			if (err < 0)
 				break;
 			if (err == 1) {
@@ -5125,7 +5125,7 @@ static int ext4_xattr_fiemap(struct inode *inode,
 
 	if (physical)
 		error = fiemap_fill_next_extent(fieinfo, 0, physical,
-						length, flags);
+						length, 0, flags);
 	return (error < 0 ? error : 0);
 }
 
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 645205d8ada6..16f93d8100db 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1825,7 +1825,7 @@ int ext4_inline_data_fiemap(struct inode *inode,
 
 	if (physical)
 		error = fiemap_fill_next_extent(fieinfo, 0, physical,
-						length, flags);
+						length, 0, flags);
 	brelse(iloc.bh);
 out:
 	up_read(&EXT4_I(inode)->xattr_sem);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index e62e59477884..d0d35557ab5f 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1931,7 +1931,7 @@ static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			len = size - start;
 		if (start < size)
 			ret = fiemap_fill_next_extent(fieinfo, start, phys,
-						      len, flags);
+						      len, 0, flags);
 		if (ret == 1)
 			ret = 0;
 	} else {
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 8ac3fad36192..127551c70b0a 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -70,6 +70,7 @@ static int ioctl_fibmap(struct file *filp, int __user *p)
  * @logical:	Extent logical start offset, in bytes
  * @phys:	Extent physical start offset, in bytes
  * @len:	Extent length, in bytes
+ * @phys_len:   Physical extent length in bytes
  * @flags:	FIEMAP_EXTENT flags that describe this extent
  *
  * Called from file system ->fiemap callback. Will populate extent
@@ -83,7 +84,7 @@ static int ioctl_fibmap(struct file *filp, int __user *p)
 #define SET_NO_UNMOUNTED_IO_FLAGS	(FIEMAP_EXTENT_DATA_ENCRYPTED)
 #define SET_NOT_ALIGNED_FLAGS	(FIEMAP_EXTENT_DATA_TAIL|FIEMAP_EXTENT_DATA_INLINE)
 int fiemap_fill_next_extent(struct fiemap_extent_info *fieinfo, u64 logical,
-			    u64 phys, u64 len, u32 flags)
+			    u64 phys, u64 len, u64 phys_len, u32 flags)
 {
 	struct fiemap_extent extent;
 	struct fiemap_extent __user *dest = fieinfo->fi_extents_start;
@@ -109,6 +110,7 @@ int fiemap_fill_next_extent(struct fiemap_extent_info *fieinfo, u64 logical,
 	extent.fe_physical = phys;
 	extent.fe_length = len;
 	extent.fe_flags = flags;
+	extent.fe_phys_length = phys_len;
 
 	dest += fieinfo->fi_extents_mapped;
 	if (copy_to_user(dest, &extent, sizeof(extent)))
@@ -318,10 +320,11 @@ int __generic_block_fiemap(struct inode *inode,
 				flags = FIEMAP_EXTENT_MERGED|FIEMAP_EXTENT_LAST;
 				ret = fiemap_fill_next_extent(fieinfo, logical,
 							      phys, size,
-							      flags);
+							      0, flags);
 			} else if (size) {
 				ret = fiemap_fill_next_extent(fieinfo, logical,
-							      phys, size, flags);
+							      phys, size,
+							      0, flags);
 				size = 0;
 			}
 
@@ -347,7 +350,7 @@ int __generic_block_fiemap(struct inode *inode,
 			if (start_blk > last_blk && !whole_file) {
 				ret = fiemap_fill_next_extent(fieinfo, logical,
 							      phys, size,
-							      flags);
+							      0, flags);
 				break;
 			}
 
@@ -358,7 +361,7 @@ int __generic_block_fiemap(struct inode *inode,
 			if (size) {
 				ret = fiemap_fill_next_extent(fieinfo, logical,
 							      phys, size,
-							      flags);
+							      0, flags);
 				if (ret)
 					break;
 			}
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6252b173a465..a99e6d093f11 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -1017,7 +1017,8 @@ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			if (size) {
 				/* End of the current extent */
 				ret = fiemap_fill_next_extent(
-					fieinfo, logical, phys, size, flags);
+					fieinfo, logical, phys, size, 0,
+					flags);
 				if (ret)
 					break;
 			}
@@ -1067,7 +1068,8 @@ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 					flags |= FIEMAP_EXTENT_LAST;
 
 				ret = fiemap_fill_next_extent(
-					fieinfo, logical, phys, size, flags);
+					fieinfo, logical, phys, size,
+					0, flags);
 				if (ret)
 					break;
 				size = 0;
@@ -1083,7 +1085,7 @@ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 					/* Terminate the current extent */
 					ret = fiemap_fill_next_extent(
 						fieinfo, logical, phys, size,
-						flags);
+						0, flags);
 					if (ret || blkoff > end_blkoff)
 						break;
 
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 767370b656ca..cb0276908155 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -736,7 +736,7 @@ static int ocfs2_fiemap_inline(struct inode *inode, struct buffer_head *di_bh,
 					 id2.i_data.id_data);
 
 		ret = fiemap_fill_next_extent(fieinfo, 0, phys, id_count,
-					      flags);
+					      0, flags);
 		if (ret < 0)
 			return ret;
 	}
@@ -809,7 +809,7 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		virt_bytes = (u64)le32_to_cpu(rec.e_cpos) << osb->s_clustersize_bits;
 
 		ret = fiemap_fill_next_extent(fieinfo, virt_bytes, phys_bytes,
-					      len_bytes, fe_flags);
+					      len_bytes, 0, fe_flags);
 		if (ret)
 			break;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 205613a06068..5a7c1f6d1189 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1030,7 +1030,7 @@ xfs_fiemap_format(
 		fiemap_flags |= FIEMAP_EXTENT_LAST;
 
 	error = fiemap_fill_next_extent(fieinfo, logical, physical,
-					length, fiemap_flags);
+					length, 0, fiemap_flags);
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
index 93abfcd9ac47..ed52d3f7821d 100644
--- a/include/uapi/linux/fiemap.h
+++ b/include/uapi/linux/fiemap.h
@@ -19,7 +19,9 @@ struct fiemap_extent {
 	__u64 fe_physical; /* physical offset in bytes for the start
 			    * of the extent from the beginning of the disk */
 	__u64 fe_length;   /* length in bytes for this extent */
-	__u64 fe_reserved64[2];
+	__u64 fe_phys_length; /* physical length in bytes, may be different from
+                               * fe_length, is valid if PHYS_LENGTH flag set */
+	__u64 fe_reserved64;
 	__u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
 	__u32 fe_reserved[3];
 };
@@ -50,6 +52,8 @@ struct fiemap {
 						    * Sets EXTENT_UNKNOWN. */
 #define FIEMAP_EXTENT_ENCODED		0x00000008 /* Data can not be read
 						    * while fs is unmounted */
+#define FIEMAP_EXTENT_PHYS_LENGTH	0x00000010 /* Physical length of extent
+						    * not the same as logical */
 #define FIEMAP_EXTENT_DATA_ENCRYPTED	0x00000080 /* Data is encrypted by fs.
 						    * Sets EXTENT_ENCODED */
 #define FIEMAP_EXTENT_NOT_ALIGNED	0x00000100 /* Extent offsets may not be
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
