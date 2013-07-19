Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D11938019
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3285FAC00E
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:49 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	y3elsxhmnfw4ziRE for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:43 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RT-0004Jr-I5
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RT-0002Mp-H3
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 47/49] xfs: Add read-only support for dirent filetype field
Date: Fri, 19 Jul 2013 16:45:22 +1000
Message-Id: <1374216324-8781-48-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-1-git-send-email-david@fromorbit.com>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
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
 db/check.c                |  12 +--
 db/dir2.c                 |  10 +--
 db/dir2sf.c               |   9 ++-
 db/metadump.c             |  10 +--
 include/xfs_da_btree.h    |   1 +
 include/xfs_dir2.h        |   9 ++-
 include/xfs_dir2_format.h | 183 ++++++++++++++++++++++++++++++++++++++++------
 include/xfs_sb.h          |  28 ++++---
 include/xfs_types.h       |   1 +
 libxfs/xfs_dir2.c         |   5 +-
 libxfs/xfs_dir2_block.c   |  18 ++---
 libxfs/xfs_dir2_data.c    |  13 ++--
 libxfs/xfs_dir2_leaf.c    |   6 +-
 libxfs/xfs_dir2_node.c    |   8 +-
 libxfs/xfs_dir2_priv.h    |  44 +++++------
 libxfs/xfs_dir2_sf.c      | 122 ++++++++++++++++++-------------
 logprint/log_misc.c       |  58 ++++++++-------
 repair/dir2.c             |  37 +++++-----
 repair/dir2.h             |   1 +
 repair/phase6.c           |  22 +++---
 20 files changed, 384 insertions(+), 213 deletions(-)

diff --git a/db/check.c b/db/check.c
index d490f81..287e491 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2309,7 +2309,7 @@ process_data_dir_v2(
 					(int)((char *)dep - (char *)data));
 			error++;
 		}
