Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4627E7FA6
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 27B8B8F8035
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	CPo0quqHpasDlyX4 for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:45 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0483-00048R-JE
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0483-000214-Gs
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 48/49] xfs: Add read-only support for dirent filetype field
Date: Fri, 19 Jul 2013 16:25:19 +1000
Message-Id: <1374215120-7271-49-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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

Add support for the file type field in directory entries so that
readdir can return the type of the inode the dirent points to to
userspace without first having to read the inode off disk.

The encoding of the type field is a single byte that is added to the
end of the directory entry name length. For all intents and
purposes, it appends a "hidden" byte to the name field which
contains the type information. As the directory entry is already of
dynamic size, helpers are already required to access and decode the
direct entry structures.

Hence the relevent extraction and iteration helpers are updated to
understand the hidden byte.  Helpers for reading and writing the
filetype field from the directory entries are also added. Only the
read helpers are used by this patch.  It also adds all the code
necessary to read the type information out of the dirents on disk.

Further we add the superblock feature bit and helpers to indicate
that we understand the on-disk format change. This is not a
compatible change - existing kernels cannot read the new format
successfully - so an incompatible feature flag is added. We don't
yet allow filesystems to mount with this flag yet - that will be
added once write support is added.

Finally, the code to take the type from the VFS, convert it to an
XFS on-disk type and put it into the xfs_name structures passed
around is added, but the directory code does not use this field yet.
That will be in the next patch.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_da_btree.h     |   1 +
 fs/xfs/xfs_dir2.c         |   5 +-
 fs/xfs/xfs_dir2.h         |   4 +-
 fs/xfs/xfs_dir2_block.c   |  16 ++--
 fs/xfs/xfs_dir2_data.c    |  13 ++--
 fs/xfs/xfs_dir2_format.h  | 183 ++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_dir2_leaf.c    |   6 +-
 fs/xfs/xfs_dir2_node.c    |   8 +-
 fs/xfs/xfs_dir2_priv.h    |   9 +++
 fs/xfs/xfs_dir2_readdir.c |  69 ++++++++++++++---
 fs/xfs/xfs_dir2_sf.c      | 121 +++++++++++++++++-------------
 fs/xfs/xfs_iops.c         |  27 ++++---
 fs/xfs/xfs_sb.h           |  28 ++++---
 fs/xfs/xfs_types.h        |   1 +
 14 files changed, 365 insertions(+), 126 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index 6fb3371..8cdc77b 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -176,6 +176,7 @@ enum xfs_dacmp {
 typedef struct xfs_da_args {
 	const __uint8_t	*name;		/* string (maybe not NULL terminated) */
 	int		namelen;	/* length of string (maybe no NULL) */
+	__uint8_t	filetype;	/* filetype of inode for directories */
 	__uint8_t	*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
 	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index 841933c..f9825b1 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -37,7 +37,8 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 
-struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2};
+struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
+
 
 /*
  * ASCII case-insensitive (ie. A-Z) support for directories that was
@@ -386,6 +387,7 @@ xfs_dir_replace(
 	memset(&args, 0, sizeof(xfs_da_args_t));
 	args.name = name->name;
 	args.namelen = name->len;
+	args.filetype = name->type;
 	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.inumber = inum;
 	args.dp = dp;
@@ -433,6 +435,7 @@ xfs_dir_canenter(
 	memset(&args, 0, sizeof(xfs_da_args_t));
 	args.name = name->name;
 	args.namelen = name->len;
+	args.filetype = name->type;
 	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.dp = dp;
 	args.whichfork = XFS_DATA_FORK;
diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index 7fe2b8f..768ddad 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -68,8 +68,8 @@ extern int xfs_dir2_sf_to_block(struct xfs_da_args *args);
 extern xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *sfp);
 extern void xfs_dir2_sf_put_parent_ino(struct xfs_dir2_sf_hdr *sfp,
 		xfs_ino_t ino);
-extern xfs_ino_t xfs_dir2_sfe_get_ino(struct xfs_dir2_sf_hdr *sfp,
-		struct xfs_dir2_sf_entry *sfep);
+extern xfs_ino_t xfs_dir3_sfe_get_ino(struct xfs_mount *mp,
+		struct xfs_dir2_sf_hdr *sfp, struct xfs_dir2_sf_entry *sfep);
 extern void xfs_dir2_sfe_put_ino( struct xfs_dir2_sf_hdr *,
 		struct xfs_dir2_sf_entry *sfep, xfs_ino_t ino);
 
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index becd69f..1cd2f56 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -369,7 +369,7 @@ xfs_dir2_block_addname(
 	if (error)
 		return error;
 
-	len = xfs_dir2_data_entsize(args->namelen);
+	len = xfs_dir3_data_entsize(mp, args->namelen);
 
 	/*
 	 * Set up pointers to parts of the block.
@@ -549,7 +549,7 @@ xfs_dir2_block_addname(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, args->namelen);
-	tagp = xfs_dir2_data_entry_tag_p(dep);
+	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
@@ -799,7 +799,7 @@ xfs_dir2_block_removename(
 	needlog = needscan = 0;
 	xfs_dir2_data_make_free(tp, bp,
 		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
-		xfs_dir2_data_entsize(dep->namelen), &needlog, &needscan);
+		xfs_dir3_data_entsize(mp, dep->namelen), &needlog, &needscan);
 	/*
 	 * Fix up the block tail.
 	 */
@@ -1159,7 +1159,7 @@ xfs_dir2_sf_to_block(
 	dep->inumber = cpu_to_be64(dp->i_ino);
 	dep->namelen = 1;
 	dep->name[0] = '.';
-	tagp = xfs_dir2_data_entry_tag_p(dep);
+	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, bp, dep);
 	blp[0].hashval = cpu_to_be32(xfs_dir_hash_dot);
@@ -1172,7 +1172,7 @@ xfs_dir2_sf_to_block(
 	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
-	tagp = xfs_dir2_data_entry_tag_p(dep);
+	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, bp, dep);
 	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
@@ -1217,10 +1217,10 @@ xfs_dir2_sf_to_block(
 		 * Copy a real entry.
 		 */
 		dep = (xfs_dir2_data_entry_t *)((char *)hdr + newoffset);
-		dep->inumber = cpu_to_be64(xfs_dir2_sfe_get_ino(sfp, sfep));
+		dep->inumber = cpu_to_be64(xfs_dir3_sfe_get_ino(mp, sfp, sfep));
 		dep->namelen = sfep->namelen;
 		memcpy(dep->name, sfep->name, dep->namelen);
-		tagp = xfs_dir2_data_entry_tag_p(dep);
+		tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 		xfs_dir2_data_log_entry(tp, bp, dep);
 		name.name = sfep->name;
@@ -1233,7 +1233,7 @@ xfs_dir2_sf_to_block(
 		if (++i == sfp->count)
 			sfep = NULL;
 		else
-			sfep = xfs_dir2_sf_nextentry(sfp, sfep);
+			sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
 	}
 	/* Done with the temporary buffer */
 	kmem_free(sfp);
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 98c23fa..1b59e43 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -147,7 +147,7 @@ __xfs_dir3_data_check(
 		XFS_WANT_CORRUPTED_RETURN(
 			!xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)));
 		XFS_WANT_CORRUPTED_RETURN(
-			be16_to_cpu(*xfs_dir2_data_entry_tag_p(dep)) ==
+			be16_to_cpu(*xfs_dir3_data_entry_tag_p(mp, dep)) ==
 					       (char *)dep - (char *)hdr);
 		count++;
 		lastfree = 0;
@@ -166,7 +166,7 @@ __xfs_dir3_data_check(
 			}
 			XFS_WANT_CORRUPTED_RETURN(i < be32_to_cpu(btp->count));
 		}
