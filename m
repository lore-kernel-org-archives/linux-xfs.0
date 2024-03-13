Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C6279C5
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295627; cv=none; b=C7eFjCPn5DGfTMNXPiAyu6OC8UItR/96XUJ3WEIUVU+cqeV1Qqq/osDB+edM3r5DrfhTRoeE5Qb5KZQqVyFhsXnwKuIMp6eZntGNcAs23qcEqvXLfAEM6DIb/J5PLCymzQj+LQKyc6LZTpxDZIrPoNtFS5AhT7yZ509mFwGoDPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295627; c=relaxed/simple;
	bh=86u8XVXo9WbhasyfPaYy9M90qtUrFAfdYMsRrsmc/TQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gRVf6WWawyM3hfmk59sdSlbwtduTF9kpYsOH9LKkjLdIQLZF087fmddtiLEsQ2zwmPgGeJPsHsqOUUm2zZ9RFlCZsvWhkgMxOOXIJoNqK32QCVpQfrTOvJzfPKDNaq9KNXL4BuENPrhw+jYvGbKF/qp1/DGnhjZQedW6S3rLvzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=km5zteb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="km5zteb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F315C43390;
	Wed, 13 Mar 2024 02:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295627;
	bh=86u8XVXo9WbhasyfPaYy9M90qtUrFAfdYMsRrsmc/TQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=km5zteb94ENB3ExsHukmEKMJ3CzWIvOnwbuU0+AZmWfNzpoHWtAmPtH40Gl+WDQqn
	 y6EYhkYtsTi3uOkhXXF+tjjJPgF0gzC6clfAmyyGOPazwM67ce+8h3FgGuv1A0jqA4
	 UVnpBHc2+xmEBYO4+QlprLvmOHpKIrZvcFFAJyKAEGNzBugYse4eVY3xXdhPsBfRyP
	 bRWLqwITsFGUb8FiX936RHfQTy2oGzIrQxwEM/tNWG7sqmLCMcm7dgz17kkWzzFs/h
	 +n9i2MA2+akZSVh2cghlRvwl/tVYQA9BGxk1+atV8eoAO1vZgTaZ0vs88ZuzJlXupF
	 rjKE9aobZYvGQ==
Date: Tue, 12 Mar 2024 19:07:06 -0700
Subject: [PATCH 54/67] xfs: make if_data a void pointer
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171029431972.2061787.17434728385863254413.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 6e145f943bd86be47e54101fa5939f9ed0cb73e5

The xfs_ifork structure currently has a union of the if_root void pointer
and the if_data char pointer.  In either case it is an opaque pointer
that depends on the fork format.  Replace the union with a single if_data
void pointer as that is what almost all callers want.  Only the symlink
NULL termination code in xfs_init_local_fork actually needs a new local
variable now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 db/namei.c                  |    4 +--
 libxfs/util.c               |    2 +
 libxfs/xfs_attr.c           |    3 +-
 libxfs/xfs_attr_leaf.c      |   62 +++++++++++++++++--------------------------
 libxfs/xfs_bmap.c           |    4 +--
 libxfs/xfs_dir2.c           |    2 +
 libxfs/xfs_dir2_block.c     |    6 +---
 libxfs/xfs_dir2_sf.c        |   61 +++++++++++++++++-------------------------
 libxfs/xfs_iext_tree.c      |   36 ++++++++++++-------------
 libxfs/xfs_inode_fork.c     |   53 +++++++++++++++++--------------------
 libxfs/xfs_inode_fork.h     |    8 ++----
 libxfs/xfs_symlink_remote.c |    4 +--
 repair/phase6.c             |    9 +++---
 13 files changed, 107 insertions(+), 147 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index 063721ca98f2..5a6fd2036a37 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -290,14 +290,12 @@ list_sfdir(
 	struct xfs_mount		*mp = dp->i_mount;
 	struct xfs_da_geometry		*geo = args->geo;
 	struct xfs_dir2_sf_entry	*sfep;
-	struct xfs_dir2_sf_hdr		*sfp;
+	struct xfs_dir2_sf_hdr		*sfp = dp->i_df.if_data;
 	xfs_ino_t			ino;
 	xfs_dir2_dataptr_t		off;
 	unsigned int			i;
 	uint8_t				filetype;
 
-	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
-
 	/* . and .. entries */
 	off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 			geo->data_entry_offset);
