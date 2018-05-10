Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34436 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965033AbeEJPys (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 11:54:48 -0400
Date: Thu, 10 May 2018 08:54:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/12] xfs: don't continue scrub if already corrupt
Message-ID: <20180510155427.GA11261@magnolia>
References: <152537075334.16676.10600900179473864298.stgit@magnolia>
 <152537078026.16676.17251024406358600547.stgit@magnolia>
 <20180510135342.GD69384@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180510135342.GD69384@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 10, 2018 at 09:53:43AM -0400, Brian Foster wrote:
> On Thu, May 03, 2018 at 11:06:20AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If we've already decided that something is corrupt, we might as well
> > abort all the loops and exit as quickly as possible.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Just a few nits..
> 
> >  fs/xfs/scrub/attr.c   |    3 ++-
> >  fs/xfs/scrub/bmap.c   |    3 ++-
> >  fs/xfs/scrub/dir.c    |   34 +++++++++++++++++++++++++---------
> >  fs/xfs/scrub/parent.c |    3 +++
> >  4 files changed, 32 insertions(+), 11 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> > index 127575f0abfb..84b6d6b66578 100644
> > --- a/fs/xfs/scrub/attr.c
> > +++ b/fs/xfs/scrub/attr.c
> > @@ -126,8 +126,9 @@ xfs_scrub_xattr_listent(
> >  	if (args.valuelen != valuelen)
> >  		xfs_scrub_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK,
> >  					     args.blkno);
> > -
> >  fail_xref:
> > +	if (sx->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > +		context->seen_enough = 1;
> >  	return;
> >  }
> >  
> > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > index fb91caf17652..c28ff2ec201a 100644
> > --- a/fs/xfs/scrub/bmap.c
> > +++ b/fs/xfs/scrub/bmap.c
> > @@ -684,7 +684,8 @@ xfs_scrub_bmap(
> >  	info.lastoff = 0;
> >  	ifp = XFS_IFORK_PTR(ip, whichfork);
> >  	for_each_xfs_iext(ifp, &icur, &irec) {
> > -		if (xfs_scrub_should_terminate(sc, &error))
> > +		if (xfs_scrub_should_terminate(sc, &error) ||
> > +		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> >  			break;
> >  		if (isnullstartblock(irec.br_startblock))
> >  			continue;
> > diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> > index 38f29806eb54..fb56a885f443 100644
> > --- a/fs/xfs/scrub/dir.c
> > +++ b/fs/xfs/scrub/dir.c
> > @@ -172,7 +172,7 @@ xfs_scrub_dir_actor(
> >  	error = xfs_dir_lookup(sdc->sc->tp, ip, &xname, &lookup_ino, NULL);
> >  	if (!xfs_scrub_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
> >  			&error))
> > -		goto fail_xref;
> > +		goto out;
> >  	if (lookup_ino != ino) {
> >  		xfs_scrub_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
> >  		goto out;
> > @@ -183,8 +183,13 @@ xfs_scrub_dir_actor(
> >  	if (error)
> >  		goto out;
> >  out:
> > -	return error;
> > -fail_xref:
> > +	/*
> > +	 * A negative error code returned here is supposed to cause the
> > +	 * dir_emit caller (xfs_readdir) to abort the directory iteration
> > +	 * and return zero to xfs_scrub_dir.
> 
> s/xfs_scrub_dir/xfs_scrub_directory/ ?

Fixed.

> > +	 */
> > +	if (error == 0 && sdc->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > +		return -EFSCORRUPTED;
> >  	return error;
> >  }
> >  
> > @@ -240,6 +245,9 @@ xfs_scrub_dir_rec(
> >  	}
> >  	xfs_scrub_buffer_recheck(ds->sc, bp);
> >  
> > +	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > +		goto out_relse;
> > +
> >  	dent = (struct xfs_dir2_data_entry *)(((char *)bp->b_addr) + off);
> >  
> >  	/* Make sure we got a real directory entry. */
> > @@ -357,6 +365,9 @@ xfs_scrub_directory_data_bestfree(
> >  
> >  	/* XXX: Check xfs_dir3_data_hdr.pad is zero once we start setting it. */
> >  
> > +	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > +		goto out_buf;
> > +
> >  	/* Do the bestfrees correspond to actual free space? */
> >  	bf = d_ops->data_bestfree_p(bp->b_addr);
> >  	smallest_bestfree = UINT_MAX;
> > @@ -394,7 +405,7 @@ xfs_scrub_directory_data_bestfree(
> >  	endptr = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
> >  
> >  	/* Iterate the entries, stopping when we hit or go past the end. */
> > -	while (ptr < endptr) {
> > +	while (ptr < endptr && !(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
> 
> This seems like slightly different behavior than all of the other
> corruption checks in the loop. Perhaps this should go after the
> xfs_scrub_directory_check_free_entry() call?

Yep, fixed.

> >  		dup = (struct xfs_dir2_data_unused *)ptr;
> >  		/* Skip real entries */
> >  		if (dup->freetag != cpu_to_be16(XFS_DIR2_DATA_FREE_TAG)) {
> > @@ -413,8 +424,10 @@ xfs_scrub_directory_data_bestfree(
> >  
> >  		/* Spot check this free entry */
> >  		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
> > -		if (tag != ((char *)dup - (char *)bp->b_addr))
> > +		if (tag != ((char *)dup - (char *)bp->b_addr)) {
> >  			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> > +			goto out_buf;
> > +		}
> >  
> >  		/*
> >  		 * Either this entry is a bestfree or it's smaller than
> > @@ -549,6 +562,8 @@ xfs_scrub_directory_leaf1_bestfree(
> >  
> >  	/* Check all the bestfree entries. */
> >  	for (i = 0; i < bestcount; i++, bestp++) {
> > +		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > +			break;
> 
> This seems similarly misplaced. If somebody later adds some additional
> checks before the loop, this all of a sudden doesn't exactly do the same
> thing. Perhaps check after the preceding hash checks and then again in
> the loop after the brelse?

Ok.

> >  		best = be16_to_cpu(*bestp);
> >  		if (best == NULLDATAOFF)
> >  			continue;
> > @@ -556,9 +571,10 @@ xfs_scrub_directory_leaf1_bestfree(
> >  				i * args->geo->fsbcount, -1, &dbp);
> >  		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk,
> >  				&error))
> > -			continue;
> > +			break;
> >  		xfs_scrub_directory_check_freesp(sc, lblk, dbp, best);
> >  		xfs_trans_brelse(sc->tp, dbp);
> > +
> >  	}
> >  out:
> >  	return error;
> > @@ -607,7 +623,7 @@ xfs_scrub_directory_free_bestfree(
> >  				-1, &dbp);
> >  		if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, lblk,
> >  				&error))
> > -			continue;
> > +			break;
> >  		xfs_scrub_directory_check_freesp(sc, lblk, dbp, best);
> >  		xfs_trans_brelse(sc->tp, dbp);
> >  	}
> > @@ -656,7 +672,7 @@ xfs_scrub_directory_blocks(
> >  
> >  	/* Iterate all the data extents in the directory... */
> >  	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &icur, &got);
> > -	while (found) {
> > +	while (found && !(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
> >  		/* Block directories only have a single block at offset 0. */
> >  		if (is_block &&
> >  		    (got.br_startoff > 0 ||
> > @@ -719,7 +735,7 @@ xfs_scrub_directory_blocks(
> >  	/* Scan for free blocks */
> >  	lblk = free_lblk;
> >  	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &icur, &got);
> > -	while (found) {
> > +	while (found && !(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
> >  		/*
> >  		 * Dirs can't have blocks mapped above 2^32.
> >  		 * Single-block dirs shouldn't even be here.
> > diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> > index 1fb88c18d455..95fdd0d9e65d 100644
> > --- a/fs/xfs/scrub/parent.c
> > +++ b/fs/xfs/scrub/parent.c
> > @@ -147,6 +147,9 @@ xfs_scrub_parent_validate(
> >  
> >  	*try_again = false;
> >  
> > +	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > +		return 0;
> > +
> 
> Technically the same resulting logic, but the return 0 here vs. the goto
> out (that also returns 0) in the subsequent check stand out a bit as
> inconsistent.

Fixed.  Thanks for the review!

--D

> Brian
> 
> >  	/* '..' must not point to ourselves. */
> >  	if (sc->ip->i_ino == dnum) {
> >  		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
