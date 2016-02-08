Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 339337CA2
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 22:24:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AB6CAAC003
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 20:24:32 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GkYVioQoQowb1SPU for <xfs@oss.sgi.com>;
	Sun, 07 Feb 2016 20:24:29 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aSdN9-00072K-O1
	for xfs@oss.sgi.com; Mon, 08 Feb 2016 15:24:23 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aSdN9-0000lx-Mr
	for xfs@oss.sgi.com; Mon, 08 Feb 2016 15:24:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/9] xfs: cull unnecessary icdinode fields
Date: Mon,  8 Feb 2016 15:24:15 +1100
Message-Id: <1454905461-2773-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1454905461-2773-1-git-send-email-david@fromorbit.com>
References: <1454905461-2773-1-git-send-email-david@fromorbit.com>
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

Now that the struct xfs_icdinode is not directly related to the
on-disk format, we can cull things in it we really don't need to
store:

	- magic number never changes
	- padding is not necessary
	- next_unlinked is never used
	- inode number is redundant
	- uuid is redundant
	- lsn is accessed directly from dinode
	- inode CRC is only accessed directly from dinode

Hence we can remove these from the struct xfs_icdinode and redirect
the code that uses them to the xfs_dinode appripriately.  This
reduces the size of the struct icdinode from 152 bytes to 88 bytes,
and removes a fair chunk of unnecessary code, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 39 +++++++++++++--------------------------
 fs/xfs/libxfs/xfs_inode_buf.h | 25 ++++++-------------------
 fs/xfs/xfs_inode.c            | 19 +------------------
 fs/xfs/xfs_inode_item.c       | 19 +++++++++++--------
 4 files changed, 31 insertions(+), 71 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 26e3c46..17ff4e8 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -202,7 +202,6 @@ xfs_inode_from_disk(
 	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
-	to->di_magic = be16_to_cpu(from->di_magic);
 	to->di_mode = be16_to_cpu(from->di_mode);
 	to->di_version = from ->di_version;
 	to->di_format = from->di_format;
@@ -212,7 +211,6 @@ xfs_inode_from_disk(
 	to->di_nlink = be32_to_cpu(from->di_nlink);
 	to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
 	to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
-	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
@@ -245,24 +243,22 @@ xfs_inode_from_disk(
 		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = be32_to_cpu(from->di_crtime.t_nsec);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
-		to->di_ino = be64_to_cpu(from->di_ino);
-		to->di_lsn = be64_to_cpu(from->di_lsn);
-		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
-		uuid_copy(&to->di_uuid, &from->di_uuid);
 	}
 }
 
 void
 xfs_inode_to_disk(
 	struct xfs_inode	*ip,
-	struct xfs_dinode	*to)
+	struct xfs_dinode	*to,
+	xfs_lsn_t		lsn)
 {
 	struct xfs_icdinode	*from = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
-	to->di_magic = cpu_to_be16(from->di_magic);
+	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+
 	to->di_mode = cpu_to_be16(from->di_mode);
-	to->di_version = from ->di_version;
+	to->di_version = from->di_version;
 	to->di_format = from->di_format;
 	to->di_onlink = cpu_to_be16(from->di_onlink);
 	to->di_uid = cpu_to_be32(from->di_uid);
@@ -270,8 +266,8 @@ xfs_inode_to_disk(
 	to->di_nlink = cpu_to_be32(from->di_nlink);
 	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
-	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
+	memset(to->di_pad, 0, sizeof(to->di_pad));
 	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
 	to->di_atime.t_nsec = cpu_to_be32(inode->i_atime.tv_nsec);
 	to->di_mtime.t_sec = cpu_to_be32(inode->i_mtime.tv_sec);
@@ -296,10 +292,11 @@ xfs_inode_to_disk(
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
-		to->di_ino = cpu_to_be64(from->di_ino);
-		to->di_lsn = cpu_to_be64(from->di_lsn);
-		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
-		uuid_copy(&to->di_uuid, &from->di_uuid);
+
+		to->di_ino = cpu_to_be64(ip->i_ino);
+		to->di_lsn = cpu_to_be64(lsn);
+		memset(to->di_pad2, 0, sizeof(to->di_pad2));
+		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_flushiter = 0;
 	} else {
 		to->di_flushiter = cpu_to_be16(from->di_flushiter);
@@ -434,13 +431,10 @@ xfs_iread(
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		/* initialise the on-disk inode core */
 		memset(&ip->i_d, 0, sizeof(ip->i_d));
-		ip->i_d.di_magic = XFS_DINODE_MAGIC;
 		ip->i_d.di_gen = prandom_u32();
-		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		if (xfs_sb_version_hascrc(&mp->m_sb))
 			ip->i_d.di_version = 3;
-			ip->i_d.di_ino = ip->i_ino;
-			uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid);
-		} else
+		else
 			ip->i_d.di_version = 2;
 		return 0;
 	}
@@ -484,16 +478,10 @@ xfs_iread(
 		 * Partial initialisation of the in-core inode. Just the bits
 		 * that xfs_ialloc won't overwrite or relies on being correct.
 		 */
-		ip->i_d.di_magic = be16_to_cpu(dip->di_magic);
 		ip->i_d.di_version = dip->di_version;
 		ip->i_d.di_gen = be32_to_cpu(dip->di_gen);
 		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
 
-		if (dip->di_version == 3) {
-			ip->i_d.di_ino = be64_to_cpu(dip->di_ino);
-			uuid_copy(&ip->i_d.di_uuid, &dip->di_uuid);
-		}
-
 		/*
 		 * Make sure to pull in the mode here as well in
 		 * case the inode is released without being used.
@@ -514,7 +502,6 @@ xfs_iread(
 	 */
 	if (ip->i_d.di_version == 1) {
 		ip->i_d.di_version = 2;
-		memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 		ip->i_d.di_nlink = ip->i_d.di_onlink;
 		ip->i_d.di_onlink = 0;
 		xfs_set_projid(ip, 0);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index adcc9bf..7b8b1b9 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -22,24 +22,22 @@ struct xfs_inode;
 struct xfs_dinode;
 
 /*
- * In memory representation of the XFS inode. This is held in the in-core
- * struct xfs_inode to represent the on disk values, but no longer needs to be
- * identical to the on-disk structure as it is always translated to on-disk
+ * In memory representation of the XFS inode. This is held in the in-core struct
+ * xfs_inode and represents the current on disk values but the structure is not
+ * in on-disk format.  That is, this structure is always translated to on-disk
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	__uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
 	__uint16_t	di_mode;	/* mode and type of file */
 	__int8_t	di_version;	/* inode version */
 	__int8_t	di_format;	/* format of di_c data */
 	__uint16_t	di_onlink;	/* old number of links to file */
+	__uint16_t	di_flushiter;	/* incremented on flush */
 	__uint32_t	di_uid;		/* owner's user id */
 	__uint32_t	di_gid;		/* owner's group id */
 	__uint32_t	di_nlink;	/* number of links to file */
 	__uint16_t	di_projid_lo;	/* lower part of owner's project id */
 	__uint16_t	di_projid_hi;	/* higher part of owner's project id */
-	__uint8_t	di_pad[6];	/* unused, zeroed space */
-	__uint16_t	di_flushiter;	/* incremented on flush */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
@@ -52,22 +50,10 @@ struct xfs_icdinode {
 	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
 	__uint32_t	di_gen;		/* generation number */
 
-	/* di_next_unlinked is the only non-core field in the old dinode */
-	xfs_agino_t	di_next_unlinked;/* agi unlinked list ptr */
-
-	/* start of the extended dinode, writable fields */
-	__uint32_t	di_crc;		/* CRC of the inode */
 	__uint64_t	di_changecount;	/* number of attribute changes */
-	xfs_lsn_t	di_lsn;		/* flush sequence */
 	__uint64_t	di_flags2;	/* more random flags */
-	__uint8_t	di_pad2[16];	/* more padding for future expansion */
 
-	/* fields only written to during inode creation */
 	xfs_ictimestamp_t di_crtime;	/* time created */
-	xfs_ino_t	di_ino;		/* inode number */
-	uuid_t		di_uuid;	/* UUID of the filesystem */
-
-	/* structure must be padded to 64 bit alignment */
 };
 
 /*
@@ -86,7 +72,8 @@ int	xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
 int	xfs_iread(struct xfs_mount *, struct xfs_trans *,
 		  struct xfs_inode *, uint);
 void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
-void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to);
+void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
+			  xfs_lsn_t lsn);
 void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
 			       struct xfs_dinode *to);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9ad9e35..45acdee 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -809,7 +809,6 @@ xfs_ialloc(
 	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
 	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
 	xfs_set_projid(ip, prid);
-	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 
 	if (pip && XFS_INHERIT_GID(pip)) {
 		ip->i_d.di_gid = pip->i_d.di_gid;
@@ -847,13 +846,8 @@ xfs_ialloc(
 	ip->i_d.di_flags = 0;
 
 	if (ip->i_d.di_version == 3) {
-		ASSERT(ip->i_d.di_ino == ino);
-		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid));
-		ip->i_d.di_crc = 0;
 		ip->i_d.di_changecount = 1;
-		ip->i_d.di_lsn = 0;
 		ip->i_d.di_flags2 = 0;
-		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
 		ip->i_d.di_crtime.t_sec = (__int32_t)tv.tv_sec;
 		ip->i_d.di_crtime.t_nsec = (__int32_t)tv.tv_nsec;
 	}
@@ -3464,13 +3458,6 @@ xfs_iflush_int(
 			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
 		goto corrupt_out;
 	}
-	if (XFS_TEST_ERROR(ip->i_d.di_magic != XFS_DINODE_MAGIC,
-				mp, XFS_ERRTAG_IFLUSH_2, XFS_RANDOM_IFLUSH_2)) {
-		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: Bad inode %Lu, ptr 0x%p, magic number 0x%x",
-			__func__, ip->i_ino, ip, ip->i_d.di_magic);
-		goto corrupt_out;
-	}
 	if (S_ISREG(ip->i_d.di_mode)) {
 		if (XFS_TEST_ERROR(
 		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
@@ -3529,7 +3516,7 @@ xfs_iflush_int(
 	 * copy out the core of the inode, because if the inode is dirty at all
 	 * the core must be.
 	 */
-	xfs_inode_to_disk(ip, dip);
+	xfs_inode_to_disk(ip, dip, iip->ili_item.li_lsn);
 
 	/* Wrap, we never let the log put out DI_MAX_FLUSH */
 	if (ip->i_d.di_flushiter == DI_MAX_FLUSH)
@@ -3581,10 +3568,6 @@ xfs_iflush_int(
 	 */
 	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
 
-	/* update the lsn in the on disk inode if required */
-	if (ip->i_d.di_version == 3)
-		dip->di_lsn = cpu_to_be64(iip->ili_item.li_lsn);
-
 	/* generate the checksum. */
 	xfs_dinode_calc_crc(mp, dip);
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 9dcbf58..588d1b4 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -325,12 +325,14 @@ xfs_inode_item_format_attr_fork(
 static void
 xfs_inode_to_log_dinode(
 	struct xfs_inode	*ip,
-	struct xfs_log_dinode	*to)
+	struct xfs_log_dinode	*to,
+	xfs_lsn_t		lsn)
 {
 	struct xfs_icdinode	*from = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
-	to->di_magic = from->di_magic;
+	to->di_magic = XFS_DINODE_MAGIC;
+
 	to->di_mode = from->di_mode;
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
@@ -340,8 +342,8 @@ xfs_inode_to_log_dinode(
 	to->di_nlink = from->di_nlink;
 	to->di_projid_lo = from->di_projid_lo;
 	to->di_projid_hi = from->di_projid_hi;
-	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
+	memset(to->di_pad, 0, sizeof(to->di_pad));
 	to->di_atime.t_sec = inode->i_atime.tv_sec;
 	to->di_atime.t_nsec = inode->i_atime.tv_nsec;
 	to->di_mtime.t_sec = inode->i_mtime.tv_sec;
@@ -366,10 +368,11 @@ xfs_inode_to_log_dinode(
 		to->di_crtime.t_sec = from->di_crtime.t_sec;
 		to->di_crtime.t_nsec = from->di_crtime.t_nsec;
 		to->di_flags2 = from->di_flags2;
-		to->di_ino = from->di_ino;
-		to->di_lsn = from->di_lsn;
-		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
-		uuid_copy(&to->di_uuid, &from->di_uuid);
+
+		to->di_ino = ip->i_ino;
+		to->di_lsn = lsn;
+		memset(to->di_pad2, 0, sizeof(to->di_pad2));
+		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_flushiter = 0;
 	} else {
 		to->di_flushiter = from->di_flushiter;
@@ -390,7 +393,7 @@ xfs_inode_item_format_core(
 	struct xfs_log_dinode	*dic;
 
 	dic = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_ICORE);
-	xfs_inode_to_log_dinode(ip, dic);
+	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
 	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_d.di_version));
 }
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
