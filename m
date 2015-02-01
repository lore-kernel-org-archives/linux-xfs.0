Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5663C7F69
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 15:43:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CB5A5AC003
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 13:43:26 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	I35BW0DGK5NyvdQy for <xfs@oss.sgi.com>;
	Sun, 01 Feb 2015 13:43:23 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YI2IW-0003p9-3E
	for xfs@oss.sgi.com; Mon, 02 Feb 2015 08:43:16 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YI2IW-0007x1-2G
	for xfs@oss.sgi.com; Mon, 02 Feb 2015 08:43:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/5] xfs: struct xfs_sb is no longer tied to the on-disk format
Date: Mon,  2 Feb 2015 08:42:59 +1100
Message-Id: <1422826983-29570-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1422826983-29570-1-git-send-email-david@fromorbit.com>
References: <1422826983-29570-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

With the removal of the bitfield based superblock logging code, the
in-core struct xfs_sb is no longer tied to the on-disk format. That
means it can be moved out of xfs_format.h and into a kernel specific
header. This allows the in-core superblock change size, shape and
structure to suit the requirements of the in-memory processing
rather than be constrained by the on-disk layout.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 96 ++--------------------------------------------
 fs/xfs/libxfs/xfs_sb.c     |  4 +-
 fs/xfs/xfs_log_recover.c   |  2 +-
 fs/xfs/xfs_mount.c         | 18 ++++-----
 fs/xfs/xfs_mount.h         |  2 +-
 fs/xfs/xfs_rtalloc.c       |  6 +--
 fs/xfs/xfs_super.c         |  6 +--
 fs/xfs/xfs_super.h         | 81 ++++++++++++++++++++++++++++++++++++++
 8 files changed, 103 insertions(+), 112 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 8eb7189..2c8d11f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -91,98 +91,7 @@ struct xfs_ifork;
 	 XFS_SB_VERSION2_FTYPE)
 
 /*
- * Superblock - in core version.  Must match the ondisk version below.
- * Must be padded to 64 bit alignment.
- */
-typedef struct xfs_sb {
-	__uint32_t	sb_magicnum;	/* magic number == XFS_SB_MAGIC */
-	__uint32_t	sb_blocksize;	/* logical block size, bytes */
-	xfs_rfsblock_t	sb_dblocks;	/* number of data blocks */
-	xfs_rfsblock_t	sb_rblocks;	/* number of realtime blocks */
-	xfs_rtblock_t	sb_rextents;	/* number of realtime extents */
-	uuid_t		sb_uuid;	/* file system unique id */
-	xfs_fsblock_t	sb_logstart;	/* starting block of log if internal */
-	xfs_ino_t	sb_rootino;	/* root inode number */
-	xfs_ino_t	sb_rbmino;	/* bitmap inode for realtime extents */
-	xfs_ino_t	sb_rsumino;	/* summary inode for rt bitmap */
-	xfs_agblock_t	sb_rextsize;	/* realtime extent size, blocks */
-	xfs_agblock_t	sb_agblocks;	/* size of an allocation group */
-	xfs_agnumber_t	sb_agcount;	/* number of allocation groups */
-	xfs_extlen_t	sb_rbmblocks;	/* number of rt bitmap blocks */
-	xfs_extlen_t	sb_logblocks;	/* number of log blocks */
-	__uint16_t	sb_versionnum;	/* header version == XFS_SB_VERSION */
-	__uint16_t	sb_sectsize;	/* volume sector size, bytes */
-	__uint16_t	sb_inodesize;	/* inode size, bytes */
-	__uint16_t	sb_inopblock;	/* inodes per block */
-	char		sb_fname[12];	/* file system name */
-	__uint8_t	sb_blocklog;	/* log2 of sb_blocksize */
-	__uint8_t	sb_sectlog;	/* log2 of sb_sectsize */
-	__uint8_t	sb_inodelog;	/* log2 of sb_inodesize */
-	__uint8_t	sb_inopblog;	/* log2 of sb_inopblock */
-	__uint8_t	sb_agblklog;	/* log2 of sb_agblocks (rounded up) */
-	__uint8_t	sb_rextslog;	/* log2 of sb_rextents */
-	__uint8_t	sb_inprogress;	/* mkfs is in progress, don't mount */
-	__uint8_t	sb_imax_pct;	/* max % of fs for inode space */
-					/* statistics */
-	/*
-	 * These fields must remain contiguous.  If you really
-	 * want to change their layout, make sure you fix the
-	 * code in xfs_trans_apply_sb_deltas().
-	 */
-	__uint64_t	sb_icount;	/* allocated inodes */
-	__uint64_t	sb_ifree;	/* free inodes */
-	__uint64_t	sb_fdblocks;	/* free data blocks */
-	__uint64_t	sb_frextents;	/* free realtime extents */
-	/*
-	 * End contiguous fields.
-	 */
-	xfs_ino_t	sb_uquotino;	/* user quota inode */
-	xfs_ino_t	sb_gquotino;	/* group quota inode */
-	__uint16_t	sb_qflags;	/* quota flags */
-	__uint8_t	sb_flags;	/* misc. flags */
-	__uint8_t	sb_shared_vn;	/* shared version number */
-	xfs_extlen_t	sb_inoalignmt;	/* inode chunk alignment, fsblocks */
-	__uint32_t	sb_unit;	/* stripe or raid unit */
-	__uint32_t	sb_width;	/* stripe or raid width */
-	__uint8_t	sb_dirblklog;	/* log2 of dir block size (fsbs) */
-	__uint8_t	sb_logsectlog;	/* log2 of the log sector size */
-	__uint16_t	sb_logsectsize;	/* sector size for the log, bytes */
-	__uint32_t	sb_logsunit;	/* stripe unit size for the log */
-	__uint32_t	sb_features2;	/* additional feature bits */
-
-	/*
-	 * bad features2 field as a result of failing to pad the sb structure to
-	 * 64 bits. Some machines will be using this field for features2 bits.
-	 * Easiest just to mark it bad and not use it for anything else.
-	 *
-	 * This is not kept up to date in memory; it is always overwritten by
-	 * the value in sb_features2 when formatting the incore superblock to
-	 * the disk buffer.
-	 */
-	__uint32_t	sb_bad_features2;
-
-	/* version 5 superblock fields start here */
-
-	/* feature masks */
-	__uint32_t	sb_features_compat;
-	__uint32_t	sb_features_ro_compat;
-	__uint32_t	sb_features_incompat;
-	__uint32_t	sb_features_log_incompat;
-
-	__uint32_t	sb_crc;		/* superblock crc */
-	__uint32_t	sb_pad;
-
-	xfs_ino_t	sb_pquotino;	/* project quota inode */
-	xfs_lsn_t	sb_lsn;		/* last write sequence */
-
-	/* must be padded to 64 bit alignment */
-} xfs_sb_t;
-
-#define XFS_SB_CRC_OFF		offsetof(struct xfs_sb, sb_crc)
-
-/*
- * Superblock - on disk version.  Must match the in core version above.
- * Must be padded to 64 bit alignment.
+ * Superblock - on disk version. Must be padded to 64 bit alignment.
  */
 typedef struct xfs_dsb {
 	__be32		sb_magicnum;	/* magic number == XFS_SB_MAGIC */
@@ -255,6 +164,7 @@ typedef struct xfs_dsb {
 	__be32		sb_features_incompat;
 	__be32		sb_features_log_incompat;
 
+#define XFS_SB_CRC_OFF		offsetof(struct xfs_dsb, sb_crc)
 	__le32		sb_crc;		/* superblock crc */
 	__be32		sb_pad;
 
@@ -562,7 +472,7 @@ static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
 		 (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE));
 }
 
