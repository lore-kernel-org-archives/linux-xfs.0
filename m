Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C47887F59
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 03:01:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A77008F8035
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 01:01:35 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	37xXOOAkByhyo3hu for <xfs@oss.sgi.com>;
	Tue, 12 Jan 2016 01:01:31 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aIupP-0005Jz-J3
	for xfs@oss.sgi.com; Tue, 12 Jan 2016 20:01:23 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aIupP-0008AE-IQ
	for xfs@oss.sgi.com; Tue, 12 Jan 2016 20:01:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/8] xfs: remove timestamps from incore inode
Date: Tue, 12 Jan 2016 20:01:14 +1100
Message-Id: <1452589280-30167-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1452589280-30167-1-git-send-email-david@fromorbit.com>
References: <1452589280-30167-1-git-send-email-david@fromorbit.com>
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

The struct xfs_inode has two copies of the current timestamps in it,
one in the vfs inode and one in the struct xfs_icdinode. Now that we
no longer log the struct xfs_icdinode directly, we don't need to
keep the timestamps in this structure. instead we can copy them
straight out of the VFS inode when formatting the inode log item or
the on-disk inode.

This reduces the struct xfs_inode in size by 24 bytes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 85 +++++++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_inode_buf.h |  9 ++---
 fs/xfs/libxfs/xfs_rtbitmap.c  |  2 +-
 fs/xfs/xfs_inode.c            | 21 ++++++-----
 fs/xfs/xfs_inode_item.c       | 73 ++++++-------------------------------
 fs/xfs/xfs_inode_item.h       |  2 -
 fs/xfs/xfs_iops.c             | 37 ++++---------------
 fs/xfs/xfs_itable.c           | 16 +++++---
 fs/xfs/xfs_log_recover.c      |  8 ++--
 fs/xfs/xfs_rtalloc.c          |  2 +-
 fs/xfs/xfs_trans_inode.c      | 12 +-----
 11 files changed, 124 insertions(+), 143 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 63d46bf..0f33265 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -195,10 +195,13 @@ xfs_imap_to_bp(
 }
 
 void
