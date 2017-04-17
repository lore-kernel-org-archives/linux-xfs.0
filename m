Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38074 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752140AbdDQSIU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Apr 2017 14:08:20 -0400
Date: Mon, 17 Apr 2017 14:08:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/10] xfs: kill the dop_low flag
Message-ID: <20170417180817.GB42232@bfoster.bfoster>
References: <20170413080517.12564-1-hch@lst.de>
 <20170413080517.12564-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413080517.12564-10-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 10:05:16AM +0200, Christoph Hellwig wrote:
> Now that we always get our space reservations right in xfs_bmapi_write
> we can remove the last remains of the dangerous low space allocator mode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 12 +-----------
>  fs/xfs/libxfs/xfs_bmap_btree.c |  2 --
>  fs/xfs/libxfs/xfs_defer.c      |  1 -
>  fs/xfs/libxfs/xfs_defer.h      | 15 ---------------
>  fs/xfs/xfs_filestream.c        |  2 --
>  fs/xfs/xfs_trace.h             | 12 +++---------
>  6 files changed, 4 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index c06e7d500ed1..9e3f0e6a9062 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -762,9 +762,6 @@ xfs_bmap_extents_to_btree(
>  	if (*firstblock == NULLFSBLOCK) {
>  		args.type = XFS_ALLOCTYPE_START_BNO;
>  		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
> -	} else if (dfops->dop_low) {
> -		args.type = XFS_ALLOCTYPE_START_BNO;
> -		args.fsbno = *firstblock;
>  	} else {
>  		args.type = XFS_ALLOCTYPE_NEAR_BNO;
>  		args.fsbno = *firstblock;
> @@ -3677,12 +3674,6 @@ xfs_bmap_btalloc(
>  			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
>  		if (error)
>  			return error;
> -	} else if (ap->dfops->dop_low) {
> -		if (xfs_inode_is_filestream(ap->ip))
> -			args.type = XFS_ALLOCTYPE_FIRST_AG;
> -		else
> -			args.type = XFS_ALLOCTYPE_START_BNO;
> -		args.minlen = 1;
>  	} else {
>  		args.type = XFS_ALLOCTYPE_NEAR_BNO;
>  		args.minlen = 1;
> @@ -3709,7 +3700,7 @@ xfs_bmap_btalloc(
>  	 * is >= the stripe unit and the allocation offset is
>  	 * at the end of file.
>  	 */
> -	if (!ap->dfops->dop_low && ap->aeof) {
> +	if (ap->aeof) {

The comment above looks like it needs updating.

>  		if (!ap->offset) {
>  			args.alignment = stripe_align;
>  			atype = args.type;
> @@ -3816,7 +3807,6 @@ xfs_bmap_btalloc(
>  		args.type = XFS_ALLOCTYPE_FIRST_AG;
>  		if ((error = xfs_alloc_vextent(&args)))
>  			return error;
> -		ap->dfops->dop_low = true;
>  	}
>  	if (args.fsbno != NULLFSBLOCK) {
>  		/*
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 153c969febd4..b9f0f61bd8ee 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -462,8 +462,6 @@ xfs_bmbt_alloc_block(
>  		 */
>  		if (xfs_trans_blk_res(args.tp))
>  			args.minleft = xfs_trans_blk_res(args.tp) - args.maxlen;
> -	} else if (cur->bc_private.b.dfops->dop_low) {
> -		args.type = XFS_ALLOCTYPE_START_BNO;

I'm not convinced this bit is safe, based on the comments on patch 4
that removes the dop_low activation logic from this context...

Brian

>  	} else {
>  		args.type = XFS_ALLOCTYPE_NEAR_BNO;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 5c2929f94bd3..172d583c6f1c 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -503,7 +503,6 @@ xfs_defer_init(
>  	xfs_fsblock_t			*fbp)
>  {
>  	dop->dop_committed = false;
> -	dop->dop_low = false;
>  	memset(&dop->dop_inodes, 0, sizeof(dop->dop_inodes));
>  	*fbp = NULLFSBLOCK;
>  	INIT_LIST_HEAD(&dop->dop_intake);
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index f6e93ef0bffe..cc1acd1fd4e8 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -36,20 +36,6 @@ struct xfs_defer_pending {
>  	unsigned int			dfp_count;	/* # extent items */
>  };
>  
> -/*
> - * Header for deferred operation list.
> - *
> - * dop_low is used by the allocator to activate the lowspace algorithm -
> - * when free space is running low the extent allocator may choose to
> - * allocate an extent from an AG without leaving sufficient space for
> - * a btree split when inserting the new extent.  In this case the allocator
> - * will enable the lowspace algorithm which is supposed to allow further
> - * allocations (such as btree splits and newroots) to allocate from
> - * sequential AGs.  In order to avoid locking AGs out of order the lowspace
> - * algorithm will start searching for free space from AG 0.  If the correct
> - * transaction reservations have been made then this algorithm will eventually
> - * find all the space it needs.
> - */
>  enum xfs_defer_ops_type {
>  	XFS_DEFER_OPS_TYPE_BMAP,
>  	XFS_DEFER_OPS_TYPE_REFCOUNT,
> @@ -62,7 +48,6 @@ enum xfs_defer_ops_type {
>  
>  struct xfs_defer_ops {
>  	bool			dop_committed;	/* did any trans commit? */
> -	bool			dop_low;	/* alloc in low mode */
>  	struct list_head	dop_intake;	/* unlogged pending work */
>  	struct list_head	dop_pending;	/* logged pending work */
>  
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 043ca3808ea2..6d61e61c0700 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -390,8 +390,6 @@ xfs_filestream_new_ag(
>  
>  	if (xfs_alloc_is_userdata(ap->datatype))
>  		flags |= XFS_PICK_USERDATA;
> -	if (ap->dfops->dop_low)
> -		flags |= XFS_PICK_LOWSPACE;
>  
>  	err = xfs_filestream_pick_ag(pip, startag, agp, flags, minlen);
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index cba10daf8391..ab4ce20b00dd 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2256,19 +2256,16 @@ DECLARE_EVENT_CLASS(xfs_defer_class,
>  		__field(dev_t, dev)
>  		__field(void *, dop)
>  		__field(bool, committed)
> -		__field(bool, low)
>  	),
>  	TP_fast_assign(
>  		__entry->dev = mp ? mp->m_super->s_dev : 0;
>  		__entry->dop = dop;
>  		__entry->committed = dop->dop_committed;
> -		__entry->low = dop->dop_low;
>  	),
> -	TP_printk("dev %d:%d ops %p committed %d low %d\n",
> +	TP_printk("dev %d:%d ops %p committed %d\n",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->dop,
> -		  __entry->committed,
> -		  __entry->low)
> +		  __entry->committed)
>  )
>  #define DEFINE_DEFER_EVENT(name) \
>  DEFINE_EVENT(xfs_defer_class, name, \
> @@ -2282,21 +2279,18 @@ DECLARE_EVENT_CLASS(xfs_defer_error_class,
>  		__field(dev_t, dev)
>  		__field(void *, dop)
>  		__field(bool, committed)
> -		__field(bool, low)
>  		__field(int, error)
>  	),
>  	TP_fast_assign(
>  		__entry->dev = mp ? mp->m_super->s_dev : 0;
>  		__entry->dop = dop;
>  		__entry->committed = dop->dop_committed;
> -		__entry->low = dop->dop_low;
>  		__entry->error = error;
>  	),
> -	TP_printk("dev %d:%d ops %p committed %d low %d err %d\n",
> +	TP_printk("dev %d:%d ops %p committed %d err %d\n",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->dop,
>  		  __entry->committed,
> -		  __entry->low,
>  		  __entry->error)
>  )
>  #define DEFINE_DEFER_ERROR_EVENT(name) \
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