-static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
+static inline int xfs_sb_version_hasfinobt(struct xfs_sb *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b0a5fe9..4cf335b 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -107,7 +107,7 @@ xfs_perag_put(
 STATIC int
 xfs_mount_validate_sb(
 	xfs_mount_t	*mp,
-	xfs_sb_t	*sbp,
+	struct xfs_sb	*sbp,
 	bool		check_inprogress,
 	bool		check_version)
 {
@@ -714,7 +714,7 @@ xfs_initialize_perag_data(
 {
 	xfs_agnumber_t	index;
 	xfs_perag_t	*pag;
-	xfs_sb_t	*sbp = &mp->m_sb;
+	struct xfs_sb	*sbp = &mp->m_sb;
 	uint64_t	ifree = 0;
 	uint64_t	ialloc = 0;
 	uint64_t	bfree = 0;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a5a945f..81d7f24 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4410,7 +4410,7 @@ xlog_do_recover(
 {
 	int		error;
 	xfs_buf_t	*bp;
-	xfs_sb_t	*sbp;
+	struct xfs_sb	*sbp;
 
 	/*
 	 * First replay the images in the log.
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 4fa80e6..6015f54 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -166,7 +166,7 @@ xfs_free_perag(
  */
 int
 xfs_sb_validate_fsb_count(
-	xfs_sb_t	*sbp,
+	struct xfs_sb	*sbp,
 	__uint64_t	nblocks)
 {
 	ASSERT(PAGE_SHIFT >= sbp->sb_blocklog);
@@ -189,7 +189,7 @@ xfs_initialize_perag(
 	xfs_perag_t	*pag;
 	xfs_agino_t	agino;
 	xfs_ino_t	ino;
-	xfs_sb_t	*sbp = &mp->m_sb;
+	struct xfs_sb	*sbp = &mp->m_sb;
 	int		error = -ENOMEM;
 
 	/*
@@ -368,7 +368,7 @@ release_buf:
 STATIC int
 xfs_update_alignment(xfs_mount_t *mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
+	struct xfs_sb	*sbp = &(mp->m_sb);
 
 	if (mp->m_dalign) {
 		/*
@@ -434,7 +434,7 @@ xfs_update_alignment(xfs_mount_t *mp)
 STATIC void
 xfs_set_maxicount(xfs_mount_t *mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
+	struct xfs_sb	*sbp = &(mp->m_sb);
 	__uint64_t	icount;
 
 	if (sbp->sb_imax_pct) {
@@ -461,7 +461,7 @@ xfs_set_maxicount(xfs_mount_t *mp)
 STATIC void
 xfs_set_rw_sizes(xfs_mount_t *mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
+	struct xfs_sb	*sbp = &(mp->m_sb);
 	int		readio_log, writeio_log;
 
 	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)) {
@@ -630,7 +630,7 @@ int
 xfs_mountfs(
 	xfs_mount_t	*mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
+	struct xfs_sb	*sbp = &(mp->m_sb);
 	xfs_inode_t	*rip;
 	__uint64_t	resblks;
 	uint		quotamount = 0;
@@ -642,9 +642,9 @@ xfs_mountfs(
 	/*
 	 * Check for a mismatched features2 values.  Older kernels read & wrote
 	 * into the wrong sb offset for sb_features2 on some platforms due to
-	 * xfs_sb_t not being 64bit size aligned when sb_features2 was added,
-	 * which made older superblock reading/writing routines swap it as a
-	 * 64-bit value.
+	 * struct xfs_sb not being 64bit size aligned when sb_features2 was
+	 * added, which made older superblock reading/writing routines swap it
+	 * as a 64-bit value.
 	 *
 	 * For backwards compatibility, we make both slots equal.
 	 *
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a5b2ff8..9d62134 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -81,7 +81,7 @@ typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
 	struct xfs_ail		*m_ail;		/* fs active log item list */
-	xfs_sb_t		m_sb;		/* copy of fs superblock */
+	struct xfs_sb		m_sb;		/* copy of fs superblock */
 	spinlock_t		m_sb_lock;	/* sb counter lock */
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
 	char			*m_fsname;	/* filesystem name */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f2079b6..7e15ec9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -897,10 +897,10 @@ xfs_growfs_rt(
 	xfs_extlen_t	nrsumblocks;	/* new number of summary blocks */
 	uint		nrsumlevels;	/* new rt summary levels */
 	uint		nrsumsize;	/* new size of rt summary, bytes */
-	xfs_sb_t	*nsbp;		/* new superblock */
+	struct xfs_sb	*nsbp;		/* new superblock */
 	xfs_extlen_t	rbmblocks;	/* current number of rt bitmap blocks */
 	xfs_extlen_t	rsumblocks;	/* current number of rt summary blks */
-	xfs_sb_t	*sbp;		/* old superblock */
+	struct xfs_sb	*sbp;		/* old superblock */
 	xfs_fsblock_t	sumbno;		/* summary block number */
 
 	sbp = &mp->m_sb;
@@ -1227,7 +1227,7 @@ xfs_rtmount_inodes(
 	xfs_mount_t	*mp)		/* file system mount structure */
 {
 	int		error;		/* error return value */
-	xfs_sb_t	*sbp;
+	struct xfs_sb	*sbp;
 
 	sbp = &mp->m_sb;
 	if (sbp->sb_rbmino == NULLFSINO)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 40d2ac5..7583044 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -602,7 +602,7 @@ xfs_set_inode32(struct xfs_mount *mp, xfs_agnumber_t agcount)
 {
 	xfs_agnumber_t	index = 0;
 	xfs_agnumber_t	maxagi = 0;
-	xfs_sb_t	*sbp = &mp->m_sb;
+	struct xfs_sb	*sbp = &mp->m_sb;
 	xfs_agnumber_t	max_metadata;
 	xfs_agino_t	agino;
 	xfs_ino_t	ino;
@@ -1084,7 +1084,7 @@ xfs_fs_statfs(
 	struct kstatfs		*statp)
 {
 	struct xfs_mount	*mp = XFS_M(dentry->d_sb);
-	xfs_sb_t		*sbp = &mp->m_sb;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_inode	*ip = XFS_I(dentry->d_inode);
 	__uint64_t		fakeinos, id;
 	xfs_extlen_t		lsize;
@@ -1198,7 +1198,7 @@ xfs_fs_remount(
 	char			*options)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
-	xfs_sb_t		*sbp = &mp->m_sb;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	substring_t		args[MAX_OPT_ARGS];
 	char			*p;
 	int			error;
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 2b830c2..a02236b 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -61,6 +61,87 @@ struct xfs_mount;
 struct xfs_buftarg;
 struct block_device;
 
+/*
+ * Superblock - in core version.  This does not have ot match the size and shape
+ * of the on-disk superblock, but must contain all the fields that we use in the
+ * on-disk superblock.
+ */
+struct xfs_sb {
+	__uint32_t	sb_magicnum;	/* magic number == XFS_SB_MAGIC */
+	__uint32_t	sb_blocksize;	/* logical block size, bytes */
+	xfs_rfsblock_t	sb_dblocks;	/* number of data blocks */
+	xfs_rfsblock_t	sb_rblocks;	/* number of realtime blocks */
+	xfs_rtblock_t	sb_rextents;	/* number of realtime extents */
+	uuid_t		sb_uuid;	/* file system unique id */
+	xfs_fsblock_t	sb_logstart;	/* starting block of log if internal */
+	xfs_ino_t	sb_rootino;	/* root inode number */
+	xfs_ino_t	sb_rbmino;	/* bitmap inode for realtime extents */
+	xfs_ino_t	sb_rsumino;	/* summary inode for rt bitmap */
+	xfs_agblock_t	sb_rextsize;	/* realtime extent size, blocks */
+	xfs_agblock_t	sb_agblocks;	/* size of an allocation group */
+	xfs_agnumber_t	sb_agcount;	/* number of allocation groups */
+	xfs_extlen_t	sb_rbmblocks;	/* number of rt bitmap blocks */
+	xfs_extlen_t	sb_logblocks;	/* number of log blocks */
+	__uint16_t	sb_versionnum;	/* header version == XFS_SB_VERSION */
+	__uint16_t	sb_sectsize;	/* volume sector size, bytes */
+	__uint16_t	sb_inodesize;	/* inode size, bytes */
+	__uint16_t	sb_inopblock;	/* inodes per block */
+	char		sb_fname[12];	/* file system name */
+	__uint8_t	sb_blocklog;	/* log2 of sb_blocksize */
+	__uint8_t	sb_sectlog;	/* log2 of sb_sectsize */
+	__uint8_t	sb_inodelog;	/* log2 of sb_inodesize */
+	__uint8_t	sb_inopblog;	/* log2 of sb_inopblock */
+	__uint8_t	sb_agblklog;	/* log2 of sb_agblocks (rounded up) */
+	__uint8_t	sb_rextslog;	/* log2 of sb_rextents */
+	__uint8_t	sb_inprogress;	/* mkfs is in progress, don't mount */
+	__uint8_t	sb_imax_pct;	/* max % of fs for inode space */
+					/* statistics */
+	__uint64_t	sb_icount;	/* allocated inodes */
+	__uint64_t	sb_ifree;	/* free inodes */
+	__uint64_t	sb_fdblocks;	/* free data blocks */
+	__uint64_t	sb_frextents;	/* free realtime extents */
+	xfs_ino_t	sb_uquotino;	/* user quota inode */
+	xfs_ino_t	sb_gquotino;	/* group quota inode */
+	__uint16_t	sb_qflags;	/* quota flags */
+	__uint8_t	sb_flags;	/* misc. flags */
+	__uint8_t	sb_shared_vn;	/* shared version number */
+	xfs_extlen_t	sb_inoalignmt;	/* inode chunk alignment, fsblocks */
+	__uint32_t	sb_unit;	/* stripe or raid unit */
+	__uint32_t	sb_width;	/* stripe or raid width */
+	__uint8_t	sb_dirblklog;	/* log2 of dir block size (fsbs) */
+	__uint8_t	sb_logsectlog;	/* log2 of the log sector size */
+	__uint16_t	sb_logsectsize;	/* sector size for the log, bytes */
+	__uint32_t	sb_logsunit;	/* stripe unit size for the log */
+	__uint32_t	sb_features2;	/* additional feature bits */
+
+	/*
+	 * bad features2 field as a result of failing to pad the sb structure to
+	 * 64 bits. Some machines will be using this field for features2 bits.
+	 * Easiest just to mark it bad and not use it for anything else.
+	 *
+	 * This is not kept up to date in memory; it is always overwritten by
+	 * the value in sb_features2 when formatting the incore superblock to
+	 * the disk buffer.
+	 */
+	__uint32_t	sb_bad_features2;
+
+	/* version 5 superblock fields start here */
+
+	/* feature masks */
+	__uint32_t	sb_features_compat;
+	__uint32_t	sb_features_ro_compat;
+	__uint32_t	sb_features_incompat;
+	__uint32_t	sb_features_log_incompat;
+
+	__uint32_t	sb_crc;		/* superblock crc */
+	__uint32_t	sb_pad;
+
+	xfs_ino_t	sb_pquotino;	/* project quota inode */
+	xfs_lsn_t	sb_lsn;		/* last write sequence */
+
+	/* must be padded to 64 bit alignment */
+};
+
 extern __uint64_t xfs_max_file_offset(unsigned int);
 
 extern void xfs_flush_inodes(struct xfs_mount *mp);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
