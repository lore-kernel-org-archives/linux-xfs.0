Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44700 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751375AbdHGPUB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Aug 2017 11:20:01 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2DF42DB924
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2017 15:20:01 +0000 (UTC)
Date: Mon, 7 Aug 2017 11:19:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] Stop searching for free slots in an inode chunk when
 there are none
Message-ID: <20170807151954.GB43920@bfoster.bfoster>
References: <20170807101710.18734-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170807101710.18734-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 07, 2017 at 12:17:10PM +0200, Carlos Maiolino wrote:
> In a filesystem without finobt, the Space manager selects an AG to alloc a new
> inode, where xfs_dialloc_ag_inobt() will search the AG for the free slot chunk.
> 
> When the new inode is in the samge AG as its parent, the btree will be searched
> starting on the parent's record, and then retried from the top if no slot is
> available beyond the parent's record.
> 
> To exit this loop though, xfs_dialloc_ag_inobt(), relies on the fact that the
> btree must have a free slot available, once its callers relied on the
> agi->freecount when deciding how/where to allocate this new inode.
> 
> In the case when the agi->freecount is corrupted, showing available inodes in an
> AG, when in fact there is none, this becomes an infinite loop.
> 
> Add a way to stop the loop when a free slot is not found in the btree, making
> the function to fall into the whole AG scan which will then, be able to detect
> the corruption and shut the filesystem down.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> V2: Use searchdistance variable to stop the infinite loop instead of adding a
>     new mechanism.
> 
>  fs/xfs/libxfs/xfs_ialloc.c | 34 ++++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index d41ade5d293e..8e535290390d 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1123,6 +1123,7 @@ xfs_dialloc_ag_inobt(
>  	int			error;
>  	int			offset;
>  	int			i, j;
> +	int			searchdistance = 10;
>  
>  	pag = xfs_perag_get(mp, agno);
>  
> @@ -1149,7 +1150,6 @@ xfs_dialloc_ag_inobt(
>  	if (pagno == agno) {
>  		int		doneleft;	/* done, to the left */
>  		int		doneright;	/* done, to the right */
> -		int		searchdistance = 10;
>  
>  		error = xfs_inobt_lookup(cur, pagino, XFS_LOOKUP_LE, &i);
>  		if (error)
> @@ -1210,10 +1210,10 @@ xfs_dialloc_ag_inobt(
>  		/*
>  		 * Loop until we find an inode chunk with a free inode.
>  		 */
> -		while (!doneleft || !doneright) {
> +		while (--searchdistance > 0 && (!doneleft || !doneright)) {
>  			int	useleft;  /* using left inode chunk this time */
>  
> -			if (!--searchdistance) {
> +			if (searchdistance <= 0) {

If the loop terminates when searchdistance <= 0, when would we ever hit
this?

>  				/*
>  				 * Not in range - save last search
>  				 * location and allocate a new inode
> @@ -1268,19 +1268,21 @@ xfs_dialloc_ag_inobt(
>  				goto error1;
>  		}
>  
> -		/*
> -		 * We've reached the end of the btree. because
> -		 * we are only searching a small chunk of the
> -		 * btree each search, there is obviously free
> -		 * inodes closer to the parent inode than we
> -		 * are now. restart the search again.
> -		 */
> -		pag->pagl_pagino = NULLAGINO;
> -		pag->pagl_leftrec = NULLAGINO;
> -		pag->pagl_rightrec = NULLAGINO;
> -		xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
> -		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> -		goto restart_pagno;
> +		if (searchdistance > 0) {
> +			/*
> +			 * We've reached the end of the btree. because
> +			 * we are only searching a small chunk of the
> +			 * btree each search, there is obviously free
> +			 * inodes closer to the parent inode than we
> +			 * are now. restart the search again.
> +			 */
> +			pag->pagl_pagino = NULLAGINO;
> +			pag->pagl_leftrec = NULLAGINO;
> +			pag->pagl_rightrec = NULLAGINO;
> +			xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
> +			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> +			goto restart_pagno;
> +		}

Hmm.. so if we have a tree with just a handful of records (say 3, for
example), we'd end up running through the tree searchdistance times
before correctly identifying the state and moving on (to the full
search). We avoid the livelock, but fwiw, that still seems like
buggy/brittle code to me. That's just my .02. If we want to use this
approach, we should at least add a comment somewhere that explains
how/why we handle this situation as such (i.e., that we require/rely on
searchdistance to deplete in the worst case of a corruption).

Also note that this has potential for performance side effects in the
common (non-corruption) case. That may or may not ultimately be a
problem, but the fallback to the optimized search is the brute force AG
scan. Given that, I think that case at least has to be considered and
noted in the commit log.

It looks to me that it shouldn't be a major problem because it only
affects the situation where the cached search "wraps" to the outside of
the tree, and that probably doesn't happen often with a search distance
of 10 records and a large tree. I am a bit curious where the
searchdistance of 10 comes from though (we fit many more records in a
single inobt leaf block)..?

Brian

>  	}
>  
>  	/*
> -- 
> 2.13.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
