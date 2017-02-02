Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28976 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbdBBXu1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 18:50:27 -0500
Subject: [PATCH 2/2] ext4: support the FSGEOMETRY ioctl, similar to xfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 02 Feb 2017 15:50:18 -0800
Message-ID: <148607941809.553.9317109635430337778.stgit@birch.djwong.org>
In-Reply-To: <148607940546.553.277589646408670724.stgit@birch.djwong.org>
References: <148607940546.553.277589646408670724.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: tytso@mit.edu, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add an ioctl to report the geometry of a mounted filesystem.  The
structure is designed to be close enough to XFS's that we'll be able to
leverage the new GETFSMAP functionality in xfsprogs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/ext4.h  |   35 +++++++++++++++++++++++++++++++++++
 fs/ext4/ioctl.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3123e49..aee207a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -706,6 +706,40 @@ fsmap_sizeof(
 #define FMR_OWN_INODES		(-7ULL)	/* inodes */
 #define FMR_OWN_DEFECTIVE	(-10ULL) /* bad blocks */
 
+/* ext4fs geometry.  Most of the fields are the same as the XFS version. */
+struct ext4_fsop_geom {
+	__u32		blocksize;	/* filesystem (data) block size */
+	__u32		inodecount;	/* inode count			*/
+	__u32		agblocks;	/* fsblocks in an AG		*/
+	__u32		agcount;	/* number of allocation groups	*/
+	__u32		logblocks;	/* fsblocks in the log		*/
+	__u32		resvblocks;	/* number of reserved blocks	*/
+	__u32		inodesize;	/* inode size in bytes		*/
+	__u32		agiblocks;	/* inode blocks per AG		*/
+	__u64		datablocks;	/* fsblocks in data subvolume	*/
+	__u64		resv64[3];
+	unsigned char	uuid[16];	/* unique id of the filesystem	*/
+	__u32		sunit;		/* stripe unit, fsblocks	*/
+	__u32		swidth;		/* stripe width, fsblocks	*/
+	__s32		version;	/* structure version		*/
+	__u32		flags;		/* superblock version flags	*/
+	__u32		resv32[4];
+};
+
+#define EXT4_FSOP_GEOM_VERSION	0
+
+#define EXT4_FSOP_GEOM_FLAGS_ATTR	0x00001	/* attributes in use	 */
+#define EXT4_FSOP_GEOM_FLAGS_NLINK	0x00002	/* 32-bit nlink values	 */
+#define EXT4_FSOP_GEOM_FLAGS_QUOTA	0x00004	/* quotas enabled	 */
+#define EXT4_FSOP_GEOM_FLAGS_PROJQ	0x00008	/* project quotas	 */
+#define EXT4_FSOP_GEOM_FLAGS_METACRC	0x00010	/* metadata checksums	 */
+#define EXT4_FSOP_GEOM_FLAGS_FTYPE	0x00020	/* inode directory types */
+#define EXT4_FSOP_GEOM_FLAGS_64BIT	0x00040	/* 64-bit support	 */
+#define EXT4_FSOP_GEOM_FLAGS_INLINEDATA	0x00080	/* inline data		 */
+#define EXT4_FSOP_GEOM_FLAGS_ENCRYPT	0x00100	/* encrypted files	 */
+#define EXT4_FSOP_GEOM_FLAGS_LARGEDIR	0x00200	/* large directories	 */
+#define EXT4_FSOP_GEOM_FLAGS_BIGALLOC	0x00400	/* bigalloc		 */
+
 /*
  * ioctl commands
  */
@@ -731,6 +765,7 @@ fsmap_sizeof(
 #define EXT4_IOC_GET_ENCRYPTION_PWSALT	FS_IOC_GET_ENCRYPTION_PWSALT
 #define EXT4_IOC_GET_ENCRYPTION_POLICY	FS_IOC_GET_ENCRYPTION_POLICY
 #define EXT4_IOC_GETFSMAP		_IOWR('X', 59, struct fsmap_head)
+#define EXT4_IOC_FSGEOMETRY		_IOR ('f', 19, struct ext4_fsop_geom)
 
 #ifndef FS_IOC_FSGETXATTR
 /* Until the uapi changes get merged for project quota... */
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index d367269..4087805 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -546,6 +546,58 @@ ext4_ioc_getfsmap(
 	return 0;
 }
 
+static int
+ext4_ioc_fsgeometry(
+	struct super_block	*sb,
+	void			__user *arg)
+{
+	struct ext4_sb_info	*sbi = EXT4_SB(sb);
+	journal_t		*journal = sbi->s_journal;
+	struct ext4_fsop_geom	geom;
+
+	memset(&geom, 0, sizeof(geom));
+	geom.version = EXT4_FSOP_GEOM_VERSION;
+	geom.blocksize = EXT4_BLOCK_SIZE(sb);
+	geom.inodecount = le32_to_cpu(sbi->s_es->s_inodes_count);
+	geom.agblocks = EXT4_BLOCKS_PER_GROUP(sb);
+	geom.agcount = sbi->s_groups_count;
+	geom.logblocks = journal ? journal->j_maxlen : 0;
+	geom.resvblocks = ext4_r_blocks_count(sbi->s_es);
+	geom.inodesize = EXT4_INODE_SIZE(sb);
+	geom.agiblocks = sbi->s_itb_per_group;
+	geom.datablocks = ext4_blocks_count(sbi->s_es);
+	memcpy(geom.uuid, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
+	geom.sunit = le16_to_cpu(sbi->s_es->s_raid_stride);
+	geom.swidth = le16_to_cpu(sbi->s_es->s_raid_stripe_width);
+	geom.flags = 0;
+	if (ext4_has_feature_xattr(sb))
+		geom.flags |= EXT4_FSOP_GEOM_FLAGS_ATTR;
+	if (ext4_has_feature_dir_nlink(sb))
+		geom.flags |= EXT4_FSOP_GEOM_FLAGS_NLINK;
+	if (ext4_has_feature_quota(sb))
+		geom.flags |= EXT4_FSOP_GEOM_FLAGS_QUOTA;
+	if (ext4_has_feature_project(sb))
+		geom.flags |= EXT4_FSOP_GEOM_FLAGS_PROJQ;
+	if (ext4_has_metadata_csum(sb))
+		geom.flags |= EXT4_FSOP_GEOM_FLAGS_METACRC;
+	if (ext4_has_feature_filetype(sb))
+		geom.flags |= EXT4_FSOP_GEOM_FLAGS_FTYPE;
+	if (ext4_has_feature_64bit(sb))
+		geom.flags |= EXT4_FSOP_GEOM_FLAGS_64BIT;
+	if (ext4_has_feature_inline_data(sb))
+		geom.flags |= EXT4_FSOP_GEOM_FLAGS_INLINEDATA;
+	if (ext4_has_feature_encrypt(sb))
+		geom.flags |= EXT4_FSOP_GEOM_FLAGS_ENCRYPT;
+	if (ext4_has_feature_largedir(sb))
+		geom.flags |= EXT4_FSOP_GEOM_FLAGS_LARGEDIR;
+	if (ext4_has_feature_bigalloc(sb))
+		geom.flags |= EXT4_FSOP_GEOM_FLAGS_BIGALLOC;
+
+	if (copy_to_user(arg, &geom, sizeof(geom)))
+		return -EFAULT;
+	return 0;
+}
+
 long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -556,6 +608,8 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	ext4_debug("cmd = %u, arg = %lu\n", cmd, arg);
 
 	switch (cmd) {
+	case EXT4_IOC_FSGEOMETRY:
+		return ext4_ioc_fsgeometry(sb, (void __user *)arg);
 	case EXT4_IOC_GETFSMAP:
 		return ext4_ioc_getfsmap(sb, (void __user *)arg);
 	case EXT4_IOC_GETFLAGS:

