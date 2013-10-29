Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C80947F72
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 06:12:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27568AC053
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 04:12:16 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	TZdz1H56gyiqgqyX for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 04:12:13 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vb7DM-0000PO-Ve
	for xfs@oss.sgi.com; Tue, 29 Oct 2013 22:12:01 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vb7DM-00087I-U2
	for xfs@oss.sgi.com; Tue, 29 Oct 2013 22:12:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/15] xfs: vectorise remaining shortform dir2 ops
Date: Tue, 29 Oct 2013 22:11:47 +1100
Message-Id: <1383045118-31107-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1383045118-31107-1-git-send-email-david@fromorbit.com>
References: <1383045118-31107-1-git-send-email-david@fromorbit.com>
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

Following from the initial patch to introduce the directory
operations vector, convert the rest of the shortform directory
operations to use vectored ops rather than superblock feature
checks. This further reduces the size of the built binary:

   text    data     bss     dec     hex filename
 794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
 792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
 792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_da_format.c    | 152 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_da_format.h    |  47 --------------
 fs/xfs/xfs_dir2.h         |  20 +++---
 fs/xfs/xfs_dir2_block.c   |   6 +-
 fs/xfs/xfs_dir2_readdir.c |   6 +-
 fs/xfs/xfs_dir2_sf.c      | 151 +++++++++------------------------------------
 6 files changed, 199 insertions(+), 183 deletions(-)

diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
index 982d105..62f55a0 100644
--- a/fs/xfs/xfs_da_format.c
+++ b/fs/xfs/xfs_da_format.c
@@ -69,17 +69,169 @@ xfs_dir3_sf_nextentry(
 }
 
 