-		p += xfs_dir2_data_entsize(dep->namelen);
+		p += xfs_dir3_data_entsize(mp, dep->namelen);
 	}
 	/*
 	 * Need to have seen all the entries and all the bestfree slots.
@@ -536,8 +536,8 @@ xfs_dir2_data_freescan(
 		else {
 			dep = (xfs_dir2_data_entry_t *)p;
 			ASSERT((char *)dep - (char *)hdr ==
-			       be16_to_cpu(*xfs_dir2_data_entry_tag_p(dep)));
-			p += xfs_dir2_data_entsize(dep->namelen);
+			       be16_to_cpu(*xfs_dir3_data_entry_tag_p(mp, dep)));
+			p += xfs_dir3_data_entsize(mp, dep->namelen);
 		}
 	}
 }
@@ -627,7 +627,8 @@ xfs_dir2_data_log_entry(
 	struct xfs_buf		*bp,
 	xfs_dir2_data_entry_t	*dep)		/* data entry pointer */
 {
-	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
+	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
+	struct xfs_mount	*mp = tp->t_mountp;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
@@ -635,7 +636,7 @@ xfs_dir2_data_log_entry(
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
 	xfs_trans_log_buf(tp, bp, (uint)((char *)dep - (char *)hdr),
-		(uint)((char *)(xfs_dir2_data_entry_tag_p(dep) + 1) -
+		(uint)((char *)(xfs_dir3_data_entry_tag_p(mp, dep) + 1) -
 		       (char *)hdr - 1));
 }
 
diff --git a/fs/xfs/xfs_dir2_format.h b/fs/xfs/xfs_dir2_format.h
index 2095e17..a0961a6 100644
--- a/fs/xfs/xfs_dir2_format.h
+++ b/fs/xfs/xfs_dir2_format.h
@@ -69,6 +69,23 @@
 #define	XFS_DIR3_FREE_MAGIC	0x58444633	/* XDF3: free index blocks */
 
 /*
+ * Dirents in version 3 directories have a file type field. Additions to this
+ * list are an on-disk format change, requiring feature bits. Valid values
+ * are as follows:
+ */
+#define XFS_DIR3_FT_UNKNOWN		0
+#define XFS_DIR3_FT_REG_FILE		1
+#define XFS_DIR3_FT_DIR			2
+#define XFS_DIR3_FT_CHRDEV		3
+#define XFS_DIR3_FT_BLKDEV		4
+#define XFS_DIR3_FT_FIFO		5
+#define XFS_DIR3_FT_SOCK		6
+#define XFS_DIR3_FT_SYMLINK		7
+#define XFS_DIR3_FT_WHT			8
+
+#define XFS_DIR3_FT_MAX			9
+
+/*
  * Byte offset in data block and shortform entry.
  */
 typedef	__uint16_t	xfs_dir2_data_off_t;
@@ -138,6 +155,9 @@ typedef struct xfs_dir2_sf_entry {
 	xfs_dir2_sf_off_t	offset;		/* saved offset */
 	__u8			name[];		/* name, variable size */
 	/*
+	 * A single byte containing the file type field follows the inode
+	 * number for version 3 directory entries.
+	 *
 	 * A xfs_dir2_ino8_t or xfs_dir2_ino4_t follows here, at a
 	 * variable offset after the name.
 	 */
@@ -162,16 +182,6 @@ xfs_dir2_sf_put_offset(xfs_dir2_sf_entry_t *sfep, xfs_dir2_data_aoff_t off)
 	put_unaligned_be16(off, &sfep->offset.i);
 }
 
-static inline int
-xfs_dir2_sf_entsize(struct xfs_dir2_sf_hdr *hdr, int len)
-{
-	return sizeof(struct xfs_dir2_sf_entry) +	/* namelen + offset */
-		len +					/* name */
-		(hdr->i8count ?				/* ino */
-		 sizeof(xfs_dir2_ino8_t) :
-		 sizeof(xfs_dir2_ino4_t));
-}
-
 static inline struct xfs_dir2_sf_entry *
 xfs_dir2_sf_firstentry(struct xfs_dir2_sf_hdr *hdr)
 {
@@ -179,14 +189,78 @@ xfs_dir2_sf_firstentry(struct xfs_dir2_sf_hdr *hdr)
 		((char *)hdr + xfs_dir2_sf_hdr_size(hdr->i8count));
 }
 
+static inline int
+xfs_dir3_sf_entsize(
+	struct xfs_mount	*mp,
+	struct xfs_dir2_sf_hdr	*hdr,
+	int			len)
+{
+	int count = sizeof(struct xfs_dir2_sf_entry); 	/* namelen + offset */
+
+	count += len;					/* name */
+	count += hdr->i8count ? sizeof(xfs_dir2_ino8_t) :
+				sizeof(xfs_dir2_ino4_t); /* ino # */
+	if (xfs_sb_version_hasftype(&mp->m_sb))
+		count += sizeof(__uint8_t);		/* file type */
+	return count;
+}
+
 static inline struct xfs_dir2_sf_entry *
-xfs_dir2_sf_nextentry(struct xfs_dir2_sf_hdr *hdr,
-		struct xfs_dir2_sf_entry *sfep)
+xfs_dir3_sf_nextentry(
+	struct xfs_mount	*mp,
+	struct xfs_dir2_sf_hdr	*hdr,
+	struct xfs_dir2_sf_entry *sfep)
 {
 	return (struct xfs_dir2_sf_entry *)
-		((char *)sfep + xfs_dir2_sf_entsize(hdr, sfep->namelen));
+		((char *)sfep + xfs_dir3_sf_entsize(mp, hdr, sfep->namelen));
 }
 
+/*
+ * in dir3 shortform directories, the file type field is stored at a variable
+ * offset after the inode number. Because it's only a single byte, endian
+ * conversion is not necessary.
+ */
+static inline __uint8_t *
+xfs_dir3_sfe_ftypep(
+	struct xfs_dir2_sf_hdr	*hdr,
+	struct xfs_dir2_sf_entry *sfep)
+{
+	return (__uint8_t *)&sfep->name[sfep->namelen];
+}
+
+static inline __uint8_t
+xfs_dir3_sfe_get_ftype(
+	struct xfs_mount	*mp,
+	struct xfs_dir2_sf_hdr	*hdr,
+	struct xfs_dir2_sf_entry *sfep)
+{
+	__uint8_t	*ftp;
+
+	if (!xfs_sb_version_hasftype(&mp->m_sb))
+		return XFS_DIR3_FT_UNKNOWN;
+
+	ftp = xfs_dir3_sfe_ftypep(hdr, sfep);
+	if (*ftp >= XFS_DIR3_FT_MAX)
+		return XFS_DIR3_FT_UNKNOWN;
+	return *ftp;
+}
+
+static inline void
+xfs_dir3_sfe_put_ftype(
+	struct xfs_mount	*mp,
+	struct xfs_dir2_sf_hdr	*hdr,
+	struct xfs_dir2_sf_entry *sfep,
+	__uint8_t		ftype)
+{
+	__uint8_t	*ftp;
+
+	ASSERT(ftype < XFS_DIR3_FT_MAX);
+
+	if (!xfs_sb_version_hasftype(&mp->m_sb))
+		return;
+	ftp = xfs_dir3_sfe_ftypep(hdr, sfep);
+	*ftp = ftype;
+}
 
 /*
  * Data block structures.
@@ -286,12 +360,18 @@ xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
  * Active entry in a data block.
  *
  * Aligned to 8 bytes.  After the variable length name field there is a
- * 2 byte tag field, which can be accessed using xfs_dir2_data_entry_tag_p.
+ * 2 byte tag field, which can be accessed using xfs_dir3_data_entry_tag_p.
+ *
+ * For dir3 structures, there is file type field between the name and the tag.
+ * This can only be manipulated by helper functions. It is packed hard against
+ * the end of the name so any padding for rounding is between the file type and
+ * the tag.
  */
 typedef struct xfs_dir2_data_entry {
 	__be64			inumber;	/* inode number */
 	__u8			namelen;	/* name length */
 	__u8			name[];		/* name bytes, no null */
+     /* __u8			filetype; */	/* type of inode we point to */
      /*	__be16                  tag; */		/* starting offset of us */
 } xfs_dir2_data_entry_t;
 
@@ -311,20 +391,67 @@ typedef struct xfs_dir2_data_unused {
 /*
  * Size of a data entry.
  */
-static inline int xfs_dir2_data_entsize(int n)
+static inline int
+__xfs_dir3_data_entsize(
+	bool	ftype,
+	int	n)
 {
-	return (int)roundup(offsetof(struct xfs_dir2_data_entry, name[0]) + n +
-		 (uint)sizeof(xfs_dir2_data_off_t), XFS_DIR2_DATA_ALIGN);
+	int	size = offsetof(struct xfs_dir2_data_entry, name[0]);
+
+	size += n;
+	size += sizeof(xfs_dir2_data_off_t);
+	if (ftype)
+		size += sizeof(__uint8_t);
+	return roundup(size, XFS_DIR2_DATA_ALIGN);
+}
+static inline int
+xfs_dir3_data_entsize(
+	struct xfs_mount	*mp,
+	int			n)
+{
+	bool ftype = xfs_sb_version_hasftype(&mp->m_sb) ? true : false;
+	return __xfs_dir3_data_entsize(ftype, n);
+}
+
+static inline __uint8_t
+xfs_dir3_dirent_get_ftype(
+	struct xfs_mount	*mp,
+	struct xfs_dir2_data_entry *dep)
+{
+	if (xfs_sb_version_hasftype(&mp->m_sb)) {
+		__uint8_t	type = dep->name[dep->namelen];
+
+		ASSERT(type < XFS_DIR3_FT_MAX);
+		if (type < XFS_DIR3_FT_MAX)
+			return type;
+
+	}
+	return XFS_DIR3_FT_UNKNOWN;
+}
+
+static inline void
+xfs_dir3_dirent_put_ftype(
+	struct xfs_mount	*mp,
+	struct xfs_dir2_data_entry *dep,
+	__uint8_t		type)
+{
+	ASSERT(type < XFS_DIR3_FT_MAX);
+	ASSERT(dep->namelen != 0);
+
+	if (xfs_sb_version_hasftype(&mp->m_sb))
+		dep->name[dep->namelen] = type;
 }
 
 /*
  * Pointer to an entry's tag word.
  */
 static inline __be16 *
-xfs_dir2_data_entry_tag_p(struct xfs_dir2_data_entry *dep)
+xfs_dir3_data_entry_tag_p(
+	struct xfs_mount	*mp,
+	struct xfs_dir2_data_entry *dep)
 {
 	return (__be16 *)((char *)dep +
-		xfs_dir2_data_entsize(dep->namelen) - sizeof(__be16));
+		xfs_dir3_data_entsize(mp, dep->namelen) - sizeof(__be16));
 }
 
 /*
@@ -375,13 +502,17 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
  * data block header because the sfe embeds the block offset of the entry into
  * it so that it doesn't change when format conversion occurs. Bad Things Happen
  * if we don't follow this rule.
+ *
+ * XXX: there is scope for significant optimisation of the logic here. Right
+ * now we are checking for "dir3 format" over and over again. Ideally we should
+ * only do it once for each operation.
  */
 #define	XFS_DIR3_DATA_DOT_OFFSET(mp)	\
 	xfs_dir3_data_hdr_size(xfs_sb_version_hascrc(&(mp)->m_sb))
 #define	XFS_DIR3_DATA_DOTDOT_OFFSET(mp)	\
-	(XFS_DIR3_DATA_DOT_OFFSET(mp) + xfs_dir2_data_entsize(1))
+	(XFS_DIR3_DATA_DOT_OFFSET(mp) + xfs_dir3_data_entsize(mp, 1))
 #define	XFS_DIR3_DATA_FIRST_OFFSET(mp)		\
-	(XFS_DIR3_DATA_DOTDOT_OFFSET(mp) + xfs_dir2_data_entsize(2))
+	(XFS_DIR3_DATA_DOTDOT_OFFSET(mp) + xfs_dir3_data_entsize(mp, 2))
 
 static inline xfs_dir2_data_aoff_t
 xfs_dir3_data_dot_offset(struct xfs_dir2_data_hdr *hdr)
@@ -392,13 +523,19 @@ xfs_dir3_data_dot_offset(struct xfs_dir2_data_hdr *hdr)
 static inline xfs_dir2_data_aoff_t
 xfs_dir3_data_dotdot_offset(struct xfs_dir2_data_hdr *hdr)
 {
-	return xfs_dir3_data_dot_offset(hdr) + xfs_dir2_data_entsize(1);
+	bool dir3 = hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
+		    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
+	return xfs_dir3_data_dot_offset(hdr) +
+		__xfs_dir3_data_entsize(dir3, 1);
 }
 
 static inline xfs_dir2_data_aoff_t
 xfs_dir3_data_first_offset(struct xfs_dir2_data_hdr *hdr)
 {
-	return xfs_dir3_data_dotdot_offset(hdr) + xfs_dir2_data_entsize(2);
+	bool dir3 = hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
+		    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
+	return xfs_dir3_data_dotdot_offset(hdr) +
+		__xfs_dir3_data_entsize(dir3, 2);
 }
 
 /*
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 591eaf2..887b1bd 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -696,7 +696,7 @@ xfs_dir2_leaf_addname(
 	ents = xfs_dir3_leaf_ents_p(leaf);
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
-	length = xfs_dir2_data_entsize(args->namelen);
+	length = xfs_dir3_data_entsize(mp, args->namelen);
 
 	/*
 	 * See if there are any entries with the same hash value
@@ -897,7 +897,7 @@ xfs_dir2_leaf_addname(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
-	tagp = xfs_dir2_data_entry_tag_p(dep);
+	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
@@ -1427,7 +1427,7 @@ xfs_dir2_leaf_removename(
 	 */
 	xfs_dir2_data_make_free(tp, dbp,
 		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
-		xfs_dir2_data_entsize(dep->namelen), &needlog, &needscan);
+		xfs_dir3_data_entsize(mp, dep->namelen), &needlog, &needscan);
 	/*
 	 * We just mark the leaf entry stale by putting a null in it.
 	 */
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 18e287d..49f1e9e 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -605,7 +605,7 @@ xfs_dir2_leafn_lookup_for_addname(
 		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
 		       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
 	}
-	length = xfs_dir2_data_entsize(args->namelen);
+	length = xfs_dir3_data_entsize(mp, args->namelen);
 	/*
 	 * Loop over leaf entries with the right hash value.
 	 */
@@ -1259,7 +1259,7 @@ xfs_dir2_leafn_remove(
 	longest = be16_to_cpu(bf[0].length);
 	needlog = needscan = 0;
 	xfs_dir2_data_make_free(tp, dbp, off,
-		xfs_dir2_data_entsize(dep->namelen), &needlog, &needscan);
+		xfs_dir3_data_entsize(mp, dep->namelen), &needlog, &needscan);
 	/*
 	 * Rescan the data block freespaces for bestfree.
 	 * Log the data block header if needed.
@@ -1711,7 +1711,7 @@ xfs_dir2_node_addname_int(
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
-	length = xfs_dir2_data_entsize(args->namelen);
+	length = xfs_dir3_data_entsize(mp, args->namelen);
 	/*
 	 * If we came in with a freespace block that means that lookup
 	 * found an entry with our hash value.  This is the freespace
@@ -2007,7 +2007,7 @@ xfs_dir2_node_addname_int(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
-	tagp = xfs_dir2_data_entry_tag_p(dep);
+	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, dbp, dep);
 	/*
diff --git a/fs/xfs/xfs_dir2_priv.h b/fs/xfs/xfs_dir2_priv.h
index 6d2a99c2..1bad84c 100644
--- a/fs/xfs/xfs_dir2_priv.h
+++ b/fs/xfs/xfs_dir2_priv.h
@@ -18,6 +18,8 @@
 #ifndef __XFS_DIR2_PRIV_H__
 #define __XFS_DIR2_PRIV_H__
 
+struct dir_context;
+
 /* xfs_dir2.c */
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
@@ -25,6 +27,13 @@ extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
 extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
 				const unsigned char *name, int len);
 
