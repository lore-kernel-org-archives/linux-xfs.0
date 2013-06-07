Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EB33C7FDD
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:27:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C88E230408C
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:27:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	an0izyAjJrOJhHWx for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:27:24 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkWO-0003wX-73
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:12 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkW8-0001Lx-W9
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 32/48] xfs_db: convert directory parsing to use libxfs
	structure
Date: Fri,  7 Jun 2013 10:25:55 +1000
Message-Id: <1370564771-4929-33-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

xfs_db rolls it's own "opaque" directory types for the different
block formats. All it cares about is where the headers end and the
data starts, and none of the other details in the structures. Rather
than duplicate this for the dir3 format, we already have perfectly
good headers and abstraction functions for finding this information
in libxfs.  Using these means that the dir2 code used for printing
fields, metadump and check need to be modified to use libxfs
definitions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/check.c    |   70 +++++++++++++++---------------
 db/dir2.c     |  133 ++++++++++++++++++++++++++++-----------------------------
 db/dir2.h     |   25 -----------
 db/dir2sf.c   |   62 +++++++++++++--------------
 db/metadump.c |   31 +++++++-------
 5 files changed, 148 insertions(+), 173 deletions(-)

diff --git a/db/check.c b/db/check.c
index dadfa97..d490f81 100644
--- a/db/check.c
+++ b/db/check.c
@@ -278,9 +278,9 @@ static xfs_ino_t	process_data_dir_v2(int *dot, int *dotdot,
 					    inodata_t *id, int v,
 					    xfs_dablk_t dabno,
 					    freetab_t **freetabp);