+/*
+ * For filetype enabled shortform directories, the file type field is stored at
+ * the end of the name.  Because it's only a single byte, endian conversion is
+ * not necessary. For non-filetype enable directories, the type is always
+ * unknown and we never store the value.
+ */
+static __uint8_t
+xfs_dir2_sfe_get_ftype(
+	struct xfs_dir2_sf_entry *sfep)
+{
+	return XFS_DIR3_FT_UNKNOWN;
+}
+
+static void
+xfs_dir2_sfe_put_ftype(
+	struct xfs_dir2_sf_entry *sfep,
+	__uint8_t		ftype)
+{
+	ASSERT(ftype < XFS_DIR3_FT_MAX);
+}
+
+static __uint8_t
+xfs_dir3_sfe_get_ftype(
+	struct xfs_dir2_sf_entry *sfep)
+{
+	__uint8_t	ftype;
+
+	ftype = sfep->name[sfep->namelen];
+	if (ftype >= XFS_DIR3_FT_MAX)
+		return XFS_DIR3_FT_UNKNOWN;
+	return ftype;
+}
+
+static void
+xfs_dir3_sfe_put_ftype(
+	struct xfs_dir2_sf_entry *sfep,
+	__uint8_t		ftype)
+{
+	ASSERT(ftype < XFS_DIR3_FT_MAX);
+
+	sfep->name[sfep->namelen] = ftype;
+}
+
+/*
+ * Inode numbers in short-form directories can come in two versions,
+ * either 4 bytes or 8 bytes wide.  These helpers deal with the
+ * two forms transparently by looking at the headers i8count field.
+ *
+ * For 64-bit inode number the most significant byte must be zero.
+ */
+static xfs_ino_t
+xfs_dir2_sf_get_ino(
+	struct xfs_dir2_sf_hdr	*hdr,
+	xfs_dir2_inou_t		*from)
+{
+	if (hdr->i8count)
+		return get_unaligned_be64(&from->i8.i) & 0x00ffffffffffffffULL;
+	else
+		return get_unaligned_be32(&from->i4.i);
+}
+
+static void
+xfs_dir2_sf_put_ino(
+	struct xfs_dir2_sf_hdr	*hdr,
+	xfs_dir2_inou_t		*to,
+	xfs_ino_t		ino)
+{
+	ASSERT((ino & 0xff00000000000000ULL) == 0);
+
+	if (hdr->i8count)
+		put_unaligned_be64(ino, &to->i8.i);
+	else
+		put_unaligned_be32(ino, &to->i4.i);
+}
+
+static xfs_ino_t
+xfs_dir2_sf_get_parent_ino(
+	struct xfs_dir2_sf_hdr	*hdr)
+{
+	return xfs_dir2_sf_get_ino(hdr, &hdr->parent);
+}
+
+static void
+xfs_dir2_sf_put_parent_ino(
+	struct xfs_dir2_sf_hdr	*hdr,
+	xfs_ino_t		ino)
+{
+	xfs_dir2_sf_put_ino(hdr, &hdr->parent, ino);
+}
+
+/*
+ * In short-form directory entries the inode numbers are stored at variable
+ * offset behind the entry name. If the entry stores a filetype value, then it
+ * sits between the name and the inode number. Hence the inode numbers may only
+ * be accessed through the helpers below.
+ */
+static xfs_ino_t
+xfs_dir2_sfe_get_ino(
+	struct xfs_dir2_sf_hdr	*hdr,
+	struct xfs_dir2_sf_entry *sfep)
+{
+	return xfs_dir2_sf_get_ino(hdr,
+				(xfs_dir2_inou_t *)&sfep->name[sfep->namelen]);
+}
+
+static void
+xfs_dir2_sfe_put_ino(
+	struct xfs_dir2_sf_hdr	*hdr,
+	struct xfs_dir2_sf_entry *sfep,
+	xfs_ino_t		ino)
+{
+	xfs_dir2_sf_put_ino(hdr,
+			    (xfs_dir2_inou_t *)&sfep->name[sfep->namelen], ino);
+}
+
+static xfs_ino_t
+xfs_dir3_sfe_get_ino(
+	struct xfs_dir2_sf_hdr	*hdr,
+	struct xfs_dir2_sf_entry *sfep)
+{
+	return xfs_dir2_sf_get_ino(hdr,
+			(xfs_dir2_inou_t *)&sfep->name[sfep->namelen + 1]);
+}
+
+static void
+xfs_dir3_sfe_put_ino(
+	struct xfs_dir2_sf_hdr	*hdr,
+	struct xfs_dir2_sf_entry *sfep,
+	xfs_ino_t		ino)
+{
+	xfs_dir2_sf_put_ino(hdr,
+			(xfs_dir2_inou_t *)&sfep->name[sfep->namelen + 1], ino);
+}
+
 const struct xfs_dir_ops xfs_dir2_ops = {
 	.sf_entsize = xfs_dir2_sf_entsize,
 	.sf_nextentry = xfs_dir2_sf_nextentry,
+	.sf_get_ftype = xfs_dir2_sfe_get_ftype,
+	.sf_put_ftype = xfs_dir2_sfe_put_ftype,
+	.sf_get_ino = xfs_dir2_sfe_get_ino,
+	.sf_put_ino = xfs_dir2_sfe_put_ino,
+	.sf_get_parent_ino = xfs_dir2_sf_get_parent_ino,
+	.sf_put_parent_ino = xfs_dir2_sf_put_parent_ino,
 };
 
 const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.sf_entsize = xfs_dir3_sf_entsize,
 	.sf_nextentry = xfs_dir3_sf_nextentry,
+	.sf_get_ftype = xfs_dir3_sfe_get_ftype,
+	.sf_put_ftype = xfs_dir3_sfe_put_ftype,
+	.sf_get_ino = xfs_dir3_sfe_get_ino,
+	.sf_put_ino = xfs_dir3_sfe_put_ino,
+	.sf_get_parent_ino = xfs_dir2_sf_get_parent_ino,
+	.sf_put_parent_ino = xfs_dir2_sf_put_parent_ino,
 };
 
 const struct xfs_dir_ops xfs_dir3_ops = {
 	.sf_entsize = xfs_dir3_sf_entsize,
 	.sf_nextentry = xfs_dir3_sf_nextentry,
+	.sf_get_ftype = xfs_dir3_sfe_get_ftype,
+	.sf_put_ftype = xfs_dir3_sfe_put_ftype,
+	.sf_get_ino = xfs_dir3_sfe_get_ino,
+	.sf_put_ino = xfs_dir3_sfe_put_ino,
+	.sf_get_parent_ino = xfs_dir2_sf_get_parent_ino,
+	.sf_put_parent_ino = xfs_dir2_sf_put_parent_ino,
 };