+#define S_SHIFT 12
+extern const unsigned char xfs_mode_to_ftype[];
+
+extern unsigned char xfs_dir3_get_dtype(struct xfs_mount *mp,
+					__uint8_t filetype);
+
+
 /* xfs_dir2_block.c */
 extern int xfs_dir3_block_read(struct xfs_trans *tp, struct xfs_inode *dp,
 			       struct xfs_buf **bpp);
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index e6211a7..6b28889 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -36,6 +36,44 @@
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
 
+/*
+ * Directory file type support functions
+ */
+static unsigned char xfs_dir3_filetype_table[] = {
+	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK,
+	DT_FIFO, DT_SOCK, DT_LNK, DT_WHT,
+};
+
+unsigned char
+xfs_dir3_get_dtype(
+	struct xfs_mount	*mp,
+	__uint8_t		filetype)
+{
+	if (!xfs_sb_version_hasftype(&mp->m_sb))
+		return DT_UNKNOWN;
+
+	if (filetype >= XFS_DIR3_FT_MAX)
+		return DT_UNKNOWN;
+
+	return xfs_dir3_filetype_table[filetype];
+}
+/*
+ * @mode, if set, indicates that the type field needs to be set up.
+ * This uses the transformation from file mode to DT_* as defined in linux/fs.h
+ * for file type specification. This will be propagated into the directory
+ * structure if appropriate for the given operation and filesystem config.
+ */
+const unsigned char xfs_mode_to_ftype[S_IFMT >> S_SHIFT] = {
+	[0]			= XFS_DIR3_FT_UNKNOWN,
+	[S_IFREG >> S_SHIFT]    = XFS_DIR3_FT_REG_FILE,
+	[S_IFDIR >> S_SHIFT]    = XFS_DIR3_FT_DIR,
+	[S_IFCHR >> S_SHIFT]    = XFS_DIR3_FT_CHRDEV,
+	[S_IFBLK >> S_SHIFT]    = XFS_DIR3_FT_BLKDEV,
+	[S_IFIFO >> S_SHIFT]    = XFS_DIR3_FT_FIFO,
+	[S_IFSOCK >> S_SHIFT]   = XFS_DIR3_FT_SOCK,
+	[S_IFLNK >> S_SHIFT]    = XFS_DIR3_FT_SYMLINK,
+};
+
 STATIC int
 xfs_dir2_sf_getdents(
 	xfs_inode_t		*dp,		/* incore directory inode */
@@ -109,20 +147,23 @@ xfs_dir2_sf_getdents(
 	 */
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	for (i = 0; i < sfp->count; i++) {
+		__uint8_t filetype;
+
 		off = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 				xfs_dir2_sf_get_offset(sfep));
 
 		if (ctx->pos > off) {
-			sfep = xfs_dir2_sf_nextentry(sfp, sfep);
+			sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
 			continue;
 		}
 
-		ino = xfs_dir2_sfe_get_ino(sfp, sfep);
+		ino = xfs_dir3_sfe_get_ino(mp, sfp, sfep);
+		filetype = xfs_dir3_sfe_get_ftype(mp, sfp, sfep);
 		ctx->pos = off & 0x7fffffff;
-		if (!dir_emit(ctx, (char *)sfep->name, sfep->namelen,
-			    ino, DT_UNKNOWN))
+		if (!dir_emit(ctx, (char *)sfep->name, sfep->namelen, ino,
+			    xfs_dir3_get_dtype(mp, filetype)))
 			return 0;
-		sfep = xfs_dir2_sf_nextentry(sfp, sfep);
+		sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
 	}
 
 	ctx->pos = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0) &
