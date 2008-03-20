Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Mar 2008 00:55:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2K7tQq1007957
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 00:55:28 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DD2DFDE4BA
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 00:55:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id V3y9Cq23AD4zG11x for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 00:55:59 -0700 (PDT)
Date: Thu, 20 Mar 2008 03:55:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: xfs_bmap_check_leaf_extents() can reference unmapped
	memory
Message-ID: <20080320075527.GA24999@infradead.org>
References: <47E2000B.9030208@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E2000B.9030208@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 20, 2008 at 05:11:23PM +1100, Lachlan McIlroy wrote:
> +	xfs_bmbt_rec_t		last;   /* last extent in previous block */
>  	xfs_bmbt_rec_t		*nextp;	/* pointer to next extent */
>  	int			bp_release = 0;
>
> @@ -6264,7 +6264,6 @@ xfs_bmap_check_leaf_extents(
>  	/*
>  	 * Loop over all leaf nodes checking that all extents are in the right order.
>  	 */
>  	for (;;) {
>  		xfs_fsblock_t	nextbno;
>  		xfs_extnum_t	num_recs;
> @@ -6285,18 +6284,18 @@ xfs_bmap_check_leaf_extents(
>  		 */
>
>  		ep = XFS_BTREE_REC_ADDR(xfs_bmbt, block, 1);
> +		if (i) {
> +			xfs_btree_check_rec(XFS_BTNUM_BMAP, (void *)&last,
> +				(void *)ep);

I haven't actually compiled this yet, but I'd expect this to give an
unitialized variable warning with gcc because it can't figure out this
can't happen in the first loop iteration.  You might need and
last = { 0, } somewhere in the beginning of the function.

Also I think the void * casts above are useless.

>  			xfs_btree_check_rec(XFS_BTNUM_BMAP, (void *)ep,
>  				(void *)(nextp));

and at that point you might fix these up aswell, with the added benefit
that now the whole call fits on a single line.