diff --git a/fs/xfs/xfs_da_format.h b/fs/xfs/xfs_da_format.h
index d54726d..68c2ad5 100644
--- a/fs/xfs/xfs_da_format.h
+++ b/fs/xfs/xfs_da_format.h
@@ -330,53 +330,6 @@ xfs_dir2_sf_firstentry(struct xfs_dir2_sf_hdr *hdr)
 }
 
 /*
- * in dir3 shortform directories, the file type field is stored at a variable
- * offset after the inode number. Because it's only a single byte, endian
- * conversion is not necessary.
- */
-static inline __uint8_t *
-xfs_dir3_sfe_ftypep(
-	struct xfs_dir2_sf_hdr	*hdr,
-	struct xfs_dir2_sf_entry *sfep)
-{
-	return (__uint8_t *)&sfep->name[sfep->namelen];
-}
-
-static inline __uint8_t
-xfs_dir3_sfe_get_ftype(
-	struct xfs_mount	*mp,
-	struct xfs_dir2_sf_hdr	*hdr,
-	struct xfs_dir2_sf_entry *sfep)
-{
-	__uint8_t	*ftp;
-
-	if (!xfs_sb_version_hasftype(&mp->m_sb))
-		return XFS_DIR3_FT_UNKNOWN;
-
-	ftp = xfs_dir3_sfe_ftypep(hdr, sfep);
-	if (*ftp >= XFS_DIR3_FT_MAX)
-		return XFS_DIR3_FT_UNKNOWN;
-	return *ftp;
-}
-
-static inline void
-xfs_dir3_sfe_put_ftype(
-	struct xfs_mount	*mp,
-	struct xfs_dir2_sf_hdr	*hdr,
-	struct xfs_dir2_sf_entry *sfep,
-	__uint8_t		ftype)
-{
-	__uint8_t	*ftp;
-
-	ASSERT(ftype < XFS_DIR3_FT_MAX);
-
-	if (!xfs_sb_version_hasftype(&mp->m_sb))
-		return;
-	ftp = xfs_dir3_sfe_ftypep(hdr, sfep);
-	*ftp = ftype;
-}
-
-/*
  * Data block structures.
  *
  * A pure data block looks like the following drawing on disk:
diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index 1909d9f..0e94b3e 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -39,6 +39,17 @@ struct xfs_dir_ops {
 	struct xfs_dir2_sf_entry *
 		(*sf_nextentry)(struct xfs_dir2_sf_hdr *hdr,
 				struct xfs_dir2_sf_entry *sfep);
+	__uint8_t (*sf_get_ftype)(struct xfs_dir2_sf_entry *sfep);
+	void	(*sf_put_ftype)(struct xfs_dir2_sf_entry *sfep,
+				__uint8_t ftype);
+	xfs_ino_t (*sf_get_ino)(struct xfs_dir2_sf_hdr *hdr,
+				struct xfs_dir2_sf_entry *sfep);
+	void	(*sf_put_ino)(struct xfs_dir2_sf_hdr *hdr,
+			      struct xfs_dir2_sf_entry *sfep,
+			      xfs_ino_t ino);
+	xfs_ino_t (*sf_get_parent_ino)(struct xfs_dir2_sf_hdr *hdr);
+	void	(*sf_put_parent_ino)(struct xfs_dir2_sf_hdr *hdr,
+				     xfs_ino_t ino);
 };
 
 extern const struct xfs_dir_ops xfs_dir2_ops;
@@ -79,15 +90,6 @@ extern int xfs_dir2_sf_to_block(struct xfs_da_args *args);
 /*
  * Interface routines used by userspace utilities
  */
