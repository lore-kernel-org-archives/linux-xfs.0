Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TE3fsp104819 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 09:03:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BCC9E4B815
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 07:03:39 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	qxxIRoNJeOjvpwWG for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 07:03:39 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QbvMh-0008H8-9o
	for xfs@oss.sgi.com; Wed, 29 Jun 2011 14:03:39 +0000
Message-Id: <20110629140339.266356959@bombadil.infradead.org>
Date: Wed, 29 Jun 2011 10:01:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 14/27] xfs: cleanup shortform directory inode number handling
References: <20110629140109.003209430@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-dir2_sf-cleanup-inum-handling
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Refactor the shortform directory helpers that deal with the 32-bit vs
64-bit wide inode numbers into more sensible helpers, and kill the
xfs_intino_t typedef that is now superflous.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dir2_sf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.c	2010-05-25 11:40:59.357006075 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.c	2010-05-27 14:48:16.709004470 +0200
@@ -59,6 +59,83 @@ static void xfs_dir2_sf_toino4(xfs_da_ar
 static void xfs_dir2_sf_toino8(xfs_da_args_t *args);
 #endif /* XFS_BIG_INUMS */
 
+
+/*
+ * Inode numbers in short-form directories can come in two versions,
+ * either 4 bytes or 8 bytes wide.  These helpers deal with the
+ * two forms transparently by looking at the headers i8count field.
+ */
+
+static xfs_ino_t
+xfs_dir2_sf_get_ino(
+	struct xfs_dir2_sf	*sfp,
+	xfs_dir2_inou_t		*from)
+{
+	if (sfp->hdr.i8count)
+		return XFS_GET_DIR_INO8(from->i8);
+	else
+		return XFS_GET_DIR_INO4(from->i4);
+}
+static void
+xfs_dir2_sf_put_inumber(
+	struct xfs_dir2_sf	*sfp,
+	xfs_dir2_inou_t		*to,
+	xfs_ino_t		ino)
+{
+	if (sfp->hdr.i8count)
+		XFS_PUT_DIR_INO8(ino, to->i8);
+	else
+		XFS_PUT_DIR_INO4(ino, to->i4);
+}
+
+xfs_ino_t
+xfs_dir2_sf_get_parent_ino(
+	struct xfs_dir2_sf	*sfp)
+{
+	return xfs_dir2_sf_get_ino(sfp, &sfp->hdr.parent);
+}
+
+
+static void
+xfs_dir2_sf_put_parent_ino(
+	struct xfs_dir2_sf	*sfp,
+	xfs_ino_t		ino)
+{
+	xfs_dir2_sf_put_inumber(sfp, &sfp->hdr.parent, ino);
+}
+
+
+/*
+ * In short-form directory entries the inode numbers are stored at variable
+ * offset behind the entry name.  The inode numbers may only be accessed
+ * through the helpers below.
+ */
+
+static xfs_dir2_inou_t *
+xfs_dir2_sf_inop(
+	struct xfs_dir2_sf_entry *sfep)
+{
+	return (xfs_dir2_inou_t *)&sfep->name[sfep->namelen];
+}
+
+xfs_ino_t
+xfs_dir2_sfe_get_ino(
+	struct xfs_dir2_sf	*sfp,
+	struct xfs_dir2_sf_entry *sfep)
+{
+	return xfs_dir2_sf_get_ino(sfp, xfs_dir2_sf_inop(sfep));
+}
+
+static void
+xfs_dir2_sfe_put_ino(
+	struct xfs_dir2_sf	*sfp,
+	struct xfs_dir2_sf_entry *sfep,
+	xfs_ino_t		ino)
+{
+	xfs_dir2_sf_put_inumber(sfp, xfs_dir2_sf_inop(sfep), ino);
+}
+
+
 /*
  * Given a block directory (dp/block), calculate its size as a shortform (sf)
  * directory and a header for the sf directory, if it will fit it the
@@ -138,7 +215,7 @@ xfs_dir2_block_sfsize(
 	 */
 	sfhp->count = count;
 	sfhp->i8count = i8count;
-	xfs_dir2_sf_put_inumber((xfs_dir2_sf_t *)sfhp, &parent, &sfhp->parent);
+	xfs_dir2_sf_put_parent_ino((xfs_dir2_sf_t *)sfhp, parent);
 	return size;
 }
 
@@ -165,7 +242,6 @@ xfs_dir2_block_to_sf(
 	char			*ptr;		/* current data pointer */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform entry */
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
-	xfs_ino_t               temp;
 
 	trace_xfs_dir2_block_to_sf(args);
 
@@ -233,7 +309,7 @@ xfs_dir2_block_to_sf(
 		else if (dep->namelen == 2 &&
 			 dep->name[0] == '.' && dep->name[1] == '.')
 			ASSERT(be64_to_cpu(dep->inumber) ==
-			       xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent));
+			       xfs_dir2_sf_get_parent_ino(sfp));
 		/*
 		 * Normal entry, copy it into shortform.
 		 */