diff --git a/libxfs/util.c b/libxfs/util.c
index 8517bfb64b52..8cea0c1500b4 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -316,7 +316,7 @@ libxfs_init_new_inode(
 	case S_IFLNK:
 		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 		ip->i_df.if_bytes = 0;
-		ip->i_df.if_u1.if_root = NULL;
+		ip->i_df.if_data = NULL;
 		break;
 	default:
 		ASSERT(0);
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index cb6c8d081fd3..d7512efd42a8 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1047,9 +1047,8 @@ xfs_attr_set(
 
 static inline int xfs_attr_sf_totsize(struct xfs_inode *dp)
 {
-	struct xfs_attr_shortform *sf;
+	struct xfs_attr_shortform *sf = dp->i_af.if_data;
 
-	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
 	return be16_to_cpu(sf->hdr.totsize);
 }
 
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 8329348eb78b..5ab52bf1aa66 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -688,7 +688,7 @@ xfs_attr_shortform_create(
 	if (ifp->if_format == XFS_DINODE_FMT_EXTENTS)
 		ifp->if_format = XFS_DINODE_FMT_LOCAL;
 	xfs_idata_realloc(dp, sizeof(*hdr), XFS_ATTR_FORK);
-	hdr = (struct xfs_attr_sf_hdr *)ifp->if_u1.if_data;
+	hdr = ifp->if_data;
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->totsize = cpu_to_be16(sizeof(*hdr));
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_ADATA);
@@ -709,14 +709,13 @@ xfs_attr_sf_findname(
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
@@ -748,29 +747,25 @@ xfs_attr_shortform_add(
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
@@ -808,20 +803,16 @@ int
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
@@ -875,18 +866,17 @@ xfs_attr_sf_removename(
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
@@ -906,14 +896,13 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
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
@@ -930,25 +919,22 @@ int
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
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index b977032d8244..5e6a5e1f355b 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -741,7 +741,7 @@ xfs_bmap_local_to_extents_empty(
 	ASSERT(ifp->if_nextents == 0);
 
 	xfs_bmap_forkoff_reset(ip, whichfork);
-	ifp->if_u1.if_root = NULL;
+	ifp->if_data = NULL;
 	ifp->if_height = 0;
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
@@ -826,7 +826,7 @@ xfs_bmap_local_to_extents(
 	xfs_bmap_local_to_extents_empty(tp, ip, whichfork);
 	flags |= XFS_ILOG_CORE;
 
-	ifp->if_u1.if_root = NULL;
+	ifp->if_data = NULL;
 	ifp->if_height = 0;
 
 	rec.br_startoff = 0;
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index c19684b34017..a781520c856d 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -195,7 +195,7 @@ xfs_dir_isempty(
 		return 1;
 	if (dp->i_disk_size > xfs_inode_data_fork_size(dp))
 		return 0;
-	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
+	sfp = dp->i_df.if_data;
 	return !sfp->count;
 }
 
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index bb9301b76880..bf950c7001f8 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -1086,7 +1086,7 @@ xfs_dir2_sf_to_block(
 	int			newoffset;	/* offset from current entry */
 	unsigned int		offset = geo->data_entry_offset;
 	xfs_dir2_sf_entry_t	*sfep;		/* sf entry pointer */
-	xfs_dir2_sf_hdr_t	*oldsfp;	/* old shortform header  */
+	struct xfs_dir2_sf_hdr	*oldsfp = ifp->if_data;
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform header  */
 	__be16			*tagp;		/* end of data entry */
 	struct xfs_name		name;
@@ -1096,10 +1096,8 @@ xfs_dir2_sf_to_block(
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 	ASSERT(dp->i_disk_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 
-	oldsfp = (xfs_dir2_sf_hdr_t *)ifp->if_u1.if_data;
-
 	ASSERT(ifp->if_bytes == dp->i_disk_size);
-	ASSERT(ifp->if_u1.if_data != NULL);
+	ASSERT(oldsfp != NULL);
 	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(oldsfp->i8count));
 	ASSERT(dp->i_df.if_nextents == 0);
 
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 260eccacf176..b2b43e937476 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
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
diff --git a/libxfs/xfs_iext_tree.c b/libxfs/xfs_iext_tree.c
index 5d0be2dc8fed..24124039fdd8 100644
--- a/libxfs/xfs_iext_tree.c
+++ b/libxfs/xfs_iext_tree.c
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
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 80f4215d24bd..fbcda5f544a7 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -48,12 +48,15 @@ xfs_init_local_fork(
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
@@ -123,7 +126,7 @@ xfs_iformat_extents(
 	}
 
 	ifp->if_bytes = 0;
-	ifp->if_u1.if_root = NULL;
+	ifp->if_data = NULL;
 	ifp->if_height = 0;
 	if (size) {
 		dp = (xfs_bmbt_rec_t *) XFS_DFORK_PTR(dip, whichfork);
@@ -210,7 +213,7 @@ xfs_iformat_btree(
 			 ifp->if_broot, size);
 
 	ifp->if_bytes = 0;
-	ifp->if_u1.if_root = NULL;
+	ifp->if_data = NULL;
 	ifp->if_height = 0;
 	return 0;
 }
@@ -507,14 +510,14 @@ xfs_idata_realloc(
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
 
@@ -530,8 +533,8 @@ xfs_idestroy_fork(
 
 	switch (ifp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
-		kmem_free(ifp->if_u1.if_data);
-		ifp->if_u1.if_data = NULL;
+		kmem_free(ifp->if_data);
+		ifp->if_data = NULL;
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
@@ -624,9 +627,9 @@ xfs_iflush_fork(
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
 
@@ -704,17 +707,15 @@ xfs_ifork_verify_local_data(
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
@@ -723,7 +724,7 @@ xfs_ifork_verify_local_data(
 
 	if (fa) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
-				ip->i_df.if_u1.if_data, ip->i_df.if_bytes, fa);
+				ip->i_df.if_data, ip->i_df.if_bytes, fa);
 		return -EFSCORRUPTED;
 	}
 
@@ -741,20 +742,14 @@ xfs_ifork_verify_local_attr(
 	if (!xfs_inode_has_attr_fork(ip)) {
 		fa = __this_address;
 	} else {
-		struct xfs_attr_shortform	*sfp;
-		struct xfs_ifork		*ifp;
-		int64_t				size;
+		struct xfs_ifork		*ifp = &ip->i_af;
 
-		ASSERT(ip->i_af.if_format == XFS_DINODE_FMT_LOCAL);
-		ifp = xfs_ifork_ptr(ip, XFS_ATTR_FORK);
-		sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
-		size = ifp->if_bytes;
-
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
 
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 535be5c03689..7edcf0e8cd53 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
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
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index cf894b5276ac..fa90b179314d 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -172,7 +172,7 @@ xfs_symlink_local_to_remote(
 
 	if (!xfs_has_crc(mp)) {
 		bp->b_ops = NULL;
-		memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
+		memcpy(bp->b_addr, ifp->if_data, ifp->if_bytes);
 		xfs_trans_log_buf(tp, bp, 0, ifp->if_bytes - 1);
 		return;
 	}
@@ -188,7 +188,7 @@ xfs_symlink_local_to_remote(
 
 	buf = bp->b_addr;
 	buf += xfs_symlink_hdr_set(mp, ip->i_ino, 0, ifp->if_bytes, bp);
-	memcpy(buf, ifp->if_u1.if_data, ifp->if_bytes);
+	memcpy(buf, ifp->if_data, ifp->if_bytes);
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsymlink_hdr) +
 					ifp->if_bytes - 1);
 }
diff --git a/repair/phase6.c b/repair/phase6.c
index fcb26d594b10..43a4c1406372 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -515,7 +515,7 @@ mk_rbmino(xfs_mount_t *mp)
 	 * now the ifork
 	 */
 	ip->i_df.if_bytes = 0;
-	ip->i_df.if_u1.if_root = NULL;
+	ip->i_df.if_data = NULL;
 
 	ip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
 
@@ -770,7 +770,7 @@ mk_rsumino(xfs_mount_t *mp)
 	 * now the ifork
 	 */
 	ip->i_df.if_bytes = 0;
-	ip->i_df.if_u1.if_root = NULL;
+	ip->i_df.if_data = NULL;
 
 	ip->i_disk_size = mp->m_rsumsize;
 
@@ -870,7 +870,7 @@ mk_root_dir(xfs_mount_t *mp)
 	 * now the ifork
 	 */
 	ip->i_df.if_bytes = 0;
-	ip->i_df.if_u1.if_root = NULL;
+	ip->i_df.if_data = NULL;
 
 	/*
 	 * initialize the directory
@@ -2472,7 +2472,7 @@ shortform_dir2_entry_check(
 {
 	xfs_ino_t		lino;
 	xfs_ino_t		parent;
-	struct xfs_dir2_sf_hdr	*sfp;
+	struct xfs_dir2_sf_hdr	*sfp = ip->i_df.if_data;
 	struct xfs_dir2_sf_entry *sfep;
 	struct xfs_dir2_sf_entry *next_sfep;
 	struct xfs_ifork	*ifp;
@@ -2487,7 +2487,6 @@ shortform_dir2_entry_check(
 	int			i8;
 
 	ifp = &ip->i_df;
-	sfp = (struct xfs_dir2_sf_hdr *) ifp->if_u1.if_data;
 	*ino_dirty = 0;
 	bytes_deleted = 0;
 

