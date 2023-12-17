Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A41646437
	for <linux-xfs@vger.kernel.org>; Sun, 17 Dec 2023 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LY45JHel"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CXTu0MZkl2Mua0Ku/MTs0lZONb8UJhgDP3ouykZevoY=; b=LY45JHelk5Ex0emYDlt99gDpp0
	fJ3b8beTtk9wC5XMYxbHN+dCRvvpwMrib3Vs2g0IhwiielqX3BUzkNMhwMth+3oo4BVHVIOP1Xqrx
	MG3GokMNAkzU1PN41NRgP2H64FCxVq3RW1LEFk9ZSysOwX8LRz5zP7pQSfRVRZ2+rUKDLUFg1PRIv
	8sdwJzfvnSoX2ziZ7vEOxgHVXu8ZekUV+TSpzKmwPm2HKLj6rnUL0g7CbVQCzR5u/znuwcEorTlqj
	lAL55BZwTfNDk2MNUs6cmaS/Ou8qEcjxiC+k4+zFPUHobgCWih6TMp3jDaKbbVac6IPG38Pp84Eem
	krgB9Tcg==;
Received: from [88.128.92.84] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rEuYV-008AFk-2g;
	Sun, 17 Dec 2023 17:03:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/8] xfs: make if_data a void pointer
