Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33150 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbeHMK30 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Aug 2018 06:29:26 -0400
Received: by mail-wm0-f68.google.com with SMTP id r24-v6so6878352wmh.0
        for <linux-xfs@vger.kernel.org>; Mon, 13 Aug 2018 00:48:20 -0700 (PDT)
Date: Mon, 13 Aug 2018 09:48:17 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/6] xfs: xrep_findroot_block should reject root blocks
 with siblings
Message-ID: <20180813074817.7jlf7653oa4ttwgk@odin.usersys.redhat.com>
References: <153400169747.27471.4044680761841034489.stgit@magnolia>
 <153400170977.27471.4053607329690572828.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153400170977.27471.4053607329690572828.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Aug 11, 2018 at 08:35:09AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xrep_findroot_block, if we find a candidate root block with sibling
> pointers or sibling blocks on the same tree level, we should not return
> that block as a tree root because root blocks cannot have siblings.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/repair.c |   47 +++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 41 insertions(+), 6 deletions(-)

Looks fine

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 17cf48564390..42d8c798ce7d 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -690,6 +690,7 @@ xrep_findroot_block(
>  	struct xfs_buf			*bp;
>  	struct xfs_btree_block		*btblock;
>  	xfs_daddr_t			daddr;
> +	int				block_level;
>  	int				error;
>  
>  	daddr = XFS_AGB_TO_DADDR(mp, ri->sc->sa.agno, agbno);
> @@ -727,17 +728,51 @@ xrep_findroot_block(
>  		goto out;
>  	bp->b_ops = fab->buf_ops;
>  
> -	/* Ignore this block if it's lower in the tree than we've seen. */
> -	if (fab->root != NULLAGBLOCK &&
> -	    xfs_btree_get_level(btblock) < fab->height)
> -		goto out;
> -
>  	/* Make sure we pass the verifiers. */
>  	bp->b_ops->verify_read(bp);
>  	if (bp->b_error)
>  		goto out;
> +
> +	/* If we've recorded a root candidate... */
> +	block_level = xfs_btree_get_level(btblock);
> +	if (fab->root != NULLAGBLOCK) {
> +		/*
> +		 * ...and this no-sibling root block candidate has the same
> +		 * level as the recorded candidate, there's no way we're going
> +		 * to accept any candidates at this tree level.  Stash a root
> +		 * block of zero because the height is still valid, but no
> +		 * AG btree can root at agblock 0.  Callers should verify the
> +		 * root agbno with xfs_verify_agbno...
> +		 */
> +		if (block_level + 1 == fab->height) {
> +			fab->root = 0;
> +			goto out;
> +		}
> +
> +		/*
> +		 * ...and this no-sibling root block is lower in the tree than
> +		 * the recorded root block candidate, just ignore it.  There's
> +		 * still a strong chance that something is wrong with the btree
> +		 * itself, but that's not what we're fixing right now.
> +		 */
> +		if (block_level < fab->height)
> +			goto out;
> +	}
> +
> +	/*
> +	 * Root blocks can't have siblings.  This level can't be the root, so
> +	 * record the tree height (but not the ag block pointer) to force us to
> +	 * look for a higher level in the tree.
> +	 */
> +	if (btblock->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) ||
> +	    btblock->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK)) {
> +		fab->root = 0;
> +		fab->height = block_level + 1;
> +		goto out;
> +	}
> +
>  	fab->root = agbno;
> -	fab->height = xfs_btree_get_level(btblock) + 1;
> +	fab->height = block_level + 1;
>  	*found_it = true;
>  
>  	trace_xrep_findroot_block(mp, ri->sc->sa.agno, agbno,
> 

-- 
Carlos
