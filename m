Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54170 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751123AbdBCPWo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Feb 2017 10:22:44 -0500
Date: Fri, 3 Feb 2017 10:22:33 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: improve handling of busy extents in the
 low-level allocator
Message-ID: <20170203152233.GC45388@bfoster.bfoster>
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
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 9f06a21..fe98fbc 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
...
> @@ -1183,8 +1194,8 @@ xfs_alloc_ag_vextent_near(
>  			if ((error = xfs_alloc_get_rec(bno_cur_lt, &ltbno, &ltlen, &i)))
>  				goto error0;
>  			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> -			xfs_alloc_compute_aligned(args, ltbno, ltlen,
> -						  &ltbnoa, &ltlena);
> +			busy |= xfs_alloc_compute_aligned(args, ltbno, ltlen,
> +					&ltbnoa, &ltlena, &busy_gen);
>  			if (ltlena >= args->minlen && ltbnoa >= args->min_agbno)
>  				break;
>  			if ((error = xfs_btree_decrement(bno_cur_lt, 0, &i)))
> @@ -1199,8 +1210,8 @@ xfs_alloc_ag_vextent_near(
>  			if ((error = xfs_alloc_get_rec(bno_cur_gt, &gtbno, &gtlen, &i)))
>  				goto error0;
>  			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> -			xfs_alloc_compute_aligned(args, gtbno, gtlen,
> -						  &gtbnoa, &gtlena);
> +			busy |= xfs_alloc_compute_aligned(args, gtbno, gtlen,
> +					&gtbnoa, &gtlena, &busy_gen);

Not a big deal, but perhaps in the above two cases where we're
traversing the bnobt, just track the max busy gen and use that being set
non-zero to trigger (hopefully) fewer flushes rather than being subject
to whatever the last value was? Then we don't have to do the 'busy |=
..' thing either. That doesn't cover the overflow case, but that should
be rare and we still have the retry.

>  			if (gtlena >= args->minlen && gtbnoa <= args->max_agbno)
>  				break;
>  			if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
...
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 29c2f99..8251359 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -334,14 +334,18 @@ xfs_extent_busy_reuse(
>   * subset of the extent that is not busy.  If *rlen is smaller than
>   * args->minlen no suitable extent could be found, and the higher level
>   * code needs to force out the log and retry the allocation.
> + *
> + * Return the current discard generation for the AG if the file system
> + * has online discard enabled.  This value can be used to wait for
> + * the trimmed extent to become fully available if the AG is running out
> + * of space.
>   */
> -void
> +bool
>  xfs_extent_busy_trim(
>  	struct xfs_alloc_arg	*args,
> -	xfs_agblock_t		bno,
> -	xfs_extlen_t		len,
> -	xfs_agblock_t		*rbno,
> -	xfs_extlen_t		*rlen)
> +	xfs_agblock_t		*bno,
> +	xfs_extlen_t		*len,
> +	unsigned		*busy_gen)
>  {
>  	xfs_agblock_t		fbno;
>  	xfs_extlen_t		flen;
> @@ -351,8 +355,8 @@ xfs_extent_busy_trim(
>  
>  	spin_lock(&args->pag->pagb_lock);
>  restart:
> -	fbno = bno;
> -	flen = len;
> +	fbno = *bno;
> +	flen = *len;
>  	rbp = args->pag->pagb_tree.rb_node;
>  	while (rbp && flen >= args->minlen) {
>  		struct xfs_extent_busy *busyp =
> @@ -504,24 +508,25 @@ xfs_extent_busy_trim(
>  
>  		flen = fend - fbno;
>  	}
> +out:
>  	spin_unlock(&args->pag->pagb_lock);
>  
> -	if (fbno != bno || flen != len) {
> -		trace_xfs_extent_busy_trim(args->mp, args->agno, bno, len,
> +	if (fbno != *bno || flen != *len) {
> +		trace_xfs_extent_busy_trim(args->mp, args->agno, *bno, *len,
>  					  fbno, flen);
> +		*bno = fbno;
> +		*len = flen;
> +		*busy_gen = args->pag->pagb_gen;
> +		return true;

We've already dropped pagb_lock by the time we grab pagb_gen. What
prevents this from racing with a flush and pagb_gen bump and returning a
gen value that might not have any associated busy extents?

>  	}
> -	*rbno = fbno;
> -	*rlen = flen;
> -	return;
> +	return false;
>  fail:
>  	/*
>  	 * Return a zero extent length as failure indications.  All callers
>  	 * re-check if the trimmed extent satisfies the minlen requirement.
>  	 */
> -	spin_unlock(&args->pag->pagb_lock);
> -	trace_xfs_extent_busy_trim(args->mp, args->agno, bno, len, fbno, 0);
> -	*rbno = fbno;
> -	*rlen = 0;
> +	flen = 0;
> +	goto out;
>  }
>  
>  STATIC void
...
> @@ -554,29 +574,53 @@ xfs_extent_busy_clear(
...
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

This seems racy. Shouldn't this do something like:

	do {
		prepare_to_wait();
		if (busy_gen != pagb_gen)
			break;
		schedule();
		finish_wait();
	} while (1);
	finish_wait();

... to make sure we don't lose a wakeup between setting the task state
and actually scheduling out?

>  }
>  
>  /*
...
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

Can we add some comments here similar to the other fields? Also, how
about slightly more informative names... pagb_discard_[gen|wait], or
pagb_busy_*?

Brian

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
