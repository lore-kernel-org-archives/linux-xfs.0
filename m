Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B02E7F54
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 09:26:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0681330406A
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:26:09 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id vPyD9b0KUT5yPVdg (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 07:26:07 -0800 (PST)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/4 v3] fiemap: add EXTENT_DATA_COMPRESSED flag
Date: Thu, 12 Dec 2013 16:25:59 +0100
Message-Id: <4f8d5dc5b51a43efaf16c39398c23a6276e40a30.1386778303.git.dsterba@suse.cz>
In-Reply-To: <cover.1386778302.git.dsterba@suse.cz>
References: <cover.1386778302.git.dsterba@suse.cz>
In-Reply-To: <cover.1386778302.git.dsterba@suse.cz>
References: <cover.1386778302.git.dsterba@suse.cz>
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
CC: Christoph Hellwig <hch@infradead.org>
CC: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.c        |    2 +-
 fs/ext4/extents.c           |    3 ++-
 fs/ext4/inline.c            |    2 +-
 fs/gfs2/inode.c             |    2 +-
 fs/ioctl.c                  |   18 ++++++++++++------
 fs/nilfs2/inode.c           |    8 +++++---
 fs/ocfs2/extent_map.c       |    4 ++--
 fs/xfs/xfs_iops.c           |    2 +-
 include/linux/fs.h          |    2 +-
 include/uapi/linux/fiemap.h |    6 +++++-
 10 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ff43802..5ea0ef5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4244,7 +4244,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			end = 1;
 		}
 		ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
-					      em_len, flags);
+					      em_len, 0, flags);
 		if (ret)
 			goto out_free;
 	}
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 35f65cf..00ffd18 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2224,6 +2224,7 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
 				(__u64)es.es_lblk << blksize_bits,
 				(__u64)es.es_pblk << blksize_bits,
 				(__u64)es.es_len << blksize_bits,
+				0,
 				flags);
 			if (err < 0)
 				break;