@@ -243,9 +319,9 @@ xfs_dir2_block_to_sf(
 				(xfs_dir2_data_aoff_t)
 				((char *)dep - (char *)block));
 			memcpy(sfep->name, dep->name, dep->namelen);
-			temp = be64_to_cpu(dep->inumber);
-			xfs_dir2_sf_put_inumber(sfp, &temp,
-				xfs_dir2_sf_inumberp(sfep));
+			xfs_dir2_sfe_put_ino(sfp, sfep,
+					     be64_to_cpu(dep->inumber));
+
 			sfep = xfs_dir2_sf_nextentry(sfp, sfep);
 		}
 		ptr += xfs_dir2_data_entsize(dep->namelen);
@@ -406,8 +482,7 @@ xfs_dir2_sf_addname_easy(
 	sfep->namelen = args->namelen;
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
-	xfs_dir2_sf_put_inumber(sfp, &args->inumber,
-		xfs_dir2_sf_inumberp(sfep));
+	xfs_dir2_sfe_put_ino(sfp, sfep, args->inumber);
 	/*
 	 * Update the header and inode.
 	 */
@@ -498,8 +573,7 @@ xfs_dir2_sf_addname_hard(
 	sfep->namelen = args->namelen;
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
-	xfs_dir2_sf_put_inumber(sfp, &args->inumber,
-		xfs_dir2_sf_inumberp(sfep));
+	xfs_dir2_sfe_put_ino(sfp, sfep, args->inumber);
 	sfp->hdr.count++;
 #if XFS_BIG_INUMS
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
@@ -618,14 +692,14 @@ xfs_dir2_sf_check(
 
 	sfp = (xfs_dir2_sf_t *)dp->i_df.if_u1.if_data;
 	offset = XFS_DIR2_DATA_FIRST_OFFSET;
-	ino = xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
+	ino = xfs_dir2_sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 	     i < sfp->hdr.count;
 	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
 		ASSERT(xfs_dir2_sf_get_offset(sfep) >= offset);
-		ino = xfs_dir2_sf_get_inumber(sfp, xfs_dir2_sf_inumberp(sfep));
+		ino = xfs_dir2_sfe_get_ino(sfp, sfep);
 		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
 		offset =
 			xfs_dir2_sf_get_offset(sfep) +
@@ -686,7 +760,7 @@ xfs_dir2_sf_create(
 	/*
 	 * Now can put in the inode number, since i8count is set.
 	 */
-	xfs_dir2_sf_put_inumber(sfp, &pino, &sfp->hdr.parent);
+	xfs_dir2_sf_put_parent_ino(sfp, pino);
 	sfp->hdr.count = 0;
 	dp->i_d.di_size = size;
 	xfs_dir2_sf_check(args);
@@ -759,7 +833,7 @@ xfs_dir2_sf_getdents(
 	 * Put .. entry unless we're starting past it.
 	 */
 	if (*offset <= dotdot_offset) {
-		ino = xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
+		ino = xfs_dir2_sf_get_parent_ino(sfp);
 		if (filldir(dirent, "..", 2, dotdot_offset & 0x7fffffff, ino, DT_DIR)) {
 			*offset = dotdot_offset & 0x7fffffff;
 			return 0;
@@ -779,7 +853,7 @@ xfs_dir2_sf_getdents(
 			continue;
 		}
 
-		ino = xfs_dir2_sf_get_inumber(sfp, xfs_dir2_sf_inumberp(sfep));
+		ino = xfs_dir2_sfe_get_ino(sfp, sfep);
 		if (filldir(dirent, (char *)sfep->name, sfep->namelen,
 			    off & 0x7fffffff, ino, DT_UNKNOWN)) {
 			*offset = off & 0x7fffffff;
@@ -839,7 +913,7 @@ xfs_dir2_sf_lookup(
 	 */
 	if (args->namelen == 2 &&
 	    args->name[0] == '.' && args->name[1] == '.') {
-		args->inumber = xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
+		args->inumber = xfs_dir2_sf_get_parent_ino(sfp);
 		args->cmpresult = XFS_CMP_EXACT;
 		return XFS_ERROR(EEXIST);
 	}
@@ -858,8 +932,7 @@ xfs_dir2_sf_lookup(
 								sfep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
-			args->inumber = xfs_dir2_sf_get_inumber(sfp,
-						xfs_dir2_sf_inumberp(sfep));
+			args->inumber = xfs_dir2_sfe_get_ino(sfp, sfep);
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
 			ci_sfep = sfep;
@@ -918,9 +991,8 @@ xfs_dir2_sf_removename(
 				i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
 		if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
-			ASSERT(xfs_dir2_sf_get_inumber(sfp,
-						xfs_dir2_sf_inumberp(sfep)) ==
-								args->inumber);
+			ASSERT(xfs_dir2_sfe_get_ino(sfp, sfep) ==
+			       args->inumber);
 			break;
 		}
 	}
@@ -1040,10 +1112,10 @@ xfs_dir2_sf_replace(
 	if (args->namelen == 2 &&
 	    args->name[0] == '.' && args->name[1] == '.') {
 #if XFS_BIG_INUMS || defined(DEBUG)
-		ino = xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
+		ino = xfs_dir2_sf_get_parent_ino(sfp);
 		ASSERT(args->inumber != ino);
 #endif
-		xfs_dir2_sf_put_inumber(sfp, &args->inumber, &sfp->hdr.parent);
+		xfs_dir2_sf_put_parent_ino(sfp, args->inumber);
 	}
 	/*
 	 * Normal entry, look for the name.
@@ -1055,12 +1127,10 @@ xfs_dir2_sf_replace(
 			if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
 #if XFS_BIG_INUMS || defined(DEBUG)
-				ino = xfs_dir2_sf_get_inumber(sfp,
-					xfs_dir2_sf_inumberp(sfep));
+				ino = xfs_dir2_sfe_get_ino(sfp, sfep);
 				ASSERT(args->inumber != ino);
 #endif
-				xfs_dir2_sf_put_inumber(sfp, &args->inumber,
-					xfs_dir2_sf_inumberp(sfep));
+				xfs_dir2_sfe_put_ino(sfp, sfep, args->inumber);
 				break;
 			}
 		}
@@ -1121,7 +1191,6 @@ xfs_dir2_sf_toino4(
 	char			*buf;		/* old dir's buffer */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			i;		/* entry index */
-	xfs_ino_t		ino;		/* entry inode number */
 	int			newsize;	/* new inode size */
 	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
 	xfs_dir2_sf_t		*oldsfp;	/* old sf directory */
@@ -1162,8 +1231,7 @@ xfs_dir2_sf_toino4(
 	 */
 	sfp->hdr.count = oldsfp->hdr.count;
 	sfp->hdr.i8count = 0;
-	ino = xfs_dir2_sf_get_inumber(oldsfp, &oldsfp->hdr.parent);
-	xfs_dir2_sf_put_inumber(sfp, &ino, &sfp->hdr.parent);
+	xfs_dir2_sf_put_parent_ino(sfp, xfs_dir2_sf_get_parent_ino(oldsfp));
 	/*
 	 * Copy the entries field by field.
 	 */
@@ -1175,9 +1243,8 @@ xfs_dir2_sf_toino4(
 		sfep->namelen = oldsfep->namelen;
 		sfep->offset = oldsfep->offset;
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
-		ino = xfs_dir2_sf_get_inumber(oldsfp,
-			xfs_dir2_sf_inumberp(oldsfep));
-		xfs_dir2_sf_put_inumber(sfp, &ino, xfs_dir2_sf_inumberp(sfep));
+		xfs_dir2_sfe_put_ino(sfp, sfep,
+			xfs_dir2_sfe_get_ino(oldsfp, oldsfep));
 	}
 	/*
 	 * Clean up the inode.
@@ -1199,7 +1266,6 @@ xfs_dir2_sf_toino8(
 	char			*buf;		/* old dir's buffer */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			i;		/* entry index */
-	xfs_ino_t		ino;		/* entry inode number */
 	int			newsize;	/* new inode size */
 	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
 	xfs_dir2_sf_t		*oldsfp;	/* old sf directory */
@@ -1240,8 +1306,7 @@ xfs_dir2_sf_toino8(
 	 */
 	sfp->hdr.count = oldsfp->hdr.count;
 	sfp->hdr.i8count = 1;
-	ino = xfs_dir2_sf_get_inumber(oldsfp, &oldsfp->hdr.parent);
-	xfs_dir2_sf_put_inumber(sfp, &ino, &sfp->hdr.parent);
+	xfs_dir2_sf_put_parent_ino(sfp, xfs_dir2_sf_get_parent_ino(oldsfp));
 	/*
 	 * Copy the entries field by field.
 	 */
@@ -1253,9 +1318,8 @@ xfs_dir2_sf_toino8(
 		sfep->namelen = oldsfep->namelen;
 		sfep->offset = oldsfep->offset;
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
-		ino = xfs_dir2_sf_get_inumber(oldsfp,
-			xfs_dir2_sf_inumberp(oldsfep));
-		xfs_dir2_sf_put_inumber(sfp, &ino, xfs_dir2_sf_inumberp(sfep));
+		xfs_dir2_sfe_put_ino(sfp, sfep,
+			xfs_dir2_sfe_get_ino(oldsfp, oldsfep));
 	}
 	/*
 	 * Clean up the inode.
Index: xfs/fs/xfs/xfs_dir2_sf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.h	2010-05-18 13:04:38.259255428 +0200
+++ xfs/fs/xfs/xfs_dir2_sf.h	2010-05-27 14:48:16.710004889 +0200
@@ -90,28 +90,6 @@ static inline int xfs_dir2_sf_hdr_size(i
 		((uint)sizeof(xfs_dir2_ino8_t) - (uint)sizeof(xfs_dir2_ino4_t)));
 }
 
-static inline xfs_dir2_inou_t *xfs_dir2_sf_inumberp(xfs_dir2_sf_entry_t *sfep)
-{
-	return (xfs_dir2_inou_t *)&(sfep)->name[(sfep)->namelen];
-}
-
-static inline xfs_intino_t
-xfs_dir2_sf_get_inumber(xfs_dir2_sf_t *sfp, xfs_dir2_inou_t *from)
-{
-	return ((sfp)->hdr.i8count == 0 ? \
-		(xfs_intino_t)XFS_GET_DIR_INO4((from)->i4) : \
-		(xfs_intino_t)XFS_GET_DIR_INO8((from)->i8));
-}
-
-static inline void xfs_dir2_sf_put_inumber(xfs_dir2_sf_t *sfp, xfs_ino_t *from,
-						xfs_dir2_inou_t *to)
-{
-	if ((sfp)->hdr.i8count == 0)
-		XFS_PUT_DIR_INO4(*(from), (to)->i4);
-	else
-		XFS_PUT_DIR_INO8(*(from), (to)->i8);
-}
-
 static inline xfs_dir2_data_aoff_t
 xfs_dir2_sf_get_offset(xfs_dir2_sf_entry_t *sfep)
 {
@@ -155,6 +133,9 @@ xfs_dir2_sf_nextentry(xfs_dir2_sf_t *sfp
 /*
  * Functions.
  */
+extern xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf *sfp);
+extern xfs_ino_t xfs_dir2_sfe_get_ino(struct xfs_dir2_sf *sfp,
+				      struct xfs_dir2_sf_entry *sfep);
 extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
 				 struct xfs_dir2_block *block,
 				 xfs_dir2_sf_hdr_t *sfhp);
Index: xfs/fs/xfs/xfs_inum.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inum.h	2010-05-18 13:04:38.266255847 +0200
+++ xfs/fs/xfs/xfs_inum.h	2010-05-27 14:48:16.712037505 +0200
@@ -28,17 +28,6 @@
 
 typedef	__uint32_t	xfs_agino_t;	/* within allocation grp inode number */
 
-/*
- * Useful inode bits for this kernel.
- * Used in some places where having 64-bits in the 32-bit kernels
- * costs too much.
- */
-#if XFS_BIG_INUMS
-typedef	xfs_ino_t	xfs_intino_t;
-#else
-typedef	__uint32_t	xfs_intino_t;
-#endif
-
 #define	NULLFSINO	((xfs_ino_t)-1)
 #define	NULLAGINO	((xfs_agino_t)-1)
 
Index: xfs/fs/xfs/xfs_dir2_block.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.c	2010-05-25 11:40:59.336004958 +0200
+++ xfs/fs/xfs/xfs_dir2_block.c	2010-05-27 14:48:16.718003421 +0200
@@ -1146,7 +1146,7 @@ xfs_dir2_sf_to_block(
 	 */
 	dep = (xfs_dir2_data_entry_t *)
 		((char *)block + XFS_DIR2_DATA_DOTDOT_OFFSET);
-	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent));
+	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
 	tagp = xfs_dir2_data_entry_tag_p(dep);
@@ -1195,8 +1195,7 @@ xfs_dir2_sf_to_block(
 		 * Copy a real entry.
 		 */
 		dep = (xfs_dir2_data_entry_t *)((char *)block + newoffset);
-		dep->inumber = cpu_to_be64(xfs_dir2_sf_get_inumber(sfp,
-				xfs_dir2_sf_inumberp(sfep)));
+		dep->inumber = cpu_to_be64(xfs_dir2_sfe_get_ino(sfp, sfep));
 		dep->namelen = sfep->namelen;
 		memcpy(dep->name, sfep->name, dep->namelen);
 		tagp = xfs_dir2_data_entry_tag_p(dep);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