@@ -180,6 +221,8 @@ xfs_dir2_block_getdents(
 	 * Each object is a real entry (dep) or an unused one (dup).
 	 */
 	while (ptr < endptr) {
+		__uint8_t filetype;
+
 		dup = (xfs_dir2_data_unused_t *)ptr;
 		/*
 		 * Unused, skip it.
@@ -194,7 +237,7 @@ xfs_dir2_block_getdents(
 		/*
 		 * Bump pointer for the next iteration.
 		 */
-		ptr += xfs_dir2_data_entsize(dep->namelen);
+		ptr += xfs_dir3_data_entsize(mp, dep->namelen);
 		/*
 		 * The entry is before the desired starting point, skip it.
 		 */
@@ -205,11 +248,13 @@ xfs_dir2_block_getdents(
 					    (char *)dep - (char *)hdr);
 
 		ctx->pos = cook & 0x7fffffff;
+		filetype = xfs_dir3_dirent_get_ftype(mp, dep);
 		/*
 		 * If it didn't fit, set the final offset to here & return.
 		 */
 		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
-			    be64_to_cpu(dep->inumber), DT_UNKNOWN)) {
+			    be64_to_cpu(dep->inumber),
+			    xfs_dir3_get_dtype(mp, filetype))) {
 			xfs_trans_brelse(NULL, bp);
 			return 0;
 		}
