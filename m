Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750891AbdBCQWo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Feb 2017 11:22:44 -0500
Date: Fri, 3 Feb 2017 11:22:43 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: improve handling of busy extents in the
 low-level allocator
Message-ID: <20170203162243.GF45388@bfoster.bfoster>
References: <1485715421-17182-1-git-send-email-hch@lst.de>
 <1485715421-17182-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485715421-17182-3-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Jan 29, 2017 at 07:43:39PM +0100, Christoph Hellwig wrote:
> Currently we force the log and simply try again if we hit a busy extent,
> but especially with online discard enabled it might take a while after
> the log force for the busy extents to disappear, and we might have
> already completed our second pass.
> 
> So instead we add a new waitqueue and a generation counter to the pag
> structure so that we can do wakeups once we've removed busy extents,
> and we replace the single retry with an unconditional one - after
> all we hold the AGF buffer lock, so no other allocations or frees
> can be racing with us in this AG.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 93 +++++++++++++++++++++++---------------------
>  fs/xfs/xfs_extent_busy.c  | 98 ++++++++++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_extent_busy.h  |  8 +++-
>  fs/xfs/xfs_mount.c        |  1 +
>  fs/xfs/xfs_mount.h        |  2 +
>  5 files changed, 129 insertions(+), 73 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 29c2f99..8251359 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
...
> @@ -554,29 +574,53 @@ xfs_extent_busy_clear(
>  	struct xfs_extent_busy	*busyp, *n;
>  	struct xfs_perag	*pag = NULL;
>  	xfs_agnumber_t		agno = NULLAGNUMBER;
> +	bool			wakeup = false;
>  
>  	list_for_each_entry_safe(busyp, n, list, list) {
>  		if (busyp->agno != agno) {
> -			if (pag) {
> -				spin_unlock(&pag->pagb_lock);
> -				xfs_perag_put(pag);
> -			}
> -			pag = xfs_perag_get(mp, busyp->agno);
> -			spin_lock(&pag->pagb_lock);
> +			if (pag)
> +				xfs_extent_busy_put_pag(pag, wakeup);
>  			agno = busyp->agno;
> +			pag = xfs_perag_get(mp, agno);
> +			spin_lock(&pag->pagb_lock);
> +			wakeup = false;
>  		}
>  
>  		if (do_discard && busyp->length &&
> -		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD))
> +		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
>  			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
> -		else
> +		} else {
>  			xfs_extent_busy_clear_one(mp, pag, busyp);
> +			wakeup = true;
> +		}

I didn't catch this until looking through everything after the next
patch, but I think there's a problem with the wakeup here as well. If we
have a busy extent with XFS_EXTENT_BUSY_SKIP_DISCARD set, we immediately
issue a wake from the first xfs_extent_busy_clear() in the cil committed
handler, regardless of whether !SKIP_DISCARD extents exist as well
under the current gen value. I think that means we'd get a premature
wake any time a busy_list has at least one of each type..?

Brian

>  	}
>  
> -	if (pag) {
> -		spin_unlock(&pag->pagb_lock);
> -		xfs_perag_put(pag);
> +	if (pag)
> +		xfs_extent_busy_put_pag(pag, wakeup);
> +}
> +
> +/*
> + * Flush out all busy extents for this AG.
> + */
> +void
> +xfs_extent_busy_flush(
> +	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag,
> +	unsigned		busy_gen)
> +{
> +	DEFINE_WAIT		(wait);
> +	int			log_flushed = 0, error;
> +
> +	trace_xfs_log_force(mp, 0, _THIS_IP_);
> +	error = _xfs_log_force(mp, XFS_LOG_SYNC, &log_flushed);
> +	if (error)
> +		return;
> +
> +	while (busy_gen == READ_ONCE(pag->pagb_gen)) {
> +		prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
> +		schedule();
>  	}
> +	finish_wait(&pag->pagb_wait, &wait);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> index bfff284..bcb99463 100644
> --- a/fs/xfs/xfs_extent_busy.h
> +++ b/fs/xfs/xfs_extent_busy.h
> @@ -58,9 +58,13 @@ void
>  xfs_extent_busy_reuse(struct xfs_mount *mp, xfs_agnumber_t agno,
>  	xfs_agblock_t fbno, xfs_extlen_t flen, bool userdata);
>  
> +bool
> +xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,
> +		xfs_extlen_t *len, unsigned *busy_gen);
> +
>  void
> -xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t bno,
> -	xfs_extlen_t len, xfs_agblock_t *rbno, xfs_extlen_t *rlen);
> +xfs_extent_busy_flush(struct xfs_mount *mp, struct xfs_perag *pag,
> +	unsigned discards);
>  
>  int
>  xfs_extent_busy_ag_cmp(void *priv, struct list_head *a, struct list_head *b);
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 9b9540d..4e9feb1 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -215,6 +215,7 @@ xfs_initialize_perag(
>  		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
>  		if (xfs_buf_hash_init(pag))
>  			goto out_unwind;
> +		init_waitqueue_head(&pag->pagb_wait);
>  
>  		if (radix_tree_preload(GFP_NOFS))
>  			goto out_unwind;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 7f351f7..7363499 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -384,6 +384,8 @@ typedef struct xfs_perag {
>  	xfs_agino_t	pagl_rightrec;
>  	spinlock_t	pagb_lock;	/* lock for pagb_tree */
>  	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
> +	unsigned int	pagb_gen;
> +	wait_queue_head_t pagb_wait;
>  
>  	atomic_t        pagf_fstrms;    /* # of filestreams active in this AG */
>  
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
