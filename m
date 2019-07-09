Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfGIOZl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Jul 2019 10:25:41 -0400
Date: Tue, 9 Jul 2019 10:25:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: bump INUMBERS cursor correctly in xfs_inumbers_walk
Message-ID: <20190709142538.GA58362@bfoster>
References: <20190709135943.GF5167@magnolia>
 <20190709142226.GP1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709142226.GP1404256@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Jul 09, 2019 at 07:22:26AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 09, 2019 at 06:59:43AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > There's a subtle unit conversion error when we increment the INUMBERS
> > cursor at the end of xfs_inumbers_walk.  If there's an inode chunk at
> > the very end of the AG /and/ the AG size is a perfect power of two, that
> > means we can have inodes, that means that the startino of that last
> 
> "...is a perfect power of two, the startino of that last chunk..."
> 

Yeah, was going to point out this looked like some stale/spurious
text... :P

> --D
> 
> > chunk (which is in units of AG inodes) will be 63 less than (1 <<
> > agino_log).  If we add XFS_INODES_PER_CHUNK to the startino, we end up
> > with a startino that's larger than (1 << agino_log) and when we convert
> > that back to fs inode units we'll rip off that upper bit and wind up
> > back at the start of the AG.
> > 
> > Fix this by converting to units of fs inodes before adding
> > XFS_INODES_PER_CHUNK so that we'll harmlessly end up pointing to the
> > next AG.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---


Otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> >  fs/xfs/xfs_itable.c |    5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > index cda8ae94480c..a8a06bb78ea8 100644
> > --- a/fs/xfs/xfs_itable.c
> > +++ b/fs/xfs/xfs_itable.c
> > @@ -338,15 +338,14 @@ xfs_inumbers_walk(
> >  		.xi_version	= XFS_INUMBERS_VERSION_V5,
> >  	};
> >  	struct xfs_inumbers_chunk *ic = data;
> > -	xfs_agino_t		agino;
> >  	int			error;
> >  
> >  	error = ic->formatter(ic->breq, &inogrp);
> >  	if (error && error != XFS_IBULK_ABORT)
> >  		return error;
> >  
> > -	agino = irec->ir_startino + XFS_INODES_PER_CHUNK;
> > -	ic->breq->startino = XFS_AGINO_TO_INO(mp, agno, agino);
> > +	ic->breq->startino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino) +
> > +			XFS_INODES_PER_CHUNK;
> >  	return error;
> >  }
> >  