@@ -500,6 +545,8 @@ xfs_dir2_leaf_getdents(
 	 * Get more blocks and readahead as necessary.
 	 */
 	while (curoff < XFS_DIR2_LEAF_OFFSET) {
+		__uint8_t filetype;
+
 		/*
 		 * If we have no buffer, or we're off the end of the
 		 * current buffer, need to get another one.
@@ -554,7 +601,7 @@ xfs_dir2_leaf_getdents(
 					}
 					dep = (xfs_dir2_data_entry_t *)ptr;
 					length =
-					   xfs_dir2_data_entsize(dep->namelen);
+					   xfs_dir3_data_entsize(mp, dep->namelen);
 					ptr += length;
 				}
 				/*
@@ -585,11 +632,13 @@ xfs_dir2_leaf_getdents(
 		}
 
 		dep = (xfs_dir2_data_entry_t *)ptr;
-		length = xfs_dir2_data_entsize(dep->namelen);
+		length = xfs_dir3_data_entsize(mp, dep->namelen);
+		filetype = xfs_dir3_dirent_get_ftype(mp, dep);
 
 		ctx->pos = xfs_dir2_byte_to_dataptr(mp, curoff) & 0x7fffffff;
 		if (!dir_emit(ctx, (char *)dep->name, dep->namelen,
-			    be64_to_cpu(dep->inumber), DT_UNKNOWN))
+			    be64_to_cpu(dep->inumber),
+			    xfs_dir3_get_dtype(mp, filetype)))
 			break;
 
 		/*
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 65b65c5..bd14e1a 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -105,31 +105,38 @@ xfs_dir2_sf_put_parent_ino(
 
 /*
  * In short-form directory entries the inode numbers are stored at variable
- * offset behind the entry name.  The inode numbers may only be accessed
- * through the helpers below.
+ * offset behind the entry name. If the entry stores a filetype value, then it
+ * sits between the name and the inode number. Hence the inode numbers may only
+ * be accessed through the helpers below.
  */
 static xfs_dir2_inou_t *
-xfs_dir2_sfe_inop(
+xfs_dir3_sfe_inop(
+	struct xfs_mount	*mp,
 	struct xfs_dir2_sf_entry *sfep)
 {
-	return (xfs_dir2_inou_t *)&sfep->name[sfep->namelen];
+	__uint8_t	*ptr = &sfep->name[sfep->namelen];
+	if (xfs_sb_version_hasftype(&mp->m_sb))
+		ptr++;
+	return (xfs_dir2_inou_t *)ptr;
 }
 
 xfs_ino_t
-xfs_dir2_sfe_get_ino(
+xfs_dir3_sfe_get_ino(
+	struct xfs_mount	*mp,
 	struct xfs_dir2_sf_hdr	*hdr,
 	struct xfs_dir2_sf_entry *sfep)
 {
-	return xfs_dir2_sf_get_ino(hdr, xfs_dir2_sfe_inop(sfep));
+	return xfs_dir2_sf_get_ino(hdr, xfs_dir3_sfe_inop(mp, sfep));
 }
 
 void
-xfs_dir2_sfe_put_ino(
+xfs_dir3_sfe_put_ino(
+	struct xfs_mount	*mp,
 	struct xfs_dir2_sf_hdr	*hdr,
 	struct xfs_dir2_sf_entry *sfep,
 	xfs_ino_t		ino)
 {
-	xfs_dir2_sf_put_ino(hdr, xfs_dir2_sfe_inop(sfep), ino);
+	xfs_dir2_sf_put_ino(hdr, xfs_dir3_sfe_inop(mp, sfep), ino);
 }
 
 /*
@@ -157,9 +164,16 @@ xfs_dir2_block_sfsize(
 	int			namelen;	/* total name bytes */
 	xfs_ino_t		parent = 0;	/* parent inode number */
 	int			size=0;		/* total computed size */
+	int			has_ftype;
 
 	mp = dp->i_mount;
 
+	/*
+	 * if there is a filetype field, add the extra byte to the namelen
+	 * for each entry that we see.
+	 */
+	has_ftype = xfs_sb_version_hasftype(&mp->m_sb) ? 1 : 0;
+
 	count = i8count = namelen = 0;
 	btp = xfs_dir2_block_tail_p(mp, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
@@ -188,9 +202,10 @@ xfs_dir2_block_sfsize(
 		if (!isdot)
 			i8count += be64_to_cpu(dep->inumber) > XFS_DIR2_MAX_SHORT_INUM;
 #endif
+		/* take into account the file type field */
 		if (!isdot && !isdotdot) {
 			count++;
-			namelen += dep->namelen;
+			namelen += dep->namelen + has_ftype;
 		} else if (isdotdot)
 			parent = be64_to_cpu(dep->inumber);
 		/*
@@ -316,12 +331,12 @@ xfs_dir2_block_to_sf(
 				(xfs_dir2_data_aoff_t)
 				((char *)dep - (char *)hdr));
 			memcpy(sfep->name, dep->name, dep->namelen);
-			xfs_dir2_sfe_put_ino(sfp, sfep,
+			xfs_dir3_sfe_put_ino(mp, sfp, sfep,
 					     be64_to_cpu(dep->inumber));
 
-			sfep = xfs_dir2_sf_nextentry(sfp, sfep);
+			sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
 		}
-		ptr += xfs_dir2_data_entsize(dep->namelen);
+		ptr += xfs_dir3_data_entsize(mp, dep->namelen);
 	}
 	ASSERT((char *)sfep - (char *)sfp == size);
 	xfs_dir2_sf_check(args);
@@ -372,7 +387,7 @@ xfs_dir2_sf_addname(
 	/*
 	 * Compute entry (and change in) size.
 	 */
-	add_entsize = xfs_dir2_sf_entsize(sfp, args->namelen);
+	add_entsize = xfs_dir3_sf_entsize(dp->i_mount, sfp, args->namelen);
 	incr_isize = add_entsize;
 	objchange = 0;
 #if XFS_BIG_INUMS
@@ -466,8 +481,9 @@ xfs_dir2_sf_addname_easy(
 	/*
 	 * Grow the in-inode space.
 	 */
-	xfs_idata_realloc(dp, xfs_dir2_sf_entsize(sfp, args->namelen),
-		XFS_DATA_FORK);
+	xfs_idata_realloc(dp,
+			  xfs_dir3_sf_entsize(dp->i_mount, sfp, args->namelen),
+			  XFS_DATA_FORK);
 	/*
 	 * Need to set up again due to realloc of the inode data.
 	 */
@@ -479,7 +495,7 @@ xfs_dir2_sf_addname_easy(
 	sfep->namelen = args->namelen;
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
-	xfs_dir2_sfe_put_ino(sfp, sfep, args->inumber);
+	xfs_dir3_sfe_put_ino(dp->i_mount, sfp, sfep, args->inumber);
 	/*
 	 * Update the header and inode.
 	 */
@@ -519,11 +535,13 @@ xfs_dir2_sf_addname_hard(
 	xfs_dir2_sf_hdr_t	*oldsfp;	/* original shortform dir */
 	xfs_dir2_sf_entry_t	*sfep;		/* entry in new dir */
 	xfs_dir2_sf_hdr_t	*sfp;		/* new shortform dir */
+	struct xfs_mount	*mp;
 
 	/*
 	 * Copy the old directory to the stack buffer.
 	 */
 	dp = args->dp;
+	mp = dp->i_mount;
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	old_isize = (int)dp->i_d.di_size;
@@ -535,13 +553,13 @@ xfs_dir2_sf_addname_hard(
 	 * to insert the new entry.
 	 * If it's going to end up at the end then oldsfep will point there.
 	 */
-	for (offset = XFS_DIR3_DATA_FIRST_OFFSET(dp->i_mount),
+	for (offset = XFS_DIR3_DATA_FIRST_OFFSET(mp),
 	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
-	      add_datasize = xfs_dir2_data_entsize(args->namelen),
+	      add_datasize = xfs_dir3_data_entsize(mp, args->namelen),
 	      eof = (char *)oldsfep == &buf[old_isize];
 	     !eof;
-	     offset = new_offset + xfs_dir2_data_entsize(oldsfep->namelen),
-	      oldsfep = xfs_dir2_sf_nextentry(oldsfp, oldsfep),
+	     offset = new_offset + xfs_dir3_data_entsize(mp, oldsfep->namelen),
+	      oldsfep = xfs_dir3_sf_nextentry(mp, oldsfp, oldsfep),
 	      eof = (char *)oldsfep == &buf[old_isize]) {
 		new_offset = xfs_dir2_sf_get_offset(oldsfep);
 		if (offset + add_datasize <= new_offset)
@@ -570,7 +588,7 @@ xfs_dir2_sf_addname_hard(
 	sfep->namelen = args->namelen;
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
-	xfs_dir2_sfe_put_ino(sfp, sfep, args->inumber);
+	xfs_dir3_sfe_put_ino(mp, sfp, sfep, args->inumber);
 	sfp->count++;
 #if XFS_BIG_INUMS
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
@@ -580,7 +598,7 @@ xfs_dir2_sf_addname_hard(
 	 * If there's more left to copy, do that.
 	 */
 	if (!eof) {
-		sfep = xfs_dir2_sf_nextentry(sfp, sfep);
+		sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
 		memcpy(sfep, oldsfep, old_isize - nbytes);
 	}
 	kmem_free(buf);
@@ -616,7 +634,7 @@ xfs_dir2_sf_addname_pick(
 	mp = dp->i_mount;
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	size = xfs_dir2_data_entsize(args->namelen);
+	size = xfs_dir3_data_entsize(mp, args->namelen);
 	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	holefit = 0;
@@ -629,8 +647,8 @@ xfs_dir2_sf_addname_pick(
 		if (!holefit)
 			holefit = offset + size <= xfs_dir2_sf_get_offset(sfep);
 		offset = xfs_dir2_sf_get_offset(sfep) +
-			 xfs_dir2_data_entsize(sfep->namelen);
-		sfep = xfs_dir2_sf_nextentry(sfp, sfep);
+			 xfs_dir3_data_entsize(mp, sfep->namelen);
+		sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
 	}
 	/*
 	 * Calculate data bytes used excluding the new entry, if this
@@ -684,31 +702,34 @@ xfs_dir2_sf_check(
 	int			offset;		/* data offset */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform dir entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
+	struct xfs_mount	*mp;
 
 	dp = args->dp;
+	mp = dp->i_mount;
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	offset = XFS_DIR3_DATA_FIRST_OFFSET(dp->i_mount);
+	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
 	ino = xfs_dir2_sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 	     i < sfp->count;
-	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
+	     i++, sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep)) {
 		ASSERT(xfs_dir2_sf_get_offset(sfep) >= offset);
-		ino = xfs_dir2_sfe_get_ino(sfp, sfep);
+		ino = xfs_dir3_sfe_get_ino(mp, sfp, sfep);
 		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
 		offset =
 			xfs_dir2_sf_get_offset(sfep) +
-			xfs_dir2_data_entsize(sfep->namelen);
+			xfs_dir3_data_entsize(mp, sfep->namelen);
+		ASSERT(xfs_dir3_sfe_get_ftype(mp, sfp, sfep) <
+							XFS_DIR3_FT_MAX);
 	}
 	ASSERT(i8count == sfp->i8count);
 	ASSERT(XFS_BIG_INUMS || i8count == 0);
 	ASSERT((char *)sfep - (char *)sfp == dp->i_d.di_size);
 	ASSERT(offset +
 	       (sfp->count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
-	       (uint)sizeof(xfs_dir2_block_tail_t) <=
-	       dp->i_mount->m_dirblksize);
+	       (uint)sizeof(xfs_dir2_block_tail_t) <= mp->m_dirblksize);
 }
 #endif	/* DEBUG */
 
@@ -820,7 +841,7 @@ xfs_dir2_sf_lookup(
 	 */
 	ci_sfep = NULL;
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->count;
-				i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
+	     i++, sfep = xfs_dir3_sf_nextentry(dp->i_mount, sfp, sfep)) {
 		/*
 		 * Compare name and if it's an exact match, return the inode
 		 * number. If it's the first case-insensitive match, store the
@@ -830,7 +851,8 @@ xfs_dir2_sf_lookup(
 								sfep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
-			args->inumber = xfs_dir2_sfe_get_ino(sfp, sfep);
+			args->inumber = xfs_dir3_sfe_get_ino(dp->i_mount,
+							     sfp, sfep);
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
 			ci_sfep = sfep;
@@ -886,10 +908,10 @@ xfs_dir2_sf_removename(
 	 * Find the one we're deleting.
 	 */
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->count;
-				i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
+	     i++, sfep = xfs_dir3_sf_nextentry(dp->i_mount, sfp, sfep)) {
 		if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
-			ASSERT(xfs_dir2_sfe_get_ino(sfp, sfep) ==
+			ASSERT(xfs_dir3_sfe_get_ino(dp->i_mount, sfp, sfep) ==
 			       args->inumber);
 			break;
 		}
@@ -903,7 +925,7 @@ xfs_dir2_sf_removename(
 	 * Calculate sizes.
 	 */
 	byteoff = (int)((char *)sfep - (char *)sfp);
-	entsize = xfs_dir2_sf_entsize(sfp, args->namelen);
+	entsize = xfs_dir3_sf_entsize(dp->i_mount, sfp, args->namelen);
 	newsize = oldsize - entsize;
 	/*
 	 * Copy the part if any after the removed entry, sliding it down.
@@ -1019,16 +1041,17 @@ xfs_dir2_sf_replace(
 	 * Normal entry, look for the name.
 	 */
 	else {
-		for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
-				i < sfp->count;
-				i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
+		for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->count;
+		     i++, sfep = xfs_dir3_sf_nextentry(dp->i_mount, sfp, sfep)) {
 			if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
 #if XFS_BIG_INUMS || defined(DEBUG)
-				ino = xfs_dir2_sfe_get_ino(sfp, sfep);
+				ino = xfs_dir3_sfe_get_ino(dp->i_mount,
+							   sfp, sfep);
 				ASSERT(args->inumber != ino);
 #endif
-				xfs_dir2_sfe_put_ino(sfp, sfep, args->inumber);
+				xfs_dir3_sfe_put_ino(dp->i_mount, sfp, sfep,
+						     args->inumber);
 				break;
 			}
 		}
@@ -1136,13 +1159,13 @@ xfs_dir2_sf_toino4(
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
 		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
 	     i < sfp->count;
-	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep),
-		  oldsfep = xfs_dir2_sf_nextentry(oldsfp, oldsfep)) {
+	     i++, sfep = xfs_dir3_sf_nextentry(dp->i_mount, sfp, sfep),
+		  oldsfep = xfs_dir3_sf_nextentry(dp->i_mount, oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
 		sfep->offset = oldsfep->offset;
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
-		xfs_dir2_sfe_put_ino(sfp, sfep,
-			xfs_dir2_sfe_get_ino(oldsfp, oldsfep));
+		xfs_dir3_sfe_put_ino(dp->i_mount, sfp, sfep,
+			xfs_dir3_sfe_get_ino(dp->i_mount, oldsfp, oldsfep));
 	}
 	/*
 	 * Clean up the inode.
@@ -1211,13 +1234,13 @@ xfs_dir2_sf_toino8(
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
 		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
 	     i < sfp->count;
-	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep),
-		  oldsfep = xfs_dir2_sf_nextentry(oldsfp, oldsfep)) {
+	     i++, sfep = xfs_dir3_sf_nextentry(dp->i_mount, sfp, sfep),
+		  oldsfep = xfs_dir3_sf_nextentry(dp->i_mount, oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
 		sfep->offset = oldsfep->offset;
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
-		xfs_dir2_sfe_put_ino(sfp, sfep,
-			xfs_dir2_sfe_get_ino(oldsfp, oldsfep));
+		xfs_dir3_sfe_put_ino(dp->i_mount, sfp, sfep,
+			xfs_dir3_sfe_get_ino(dp->i_mount, oldsfp, oldsfep));
 	}
 	/*
 	 * Clean up the inode.
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 82c5a5d..b250495 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -40,6 +40,9 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_symlink.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2_format.h"
+#include "xfs_dir2_priv.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -88,10 +91,12 @@ xfs_init_security(
 static void
 xfs_dentry_to_name(
 	struct xfs_name	*namep,
-	struct dentry	*dentry)
+	struct dentry	*dentry,
+	int		mode)
 {
 	namep->name = dentry->d_name.name;
 	namep->len = dentry->d_name.len;
+	namep->type = xfs_mode_to_ftype[(mode & S_IFMT) >> S_SHIFT];
 }
 
 STATIC void
@@ -107,7 +112,7 @@ xfs_cleanup_inode(
 	 * xfs_init_security we must back out.
 	 * ENOSPC can hit here, among other things.
 	 */
-	xfs_dentry_to_name(&teardown, dentry);
+	xfs_dentry_to_name(&teardown, dentry, 0);
 
 	xfs_remove(XFS_I(dir), &teardown, XFS_I(inode));
 	iput(inode);
@@ -147,7 +152,7 @@ xfs_vn_mknod(
 			mode &= ~current_umask();
 	}
 
-	xfs_dentry_to_name(&name, dentry);
+	xfs_dentry_to_name(&name, dentry, mode);
 	error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
 	if (unlikely(error))
 		goto out_free_acl;
@@ -208,7 +213,7 @@ xfs_vn_lookup(
 	if (dentry->d_name.len >= MAXNAMELEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	xfs_dentry_to_name(&name, dentry);
+	xfs_dentry_to_name(&name, dentry, 0);
 	error = xfs_lookup(XFS_I(dir), &name, &cip, NULL);
 	if (unlikely(error)) {
 		if (unlikely(error != ENOENT))
@@ -235,7 +240,7 @@ xfs_vn_ci_lookup(
 	if (dentry->d_name.len >= MAXNAMELEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	xfs_dentry_to_name(&xname, dentry);
+	xfs_dentry_to_name(&xname, dentry, 0);
 	error = xfs_lookup(XFS_I(dir), &xname, &ip, &ci_name);
 	if (unlikely(error)) {
 		if (unlikely(error != ENOENT))
@@ -270,7 +275,7 @@ xfs_vn_link(
 	struct xfs_name	name;
 	int		error;
 
-	xfs_dentry_to_name(&name, dentry);
+	xfs_dentry_to_name(&name, dentry, inode->i_mode);
 
 	error = xfs_link(XFS_I(dir), XFS_I(inode), &name);
 	if (unlikely(error))
@@ -289,7 +294,7 @@ xfs_vn_unlink(
 	struct xfs_name	name;
 	int		error;
 
-	xfs_dentry_to_name(&name, dentry);
+	xfs_dentry_to_name(&name, dentry, 0);
 
 	error = -xfs_remove(XFS_I(dir), &name, XFS_I(dentry->d_inode));
 	if (error)
@@ -319,7 +324,7 @@ xfs_vn_symlink(
 
 	mode = S_IFLNK |
 		(irix_symlink_mode ? 0777 & ~current_umask() : S_IRWXUGO);
-	xfs_dentry_to_name(&name, dentry);
+	xfs_dentry_to_name(&name, dentry, mode);
 
 	error = xfs_symlink(XFS_I(dir), &name, symname, mode, &cip);
 	if (unlikely(error))
@@ -351,12 +356,12 @@ xfs_vn_rename(
 	struct xfs_name	oname;
 	struct xfs_name	nname;
 
-	xfs_dentry_to_name(&oname, odentry);
-	xfs_dentry_to_name(&nname, ndentry);
+	xfs_dentry_to_name(&oname, odentry, 0);
+	xfs_dentry_to_name(&nname, ndentry, odentry->d_inode->i_mode);
 
 	return -xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
 			   XFS_I(ndir), &nname, new_inode ?
-			   			XFS_I(new_inode) : NULL);
+						XFS_I(new_inode) : NULL);
 }
 
 /*
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index d6f3648..c5b1c04 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -555,12 +555,6 @@ static inline void xfs_sb_version_addprojid32bit(xfs_sb_t *sbp)
 	sbp->sb_bad_features2 |= XFS_SB_VERSION2_PROJID32BIT;
 }
 
-static inline int xfs_sb_version_hascrc(xfs_sb_t *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
-}
-
-
 /*
  * Extended v5 superblock feature masks. These are to be used for new v5
  * superblock features only.
@@ -599,7 +593,9 @@ xfs_sb_has_ro_compat_feature(
 	return (sbp->sb_features_ro_compat & feature) != 0;
 }
 
+#define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
 #define XFS_SB_FEAT_INCOMPAT_ALL 0
+
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
 xfs_sb_has_incompat_feature(
@@ -619,16 +615,30 @@ xfs_sb_has_incompat_log_feature(
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
 
-static inline bool
-xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
+/*
+ * V5 superblock specific feature checks
+ */
+static inline int xfs_sb_version_hascrc(xfs_sb_t *sbp)
 {
-	return (ino == sbp->sb_uquotino || ino == sbp->sb_gquotino);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+}
+
+static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE);
 }
 
 /*
  * end of superblock version macros
  */
 
+static inline bool
+xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
+{
+	return (ino == sbp->sb_uquotino || ino == sbp->sb_gquotino);
+}
+
 #define XFS_SB_DADDR		((xfs_daddr_t)0) /* daddr in filesystem/ag */
 #define	XFS_SB_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_SB_DADDR)
 #define XFS_BUF_TO_SBP(bp)	((xfs_dsb_t *)((bp)->b_addr))
diff --git a/fs/xfs/xfs_types.h b/fs/xfs/xfs_types.h
index ce44b18..82bbc34 100644
--- a/fs/xfs/xfs_types.h
+++ b/fs/xfs/xfs_types.h
@@ -140,6 +140,7 @@ typedef enum {
 struct xfs_name {
 	const unsigned char	*name;
 	int			len;
+	int			type;
 };
 
 /*
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
