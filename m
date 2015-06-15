Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7DD767F3F
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 09:57:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6D3E08F8040
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 07:57:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OzI5PPtjcD6Q6PQt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Jun 2015 07:57:50 -0700 (PDT)
Date: Mon, 15 Jun 2015 10:57:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/20] xfs: xfs_alloc_fix_freelist() can use incore perag
	structures
Message-ID: <20150615145746.GA36091@bfoster.bfoster>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
	<1433311497-10245-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1433311497-10245-2-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 03, 2015 at 04:04:38PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> At the moment, xfs_alloc_fix_freelist() uses a mix of per-ag based
> access and agf buffer  based access to freelist and space usage
> information. However, once the AGF buffer is locked inside this
> function, it is guaranteed that both the in-memory and on-disk
> values are identical. xfs_alloc_fix_freelist() doesn't modify the
> values in the structures directly, so it is a read-only user of the
> infomration, and hence can use the per-ag structure exclusively for
> determining what it should do.
> 
> This opens up an avenue for cleaning up a lot of duplicated logic
> whose only difference is the structure it gets the data from, and in
> doing so removes a lot of needless byte swapping overhead when
> fixing up the free list.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c | 69 +++++++++++++++++++++--------------------------
>  fs/xfs/libxfs/xfs_alloc.h |  8 ++----
>  fs/xfs/libxfs/xfs_bmap.c  |  3 ++-
>  fs/xfs/xfs_filestream.c   |  3 ++-
>  4 files changed, 37 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index bc78ac0..08b45f8 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1857,11 +1857,11 @@ xfs_alloc_compute_maxlevels(
>  xfs_extlen_t
>  xfs_alloc_longest_free_extent(
>  	struct xfs_mount	*mp,
> -	struct xfs_perag	*pag)
> +	struct xfs_perag	*pag,
> +	xfs_extlen_t		need)
>  {
> -	xfs_extlen_t		need, delta = 0;
> +	xfs_extlen_t		delta = 0;
>  
> -	need = XFS_MIN_FREELIST_PAG(pag, mp);
>  	if (need > pag->pagf_flcount)
>  		delta = need - pag->pagf_flcount;
>  
> @@ -1880,10 +1880,8 @@ xfs_alloc_fix_freelist(
>  	int		flags)	/* XFS_ALLOC_FLAG_... */
>  {
>  	xfs_buf_t	*agbp;	/* agf buffer pointer */
> -	xfs_agf_t	*agf;	/* a.g. freespace structure pointer */
>  	xfs_buf_t	*agflbp;/* agfl buffer pointer */
>  	xfs_agblock_t	bno;	/* freelist block */
> -	xfs_extlen_t	delta;	/* new blocks needed in freelist */
>  	int		error;	/* error result code */
>  	xfs_extlen_t	longest;/* longest extent in allocation group */
>  	xfs_mount_t	*mp;	/* file system mount point structure */
> @@ -1927,7 +1925,7 @@ xfs_alloc_fix_freelist(
>  		 * total blocks, reject it.
>  		 */
>  		need = XFS_MIN_FREELIST_PAG(pag, mp);
> -		longest = xfs_alloc_longest_free_extent(mp, pag);
> +		longest = xfs_alloc_longest_free_extent(mp, pag, need);
>  		if ((args->minlen + args->alignment + args->minalignslop - 1) >
>  				longest ||
>  		    ((int)(pag->pagf_freeblks + pag->pagf_flcount -
> @@ -1954,25 +1952,16 @@ xfs_alloc_fix_freelist(
>  			return 0;
>  		}
>  	}
> -	/*
> -	 * Figure out how many blocks we should have in the freelist.
> -	 */
> -	agf = XFS_BUF_TO_AGF(agbp);
> -	need = XFS_MIN_FREELIST(agf, mp);
> -	/*
> -	 * If there isn't enough total or single-extent, reject it.
> -	 */
> +
> +
> +	/* If there isn't enough total space or single-extent, reject it. */
> +	need = XFS_MIN_FREELIST_PAG(pag, mp);
>  	if (!(flags & XFS_ALLOC_FLAG_FREEING)) {
> -		delta = need > be32_to_cpu(agf->agf_flcount) ?
> -			(need - be32_to_cpu(agf->agf_flcount)) : 0;
> -		longest = be32_to_cpu(agf->agf_longest);
> -		longest = (longest > delta) ? (longest - delta) :
> -			(be32_to_cpu(agf->agf_flcount) > 0 || longest > 0);
> +		longest = xfs_alloc_longest_free_extent(mp, pag, need);
>  		if ((args->minlen + args->alignment + args->minalignslop - 1) >
>  				longest ||
> -		    ((int)(be32_to_cpu(agf->agf_freeblks) +
> -		     be32_to_cpu(agf->agf_flcount) - need - args->total) <
> -				(int)args->minleft)) {
> +		    ((int)(pag->pagf_freeblks + pag->pagf_flcount -
> +			   need - args->total) < (int)args->minleft)) {
>  			xfs_trans_brelse(tp, agbp);
>  			args->agbp = NULL;
>  			return 0;
> @@ -1980,21 +1969,25 @@ xfs_alloc_fix_freelist(
>  	}
>  	/*
>  	 * Make the freelist shorter if it's too long.
> +	 *
> +	 * XXX (dgc): When we have lots of free space, does this buy us
> +	 * anything other than extra overhead when we need to put more blocks
> +	 * back on the free list? Maybe we should only do this when space is
> +	 * getting low or the AGFL is more than half full?
>  	 */
> -	while (be32_to_cpu(agf->agf_flcount) > need) {
> -		xfs_buf_t	*bp;
> +	while (pag->pagf_flcount > need) {
> +		struct xfs_buf	*bp;
>  
>  		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
>  		if (error)
>  			return error;
> -		if ((error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1, 1)))
> +		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1, 1);
> +		if (error)
>  			return error;
>  		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
>  		xfs_trans_binval(tp, bp);
>  	}
> -	/*
> -	 * Initialize the args structure.
> -	 */
> +
>  	memset(&targs, 0, sizeof(targs));
>  	targs.tp = tp;
>  	targs.mp = mp;
> @@ -2003,18 +1996,18 @@ xfs_alloc_fix_freelist(
>  	targs.alignment = targs.minlen = targs.prod = targs.isfl = 1;
>  	targs.type = XFS_ALLOCTYPE_THIS_AG;
>  	targs.pag = pag;
> -	if ((error = xfs_alloc_read_agfl(mp, tp, targs.agno, &agflbp)))
> +	error = xfs_alloc_read_agfl(mp, tp, targs.agno, &agflbp);
> +	if (error)
>  		return error;
> -	/*
> -	 * Make the freelist longer if it's too short.
> -	 */
> -	while (be32_to_cpu(agf->agf_flcount) < need) {
> +
> +	/* Make the freelist longer if it's too short. */
> +	while (pag->pagf_flcount < need) {
>  		targs.agbno = 0;
> -		targs.maxlen = need - be32_to_cpu(agf->agf_flcount);
> -		/*
> -		 * Allocate as many blocks as possible at once.
> -		 */
> -		if ((error = xfs_alloc_ag_vextent(&targs))) {
> +		targs.maxlen = need - pag->pagf_flcount;
> +
> +		/* Allocate as many blocks as possible at once. */
> +		error = xfs_alloc_ag_vextent(&targs);
> +		if (error) {
>  			xfs_trans_brelse(tp, agflbp);
>  			return error;
>  		}
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 29f27b2..a4d3b9a 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -130,12 +130,8 @@ typedef struct xfs_alloc_arg {
>  #define XFS_ALLOC_USERDATA		1	/* allocation is for user data*/
>  #define XFS_ALLOC_INITIAL_USER_DATA	2	/* special case start of file */
>  
> -/*
> - * Find the length of the longest extent in an AG.
> - */
> -xfs_extlen_t
> -xfs_alloc_longest_free_extent(struct xfs_mount *mp,
> -		struct xfs_perag *pag);
> +xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_mount *mp,
> +		struct xfs_perag *pag, xfs_extlen_t need);
>  
>  /*
>   * Compute and fill in value of m_ag_maxlevels.
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 5cb3e85..7382cce 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3521,7 +3521,8 @@ xfs_bmap_longest_free_extent(
>  		}
>  	}
>  
> -	longest = xfs_alloc_longest_free_extent(mp, pag);
> +	longest = xfs_alloc_longest_free_extent(mp, pag,
> +						XFS_MIN_FREELIST_PAG(pag, mp));
>  	if (*blen < longest)
>  		*blen = longest;
>  
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index da82f1c..9ac5eaa 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -196,7 +196,8 @@ xfs_filestream_pick_ag(
>  			goto next_ag;
>  		}
>  
> -		longest = xfs_alloc_longest_free_extent(mp, pag);
> +		longest = xfs_alloc_longest_free_extent(mp, pag,
> +						XFS_MIN_FREELIST_PAG(pag, mp));
>  		if (((minlen && longest >= minlen) ||
>  		     (!minlen && pag->pagf_freeblks >= minfree)) &&
>  		    (!pag->pagf_metadata || !(flags & XFS_PICK_USERDATA) ||
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
