Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17793 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750776AbeELCDd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 22:03:33 -0400
Date: Sat, 12 May 2018 12:03:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/10] xfs: turn ag header initialisation into a table
 driven operation
Message-ID: <20180512020331.GZ10363@dastard>
References: <20180511225107.27171-1-david@fromorbit.com>
 <20180511225107.27171-6-david@fromorbit.com>
 <20180512005535.GR11261@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180512005535.GR11261@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 11, 2018 at 05:55:35PM -0700, Darrick J. Wong wrote:
> On Sat, May 12, 2018 at 08:51:02AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > There's still more cookie cutter code in setting up each AG header.
> > Separate all the variables into a simple structure and iterate a
> > table of header definitions to initialise everything.
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_fsops.c | 158 +++++++++++++++++++--------------------------
> >  1 file changed, 66 insertions(+), 92 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index 4dbb7b41aeca..263f9b5da991 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -283,12 +283,13 @@ xfs_agiblock_init(
> >  		agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
> >  }
> >  
> > +typedef void (*aghdr_init_work_f)(struct xfs_mount *mp, struct xfs_buf *bp,
> > +				  struct aghdr_init_data *id);
> >  static int
> >  xfs_growfs_init_aghdr(
> >  	struct xfs_mount	*mp,
> >  	struct aghdr_init_data	*id,
> > -	void			(*work)(struct xfs_mount *, struct xfs_buf *,
> > -					struct aghdr_init_data *),
> > +	aghdr_init_work_f	work,
> >  	const struct xfs_buf_ops *ops)
> >  
> >  {
> > @@ -305,6 +306,16 @@ xfs_growfs_init_aghdr(
> >  	return 0;
> >  }
> >  
> > +struct xfs_aghdr_grow_data {
> > +	xfs_daddr_t		daddr;
> > +	size_t			numblks;
> > +	const struct xfs_buf_ops *ops;
> > +	aghdr_init_work_f	work;
> > +	xfs_btnum_t		type;
> > +	int			numrecs;
> > +	bool			need_init;
> > +};
> > +
> >  /*
> >   * Write new AG headers to disk. Non-transactional, but written
> >   * synchronously so they are completed prior to the growfs transaction
> > @@ -316,104 +327,67 @@ xfs_grow_ag_headers(
> >  	struct aghdr_init_data	*id)
> >  
> >  {
> > +	struct xfs_aghdr_grow_data aghdr_data[] = {
> > +		/* AGF */
> > +		{ XFS_AG_DADDR(mp, id->agno, XFS_AGF_DADDR(mp)),
> > +		  XFS_FSS_TO_BB(mp, 1), &xfs_agf_buf_ops,
> > +		  &xfs_agfblock_init, 0, 0, true },
> 
> Any chance I could get you to convert these to something associative
> and easier to check? e.g.
> 
> 	/* AGF */
> 	{
> 		.daddr		= XFS_AG_DADDR(mp, id->agno, XFS_AGF_DADDR(mp)),
> 		.numblks	= XFS_FSS_TO_BB(mp, 1),
> 		.ops		= &xfs_agf_buf_ops,
> 		.work		= &xfs_agfblock_init,
> 		.type		= 0,
> 		.numrecs	= 0,
> 		.need_init	= true,
> 	},

I can, if you don't care it will take 100 lines of code instead of
30.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