-static xfs_dir2_data_free_t
-			*process_data_dir_v2_freefind(xfs_dir2_data_t *data,
-						   xfs_dir2_data_unused_t *dup);
+static xfs_dir2_data_free_t *process_data_dir_v2_freefind(
+					struct xfs_dir2_data_hdr *data,
+					struct xfs_dir2_data_unused *dup);
 static void		process_dir(xfs_dinode_t *dip, blkmap_t *blkmap,
 				    inodata_t *id);
 static int		process_dir_v2(xfs_dinode_t *dip, blkmap_t *blkmap,
@@ -2188,11 +2188,11 @@ process_data_dir_v2(
 	xfs_dir2_dataptr_t	addr;
 	xfs_dir2_data_free_t	*bf;
 	int			bf_err;
-	xfs_dir2_block_t	*block;
+	struct xfs_dir2_data_hdr *block;
 	xfs_dir2_block_tail_t	*btp = NULL;
 	inodata_t		*cid;
 	int			count;
-	xfs_dir2_data_t		*data;
+	struct xfs_dir2_data_hdr *data;
 	xfs_dir2_db_t		db;
 	xfs_dir2_data_entry_t	*dep;
 	xfs_dir2_data_free_t	*dfp;
@@ -2214,20 +2214,20 @@ process_data_dir_v2(
 
 	data = iocur_top->data;
 	block = iocur_top->data;
-	if (be32_to_cpu(block->hdr.magic) != XFS_DIR2_BLOCK_MAGIC &&
-			be32_to_cpu(data->hdr.magic) != XFS_DIR2_DATA_MAGIC) {
+	if (be32_to_cpu(block->magic) != XFS_DIR2_BLOCK_MAGIC &&
+			be32_to_cpu(data->magic) != XFS_DIR2_DATA_MAGIC) {
 		if (!sflag || v)
 			dbprintf(_("bad directory data magic # %#x for dir ino "
 				 "%lld block %d\n"),
-				be32_to_cpu(data->hdr.magic), id->ino, dabno);
+				be32_to_cpu(data->magic), id->ino, dabno);
 		error++;
 		return NULLFSINO;
 	}
 	db = xfs_dir2_da_to_db(mp, dabno);
-	bf = data->hdr.bestfree;
-	ptr = (char *)data->u;
-	if (be32_to_cpu(block->hdr.magic) == XFS_DIR2_BLOCK_MAGIC) {
-		btp = xfs_dir2_block_tail_p(mp, &block->hdr);
+	bf = xfs_dir3_data_bestfree_p(data);
+	ptr = (char *)xfs_dir3_data_unused_p(data);
+	if (be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC) {
+		btp = xfs_dir2_block_tail_p(mp, block);
 		lep = xfs_dir2_block_leaf_p(btp);
 		endptr = (char *)lep;
 		if (endptr <= ptr || endptr > (char *)btp) {
@@ -2372,7 +2372,7 @@ process_data_dir_v2(
 			(*dot)++;
 		}
 	}
-	if (be32_to_cpu(data->hdr.magic) == XFS_DIR2_BLOCK_MAGIC) {
+	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC) {
 		endptr = (char *)data + mp->m_dirblksize;
 		for (i = stale = 0; lep && i < be32_to_cpu(btp->count); i++) {
 			if ((char *)&lep[i] >= endptr) {
@@ -2404,9 +2404,8 @@ process_data_dir_v2(
 				id->ino, dabno);
 		error++;
 	}
-	if (be32_to_cpu(data->hdr.magic) == XFS_DIR2_BLOCK_MAGIC &&
-				count != be32_to_cpu(btp->count) - 
-						be32_to_cpu(btp->stale)) {
+	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC &&
+	    count != be32_to_cpu(btp->count) - be32_to_cpu(btp->stale)) {
 		if (!sflag || v)
 			dbprintf(_("dir %lld block %d bad block tail count %d "
 				 "(stale %d)\n"), 
@@ -2414,7 +2413,7 @@ process_data_dir_v2(
 				be32_to_cpu(btp->stale));
 		error++;
 	}
-	if (be32_to_cpu(data->hdr.magic) == XFS_DIR2_BLOCK_MAGIC && 
+	if (be32_to_cpu(data->magic) == XFS_DIR2_BLOCK_MAGIC && 
 					stale != be32_to_cpu(btp->stale)) {
 		if (!sflag || v)
 			dbprintf(_("dir %lld block %d bad stale tail count %d\n"),
@@ -2439,18 +2438,19 @@ process_data_dir_v2(
 
 static xfs_dir2_data_free_t *
 process_data_dir_v2_freefind(
-	xfs_dir2_data_t		*data,
+	struct xfs_dir2_data_hdr *data,
 	xfs_dir2_data_unused_t	*dup)
 {
-	xfs_dir2_data_free_t	*dfp;
+	struct xfs_dir2_data_free *bf;
+	struct xfs_dir2_data_free *dfp;
 	xfs_dir2_data_aoff_t	off;
 
 	off = (xfs_dir2_data_aoff_t)((char *)dup - (char *)data);
-	if (be16_to_cpu(dup->length) < be16_to_cpu(data->hdr.
-				bestfree[XFS_DIR2_DATA_FD_COUNT - 1].length))
+	bf = xfs_dir3_data_bestfree_p(data);
+	if (be16_to_cpu(dup->length) <
+			be16_to_cpu(bf[XFS_DIR2_DATA_FD_COUNT - 1].length))
 		return NULL;
-	for (dfp = &data->hdr.bestfree[0]; dfp < &data->hdr.
-				bestfree[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
+	for (dfp = bf; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
 		if (be16_to_cpu(dfp->offset) == 0)
 			return NULL;
 		if (be16_to_cpu(dfp->offset) == off)
@@ -3421,20 +3421,20 @@ process_sf_dir_v2(
 	int			i8;
 	xfs_ino_t		lino;
 	int			offset;
-	xfs_dir2_sf_t		*sf;
+	struct xfs_dir2_sf_hdr	*sf;
 	xfs_dir2_sf_entry_t	*sfe;
 	int			v;
 
-	sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
+	sf = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip);
 	addlink_inode(id);
 	v = verbose || id->ilist;
 	if (v)
 		dbprintf(_("dir %lld entry . %lld\n"), id->ino, id->ino);
 	(*dot)++;
-	sfe = xfs_dir2_sf_firstentry(&sf->hdr);
+	sfe = xfs_dir2_sf_firstentry(sf);
 	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
-	for (i = sf->hdr.count - 1, i8 = 0; i >= 0; i--) {
-		if ((__psint_t)sfe + xfs_dir2_sf_entsize(&sf->hdr,sfe->namelen) -
+	for (i = sf->count - 1, i8 = 0; i >= 0; i--) {
+		if ((__psint_t)sfe + xfs_dir2_sf_entsize(sf, sfe->namelen) -
 		    (__psint_t)sf > be64_to_cpu(dip->di_size)) {
 			if (!sflag)
 				dbprintf(_("dir %llu bad size in entry at %d\n"),
@@ -3443,7 +3443,7 @@ process_sf_dir_v2(
 			error++;
 			break;
 		}
-		lino = xfs_dir2_sfe_get_ino(&sf->hdr, sfe);
+		lino = xfs_dir2_sfe_get_ino(sf, sfe);
 		if (lino > XFS_DIR2_MAX_SHORT_INUM)
 			i8++;
 		cid = find_inode(lino, 1);
@@ -3473,8 +3473,8 @@ process_sf_dir_v2(
 		}
 		offset =
 			xfs_dir2_sf_get_offset(sfe) +
-			xfs_dir2_sf_entsize(&sf->hdr, sfe->namelen);
-		sfe = xfs_dir2_sf_nextentry(&sf->hdr, sfe);
+			xfs_dir2_sf_entsize(sf, sfe->namelen);
+		sfe = xfs_dir2_sf_nextentry(sf, sfe);
 	}
 	if (i < 0 && (__psint_t)sfe - (__psint_t)sf != 
 					be64_to_cpu(dip->di_size)) {
@@ -3484,13 +3484,13 @@ process_sf_dir_v2(
 				(uint)((char *)sfe - (char *)sf));
 		error++;
 	}
-	if (offset + (sf->hdr.count + 2) * sizeof(xfs_dir2_leaf_entry_t) +
+	if (offset + (sf->count + 2) * sizeof(xfs_dir2_leaf_entry_t) +
 	    sizeof(xfs_dir2_block_tail_t) > mp->m_dirblksize) {
 		if (!sflag)
 			dbprintf(_("dir %llu offsets too high\n"), id->ino);
 		error++;
 	}
-	lino = xfs_dir2_sf_get_parent_ino(&sf->hdr);
+	lino = xfs_dir2_sf_get_parent_ino(sf);
 	if (lino > XFS_DIR2_MAX_SHORT_INUM)
 		i8++;
 	cid = find_inode(lino, 1);
@@ -3504,11 +3504,11 @@ process_sf_dir_v2(
 	}
 	if (v)
 		dbprintf(_("dir %lld entry .. %lld\n"), id->ino, lino);
-	if (i8 != sf->hdr.i8count) {
+	if (i8 != sf->i8count) {
 		if (!sflag)
 			dbprintf(_("dir %lld i8count mismatch is %d should be "
 				 "%d\n"),
-				id->ino, sf->hdr.i8count, i8);
+				id->ino, sf->i8count, i8);
 		error++;
 	}
 	(*dotdot)++;
diff --git a/db/dir2.c b/db/dir2.c
index 7094a83..90378e6 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -58,13 +58,13 @@ const field_t	dir2_hfld[] = {
 	{ NULL }
 };
 
-#define	BOFF(f)	bitize(offsetof(xfs_dir2_block_t, f))
-#define	DOFF(f)	bitize(offsetof(xfs_dir2_data_t, f))
-#define	FOFF(f)	bitize(offsetof(xfs_dir2_free_t, f))
-#define	LOFF(f)	bitize(offsetof(xfs_dir2_leaf_t, f))
-#define	NOFF(f)	bitize(offsetof(xfs_da_intnode_t, f))
+#define	BOFF(f)	bitize(offsetof(struct xfs_dir2_data_hdr, f))
+#define	DOFF(f)	bitize(offsetof(struct xfs_dir2_data_hdr, f))
+#define	FOFF(f)	bitize(offsetof(struct xfs_dir2_free, f))
+#define	LOFF(f)	bitize(offsetof(struct xfs_dir2_leaf, f))
+#define	NOFF(f)	bitize(offsetof(struct xfs_da_intnode, f))
 const field_t	dir2_flds[] = {
-	{ "bhdr", FLDT_DIR2_DATA_HDR, OI(BOFF(hdr)), dir2_block_hdr_count,
+	{ "bhdr", FLDT_DIR2_DATA_HDR, OI(BOFF(magic)), dir2_block_hdr_count,
 	  FLD_COUNT, TYP_NONE },
 	{ "bu", FLDT_DIR2_DATA_UNION, dir2_block_u_offset, dir2_block_u_count,
 	  FLD_ARRAY|FLD_OFFSET|FLD_COUNT, TYP_NONE },
@@ -72,7 +72,7 @@ const field_t	dir2_flds[] = {
 	  dir2_block_leaf_count, FLD_ARRAY|FLD_OFFSET|FLD_COUNT, TYP_NONE },
 	{ "btail", FLDT_DIR2_BLOCK_TAIL, dir2_block_tail_offset,
 	  dir2_block_tail_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
-	{ "dhdr", FLDT_DIR2_DATA_HDR, OI(DOFF(hdr)), dir2_data_hdr_count,
+	{ "dhdr", FLDT_DIR2_DATA_HDR, OI(DOFF(magic)), dir2_data_hdr_count,
 	  FLD_COUNT, TYP_NONE },
 	{ "du", FLDT_DIR2_DATA_UNION, dir2_data_u_offset, dir2_data_u_count,
 	  FLD_ARRAY|FLD_OFFSET|FLD_COUNT, TYP_NONE },
@@ -189,66 +189,62 @@ const field_t	da_node_hdr_flds[] = {
 	{ NULL }
 };
 
-/*ARGSUSED*/
 static int
 dir2_block_hdr_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_dir2_block_t	*block;
+	struct xfs_dir2_data_hdr *block;
 
 	ASSERT(startoff == 0);
 	block = obj;
-	return be32_to_cpu(block->hdr.magic) == XFS_DIR2_BLOCK_MAGIC;
+	return be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC;
 }
 
-/*ARGSUSED*/
 static int
 dir2_block_leaf_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_dir2_block_t	*block;
-	xfs_dir2_block_tail_t	*btp;
+	struct xfs_dir2_data_hdr *block;
+	struct xfs_dir2_block_tail *btp;
 
 	ASSERT(startoff == 0);
 	block = obj;
-	if (be32_to_cpu(block->hdr.magic) != XFS_DIR2_BLOCK_MAGIC)
+	if (be32_to_cpu(block->magic) != XFS_DIR2_BLOCK_MAGIC)
 		return 0;
-	btp = xfs_dir2_block_tail_p(mp, &block->hdr);
+	btp = xfs_dir2_block_tail_p(mp, block);
 	return be32_to_cpu(btp->count);
 }
 
-/*ARGSUSED*/
 static int
 dir2_block_leaf_offset(
 	void			*obj,
 	int			startoff,
 	int			idx)
 {
-	xfs_dir2_block_t	*block;
-	xfs_dir2_block_tail_t	*btp;
-	xfs_dir2_leaf_entry_t	*lep;
+	struct xfs_dir2_data_hdr *block;
+	struct xfs_dir2_block_tail *btp;
+	struct xfs_dir2_leaf_entry *lep;
 
 	ASSERT(startoff == 0);
 	block = obj;
-	ASSERT(be32_to_cpu(block->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
-	btp = xfs_dir2_block_tail_p(mp, &block->hdr);
+	ASSERT(be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC);
+	btp = xfs_dir2_block_tail_p(mp, block);
 	lep = xfs_dir2_block_leaf_p(btp) + idx;
 	return bitize((int)((char *)lep - (char *)block));
 }
 
-/*ARGSUSED*/
 static int
 dir2_block_tail_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_dir2_block_t	*block;
+	struct xfs_dir2_data_hdr *block;
 
 	ASSERT(startoff == 0);
 	block = obj;
-	return be32_to_cpu(block->hdr.magic) == XFS_DIR2_BLOCK_MAGIC;
+	return be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC;
 }
 
 /*ARGSUSED*/
@@ -258,14 +254,14 @@ dir2_block_tail_offset(
 	int			startoff,
 	int			idx)
 {
-	xfs_dir2_block_t	*block;
-	xfs_dir2_block_tail_t	*btp;
+	struct xfs_dir2_data_hdr *block;
+	struct xfs_dir2_block_tail *btp;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
 	block = obj;
-	ASSERT(be32_to_cpu(block->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
-	btp = xfs_dir2_block_tail_p(mp, &block->hdr);
+	ASSERT(be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC);
+	btp = xfs_dir2_block_tail_p(mp, block);
 	return bitize((int)((char *)btp - (char *)block));
 }
 
@@ -275,22 +271,23 @@ dir2_block_u_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_dir2_block_t	*block;
-	xfs_dir2_block_tail_t	*btp;
-	xfs_dir2_data_entry_t	*dep;
-	xfs_dir2_data_unused_t	*dup;
+	struct xfs_dir2_data_hdr *block;
+	struct xfs_dir2_block_tail *btp;
 	char			*endptr;
 	int			i;
 	char			*ptr;
 
 	ASSERT(startoff == 0);
 	block = obj;
-	if (be32_to_cpu(block->hdr.magic) != XFS_DIR2_BLOCK_MAGIC)
+	if (be32_to_cpu(block->magic) != XFS_DIR2_BLOCK_MAGIC)
 		return 0;
-	btp = xfs_dir2_block_tail_p(mp, &block->hdr);
-	ptr = (char *)block->u;
+	btp = xfs_dir2_block_tail_p(mp, block);
+	ptr = (char *)xfs_dir3_data_unused_p(block);
 	endptr = (char *)xfs_dir2_block_leaf_p(btp);
 	for (i = 0; ptr < endptr; i++) {
+		struct xfs_dir2_data_entry *dep;
+		struct xfs_dir2_data_unused *dup;
+
 		dup = (xfs_dir2_data_unused_t *)ptr;
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG)
 			ptr += be16_to_cpu(dup->length);
@@ -309,21 +306,22 @@ dir2_block_u_offset(
 	int			startoff,
 	int			idx)
 {
-	xfs_dir2_block_t	*block;
-	xfs_dir2_block_tail_t	*btp;
-	xfs_dir2_data_entry_t	*dep;
-	xfs_dir2_data_unused_t	*dup;
+	struct xfs_dir2_data_hdr *block;
+	struct xfs_dir2_block_tail *btp;
 	char			*endptr;
 	int			i;
 	char			*ptr;
 
 	ASSERT(startoff == 0);
 	block = obj;
-	ASSERT(be32_to_cpu(block->hdr.magic) == XFS_DIR2_BLOCK_MAGIC);
-	btp = xfs_dir2_block_tail_p(mp, &block->hdr);
-	ptr = (char *)block->u;
+	ASSERT(be32_to_cpu(block->magic) == XFS_DIR2_BLOCK_MAGIC);
+	btp = xfs_dir2_block_tail_p(mp, block);
+	ptr = (char *)xfs_dir3_data_unused_p(block);
 	endptr = (char *)xfs_dir2_block_leaf_p(btp);
 	for (i = 0; i < idx; i++) {
+		struct xfs_dir2_data_entry *dep;
+		struct xfs_dir2_data_unused *dup;
+
 		ASSERT(ptr < endptr);
 		dup = (xfs_dir2_data_unused_t *)ptr;
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG)
@@ -478,11 +476,11 @@ dir2_data_hdr_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_dir2_data_t		*data;
+	struct xfs_dir2_data_hdr *data;
 
 	ASSERT(startoff == 0);
 	data = obj;
-	return be32_to_cpu(data->hdr.magic) == XFS_DIR2_DATA_MAGIC;
+	return be32_to_cpu(data->magic) == XFS_DIR2_DATA_MAGIC;
 }
 
 /*ARGSUSED*/
@@ -491,20 +489,21 @@ dir2_data_u_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_dir2_data_t		*data;
-	xfs_dir2_data_entry_t	*dep;
-	xfs_dir2_data_unused_t	*dup;
+	struct xfs_dir2_data_hdr *data;
 	char			*endptr;
 	int			i;
 	char			*ptr;
 
 	ASSERT(startoff == 0);
 	data = obj;
-	if (be32_to_cpu(data->hdr.magic) != XFS_DIR2_DATA_MAGIC)
+	if (be32_to_cpu(data->magic) != XFS_DIR2_DATA_MAGIC)
 		return 0;
-	ptr = (char *)data->u;
+	ptr = (char *)xfs_dir3_data_unused_p(data);
 	endptr = (char *)data + mp->m_dirblksize;
 	for (i = 0; ptr < endptr; i++) {
+		struct xfs_dir2_data_entry *dep;
+		struct xfs_dir2_data_unused *dup;
+
 		dup = (xfs_dir2_data_unused_t *)ptr;
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG)
 			ptr += be16_to_cpu(dup->length);
@@ -523,20 +522,20 @@ dir2_data_u_offset(
 	int			startoff,
 	int			idx)
 {
-	xfs_dir2_data_t		*data;
-	xfs_dir2_data_entry_t	*dep;
-	xfs_dir2_data_unused_t	*dup;
-				/*REFERENCED*/
+	struct xfs_dir2_data_hdr *data;
 	char			*endptr;
 	int			i;
 	char			*ptr;
 
 	ASSERT(startoff == 0);
 	data = obj;
-	ASSERT(be32_to_cpu(data->hdr.magic) == XFS_DIR2_DATA_MAGIC);
-	ptr = (char *)data->u;
+	ASSERT(be32_to_cpu(data->magic) == XFS_DIR2_DATA_MAGIC);
+	ptr = (char *)xfs_dir3_data_unused_p(data);
 	endptr = (char *)data + mp->m_dirblksize;
 	for (i = 0; i < idx; i++) {
+		struct xfs_dir2_data_entry *dep;
+		struct xfs_dir2_data_unused *dup;
+
 		ASSERT(ptr < endptr);
 		dup = (xfs_dir2_data_unused_t *)ptr;
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG)
@@ -576,7 +575,7 @@ dir2_free_bests_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_dir2_free_t		*free;
+	struct xfs_dir2_free	*free;
 
 	ASSERT(startoff == 0);
 	free = obj;
@@ -591,7 +590,7 @@ dir2_free_hdr_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_dir2_free_t		*free;
+	struct xfs_dir2_free	*free;
 
 	ASSERT(startoff == 0);
 	free = obj;
@@ -604,8 +603,8 @@ dir2_leaf_bests_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_dir2_leaf_t		*leaf;
-	xfs_dir2_leaf_tail_t	*ltp;
+	struct xfs_dir2_leaf	*leaf;
+	struct xfs_dir2_leaf_tail *ltp;
 
 	ASSERT(startoff == 0);
 	leaf = obj;
@@ -622,9 +621,9 @@ dir2_leaf_bests_offset(
 	int			startoff,
 	int			idx)
 {
+	struct xfs_dir2_leaf	*leaf;
+	struct xfs_dir2_leaf_tail *ltp;
 	__be16			*lbp;
-	xfs_dir2_leaf_t		*leaf;
-	xfs_dir2_leaf_tail_t	*ltp;
 
 	ASSERT(startoff == 0);
 	leaf = obj;
@@ -640,7 +639,7 @@ dir2_leaf_ents_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_dir2_leaf_t		*leaf;
+	struct xfs_dir2_leaf	*leaf;
 
 	ASSERT(startoff == 0);
 	leaf = obj;
@@ -656,7 +655,7 @@ dir2_leaf_hdr_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_dir2_leaf_t		*leaf;
+	struct xfs_dir2_leaf	*leaf;
 
 	ASSERT(startoff == 0);
 	leaf = obj;
@@ -670,7 +669,7 @@ dir2_leaf_tail_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_dir2_leaf_t		*leaf;
+	struct xfs_dir2_leaf	*leaf;
 
 	ASSERT(startoff == 0);
 	leaf = obj;
@@ -684,8 +683,8 @@ dir2_leaf_tail_offset(
 	int			startoff,
 	int			idx)
 {
-	xfs_dir2_leaf_t		*leaf;
-	xfs_dir2_leaf_tail_t	*ltp;
+	struct xfs_dir2_leaf	*leaf;
+	struct xfs_dir2_leaf_tail *ltp;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -716,7 +715,7 @@ dir2_node_hdr_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_da_intnode_t	*node;
+	struct xfs_da_intnode	*node;
 
 	ASSERT(startoff == 0);
 	node = obj;
diff --git a/db/dir2.h b/db/dir2.h
index a5f0bec..05ab354 100644
--- a/db/dir2.h
+++ b/db/dir2.h
@@ -31,31 +31,6 @@ extern const field_t	da_blkinfo_flds[];
 extern const field_t	da_node_entry_flds[];
 extern const field_t	da_node_hdr_flds[];
 
-/*
- * generic dir2 structures used by xfs_db
- */
-typedef union {
-	xfs_dir2_data_entry_t	entry;
-	xfs_dir2_data_unused_t	unused;
-} xfs_dir2_data_union_t;
-
-typedef struct xfs_dir2_data {
-	xfs_dir2_data_hdr_t	hdr;		/* magic XFS_DIR2_DATA_MAGIC */
-	xfs_dir2_data_union_t	u[1];
-} xfs_dir2_data_t;
-
-typedef struct xfs_dir2_block {
-	xfs_dir2_data_hdr_t	hdr;		/* magic XFS_DIR2_BLOCK_MAGIC */
-	xfs_dir2_data_union_t	u[1];
-	xfs_dir2_leaf_entry_t	leaf[1];
-	xfs_dir2_block_tail_t	tail;
-} xfs_dir2_block_t;
-
-typedef struct xfs_dir2_sf {
-	xfs_dir2_sf_hdr_t	hdr;		/* shortform header */
-	xfs_dir2_sf_entry_t	list[1];	/* shortform entries */
-} xfs_dir2_sf_t;
-
 static inline xfs_dir2_inou_t *xfs_dir2_sf_inumberp(xfs_dir2_sf_entry_t *sfep)
 {
 	return (xfs_dir2_inou_t *)&(sfep)->name[(sfep)->namelen];
diff --git a/db/dir2sf.c b/db/dir2sf.c
index 271e08a..b32ca32 100644
--- a/db/dir2sf.c
+++ b/db/dir2sf.c
@@ -32,9 +32,9 @@ static int	dir2_sf_entry_name_count(void *obj, int startoff);
 static int	dir2_sf_list_count(void *obj, int startoff);
 static int	dir2_sf_list_offset(void *obj, int startoff, int idx);
 
-#define	OFF(f)	bitize(offsetof(xfs_dir2_sf_t, f))
+#define	OFF(f)	bitize(offsetof(struct xfs_dir2_sf_hdr, f))
 const field_t	dir2sf_flds[] = {
-	{ "hdr", FLDT_DIR2_SF_HDR, OI(OFF(hdr)), C1, 0, TYP_NONE },
+	{ "hdr", FLDT_DIR2_SF_HDR, OI(OFF(count)), C1, 0, TYP_NONE },
 	{ "list", FLDT_DIR2_SF_ENTRY, dir2_sf_list_offset, dir2_sf_list_count,
 	  FLD_ARRAY|FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ NULL }
@@ -75,11 +75,11 @@ dir2_inou_i4_count(
 	int		startoff)
 {
 	struct xfs_dinode *dip = obj;
-	xfs_dir2_sf_t	*sf;
+	struct xfs_dir2_sf_hdr	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
-	return sf->hdr.i8count == 0;
+	sf = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip);
+	return sf->i8count == 0;
 }
 
 /*ARGSUSED*/
@@ -89,11 +89,11 @@ dir2_inou_i8_count(
 	int		startoff)
 {
 	struct xfs_dinode *dip = obj;
-	xfs_dir2_sf_t	*sf;
+	struct xfs_dir2_sf_hdr	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
-	return sf->hdr.i8count != 0;
+	sf = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip);
+	return sf->i8count != 0;
 }
 
 /*ARGSUSED*/
@@ -104,12 +104,12 @@ dir2_inou_size(
 	int		idx)
 {
 	struct xfs_dinode *dip = obj;
-	xfs_dir2_sf_t	*sf;
+	struct xfs_dir2_sf_hdr	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(idx == 0);
-	sf = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
-	return bitize(sf->hdr.i8count ?
+	sf = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip);
+	return bitize(sf->i8count ?
 		      (uint)sizeof(xfs_dir2_ino8_t) :
 		      (uint)sizeof(xfs_dir2_ino4_t));
 }
@@ -149,14 +149,14 @@ dir2_sf_entry_size(
 {
 	xfs_dir2_sf_entry_t	*e;
 	int			i;
-	xfs_dir2_sf_t		*sf;
+	struct xfs_dir2_sf_hdr	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = (xfs_dir2_sf_t *)((char *)obj + byteize(startoff));
-	e = xfs_dir2_sf_firstentry(&sf->hdr);
+	sf = (struct xfs_dir2_sf_hdr *)((char *)obj + byteize(startoff));
+	e = xfs_dir2_sf_firstentry(sf);
 	for (i = 0; i < idx; i++)
-		e = xfs_dir2_sf_nextentry(&sf->hdr, e);
-	return bitize((int)xfs_dir2_sf_entsize(&sf->hdr, e->namelen));
+		e = xfs_dir2_sf_nextentry(sf, e);
+	return bitize((int)xfs_dir2_sf_entsize(sf, e->namelen));
 }
 
 /*ARGSUSED*/
@@ -166,12 +166,12 @@ dir2_sf_hdr_size(
 	int		startoff,
 	int		idx)
 {
-	xfs_dir2_sf_t	*sf;
+	struct xfs_dir2_sf_hdr	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(idx == 0);
-	sf = (xfs_dir2_sf_t *)((char *)obj + byteize(startoff));
-	return bitize(xfs_dir2_sf_hdr_size(sf->hdr.i8count));
+	sf = (struct xfs_dir2_sf_hdr *)((char *)obj + byteize(startoff));
+	return bitize(xfs_dir2_sf_hdr_size(sf->i8count));
 }
 
 static int
@@ -179,11 +179,11 @@ dir2_sf_list_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_dir2_sf_t		*sf;
+	struct xfs_dir2_sf_hdr	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = (xfs_dir2_sf_t *)((char *)obj + byteize(startoff));
-	return sf->hdr.count;
+	sf = (struct xfs_dir2_sf_hdr *)((char *)obj + byteize(startoff));
+	return sf->count;
 }
 
 static int
@@ -194,13 +194,13 @@ dir2_sf_list_offset(
 {
 	xfs_dir2_sf_entry_t	*e;
 	int			i;
-	xfs_dir2_sf_t		*sf;
+	struct xfs_dir2_sf_hdr	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = (xfs_dir2_sf_t *)((char *)obj + byteize(startoff));
-	e = xfs_dir2_sf_firstentry(&sf->hdr);
+	sf = (struct xfs_dir2_sf_hdr *)((char *)obj + byteize(startoff));
+	e = xfs_dir2_sf_firstentry(sf);
 	for (i = 0; i < idx; i++)
-		e = xfs_dir2_sf_nextentry(&sf->hdr, e);
+		e = xfs_dir2_sf_nextentry(sf, e);
 	return bitize((int)((char *)e - (char *)sf));
 }
 
@@ -213,13 +213,13 @@ dir2sf_size(
 {
 	xfs_dir2_sf_entry_t	*e;
 	int			i;
-	xfs_dir2_sf_t		*sf;
+	struct xfs_dir2_sf_hdr	*sf;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(idx == 0);
-	sf = (xfs_dir2_sf_t *)((char *)obj + byteize(startoff));
-	e = xfs_dir2_sf_firstentry(&sf->hdr);
-	for (i = 0; i < sf->hdr.count; i++)
-		e = xfs_dir2_sf_nextentry(&sf->hdr, e);
+	sf = (struct xfs_dir2_sf_hdr *)((char *)obj + byteize(startoff));
+	e = xfs_dir2_sf_firstentry(sf);
+	for (i = 0; i < sf->count; i++)
+		e = xfs_dir2_sf_nextentry(sf, e);
 	return bitize((int)((char *)e - (char *)sf));
 }
diff --git a/db/metadump.c b/db/metadump.c
index 44e7162..bc1c7fa 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -906,12 +906,12 @@ static void
 obfuscate_sf_dir(
 	xfs_dinode_t		*dip)
 {
-	xfs_dir2_sf_t		*sfp;
+	struct xfs_dir2_sf_hdr	*sfp;
 	xfs_dir2_sf_entry_t	*sfep;
 	__uint64_t		ino_dir_size;
 	int			i;
 
-	sfp = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
+	sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip);
 	ino_dir_size = be64_to_cpu(dip->di_size);
 	if (ino_dir_size > XFS_DFORK_DSIZE(dip, mp)) {
 		ino_dir_size = XFS_DFORK_DSIZE(dip, mp);
@@ -920,8 +920,8 @@ obfuscate_sf_dir(
 					(long long)cur_ino);
 	}
 
-	sfep = xfs_dir2_sf_firstentry(&sfp->hdr);
-	for (i = 0; (i < sfp->hdr.count) &&
+	sfep = xfs_dir2_sf_firstentry(sfp);
+	for (i = 0; (i < sfp->count) &&
 			((char *)sfep - (char *)sfp < ino_dir_size); i++) {
 
 		/*
@@ -934,27 +934,27 @@ obfuscate_sf_dir(
 			if (show_warnings)
 				print_warning("zero length entry in dir inode "
 						"%llu", (long long)cur_ino);
-			if (i != sfp->hdr.count - 1)
+			if (i != sfp->count - 1)
 				break;
 			namelen = ino_dir_size - ((char *)&sfep->name[0] -
 					 (char *)sfp);
 		} else if ((char *)sfep - (char *)sfp +
-				xfs_dir2_sf_entsize(&sfp->hdr, sfep->namelen) >
+				xfs_dir2_sf_entsize(sfp, sfep->namelen) >
 				ino_dir_size) {
 			if (show_warnings)
 				print_warning("entry length in dir inode %llu "
 					"overflows space", (long long)cur_ino);
-			if (i != sfp->hdr.count - 1)
+			if (i != sfp->count - 1)
 				break;
 			namelen = ino_dir_size - ((char *)&sfep->name[0] -
 					 (char *)sfp);
 		}
 
-		generate_obfuscated_name(xfs_dir2_sfe_get_ino(&sfp->hdr, sfep),
+		generate_obfuscated_name(xfs_dir2_sfe_get_ino(sfp, sfep),
 					 namelen, &sfep->name[0]);
 
 		sfep = (xfs_dir2_sf_entry_t *)((char *)sfep +
-				xfs_dir2_sf_entsize(&sfp->hdr, namelen));
+				xfs_dir2_sf_entsize(sfp, namelen));
 	}
 }
 
@@ -1101,6 +1101,9 @@ obfuscate_dir_data_blocks(
 
 		if (dir_data.block_index == 0) {
 			int		wantmagic;
+			struct xfs_dir2_data_hdr *datahdr;
+
+			datahdr = (struct xfs_dir2_data_hdr *)block;
 
 			if (offset % mp->m_dirblkfsbs != 0)
 				return;	/* corrupted, leave it alone */
@@ -1110,10 +1113,8 @@ obfuscate_dir_data_blocks(
 			if (is_block_format) {
 				xfs_dir2_leaf_entry_t	*blp;
 				xfs_dir2_block_tail_t	*btp;
-				xfs_dir2_block_t	*blk;
 
-				blk = (xfs_dir2_block_t *)block;
-				btp = xfs_dir2_block_tail_p(mp, &blk->hdr);
+				btp = xfs_dir2_block_tail_p(mp, datahdr);
 				blp = xfs_dir2_block_leaf_p(btp);
 				if ((char *)blp > (char *)btp)
 					blp = (xfs_dir2_leaf_entry_t *)btp;
@@ -1125,10 +1126,10 @@ obfuscate_dir_data_blocks(
 						mp->m_sb.sb_blocklog;
 				wantmagic = XFS_DIR2_DATA_MAGIC;
 			}
-			dir_data.offset_to_entry = offsetof(xfs_dir2_data_t, u);
+			dir_data.offset_to_entry =
+					xfs_dir3_data_entry_offset(datahdr);
 
-			if (be32_to_cpu(((xfs_dir2_data_hdr_t*)block)->magic) !=
-					wantmagic) {
+			if (be32_to_cpu(datahdr->magic) != wantmagic) {
 				if (show_warnings)
 					print_warning("invalid magic in dir "
 						"inode %llu block %ld",
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
