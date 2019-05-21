Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44416 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbfEURBI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 13:01:08 -0400
Date: Tue, 21 May 2019 10:01:03 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/12] libfrog: fix bitmap return values
Message-ID: <20190521170103.GD5141@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839424514.68606.14562327454853103352.stgit@magnolia>
 <5caa6c9e-3a42-6c8e-101b-c198af77e765@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5caa6c9e-3a42-6c8e-101b-c198af77e765@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 11:54:18AM -0500, Eric Sandeen wrote:
> On 5/20/19 6:17 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fix the return types of non-predicate bitmap functions to return the
> > usual negative error codes instead of the "moveon" boolean.
> 
> This seems much better, though how did you decide on negative
> error codes?  They are usual for the kernel, but in userspace
> we have kind of a mishmash, even in libfrog.
> 
>   File                 Function                 Line
> 0 libfrog/paths.c      fs_table_insert          176 error = ENOMEM;
> 1 libfrog/paths.c      fs_extract_mount_options 354 return ENOMEM;
> 2 libfrog/radix-tree.c radix_tree_extend        135 return -ENOMEM;
> 3 libfrog/radix-tree.c radix_tree_insert        188 return -ENOMEM;
> 4 libfrog/workqueue.c  workqueue_add            110 return ENOMEM;
> 
> 3 libfrog/paths.c         fs_table_initialise_mounts         384 return ENOENT;
> 4 libfrog/paths.c         fs_table_initialise_projects       489 error = ENOENT;
> 5 libfrog/paths.c         fs_table_insert_project_path       560 error = ENOENT;

Blindly copying libxfs style. :)

I see your point about being consistent within libfrog but OTOH it's
messy that we're not consistent across the various xfsprogs libraries.

Uhm.... I'll change it if you want.

--D

