Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2810D7F4C
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 17:24:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F0CF28F804C
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 15:24:17 -0700 (PDT)
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 13 Mar 2013 15:23:03 -0700
Message-Id: <1363213395-10988-2-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1363213395-10988-1-git-send-email-ebiederm@xmission.com>
References: <87boan3prc.fsf@xmission.com>
	<1363213395-10988-1-git-send-email-ebiederm@xmission.com>
Subject: [PATCH 02/14] xfs: Separate the in core and the logged inode.
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
Cc: Alex Elder <elder@kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>

From: "Eric W. Biederman" <ebiederm@xmission.com>

Add xfs_inode_from_disk xfs_inode_to_disk and xfs_inode_to_log to
handle changes.

Add an extra copy of struct xfs_icdinode into struct
xfs_inode_log_item ultimately it will be the only copy but for the
moment it is a temporary copy.

In struct xfs_inode change the type of i_d to an anonymous structure
with all of the same members as struct xfs_icdinode.

Modify the two places that create a pointer to ip->i_d as
a shortcut to get shorter names to use ip->i_d directly.

Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/xfs/xfs_icache.c     |    2 +-
 fs/xfs/xfs_inode.c      |  138 ++++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_inode.h      |   31 ++++++++++-
 fs/xfs/xfs_inode_item.c |    3 +-
 fs/xfs/xfs_inode_item.h |    1 +
 fs/xfs/xfs_itable.c     |   45 +++++++--------
 6 files changed, 155 insertions(+), 65 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 96e344e..1213f07 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -82,7 +82,7 @@ xfs_inode_alloc(
 	memset(&ip->i_df, 0, sizeof(xfs_ifork_t));
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
-	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
+	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
 	return ip;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4f20165..469b9b3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -832,40 +832,104 @@ xfs_iformat_btree(
 	return 0;
 }
 
-STATIC void
-xfs_dinode_from_disk(
-	xfs_icdinode_t		*to,
-	xfs_dinode_t		*from)
-{
-	to->di_magic = be16_to_cpu(from->di_magic);
-	to->di_mode = be16_to_cpu(from->di_mode);
-	to->di_version = from ->di_version;
-	to->di_format = from->di_format;
-	to->di_onlink = be16_to_cpu(from->di_onlink);
-	to->di_uid = be32_to_cpu(from->di_uid);
-	to->di_gid = be32_to_cpu(from->di_gid);
-	to->di_nlink = be32_to_cpu(from->di_nlink);
-	to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
-	to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
-	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
-	to->di_flushiter = be16_to_cpu(from->di_flushiter);
-	to->di_atime.t_sec = be32_to_cpu(from->di_atime.t_sec);
-	to->di_atime.t_nsec = be32_to_cpu(from->di_atime.t_nsec);
-	to->di_mtime.t_sec = be32_to_cpu(from->di_mtime.t_sec);
-	to->di_mtime.t_nsec = be32_to_cpu(from->di_mtime.t_nsec);
-	to->di_ctime.t_sec = be32_to_cpu(from->di_ctime.t_sec);
-	to->di_ctime.t_nsec = be32_to_cpu(from->di_ctime.t_nsec);
-	to->di_size = be64_to_cpu(from->di_size);
-	to->di_nblocks = be64_to_cpu(from->di_nblocks);
-	to->di_extsize = be32_to_cpu(from->di_extsize);
-	to->di_nextents = be32_to_cpu(from->di_nextents);
-	to->di_anextents = be16_to_cpu(from->di_anextents);
-	to->di_forkoff = from->di_forkoff;
-	to->di_aformat	= from->di_aformat;
-	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
-	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
-	to->di_flags	= be16_to_cpu(from->di_flags);
-	to->di_gen	= be32_to_cpu(from->di_gen);
+static void xfs_inode_from_disk(struct xfs_inode *to, struct xfs_dinode *from)
+{
+	to->i_d.di_magic	= be16_to_cpu(from->di_magic);
+	to->i_d.di_mode		= be16_to_cpu(from->di_mode);
+	to->i_d.di_version	= from ->di_version;
+	to->i_d.di_format	= from->di_format;
+	to->i_d.di_onlink	= be16_to_cpu(from->di_onlink);
+	to->i_d.di_uid		= be32_to_cpu(from->di_uid);
+	to->i_d.di_gid		= be32_to_cpu(from->di_gid);
+	to->i_d.di_nlink	= be32_to_cpu(from->di_nlink);
+	to->i_d.di_projid_lo	= be16_to_cpu(from->di_projid_lo);
+	to->i_d.di_projid_hi	= be16_to_cpu(from->di_projid_hi);
+	memcpy(to->i_d.di_pad, from->di_pad, sizeof(to->i_d.di_pad));
+	to->i_d.di_flushiter	= be16_to_cpu(from->di_flushiter);
+	to->i_d.di_atime.t_sec	= be32_to_cpu(from->di_atime.t_sec);
+	to->i_d.di_atime.t_nsec	= be32_to_cpu(from->di_atime.t_nsec);
+	to->i_d.di_mtime.t_sec	= be32_to_cpu(from->di_mtime.t_sec);
+	to->i_d.di_mtime.t_nsec = be32_to_cpu(from->di_mtime.t_nsec);
+	to->i_d.di_ctime.t_sec	= be32_to_cpu(from->di_ctime.t_sec);
+	to->i_d.di_ctime.t_nsec	= be32_to_cpu(from->di_ctime.t_nsec);
+	to->i_d.di_size		= be64_to_cpu(from->di_size);
+	to->i_d.di_nblocks	= be64_to_cpu(from->di_nblocks);
+	to->i_d.di_extsize	= be32_to_cpu(from->di_extsize);
+	to->i_d.di_nextents	= be32_to_cpu(from->di_nextents);
+	to->i_d.di_anextents	= be16_to_cpu(from->di_anextents);
+	to->i_d.di_forkoff 	= from->di_forkoff;
+	to->i_d.di_aformat	= from->di_aformat;
+	to->i_d.di_dmevmask	= be32_to_cpu(from->di_dmevmask);
+	to->i_d.di_dmstate	= be16_to_cpu(from->di_dmstate);
+	to->i_d.di_flags	= be16_to_cpu(from->di_flags);
+	to->i_d.di_gen		= be32_to_cpu(from->di_gen);
+}
+
+static void xfs_inode_to_disk(struct xfs_dinode *to, struct xfs_inode *from)
+{
+	to->di_magic		= cpu_to_be16(from->i_d.di_magic);
+	to->di_mode		= cpu_to_be16(from->i_d.di_mode);
+	to->di_version		= from->i_d.di_version;
+	to->di_format		= from->i_d.di_format;
+	to->di_onlink		= cpu_to_be16(from->i_d.di_onlink);
+	to->di_uid		= cpu_to_be32(from->i_d.di_uid);
+	to->di_gid		= cpu_to_be32(from->i_d.di_gid);
+	to->di_nlink		= cpu_to_be32(from->i_d.di_nlink);
+	to->di_projid_lo	= cpu_to_be16(from->i_d.di_projid_lo);
+	to->di_projid_hi	= cpu_to_be16(from->i_d.di_projid_hi);
+	memcpy(to->di_pad, from->i_d.di_pad, sizeof(to->di_pad));
+	to->di_flushiter	= cpu_to_be16(from->i_d.di_flushiter);
+	to->di_atime.t_sec	= cpu_to_be32(from->i_d.di_atime.t_sec);
+	to->di_atime.t_nsec	= cpu_to_be32(from->i_d.di_atime.t_nsec);
+	to->di_mtime.t_sec	= cpu_to_be32(from->i_d.di_mtime.t_sec);
+	to->di_mtime.t_nsec	= cpu_to_be32(from->i_d.di_mtime.t_nsec);
+	to->di_ctime.t_sec	= cpu_to_be32(from->i_d.di_ctime.t_sec);
+	to->di_ctime.t_nsec	= cpu_to_be32(from->i_d.di_ctime.t_nsec);
+	to->di_size		= cpu_to_be64(from->i_d.di_size);
+	to->di_nblocks		= cpu_to_be64(from->i_d.di_nblocks);
+	to->di_extsize		= cpu_to_be32(from->i_d.di_extsize);
+	to->di_nextents		= cpu_to_be32(from->i_d.di_nextents);
+	to->di_anextents	= cpu_to_be16(from->i_d.di_anextents);
+	to->di_forkoff		= from->i_d.di_forkoff;
+	to->di_aformat		= from->i_d.di_aformat;
+	to->di_dmevmask		= cpu_to_be32(from->i_d.di_dmevmask);
+	to->di_dmstate		= cpu_to_be16(from->i_d.di_dmstate);
+	to->di_flags		= cpu_to_be16(from->i_d.di_flags);
+	to->di_gen		= cpu_to_be32(from->i_d.di_gen);
+}
+
+void xfs_inode_to_log(struct xfs_icdinode *to, struct xfs_inode *from)
+{
+	/* xfs_inode_to_disk without the endian changes */
+	to->di_magic		= from->i_d.di_magic;
+	to->di_mode		= from->i_d.di_mode;
+	to->di_version		= from->i_d.di_version;
+	to->di_format		= from->i_d.di_format;
+	to->di_onlink		= from->i_d.di_onlink;
+	to->di_uid		= from->i_d.di_uid;
+	to->di_gid		= from->i_d.di_gid;
+	to->di_nlink		= from->i_d.di_nlink;
+	to->di_projid_lo	= from->i_d.di_projid_lo;
+	to->di_projid_hi	= from->i_d.di_projid_hi;
+	memcpy(to->di_pad, from->i_d.di_pad, sizeof(to->di_pad));
+	to->di_flushiter	= from->i_d.di_flushiter;
+	to->di_atime.t_sec	= from->i_d.di_atime.t_sec;
+	to->di_atime.t_nsec	= from->i_d.di_atime.t_nsec;
+	to->di_mtime.t_sec	= from->i_d.di_mtime.t_sec;
+	to->di_mtime.t_nsec	= from->i_d.di_mtime.t_nsec;
+	to->di_ctime.t_sec	= from->i_d.di_ctime.t_sec;
+	to->di_ctime.t_nsec	= from->i_d.di_ctime.t_nsec;
+	to->di_size		= from->i_d.di_size;
+	to->di_nblocks		= from->i_d.di_nblocks;
+	to->di_extsize		= from->i_d.di_extsize;
+	to->di_nextents		= from->i_d.di_nextents;
+	to->di_anextents	= from->i_d.di_anextents;
+	to->di_forkoff		= from->i_d.di_forkoff;
+	to->di_aformat		= from->i_d.di_aformat;
+	to->di_dmevmask		= from->i_d.di_dmevmask;
+	to->di_dmstate		= from->i_d.di_dmstate;
+	to->di_flags		= from->i_d.di_flags;
+	to->di_gen		= from->i_d.di_gen;
 }
 
 void
@@ -948,9 +1012,7 @@ uint
 xfs_ip2xflags(
 	xfs_inode_t		*ip)
 {
-	xfs_icdinode_t		*dic = &ip->i_d;
-
-	return _xfs_dic2xflags(dic->di_flags) |
+	return _xfs_dic2xflags(ip->i_d.di_flags) |
 				(XFS_IFORK_Q(ip) ? XFS_XFLAG_HASATTR : 0);
 }
 
@@ -1012,7 +1074,7 @@ xfs_iread(
 	 * Otherwise, just get the truly permanent information.
 	 */
 	if (dip->di_mode) {
-		xfs_dinode_from_disk(&ip->i_d, dip);
+		xfs_inode_from_disk(ip, dip);
 		error = xfs_iformat(ip, dip);
 		if (error)  {
 #ifdef DEBUG
@@ -2800,7 +2862,7 @@ xfs_iflush_int(
 	 * because if the inode is dirty at all the core must
 	 * be.
 	 */
-	xfs_dinode_to_disk(dip, &ip->i_d);
+	xfs_inode_to_disk(dip, ip);
 
 	/* Wrap, we never let the log put out DI_MAX_FLUSH */
 	if (ip->i_d.di_flushiter == DI_MAX_FLUSH)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 237e7f6..977f1d8 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -243,7 +243,34 @@ typedef struct xfs_inode {
 	unsigned long		i_flags;	/* see defined flags below */
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 
-	xfs_icdinode_t		i_d;		/* most of ondisk inode */
+	struct {
+		u16		di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
+		u16		di_mode;	/* mode and type of file */
+		s8		di_version;	/* inode version */
+		s8		di_format;	/* format of di_c data */
+		u16		di_onlink;	/* old number of links to file */
+		u32		di_uid;		/* owner's user id */
+		u32		di_gid;		/* owner's group id */
+		u32		di_nlink;	/* number of links to file */
+		u16		di_projid_lo;	/* lower part of owner's project id */
+		u16		di_projid_hi;	/* higher part of owner's project id */
+		u8		di_pad[6];	/* unused, zeroed space */
+		u16		di_flushiter;	/* incremented on flush */
+		xfs_ictimestamp_t di_atime;	/* time last accessed */
+		xfs_ictimestamp_t di_mtime;	/* time last modified */
+		xfs_ictimestamp_t di_ctime;	/* time created/inode modified */
+		xfs_fsize_t	di_size;	/* number of bytes in file */
+		xfs_drfsbno_t	di_nblocks;	/* # of direct & btree blocks used */
+		xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
+		xfs_extnum_t	di_nextents;	/* number of extents in data fork */
+		xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+		u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
+		s8		di_aformat;	/* format of attr fork's data */
+		u32		di_dmevmask;	/* DMIG event mask */
+		u16		di_dmstate;	/* DMIG state info */
+		u16		di_flags;	/* random flags, XFS_DIFLAG_... */
+		u32		di_gen;		/* generation number */
+	} i_d;		/* most of ondisk inode */
 
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */
@@ -550,6 +577,8 @@ do { \
 #define XFS_IGET_UNTRUSTED	0x2
 #define XFS_IGET_DONTCACHE	0x4
 
+void xfs_inode_to_log(struct xfs_icdinode *to, struct xfs_inode *from);
+
 int		xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
 			       struct xfs_imap *, struct xfs_dinode **,
 			       struct xfs_buf **, uint, uint);
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index f034bd1..6be81b6 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -178,7 +178,7 @@ xfs_inode_item_format(
 	vecp++;
 	nvecs	     = 1;
 
-	vecp->i_addr = &ip->i_d;
+	vecp->i_addr = &iip->ili_d;
 	vecp->i_len  = sizeof(struct xfs_icdinode);
 	vecp->i_type = XLOG_REG_TYPE_ICORE;
 	vecp++;
@@ -212,6 +212,7 @@ xfs_inode_item_format(
 			memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 		}
 	}
+	xfs_inode_to_log(&iip->ili_d, ip);
 
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_EXTENTS:
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 779812f..9e66a39 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -138,6 +138,7 @@ struct xfs_mount;
 typedef struct xfs_inode_log_item {
 	xfs_log_item_t		ili_item;	   /* common portion */
 	struct xfs_inode	*ili_inode;	   /* inode ptr */
+	struct xfs_icdinode	ili_d;		   /* most of ondisk inode */
 	xfs_lsn_t		ili_flush_lsn;	   /* lsn at last flush */
 	xfs_lsn_t		ili_last_lsn;	   /* lsn at last transaction */
 	unsigned short		ili_lock_flags;	   /* lock flags */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 2ea7d40..dfb7f71 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -60,7 +60,6 @@ xfs_bulkstat_one_int(
 	int			*ubused,	/* bytes used by me */
 	int			*stat)		/* BULKSTAT_RV_... */
 {
-	struct xfs_icdinode	*dic;		/* dinode core info pointer */
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct xfs_bstat	*buf;		/* return buffer */
 	int			error = 0;	/* error value */
@@ -85,36 +84,34 @@ xfs_bulkstat_one_int(
 	ASSERT(ip != NULL);
 	ASSERT(ip->i_imap.im_blkno != 0);
 
-	dic = &ip->i_d;
-
 	/* xfs_iget returns the following without needing
 	 * further change.
 	 */
-	buf->bs_nlink = dic->di_nlink;
-	buf->bs_projid_lo = dic->di_projid_lo;
-	buf->bs_projid_hi = dic->di_projid_hi;
+	buf->bs_nlink = ip->i_d.di_nlink;
+	buf->bs_projid_lo = ip->i_d.di_projid_lo;
+	buf->bs_projid_hi = ip->i_d.di_projid_hi;
 	buf->bs_ino = ino;
-	buf->bs_mode = dic->di_mode;
-	buf->bs_uid = dic->di_uid;
-	buf->bs_gid = dic->di_gid;
-	buf->bs_size = dic->di_size;
-	buf->bs_atime.tv_sec = dic->di_atime.t_sec;
-	buf->bs_atime.tv_nsec = dic->di_atime.t_nsec;
-	buf->bs_mtime.tv_sec = dic->di_mtime.t_sec;
-	buf->bs_mtime.tv_nsec = dic->di_mtime.t_nsec;
-	buf->bs_ctime.tv_sec = dic->di_ctime.t_sec;
-	buf->bs_ctime.tv_nsec = dic->di_ctime.t_nsec;
+	buf->bs_mode = ip->i_d.di_mode;
+	buf->bs_uid = ip->i_d.di_uid;
+	buf->bs_gid = ip->i_d.di_gid;
+	buf->bs_size = ip->i_d.di_size;
+	buf->bs_atime.tv_sec = ip->i_d.di_atime.t_sec;
+	buf->bs_atime.tv_nsec = ip->i_d.di_atime.t_nsec;
+	buf->bs_mtime.tv_sec = ip->i_d.di_mtime.t_sec;
+	buf->bs_mtime.tv_nsec = ip->i_d.di_mtime.t_nsec;
+	buf->bs_ctime.tv_sec = ip->i_d.di_ctime.t_sec;
+	buf->bs_ctime.tv_nsec = ip->i_d.di_ctime.t_nsec;
 	buf->bs_xflags = xfs_ip2xflags(ip);
-	buf->bs_extsize = dic->di_extsize << mp->m_sb.sb_blocklog;
-	buf->bs_extents = dic->di_nextents;
-	buf->bs_gen = dic->di_gen;
+	buf->bs_extsize = ip->i_d.di_extsize << mp->m_sb.sb_blocklog;
+	buf->bs_extents = ip->i_d.di_nextents;
+	buf->bs_gen = ip->i_d.di_gen;
 	memset(buf->bs_pad, 0, sizeof(buf->bs_pad));
-	buf->bs_dmevmask = dic->di_dmevmask;
-	buf->bs_dmstate = dic->di_dmstate;
-	buf->bs_aextents = dic->di_anextents;
+	buf->bs_dmevmask = ip->i_d.di_dmevmask;
+	buf->bs_dmstate = ip->i_d.di_dmstate;
+	buf->bs_aextents = ip->i_d.di_anextents;
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
 
-	switch (dic->di_format) {
+	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_DEV:
 		buf->bs_rdev = ip->i_df.if_u2.if_rdev;
 		buf->bs_blksize = BLKDEV_IOSIZE;
@@ -130,7 +127,7 @@ xfs_bulkstat_one_int(
 	case XFS_DINODE_FMT_BTREE:
 		buf->bs_rdev = 0;
 		buf->bs_blksize = mp->m_sb.sb_blocksize;
-		buf->bs_blocks = dic->di_nblocks + ip->i_delayed_blks;
+		buf->bs_blocks = ip->i_d.di_nblocks + ip->i_delayed_blks;
 		break;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
