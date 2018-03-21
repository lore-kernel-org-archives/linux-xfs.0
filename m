Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55034 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbeCURo5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 13:44:57 -0400
Date: Wed, 21 Mar 2018 10:44:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/9] xfs: sanity-check the unused space before trying to
 use it
Message-ID: <20180321174453.GG4818@magnolia>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
 <152107377649.19571.3126019873391787136.stgit@magnolia>
 <20180321135233.GB11127@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180321135233.GB11127@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 21, 2018 at 09:52:33AM -0400, Brian Foster wrote:
> On Wed, Mar 14, 2018 at 05:29:36PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In xfs_dir2_data_use_free, we examine on-disk metadata and ASSERT if
> > it doesn't make sense.  Since a carefully crafted fuzzed image can cause
> > the kernel to crash after blowing a bunch of assertions, let's move
> > those checks into a validator function and rig everything up to return
> > EFSCORRUPTED to userspace.  Found by lastbit fuzzing ltail.bestcount via
> > xfs/391.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_dir2.h       |    2 +
> >  fs/xfs/libxfs/xfs_dir2_block.c |   38 ++++++++++++-------
> >  fs/xfs/libxfs/xfs_dir2_data.c  |   78 +++++++++++++++++++++++++++++++---------
> >  fs/xfs/libxfs/xfs_dir2_leaf.c  |    6 +++
> >  fs/xfs/libxfs/xfs_dir2_node.c  |    4 ++
> >  5 files changed, 93 insertions(+), 35 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> > index 388d67c..989e95a 100644
> > --- a/fs/xfs/libxfs/xfs_dir2.h
> > +++ b/fs/xfs/libxfs/xfs_dir2.h
> > @@ -173,7 +173,7 @@ extern void xfs_dir2_data_log_unused(struct xfs_da_args *args,
> >  extern void xfs_dir2_data_make_free(struct xfs_da_args *args,
> >  		struct xfs_buf *bp, xfs_dir2_data_aoff_t offset,
> >  		xfs_dir2_data_aoff_t len, int *needlogp, int *needscanp);
> > -extern void xfs_dir2_data_use_free(struct xfs_da_args *args,
> > +extern int xfs_dir2_data_use_free(struct xfs_da_args *args,
> >  		struct xfs_buf *bp, struct xfs_dir2_data_unused *dup,
> >  		xfs_dir2_data_aoff_t offset, xfs_dir2_data_aoff_t len,
> >  		int *needlogp, int *needscanp);
> > diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> > index 2da86a3..5726402 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_block.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> > @@ -454,12 +454,15 @@ xfs_dir2_block_addname(
> >  		/*
> >  		 * Mark the space needed for the new leaf entry, now in use.
> >  		 */
> > -		xfs_dir2_data_use_free(args, bp, enddup,
> > +		error = xfs_dir2_data_use_free(args, bp, enddup,
> >  			(xfs_dir2_data_aoff_t)
> >  			((char *)enddup - (char *)hdr + be16_to_cpu(enddup->length) -
> >  			 sizeof(*blp)),
> >  			(xfs_dir2_data_aoff_t)sizeof(*blp),
> >  			&needlog, &needscan);
> 
> Parameter alignment looks screwed up on many of these updated calls
> throughout.

Yeah, they're a mess.  As usual I tried to start with the smallest
possible fix, but ugh this does scream for some cleaning.

> > +		if (error)
> > +			return error;
> > +
> >  		/*
> >  		 * Update the tail (entry count).
> >  		 */
> ...
> > diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> > index 0839ffe..641b352 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_node.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> > @@ -2023,9 +2023,11 @@ xfs_dir2_node_addname_int(
> >  	/*
> >  	 * Mark the first part of the unused space, inuse for us.
> >  	 */
> > -	xfs_dir2_data_use_free(args, dbp, dup,
> > +	error = xfs_dir2_data_use_free(args, dbp, dup,
> >  		(xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr), length,
> >  		&needlog, &needscan);
> > +	if (error)
> > +		return error;
> 
> Do we have to deal with dbp here?

It's bjoined to the transaction, so dbp should be freed when the caller
cancels the transaction after we error out.  OTOH it doesn't hurt to
try to release the buffer early.

--D

> Brian
> 
> >  	/*
> >  	 * Fill in the new entry and log it.
> >  	 */
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