> 
> 
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  include/bitmap.h |    8 +++--
> >  libfrog/bitmap.c |   86 ++++++++++++++++++++++++++----------------------------
> >  repair/rmap.c    |   18 ++++++++---
> >  scrub/phase6.c   |   18 ++++-------
> >  4 files changed, 65 insertions(+), 65 deletions(-)
> > 
> > 
> > diff --git a/include/bitmap.h b/include/bitmap.h
> > index e29a4335..99a2fb23 100644
> > --- a/include/bitmap.h
> > +++ b/include/bitmap.h
> > @@ -11,11 +11,11 @@ struct bitmap {
> >  	struct avl64tree_desc	*bt_tree;
> >  };
> >  
> > -bool bitmap_init(struct bitmap **bmap);
> > +int bitmap_init(struct bitmap **bmap);
> >  void bitmap_free(struct bitmap **bmap);
> > -bool bitmap_set(struct bitmap *bmap, uint64_t start, uint64_t length);
> > -bool bitmap_iterate(struct bitmap *bmap,
> > -		bool (*fn)(uint64_t, uint64_t, void *), void *arg);
> > +int bitmap_set(struct bitmap *bmap, uint64_t start, uint64_t length);
> > +int bitmap_iterate(struct bitmap *bmap, int (*fn)(uint64_t, uint64_t, void *),
> > +		void *arg);
> >  bool bitmap_test(struct bitmap *bmap, uint64_t start,
> >  		uint64_t len);
> >  bool bitmap_empty(struct bitmap *bmap);
> > diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
> > index 450ebe0a..4dafc4c9 100644
> > --- a/libfrog/bitmap.c
> > +++ b/libfrog/bitmap.c
> > @@ -66,7 +66,7 @@ static struct avl64ops bitmap_ops = {
> >  };
> >  
> >  /* Initialize a bitmap. */
> > -bool
> > +int
> >  bitmap_init(
> >  	struct bitmap		**bmapp)
> >  {
> > @@ -74,18 +74,18 @@ bitmap_init(
> >  
> >  	bmap = calloc(1, sizeof(struct bitmap));
> >  	if (!bmap)
> > -		return false;
> > +		return -ENOMEM;
> >  	bmap->bt_tree = malloc(sizeof(struct avl64tree_desc));
> >  	if (!bmap->bt_tree) {
> >  		free(bmap);
> > -		return false;
> > +		return -ENOMEM;
> >  	}
> >  
> >  	pthread_mutex_init(&bmap->bt_lock, NULL);
> >  	avl64_init_tree(bmap->bt_tree, &bitmap_ops);
> >  	*bmapp = bmap;
> >  
> > -	return true;
> > +	return 0;
> >  }
> >  
> >  /* Free a bitmap. */
> > @@ -127,8 +127,31 @@ bitmap_node_init(
> >  	return ext;
> >  }
> >  
> > +/* Create a new bitmap node and insert it. */
> > +static inline int
> > +__bitmap_insert(
> > +	struct bitmap		*bmap,
> > +	uint64_t		start,
> > +	uint64_t		length)
> > +{
> > +	struct bitmap_node	*ext;
> > +	struct avl64node	*node;
> > +
> > +	ext = bitmap_node_init(start, length);
> > +	if (!ext)
> > +		return -ENOMEM;
> > +
> > +	node = avl64_insert(bmap->bt_tree, &ext->btn_node);
> > +	if (node == NULL) {
> > +		free(ext);
> > +		return -EEXIST;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /* Set a region of bits (locked). */
> > -static bool
> > +static int
> >  __bitmap_set(
> >  	struct bitmap		*bmap,
> >  	uint64_t		start,
> > @@ -142,28 +165,14 @@ __bitmap_set(
> >  	struct bitmap_node	*ext;
> >  	uint64_t		new_start;
> >  	uint64_t		new_length;
> > -	struct avl64node	*node;
> > -	bool			res = true;
> >  
> >  	/* Find any existing nodes adjacent or within that range. */
> >  	avl64_findranges(bmap->bt_tree, start - 1, start + length + 1,
> >  			&firstn, &lastn);
> >  
> >  	/* Nothing, just insert a new extent. */
> > -	if (firstn == NULL && lastn == NULL) {
> > -		ext = bitmap_node_init(start, length);
> > -		if (!ext)
> > -			return false;
> > -
> > -		node = avl64_insert(bmap->bt_tree, &ext->btn_node);
> > -		if (node == NULL) {
> > -			free(ext);
> > -			errno = EEXIST;
> > -			return false;
> > -		}
> > -
> > -		return true;
> > -	}
> > +	if (firstn == NULL && lastn == NULL)
> > +		return __bitmap_insert(bmap, start, length);
> >  
> >  	assert(firstn != NULL && lastn != NULL);
> >  	new_start = start;
> > @@ -175,7 +184,7 @@ __bitmap_set(
> >  		/* Bail if the new extent is contained within an old one. */
> >  		if (ext->btn_start <= start &&
> >  		    ext->btn_start + ext->btn_length >= start + length)
> > -			return res;
> > +			return 0;
> >  
> >  		/* Check for overlapping and adjacent extents. */
> >  		if (ext->btn_start + ext->btn_length >= start ||
> > @@ -195,28 +204,17 @@ __bitmap_set(
> >  		}
> >  	}
> >  
> > -	ext = bitmap_node_init(new_start, new_length);
> > -	if (!ext)
> > -		return false;
> > -
> > -	node = avl64_insert(bmap->bt_tree, &ext->btn_node);
> > -	if (node == NULL) {
> > -		free(ext);
> > -		errno = EEXIST;
> > -		return false;
> > -	}
> > -
> > -	return res;
> > +	return __bitmap_insert(bmap, new_start, new_length);
> >  }
> >  
> >  /* Set a region of bits. */
> > -bool
> > +int
> >  bitmap_set(
> >  	struct bitmap		*bmap,
> >  	uint64_t		start,
> >  	uint64_t		length)
> >  {
> > -	bool			res;
> > +	int			res;
> >  
> >  	pthread_mutex_lock(&bmap->bt_lock);
> >  	res = __bitmap_set(bmap, start, length);
> > @@ -308,26 +306,26 @@ bitmap_clear(
> >  
> >  #ifdef DEBUG
> >  /* Iterate the set regions of this bitmap. */
> > -bool
> > +int
> >  bitmap_iterate(
> >  	struct bitmap		*bmap,
> > -	bool			(*fn)(uint64_t, uint64_t, void *),
> > +	int			(*fn)(uint64_t, uint64_t, void *),
> >  	void			*arg)
> >  {
> >  	struct avl64node	*node;
> >  	struct bitmap_node	*ext;
> > -	bool			moveon = true;
> > +	int			error = 0;
> >  
> >  	pthread_mutex_lock(&bmap->bt_lock);
> >  	avl_for_each(bmap->bt_tree, node) {
> >  		ext = container_of(node, struct bitmap_node, btn_node);
> > -		moveon = fn(ext->btn_start, ext->btn_length, arg);
> > -		if (!moveon)
> > +		error = fn(ext->btn_start, ext->btn_length, arg);
> > +		if (error)
> >  			break;
> >  	}
> >  	pthread_mutex_unlock(&bmap->bt_lock);
> >  
> > -	return moveon;
> > +	return error;
> >  }
> >  #endif
> >  
> > @@ -372,14 +370,14 @@ bitmap_empty(
> >  }
> >  
> >  #ifdef DEBUG
> > -static bool
> > +static int
> >  bitmap_dump_fn(
> >  	uint64_t		startblock,
> >  	uint64_t		blockcount,
> >  	void			*arg)
> >  {
> >  	printf("%"PRIu64":%"PRIu64"\n", startblock, blockcount);
> > -	return true;
> > +	return 0;
> >  }
> >  
> >  /* Dump bitmap. */
> > diff --git a/repair/rmap.c b/repair/rmap.c
> > index 19cceca3..47828a06 100644
> > --- a/repair/rmap.c
> > +++ b/repair/rmap.c
> > @@ -490,16 +490,22 @@ rmap_store_ag_btree_rec(
> >  	error = init_slab_cursor(ag_rmap->ar_raw_rmaps, rmap_compare, &rm_cur);
> >  	if (error)
> >  		goto err;
> > -	if (!bitmap_init(&own_ag_bitmap)) {
> > -		error = -ENOMEM;
> > +	error = -bitmap_init(&own_ag_bitmap);
> > +	if (error)
> >  		goto err_slab;
> > -	}
> >  	while ((rm_rec = pop_slab_cursor(rm_cur)) != NULL) {
> >  		if (rm_rec->rm_owner != XFS_RMAP_OWN_AG)
> >  			continue;
> > -		if (!bitmap_set(own_ag_bitmap, rm_rec->rm_startblock,
> > -					rm_rec->rm_blockcount)) {
> > -			error = EFSCORRUPTED;
> > +		error = -bitmap_set(own_ag_bitmap, rm_rec->rm_startblock,
> > +					rm_rec->rm_blockcount);
> > +		if (error) {
> > +			/*
> > +			 * If this range is already set, then the incore rmap
> > +			 * records for the AG free space btrees overlap and
> > +			 * we're toast because that is not allowed.
> > +			 */
> > +			if (error == EEXIST)
> > +				error = EFSCORRUPTED;
> >  			goto err_slab;
> >  		}
> >  	}
> > diff --git a/scrub/phase6.c b/scrub/phase6.c
> > index 4b25f3bb..66e6451c 100644
> > --- a/scrub/phase6.c
> > +++ b/scrub/phase6.c
> > @@ -341,7 +341,6 @@ xfs_check_rmap_ioerr(
> >  	struct media_verify_state	*vs = arg;
> >  	struct bitmap			*tree;
> >  	dev_t				dev;
> > -	bool				moveon;
> >  
> >  	dev = xfs_disk_to_dev(ctx, disk);
> >  
> > @@ -356,8 +355,8 @@ xfs_check_rmap_ioerr(
> >  	else
> >  		tree = NULL;
> >  	if (tree) {
> > -		moveon = bitmap_set(tree, start, length);
> > -		if (!moveon)
> > +		errno = -bitmap_set(tree, start, length);
> > +		if (errno)
> >  			str_errno(ctx, ctx->mntpoint);
> >  	}
> >  
> > @@ -454,16 +453,16 @@ xfs_scan_blocks(
> >  	struct scrub_ctx		*ctx)
> >  {
> >  	struct media_verify_state	vs = { NULL };
> > -	bool				moveon;
> > +	bool				moveon = false;
> >  
> > -	moveon = bitmap_init(&vs.d_bad);
> > -	if (!moveon) {
> > +	errno = -bitmap_init(&vs.d_bad);
> > +	if (errno) {
> >  		str_errno(ctx, ctx->mntpoint);
> >  		goto out;
> >  	}
> >  
> > -	moveon = bitmap_init(&vs.r_bad);
> > -	if (!moveon) {
> > +	errno = -bitmap_init(&vs.r_bad);
> > +	if (errno) {
> >  		str_errno(ctx, ctx->mntpoint);
> >  		goto out_dbad;
> >  	}
> > @@ -472,7 +471,6 @@ xfs_scan_blocks(
> >  			ctx->geo.blocksize, xfs_check_rmap_ioerr,
> >  			scrub_nproc(ctx));
> >  	if (!vs.rvp_data) {
> > -		moveon = false;
> >  		str_info(ctx, ctx->mntpoint,
> >  _("Could not create data device media verifier."));
> >  		goto out_rbad;
> > @@ -482,7 +480,6 @@ _("Could not create data device media verifier."));
> >  				ctx->geo.blocksize, xfs_check_rmap_ioerr,
> >  				scrub_nproc(ctx));
> >  		if (!vs.rvp_log) {
> > -			moveon = false;
> >  			str_info(ctx, ctx->mntpoint,
> >  	_("Could not create log device media verifier."));
> >  			goto out_datapool;
> > @@ -493,7 +490,6 @@ _("Could not create data device media verifier."));
> >  				ctx->geo.blocksize, xfs_check_rmap_ioerr,
> >  				scrub_nproc(ctx));
> >  		if (!vs.rvp_realtime) {
> > -			moveon = false;
> >  			str_info(ctx, ctx->mntpoint,
> >  	_("Could not create realtime device media verifier."));
> >  			goto out_logpool;
> > 