-		tagp = xfs_dir2_data_entry_tag_p(dep);
+		tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 		if ((char *)tagp >= endptr) {
 			if (!sflag || v)
 				dbprintf(_("dir %lld block %d bad entry at %d\n"),
@@ -2324,7 +2324,7 @@ process_data_dir_v2(
 		xname.name = dep->name;
 		xname.len = dep->namelen;
 		dir_hash_add(mp->m_dirnameops->hashname(&xname), addr);
-		ptr += xfs_dir2_data_entsize(dep->namelen);
+		ptr += xfs_dir3_data_entsize(mp, dep->namelen);
 		count++;
 		lastfree = 0;
 		lino = be64_to_cpu(dep->inumber);
@@ -3434,7 +3434,7 @@ process_sf_dir_v2(
 	sfe = xfs_dir2_sf_firstentry(sf);
 	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
 	for (i = sf->count - 1, i8 = 0; i >= 0; i--) {
-		if ((__psint_t)sfe + xfs_dir2_sf_entsize(sf, sfe->namelen) -
+		if ((__psint_t)sfe + xfs_dir3_sf_entsize(mp, sf, sfe->namelen) -
 		    (__psint_t)sf > be64_to_cpu(dip->di_size)) {
 			if (!sflag)
 				dbprintf(_("dir %llu bad size in entry at %d\n"),
@@ -3443,7 +3443,7 @@ process_sf_dir_v2(
 			error++;
 			break;
 		}
-		lino = xfs_dir2_sfe_get_ino(sf, sfe);
+		lino = xfs_dir3_sfe_get_ino(mp, sf, sfe);
 		if (lino > XFS_DIR2_MAX_SHORT_INUM)
 			i8++;
 		cid = find_inode(lino, 1);
@@ -3473,8 +3473,8 @@ process_sf_dir_v2(
 		}
 		offset =
 			xfs_dir2_sf_get_offset(sfe) +
-			xfs_dir2_sf_entsize(sf, sfe->namelen);
-		sfe = xfs_dir2_sf_nextentry(sf, sfe);
+			xfs_dir3_sf_entsize(mp, sf, sfe->namelen);
+		sfe = xfs_dir3_sf_nextentry(mp, sf, sfe);
 	}
 	if (i < 0 && (__psint_t)sfe - (__psint_t)sf != 
 					be64_to_cpu(dip->di_size)) {
diff --git a/db/dir2.c b/db/dir2.c
index 85240b0..39042b3 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -222,7 +222,7 @@ __dir2_data_entries_count(
 			ptr += be16_to_cpu(dup->length);
 		else {
 			dep = (xfs_dir2_data_entry_t *)ptr;
-			ptr += xfs_dir2_data_entsize(dep->namelen);
+			ptr += xfs_dir3_data_entsize(mp, dep->namelen);
 		}
 	}
 	return i;
@@ -246,7 +246,7 @@ __dir2_data_entry_offset(
 			ptr += be16_to_cpu(dup->length);
 		else {
 			dep = (xfs_dir2_data_entry_t *)ptr;
-			ptr += xfs_dir2_data_entsize(dep->namelen);
+			ptr += xfs_dir3_data_entsize(mp, dep->namelen);
 		}
 	}
 	return ptr;
@@ -495,7 +495,7 @@ dir2_data_union_tag_count(
 		end = (char *)&dep->namelen + sizeof(dep->namelen);
 		if (end > (char *)obj + mp->m_dirblksize)
 			return 0;
-		tagp = xfs_dir2_data_entry_tag_p(dep);
+		tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	}
 	end = (char *)tagp + sizeof(*tagp);
 	return end <= (char *)obj + mp->m_dirblksize;
@@ -517,7 +517,7 @@ dir2_data_union_tag_offset(
 		return bitize((int)((char *)xfs_dir2_data_unused_tag_p(dup) -
 				    (char *)dup));
 	dep = (xfs_dir2_data_entry_t *)dup;
-	return bitize((int)((char *)xfs_dir2_data_entry_tag_p(dep) -
+	return bitize((int)((char *)xfs_dir3_data_entry_tag_p(mp, dep) -
 			    (char *)dep));
 }
 
@@ -592,7 +592,7 @@ dir2_data_union_size(
 		return bitize(be16_to_cpu(dup->length));
 	else {
 		dep = (xfs_dir2_data_entry_t *)dup;
-		return bitize(xfs_dir2_data_entsize(dep->namelen));
+		return bitize(xfs_dir3_data_entsize(mp, dep->namelen));
 	}
 }
 
diff --git a/db/dir2sf.c b/db/dir2sf.c
index b32ca32..d628641 100644
--- a/db/dir2sf.c
+++ b/db/dir2sf.c
@@ -24,6 +24,7 @@
 #include "bit.h"
 #include "dir2.h"
 #include "dir2sf.h"
+#include "init.h"
 
 static int	dir2_inou_i4_count(void *obj, int startoff);
 static int	dir2_inou_i8_count(void *obj, int startoff);
@@ -155,8 +156,8 @@ dir2_sf_entry_size(
 	sf = (struct xfs_dir2_sf_hdr *)((char *)obj + byteize(startoff));
 	e = xfs_dir2_sf_firstentry(sf);
 	for (i = 0; i < idx; i++)
-		e = xfs_dir2_sf_nextentry(sf, e);
-	return bitize((int)xfs_dir2_sf_entsize(sf, e->namelen));
+		e = xfs_dir3_sf_nextentry(mp, sf, e);
+	return bitize((int)xfs_dir3_sf_entsize(mp, sf, e->namelen));
 }
 
 /*ARGSUSED*/
@@ -200,7 +201,7 @@ dir2_sf_list_offset(
 	sf = (struct xfs_dir2_sf_hdr *)((char *)obj + byteize(startoff));
 	e = xfs_dir2_sf_firstentry(sf);
 	for (i = 0; i < idx; i++)
-		e = xfs_dir2_sf_nextentry(sf, e);
+		e = xfs_dir3_sf_nextentry(mp, sf, e);
 	return bitize((int)((char *)e - (char *)sf));
 }
 
@@ -220,6 +221,6 @@ dir2sf_size(
 	sf = (struct xfs_dir2_sf_hdr *)((char *)obj + byteize(startoff));
 	e = xfs_dir2_sf_firstentry(sf);
 	for (i = 0; i < sf->count; i++)
-		e = xfs_dir2_sf_nextentry(sf, e);
+		e = xfs_dir3_sf_nextentry(mp, sf, e);
 	return bitize((int)((char *)e - (char *)sf));
 }
diff --git a/db/metadump.c b/db/metadump.c
index 1c8020b..d9f35b0 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -939,7 +939,7 @@ obfuscate_sf_dir(
 			namelen = ino_dir_size - ((char *)&sfep->name[0] -
 					 (char *)sfp);
 		} else if ((char *)sfep - (char *)sfp +
-				xfs_dir2_sf_entsize(sfp, sfep->namelen) >
+				xfs_dir3_sf_entsize(mp, sfp, sfep->namelen) >
 				ino_dir_size) {
 			if (show_warnings)
 				print_warning("entry length in dir inode %llu "
@@ -950,11 +950,11 @@ obfuscate_sf_dir(
 					 (char *)sfp);
 		}
 
-		generate_obfuscated_name(xfs_dir2_sfe_get_ino(sfp, sfep),
+		generate_obfuscated_name(xfs_dir3_sfe_get_ino(mp, sfp, sfep),
 					 namelen, &sfep->name[0]);
 
 		sfep = (xfs_dir2_sf_entry_t *)((char *)sfep +
-				xfs_dir2_sf_entsize(sfp, namelen));
+				xfs_dir3_sf_entsize(mp, sfp, namelen));
 	}
 }
 
@@ -1184,7 +1184,7 @@ obfuscate_dir_data_blocks(
 			}
 
 			dep = (xfs_dir2_data_entry_t *)ptr;
-			length = xfs_dir2_data_entsize(dep->namelen);
+			length = xfs_dir3_data_entsize(mp, dep->namelen);
 
 			if (dir_offset + length > dir_data.end_of_data ||
 					ptr + length > endptr) {
@@ -1194,7 +1194,7 @@ obfuscate_dir_data_blocks(
 						(long long)cur_ino);
 				break;
 			}
-			if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(dep)) !=
+			if (be16_to_cpu(*xfs_dir3_data_entry_tag_p(mp, dep)) !=
 					dir_offset) {
 				dir_data.bad_block = 1;
 				break;
diff --git a/include/xfs_da_btree.h b/include/xfs_da_btree.h
index 6fb3371..8cdc77b 100644
--- a/include/xfs_da_btree.h
+++ b/include/xfs_da_btree.h
@@ -176,6 +176,7 @@ enum xfs_dacmp {
 typedef struct xfs_da_args {
 	const __uint8_t	*name;		/* string (maybe not NULL terminated) */
 	int		namelen;	/* length of string (maybe no NULL) */
+	__uint8_t	filetype;	/* filetype of inode for directories */
 	__uint8_t	*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
 	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
diff --git a/include/xfs_dir2.h b/include/xfs_dir2.h
index 7fe2b8f..9910401 100644
--- a/include/xfs_dir2.h
+++ b/include/xfs_dir2.h
@@ -68,10 +68,11 @@ extern int xfs_dir2_sf_to_block(struct xfs_da_args *args);
 extern xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *sfp);
 extern void xfs_dir2_sf_put_parent_ino(struct xfs_dir2_sf_hdr *sfp,
 		xfs_ino_t ino);
-extern xfs_ino_t xfs_dir2_sfe_get_ino(struct xfs_dir2_sf_hdr *sfp,
-		struct xfs_dir2_sf_entry *sfep);
-extern void xfs_dir2_sfe_put_ino( struct xfs_dir2_sf_hdr *,
-		struct xfs_dir2_sf_entry *sfep, xfs_ino_t ino);
+extern xfs_ino_t xfs_dir3_sfe_get_ino(struct xfs_mount *mp,
+		struct xfs_dir2_sf_hdr *sfp, struct xfs_dir2_sf_entry *sfep);
+extern void xfs_dir3_sfe_put_ino(struct xfs_mount *mp,
+		struct xfs_dir2_sf_hdr *hdr, struct xfs_dir2_sf_entry *sfep,
+		xfs_ino_t ino);
 
 extern int xfs_dir2_isblock(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
 extern int xfs_dir2_isleaf(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
diff --git a/include/xfs_dir2_format.h b/include/xfs_dir2_format.h
index 2095e17..a0961a6 100644
--- a/include/xfs_dir2_format.h
+++ b/include/xfs_dir2_format.h
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
diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index d6f3648..c5b1c04 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
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
diff --git a/include/xfs_types.h b/include/xfs_types.h
index ce44b18..82bbc34 100644
--- a/include/xfs_types.h
+++ b/include/xfs_types.h
@@ -140,6 +140,7 @@ typedef enum {
 struct xfs_name {
 	const unsigned char	*name;
 	int			len;
+	int			type;
 };
 
 /*
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 830fe3e..521042f 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -18,7 +18,8 @@
 
 #include <xfs.h>
 
-struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2};
+struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
+
 
 /*
  * ASCII case-insensitive (ie. A-Z) support for directories that was
@@ -367,6 +368,7 @@ xfs_dir_replace(
 	memset(&args, 0, sizeof(xfs_da_args_t));
 	args.name = name->name;
 	args.namelen = name->len;
+	args.filetype = name->type;
 	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.inumber = inum;
 	args.dp = dp;
@@ -414,6 +416,7 @@ xfs_dir_canenter(
 	memset(&args, 0, sizeof(xfs_da_args_t));
 	args.name = name->name;
 	args.namelen = name->len;
+	args.filetype = name->type;
 	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.dp = dp;
 	args.whichfork = XFS_DATA_FORK;
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index d94b9b2..615eea9 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -107,7 +107,7 @@ const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
 	.verify_write = xfs_dir3_block_write_verify,
 };
 
-static int
+int
 xfs_dir3_block_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
@@ -350,7 +350,7 @@ xfs_dir2_block_addname(
 	if (error)
 		return error;
 
-	len = xfs_dir2_data_entsize(args->namelen);
+	len = xfs_dir3_data_entsize(mp, args->namelen);
 
 	/*
 	 * Set up pointers to parts of the block.
@@ -530,7 +530,7 @@ xfs_dir2_block_addname(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, args->namelen);
-	tagp = xfs_dir2_data_entry_tag_p(dep);
+	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
@@ -780,7 +780,7 @@ xfs_dir2_block_removename(
 	needlog = needscan = 0;
 	xfs_dir2_data_make_free(tp, bp,
 		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
-		xfs_dir2_data_entsize(dep->namelen), &needlog, &needscan);
+		xfs_dir3_data_entsize(mp, dep->namelen), &needlog, &needscan);
 	/*
 	 * Fix up the block tail.
 	 */
@@ -1140,7 +1140,7 @@ xfs_dir2_sf_to_block(
 	dep->inumber = cpu_to_be64(dp->i_ino);
 	dep->namelen = 1;
 	dep->name[0] = '.';
-	tagp = xfs_dir2_data_entry_tag_p(dep);
+	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, bp, dep);
 	blp[0].hashval = cpu_to_be32(xfs_dir_hash_dot);
@@ -1153,7 +1153,7 @@ xfs_dir2_sf_to_block(
 	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
-	tagp = xfs_dir2_data_entry_tag_p(dep);
+	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, bp, dep);
 	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
@@ -1198,10 +1198,10 @@ xfs_dir2_sf_to_block(
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
@@ -1214,7 +1214,7 @@ xfs_dir2_sf_to_block(
 		if (++i == sfp->count)
 			sfep = NULL;
 		else
-			sfep = xfs_dir2_sf_nextentry(sfp, sfep);
+			sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
 	}
 	/* Done with the temporary buffer */
 	kmem_free(sfp);
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 5074878..ea9ba91 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -131,7 +131,7 @@ __xfs_dir3_data_check(
 		XFS_WANT_CORRUPTED_RETURN(
 			!xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)));
 		XFS_WANT_CORRUPTED_RETURN(
-			be16_to_cpu(*xfs_dir2_data_entry_tag_p(dep)) ==
+			be16_to_cpu(*xfs_dir3_data_entry_tag_p(mp, dep)) ==
 					       (char *)dep - (char *)hdr);
 		count++;
 		lastfree = 0;
@@ -150,7 +150,7 @@ __xfs_dir3_data_check(
 			}
 			XFS_WANT_CORRUPTED_RETURN(i < be32_to_cpu(btp->count));
 		}
-		p += xfs_dir2_data_entsize(dep->namelen);
+		p += xfs_dir3_data_entsize(mp, dep->namelen);
 	}
 	/*
 	 * Need to have seen all the entries and all the bestfree slots.
@@ -520,8 +520,8 @@ xfs_dir2_data_freescan(
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
@@ -611,7 +611,8 @@ xfs_dir2_data_log_entry(
 	struct xfs_buf		*bp,
 	xfs_dir2_data_entry_t	*dep)		/* data entry pointer */
 {
-	xfs_dir2_data_hdr_t	*hdr = bp->b_addr;
+	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
+	struct xfs_mount	*mp = tp->t_mountp;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
@@ -619,7 +620,7 @@ xfs_dir2_data_log_entry(
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
 	xfs_trans_log_buf(tp, bp, (uint)((char *)dep - (char *)hdr),
-		(uint)((char *)(xfs_dir2_data_entry_tag_p(dep) + 1) -
+		(uint)((char *)(xfs_dir3_data_entry_tag_p(mp, dep) + 1) -
 		       (char *)hdr - 1));
 }
 
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 55b7d05..04ad083 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -677,7 +677,7 @@ xfs_dir2_leaf_addname(
 	ents = xfs_dir3_leaf_ents_p(leaf);
 	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
-	length = xfs_dir2_data_entsize(args->namelen);
+	length = xfs_dir3_data_entsize(mp, args->namelen);
 
 	/*
 	 * See if there are any entries with the same hash value
@@ -878,7 +878,7 @@ xfs_dir2_leaf_addname(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
-	tagp = xfs_dir2_data_entry_tag_p(dep);
+	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
@@ -1409,7 +1409,7 @@ xfs_dir2_leaf_removename(
 	 */
 	xfs_dir2_data_make_free(tp, dbp,
 		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
-		xfs_dir2_data_entsize(dep->namelen), &needlog, &needscan);
+		xfs_dir3_data_entsize(mp, dep->namelen), &needlog, &needscan);
 	/*
 	 * We just mark the leaf entry stale by putting a null in it.
 	 */
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index d2bd249..5b118d5 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -587,7 +587,7 @@ xfs_dir2_leafn_lookup_for_addname(
 		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
 		       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
 	}
-	length = xfs_dir2_data_entsize(args->namelen);
+	length = xfs_dir3_data_entsize(mp, args->namelen);
 	/*
 	 * Loop over leaf entries with the right hash value.
 	 */
@@ -1241,7 +1241,7 @@ xfs_dir2_leafn_remove(
 	longest = be16_to_cpu(bf[0].length);
 	needlog = needscan = 0;
 	xfs_dir2_data_make_free(tp, dbp, off,
-		xfs_dir2_data_entsize(dep->namelen), &needlog, &needscan);
+		xfs_dir3_data_entsize(mp, dep->namelen), &needlog, &needscan);
 	/*
 	 * Rescan the data block freespaces for bestfree.
 	 * Log the data block header if needed.
@@ -1693,7 +1693,7 @@ xfs_dir2_node_addname_int(
 	dp = args->dp;
 	mp = dp->i_mount;
 	tp = args->trans;
-	length = xfs_dir2_data_entsize(args->namelen);
+	length = xfs_dir3_data_entsize(mp, args->namelen);
 	/*
 	 * If we came in with a freespace block that means that lookup
 	 * found an entry with our hash value.  This is the freespace
@@ -1989,7 +1989,7 @@ xfs_dir2_node_addname_int(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
-	tagp = xfs_dir2_data_entry_tag_p(dep);
+	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, dbp, dep);
 	/*
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 7af3e92..1bad84c 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -18,21 +18,26 @@
 #ifndef __XFS_DIR2_PRIV_H__
 #define __XFS_DIR2_PRIV_H__
 
+struct dir_context;
+
 /* xfs_dir2.c */
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
-extern int xfs_dir2_isblock(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
-extern int xfs_dir2_isleaf(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
 				xfs_dir2_db_t *dbp);
-extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
-				struct xfs_buf *bp);
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
+extern int xfs_dir3_block_read(struct xfs_trans *tp, struct xfs_inode *dp,
+			       struct xfs_buf **bpp);
 extern int xfs_dir2_block_addname(struct xfs_da_args *args);
-extern int xfs_dir2_block_getdents(struct xfs_inode *dp, void *dirent,
-		xfs_off_t *offset, filldir_t filldir);
 extern int xfs_dir2_block_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_block_removename(struct xfs_da_args *args);
 extern int xfs_dir2_block_replace(struct xfs_da_args *args);
@@ -55,22 +60,8 @@ extern int xfs_dir3_data_readahead(struct xfs_trans *tp, struct xfs_inode *dp,
 extern struct xfs_dir2_data_free *
 xfs_dir2_data_freeinsert(struct xfs_dir2_data_hdr *hdr,
 		struct xfs_dir2_data_unused *dup, int *loghead);
-extern void xfs_dir2_data_freescan(struct xfs_mount *mp,
-		struct xfs_dir2_data_hdr *hdr, int *loghead);
 extern int xfs_dir3_data_init(struct xfs_da_args *args, xfs_dir2_db_t blkno,
 		struct xfs_buf **bpp);
-extern void xfs_dir2_data_log_entry(struct xfs_trans *tp, struct xfs_buf *bp,
-		struct xfs_dir2_data_entry *dep);
-extern void xfs_dir2_data_log_header(struct xfs_trans *tp,
-		struct xfs_buf *bp);
-extern void xfs_dir2_data_log_unused(struct xfs_trans *tp, struct xfs_buf *bp,
-		struct xfs_dir2_data_unused *dup);
-extern void xfs_dir2_data_make_free(struct xfs_trans *tp, struct xfs_buf *bp,
-		xfs_dir2_data_aoff_t offset, xfs_dir2_data_aoff_t len,
-		int *needlogp, int *needscanp);
-extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
-		struct xfs_dir2_data_unused *dup, xfs_dir2_data_aoff_t offset,
-		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
 
 /* xfs_dir2_leaf.c */
 extern int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
@@ -83,8 +74,6 @@ extern void xfs_dir3_leaf_compact(struct xfs_da_args *args,
 extern void xfs_dir3_leaf_compact_x1(struct xfs_dir3_icleaf_hdr *leafhdr,
 		struct xfs_dir2_leaf_entry *ents, int *indexp,
 		int *lowstalep, int *highstalep, int *lowlogp, int *highlogp);
-extern int xfs_dir2_leaf_getdents(struct xfs_inode *dp, void *dirent,
-		size_t bufsize, xfs_off_t *offset, filldir_t filldir);
 extern int xfs_dir3_leaf_get_buf(struct xfs_da_args *args, xfs_dir2_db_t bno,
 		struct xfs_buf **bpp, __uint16_t magic);
 extern void xfs_dir3_leaf_log_ents(struct xfs_trans *tp, struct xfs_buf *bp,
@@ -104,6 +93,8 @@ xfs_dir3_leaf_find_entry(struct xfs_dir3_icleaf_hdr *leafhdr,
 		int lowstale, int highstale, int *lfloglow, int *lfloghigh);
 extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
 
+extern void xfs_dir3_leaf_hdr_from_disk(struct xfs_dir3_icleaf_hdr *to,
+		struct xfs_dir2_leaf *from);
 extern void xfs_dir3_leaf_hdr_to_disk(struct xfs_dir2_leaf *to,
 		struct xfs_dir3_icleaf_hdr *from);
 extern bool xfs_dir3_leaf_check_int(struct xfs_mount *mp,
@@ -134,19 +125,18 @@ extern int xfs_dir2_free_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, struct xfs_buf **bpp);
 
 /* xfs_dir2_sf.c */
-extern xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *sfp);
-extern xfs_ino_t xfs_dir2_sfe_get_ino(struct xfs_dir2_sf_hdr *sfp,
-		struct xfs_dir2_sf_entry *sfep);
 extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
 		struct xfs_dir2_data_hdr *block, struct xfs_dir2_sf_hdr *sfhp);
 extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp,
 		int size, xfs_dir2_sf_hdr_t *sfhp);
 extern int xfs_dir2_sf_addname(struct xfs_da_args *args);
 extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
-extern int xfs_dir2_sf_getdents(struct xfs_inode *dp, void *dirent,
-		xfs_off_t *offset, filldir_t filldir);
 extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
 extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
 
+/* xfs_dir2_readdir.c */
+extern int xfs_readdir(struct xfs_inode *dp, struct dir_context *ctx,
+		       size_t bufsize);
+
 #endif /* __XFS_DIR2_PRIV_H__ */
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index cb23368..2791d99 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -15,7 +15,6 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-
 #include <xfs.h>
 
 /*
@@ -89,31 +88,38 @@ xfs_dir2_sf_put_parent_ino(
 
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
@@ -141,9 +147,16 @@ xfs_dir2_block_sfsize(
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
@@ -172,9 +185,10 @@ xfs_dir2_block_sfsize(
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
@@ -300,12 +314,12 @@ xfs_dir2_block_to_sf(
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
@@ -356,7 +370,7 @@ xfs_dir2_sf_addname(
 	/*
 	 * Compute entry (and change in) size.
 	 */
-	add_entsize = xfs_dir2_sf_entsize(sfp, args->namelen);
+	add_entsize = xfs_dir3_sf_entsize(dp->i_mount, sfp, args->namelen);
 	incr_isize = add_entsize;
 	objchange = 0;
 #if XFS_BIG_INUMS
@@ -450,8 +464,9 @@ xfs_dir2_sf_addname_easy(
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
@@ -463,7 +478,7 @@ xfs_dir2_sf_addname_easy(
 	sfep->namelen = args->namelen;
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
-	xfs_dir2_sfe_put_ino(sfp, sfep, args->inumber);
+	xfs_dir3_sfe_put_ino(dp->i_mount, sfp, sfep, args->inumber);
 	/*
 	 * Update the header and inode.
 	 */
@@ -503,11 +518,13 @@ xfs_dir2_sf_addname_hard(
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
@@ -519,13 +536,13 @@ xfs_dir2_sf_addname_hard(
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
@@ -554,7 +571,7 @@ xfs_dir2_sf_addname_hard(
 	sfep->namelen = args->namelen;
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
-	xfs_dir2_sfe_put_ino(sfp, sfep, args->inumber);
+	xfs_dir3_sfe_put_ino(mp, sfp, sfep, args->inumber);
 	sfp->count++;
 #if XFS_BIG_INUMS
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
@@ -564,7 +581,7 @@ xfs_dir2_sf_addname_hard(
 	 * If there's more left to copy, do that.
 	 */
 	if (!eof) {
-		sfep = xfs_dir2_sf_nextentry(sfp, sfep);
+		sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
 		memcpy(sfep, oldsfep, old_isize - nbytes);
 	}
 	kmem_free(buf);
@@ -600,7 +617,7 @@ xfs_dir2_sf_addname_pick(
 	mp = dp->i_mount;
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	size = xfs_dir2_data_entsize(args->namelen);
+	size = xfs_dir3_data_entsize(mp, args->namelen);
 	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	holefit = 0;
@@ -613,8 +630,8 @@ xfs_dir2_sf_addname_pick(
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
@@ -668,31 +685,34 @@ xfs_dir2_sf_check(
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
 
@@ -804,7 +824,7 @@ xfs_dir2_sf_lookup(
 	 */
 	ci_sfep = NULL;
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->count;
-				i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
+	     i++, sfep = xfs_dir3_sf_nextentry(dp->i_mount, sfp, sfep)) {
 		/*
 		 * Compare name and if it's an exact match, return the inode
 		 * number. If it's the first case-insensitive match, store the
@@ -814,7 +834,8 @@ xfs_dir2_sf_lookup(
 								sfep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
-			args->inumber = xfs_dir2_sfe_get_ino(sfp, sfep);
+			args->inumber = xfs_dir3_sfe_get_ino(dp->i_mount,
+							     sfp, sfep);
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
 			ci_sfep = sfep;
@@ -870,10 +891,10 @@ xfs_dir2_sf_removename(
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
@@ -887,7 +908,7 @@ xfs_dir2_sf_removename(
 	 * Calculate sizes.
 	 */
 	byteoff = (int)((char *)sfep - (char *)sfp);
-	entsize = xfs_dir2_sf_entsize(sfp, args->namelen);
+	entsize = xfs_dir3_sf_entsize(dp->i_mount, sfp, args->namelen);
 	newsize = oldsize - entsize;
 	/*
 	 * Copy the part if any after the removed entry, sliding it down.
@@ -1003,16 +1024,17 @@ xfs_dir2_sf_replace(
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
@@ -1120,13 +1142,13 @@ xfs_dir2_sf_toino4(
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
@@ -1195,13 +1217,13 @@ xfs_dir2_sf_toino8(
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
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 9526ec4..817142b 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -565,7 +565,10 @@ xlog_print_trans_inode_core(xfs_icdinode_t *ip)
 }
 
 void
-xlog_print_dir2_sf(xfs_dir2_sf_hdr_t *sfp, int size)
+xlog_print_dir2_sf(
+	struct xlog	*log,
+	xfs_dir2_sf_hdr_t *sfp,
+	int		size)
 {
 	xfs_ino_t	ino;
 	int		count;
@@ -587,21 +590,23 @@ xlog_print_dir2_sf(xfs_dir2_sf_hdr_t *sfp, int size)
 	count = sfp->count;
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	for (i = 0; i < count; i++) {
-		ino = xfs_dir2_sfe_get_ino(sfp, sfep);
+		ino = xfs_dir3_sfe_get_ino(log->l_mp, sfp, sfep);
 		memmove(namebuf, (sfep->name), sfep->namelen);
 		namebuf[sfep->namelen] = '\0';
 		printf(_("%s ino 0x%llx namelen %d\n"),
 		       namebuf, (unsigned long long)ino, sfep->namelen);
-		sfep = xfs_dir2_sf_nextentry(sfp, sfep);
+		sfep = xfs_dir3_sf_nextentry(log->l_mp, sfp, sfep);
 	}
 }
 
 int
-xlog_print_trans_inode(xfs_caddr_t *ptr,
-		       int len,
-		       int *i,
-		       int num_ops,
-		       boolean_t continued)
+xlog_print_trans_inode(
+	struct xlog	*log,
+	xfs_caddr_t	*ptr,
+	int		len,
+	int		*i,
+	int		num_ops,
+	boolean_t	continued)
 {
     xfs_icdinode_t	   dino;
     xlog_op_header_t	   *op_head;
@@ -695,7 +700,7 @@ xlog_print_trans_inode(xfs_caddr_t *ptr,
 	    case XFS_ILOG_DDATA:
 		printf(_("LOCAL inode data\n"));
 		if (mode == S_IFDIR)
-		    xlog_print_dir2_sf((xfs_dir2_sf_hdr_t *)*ptr, size);
+		    xlog_print_dir2_sf(log, (xfs_dir2_sf_hdr_t *)*ptr, size);
 		break;
 	    default:
 		ASSERT((f->ilf_fields & XFS_ILOG_DFORK) == 0);
@@ -722,7 +727,7 @@ xlog_print_trans_inode(xfs_caddr_t *ptr,
 	    case XFS_ILOG_ADATA:
 		printf(_("LOCAL attr data\n"));
 		if (mode == S_IFDIR)
-		    xlog_print_dir2_sf((xfs_dir2_sf_hdr_t *)*ptr, size);
+		    xlog_print_dir2_sf(log, (xfs_dir2_sf_hdr_t *)*ptr, size);
 		break;
 	    default:
 		ASSERT((f->ilf_fields & XFS_ILOG_AFORK) == 0);
@@ -857,14 +862,16 @@ print_lsn(xfs_caddr_t	string,
 
 
 int
-xlog_print_record(int			  fd,
-		 int			  num_ops,
-		 int			  len,
-		 int			  *read_type,
-		 xfs_caddr_t		  *partial_buf,
-		 xlog_rec_header_t	  *rhead,
-		 xlog_rec_ext_header_t	  *xhdrs,
-		 int			  bad_hdr_warn)
+xlog_print_record(
+	struct xlog		*log,
+	int			fd,
+	int			num_ops,
+	int			len,
+	int			*read_type,
+	xfs_caddr_t		*partial_buf,
+	xlog_rec_header_t	*rhead,
+	xlog_rec_ext_header_t	*xhdrs,
+	int			bad_hdr_warn)
 {
     xfs_caddr_t		buf, ptr;
     int			read_len, skip;
@@ -1011,7 +1018,7 @@ xlog_print_record(int			  fd,
 			break;
 		    }
 		    case XFS_LI_INODE: {
-			skip = xlog_print_trans_inode(&ptr,
+			skip = xlog_print_trans_inode(log, &ptr,
 					be32_to_cpu(op_head->oh_len),
 					&i, num_ops, continued);
 			break;
@@ -1387,7 +1394,7 @@ void xfs_log_print(struct xlog  *log,
 		break;
 	}
 
-	error =	xlog_print_record(fd, num_ops, len, &read_type, &partial_buf,
+	error =	xlog_print_record(log, fd, num_ops, len, &read_type, &partial_buf,
 				  hdr, xhdrs, first_hdr_found);
 	first_hdr_found++;
 	switch (error) {
@@ -1488,14 +1495,9 @@ loop:
 	    }
 
 partial_log_read:
-	    error= xlog_print_record(fd,
-				    num_ops,
-				    len,
-				    &read_type,
-				    &partial_buf,
-				    (xlog_rec_header_t *)hbuf,
-				    xhdrs,
-				    first_hdr_found);
+	    error= xlog_print_record(log, fd, num_ops, len, &read_type,
+				    &partial_buf, (xlog_rec_header_t *)hbuf,
+				    xhdrs, first_hdr_found);
 	    if (read_type != FULL_READ)
 		len -= read_type;
 	    read_type = FULL_READ;
diff --git a/repair/dir2.c b/repair/dir2.c
index 2ca7fd1..2cccf1d 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -651,6 +651,7 @@ _("would correct bad hashval in interior dir block\n"
  */
 void
 process_sf_dir2_fixi8(
+	struct xfs_mount	*mp,
 	struct xfs_dir2_sf_hdr	*sfp,
 	xfs_dir2_sf_entry_t	**next_sfep)
 {
@@ -680,10 +681,10 @@ process_sf_dir2_fixi8(
 		xfs_dir2_sf_put_offset(newsfep,
 			xfs_dir2_sf_get_offset(oldsfep));
 		memmove(newsfep->name, oldsfep->name, newsfep->namelen);
-		ino = xfs_dir2_sfe_get_ino(oldsfp, oldsfep);
-		xfs_dir2_sfe_put_ino(newsfp, newsfep, ino);
-		oldsfep = xfs_dir2_sf_nextentry(oldsfp, oldsfep);
-		newsfep = xfs_dir2_sf_nextentry(newsfp, newsfep);
+		ino = xfs_dir3_sfe_get_ino(mp, oldsfp, oldsfep);
+		xfs_dir3_sfe_put_ino(mp, newsfp, newsfep, ino);
+		oldsfep = xfs_dir3_sf_nextentry(mp, oldsfp, oldsfep);
+		newsfep = xfs_dir3_sf_nextentry(mp, newsfp, newsfep);
 	}
 	*next_sfep = newsfep;
 	free(oldsfp);
@@ -708,8 +709,8 @@ process_sf_dir2_fixoff(
 
 	for (i = 0; i < sfp->count; i++) {
 		xfs_dir2_sf_put_offset(sfep, offset);
-		offset += xfs_dir2_data_entsize(sfep->namelen);
-		sfep = xfs_dir2_sf_nextentry(sfp, sfep);
+		offset += xfs_dir3_data_entsize(mp, sfep->namelen);
+		sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
 	}
 }
 
@@ -771,7 +772,7 @@ process_sf_dir2(
 	/*
 	 * check for bad entry count
 	 */
-	if (num_entries * xfs_dir2_sf_entsize(sfp, 1) +
+	if (num_entries * xfs_dir3_sf_entsize(mp, sfp, 1) +
 		    xfs_dir2_sf_hdr_size(0) > max_size || num_entries == 0)
 		num_entries = 0xFF;
 
@@ -787,7 +788,7 @@ process_sf_dir2(
 		sfep = next_sfep;
 		junkit = 0;
 		bad_sfnamelen = 0;
-		lino = xfs_dir2_sfe_get_ino(sfp, sfep);
+		lino = xfs_dir3_sfe_get_ino(mp, sfp, sfep);
 		/*
 		 * if entry points to self, junk it since only '.' or '..'
 		 * should do that and shortform dirs don't contain either
@@ -901,7 +902,7 @@ _("zero length entry in shortform dir %" PRIu64 ""),
 				break;
 			}
 		} else if ((__psint_t) sfep - (__psint_t) sfp +
-				xfs_dir2_sf_entsize(sfp, sfep->namelen)
+				xfs_dir3_sf_entsize(mp, sfp, sfep->namelen)
 							> ino_dir_size)  {
 			bad_sfnamelen = 1;
 
@@ -972,7 +973,7 @@ _("entry contains offset out of order in shortform dir %" PRIu64 "\n"),
 			bad_offset = 1;
 		}
 		offset = xfs_dir2_sf_get_offset(sfep) +
-						xfs_dir2_data_entsize(namelen);
+					xfs_dir3_data_entsize(mp, namelen);
 
 		/*
 		 * junk the entry by copying up the rest of the
@@ -989,7 +990,7 @@ _("entry contains offset out of order in shortform dir %" PRIu64 "\n"),
 			name[namelen] = '\0';
 
 			if (!no_modify)  {
-				tmp_elen = xfs_dir2_sf_entsize(sfp,
+				tmp_elen = xfs_dir3_sf_entsize(mp, sfp,
 								sfep->namelen);
 				be64_add_cpu(&dip->di_size, -tmp_elen);
 				ino_dir_size -= tmp_elen;
@@ -1043,8 +1044,8 @@ _("would have junked entry \"%s\" in directory inode %" PRIu64 "\n"),
 		next_sfep = (tmp_sfep == NULL)
 			? (xfs_dir2_sf_entry_t *) ((__psint_t) sfep
 							+ ((!bad_sfnamelen)
-				? xfs_dir2_sf_entsize(sfp, sfep->namelen)
-				: xfs_dir2_sf_entsize(sfp, namelen)))
+				? xfs_dir3_sf_entsize(mp, sfp, sfep->namelen)
+				: xfs_dir3_sf_entsize(mp, sfp, namelen)))
 			: tmp_sfep;
 	}
 
@@ -1075,7 +1076,7 @@ _("would have corrected i8 count in directory %" PRIu64 " from %d to %d\n"),
 _("corrected i8 count in directory %" PRIu64 ", was %d, now %d\n"),
 				ino, sfp->i8count, i8);
 			if (i8 == 0)
-				process_sf_dir2_fixi8(sfp, &next_sfep);
+				process_sf_dir2_fixi8(mp, sfp, &next_sfep);
 			else
 				sfp->i8count = i8;
 			*dino_dirty = 1;
@@ -1268,12 +1269,12 @@ process_dir2_data(
 			continue;
 		}
 		dep = (xfs_dir2_data_entry_t *)ptr;
-		if (ptr + xfs_dir2_data_entsize(dep->namelen) > endptr)
+		if (ptr + xfs_dir3_data_entsize(mp, dep->namelen) > endptr)
 			break;
-		if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(dep)) !=
+		if (be16_to_cpu(*xfs_dir3_data_entry_tag_p(mp, dep)) !=
 		    				(char *)dep - (char *)d)
 			break;
-		ptr += xfs_dir2_data_entsize(dep->namelen);
+		ptr += xfs_dir3_data_entsize(mp, dep->namelen);
 		lastfree = 0;
 	}
 	/*
@@ -1528,7 +1529,7 @@ _("entry \"%*.*s\" in directory inode %" PRIu64 " points to self: "),
 		/*
 		 * Advance to the next entry.
 		 */
-		ptr += xfs_dir2_data_entsize(dep->namelen);
+		ptr += xfs_dir3_data_entsize(mp, dep->namelen);
 	}
 	/*
 	 * Check the bestfree table.
diff --git a/repair/dir2.h b/repair/dir2.h
index 3d8fe8a..df68d5c 100644
--- a/repair/dir2.h
+++ b/repair/dir2.h
@@ -72,6 +72,7 @@ process_dir2(
 
 void
 process_sf_dir2_fixi8(
+	struct xfs_mount	*mp,
 	struct xfs_dir2_sf_hdr	*sfp,
 	xfs_dir2_sf_entry_t	**next_sfep);
 
diff --git a/repair/phase6.c b/repair/phase6.c
index df9b92e..77d99e1 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1500,12 +1500,12 @@ longform_dir2_entry_check_data(
 
 		/* validate data entry size */
 		dep = (xfs_dir2_data_entry_t *)ptr;
-		if (ptr + xfs_dir2_data_entsize(dep->namelen) > endptr)
+		if (ptr + xfs_dir3_data_entsize(mp, dep->namelen) > endptr)
 			break;
-		if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(dep)) !=
+		if (be16_to_cpu(*xfs_dir3_data_entry_tag_p(mp, dep)) !=
 						(char *)dep - (char *)d)
 			break;
-		ptr += xfs_dir2_data_entsize(dep->namelen);
+		ptr += xfs_dir3_data_entsize(mp, dep->namelen);
 	}
 
 	/* did we find an empty or corrupt block? */
@@ -1594,7 +1594,7 @@ longform_dir2_entry_check_data(
 		}
 		addr = xfs_dir2_db_off_to_dataptr(mp, db, ptr - (char *)d);
 		dep = (xfs_dir2_data_entry_t *)ptr;
-		ptr += xfs_dir2_data_entsize(dep->namelen);
+		ptr += xfs_dir3_data_entsize(mp, dep->namelen);
 		inum = be64_to_cpu(dep->inumber);
 		lastfree = 0;
 		/*
@@ -2226,7 +2226,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 		bad_sfnamelen = 0;
 		tmp_sfep = NULL;
 
-		lino = xfs_dir2_sfe_get_ino(sfp, sfep);
+		lino = xfs_dir3_sfe_get_ino(mp, sfp, sfep);
 
 		namelen = sfep->namelen;
 
@@ -2255,7 +2255,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 				break;
 			}
 		} else if (no_modify && (__psint_t) sfep - (__psint_t) sfp +
-				+ xfs_dir2_sf_entsize(sfp, sfep->namelen)
+				+ xfs_dir3_sf_entsize(mp, sfp, sfep->namelen)
 				> ip->i_d.di_size)  {
 			bad_sfnamelen = 1;
 
@@ -2285,7 +2285,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 
 		if (no_modify && verify_inum(mp, lino))  {
 			next_sfep = (xfs_dir2_sf_entry_t *)((__psint_t)sfep +
-				xfs_dir2_sf_entsize(sfp, sfep->namelen));
+				xfs_dir3_sf_entsize(mp, sfp, sfep->namelen));
 			continue;
 		}
 
@@ -2393,7 +2393,7 @@ do_junkit:
 			if (lino == orphanage_ino)
 				orphanage_ino = 0;
 			if (!no_modify)  {
-				tmp_elen = xfs_dir2_sf_entsize(sfp,
+				tmp_elen = xfs_dir3_sf_entsize(mp, sfp,
 								sfep->namelen);
 				tmp_sfep = (xfs_dir2_sf_entry_t *)
 					((__psint_t) sfep + tmp_elen);
@@ -2446,8 +2446,8 @@ do_junkit:
 		next_sfep = (tmp_sfep == NULL)
 			? (xfs_dir2_sf_entry_t *) ((__psint_t) sfep
 							+ ((!bad_sfnamelen)
-				? xfs_dir2_sf_entsize(sfp, sfep->namelen)
-				: xfs_dir2_sf_entsize(sfp, namelen)))
+				? xfs_dir3_sf_entsize(mp, sfp, sfep->namelen)
+				: xfs_dir3_sf_entsize(mp, sfp, namelen)))
 			: tmp_sfep;
 	}
 
@@ -2458,7 +2458,7 @@ do_junkit:
 		} else {
 			if (i8 == 0) {
 				tmp_sfep = next_sfep;
-				process_sf_dir2_fixi8(sfp, &tmp_sfep);
+				process_sf_dir2_fixi8(mp, sfp, &tmp_sfep);
 				bytes_deleted +=
 					(__psint_t)next_sfep -
 					(__psint_t)tmp_sfep;
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