-xfs_dinode_from_disk(
-	struct xfs_icdinode	*to,
+xfs_inode_from_disk(
+	struct xfs_inode	*ip,
 	struct xfs_dinode	*from)
 {
+	struct xfs_icdinode	*to = &ip->i_d;
+	struct inode		*inode = VFS_I(ip);
+
 	to->di_magic = be16_to_cpu(from->di_magic);
 	to->di_mode = be16_to_cpu(from->di_mode);
 	to->di_version = from ->di_version;
@@ -211,12 +214,14 @@ xfs_dinode_from_disk(
 	to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
-	to->di_atime.t_sec = be32_to_cpu(from->di_atime.t_sec);
-	to->di_atime.t_nsec = be32_to_cpu(from->di_atime.t_nsec);
-	to->di_mtime.t_sec = be32_to_cpu(from->di_mtime.t_sec);
-	to->di_mtime.t_nsec = be32_to_cpu(from->di_mtime.t_nsec);
-	to->di_ctime.t_sec = be32_to_cpu(from->di_ctime.t_sec);
-	to->di_ctime.t_nsec = be32_to_cpu(from->di_ctime.t_nsec);
+
+	inode->i_atime.tv_sec = be32_to_cpu(from->di_atime.t_sec);
+	inode->i_atime.tv_nsec = be32_to_cpu(from->di_atime.t_nsec);
+	inode->i_mtime.tv_sec = be32_to_cpu(from->di_mtime.t_sec);
+	inode->i_mtime.tv_nsec = be32_to_cpu(from->di_mtime.t_nsec);
+	inode->i_ctime.tv_sec = be32_to_cpu(from->di_ctime.t_sec);
+	inode->i_ctime.tv_nsec = be32_to_cpu(from->di_ctime.t_nsec);
+
 	to->di_size = be64_to_cpu(from->di_size);
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
 	to->di_extsize = be32_to_cpu(from->di_extsize);
@@ -242,9 +247,63 @@ xfs_dinode_from_disk(
 }
 
 void
-xfs_dinode_to_disk(
-	struct xfs_dinode	*to,
-	struct xfs_icdinode	*from)
+xfs_inode_to_disk(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*to)
+{
+	struct xfs_icdinode	*from = &ip->i_d;
+	struct inode		*inode = VFS_I(ip);
+
+	to->di_magic = cpu_to_be16(from->di_magic);
+	to->di_mode = cpu_to_be16(from->di_mode);
+	to->di_version = from ->di_version;
+	to->di_format = from->di_format;
+	to->di_onlink = cpu_to_be16(from->di_onlink);
+	to->di_uid = cpu_to_be32(from->di_uid);
+	to->di_gid = cpu_to_be32(from->di_gid);
+	to->di_nlink = cpu_to_be32(from->di_nlink);
+	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
+	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
+	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
+
+	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
+	to->di_atime.t_nsec = cpu_to_be32(inode->i_atime.tv_nsec);
+	to->di_mtime.t_sec = cpu_to_be32(inode->i_mtime.tv_sec);
+	to->di_mtime.t_nsec = cpu_to_be32(inode->i_mtime.tv_nsec);
+	to->di_ctime.t_sec = cpu_to_be32(inode->i_ctime.tv_sec);
+	to->di_ctime.t_nsec = cpu_to_be32(inode->i_ctime.tv_nsec);
+
+	to->di_size = cpu_to_be64(from->di_size);
+	to->di_nblocks = cpu_to_be64(from->di_nblocks);
+	to->di_extsize = cpu_to_be32(from->di_extsize);
+	to->di_nextents = cpu_to_be32(from->di_nextents);
+	to->di_anextents = cpu_to_be16(from->di_anextents);
+	to->di_forkoff = from->di_forkoff;
+	to->di_aformat = from->di_aformat;
+	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
+	to->di_dmstate = cpu_to_be16(from->di_dmstate);
+	to->di_flags = cpu_to_be16(from->di_flags);
+	to->di_gen = cpu_to_be32(from->di_gen);
+
+	if (from->di_version == 3) {
+		to->di_changecount = cpu_to_be64(from->di_changecount);
+		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
+		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
+		to->di_flags2 = cpu_to_be64(from->di_flags2);
+		to->di_ino = cpu_to_be64(from->di_ino);
+		to->di_lsn = cpu_to_be64(from->di_lsn);
+		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
+		uuid_copy(&to->di_uuid, &from->di_uuid);
+		to->di_flushiter = 0;
+	} else {
+		to->di_flushiter = cpu_to_be16(from->di_flushiter);
+	}
+}
+
+void
+xfs_log_dinode_to_disk(
+	struct xfs_log_dinode	*from,
+	struct xfs_dinode	*to)
 {
 	to->di_magic = cpu_to_be16(from->di_magic);
 	to->di_mode = cpu_to_be16(from->di_mode);
@@ -257,12 +316,14 @@ xfs_dinode_to_disk(
 	to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
+
 	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
 	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
 	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
 	to->di_mtime.t_nsec = cpu_to_be32(from->di_mtime.t_nsec);
 	to->di_ctime.t_sec = cpu_to_be32(from->di_ctime.t_sec);
 	to->di_ctime.t_nsec = cpu_to_be32(from->di_ctime.t_nsec);
+
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
 	to->di_extsize = cpu_to_be32(from->di_extsize);
@@ -403,7 +464,7 @@ xfs_iread(
 	 * Otherwise, just get the truly permanent information.
 	 */
 	if (dip->di_mode) {
-		xfs_dinode_from_disk(&ip->i_d, dip);
+		xfs_inode_from_disk(ip, dip);
 		error = xfs_iformat_fork(ip, dip);
 		if (error)  {
 #ifdef DEBUG
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 642f2a2..adcc9bf 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -40,9 +40,6 @@ struct xfs_icdinode {
 	__uint16_t	di_projid_hi;	/* higher part of owner's project id */
 	__uint8_t	di_pad[6];	/* unused, zeroed space */
 	__uint16_t	di_flushiter;	/* incremented on flush */
-	xfs_ictimestamp_t di_atime;	/* time last accessed */
-	xfs_ictimestamp_t di_mtime;	/* time last modified */
-	xfs_ictimestamp_t di_ctime;	/* time created/inode modified */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
@@ -89,8 +86,10 @@ int	xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
 int	xfs_iread(struct xfs_mount *, struct xfs_trans *,
 		  struct xfs_inode *, uint);
 void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
-void	xfs_dinode_to_disk(struct xfs_dinode *to, struct xfs_icdinode *from);
-void	xfs_dinode_from_disk(struct xfs_icdinode *to, struct xfs_dinode *from);
+void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to);
+void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
+void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
+			       struct xfs_dinode *to);
 
 #if defined(DEBUG)
 void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 9b59ffa..acc71dd 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -983,7 +983,7 @@ xfs_rtfree_extent(
 	    mp->m_sb.sb_rextents) {
 		if (!(mp->m_rbmip->i_d.di_flags & XFS_DIFLAG_NEWRTBM))
 			mp->m_rbmip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
-		*(__uint64_t *)&mp->m_rbmip->i_d.di_atime = 0;
+		*(__uint64_t *)&VFS_I(mp->m_rbmip)->i_atime = 0;
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
 	}
 	return 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7e24232..3e9b8a0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -757,6 +757,7 @@ xfs_ialloc(
 	uint		flags;
 	int		error;
 	struct timespec	tv;
+	struct inode	*inode;
 
 	/*
 	 * Call the space management code to pick
@@ -782,6 +783,7 @@ xfs_ialloc(
 	if (error)
 		return error;
 	ASSERT(ip != NULL);
+	inode = VFS_I(ip);
 
 	/*
 	 * We always convert v1 inodes to v2 now - we only support filesystems
@@ -823,10 +825,9 @@ xfs_ialloc(
 	ASSERT(ip->i_d.di_nblocks == 0);
 
 	tv = current_fs_time(mp->m_super);
-	ip->i_d.di_mtime.t_sec = (__int32_t)tv.tv_sec;
-	ip->i_d.di_mtime.t_nsec = (__int32_t)tv.tv_nsec;
-	ip->i_d.di_atime = ip->i_d.di_mtime;
-	ip->i_d.di_ctime = ip->i_d.di_mtime;
+	inode->i_mtime = tv;
+	inode->i_atime = tv;
+	inode->i_ctime = tv;
 
 	/*
 	 * di_gen will have been taken care of in xfs_iread.
@@ -844,7 +845,8 @@ xfs_ialloc(
 		ip->i_d.di_lsn = 0;
 		ip->i_d.di_flags2 = 0;
 		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
-		ip->i_d.di_crtime = ip->i_d.di_mtime;
+		ip->i_d.di_crtime.t_sec = (__int32_t)tv.tv_sec;
+		ip->i_d.di_crtime.t_nsec = (__int32_t)tv.tv_nsec;
 	}
 
 
@@ -3509,12 +3511,11 @@ xfs_iflush_int(
 		ip->i_d.di_flushiter++;
 
 	/*
-	 * Copy the dirty parts of the inode into the on-disk
-	 * inode.  We always copy out the core of the inode,
-	 * because if the inode is dirty at all the core must
-	 * be.
+	 * Copy the dirty parts of the inode into the on-disk inode.  We always
+	 * copy out the core of the inode, because if the inode is dirty at all
+	 * the core must be.
 	 */
-	xfs_dinode_to_disk(dip, &ip->i_d);
+	xfs_inode_to_disk(ip, dip);
 
 	/* Wrap, we never let the log put out DI_MAX_FLUSH */
 	if (ip->i_d.di_flushiter == DI_MAX_FLUSH)
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 3ad9972..9dcbf58 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -323,10 +323,13 @@ xfs_inode_item_format_attr_fork(
 }
 
 static void
-xfs_icdinode_to_log_dinode(
-	struct xfs_icdinode	*from,
+xfs_inode_to_log_dinode(
+	struct xfs_inode	*ip,
 	struct xfs_log_dinode	*to)
 {
+	struct xfs_icdinode	*from = &ip->i_d;
+	struct inode		*inode = VFS_I(ip);
+
 	to->di_magic = from->di_magic;
 	to->di_mode = from->di_mode;
 	to->di_version = from->di_version;
@@ -338,66 +341,14 @@ xfs_icdinode_to_log_dinode(
 	to->di_projid_lo = from->di_projid_lo;
 	to->di_projid_hi = from->di_projid_hi;
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
-	to->di_atime.t_sec = from->di_atime.t_sec;
-	to->di_atime.t_nsec = from->di_atime.t_nsec;
-	to->di_mtime.t_sec = from->di_mtime.t_sec;
-	to->di_mtime.t_nsec = from->di_mtime.t_nsec;
-	to->di_ctime.t_sec = from->di_ctime.t_sec;
-	to->di_ctime.t_nsec = from->di_ctime.t_nsec;
-	to->di_size = from->di_size;
-	to->di_nblocks = from->di_nblocks;
-	to->di_extsize = from->di_extsize;
-	to->di_nextents = from->di_nextents;
-	to->di_anextents = from->di_anextents;
-	to->di_forkoff = from->di_forkoff;
-	to->di_aformat = from->di_aformat;
-	to->di_dmevmask = from->di_dmevmask;
-	to->di_dmstate = from->di_dmstate;
-	to->di_flags = from->di_flags;
-	to->di_gen = from->di_gen;
 
-	if (from->di_version == 3) {
-		to->di_changecount = from->di_changecount;
-		to->di_crtime.t_sec = from->di_crtime.t_sec;
-		to->di_crtime.t_nsec = from->di_crtime.t_nsec;
-		to->di_flags2 = from->di_flags2;
-		to->di_ino = from->di_ino;
-		to->di_lsn = from->di_lsn;
-		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
-		uuid_copy(&to->di_uuid, &from->di_uuid);
-		to->di_flushiter = 0;
-	} else {
-		to->di_flushiter = from->di_flushiter;
-	}
-}
+	to->di_atime.t_sec = inode->i_atime.tv_sec;
+	to->di_atime.t_nsec = inode->i_atime.tv_nsec;
+	to->di_mtime.t_sec = inode->i_mtime.tv_sec;
+	to->di_mtime.t_nsec = inode->i_mtime.tv_nsec;
+	to->di_ctime.t_sec = inode->i_ctime.tv_sec;
+	to->di_ctime.t_nsec = inode->i_ctime.tv_nsec;
 
-/*
- * Recovery needs to be able to convert a log dinode back to a real dinode
- * for writeback we do that by converting a log dinode to a icdinode, and
- * then passing that to the formatting function.
- */
-void
-xfs_log_dinode_to_icdinode(
-	struct xfs_log_dinode	*from,
-	struct xfs_icdinode	*to)
-{
-	to->di_magic = from->di_magic;
-	to->di_mode = from->di_mode;
-	to->di_version = from->di_version;
-	to->di_format = from->di_format;
-	to->di_onlink = from->di_onlink;
-	to->di_uid = from->di_uid;
-	to->di_gid = from->di_gid;
-	to->di_nlink = from->di_nlink;
-	to->di_projid_lo = from->di_projid_lo;
-	to->di_projid_hi = from->di_projid_hi;
-	memset(to->di_pad, 0, sizeof(to->di_pad));
-	to->di_atime.t_sec = from->di_atime.t_sec;
-	to->di_atime.t_nsec = from->di_atime.t_nsec;
-	to->di_mtime.t_sec = from->di_mtime.t_sec;
-	to->di_mtime.t_nsec = from->di_mtime.t_nsec;
-	to->di_ctime.t_sec = from->di_ctime.t_sec;
-	to->di_ctime.t_nsec = from->di_ctime.t_nsec;
 	to->di_size = from->di_size;
 	to->di_nblocks = from->di_nblocks;
 	to->di_extsize = from->di_extsize;
@@ -439,7 +390,7 @@ xfs_inode_item_format_core(
 	struct xfs_log_dinode	*dic;
 
 	dic = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_ICORE);
-	xfs_icdinode_to_log_dinode(&ip->i_d, dic);
+	xfs_inode_to_log_dinode(ip, dic);
 	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_d.di_version));
 }
 
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 2426118..4c7722e 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -49,8 +49,6 @@ extern void xfs_istale_done(struct xfs_buf *, struct xfs_log_item *);
 extern void xfs_iflush_abort(struct xfs_inode *, bool);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 					 xfs_inode_log_format_t *);
-extern void xfs_log_dinode_to_icdinode(struct xfs_log_dinode *from,
-				       struct xfs_icdinode *to);
 
 extern struct kmem_zone	*xfs_ili_zone;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 245268a..b008677 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -517,21 +517,12 @@ xfs_setattr_time(
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
-	if (iattr->ia_valid & ATTR_ATIME) {
+	if (iattr->ia_valid & ATTR_ATIME)
 		inode->i_atime = iattr->ia_atime;
-		ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
-		ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
-	}
-	if (iattr->ia_valid & ATTR_CTIME) {
+	if (iattr->ia_valid & ATTR_CTIME)
 		inode->i_ctime = iattr->ia_ctime;
-		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
-		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
-	}
-	if (iattr->ia_valid & ATTR_MTIME) {
+	if (iattr->ia_valid & ATTR_MTIME)
 		inode->i_mtime = iattr->ia_mtime;
-		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
-		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
-	}
 }
 
 int
@@ -986,21 +977,13 @@ xfs_vn_update_time(
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (flags & S_CTIME) {
+	if (flags & S_CTIME)
 		inode->i_ctime = *now;
-		ip->i_d.di_ctime.t_sec = (__int32_t)now->tv_sec;
-		ip->i_d.di_ctime.t_nsec = (__int32_t)now->tv_nsec;
-	}
-	if (flags & S_MTIME) {
+	if (flags & S_MTIME)
 		inode->i_mtime = *now;
-		ip->i_d.di_mtime.t_sec = (__int32_t)now->tv_sec;
-		ip->i_d.di_mtime.t_nsec = (__int32_t)now->tv_nsec;
-	}
-	if (flags & S_ATIME) {
+	if (flags & S_ATIME)
 		inode->i_atime = *now;
-		ip->i_d.di_atime.t_sec = (__int32_t)now->tv_sec;
-		ip->i_d.di_atime.t_nsec = (__int32_t)now->tv_nsec;
-	}
+
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
 	return xfs_trans_commit(tp);
@@ -1247,12 +1230,6 @@ xfs_setup_inode(
 
 	inode->i_generation = ip->i_d.di_gen;
 	i_size_write(inode, ip->i_d.di_size);
-	inode->i_atime.tv_sec	= ip->i_d.di_atime.t_sec;
-	inode->i_atime.tv_nsec	= ip->i_d.di_atime.t_nsec;
-	inode->i_mtime.tv_sec	= ip->i_d.di_mtime.t_sec;
-	inode->i_mtime.tv_nsec	= ip->i_d.di_mtime.t_nsec;
-	inode->i_ctime.tv_sec	= ip->i_d.di_ctime.t_sec;
-	inode->i_ctime.tv_nsec	= ip->i_d.di_ctime.t_nsec;
 	xfs_diflags_to_iflags(inode, ip);
 
 	ip->d_ops = ip->i_mount->m_nondir_inode_ops;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 930ebd8..2acda42 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -57,6 +57,7 @@ xfs_bulkstat_one_int(
 {
 	struct xfs_icdinode	*dic;		/* dinode core info pointer */
 	struct xfs_inode	*ip;		/* incore inode pointer */
+	struct inode		*inode;
 	struct xfs_bstat	*buf;		/* return buffer */
 	int			error = 0;	/* error value */
 
@@ -77,6 +78,7 @@ xfs_bulkstat_one_int(
 
 	ASSERT(ip != NULL);
 	ASSERT(ip->i_imap.im_blkno != 0);
+	inode = VFS_I(ip);
 
 	dic = &ip->i_d;
 
@@ -91,12 +93,14 @@ xfs_bulkstat_one_int(
 	buf->bs_uid = dic->di_uid;
 	buf->bs_gid = dic->di_gid;
 	buf->bs_size = dic->di_size;
-	buf->bs_atime.tv_sec = dic->di_atime.t_sec;
-	buf->bs_atime.tv_nsec = dic->di_atime.t_nsec;
-	buf->bs_mtime.tv_sec = dic->di_mtime.t_sec;
-	buf->bs_mtime.tv_nsec = dic->di_mtime.t_nsec;
-	buf->bs_ctime.tv_sec = dic->di_ctime.t_sec;
-	buf->bs_ctime.tv_nsec = dic->di_ctime.t_nsec;
+
+	buf->bs_atime.tv_sec = inode->i_atime.tv_sec;
+	buf->bs_atime.tv_nsec = inode->i_atime.tv_nsec;
+	buf->bs_mtime.tv_sec = inode->i_mtime.tv_sec;
+	buf->bs_mtime.tv_nsec = inode->i_mtime.tv_nsec;
+	buf->bs_ctime.tv_sec = inode->i_ctime.tv_sec;
+	buf->bs_ctime.tv_nsec = inode->i_ctime.tv_nsec;
+
 	buf->bs_xflags = xfs_ip2xflags(ip);
 	buf->bs_extsize = dic->di_extsize << mp->m_sb.sb_blocklog;
 	buf->bs_extents = dic->di_nextents;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3120f7b..4b79cf0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2793,7 +2793,7 @@ xfs_recover_inode_owner_change(
 		return -ENOMEM;
 
 	/* instantiate the inode */
-	xfs_dinode_from_disk(&ip->i_d, dip);
+	xfs_inode_from_disk(ip, dip);
 	ASSERT(ip->i_d.di_version >= 3);
 
 	error = xfs_iformat_fork(ip, dip);
@@ -2840,7 +2840,6 @@ xlog_recover_inode_pass2(
 	int			attr_index;
 	uint			fields;
 	struct xfs_log_dinode	*ldip;
-	struct xfs_icdinode	icic;
 	uint			isize;
 	int			need_free = 0;
 
@@ -3007,9 +3006,8 @@ xlog_recover_inode_pass2(
 		goto out_release;
 	}
 
-	/* The core is in in-core format */
-	xfs_log_dinode_to_icdinode(ldip, &icic);
-	xfs_dinode_to_disk(dip, &icic);
+	/* recover the log dinode inode into the on disk inode */
+	xfs_log_dinode_to_disk(ldip, dip);
 
 	/* the rest is in on-disk format */
 	if (item->ri_buf[1].i_len > isize) {
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index be02a68..abf4443 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1272,7 +1272,7 @@ xfs_rtpick_extent(
 
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
-	seqp = (__uint64_t *)&mp->m_rbmip->i_d.di_atime;
+	seqp = (__uint64_t *)&VFS_I(mp->m_rbmip)->i_atime;
 	if (!(mp->m_rbmip->i_d.di_flags & XFS_DIFLAG_NEWRTBM)) {
 		mp->m_rbmip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
 		*seqp = 0;
diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index b97f1df..3f0d466 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -75,18 +75,10 @@ xfs_trans_ichgtime(
 
 	tv = current_fs_time(inode->i_sb);
 
-	if ((flags & XFS_ICHGTIME_MOD) &&
-	    !timespec_equal(&inode->i_mtime, &tv)) {
+	if (flags & XFS_ICHGTIME_MOD)
 		inode->i_mtime = tv;
-		ip->i_d.di_mtime.t_sec = tv.tv_sec;
-		ip->i_d.di_mtime.t_nsec = tv.tv_nsec;
-	}
-	if ((flags & XFS_ICHGTIME_CHG) &&
-	    !timespec_equal(&inode->i_ctime, &tv)) {
+	if (flags & XFS_ICHGTIME_CHG)
 		inode->i_ctime = tv;
-		ip->i_d.di_ctime.t_sec = tv.tv_sec;
-		ip->i_d.di_ctime.t_nsec = tv.tv_nsec;
-	}
 }
 
 /*
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
