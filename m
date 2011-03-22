Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2MNS7lx055165 for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 18:28:12 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8617D1401391
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 16:30:56 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kUlFC0DFXTiJ076d for <xfs@oss.sgi.com>;
	Tue, 22 Mar 2011 16:30:56 -0700 (PDT)
Date: Wed, 23 Mar 2011 10:30:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] xfs: optimize AGFL refills
Message-ID: <20110322233054.GD15270@dastard>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.280301318@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110322200137.280301318@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Mar 22, 2011 at 03:55:51PM -0400, Christoph Hellwig wrote:
> Avoid forcing out busy extent when moving blocks from/to the AGFL.  We
> archive this my moving the busy search out of xfs_alloc_get_freelist into
> the callers that need it, and by moving the busy list insert from
> xfs_free_ag_extent extent which is used both by AGFL refills and real
> allocation to xfs_free_extent, which is only used by the latter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_alloc.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_alloc.c	2011-03-19 16:49:23.774797370 +0100
> +++ xfs/fs/xfs/xfs_alloc.c	2011-03-19 16:49:38.882797272 +0100
> @@ -1326,6 +1326,8 @@ xfs_alloc_ag_vextent_small(
>  		if (error)
>  			goto error0;
>  		if (fbno != NULLAGBLOCK) {
> +			if (xfs_alloc_busy_search(args->mp, args->agno, fbno, 1))
> +				xfs_trans_set_sync(args->tp);
>  			if (args->userdata) {
>  				xfs_buf_t	*bp;
>  
> @@ -1617,18 +1619,6 @@ xfs_free_ag_extent(
>  
>  	trace_xfs_free_extent(mp, agno, bno, len, isfl, haveleft, haveright);
>  
> -	/*
> -	 * Since blocks move to the free list without the coordination
> -	 * used in xfs_bmap_finish, we can't allow block to be available
> -	 * for reallocation and non-transaction writing (user data)
> -	 * until we know that the transaction that moved it to the free
> -	 * list is permanently on disk.  We track the blocks by declaring
> -	 * these blocks as "busy"; the busy list is maintained on a per-ag
> -	 * basis and each transaction records which entries should be removed
> -	 * when the iclog commits to disk.  If a busy block is allocated,
> -	 * the iclog is pushed up to the LSN that freed the block.
> -	 */
> -	xfs_alloc_busy_insert(tp, agno, bno, len);
>  	return 0;
>  
>   error0:
> @@ -1923,21 +1913,6 @@ xfs_alloc_get_freelist(
>  	xfs_alloc_log_agf(tp, agbp, logflags);
>  	*bnop = bno;
>  
> -	/*
> -	 * As blocks are freed, they are added to the per-ag busy list and
> -	 * remain there until the freeing transaction is committed to disk.
> -	 * Now that we have allocated blocks, this list must be searched to see
> -	 * if a block is being reused.  If one is, then the freeing transaction
> -	 * must be pushed to disk before this transaction.
> -	 *
> -	 * We do this by setting the current transaction to a sync transaction
> -	 * which guarantees that the freeing transaction is on disk before this
> -	 * transaction. This is done instead of a synchronous log force here so
> -	 * that we don't sit and wait with the AGF locked in the transaction
> -	 * during the log force.
> -	 */
> -	if (xfs_alloc_busy_search(mp, be32_to_cpu(agf->agf_seqno), bno, 1))
> -		xfs_trans_set_sync(tp);
>  	return 0;
>  }
>  
> @@ -2407,6 +2382,8 @@ xfs_free_extent(
>  		be32_to_cpu(XFS_BUF_TO_AGF(args.agbp)->agf_length));
>  #endif
>  	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
> +	if (error)
> +		xfs_alloc_busy_insert(tp, args.agno, args.agbno, len);

Shouldn't that be "if (!error)"?  i.e. if we freed the extent
successfully we need to insert it in the busy list. This current
code has the effect of never inserting freed data extents in the
busy list....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