-extern xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *sfp);
-extern void xfs_dir2_sf_put_parent_ino(struct xfs_dir2_sf_hdr *sfp,
-		xfs_ino_t ino);
-extern xfs_ino_t xfs_dir3_sfe_get_ino(struct xfs_mount *mp,
-		struct xfs_dir2_sf_hdr *sfp, struct xfs_dir2_sf_entry *sfep);
-extern void xfs_dir3_sfe_put_ino(struct xfs_mount *mp,
-		struct xfs_dir2_sf_hdr *hdr, struct xfs_dir2_sf_entry *sfep,
-		xfs_ino_t ino);
-
 extern int xfs_dir2_isblock(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
 extern int xfs_dir2_isleaf(struct xfs_trans *tp, struct xfs_inode *dp, int *r);
 extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 9d86b6f..960f3ab 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -1173,7 +1173,7 @@ xfs_dir2_sf_to_block(
 	 * Create entry for ..
 	 */
 	dep = xfs_dir3_data_dotdot_entry_p(mp, hdr);
-	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
+	dep->inumber = cpu_to_be64(dp->d_ops->sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
 	xfs_dir3_dirent_put_ftype(mp, dep, XFS_DIR3_FT_DIR);
@@ -1222,10 +1222,10 @@ xfs_dir2_sf_to_block(
 		 * Copy a real entry.
 		 */
 		dep = (xfs_dir2_data_entry_t *)((char *)hdr + newoffset);
-		dep->inumber = cpu_to_be64(xfs_dir3_sfe_get_ino(mp, sfp, sfep));
+		dep->inumber = cpu_to_be64(dp->d_ops->sf_get_ino(sfp, sfep));
 		dep->namelen = sfep->namelen;
 		xfs_dir3_dirent_put_ftype(mp, dep,
-					xfs_dir3_sfe_get_ftype(mp, sfp, sfep));
+					  dp->d_ops->sf_get_ftype(sfep));
 		memcpy(dep->name, sfep->name, dep->namelen);
 		tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 8033305..2d2c8fb 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -136,7 +136,7 @@ xfs_dir2_sf_getdents(
 	 * Put .. entry unless we're starting past it.
 	 */
 	if (ctx->pos <= dotdot_offset) {
-		ino = xfs_dir2_sf_get_parent_ino(sfp);
+		ino = dp->d_ops->sf_get_parent_ino(sfp);
 		ctx->pos = dotdot_offset & 0x7fffffff;
 		if (!dir_emit(ctx, "..", 2, ino, DT_DIR))
 			return 0;
@@ -157,8 +157,8 @@ xfs_dir2_sf_getdents(
 			continue;
 		}
 
-		ino = xfs_dir3_sfe_get_ino(mp, sfp, sfep);
-		filetype = xfs_dir3_sfe_get_ftype(mp, sfp, sfep);
+		ino = dp->d_ops->sf_get_ino(sfp, sfep);
+		filetype = dp->d_ops->sf_get_ftype(sfep);
 		ctx->pos = off & 0x7fffffff;
 		if (!dir_emit(ctx, (char *)sfep->name, sfep->namelen, ino,
 			    xfs_dir3_get_dtype(mp, filetype)))
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 73881c9..ec0d39b 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -57,89 +57,6 @@ static void xfs_dir2_sf_toino8(xfs_da_args_t *args);
 #endif /* XFS_BIG_INUMS */
 
 /*
- * Inode numbers in short-form directories can come in two versions,
- * either 4 bytes or 8 bytes wide.  These helpers deal with the
- * two forms transparently by looking at the headers i8count field.
- *
- * For 64-bit inode number the most significant byte must be zero.
- */
-static xfs_ino_t
-xfs_dir2_sf_get_ino(
-	struct xfs_dir2_sf_hdr	*hdr,
-	xfs_dir2_inou_t		*from)
-{
-	if (hdr->i8count)
-		return get_unaligned_be64(&from->i8.i) & 0x00ffffffffffffffULL;
-	else
-		return get_unaligned_be32(&from->i4.i);
-}
-
-static void
-xfs_dir2_sf_put_ino(
-	struct xfs_dir2_sf_hdr	*hdr,
-	xfs_dir2_inou_t		*to,
-	xfs_ino_t		ino)
-{
-	ASSERT((ino & 0xff00000000000000ULL) == 0);
-
-	if (hdr->i8count)
-		put_unaligned_be64(ino, &to->i8.i);
-	else
-		put_unaligned_be32(ino, &to->i4.i);
-}
-
-xfs_ino_t
-xfs_dir2_sf_get_parent_ino(
-	struct xfs_dir2_sf_hdr	*hdr)
-{
-	return xfs_dir2_sf_get_ino(hdr, &hdr->parent);
-}
-
-void
-xfs_dir2_sf_put_parent_ino(
-	struct xfs_dir2_sf_hdr	*hdr,
-	xfs_ino_t		ino)
-{
-	xfs_dir2_sf_put_ino(hdr, &hdr->parent, ino);
-}
-
-/*
- * In short-form directory entries the inode numbers are stored at variable
- * offset behind the entry name. If the entry stores a filetype value, then it
- * sits between the name and the inode number. Hence the inode numbers may only
- * be accessed through the helpers below.
- */
-static xfs_dir2_inou_t *
-xfs_dir3_sfe_inop(
-	struct xfs_mount	*mp,
-	struct xfs_dir2_sf_entry *sfep)
-{
-	__uint8_t	*ptr = &sfep->name[sfep->namelen];
-	if (xfs_sb_version_hasftype(&mp->m_sb))
-		ptr++;
-	return (xfs_dir2_inou_t *)ptr;
-}
-
-xfs_ino_t
-xfs_dir3_sfe_get_ino(
-	struct xfs_mount	*mp,
-	struct xfs_dir2_sf_hdr	*hdr,
-	struct xfs_dir2_sf_entry *sfep)
-{
-	return xfs_dir2_sf_get_ino(hdr, xfs_dir3_sfe_inop(mp, sfep));
-}
-
-void
-xfs_dir3_sfe_put_ino(
-	struct xfs_mount	*mp,
-	struct xfs_dir2_sf_hdr	*hdr,
-	struct xfs_dir2_sf_entry *sfep,
-	xfs_ino_t		ino)
-{
-	xfs_dir2_sf_put_ino(hdr, xfs_dir3_sfe_inop(mp, sfep), ino);
-}
-
-/*
  * Given a block directory (dp/block), calculate its size as a shortform (sf)
  * directory and a header for the sf directory, if it will fit it the
  * space currently present in the inode.  If it won't fit, the output
@@ -226,7 +143,7 @@ xfs_dir2_block_sfsize(
 	 */
 	sfhp->count = count;
 	sfhp->i8count = i8count;
-	xfs_dir2_sf_put_parent_ino(sfhp, parent);
+	dp->d_ops->sf_put_parent_ino(sfhp, parent);
 	return size;
 }
 
@@ -321,7 +238,7 @@ xfs_dir2_block_to_sf(
 		else if (dep->namelen == 2 &&
 			 dep->name[0] == '.' && dep->name[1] == '.')
 			ASSERT(be64_to_cpu(dep->inumber) ==
-			       xfs_dir2_sf_get_parent_ino(sfp));
+			       dp->d_ops->sf_get_parent_ino(sfp));
 		/*
 		 * Normal entry, copy it into shortform.
 		 */
@@ -331,9 +248,9 @@ xfs_dir2_block_to_sf(
 				(xfs_dir2_data_aoff_t)
 				((char *)dep - (char *)hdr));
 			memcpy(sfep->name, dep->name, dep->namelen);
-			xfs_dir3_sfe_put_ino(mp, sfp, sfep,
-					     be64_to_cpu(dep->inumber));
-			xfs_dir3_sfe_put_ftype(mp, sfp, sfep,
+			dp->d_ops->sf_put_ino(sfp, sfep,
+					      be64_to_cpu(dep->inumber));
+			dp->d_ops->sf_put_ftype(sfep,
 					xfs_dir3_dirent_get_ftype(mp, dep));
 
 			sfep = dp->d_ops->sf_nextentry(sfp, sfep);
@@ -496,8 +413,8 @@ xfs_dir2_sf_addname_easy(
 	sfep->namelen = args->namelen;
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
-	xfs_dir3_sfe_put_ino(dp->i_mount, sfp, sfep, args->inumber);
-	xfs_dir3_sfe_put_ftype(dp->i_mount, sfp, sfep, args->filetype);
+	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
+	dp->d_ops->sf_put_ftype(sfep, args->filetype);
 
 	/*
 	 * Update the header and inode.
@@ -591,8 +508,8 @@ xfs_dir2_sf_addname_hard(
 	sfep->namelen = args->namelen;
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
-	xfs_dir3_sfe_put_ino(mp, sfp, sfep, args->inumber);
-	xfs_dir3_sfe_put_ftype(mp, sfp, sfep, args->filetype);
+	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
+	dp->d_ops->sf_put_ftype(sfep, args->filetype);
 	sfp->count++;
 #if XFS_BIG_INUMS
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
@@ -713,20 +630,19 @@ xfs_dir2_sf_check(
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	offset = xfs_dir3_data_first_offset(mp);
-	ino = xfs_dir2_sf_get_parent_ino(sfp);
+	ino = dp->d_ops->sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 	     i < sfp->count;
 	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep)) {
 		ASSERT(xfs_dir2_sf_get_offset(sfep) >= offset);
-		ino = xfs_dir3_sfe_get_ino(mp, sfp, sfep);
+		ino = dp->d_ops->sf_get_ino(sfp, sfep);
 		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
 		offset =
 			xfs_dir2_sf_get_offset(sfep) +
 			xfs_dir3_data_entsize(mp, sfep->namelen);
-		ASSERT(xfs_dir3_sfe_get_ftype(mp, sfp, sfep) <
-							XFS_DIR3_FT_MAX);
+		ASSERT(dp->d_ops->sf_get_ftype(sfep) < XFS_DIR3_FT_MAX);
 	}
 	ASSERT(i8count == sfp->i8count);
 	ASSERT(XFS_BIG_INUMS || i8count == 0);
@@ -782,7 +698,7 @@ xfs_dir2_sf_create(
 	/*
 	 * Now can put in the inode number, since i8count is set.
 	 */
-	xfs_dir2_sf_put_parent_ino(sfp, pino);
+	dp->d_ops->sf_put_parent_ino(sfp, pino);
 	sfp->count = 0;
 	dp->i_d.di_size = size;
 	xfs_dir2_sf_check(args);
@@ -837,7 +753,7 @@ xfs_dir2_sf_lookup(
 	 */
 	if (args->namelen == 2 &&
 	    args->name[0] == '.' && args->name[1] == '.') {
-		args->inumber = xfs_dir2_sf_get_parent_ino(sfp);
+		args->inumber = dp->d_ops->sf_get_parent_ino(sfp);
 		args->cmpresult = XFS_CMP_EXACT;
 		args->filetype = XFS_DIR3_FT_DIR;
 		return XFS_ERROR(EEXIST);
@@ -857,10 +773,8 @@ xfs_dir2_sf_lookup(
 								sfep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
-			args->inumber = xfs_dir3_sfe_get_ino(dp->i_mount,
-							     sfp, sfep);
-			args->filetype = xfs_dir3_sfe_get_ftype(dp->i_mount,
-								sfp, sfep);
+			args->inumber = dp->d_ops->sf_get_ino(sfp, sfep);
+			args->filetype = dp->d_ops->sf_get_ftype(sfep);
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
 			ci_sfep = sfep;
@@ -919,7 +833,7 @@ xfs_dir2_sf_removename(
 	     i++, sfep = dp->d_ops->sf_nextentry(sfp, sfep)) {
 		if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
-			ASSERT(xfs_dir3_sfe_get_ino(dp->i_mount, sfp, sfep) ==
+			ASSERT(dp->d_ops->sf_get_ino(sfp, sfep) ==
 			       args->inumber);
 			break;
 		}
@@ -1040,10 +954,10 @@ xfs_dir2_sf_replace(
 	if (args->namelen == 2 &&
 	    args->name[0] == '.' && args->name[1] == '.') {
 #if XFS_BIG_INUMS || defined(DEBUG)
-		ino = xfs_dir2_sf_get_parent_ino(sfp);
+		ino = dp->d_ops->sf_get_parent_ino(sfp);
 		ASSERT(args->inumber != ino);
 #endif
-		xfs_dir2_sf_put_parent_ino(sfp, args->inumber);
+		dp->d_ops->sf_put_parent_ino(sfp, args->inumber);
 	}
 	/*
 	 * Normal entry, look for the name.
@@ -1054,14 +968,11 @@ xfs_dir2_sf_replace(
 			if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
 #if XFS_BIG_INUMS || defined(DEBUG)
-				ino = xfs_dir3_sfe_get_ino(dp->i_mount,
-							   sfp, sfep);
+				ino = dp->d_ops->sf_get_ino(sfp, sfep);
 				ASSERT(args->inumber != ino);
 #endif
-				xfs_dir3_sfe_put_ino(dp->i_mount, sfp, sfep,
-						     args->inumber);
-				xfs_dir3_sfe_put_ftype(dp->i_mount, sfp, sfep,
-						       args->filetype);
+				dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
+				dp->d_ops->sf_put_ftype(sfep, args->filetype);
 				break;
 			}
 		}
@@ -1164,7 +1075,7 @@ xfs_dir2_sf_toino4(
 	 */
 	sfp->count = oldsfp->count;
 	sfp->i8count = 0;
-	xfs_dir2_sf_put_parent_ino(sfp, xfs_dir2_sf_get_parent_ino(oldsfp));
+	dp->d_ops->sf_put_parent_ino(sfp, dp->d_ops->sf_get_parent_ino(oldsfp));
 	/*
 	 * Copy the entries field by field.
 	 */
@@ -1176,10 +1087,9 @@ xfs_dir2_sf_toino4(
 		sfep->namelen = oldsfep->namelen;
 		sfep->offset = oldsfep->offset;
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
-		xfs_dir3_sfe_put_ino(mp, sfp, sfep,
-			xfs_dir3_sfe_get_ino(mp, oldsfp, oldsfep));
-		xfs_dir3_sfe_put_ftype(mp, sfp, sfep,
-			xfs_dir3_sfe_get_ftype(mp, oldsfp, oldsfep));
+		dp->d_ops->sf_put_ino(sfp, sfep,
+				      dp->d_ops->sf_get_ino(oldsfp, oldsfep));
+		dp->d_ops->sf_put_ftype(sfep, dp->d_ops->sf_get_ftype(oldsfep));
 	}
 	/*
 	 * Clean up the inode.
@@ -1243,7 +1153,7 @@ xfs_dir2_sf_toino8(
 	 */
 	sfp->count = oldsfp->count;
 	sfp->i8count = 1;
-	xfs_dir2_sf_put_parent_ino(sfp, xfs_dir2_sf_get_parent_ino(oldsfp));
+	dp->d_ops->sf_put_parent_ino(sfp, dp->d_ops->sf_get_parent_ino(oldsfp));
 	/*
 	 * Copy the entries field by field.
 	 */
@@ -1255,10 +1165,9 @@ xfs_dir2_sf_toino8(
 		sfep->namelen = oldsfep->namelen;
 		sfep->offset = oldsfep->offset;
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
-		xfs_dir3_sfe_put_ino(mp, sfp, sfep,
-			xfs_dir3_sfe_get_ino(mp, oldsfp, oldsfep));
-		xfs_dir3_sfe_put_ftype(mp, sfp, sfep,
-			xfs_dir3_sfe_get_ftype(mp, oldsfp, oldsfep));
+		dp->d_ops->sf_put_ino(sfp, sfep,
+				      dp->d_ops->sf_get_ino(oldsfp, oldsfep));
+		dp->d_ops->sf_put_ftype(sfep, dp->d_ops->sf_get_ftype(oldsfep));
 	}
 	/*
 	 * Clean up the inode.
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