@@ -4798,7 +4799,7 @@ static int ext4_xattr_fiemap(struct inode *inode,
 
 	if (physical)
 		error = fiemap_fill_next_extent(fieinfo, 0, physical,
-						length, flags);
+						length, 0, flags);
 	return (error < 0 ? error : 0);
 }
 
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index bae9875..c5da773 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1816,7 +1816,7 @@ int ext4_inline_data_fiemap(struct inode *inode,
 
 	if (physical)
 		error = fiemap_fill_next_extent(fieinfo, 0, physical,
-						length, flags);
+						length, 0, flags);
 	brelse(iloc.bh);
 out:
 	up_read(&EXT4_I(inode)->xattr_sem);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 7119504..86e9e9b 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1817,7 +1817,7 @@ static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			len = size - start;
 		if (start < size)
 			ret = fiemap_fill_next_extent(fieinfo, start, phys,
-						      len, flags);
+						      len, 0, flags);
 		if (ret == 1)
 			ret = 0;
 	} else {
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 8ac3fad..e7902c4 100644
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
@@ -80,10 +81,11 @@ static int ioctl_fibmap(struct file *filp, int __user *p)
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
@@ -110,6 +112,9 @@ int fiemap_fill_next_extent(struct fiemap_extent_info *fieinfo, u64 logical,
 	extent.fe_length = len;
 	extent.fe_flags = flags;
 
+	if (flags & FIEMAP_EXTENT_DATA_COMPRESSED)
+		extent.fe_phys_length = phys_len;
+
 	dest += fieinfo->fi_extents_mapped;
 	if (copy_to_user(dest, &extent, sizeof(extent)))
 		return -EFAULT;
@@ -318,10 +323,11 @@ int __generic_block_fiemap(struct inode *inode,
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
 
@@ -347,7 +353,7 @@ int __generic_block_fiemap(struct inode *inode,
 			if (start_blk > last_blk && !whole_file) {
 				ret = fiemap_fill_next_extent(fieinfo, logical,
 							      phys, size,
-							      flags);
+							      0, flags);
 				break;
 			}
 
@@ -358,7 +364,7 @@ int __generic_block_fiemap(struct inode *inode,
 			if (size) {
 				ret = fiemap_fill_next_extent(fieinfo, logical,
 							      phys, size,
-							      flags);
+							      0, flags);
 				if (ret)
 					break;
 			}
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 7e350c5..b03917a 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -1018,7 +1018,8 @@ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			if (size) {
 				/* End of the current extent */
 				ret = fiemap_fill_next_extent(
-					fieinfo, logical, phys, size, flags);
+					fieinfo, logical, phys, size, 0,
+					flags);
 				if (ret)
 					break;
 			}
@@ -1068,7 +1069,8 @@ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 					flags |= FIEMAP_EXTENT_LAST;
 
 				ret = fiemap_fill_next_extent(
-					fieinfo, logical, phys, size, flags);
+					fieinfo, logical, phys, size, 0,
+					flags);
 				if (ret)
 					break;
 				size = 0;
@@ -1084,7 +1086,7 @@ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 					/* Terminate the current extent */
 					ret = fiemap_fill_next_extent(
 						fieinfo, logical, phys, size,
-						flags);
+						0, flags);
 					if (ret || blkoff > end_blkoff)
 						break;
 
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 767370b..521b0f2 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -735,7 +735,7 @@ static int ocfs2_fiemap_inline(struct inode *inode, struct buffer_head *di_bh,
 			phys += offsetof(struct ocfs2_dinode,
 					 id2.i_data.id_data);
 
-		ret = fiemap_fill_next_extent(fieinfo, 0, phys, id_count,
+		ret = fiemap_fill_next_extent(fieinfo, 0, phys, id_count, 0,
 					      flags);
 		if (ret < 0)
 			return ret;
@@ -809,7 +809,7 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		virt_bytes = (u64)le32_to_cpu(rec.e_cpos) << osb->s_clustersize_bits;
 
 		ret = fiemap_fill_next_extent(fieinfo, virt_bytes, phys_bytes,
-					      len_bytes, fe_flags);
+					      len_bytes, 0, fe_flags);
 		if (ret)
 			break;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 27e0e54..31e9f53 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1000,7 +1000,7 @@ xfs_fiemap_format(
 		fiemap_flags |= FIEMAP_EXTENT_LAST;
 
 	error = fiemap_fill_next_extent(fieinfo, logical, physical,
-					length, fiemap_flags);
+					length, 0, fiemap_flags);
 	if (error > 0) {
 		error = 0;
 		*full = 1;	/* user array now full */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 121f11f..1a96f9b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1479,7 +1479,7 @@ struct fiemap_extent_info {
 							fiemap_extent array */
 };
 int fiemap_fill_next_extent(struct fiemap_extent_info *info, u64 logical,
-			    u64 phys, u64 len, u32 flags);
+			    u64 phys, u64 len, u64 phys_len, u32 flags);
 int fiemap_check_flags(struct fiemap_extent_info *fieinfo, u32 fs_flags);
 
 /*
diff --git a/include/uapi/linux/fiemap.h b/include/uapi/linux/fiemap.h
index 93abfcd..0e32cae 100644
--- a/include/uapi/linux/fiemap.h
+++ b/include/uapi/linux/fiemap.h
@@ -19,7 +19,9 @@ struct fiemap_extent {
 	__u64 fe_physical; /* physical offset in bytes for the start
 			    * of the extent from the beginning of the disk */
 	__u64 fe_length;   /* length in bytes for this extent */
-	__u64 fe_reserved64[2];
+	__u64 fe_phys_length; /* physical length in bytes, undefined if
+			       * DATA_COMPRESSED not set */
+	__u64 fe_reserved64;
 	__u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
 	__u32 fe_reserved[3];
 };
@@ -50,6 +52,8 @@ struct fiemap {
 						    * Sets EXTENT_UNKNOWN. */
 #define FIEMAP_EXTENT_ENCODED		0x00000008 /* Data can not be read
 						    * while fs is unmounted */
+#define FIEMAP_EXTENT_DATA_COMPRESSED	0x00000040 /* Data is compressed by fs.
+						    * Sets EXTENT_ENCODED */
 #define FIEMAP_EXTENT_DATA_ENCRYPTED	0x00000080 /* Data is encrypted by fs.
 						    * Sets EXTENT_ENCODED */
 #define FIEMAP_EXTENT_NOT_ALIGNED	0x00000100 /* Extent offsets may not be
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
