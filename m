Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 961F67CB8
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:21:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 78C98304039
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:21:20 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	NZCxiLNiQhq9kZXB for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:21:17 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVwPu-0004lz-Pm
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVwPu-00014N-Ot
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/15] xfs: introduce inode log format object
Date: Wed, 17 Feb 2016 18:20:45 +1100
Message-Id: <1455693652-3899-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1455693652-3899-1-git-send-email-david@fromorbit.com>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
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

Source kernel commit f8d55aa0523ad0f78979c222ed18b78ea7be793a

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
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 db/check.c               |  2 +-
 libxfs/util.c            |  2 +-
 libxfs/xfs_inode_buf.c   |  8 ++++----
 libxfs/xfs_inode_buf.h   | 53 +++++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_log_format.h  | 15 +++++++-------
 logprint/log_misc.c      |  7 ++++---
 logprint/log_print_all.c | 13 ++++++------
 repair/phase6.c          |  8 ++++----
 repair/phase7.c          |  2 +-
 9 files changed, 82 insertions(+), 28 deletions(-)

diff --git a/db/check.c b/db/check.c
index 838db53..d6d1d57 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2619,7 +2619,7 @@ process_inode(
 {
 	blkmap_t		*blkmap;
 	xfs_fsblock_t		bno = 0;
-	xfs_icdinode_t		idic;
+	struct xfs_icdinode	idic;
 	inodata_t		*id = NULL;
 	xfs_ino_t		ino;
 	xfs_extnum_t		nextents = 0;
diff --git a/libxfs/util.c b/libxfs/util.c
index 4a72e89..787fd5d 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -345,7 +345,7 @@ void
 libxfs_iprint(
 	xfs_inode_t		*ip)
 {
-	xfs_icdinode_t		*dip;
+	struct xfs_icdinode	*dip;
 	xfs_bmbt_rec_host_t	*ep;
 	xfs_extnum_t		i;
 	xfs_extnum_t		nextents;
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 89c05ad..dbea592 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -205,8 +205,8 @@ xfs_imap_to_bp(
 
 void
 xfs_dinode_from_disk(
-	xfs_icdinode_t		*to,
-	xfs_dinode_t		*from)
+	struct xfs_icdinode	*to,
+	struct xfs_dinode	*from)
 {
 	to->di_magic = be16_to_cpu(from->di_magic);
 	to->di_mode = be16_to_cpu(from->di_mode);
@@ -252,8 +252,8 @@ xfs_dinode_from_disk(
 
 void
 xfs_dinode_to_disk(
-	xfs_dinode_t		*to,
-	xfs_icdinode_t		*from)
+	struct xfs_dinode	*to,
+	struct xfs_icdinode	*from)
 {
 	to->di_magic = cpu_to_be16(from->di_magic);
 	to->di_mode = cpu_to_be16(from->di_mode);
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 03f2a90..da66458 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
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
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index c860345..85d4732 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
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
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 7378fe1..e6ee832 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -588,7 +588,8 @@ xlog_print_trans_qoff(char **ptr, uint len)
 
 
 void
-xlog_print_trans_inode_core(xfs_icdinode_t *ip)
+xlog_print_trans_inode_core(
+	struct xfs_log_dinode	*ip)
 {
     printf(_("INODE CORE\n"));
     printf(_("magic 0x%hx mode 0%ho version %d format %d\n"),
@@ -652,7 +653,7 @@ xlog_print_trans_inode(
 	int		num_ops,
 	int		continued)
 {
-    xfs_icdinode_t	   dino;
+    struct xfs_log_dinode dino;
     xlog_op_header_t	   *op_head;
     xfs_inode_log_format_t dst_lbuf;
     xfs_inode_log_format_64_t src_lbuf; /* buffer of biggest one */
@@ -705,7 +706,7 @@ xlog_print_trans_inode(
     mode = dino.di_mode & S_IFMT;
     size = (int)dino.di_size;
     xlog_print_trans_inode_core(&dino);
-    *ptr += xfs_icdinode_size(dino.di_version);
+    *ptr += xfs_log_dinode_size(dino.di_version);
 
     if (*i == num_ops-1 && f->ilf_size == 3)  {
 	return 1;
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index ba26408..1bc18af 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -250,7 +250,7 @@ xlog_recover_print_dquot(
 
 STATIC void
 xlog_recover_print_inode_core(
-	xfs_icdinode_t		*di)
+	struct xfs_log_dinode	*di)
 {
 	printf(_("	CORE inode:\n"));
 	if (!print_inode)
@@ -259,8 +259,9 @@ xlog_recover_print_inode_core(
 	     "onlink:%d\n"),
 	       (di->di_magic>>8) & 0xff, di->di_magic & 0xff,
 	       di->di_mode, di->di_version, di->di_format, di->di_onlink);
-	printf(_("		uid:%d  gid:%d  nlink:%d projid:%u\n"),
-	       di->di_uid, di->di_gid, di->di_nlink, xfs_get_projid(di));
+	printf(_("		uid:%d  gid:%d  nlink:%d projid:0x%04x%04x\n"),
+	       di->di_uid, di->di_gid, di->di_nlink,
+	       di->di_projid_hi, di->di_projid_lo);
 	printf(_("		atime:%d  mtime:%d  ctime:%d\n"),
 	       di->di_atime.t_sec, di->di_mtime.t_sec, di->di_ctime.t_sec);
 	printf(_("		flushiter:%d\n"), di->di_flushiter);
@@ -293,9 +294,9 @@ xlog_recover_print_inode(
 	       f->ilf_dsize);
 
 	/* core inode comes 2nd */
-	ASSERT(item->ri_buf[1].i_len == xfs_icdinode_size(1) ||
-		item->ri_buf[1].i_len == xfs_icdinode_size(3));
-	xlog_recover_print_inode_core((xfs_icdinode_t *)
+	ASSERT(item->ri_buf[1].i_len == xfs_log_dinode_size(2) ||
+		item->ri_buf[1].i_len == xfs_log_dinode_size(3));
+	xlog_recover_print_inode_core((struct xfs_log_dinode *)
 				      item->ri_buf[1].i_addr);
 
 	hasdata = (f->ilf_fields & XFS_ILOG_DFORK) != 0;
diff --git a/repair/phase6.c b/repair/phase6.c
index eb36520..3aa109d 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -507,8 +507,8 @@ mk_rbmino(xfs_mount_t *mp)
 			error);
 	}
 
-	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 1;
-	memset(&ip->i_d, 0, xfs_icdinode_size(vers));
+	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 2;
+	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = S_IFREG;
@@ -767,7 +767,7 @@ mk_rsumino(xfs_mount_t *mp)
 	}
 
 	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 1;
-	memset(&ip->i_d, 0, xfs_icdinode_size(vers));
+	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = S_IFREG;
@@ -882,7 +882,7 @@ mk_root_dir(xfs_mount_t *mp)
 	 * take care of the core -- initialization from xfs_ialloc()
 	 */
 	vers = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 2;
-	memset(&ip->i_d, 0, xfs_icdinode_size(vers));
+	memset(&ip->i_d, 0, sizeof(ip->i_d));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
 	ip->i_d.di_mode = (__uint16_t) mode|S_IFDIR;
diff --git a/repair/phase7.c b/repair/phase7.c
index 640eaec..72a8ade 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -31,7 +31,7 @@
 /* dinoc is a pointer to the IN-CORE dinode core */
 static void
 set_nlinks(
-	xfs_icdinode_t		*dinoc,
+	struct xfs_icdinode	*dinoc,
 	xfs_ino_t		ino,
 	__uint32_t		nrefs,
 	int			*dirty)
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
