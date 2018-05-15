Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40608 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbeEOXhT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 19:37:19 -0400
Date: Tue, 15 May 2018 16:36:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: change xfs_update_secondary_supers to use
 xfS_sb_read_secondary
Message-ID: <20180515233656.GO4933@magnolia>
References: <20180515204721.GM4933@magnolia>
 <20180515230811.GJ23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180515230811.GJ23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Wed, May 16, 2018 at 09:08:11AM +1000, Dave Chinner wrote:
> On Tue, May 15, 2018 at 01:47:21PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use the new helper to read secondary superblocks instead of opencoding
> > it ourselves.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_fsops.c |   10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 056a76689197..40c131ebf772 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -191,18 +191,15 @@ xfs_growfs_data_private(
> >   */
> >  int
> >  xfs_update_secondary_supers(
> > -	xfs_mount_t		*mp)
> > +	struct xfs_mount	*mp)
> >  {
> > -	int			error, saved_error;
> > +	struct xfs_buf		*bp;
> >  	xfs_agnumber_t		agno;
> > -	xfs_buf_t		*bp;
> > +	int			error, saved_error;
> >  
> >  	error = saved_error = 0;
> >  
> >  	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
> > -		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
> > -			  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> > -			  XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
> >  		/*
> >  		 * If we get an error reading or writing alternate superblocks,
> >  		 * continue.  xfs_repair chooses the "best" superblock based
> > @@ -210,6 +207,7 @@ xfs_update_secondary_supers(
> >  		 * superblocks un-updated than updated, and xfs_repair may
> >  		 * pick them over the properly-updated primary.
> >  		 */
> > +		error = xfs_sb_read_secondary(mp, NULL, agno, &bp);
> >  		if (error) {
> >  			xfs_warn(mp,
> >  		"error %d reading secondary superblock for ag %d",
> 
> Why change this now when my growfs patchset ireworks it and then
> moves the function entirely? Doing this now just breaks that
> patchset unnecessarily and forces another rebase - can we move this
> to the end of the growfs patchset?

The label stuff will come after your growfs stuff... maybe I'll try this
again tomorrow when I'm more awake.

Scrub wants a function to read a secondary sb, and a second one to clone
the primary to fix damage by getting the sb, formatting the incore sb
into the buffer, and writing it to disk.

Label wants a function to read each secondary sb, format the incore sb
into the buffer, and write it to disk.

Growfs wants to (read an existing ag's secondary sb | get a new ag's
sb), format the incore sb into the buffer, and write it to disk.

Does that sound right?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
