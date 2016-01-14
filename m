Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4AA447F4E
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 00:10:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12287304059
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 22:10:30 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZK22wYS6gngXUsdX for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2016 22:10:25 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aJb68-0002OS-LL
	for xfs@oss.sgi.com; Thu, 14 Jan 2016 17:09:28 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aJb68-0001Ur-KW
	for xfs@oss.sgi.com; Thu, 14 Jan 2016 17:09:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/8] xfs: introduce inode log format object
Date: Thu, 14 Jan 2016 17:09:18 +1100
Message-Id: <1452751765-4420-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1452751765-4420-1-git-send-email-david@fromorbit.com>
References: <1452751765-4420-1-git-send-email-david@fromorbit.com>
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

We currently carry around and log an entire inode core in the
struct xfs_inode. A lot of the information in the inode core is
duplicated in the VFS inode, but we cannot remove this duplication
of infomration because the inode core is logged directly in
xfs_inode_item_format().

Add a new function xfs_inode_item_format_core() that copies the
inode core data into a struct xfs_icdinode that is pulled directly
from the log vector buffer. This means we no longer directly
copy the inode core, but copy the structures one member at a time.
This will be slightly less efficient than copying, but will allow us
to remove duplicate and unnecessary items from the struct xfs_inode.

To enable us to do this, call the new structure a xfs_log_dinode,
so that we know it's different to the physical xfs_dinode and the
in-core xfs_icdinode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c  |   8 +--
 fs/xfs/libxfs/xfs_inode_buf.h  |  53 ++++++++++++++++-
 fs/xfs/libxfs/xfs_log_format.h |  15 ++---
 fs/xfs/xfs_icache.c            |   2 +-
 fs/xfs/xfs_inode.c             |   6 +-
 fs/xfs/xfs_inode.h             |   2 +-
 fs/xfs/xfs_inode_item.c        | 128 +++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_inode_item.h        |   2 +
 fs/xfs/xfs_log_recover.c       |  52 +++++++++--------
 9 files changed, 221 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 1aabfda..63d46bf 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -196,8 +196,8 @@ xfs_imap_to_bp(
 
 void
 xfs_dinode_from_disk(
-	xfs_icdinode_t		*to,
-	xfs_dinode_t		*from)
+	struct xfs_icdinode	*to,
+	struct xfs_dinode	*from)
 {
 	to->di_magic = be16_to_cpu(from->di_magic);
 	to->di_mode = be16_to_cpu(from->di_mode);
@@ -243,8 +243,8 @@ xfs_dinode_from_disk(
 
 void
 xfs_dinode_to_disk(
-	xfs_dinode_t		*to,
-	xfs_icdinode_t		*from)
+	struct xfs_dinode	*to,
+	struct xfs_icdinode	*from)
 {
 	to->di_magic = cpu_to_be16(from->di_magic);
 	to->di_mode = cpu_to_be16(from->di_mode);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 9308c47..642f2a2 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -20,7 +20,58 @@
 
 struct xfs_inode;
 struct xfs_dinode;
-struct xfs_icdinode;
+
+/*
+ * In memory representation of the XFS inode. This is held in the in-core
+ * struct xfs_inode to represent the on disk values, but no longer needs to be
+ * identical to the on-disk structure as it is always translated to on-disk
+ * format specific structures at the appropriate time.
+ */
+struct xfs_icdinode {
+	__uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
+	__uint16_t	di_mode;	/* mode and type of file */
+	__int8_t	di_version;	/* inode version */
+	__int8_t	di_format;	/* format of di_c data */
+	__uint16_t	di_onlink;	/* old number of links to file */
+	__uint32_t	di_uid;		/* owner's user id */
+	__uint32_t	di_gid;		/* owner's group id */
+	__uint32_t	di_nlink;	/* number of links to file */
+	__uint16_t	di_projid_lo;	/* lower part of owner's project id */
+	__uint16_t	di_projid_hi;	/* higher part of owner's project id */
+	__uint8_t	di_pad[6];	/* unused, zeroed space */
+	__uint16_t	di_flushiter;	/* incremented on flush */
+	xfs_ictimestamp_t di_atime;	/* time last accessed */
+	xfs_ictimestamp_t di_mtime;	/* time last modified */
+	xfs_ictimestamp_t di_ctime;	/* time created/inode modified */
+	xfs_fsize_t	di_size;	/* number of bytes in file */
+	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
+	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
+	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
+	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	__uint8_t	di_forkoff;	/* attr fork offs, <<3 for 64b align */
+	__int8_t	di_aformat;	/* format of attr fork's data */
+	__uint32_t	di_dmevmask;	/* DMIG event mask */
+	__uint16_t	di_dmstate;	/* DMIG state info */
+	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
+	__uint32_t	di_gen;		/* generation number */
+
+	/* di_next_unlinked is the only non-core field in the old dinode */
+	xfs_agino_t	di_next_unlinked;/* agi unlinked list ptr */
+
+	/* start of the extended dinode, writable fields */
+	__uint32_t	di_crc;		/* CRC of the inode */
+	__uint64_t	di_changecount;	/* number of attribute changes */
+	xfs_lsn_t	di_lsn;		/* flush sequence */
+	__uint64_t	di_flags2;	/* more random flags */
+	__uint8_t	di_pad2[16];	/* more padding for future expansion */
+
+	/* fields only written to during inode creation */
+	xfs_ictimestamp_t di_crtime;	/* time created */
+	xfs_ino_t	di_ino;		/* inode number */
+	uuid_t		di_uuid;	/* UUID of the filesystem */
+
+	/* structure must be padded to 64 bit alignment */
+};
 
 /*
  * Inode location information.  Stored in the inode and passed to
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 2653146..d00ed63 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -290,6 +290,7 @@ typedef struct xfs_inode_log_format_64 {
 	__int32_t		ilf_boffset;	/* off of inode in buffer */
 } xfs_inode_log_format_64_t;
 
+
 /*
  * Flags for xfs_trans_log_inode flags field.
  */
@@ -360,10 +361,10 @@ typedef struct xfs_ictimestamp {
 } xfs_ictimestamp_t;
 
 /*
- * NOTE:  This structure must be kept identical to struct xfs_dinode
- *	  except for the endianness annotations.
+ * Define the format of the inode core that is logged. This structure must be
+ * kept identical to struct xfs_dinode except for the endianness annotations.
  */
-typedef struct xfs_icdinode {
+struct xfs_log_dinode {
 	__uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
 	__uint16_t	di_mode;	/* mode and type of file */
 	__int8_t	di_version;	/* inode version */
@@ -407,13 +408,13 @@ typedef struct xfs_icdinode {
 	uuid_t		di_uuid;	/* UUID of the filesystem */
 
 	/* structure must be padded to 64 bit alignment */
-} xfs_icdinode_t;
+};
 
-static inline uint xfs_icdinode_size(int version)
+static inline uint xfs_log_dinode_size(int version)
 {
 	if (version == 3)
-		return sizeof(struct xfs_icdinode);
-	return offsetof(struct xfs_icdinode, di_next_unlinked);
+		return sizeof(struct xfs_log_dinode);
+	return offsetof(struct xfs_log_dinode, di_next_unlinked);
 }
 
 /*
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d7a490f..7c26f86 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -79,7 +79,7 @@ xfs_inode_alloc(
 	memset(&ip->i_df, 0, sizeof(xfs_ifork_t));
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
-	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));
+	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
 	return ip;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ae3758a..7e24232 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -650,9 +650,9 @@ _xfs_dic2xflags(
 
 uint
 xfs_ip2xflags(
-	xfs_inode_t		*ip)
+	struct xfs_inode	*ip)
 {
-	xfs_icdinode_t		*dic = &ip->i_d;
+	struct xfs_icdinode	*dic = &ip->i_d;
 
 	return _xfs_dic2xflags(dic->di_flags) |
 				(XFS_IFORK_Q(ip) ? XFS_XFLAG_HASATTR : 0);
@@ -660,7 +660,7 @@ xfs_ip2xflags(
 
 uint
 xfs_dic2xflags(
-	xfs_dinode_t		*dip)
+	struct xfs_dinode	*dip)
 {
 	return _xfs_dic2xflags(be16_to_cpu(dip->di_flags)) |
 				(XFS_DFORK_Q(dip) ? XFS_XFLAG_HASATTR : 0);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ca9e119..aef5452 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -63,7 +63,7 @@ typedef struct xfs_inode {
 	unsigned long		i_flags;	/* see defined flags below */
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 
-	xfs_icdinode_t		i_d;		/* most of ondisk inode */
+	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index d14b12b..3ad9972 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -135,7 +135,7 @@ xfs_inode_item_size(
 
 	*nvecs += 2;
 	*nbytes += sizeof(struct xfs_inode_log_format) +
-		   xfs_icdinode_size(ip->i_d.di_version);
+		   xfs_log_dinode_size(ip->i_d.di_version);
 
 	xfs_inode_item_data_fork_size(iip, nvecs, nbytes);
 	if (XFS_IFORK_Q(ip))
@@ -322,6 +322,127 @@ xfs_inode_item_format_attr_fork(
 	}
 }
 
+static void
+xfs_icdinode_to_log_dinode(
+	struct xfs_icdinode	*from,
+	struct xfs_log_dinode	*to)
+{
+	to->di_magic = from->di_magic;
+	to->di_mode = from->di_mode;
+	to->di_version = from->di_version;
+	to->di_format = from->di_format;
+	to->di_onlink = from->di_onlink;
+	to->di_uid = from->di_uid;
+	to->di_gid = from->di_gid;
+	to->di_nlink = from->di_nlink;
+	to->di_projid_lo = from->di_projid_lo;
+	to->di_projid_hi = from->di_projid_hi;
+	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
+	to->di_atime.t_sec = from->di_atime.t_sec;
+	to->di_atime.t_nsec = from->di_atime.t_nsec;
+	to->di_mtime.t_sec = from->di_mtime.t_sec;
+	to->di_mtime.t_nsec = from->di_mtime.t_nsec;
+	to->di_ctime.t_sec = from->di_ctime.t_sec;
+	to->di_ctime.t_nsec = from->di_ctime.t_nsec;
+	to->di_size = from->di_size;
+	to->di_nblocks = from->di_nblocks;
+	to->di_extsize = from->di_extsize;
+	to->di_nextents = from->di_nextents;
+	to->di_anextents = from->di_anextents;
+	to->di_forkoff = from->di_forkoff;
+	to->di_aformat = from->di_aformat;
+	to->di_dmevmask = from->di_dmevmask;
+	to->di_dmstate = from->di_dmstate;
+	to->di_flags = from->di_flags;
+	to->di_gen = from->di_gen;
+
+	if (from->di_version == 3) {
+		to->di_changecount = from->di_changecount;
+		to->di_crtime.t_sec = from->di_crtime.t_sec;
+		to->di_crtime.t_nsec = from->di_crtime.t_nsec;
+		to->di_flags2 = from->di_flags2;
+		to->di_ino = from->di_ino;
+		to->di_lsn = from->di_lsn;
+		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
+		uuid_copy(&to->di_uuid, &from->di_uuid);
+		to->di_flushiter = 0;
+	} else {
+		to->di_flushiter = from->di_flushiter;
+	}
+}
+
+/*
+ * Recovery needs to be able to convert a log dinode back to a real dinode
+ * for writeback we do that by converting a log dinode to a icdinode, and
+ * then passing that to the formatting function.
+ */
+void
+xfs_log_dinode_to_icdinode(
+	struct xfs_log_dinode	*from,
+	struct xfs_icdinode	*to)
+{
+	to->di_magic = from->di_magic;
+	to->di_mode = from->di_mode;
+	to->di_version = from->di_version;
+	to->di_format = from->di_format;
+	to->di_onlink = from->di_onlink;
+	to->di_uid = from->di_uid;
+	to->di_gid = from->di_gid;
+	to->di_nlink = from->di_nlink;
+	to->di_projid_lo = from->di_projid_lo;
+	to->di_projid_hi = from->di_projid_hi;
+	memset(to->di_pad, 0, sizeof(to->di_pad));
+	to->di_atime.t_sec = from->di_atime.t_sec;
+	to->di_atime.t_nsec = from->di_atime.t_nsec;
+	to->di_mtime.t_sec = from->di_mtime.t_sec;
+	to->di_mtime.t_nsec = from->di_mtime.t_nsec;
+	to->di_ctime.t_sec = from->di_ctime.t_sec;
+	to->di_ctime.t_nsec = from->di_ctime.t_nsec;
+	to->di_size = from->di_size;
+	to->di_nblocks = from->di_nblocks;
+	to->di_extsize = from->di_extsize;
+	to->di_nextents = from->di_nextents;
+	to->di_anextents = from->di_anextents;
+	to->di_forkoff = from->di_forkoff;
+	to->di_aformat = from->di_aformat;
+	to->di_dmevmask = from->di_dmevmask;
+	to->di_dmstate = from->di_dmstate;
+	to->di_flags = from->di_flags;
+	to->di_gen = from->di_gen;
+
+	if (from->di_version == 3) {
+		to->di_changecount = from->di_changecount;
+		to->di_crtime.t_sec = from->di_crtime.t_sec;
+		to->di_crtime.t_nsec = from->di_crtime.t_nsec;
+		to->di_flags2 = from->di_flags2;
+		to->di_ino = from->di_ino;
+		to->di_lsn = from->di_lsn;
+		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
+		uuid_copy(&to->di_uuid, &from->di_uuid);
+		to->di_flushiter = 0;
+	} else {
+		to->di_flushiter = from->di_flushiter;
+	}
+}
+
+/*
+ * Format the inode core. Current timestamp data is only in the VFS inode
+ * fields, so we need to grab them from there. Hence rather than just copying
+ * the XFS inode core structure, format the fields directly into the iovec.
+ */
+static void
+xfs_inode_item_format_core(
+	struct xfs_inode	*ip,
+	struct xfs_log_vec	*lv,
+	struct xfs_log_iovec	**vecp)
+{
+	struct xfs_log_dinode	*dic;
+
+	dic = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_ICORE);
+	xfs_icdinode_to_log_dinode(&ip->i_d, dic);
+	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_d.di_version));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the given inode
  * log item.  It fills the first item with an inode log format structure,