Date: Sun, 17 Dec 2023 18:03:43 +0100
Message-Id: <20231217170350.605812-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231217170350.605812-1-hch@lst.de>
References: <20231217170350.605812-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The xfs_ifork structure currently has a union of the if_root void pointer
and the if_data char pointer.  In either case it is an opaque pointer
that depends on the fork format.  Replace the union with a single if_data
void pointer as that is what almost all callers want.  Only the symlink
NULL termination code in xfs_init_local_fork actually needs a new local
variable now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c           |  3 +-
 fs/xfs/libxfs/xfs_attr_leaf.c      | 62 ++++++++++++------------------
 fs/xfs/libxfs/xfs_bmap.c           |  4 +-
 fs/xfs/libxfs/xfs_dir2.c           |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c     |  6 +--
 fs/xfs/libxfs/xfs_dir2_sf.c        | 61 ++++++++++++-----------------
 fs/xfs/libxfs/xfs_iext_tree.c      | 36 ++++++++---------
 fs/xfs/libxfs/xfs_inode_fork.c     | 53 ++++++++++++-------------
 fs/xfs/libxfs/xfs_inode_fork.h     |  8 ++--
 fs/xfs/libxfs/xfs_symlink_remote.c |  4 +-
 fs/xfs/scrub/attr.c                | 10 ++---
 fs/xfs/scrub/readdir.c             |  6 +--
 fs/xfs/scrub/symlink.c             |  2 +-
 fs/xfs/xfs_attr_list.c             |  3 +-
 fs/xfs/xfs_dir2_readdir.c          |  6 +--
 fs/xfs/xfs_inode.c                 |  6 +--
 fs/xfs/xfs_inode_item.c            | 10 ++---
 fs/xfs/xfs_symlink.c               |  4 +-
 18 files changed, 119 insertions(+), 167 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fa49c795f40745..7f822e72dfcd3e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1049,9 +1049,8 @@ xfs_attr_set(
 
 static inline int xfs_attr_sf_totsize(struct xfs_inode *dp)
 {
-	struct xfs_attr_shortform *sf;
+	struct xfs_attr_shortform *sf = dp->i_af.if_data;
 
-	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
 	return be16_to_cpu(sf->hdr.totsize);
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 5d1ab4978f3293..3e5377fd498471 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -691,7 +691,7 @@ xfs_attr_shortform_create(
 	if (ifp->if_format == XFS_DINODE_FMT_EXTENTS)
 		ifp->if_format = XFS_DINODE_FMT_LOCAL;
 	xfs_idata_realloc(dp, sizeof(*hdr), XFS_ATTR_FORK);
-	hdr = (struct xfs_attr_sf_hdr *)ifp->if_u1.if_data;
+	hdr = ifp->if_data;
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->totsize = cpu_to_be16(sizeof(*hdr));
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_ADATA);
@@ -712,14 +712,13 @@ xfs_attr_sf_findname(
 	struct xfs_attr_sf_entry **sfep,
 	unsigned int		 *basep)
 {
-	struct xfs_attr_shortform *sf;
+	struct xfs_attr_shortform *sf = args->dp->i_af.if_data;
 	struct xfs_attr_sf_entry *sfe;
 	unsigned int		base = sizeof(struct xfs_attr_sf_hdr);
 	int			size = 0;
 	int			end;
 	int			i;
 
-	sf = (struct xfs_attr_shortform *)args->dp->i_af.if_u1.if_data;
 	sfe = &sf->list[0];
 	end = sf->hdr.count;
 	for (i = 0; i < end; sfe = xfs_attr_sf_nextentry(sfe),
@@ -751,29 +750,25 @@ xfs_attr_shortform_add(
 	struct xfs_da_args		*args,
 	int				forkoff)
 {
-	struct xfs_attr_shortform	*sf;
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_mount		*mp = dp->i_mount;
+	struct xfs_ifork		*ifp = &dp->i_af;
+	struct xfs_attr_shortform	*sf = ifp->if_data;
 	struct xfs_attr_sf_entry	*sfe;
 	int				offset, size;
-	struct xfs_mount		*mp;
-	struct xfs_inode		*dp;
-	struct xfs_ifork		*ifp;
 
 	trace_xfs_attr_sf_add(args);
 
-	dp = args->dp;
-	mp = dp->i_mount;
 	dp->i_forkoff = forkoff;
 
-	ifp = &dp->i_af;
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
-	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	if (xfs_attr_sf_findname(args, &sfe, NULL) == -EEXIST)
 		ASSERT(0);
 
 	offset = (char *)sfe - (char *)sf;
 	size = xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
 	xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
-	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
+	sf = ifp->if_data;
 	sfe = (struct xfs_attr_sf_entry *)((char *)sf + offset);
 
 	sfe->namelen = args->namelen;
@@ -811,20 +806,16 @@ int
 xfs_attr_sf_removename(
 	struct xfs_da_args		*args)
 {
-	struct xfs_attr_shortform	*sf;
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_mount		*mp = dp->i_mount;
+	struct xfs_attr_shortform	*sf = dp->i_af.if_data;
 	struct xfs_attr_sf_entry	*sfe;
 	int				size = 0, end, totsize;
 	unsigned int			base;
-	struct xfs_mount		*mp;
-	struct xfs_inode		*dp;
 	int				error;
 
 	trace_xfs_attr_sf_remove(args);
 
-	dp = args->dp;
-	mp = dp->i_mount;
-	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
-
 	error = xfs_attr_sf_findname(args, &sfe, &base);
 
 	/*
@@ -878,18 +869,17 @@ xfs_attr_sf_removename(
  */
 /*ARGSUSED*/
 int
-xfs_attr_shortform_lookup(xfs_da_args_t *args)
+xfs_attr_shortform_lookup(
+	struct xfs_da_args		*args)
 {
-	struct xfs_attr_shortform *sf;
-	struct xfs_attr_sf_entry *sfe;
-	int i;
-	struct xfs_ifork *ifp;
+	struct xfs_ifork		*ifp = &args->dp->i_af;
+	struct xfs_attr_shortform	*sf = ifp->if_data;
+	struct xfs_attr_sf_entry	*sfe;
+	int				i;
 
 	trace_xfs_attr_sf_lookup(args);
 
-	ifp = &args->dp->i_af;
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
-	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = xfs_attr_sf_nextentry(sfe), i++) {
@@ -909,14 +899,13 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
  */
 int
 xfs_attr_shortform_getvalue(
-	struct xfs_da_args	*args)
+	struct xfs_da_args		*args)
 {
-	struct xfs_attr_shortform *sf;
-	struct xfs_attr_sf_entry *sfe;
-	int			i;
+	struct xfs_attr_shortform	*sf = args->dp->i_af.if_data;
+	struct xfs_attr_sf_entry	*sfe;
+	int				i;
 
 	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);
-	sf = (struct xfs_attr_shortform *)args->dp->i_af.if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = xfs_attr_sf_nextentry(sfe), i++) {
@@ -933,25 +922,22 @@ int
 xfs_attr_shortform_to_leaf(
 	struct xfs_da_args		*args)
 {
-	struct xfs_inode		*dp;
-	struct xfs_attr_shortform	*sf;
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_ifork		*ifp = &dp->i_af;
+	struct xfs_attr_shortform	*sf = ifp->if_data;
 	struct xfs_attr_sf_entry	*sfe;
 	struct xfs_da_args		nargs;
 	char				*tmpbuffer;
 	int				error, i, size;
 	xfs_dablk_t			blkno;
 	struct xfs_buf			*bp;
-	struct xfs_ifork		*ifp;
 
 	trace_xfs_attr_sf_to_leaf(args);
 
-	dp = args->dp;
-	ifp = &dp->i_af;
-	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	size = be16_to_cpu(sf->hdr.totsize);
 	tmpbuffer = kmem_alloc(size, 0);
 	ASSERT(tmpbuffer != NULL);
-	memcpy(tmpbuffer, ifp->if_u1.if_data, size);
+	memcpy(tmpbuffer, ifp->if_data, size);
 	sf = (struct xfs_attr_shortform *)tmpbuffer;
 
 	xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 523926fe50eb0a..3ed01c178b7baa 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -747,7 +747,7 @@ xfs_bmap_local_to_extents_empty(
 	ASSERT(ifp->if_nextents == 0);
 
 	xfs_bmap_forkoff_reset(ip, whichfork);
-	ifp->if_u1.if_root = NULL;
+	ifp->if_data = NULL;
 	ifp->if_height = 0;
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
@@ -832,7 +832,7 @@ xfs_bmap_local_to_extents(
 	xfs_bmap_local_to_extents_empty(tp, ip, whichfork);
 	flags |= XFS_ILOG_CORE;
 
-	ifp->if_u1.if_root = NULL;
+	ifp->if_data = NULL;
 	ifp->if_height = 0;
 
 	rec.br_startoff = 0;
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index f5462fd582d502..a7667328151450 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -196,7 +196,7 @@ xfs_dir_isempty(
 		return 1;
 	if (dp->i_disk_size > xfs_inode_data_fork_size(dp))
 		return 0;
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	sfp = dp->i_df.if_data;
 	return !sfp->count;
 }
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 00f960a703b2ef..3c256d4cc40b48 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1089,7 +1089,7 @@ xfs_dir2_sf_to_block(
 	int			newoffset;	/* offset from current entry */
 	unsigned int		offset = geo->data_entry_offset;
 	xfs_dir2_sf_entry_t	*sfep;		/* sf entry pointer */
-	xfs_dir2_sf_hdr_t	*oldsfp;	/* old shortform header  */
+	struct xfs_dir2_sf_hdr	*oldsfp = ifp->if_data;
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform header  */
 	__be16			*tagp;		/* end of data entry */
 	struct xfs_name		name;
@@ -1099,10 +1099,8 @@ xfs_dir2_sf_to_block(
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 
-	oldsfp = (xfs_dir2_sf_hdr_t *)ifp->if_u1.if_data;
-
 	ASSERT(ifp->if_bytes == dp->i_disk_size);
-	ASSERT(ifp->if_u1.if_data != NULL);
+	ASSERT(oldsfp != NULL);
 	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(oldsfp->i8count));
 	ASSERT(dp->i_df.if_nextents == 0);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 870ef1d1ebe4a2..0b63138d2b9f0e 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -364,25 +364,23 @@ int						/* error */
 xfs_dir2_sf_addname(
 	xfs_da_args_t		*args)		/* operation arguments */
 {
-	xfs_inode_t		*dp;		/* incore directory inode */
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
 	int			error;		/* error return value */
 	int			incr_isize;	/* total change in size */
 	int			new_isize;	/* size after adding name */
 	int			objchange;	/* changing to 8-byte inodes */
 	xfs_dir2_data_aoff_t	offset = 0;	/* offset for new entry */
 	int			pick;		/* which algorithm to use */
-	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 	xfs_dir2_sf_entry_t	*sfep = NULL;	/* shortform entry */
 
 	trace_xfs_dir2_sf_addname(args);
 
 	ASSERT(xfs_dir2_sf_lookup(args) == -ENOENT);
-	dp = args->dp;
 	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
 	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
-	ASSERT(dp->i_df.if_u1.if_data != NULL);
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	ASSERT(sfp != NULL);
 	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
 	/*
 	 * Compute entry (and change in) size.
@@ -462,11 +460,9 @@ xfs_dir2_sf_addname_easy(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
-	int			byteoff;	/* byte offset in sf dir */
-	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
+	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
+	int			byteoff = (int)((char *)sfep - (char *)sfp);
 
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	byteoff = (int)((char *)sfep - (char *)sfp);
 	/*
 	 * Grow the in-inode space.
 	 */
@@ -475,7 +471,7 @@ xfs_dir2_sf_addname_easy(
 	/*
 	 * Need to set up again due to realloc of the inode data.
 	 */
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	sfp = dp->i_df.if_data;
 	sfep = (xfs_dir2_sf_entry_t *)((char *)sfp + byteoff);
 	/*
 	 * Fill in the new entry.
@@ -528,11 +524,10 @@ xfs_dir2_sf_addname_hard(
 	/*
 	 * Copy the old directory to the stack buffer.
 	 */
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	old_isize = (int)dp->i_disk_size;
 	buf = kmem_alloc(old_isize, 0);
 	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
-	memcpy(oldsfp, sfp, old_isize);
+	memcpy(oldsfp, dp->i_df.if_data, old_isize);
 	/*
 	 * Loop over the old directory finding the place we're going
 	 * to insert the new entry.
@@ -560,7 +555,7 @@ xfs_dir2_sf_addname_hard(
 	/*
 	 * Reset the pointer since the buffer was reallocated.
 	 */
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	sfp = dp->i_df.if_data;
 	/*
 	 * Copy the first part of the directory, including the header.
 	 */
@@ -610,11 +605,10 @@ xfs_dir2_sf_addname_pick(
 	int			i;		/* entry number */
 	xfs_dir2_data_aoff_t	offset;		/* data block offset */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform entry */
-	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
+	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
 	int			size;		/* entry's data size */
 	int			used;		/* data bytes used */
 
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	size = xfs_dir2_data_entsize(mp, args->namelen);
 	offset = args->geo->data_first_offset;
 	sfep = xfs_dir2_sf_firstentry(sfp);
@@ -673,14 +667,13 @@ xfs_dir2_sf_check(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
 	int			i;		/* entry number */
 	int			i8count;	/* number of big inode#s */
 	xfs_ino_t		ino;		/* entry inode number */
 	int			offset;		/* data offset */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform dir entry */
-	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	offset = args->geo->data_first_offset;
 	ino = xfs_dir2_sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
@@ -834,7 +827,7 @@ xfs_dir2_sf_create(
 	/*
 	 * Fill in the header,
 	 */
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	sfp = dp->i_df.if_data;
 	sfp->i8count = i8count;
 	/*
 	 * Now can put in the inode number, since i8count is set.
@@ -857,9 +850,9 @@ xfs_dir2_sf_lookup(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
 	int			i;		/* entry index */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
-	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 	enum xfs_dacmp		cmp;		/* comparison result */
 	xfs_dir2_sf_entry_t	*ci_sfep;	/* case-insens. entry */
 
@@ -870,8 +863,7 @@ xfs_dir2_sf_lookup(
 	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
 	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
-	ASSERT(dp->i_df.if_u1.if_data != NULL);
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	ASSERT(sfp != NULL);
 	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
 	/*
 	 * Special case for .
@@ -933,13 +925,13 @@ xfs_dir2_sf_removename(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
 	int			byteoff;	/* offset of removed entry */
 	int			entsize;	/* this entry's size */
 	int			i;		/* shortform entry index */
 	int			newsize;	/* new inode size */
 	int			oldsize;	/* old inode size */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
-	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 
 	trace_xfs_dir2_sf_removename(args);
 
@@ -947,8 +939,7 @@ xfs_dir2_sf_removename(
 	oldsize = (int)dp->i_disk_size;
 	ASSERT(oldsize >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == oldsize);
-	ASSERT(dp->i_df.if_u1.if_data != NULL);
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	ASSERT(sfp != NULL);
 	ASSERT(oldsize >= xfs_dir2_sf_hdr_size(sfp->i8count));
 	/*
 	 * Loop over the old directory entries.
@@ -989,7 +980,7 @@ xfs_dir2_sf_removename(
 	 * Reallocate, making it smaller.
 	 */
 	xfs_idata_realloc(dp, newsize - oldsize, XFS_DATA_FORK);
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	sfp = dp->i_df.if_data;
 	/*
 	 * Are we changing inode number size?
 	 */
@@ -1012,13 +1003,12 @@ xfs_dir2_sf_replace_needblock(
 	struct xfs_inode	*dp,
 	xfs_ino_t		inum)
 {
+	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
 	int			newsize;
-	struct xfs_dir2_sf_hdr	*sfp;
 
 	if (dp->i_df.if_format != XFS_DINODE_FMT_LOCAL)
 		return false;
 
-	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
 	newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
 
 	return inum > XFS_DIR2_MAX_SHORT_INUM &&
@@ -1034,19 +1024,18 @@ xfs_dir2_sf_replace(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
 	int			i;		/* entry index */
 	xfs_ino_t		ino=0;		/* entry old inode number */
 	int			i8elevated;	/* sf_toino8 set i8count=1 */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
-	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 
 	trace_xfs_dir2_sf_replace(args);
 
 	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
 	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
-	ASSERT(dp->i_df.if_u1.if_data != NULL);
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	ASSERT(sfp != NULL);
 	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
 
 	/*
@@ -1069,7 +1058,7 @@ xfs_dir2_sf_replace(
 		 */
 		xfs_dir2_sf_toino8(args);
 		i8elevated = 1;
-		sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+		sfp = dp->i_df.if_data;
 	} else
 		i8elevated = 0;
 
@@ -1150,11 +1139,11 @@ xfs_dir2_sf_toino4(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_dir2_sf_hdr	*oldsfp = dp->i_df.if_data;
 	char			*buf;		/* old dir's buffer */
 	int			i;		/* entry index */
 	int			newsize;	/* new inode size */
 	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
-	xfs_dir2_sf_hdr_t	*oldsfp;	/* old sf directory */
 	int			oldsize;	/* old inode size */
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
@@ -1168,7 +1157,6 @@ xfs_dir2_sf_toino4(
 	 */
 	oldsize = dp->i_df.if_bytes;
 	buf = kmem_alloc(oldsize, 0);
-	oldsfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	ASSERT(oldsfp->i8count == 1);
 	memcpy(buf, oldsfp, oldsize);
 	/*
@@ -1181,7 +1169,7 @@ xfs_dir2_sf_toino4(
 	 * Reset our pointers, the data has moved.
 	 */
 	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	sfp = dp->i_df.if_data;
 	/*
 	 * Fill in the new header.
 	 */
@@ -1223,11 +1211,11 @@ xfs_dir2_sf_toino8(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_dir2_sf_hdr	*oldsfp = dp->i_df.if_data;
 	char			*buf;		/* old dir's buffer */
 	int			i;		/* entry index */
 	int			newsize;	/* new inode size */
 	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
-	xfs_dir2_sf_hdr_t	*oldsfp;	/* old sf directory */
 	int			oldsize;	/* old inode size */
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
@@ -1241,7 +1229,6 @@ xfs_dir2_sf_toino8(
 	 */
 	oldsize = dp->i_df.if_bytes;
 	buf = kmem_alloc(oldsize, 0);
-	oldsfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	ASSERT(oldsfp->i8count == 0);
 	memcpy(buf, oldsfp, oldsize);
 	/*
@@ -1254,7 +1241,7 @@ xfs_dir2_sf_toino8(
 	 * Reset our pointers, the data has moved.
 	 */
 	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	sfp = dp->i_df.if_data;
 	/*
 	 * Fill in the new header.
 	 */
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index d062794cc79575..f4e6b200cdf8c1 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -158,7 +158,7 @@ static void *
 xfs_iext_find_first_leaf(
 	struct xfs_ifork	*ifp)
 {
-	struct xfs_iext_node	*node = ifp->if_u1.if_root;
+	struct xfs_iext_node	*node = ifp->if_data;
 	int			height;
 
 	if (!ifp->if_height)
@@ -176,7 +176,7 @@ static void *
 xfs_iext_find_last_leaf(
 	struct xfs_ifork	*ifp)
 {
-	struct xfs_iext_node	*node = ifp->if_u1.if_root;
+	struct xfs_iext_node	*node = ifp->if_data;
 	int			height, i;
 
 	if (!ifp->if_height)
@@ -306,7 +306,7 @@ xfs_iext_find_level(
 	xfs_fileoff_t		offset,
 	int			level)
 {
-	struct xfs_iext_node	*node = ifp->if_u1.if_root;
+	struct xfs_iext_node	*node = ifp->if_data;
 	int			height, i;
 
 	if (!ifp->if_height)
@@ -402,12 +402,12 @@ xfs_iext_grow(
 	int			i;
 
 	if (ifp->if_height == 1) {
-		struct xfs_iext_leaf *prev = ifp->if_u1.if_root;
+		struct xfs_iext_leaf *prev = ifp->if_data;
 
 		node->keys[0] = xfs_iext_leaf_key(prev, 0);
 		node->ptrs[0] = prev;
 	} else  {
-		struct xfs_iext_node *prev = ifp->if_u1.if_root;
+		struct xfs_iext_node *prev = ifp->if_data;
 
 		ASSERT(ifp->if_height > 1);
 
@@ -418,7 +418,7 @@ xfs_iext_grow(
 	for (i = 1; i < KEYS_PER_NODE; i++)
 		node->keys[i] = XFS_IEXT_KEY_INVALID;
 
-	ifp->if_u1.if_root = node;
+	ifp->if_data = node;
 	ifp->if_height++;
 }
 
@@ -430,7 +430,7 @@ xfs_iext_update_node(
 	int			level,
 	void			*ptr)
 {
-	struct xfs_iext_node	*node = ifp->if_u1.if_root;
+	struct xfs_iext_node	*node = ifp->if_data;
 	int			height, i;
 
 	for (height = ifp->if_height; height > level; height--) {
@@ -583,11 +583,11 @@ xfs_iext_alloc_root(
 {
 	ASSERT(ifp->if_bytes == 0);
 
-	ifp->if_u1.if_root = kmem_zalloc(sizeof(struct xfs_iext_rec), KM_NOFS);
+	ifp->if_data = kmem_zalloc(sizeof(struct xfs_iext_rec), KM_NOFS);
 	ifp->if_height = 1;
 
 	/* now that we have a node step into it */
-	cur->leaf = ifp->if_u1.if_root;
+	cur->leaf = ifp->if_data;
 	cur->pos = 0;
 }
 
@@ -603,9 +603,9 @@ xfs_iext_realloc_root(
 	if (new_size / sizeof(struct xfs_iext_rec) == RECS_PER_LEAF)
 		new_size = NODE_SIZE;
 
-	new = krealloc(ifp->if_u1.if_root, new_size, GFP_NOFS | __GFP_NOFAIL);
+	new = krealloc(ifp->if_data, new_size, GFP_NOFS | __GFP_NOFAIL);
 	memset(new + ifp->if_bytes, 0, new_size - ifp->if_bytes);
-	ifp->if_u1.if_root = new;
+	ifp->if_data = new;
 	cur->leaf = new;
 }
 
@@ -786,8 +786,8 @@ xfs_iext_remove_node(
 		 * If we are at the root and only one entry is left we can just
 		 * free this node and update the root pointer.
 		 */
-		ASSERT(node == ifp->if_u1.if_root);
-		ifp->if_u1.if_root = node->ptrs[0];
+		ASSERT(node == ifp->if_data);
+		ifp->if_data = node->ptrs[0];
 		ifp->if_height--;
 		kmem_free(node);
 	}
@@ -863,8 +863,8 @@ xfs_iext_free_last_leaf(
 	struct xfs_ifork	*ifp)
 {
 	ifp->if_height--;
-	kmem_free(ifp->if_u1.if_root);
-	ifp->if_u1.if_root = NULL;
+	kmem_free(ifp->if_data);
+	ifp->if_data = NULL;
 }
 
 void
@@ -881,7 +881,7 @@ xfs_iext_remove(
 	trace_xfs_iext_remove(ip, cur, state, _RET_IP_);
 
 	ASSERT(ifp->if_height > 0);
-	ASSERT(ifp->if_u1.if_root != NULL);
+	ASSERT(ifp->if_data != NULL);
 	ASSERT(xfs_iext_valid(ifp, cur));
 
 	xfs_iext_inc_seq(ifp);
@@ -1051,9 +1051,9 @@ void
 xfs_iext_destroy(
 	struct xfs_ifork	*ifp)
 {
-	xfs_iext_destroy_node(ifp->if_u1.if_root, ifp->if_height);
+	xfs_iext_destroy_node(ifp->if_data, ifp->if_height);
 
 	ifp->if_bytes = 0;
 	ifp->if_height = 0;
-	ifp->if_u1.if_root = NULL;
+	ifp->if_data = NULL;
 }
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index b86d57589f67e6..d23910e503a1ae 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -50,12 +50,15 @@ xfs_init_local_fork(
 		mem_size++;
 
 	if (size) {
-		ifp->if_u1.if_data = kmem_alloc(mem_size, KM_NOFS);
-		memcpy(ifp->if_u1.if_data, data, size);
+		char *new_data = kmem_alloc(mem_size, KM_NOFS);
+
+		memcpy(new_data, data, size);
 		if (zero_terminate)
-			ifp->if_u1.if_data[size] = '\0';
+			new_data[size] = '\0';
+
+		ifp->if_data = new_data;
 	} else {
-		ifp->if_u1.if_data = NULL;
+		ifp->if_data = NULL;
 	}
 
 	ifp->if_bytes = size;
@@ -125,7 +128,7 @@ xfs_iformat_extents(
 	}
 
 	ifp->if_bytes = 0;
-	ifp->if_u1.if_root = NULL;
+	ifp->if_data = NULL;
 	ifp->if_height = 0;
 	if (size) {
 		dp = (xfs_bmbt_rec_t *) XFS_DFORK_PTR(dip, whichfork);
@@ -212,7 +215,7 @@ xfs_iformat_btree(
 			 ifp->if_broot, size);
 
 	ifp->if_bytes = 0;
-	ifp->if_u1.if_root = NULL;
+	ifp->if_data = NULL;
 	ifp->if_height = 0;
 	return 0;
 }
@@ -509,14 +512,14 @@ xfs_idata_realloc(
 		return;
 
 	if (new_size == 0) {
-		kmem_free(ifp->if_u1.if_data);
-		ifp->if_u1.if_data = NULL;
+		kmem_free(ifp->if_data);
+		ifp->if_data = NULL;
 		ifp->if_bytes = 0;
 		return;
 	}
 
-	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, new_size,
-				      GFP_NOFS | __GFP_NOFAIL);
+	ifp->if_data = krealloc(ifp->if_data, new_size,
+			GFP_NOFS | __GFP_NOFAIL);
 	ifp->if_bytes = new_size;
 }
 
@@ -532,8 +535,8 @@ xfs_idestroy_fork(
 
 	switch (ifp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
-		kmem_free(ifp->if_u1.if_data);
-		ifp->if_u1.if_data = NULL;
+		kmem_free(ifp->if_data);
+		ifp->if_data = NULL;
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
@@ -626,9 +629,9 @@ xfs_iflush_fork(
 	case XFS_DINODE_FMT_LOCAL:
 		if ((iip->ili_fields & dataflag[whichfork]) &&
 		    (ifp->if_bytes > 0)) {
-			ASSERT(ifp->if_u1.if_data != NULL);
+			ASSERT(ifp->if_data != NULL);
 			ASSERT(ifp->if_bytes <= xfs_inode_fork_size(ip, whichfork));
-			memcpy(cp, ifp->if_u1.if_data, ifp->if_bytes);
+			memcpy(cp, ifp->if_data, ifp->if_bytes);
 		}
 		break;
 
@@ -706,17 +709,15 @@ xfs_ifork_verify_local_data(
 	case S_IFDIR: {
 		struct xfs_mount	*mp = ip->i_mount;
 		struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
-		struct xfs_dir2_sf_hdr	*sfp;
+		struct xfs_dir2_sf_hdr	*sfp = ifp->if_data;
 
-		sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
 		fa = xfs_dir2_sf_verify(mp, sfp, ifp->if_bytes);
 		break;
 	}
 	case S_IFLNK: {
 		struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
 
-		fa = xfs_symlink_shortform_verify(ifp->if_u1.if_data,
-				ifp->if_bytes);
+		fa = xfs_symlink_shortform_verify(ifp->if_data, ifp->if_bytes);
 		break;
 	}
 	default:
@@ -725,7 +726,7 @@ xfs_ifork_verify_local_data(
 
 	if (fa) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
-				ip->i_df.if_u1.if_data, ip->i_df.if_bytes, fa);
+				ip->i_df.if_data, ip->i_df.if_bytes, fa);
 		return -EFSCORRUPTED;
 	}
 
@@ -743,20 +744,14 @@ xfs_ifork_verify_local_attr(
 	if (!xfs_inode_has_attr_fork(ip)) {
 		fa = __this_address;
 	} else {
-		struct xfs_attr_shortform	*sfp;
-		struct xfs_ifork		*ifp;
-		int64_t				size;
-
-		ASSERT(ip->i_af.if_format == XFS_DINODE_FMT_LOCAL);
-		ifp = xfs_ifork_ptr(ip, XFS_ATTR_FORK);
-		sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
-		size = ifp->if_bytes;
+		struct xfs_ifork		*ifp = &ip->i_af;
 
-		fa = xfs_attr_shortform_verify(sfp, size);
+		ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
+		fa = xfs_attr_shortform_verify(ifp->if_data, ifp->if_bytes);
 	}
 	if (fa) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
-				ifp->if_u1.if_data, ifp->if_bytes, fa);
+				ifp->if_data, ifp->if_bytes, fa);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 535be5c036899c..7edcf0e8cd5388 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -13,14 +13,12 @@ struct xfs_dinode;
  * File incore extent information, present for each of data & attr forks.
  */
 struct xfs_ifork {
-	int64_t			if_bytes;	/* bytes in if_u1 */
+	int64_t			if_bytes;	/* bytes in if_data */
 	struct xfs_btree_block	*if_broot;	/* file's incore btree root */
 	unsigned int		if_seq;		/* fork mod counter */
 	int			if_height;	/* height of the extent tree */
-	union {
-		void		*if_root;	/* extent tree root */
-		char		*if_data;	/* inline file data */
-	} if_u1;
+	void			*if_data;	/* extent tree root or
+						   inline data */
 	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	int8_t			if_format;	/* format of this fork */
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 3c96d1d617fb0b..160aa20aa44139 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -175,7 +175,7 @@ xfs_symlink_local_to_remote(
 
 	if (!xfs_has_crc(mp)) {
 		bp->b_ops = NULL;
-		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
+		memcpy(bp->b_addr, ifp->if_data, ifp->if_bytes);
 		xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
 		return;
 	}
@@ -191,7 +191,7 @@ xfs_symlink_local_to_remote(
 
 	buf = bp->b_addr;
 	buf += xfs_symlink_hdr_set(mp, ip->i_ino, 0, ifp->if_bytes, bp);
-	memcpy(buf, ifp->if_u1.if_data, ifp->if_bytes);
+	memcpy(buf, ifp->if_data, ifp->if_bytes);
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsymlink_hdr) +
 					ifp->if_bytes - 1);
 }
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 6c16d9530ccaca..bac6fb2f01d880 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -527,19 +527,15 @@ xchk_xattr_check_sf(
 	struct xfs_scrub		*sc)
 {
 	struct xchk_xattr_buf		*ab = sc->buf;
-	struct xfs_attr_shortform	*sf;
+	struct xfs_ifork		*ifp = &sc->ip->i_af;
+	struct xfs_attr_shortform	*sf = ifp->if_data;
 	struct xfs_attr_sf_entry	*sfe;
 	struct xfs_attr_sf_entry	*next;
-	struct xfs_ifork		*ifp;
-	unsigned char			*end;
+	unsigned char			*end = ifp->if_data + ifp->if_bytes;
 	int				i;
 	int				error = 0;
 
-	ifp = xfs_ifork_ptr(sc->ip, XFS_ATTR_FORK);
-
 	bitmap_zero(ab->usedmap, ifp->if_bytes);
-	sf = (struct xfs_attr_shortform *)sc->ip->i_af.if_u1.if_data;
-	end = (unsigned char *)ifp->if_u1.if_data + ifp->if_bytes;
 	xchk_xattr_set_map(sc, ab->usedmap, 0, sizeof(sf->hdr));
 
 	sfe = &sf->list[0];
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index e51c1544be6323..16462332c897b1 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -36,16 +36,14 @@ xchk_dir_walk_sf(
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_geometry	*geo = mp->m_dir_geo;
 	struct xfs_dir2_sf_entry *sfep;
-	struct xfs_dir2_sf_hdr	*sfp;
+	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
 	xfs_ino_t		ino;
 	xfs_dir2_dataptr_t	dapos;
 	unsigned int		i;
 	int			error;
 
 	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
-	ASSERT(dp->i_df.if_u1.if_data != NULL);
-
-	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
+	ASSERT(sfp != NULL);
 
 	/* dot entry */
 	dapos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 60643d791d4a22..ddff86713df353 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -61,7 +61,7 @@ xchk_symlink(
 	/* Inline symlink? */
 	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
 		if (len > xfs_inode_data_fork_size(ip) ||
-		    len > strnlen(ifp->if_u1.if_data, xfs_inode_data_fork_size(ip)))
+		    len > strnlen(ifp->if_data, xfs_inode_data_fork_size(ip)))
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		return 0;
 	}
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 99bbbe1a0e4478..8700b00e154c98 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -56,12 +56,11 @@ xfs_attr_shortform_list(
 	struct xfs_attrlist_cursor_kern	*cursor = &context->cursor;
 	struct xfs_inode		*dp = context->dp;
 	struct xfs_attr_sf_sort		*sbuf, *sbp;
-	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_shortform	*sf = dp->i_af.if_data;
 	struct xfs_attr_sf_entry	*sfe;
 	int				sbsize, nsbuf, count, i;
 	int				error = 0;
 
-	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
 	ASSERT(sf != NULL);
 	if (!sf->hdr.count)
 		return 0;
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 57f42c2af0a316..cc6dc56f455d0c 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -52,7 +52,7 @@ xfs_dir2_sf_getdents(
 	struct xfs_mount	*mp = dp->i_mount;
 	xfs_dir2_dataptr_t	off;		/* current entry's offset */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
-	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
+	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
 	xfs_dir2_dataptr_t	dot_offset;
 	xfs_dir2_dataptr_t	dotdot_offset;
 	xfs_ino_t		ino;
@@ -60,9 +60,7 @@ xfs_dir2_sf_getdents(
 
 	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
 	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
-	ASSERT(dp->i_df.if_u1.if_data != NULL);
-
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	ASSERT(sfp != NULL);
 
 	/*
 	 * If the block number in the offset is out of range, we're done.
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1ffc8dfa2a52ce..1fd94958aa97aa 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -872,7 +872,7 @@ xfs_init_new_inode(
 	case S_IFLNK:
 		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 		ip->i_df.if_bytes = 0;
-		ip->i_df.if_u1.if_root = NULL;
+		ip->i_df.if_data = NULL;
 		break;
 	default:
 		ASSERT(0);
@@ -2378,8 +2378,8 @@ xfs_ifree(
 	 * already been freed by xfs_attr_inactive.
 	 */
 	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
-		kmem_free(ip->i_df.if_u1.if_data);
-		ip->i_df.if_u1.if_data = NULL;
+		kmem_free(ip->i_df.if_data);
+		ip->i_df.if_data = NULL;
 		ip->i_df.if_bytes = 0;
 	}
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index b35335e20342c7..0aee97ba0be81f 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -352,11 +352,10 @@ xfs_inode_item_format_data_fork(
 			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT | XFS_ILOG_DEV);
 		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
 		    ip->i_df.if_bytes > 0) {
-			ASSERT(ip->i_df.if_u1.if_data != NULL);
+			ASSERT(ip->i_df.if_data != NULL);
 			ASSERT(ip->i_disk_size > 0);
 			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_ILOCAL,
-					ip->i_df.if_u1.if_data,
-					ip->i_df.if_bytes);
+					ip->i_df.if_data, ip->i_df.if_bytes);
 			ilf->ilf_dsize = (unsigned)ip->i_df.if_bytes;
 			ilf->ilf_size++;
 		} else {
@@ -431,10 +430,9 @@ xfs_inode_item_format_attr_fork(
 
 		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
 		    ip->i_af.if_bytes > 0) {
-			ASSERT(ip->i_af.if_u1.if_data != NULL);
+			ASSERT(ip->i_af.if_data != NULL);
 			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_LOCAL,
-					ip->i_af.if_u1.if_data,
-					ip->i_af.if_bytes);
+					ip->i_af.if_data, ip->i_af.if_bytes);
 			ilf->ilf_asize = (unsigned)ip->i_af.if_bytes;
 			ilf->ilf_size++;
 		} else {
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 7c713727f7fd37..92974a4414c832 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -131,10 +131,10 @@ xfs_readlink(
 		 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED
 		 * if if_data is junk.
 		 */
-		if (XFS_IS_CORRUPT(ip->i_mount, !ip->i_df.if_u1.if_data))
+		if (XFS_IS_CORRUPT(ip->i_mount, !ip->i_df.if_data))
 			goto out;
 
-		memcpy(link, ip->i_df.if_u1.if_data, pathlen + 1);
+		memcpy(link, ip->i_df.if_data, pathlen + 1);
 		error = 0;
 	} else {
 		error = xfs_readlink_bmap_ilocked(ip, link);
-- 
2.39.2

