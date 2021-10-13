Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779BCC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 04:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DB48608FB
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 04:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhJME7n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 00:59:43 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:39280 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229628AbhJME7n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Oct 2021 00:59:43 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 3847F105F4E;
        Wed, 13 Oct 2021 15:57:38 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1maWKg-005eA7-4G; Wed, 13 Oct 2021 15:57:38 +1100
Date:   Wed, 13 Oct 2021 15:57:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 04/15] xfs: dynamically allocate btree scrub context
 structure
Message-ID: <20211013045738.GW2361455@dread.disaster.area>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408157576.4151249.1044656167414078424.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163408157576.4151249.1044656167414078424.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61666743
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=W8TT15eiPmaqKmKXq5UA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 04:32:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Reorganize struct xchk_btree so that we can dynamically size the context
> structure to fit the type of btree cursor that we have.  This will
> enable us to use memory more efficiently once we start adding very tall
> btree types.  Right-size the lastkey array so that we stop wasting the
> first array element.

"right size"?

I'm assuming this is the "nlevels - 1" bit?

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/btree.c |   23 ++++++++++++-----------
>  fs/xfs/scrub/btree.h |   11 ++++++++++-
>  2 files changed, 22 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index d5e1ca521fc4..6d4eba85ef77 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -189,9 +189,9 @@ xchk_btree_key(
>  
>  	/* If this isn't the first key, are they in order? */
>  	if (cur->bc_ptrs[level] > 1 &&
> -	    !cur->bc_ops->keys_inorder(cur, &bs->lastkey[level], key))
> +	    !cur->bc_ops->keys_inorder(cur, &bs->lastkey[level - 1], key))
>  		xchk_btree_set_corrupt(bs->sc, cur, level);
> -	memcpy(&bs->lastkey[level], key, cur->bc_ops->key_len);
> +	memcpy(&bs->lastkey[level - 1], key, cur->bc_ops->key_len);
>  
>  	if (level + 1 >= cur->bc_nlevels)
>  		return;
> @@ -631,17 +631,24 @@ xchk_btree(
>  	union xfs_btree_ptr		*pp;
>  	union xfs_btree_rec		*recp;
>  	struct xfs_btree_block		*block;
> -	int				level;
>  	struct xfs_buf			*bp;
>  	struct check_owner		*co;
>  	struct check_owner		*n;
> +	size_t				cur_sz;
> +	int				level;
>  	int				error = 0;
>  
>  	/*
>  	 * Allocate the btree scrub context from the heap, because this
> -	 * structure can get rather large.
> +	 * structure can get rather large.  Don't let a caller feed us a
> +	 * totally absurd size.
>  	 */
> -	bs = kmem_zalloc(sizeof(struct xchk_btree), KM_NOFS | KM_MAYFAIL);
> +	cur_sz = xchk_btree_sizeof(cur->bc_nlevels);
> +	if (cur_sz > PAGE_SIZE) {
> +		xchk_btree_set_corrupt(sc, cur, 0);
> +		return 0;
> +	}
> +	bs = kmem_zalloc(cur_sz, KM_NOFS | KM_MAYFAIL);
>  	if (!bs)
>  		return -ENOMEM;
>  	bs->cur = cur;
> @@ -653,12 +660,6 @@ xchk_btree(
>  	/* Initialize scrub state */
>  	INIT_LIST_HEAD(&bs->to_check);
>  
> -	/* Don't try to check a tree with a height we can't handle. */
> -	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS) {
> -		xchk_btree_set_corrupt(sc, cur, 0);
> -		goto out;
> -	}
> -
>  	/*
>  	 * Load the root of the btree.  The helper function absorbs
>  	 * error codes for us.
> diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
> index 7671108f9f85..62c3091ef20f 100644
> --- a/fs/xfs/scrub/btree.h
> +++ b/fs/xfs/scrub/btree.h
> @@ -39,9 +39,18 @@ struct xchk_btree {
>  
>  	/* internal scrub state */
>  	union xfs_btree_rec		lastrec;
> -	union xfs_btree_key		lastkey[XFS_BTREE_MAXLEVELS];
>  	struct list_head		to_check;
> +
> +	/* this element must come last! */
> +	union xfs_btree_key		lastkey[];
>  };
> +
> +static inline size_t
> +xchk_btree_sizeof(unsigned int nlevels)
> +{
> +	return struct_size((struct xchk_btree *)NULL, lastkey, nlevels - 1);
> +}

I'd like a comment here indicating that the max number of keys is
"nlevels - 1" because the last level of the tree is records and
that's held in a separate lastrec field...

That way there's a reminder of why there's a "- 1" here without
having work it out from first principles every time we look at this
code...

Otherwise it seems reasonable.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
