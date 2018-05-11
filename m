Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751010AbeEKPT0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 May 2018 11:19:26 -0400
Date: Fri, 11 May 2018 11:19:24 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/8] xfs: don't continue scrub if already corrupt
Message-ID: <20180511151924.GC105683@bfoster.bfoster>
References: <152597988038.25215.9276761144353662866.stgit@magnolia>
 <152597989315.25215.2420081776495470973.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152597989315.25215.2420081776495470973.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 10, 2018 at 12:18:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we've already decided that something is corrupt, we might as well
> abort all the loops and exit as quickly as possible.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/attr.c   |    3 ++-
>  fs/xfs/scrub/bmap.c   |    3 ++-
>  fs/xfs/scrub/dir.c    |   35 +++++++++++++++++++++++++++--------
>  fs/xfs/scrub/parent.c |    3 +++
>  4 files changed, 34 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 127575f0abfb..84b6d6b66578 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -126,8 +126,9 @@ xfs_scrub_xattr_listent(
>  	if (args.valuelen != valuelen)
>  		xfs_scrub_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK,
>  					     args.blkno);
> -
>  fail_xref:
> +	if (sx->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> +		context->seen_enough = 1;
>  	return;
>  }
>  
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index e5a4611abf86..42a115e83739 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -683,7 +683,8 @@ xfs_scrub_bmap(
>  	info.lastoff = 0;
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	for_each_xfs_iext(ifp, &icur, &irec) {
> -		if (xfs_scrub_should_terminate(sc, &error))
> +		if (xfs_scrub_should_terminate(sc, &error) ||
> +		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
>  			break;
>  		if (isnullstartblock(irec.br_startblock))
>  			continue;
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 38f29806eb54..1a4309b3e786 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -172,7 +172,7 @@ xfs_scrub_dir_actor(
>  	error = xfs_dir_lookup(sdc->sc->tp, ip, &xname, &lookup_ino, NULL);
>  	if (!xfs_scrub_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
>  			&error))
> -		goto fail_xref;
> +		goto out;
>  	if (lookup_ino != ino) {
>  		xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
>  		goto out;
> @@ -183,8 +183,13 @@ xfs_scrub_dir_actor(
>  	if (error)
>  		goto out;
>  out:
> -	return error;
> -fail_xref:
> +	/*
> +	 * A negative error code returned here is supposed to cause the
> +	 * dir_emit caller (xfs_readdir) to abort the directory iteration
> +	 * and return zero to xfs_scrub_directory.
> +	 */
> +	if (error == 0 && sdc->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> +		return -EFSCORRUPTED;
>  	return error;
>  }
>  
> @@ -240,6 +245,9 @@ xfs_scrub_dir_rec(
>  	}
>  	xfs_scrub_buffer_recheck(ds->sc, bp);
>  
> +	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> +		goto out_relse;
> +
>  	dent = (struct xfs_dir2_data_entry *)(((char *)bp->b_addr) + off);
>  
>  	/* Make sure we got a real directory entry. */
> @@ -357,6 +365,9 @@ xfs_scrub_directory_data_bestfree(
>  
>  	/* XXX: Check xfs_dir3_data_hdr.pad is zero once we start setting it. */
>  
> +	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> +		goto out_buf;
> +
>  	/* Do the bestfrees correspond to actual free space? */
>  	bf = d_ops->data_bestfree_p(bp->b_addr);
>  	smallest_bestfree = UINT_MAX;
> @@ -413,14 +424,18 @@ xfs_scrub_directory_data_bestfree(
>  
>  		/* Spot check this free entry */
>  		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
> -		if (tag != ((char *)dup - (char *)bp->b_addr))
> +		if (tag != ((char *)dup - (char *)bp->b_addr)) {
>  			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> +			goto out_buf;
> +		}
>  
>  		/*
>  		 * Either this entry is a bestfree or it's smaller than
>  		 * any of the bestfrees.
>  		 */
>  		xfs_scrub_directory_check_free_entry(sc, lblk, bf, dup);
> +		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> +			goto out_buf;
>  
>  		/* Move on. */
>  		newlen = be16_to_cpu(dup->length);
> @@ -546,6 +561,8 @@ xfs_scrub_directory_leaf1_bestfree(
>  	}
>  	if (leafhdr.stale != stale)
>  		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> +	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> +		goto out;
>  
>  	/* Check all the bestfree entries. */
>  	for (i = 0; i < bestcount; i++, bestp++) {
> @@ -556,9 +573,11 @@ xfs_scrub_directory_leaf1_bestfree(
>  				i * args->geo->fsbcount, -1, &dbp);
>  		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk,
>  				&error))
> -			continue;
> +			break;
>  		xfs_scrub_directory_check_freesp(sc, lblk, dbp, best);
>  		xfs_trans_brelse(sc->tp, dbp);
> +		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> +			goto out;
>  	}
>  out:
>  	return error;
> @@ -607,7 +626,7 @@ xfs_scrub_directory_free_bestfree(
>  				-1, &dbp);
>  		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk,
>  				&error))
> -			continue;
> +			break;
>  		xfs_scrub_directory_check_freesp(sc, lblk, dbp, best);
>  		xfs_trans_brelse(sc->tp, dbp);
>  	}
> @@ -656,7 +675,7 @@ xfs_scrub_directory_blocks(
>  
>  	/* Iterate all the data extents in the directory... */
>  	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &icur, &got);
> -	while (found) {
> +	while (found && !(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
>  		/* Block directories only have a single block at offset 0. */
>  		if (is_block &&
>  		    (got.br_startoff > 0 ||
> @@ -719,7 +738,7 @@ xfs_scrub_directory_blocks(
>  	/* Scan for free blocks */
>  	lblk = free_lblk;
>  	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &icur, &got);
> -	while (found) {
> +	while (found && !(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
>  		/*
>  		 * Dirs can't have blocks mapped above 2^32.
>  		 * Single-block dirs shouldn't even be here.
> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index 1fb88c18d455..fc336807e156 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -147,6 +147,9 @@ xfs_scrub_parent_validate(
>  
>  	*try_again = false;
>  
> +	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> +		goto out;
> +
>  	/* '..' must not point to ourselves. */
>  	if (sc->ip->i_ino == dnum) {
>  		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
