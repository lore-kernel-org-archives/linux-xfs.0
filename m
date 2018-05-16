Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:42014 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751309AbeEPBEr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 21:04:47 -0400
Date: Wed, 16 May 2018 11:04:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: change xfs_update_secondary_supers to use
 xfS_sb_read_secondary
Message-ID: <20180516010443.GN23861@dastard>
References: <20180515204721.GM4933@magnolia>
 <20180515230811.GJ23861@dastard>
 <20180515233656.GO4933@magnolia>
 <20180516002346.GL23861@dastard>
 <20180516004129.GP4933@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516004129.GP4933@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, May 15, 2018 at 05:41:29PM -0700, Darrick J. Wong wrote:
> On Wed, May 16, 2018 at 10:23:46AM +1000, Dave Chinner wrote:
> > On Tue, May 15, 2018 at 04:36:56PM -0700, Darrick J. Wong wrote:
> > > On Wed, May 16, 2018 at 09:08:11AM +1000, Dave Chinner wrote:
> > > > On Tue, May 15, 2018 at 01:47:21PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > Use the new helper to read secondary superblocks instead of opencoding
> > > > > it ourselves.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > ---
> > > > >  fs/xfs/xfs_fsops.c |   10 ++++------
> > > > >  1 file changed, 4 insertions(+), 6 deletions(-)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > > > index 056a76689197..40c131ebf772 100644
> > > > > --- a/fs/xfs/xfs_fsops.c
> > > > > +++ b/fs/xfs/xfs_fsops.c
> > > > > @@ -191,18 +191,15 @@ xfs_growfs_data_private(
> > > > >   */
> > > > >  int
> > > > >  xfs_update_secondary_supers(
> > > > > -	xfs_mount_t		*mp)
> > > > > +	struct xfs_mount	*mp)
> > > > >  {
> > > > > -	int			error, saved_error;
> > > > > +	struct xfs_buf		*bp;
> > > > >  	xfs_agnumber_t		agno;
> > > > > -	xfs_buf_t		*bp;
> > > > > +	int			error, saved_error;
> > > > >  
> > > > >  	error = saved_error = 0;
> > > > >  
> > > > >  	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
> > > > > -		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
> > > > > -			  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> > > > > -			  XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
> > > > >  		/*
> > > > >  		 * If we get an error reading or writing alternate superblocks,
> > > > >  		 * continue.  xfs_repair chooses the "best" superblock based
> > > > > @@ -210,6 +207,7 @@ xfs_update_secondary_supers(
> > > > >  		 * superblocks un-updated than updated, and xfs_repair may
> > > > >  		 * pick them over the properly-updated primary.
> > > > >  		 */
> > > > > +		error = xfs_sb_read_secondary(mp, NULL, agno, &bp);
> > > > >  		if (error) {
> > > > >  			xfs_warn(mp,
> > > > >  		"error %d reading secondary superblock for ag %d",
> > > > 
> > > > Why change this now when my growfs patchset ireworks it and then
> > > > moves the function entirely? Doing this now just breaks that
> > > > patchset unnecessarily and forces another rebase - can we move this
> > > > to the end of the growfs patchset?
> > > 
> > > The label stuff will come after your growfs stuff... maybe I'll try this
> > > again tomorrow when I'm more awake.
> > 
> > *nod*
> 
> Aha, just s/xfs_update_secondary_supers/xfs_update_secondary_sbs/ in
> Eric's online label patch, and drop the one where he adds
> xfs_update_secondary_supers.
> 
> > > Scrub wants a function to read a secondary sb, and a second one to clone
> > > the primary to fix damage by getting the sb, formatting the incore sb
> > > into the buffer, and writing it to disk.
> > 
> > This is all done in a transaction context during scrub, isn't it?
> > Which means it's mostly separate to the non-transactional "update
> > all secondary SB's?
> 
> Yes.  It's likely we only want to update a single secondary sb, and
> updating all of them is overkill, so maybe it's fine just to open code
> this one use?  Seeing as I don't think we'd ordinarily be updating only
> a single secondary sb.

Ok, so that means - initially, at least - they will be separate
functions.

In time, I'd like to explore making the secondary superblock
updates ordered buffers attached to a special superblock update
transaction (i.e. like the inode extent swap intent in the inode log
item flags), and that would probably allow us to factor it all down
to a single set of transaction aware functions...

> > > Label wants a function to read each secondary sb, format the incore sb
> > > into the buffer, and write it to disk.
> > 
> > Yup - it can just use the function I added to rewrite all the
> > secondary superblocks.
> > 
> > Hmmmm - just a thought here: does repair check and repair
> > inconsistent labels across secondary superblocks? What about UUID
> > updates? Do we have a generic need for some superblock updates to be
> > atomic across all superblocks?
> 
> Online fsck checks both sb_fname and sb_uuid and complains if the
> secondaries are out of date.  xfs_repair doesn't check at all.

OK, so I'm guessing that will get added to the growing list of
things that repair needs to check?

> > > Growfs wants to (read an existing ag's secondary sb | get a new ag's
> > > sb), format the incore sb into the buffer, and write it to disk.
> > 
> > After my changes, growfs no longer reads the secondary superblocks.
> > It just rewrites them all completely by rewriting the primary SB
> > into them. The existing code rewrites them completely, too, so the
> > read is actually redundant and, potentially, can cause the grow to
> > fail.
> 
> Ok, I had wondered myself if we should unconditionally rewrite the
> secondary sbs, because why would we care what the previous contents
> were?

Exactly :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