@@ -351,10 +472,7 @@ xfs_inode_item_format(
 	ilf->ilf_size = 2; /* format + core */
 	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_inode_log_format));
 
-	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ICORE,
-			&ip->i_d,
-			xfs_icdinode_size(ip->i_d.di_version));
-
+	xfs_inode_item_format_core(ip, lv, &vecp);
 	xfs_inode_item_format_data_fork(iip, ilf, lv, &vecp);
 	if (XFS_IFORK_Q(ip)) {
 		xfs_inode_item_format_attr_fork(iip, ilf, lv, &vecp);
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 4c7722e..2426118 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -49,6 +49,8 @@ extern void xfs_istale_done(struct xfs_buf *, struct xfs_log_item *);
 extern void xfs_iflush_abort(struct xfs_inode *, bool);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 					 xfs_inode_log_format_t *);
+extern void xfs_log_dinode_to_icdinode(struct xfs_log_dinode *from,
+				       struct xfs_icdinode *to);
 
 extern struct kmem_zone	*xfs_ili_zone;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index da37beb..3120f7b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2839,7 +2839,8 @@ xlog_recover_inode_pass2(
 	int			error;
 	int			attr_index;
 	uint			fields;
-	xfs_icdinode_t		*dicp;
+	struct xfs_log_dinode	*ldip;
+	struct xfs_icdinode	icic;
 	uint			isize;
 	int			need_free = 0;
 
@@ -2892,8 +2893,8 @@ xlog_recover_inode_pass2(
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
-	dicp = item->ri_buf[1].i_addr;
-	if (unlikely(dicp->di_magic != XFS_DINODE_MAGIC)) {
+	ldip = item->ri_buf[1].i_addr;
+	if (unlikely(ldip->di_magic != XFS_DINODE_MAGIC)) {
 		xfs_alert(mp,
 			"%s: Bad inode log record, rec ptr 0x%p, ino %Ld",
 			__func__, item, in_f->ilf_ino);
@@ -2929,13 +2930,13 @@ xlog_recover_inode_pass2(
 	 * to skip replay when the on disk inode is newer than the log one
 	 */
 	if (!xfs_sb_version_hascrc(&mp->m_sb) &&
-	    dicp->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
+	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
 		/*
 		 * Deal with the wrap case, DI_MAX_FLUSH is less
 		 * than smaller numbers
 		 */
 		if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
-		    dicp->di_flushiter < (DI_MAX_FLUSH >> 1)) {
+		    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
 			/* do nothing */
 		} else {
 			trace_xfs_log_recover_inode_skip(log, in_f);
@@ -2945,13 +2946,13 @@ xlog_recover_inode_pass2(
 	}
 
 	/* Take the opportunity to reset the flush iteration count */
-	dicp->di_flushiter = 0;
+	ldip->di_flushiter = 0;
 
-	if (unlikely(S_ISREG(dicp->di_mode))) {
-		if ((dicp->di_format != XFS_DINODE_FMT_EXTENTS) &&
-		    (dicp->di_format != XFS_DINODE_FMT_BTREE)) {
+	if (unlikely(S_ISREG(ldip->di_mode))) {
+		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
+		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
-					 XFS_ERRLEVEL_LOW, mp, dicp);
+					 XFS_ERRLEVEL_LOW, mp, ldip);
 			xfs_alert(mp,
 		"%s: Bad regular inode log record, rec ptr 0x%p, "
 		"ino ptr = 0x%p, ino bp = 0x%p, ino %Ld",
@@ -2959,12 +2960,12 @@ xlog_recover_inode_pass2(
 			error = -EFSCORRUPTED;
 			goto out_release;
 		}
-	} else if (unlikely(S_ISDIR(dicp->di_mode))) {
-		if ((dicp->di_format != XFS_DINODE_FMT_EXTENTS) &&
-		    (dicp->di_format != XFS_DINODE_FMT_BTREE) &&
-		    (dicp->di_format != XFS_DINODE_FMT_LOCAL)) {
+	} else if (unlikely(S_ISDIR(ldip->di_mode))) {
+		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
+		    (ldip->di_format != XFS_DINODE_FMT_BTREE) &&
+		    (ldip->di_format != XFS_DINODE_FMT_LOCAL)) {
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(4)",
-					     XFS_ERRLEVEL_LOW, mp, dicp);
+					     XFS_ERRLEVEL_LOW, mp, ldip);
 			xfs_alert(mp,
 		"%s: Bad dir inode log record, rec ptr 0x%p, "
 		"ino ptr = 0x%p, ino bp = 0x%p, ino %Ld",
@@ -2973,32 +2974,32 @@ xlog_recover_inode_pass2(
 			goto out_release;
 		}
 	}
-	if (unlikely(dicp->di_nextents + dicp->di_anextents > dicp->di_nblocks)){
+	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
-				     XFS_ERRLEVEL_LOW, mp, dicp);
+				     XFS_ERRLEVEL_LOW, mp, ldip);
 		xfs_alert(mp,
 	"%s: Bad inode log record, rec ptr 0x%p, dino ptr 0x%p, "
 	"dino bp 0x%p, ino %Ld, total extents = %d, nblocks = %Ld",
 			__func__, item, dip, bp, in_f->ilf_ino,
-			dicp->di_nextents + dicp->di_anextents,
-			dicp->di_nblocks);
+			ldip->di_nextents + ldip->di_anextents,
+			ldip->di_nblocks);
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
-	if (unlikely(dicp->di_forkoff > mp->m_sb.sb_inodesize)) {
+	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
-				     XFS_ERRLEVEL_LOW, mp, dicp);
+				     XFS_ERRLEVEL_LOW, mp, ldip);
 		xfs_alert(mp,
 	"%s: Bad inode log record, rec ptr 0x%p, dino ptr 0x%p, "
 	"dino bp 0x%p, ino %Ld, forkoff 0x%x", __func__,
-			item, dip, bp, in_f->ilf_ino, dicp->di_forkoff);
+			item, dip, bp, in_f->ilf_ino, ldip->di_forkoff);
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
-	isize = xfs_icdinode_size(dicp->di_version);
+	isize = xfs_log_dinode_size(ldip->di_version);
 	if (unlikely(item->ri_buf[1].i_len > isize)) {
 		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
-				     XFS_ERRLEVEL_LOW, mp, dicp);
+				     XFS_ERRLEVEL_LOW, mp, ldip);
 		xfs_alert(mp,
 			"%s: Bad inode log record length %d, rec ptr 0x%p",
 			__func__, item->ri_buf[1].i_len, item);
@@ -3007,7 +3008,8 @@ xlog_recover_inode_pass2(
 	}
 
 	/* The core is in in-core format */
-	xfs_dinode_to_disk(dip, dicp);
+	xfs_log_dinode_to_icdinode(ldip, &icic);
+	xfs_dinode_to_disk(dip, &icic);
 
 	/* the rest is in on-disk format */
 	if (item->ri_buf[1].i_len > isize) {
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
