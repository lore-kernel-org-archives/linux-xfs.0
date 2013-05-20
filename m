Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EED1A7F67
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 01:53:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C7F3A8F8039
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 23:53:35 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	eZjSMS34iv96wpUd for <xfs@oss.sgi.com>;
	Sun, 19 May 2013 23:53:32 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UeJyJ-0006r8-P4
	for xfs@oss.sgi.com; Mon, 20 May 2013 16:53:27 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UeJy9-0006W3-Kz
	for xfs@oss.sgi.com; Mon, 20 May 2013 16:53:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs_repair: convert directory parsing to use libxfs
	structure
Date: Mon, 20 May 2013 16:53:02 +1000
Message-Id: <1369032783-24973-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1369032783-24973-1-git-send-email-david@fromorbit.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
	<1369032783-24973-1-git-send-email-david@fromorbit.com>
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

It turns out that xfs_repair copies xfs_db in rollin git's own
opaque directory types for the different block formats. It has a
little comment about how they are "shared" with xfs_db. Shared by
copy and pasting, rather than a common header, it would appear.

Anyway, same problems, need to use format aware definitionsi and
abstractions from libxfs so that everything is parsed properly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/dir2.c   |  116 +++++++++++++++++++++++++++----------------------------
 repair/dir2.h   |   28 +-------------
 repair/phase6.c |   60 ++++++++++++++--------------
 3 files changed, 89 insertions(+), 115 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index e41c5f9..2ca7fd1 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -651,13 +651,13 @@ _("would correct bad hashval in interior dir block\n"
  */
 void
 process_sf_dir2_fixi8(
-	xfs_dir2_sf_t		*sfp,
+	struct xfs_dir2_sf_hdr	*sfp,
 	xfs_dir2_sf_entry_t	**next_sfep)
 {
 	xfs_ino_t		ino;
-	xfs_dir2_sf_t		*newsfp;
+	struct xfs_dir2_sf_hdr	*newsfp;
 	xfs_dir2_sf_entry_t	*newsfep;
-	xfs_dir2_sf_t		*oldsfp;
+	struct xfs_dir2_sf_hdr	*oldsfp;
 	xfs_dir2_sf_entry_t	*oldsfep;
 	int			oldsize;
 
@@ -669,21 +669,21 @@ process_sf_dir2_fixi8(
 		exit(1);
 	}
 	memmove(oldsfp, newsfp, oldsize);
-	newsfp->hdr.count = oldsfp->hdr.count;
-	newsfp->hdr.i8count = 0;
-	ino = xfs_dir2_sf_get_parent_ino(&sfp->hdr);
-	xfs_dir2_sf_put_parent_ino(&newsfp->hdr, ino);
-	oldsfep = xfs_dir2_sf_firstentry(&oldsfp->hdr);
-	newsfep = xfs_dir2_sf_firstentry(&newsfp->hdr);
+	newsfp->count = oldsfp->count;
+	newsfp->i8count = 0;
+	ino = xfs_dir2_sf_get_parent_ino(sfp);
+	xfs_dir2_sf_put_parent_ino(newsfp, ino);
+	oldsfep = xfs_dir2_sf_firstentry(oldsfp);
+	newsfep = xfs_dir2_sf_firstentry(newsfp);
 	while ((int)((char *)oldsfep - (char *)oldsfp) < oldsize) {
 		newsfep->namelen = oldsfep->namelen;
 		xfs_dir2_sf_put_offset(newsfep,
 			xfs_dir2_sf_get_offset(oldsfep));
 		memmove(newsfep->name, oldsfep->name, newsfep->namelen);
-		ino = xfs_dir2_sfe_get_ino(&oldsfp->hdr, oldsfep);
-		xfs_dir2_sfe_put_ino(&newsfp->hdr, newsfep, ino);
-		oldsfep = xfs_dir2_sf_nextentry(&oldsfp->hdr, oldsfep);
-		newsfep = xfs_dir2_sf_nextentry(&newsfp->hdr, newsfep);
+		ino = xfs_dir2_sfe_get_ino(oldsfp, oldsfep);
+		xfs_dir2_sfe_put_ino(newsfp, newsfep, ino);
+		oldsfep = xfs_dir2_sf_nextentry(oldsfp, oldsfep);
+		newsfep = xfs_dir2_sf_nextentry(newsfp, newsfep);
 	}
 	*next_sfep = newsfep;
 	free(oldsfp);
@@ -700,16 +700,16 @@ process_sf_dir2_fixoff(
 	int			i;
 	int			offset;
 	xfs_dir2_sf_entry_t	*sfep;
-	xfs_dir2_sf_t		*sfp;
+	struct xfs_dir2_sf_hdr	*sfp;
 
-	sfp = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
-	sfep = xfs_dir2_sf_firstentry(&sfp->hdr);
+	sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip);
+	sfep = xfs_dir2_sf_firstentry(sfp);
 	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
 
-	for (i = 0; i < sfp->hdr.count; i++) {
+	for (i = 0; i < sfp->count; i++) {
 		xfs_dir2_sf_put_offset(sfep, offset);
 		offset += xfs_dir2_data_entsize(sfep->namelen);
-		sfep = xfs_dir2_sf_nextentry(&sfp->hdr, sfep);
+		sfep = xfs_dir2_sf_nextentry(sfp, sfep);
 	}
 }
 
@@ -747,16 +747,16 @@ process_sf_dir2(
 	xfs_dir2_sf_entry_t	*next_sfep;
 	int			num_entries;
 	int			offset;
-	xfs_dir2_sf_t		*sfp;
+	struct xfs_dir2_sf_hdr	*sfp;
 	xfs_dir2_sf_entry_t	*sfep;
 	int			tmp_elen;
 	int			tmp_len;
 	xfs_dir2_sf_entry_t	*tmp_sfep;
 	xfs_ino_t		zero = 0;
 
-	sfp = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
+	sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip);
 	max_size = XFS_DFORK_DSIZE(dip, mp);
-	num_entries = sfp->hdr.count;
+	num_entries = sfp->count;
 	ino_dir_size = be64_to_cpu(dip->di_size);
 	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
 	bad_offset = *repair = 0;
@@ -766,12 +766,12 @@ process_sf_dir2(
 	/*
 	 * Initialize i8 based on size of parent inode number.
 	 */
-	i8 = (xfs_dir2_sf_get_parent_ino(&sfp->hdr) > XFS_DIR2_MAX_SHORT_INUM);
+	i8 = (xfs_dir2_sf_get_parent_ino(sfp) > XFS_DIR2_MAX_SHORT_INUM);
 
 	/*
 	 * check for bad entry count
 	 */
-	if (num_entries * xfs_dir2_sf_entsize(&sfp->hdr, 1) +
+	if (num_entries * xfs_dir2_sf_entsize(sfp, 1) +
 		    xfs_dir2_sf_hdr_size(0) > max_size || num_entries == 0)
 		num_entries = 0xFF;
 
@@ -779,7 +779,7 @@ process_sf_dir2(
 	 * run through entries, stop at first bad entry, don't need
 	 * to check for .. since that's encoded in its own field
 	 */
-	sfep = next_sfep = xfs_dir2_sf_firstentry(&sfp->hdr);
+	sfep = next_sfep = xfs_dir2_sf_firstentry(sfp);
 	for (i = 0;
 	     i < num_entries && ino_dir_size > (char *)next_sfep - (char *)sfp;
 	     i++) {
@@ -787,7 +787,7 @@ process_sf_dir2(
 		sfep = next_sfep;
 		junkit = 0;
 		bad_sfnamelen = 0;
-		lino = xfs_dir2_sfe_get_ino(&sfp->hdr, sfep);
+		lino = xfs_dir2_sfe_get_ino(sfp, sfep);
 		/*
 		 * if entry points to self, junk it since only '.' or '..'
 		 * should do that and shortform dirs don't contain either
@@ -901,7 +901,7 @@ _("zero length entry in shortform dir %" PRIu64 ""),
 				break;
 			}
 		} else if ((__psint_t) sfep - (__psint_t) sfp +
-				xfs_dir2_sf_entsize(&sfp->hdr, sfep->namelen)
+				xfs_dir2_sf_entsize(sfp, sfep->namelen)
 							> ino_dir_size)  {
 			bad_sfnamelen = 1;
 
@@ -989,7 +989,7 @@ _("entry contains offset out of order in shortform dir %" PRIu64 "\n"),
 			name[namelen] = '\0';
 
 			if (!no_modify)  {
-				tmp_elen = xfs_dir2_sf_entsize(&sfp->hdr,
+				tmp_elen = xfs_dir2_sf_entsize(sfp,
 								sfep->namelen);
 				be64_add_cpu(&dip->di_size, -tmp_elen);
 				ino_dir_size -= tmp_elen;
@@ -1001,7 +1001,7 @@ _("entry contains offset out of order in shortform dir %" PRIu64 "\n"),
 
 				memmove(sfep, tmp_sfep, tmp_len);
 
-				sfp->hdr.count -= 1;
+				sfp->count -= 1;
 				num_entries--;
 				memset((void *) ((__psint_t) sfep + tmp_len), 0,
 					tmp_elen);
@@ -1043,41 +1043,41 @@ _("would have junked entry \"%s\" in directory inode %" PRIu64 "\n"),
 		next_sfep = (tmp_sfep == NULL)
 			? (xfs_dir2_sf_entry_t *) ((__psint_t) sfep
 							+ ((!bad_sfnamelen)
-				? xfs_dir2_sf_entsize(&sfp->hdr, sfep->namelen)
-				: xfs_dir2_sf_entsize(&sfp->hdr, namelen)))
+				? xfs_dir2_sf_entsize(sfp, sfep->namelen)
+				: xfs_dir2_sf_entsize(sfp, namelen)))
 			: tmp_sfep;
 	}
 
 	/* sync up sizes and entry counts */
 
-	if (sfp->hdr.count != i) {
+	if (sfp->count != i) {
 		if (no_modify) {
 			do_warn(
 _("would have corrected entry count in directory %" PRIu64 " from %d to %d\n"),
-				ino, sfp->hdr.count, i);
+				ino, sfp->count, i);
 		} else {
 			do_warn(
 _("corrected entry count in directory %" PRIu64 ", was %d, now %d\n"),
-				ino, sfp->hdr.count, i);
-			sfp->hdr.count = i;
+				ino, sfp->count, i);
+			sfp->count = i;
 			*dino_dirty = 1;
 			*repair = 1;
 		}
 	}
 
-	if (sfp->hdr.i8count != i8)  {
+	if (sfp->i8count != i8)  {
 		if (no_modify)  {
 			do_warn(
 _("would have corrected i8 count in directory %" PRIu64 " from %d to %d\n"),
-				ino, sfp->hdr.i8count, i8);
+				ino, sfp->i8count, i8);
 		} else {
 			do_warn(
 _("corrected i8 count in directory %" PRIu64 ", was %d, now %d\n"),
-				ino, sfp->hdr.i8count, i8);
+				ino, sfp->i8count, i8);
 			if (i8 == 0)
 				process_sf_dir2_fixi8(sfp, &next_sfep);
 			else
-				sfp->hdr.i8count = i8;
+				sfp->i8count = i8;
 			*dino_dirty = 1;
 			*repair = 1;
 		}
@@ -1101,7 +1101,7 @@ _("corrected directory %" PRIu64 " size, was %" PRId64 ", now %" PRIdPTR "\n"),
 			*repair = 1;
 		}
 	}
-	if (offset + (sfp->hdr.count + 2) * sizeof(xfs_dir2_leaf_entry_t) +
+	if (offset + (sfp->count + 2) * sizeof(xfs_dir2_leaf_entry_t) +
 			sizeof(xfs_dir2_block_tail_t) > mp->m_dirblksize) {
 		do_warn(_("directory %" PRIu64 " offsets too high\n"), ino);
 		bad_offset = 1;
@@ -1124,7 +1124,7 @@ _("corrected entry offsets in directory %" PRIu64 "\n"),
 	/*
 	 * check parent (..) entry
 	 */
-	*parent = xfs_dir2_sf_get_parent_ino(&sfp->hdr);
+	*parent = xfs_dir2_sf_get_parent_ino(sfp);
 
 	/*
 	 * if parent entry is bogus, null it out.  we'll fix it later .
@@ -1138,7 +1138,7 @@ _("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
 		if (!no_modify)  {
 			do_warn(_("clearing inode number\n"));
 
-			xfs_dir2_sf_put_parent_ino(&sfp->hdr, zero);
+			xfs_dir2_sf_put_parent_ino(sfp, zero);
 			*dino_dirty = 1;
 			*repair = 1;
 		} else  {
@@ -1153,7 +1153,7 @@ _("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
 _("corrected root directory %" PRIu64 " .. entry, was %" PRIu64 ", now %" PRIu64 "\n"),
 				ino, *parent, ino);
 			*parent = ino;
-			xfs_dir2_sf_put_parent_ino(&sfp->hdr, ino);
+			xfs_dir2_sf_put_parent_ino(sfp, ino);
 			*dino_dirty = 1;
 			*repair = 1;
 		} else  {
@@ -1173,7 +1173,7 @@ _("bad .. entry in directory inode %" PRIu64 ", points to self, "),
 		if (!no_modify)  {
 			do_warn(_("clearing inode number\n"));
 
-			xfs_dir2_sf_put_parent_ino(&sfp->hdr, zero);
+			xfs_dir2_sf_put_parent_ino(sfp, zero);
 			*dino_dirty = 1;
 			*repair = 1;
 		} else  {
@@ -1207,7 +1207,7 @@ process_dir2_data(
 	xfs_dir2_data_free_t	*bf;
 	int			clearino;
 	char			*clearreason = NULL;
-	xfs_dir2_data_t		*d;
+	struct xfs_dir2_data_hdr *d;
 	xfs_dir2_data_entry_t	*dep;
 	xfs_dir2_data_free_t	*dfp;
 	xfs_dir2_data_unused_t	*dup;
@@ -1222,8 +1222,8 @@ process_dir2_data(
 	xfs_ino_t		ent_ino;
 
 	d = bp->b_addr;
-	bf = xfs_dir3_data_bestfree_p(&d->hdr);
-	ptr = (char *)xfs_dir3_data_entry_p(&d->hdr);
+	bf = xfs_dir3_data_bestfree_p(d);
+	ptr = (char *)xfs_dir3_data_entry_p(d);
 	badbest = lastfree = freeseen = 0;
 	if (be16_to_cpu(bf[0].length) == 0) {
 		badbest |= be16_to_cpu(bf[0].offset) != 0;
@@ -1255,7 +1255,7 @@ process_dir2_data(
 							(char *)dup - (char *)d)
 				break;
 			badbest |= lastfree != 0;
-			dfp = xfs_dir2_data_freefind(&d->hdr, dup);
+			dfp = xfs_dir2_data_freefind(d, dup);
 			if (dfp) {
 				i = dfp - bf;
 				badbest |= (freeseen & (1 << i)) != 0;
@@ -1289,7 +1289,7 @@ process_dir2_data(
 			do_warn(_("\twould junk block\n"));
 		return 1;
 	}
-	ptr = (char *)xfs_dir3_data_entry_p(&d->hdr);
+	ptr = (char *)xfs_dir3_data_entry_p(d);
 	/*
 	 * Process the entries now.
 	 */
@@ -1539,7 +1539,7 @@ _("bad bestfree table in block %u in directory inode %" PRIu64 ": "),
 			da_bno, ino);
 		if (!no_modify) {
 			do_warn(_("repairing table\n"));
-			libxfs_dir2_data_freescan(mp, &d->hdr, &i);
+			libxfs_dir2_data_freescan(mp, d, &i);
 			*dirty = 1;
 		} else {
 			do_warn(_("would repair table\n"));
@@ -1566,7 +1566,7 @@ process_block_dir2(
 	int		*dotdot,	/* out - 1 if there's a dotdot, else 0 */
 	int		*repair)	/* out - 1 if something was fixed */
 {
-	xfs_dir2_block_t	*block;
+	struct xfs_dir2_data_hdr *block;
 	xfs_dir2_leaf_entry_t	*blp;
 	bmap_ext_t		*bmp;
 	struct xfs_buf		*bp;
@@ -1598,16 +1598,16 @@ _("can't read block %u for directory inode %" PRIu64 "\n"),
 	 * Verify the block
 	 */
 	block = bp->b_addr;
-	if (!(be32_to_cpu(block->hdr.magic) == XFS_DIR2_BLOCK_MAGIC ||
-	      be32_to_cpu(block->hdr.magic) == XFS_DIR3_BLOCK_MAGIC))
+	if (!(be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC ||
+	      be32_to_cpu(block->magic) == XFS_DIR3_BLOCK_MAGIC))
 		do_warn(
 _("bad directory block magic # %#x in block %u for directory inode %" PRIu64 "\n"),
-			be32_to_cpu(block->hdr.magic), mp->m_dirdatablk, ino);
+			be32_to_cpu(block->magic), mp->m_dirdatablk, ino);
 	/*
 	 * process the data area
 	 * this also checks & fixes the bestfree
 	 */
-	btp = xfs_dir2_block_tail_p(mp, &block->hdr);
+	btp = xfs_dir2_block_tail_p(mp, block);
 	blp = xfs_dir2_block_leaf_p(btp);
 	/*
 	 * Don't let this go past the end of the block.
@@ -1878,7 +1878,7 @@ process_leaf_node_dir2(
 {
 	bmap_ext_t		*bmp;
 	struct xfs_buf		*bp;
-	xfs_dir2_data_t		*data;
+	struct xfs_dir2_data_hdr *data;
 	xfs_dfiloff_t		dbno;
 	int			good;
 	int			i;
@@ -1914,11 +1914,11 @@ _("can't read block %" PRIu64 " for directory inode %" PRIu64 "\n"),
 			continue;
 		}
 		data = bp->b_addr;
-		if (!(be32_to_cpu(data->hdr.magic) == XFS_DIR2_DATA_MAGIC ||
-		      be32_to_cpu(data->hdr.magic) == XFS_DIR3_DATA_MAGIC))
+		if (!(be32_to_cpu(data->magic) == XFS_DIR2_DATA_MAGIC ||
+		      be32_to_cpu(data->magic) == XFS_DIR3_DATA_MAGIC))
 			do_warn(
 _("bad directory block magic # %#x in block %" PRIu64 " for directory inode %" PRIu64 "\n"),
-				be32_to_cpu(data->hdr.magic), dbno, ino);
+				be32_to_cpu(data->magic), dbno, ino);
 		i = process_dir2_data(mp, ino, dip, ino_discovery, dirname,
 			parent, bp, dot, dotdot, (xfs_dablk_t)dbno,
 			(char *)data + mp->m_dirblksize, &dirty);
diff --git a/repair/dir2.h b/repair/dir2.h
index 6ba96bb..3d8fe8a 100644
--- a/repair/dir2.h
+++ b/repair/dir2.h
@@ -23,32 +23,6 @@ struct blkmap;
 struct bmap_ext;
 
 /*
- * generic dir2 structures used by xfs_repair.
- * XXX: shared with xfsdb
- */
-typedef union {
-	xfs_dir2_data_entry_t	entry;
-	xfs_dir2_data_unused_t	unused;
-} xfs_dir2_data_union_t;
-
-typedef struct xfs_dir2_data {
-	xfs_dir2_data_hdr_t	hdr;		/* magic XFS_DIR2_DATA_MAGIC */
-	xfs_dir2_data_union_t	__u[1];
-} xfs_dir2_data_t;
-
-typedef struct xfs_dir2_block {
-	xfs_dir2_data_hdr_t	hdr;		/* magic XFS_DIR2_BLOCK_MAGIC */
-	xfs_dir2_data_union_t	__u[1];
-	xfs_dir2_leaf_entry_t	__leaf[1];
-	xfs_dir2_block_tail_t	tail;
-} xfs_dir2_block_t;
-
-typedef struct xfs_dir2_sf {
-	xfs_dir2_sf_hdr_t	hdr;		/* shortform header */
-	xfs_dir2_sf_entry_t	list[1];	/* shortform entries */
-} xfs_dir2_sf_t;
-
-/*
  * the cursor gets passed up and down the da btree processing
  * routines.  The interior block processing routines use the
  * cursor to determine if the pointers to and from the preceding
@@ -98,7 +72,7 @@ process_dir2(
 
 void
 process_sf_dir2_fixi8(
-	xfs_dir2_sf_t		*sfp,
+	struct xfs_dir2_sf_hdr	*sfp,
 	xfs_dir2_sf_entry_t	**next_sfep);
 
 int
diff --git a/repair/phase6.c b/repair/phase6.c
index 6976d0c..1fdd4c8 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1391,7 +1391,7 @@ longform_dir2_entry_check_data(
 	struct xfs_buf		*bp;
 	xfs_dir2_block_tail_t	*btp;
 	int			committed;
-	xfs_dir2_data_t		*d;
+	struct xfs_dir2_data_hdr *d;
 	xfs_dir2_db_t		db;
 	xfs_dir2_data_entry_t	*dep;
 	xfs_dir2_data_unused_t	*dup;
@@ -1418,7 +1418,7 @@ longform_dir2_entry_check_data(
 
 	bp = *bpp;
 	d = bp->b_addr;
-	ptr = (char *)xfs_dir3_data_entry_p(&d->hdr);
+	ptr = (char *)xfs_dir3_data_entry_p(d);
 	nbad = 0;
 	needscan = needlog = 0;
 	junkit = 0;
@@ -1479,7 +1479,7 @@ longform_dir2_entry_check_data(
 				break;
 
 			/* check for block with no data entries */
-			if ((ptr == (char *)xfs_dir3_data_entry_p(&d->hdr)) &&
+			if ((ptr == (char *)xfs_dir3_data_entry_p(d)) &&
 			    (ptr + be16_to_cpu(dup->length) >= endptr)) {
 				junkit = 1;
 				*num_illegal += 1;
@@ -1539,19 +1539,19 @@ longform_dir2_entry_check_data(
 	libxfs_trans_bjoin(tp, bp);
 	libxfs_trans_bhold(tp, bp);
 	xfs_bmap_init(&flist, &firstblock);
-	if (be32_to_cpu(d->hdr.magic) != wantmagic) {
+	if (be32_to_cpu(d->magic) != wantmagic) {
 		do_warn(
 	_("bad directory block magic # %#x for directory inode %" PRIu64 " block %d: "),
-			be32_to_cpu(d->hdr.magic), ip->i_ino, da_bno);
+			be32_to_cpu(d->magic), ip->i_ino, da_bno);
 		if (!no_modify) {
 			do_warn(_("fixing magic # to %#x\n"), wantmagic);
-			d->hdr.magic = cpu_to_be32(wantmagic);
+			d->magic = cpu_to_be32(wantmagic);
 			needlog = 1;
 		} else
 			do_warn(_("would fix magic # to %#x\n"), wantmagic);
 	}
 	lastfree = 0;
-	ptr = (char *)xfs_dir3_data_entry_p(&d->hdr);
+	ptr = (char *)xfs_dir3_data_entry_p(d);
 	/*
 	 * look at each entry.  reference inode pointed to by each
 	 * entry in the incore inode tree.
@@ -1722,7 +1722,7 @@ longform_dir2_entry_check_data(
 			ASSERT(dep->name[0] == '.' && dep->namelen == 1);
 			add_inode_ref(current_irec, current_ino_offset);
 			if (da_bno != 0 ||
-			    dep != xfs_dir3_data_entry_p(&d->hdr)) {
+			    dep != xfs_dir3_data_entry_p(d)) {
 				/* "." should be the first entry */
 				nbad++;
 				if (entry_junked(
@@ -1803,12 +1803,12 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 	}
 	*num_illegal += nbad;
 	if (needscan)
-		libxfs_dir2_data_freescan(mp, &d->hdr, &needlog);
+		libxfs_dir2_data_freescan(mp, d, &needlog);
 	if (needlog)
 		libxfs_dir2_data_log_header(tp, bp);
 	libxfs_bmap_finish(&tp, &flist, &committed);
 	libxfs_trans_commit(tp, 0);
-	freetab->ents[db].v = be16_to_cpu(d->hdr.bestfree[0].length);
+	freetab->ents[db].v = be16_to_cpu(d->bestfree[0].length);
 	freetab->ents[db].s = 0;
 }
 
@@ -2029,7 +2029,6 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 			int		ino_offset,
 			dir_hash_tab_t	*hashtab)
 {
-	xfs_dir2_block_t	*block;
 	struct xfs_buf		**bplist;
 	xfs_dablk_t		da_bno;
 	freetab_t		*freetab;
@@ -2096,11 +2095,12 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 	if (!dotdot_update) {
 		/* check btree and freespace */
 		if (isblock) {
+			struct xfs_dir2_data_hdr *block;
 			xfs_dir2_block_tail_t	*btp;
 			xfs_dir2_leaf_entry_t	*blp;
 
 			block = bplist[0]->b_addr;
-			btp = xfs_dir2_block_tail_p(mp, &block->hdr);
+			btp = xfs_dir2_block_tail_p(mp, block);
 			blp = xfs_dir2_block_leaf_p(btp);
 			seeval = dir_hash_see_all(hashtab, blp,
 						be32_to_cpu(btp->count),
@@ -2148,7 +2148,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 {
 	xfs_ino_t		lino;
 	xfs_ino_t		parent;
-	xfs_dir2_sf_t		*sfp;
+	struct xfs_dir2_sf_hdr	*sfp;
 	xfs_dir2_sf_entry_t	*sfep, *next_sfep, *tmp_sfep;
 	xfs_ifork_t		*ifp;
 	ino_tree_node_t		*irec;
@@ -2165,7 +2165,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 	int			i8;
 
 	ifp = &ip->i_df;
-	sfp = (xfs_dir2_sf_t *) ifp->if_u1.if_data;
+	sfp = (struct xfs_dir2_sf_hdr *) ifp->if_u1.if_data;
 	*ino_dirty = 0;
 	bytes_deleted = 0;
 
@@ -2185,7 +2185,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 			do_warn(
 	_("setting .. in sf dir inode %" PRIu64 " to %" PRIu64 "\n"),
 				ino, parent);
-			xfs_dir2_sf_put_parent_ino(&sfp->hdr, parent);
+			xfs_dir2_sf_put_parent_ino(sfp, parent);
 			*ino_dirty = 1;
 		}
 		return;
@@ -2202,23 +2202,23 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 	/*
 	 * Initialise i8 counter -- the parent inode number counts as well.
 	 */
-	i8 = xfs_dir2_sf_get_parent_ino(&sfp->hdr) > XFS_DIR2_MAX_SHORT_INUM;
+	i8 = xfs_dir2_sf_get_parent_ino(sfp) > XFS_DIR2_MAX_SHORT_INUM;
 
 	/*
 	 * now run through entries, stop at first bad entry, don't need
 	 * to skip over '..' since that's encoded in its own field and
 	 * no need to worry about '.' since it doesn't exist.
 	 */
-	sfep = next_sfep = xfs_dir2_sf_firstentry(&sfp->hdr);
+	sfep = next_sfep = xfs_dir2_sf_firstentry(sfp);
 
-	for (i = 0; i < sfp->hdr.count && max_size >
+	for (i = 0; i < sfp->count && max_size >
 					(__psint_t)next_sfep - (__psint_t)sfp;
 			sfep = next_sfep, i++)  {
 		junkit = 0;
 		bad_sfnamelen = 0;
 		tmp_sfep = NULL;
 
-		lino = xfs_dir2_sfe_get_ino(&sfp->hdr, sfep);
+		lino = xfs_dir2_sfe_get_ino(sfp, sfep);
 
 		namelen = sfep->namelen;
 
@@ -2235,7 +2235,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 			 */
 			bad_sfnamelen = 1;
 
-			if (i == sfp->hdr.count - 1)  {
+			if (i == sfp->count - 1)  {
 				namelen = ip->i_d.di_size -
 					((__psint_t) &sfep->name[0] -
 					 (__psint_t) sfp);
@@ -2247,11 +2247,11 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 				break;
 			}
 		} else if (no_modify && (__psint_t) sfep - (__psint_t) sfp +
-				+ xfs_dir2_sf_entsize(&sfp->hdr, sfep->namelen)
+				+ xfs_dir2_sf_entsize(sfp, sfep->namelen)
 				> ip->i_d.di_size)  {
 			bad_sfnamelen = 1;
 
-			if (i == sfp->hdr.count - 1)  {
+			if (i == sfp->count - 1)  {
 				namelen = ip->i_d.di_size -
 					((__psint_t) &sfep->name[0] -
 					 (__psint_t) sfp);
@@ -2277,7 +2277,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 
 		if (no_modify && verify_inum(mp, lino))  {
 			next_sfep = (xfs_dir2_sf_entry_t *)((__psint_t)sfep +
-				xfs_dir2_sf_entsize(&sfp->hdr, sfep->namelen));
+				xfs_dir2_sf_entsize(sfp, sfep->namelen));
 			continue;
 		}
 
@@ -2328,7 +2328,7 @@ shortform_dir2_entry_check(xfs_mount_t	*mp,
 		 * check for duplicate names in directory.
 		 */
 		if (!dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
-				(sfep - xfs_dir2_sf_firstentry(&sfp->hdr)),
+				(sfep - xfs_dir2_sf_firstentry(sfp)),
 				lino, sfep->namelen, sfep->name)) {
 			do_warn(
 _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
@@ -2385,7 +2385,7 @@ do_junkit:
 			if (lino == orphanage_ino)
 				orphanage_ino = 0;
 			if (!no_modify)  {
-				tmp_elen = xfs_dir2_sf_entsize(&sfp->hdr,
+				tmp_elen = xfs_dir2_sf_entsize(sfp,
 								sfep->namelen);
 				tmp_sfep = (xfs_dir2_sf_entry_t *)
 					((__psint_t) sfep + tmp_elen);
@@ -2396,7 +2396,7 @@ do_junkit:
 
 				memmove(sfep, tmp_sfep, tmp_len);
 
-				sfp->hdr.count -= 1;
+				sfp->count -= 1;
 				memset((void *)((__psint_t)sfep + tmp_len), 0,
 						tmp_elen);
 
@@ -2438,12 +2438,12 @@ do_junkit:
 		next_sfep = (tmp_sfep == NULL)
 			? (xfs_dir2_sf_entry_t *) ((__psint_t) sfep
 							+ ((!bad_sfnamelen)
-				? xfs_dir2_sf_entsize(&sfp->hdr, sfep->namelen)
-				: xfs_dir2_sf_entsize(&sfp->hdr, namelen)))
+				? xfs_dir2_sf_entsize(sfp, sfep->namelen)
+				: xfs_dir2_sf_entsize(sfp, namelen)))
 			: tmp_sfep;
 	}
 
-	if (sfp->hdr.i8count != i8) {
+	if (sfp->i8count != i8) {
 		if (no_modify) {
 			do_warn(_("would fix i8count in inode %" PRIu64 "\n"),
 				ino);
@@ -2456,7 +2456,7 @@ do_junkit:
 					(__psint_t)tmp_sfep;
 				next_sfep = tmp_sfep;
 			} else
-				sfp->hdr.i8count = i8;
+				sfp->i8count = i8;
 			*ino_dirty = 1;
 			do_warn(_("fixing i8count in inode %" PRIu64 "\n"),
 				ino);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
