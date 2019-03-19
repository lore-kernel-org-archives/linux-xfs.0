Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44222 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfCSPPs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 11:15:48 -0400
Date: Tue, 19 Mar 2019 08:15:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: always init bma in xfs_bmapi_write
Message-ID: <20190319151539.GQ4929@magnolia>
References: <20190318164401.GP4929@magnolia>
 <20190319130112.GC23863@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319130112.GC23863@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Tue, Mar 19, 2019 at 09:01:13AM -0400, Brian Foster wrote:
> On Mon, Mar 18, 2019 at 09:44:01AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Always init the tp/ip fields of bma in xfs_bmapi_write so that the
> > bmapi_finish at the bottom never trips over null transaction or inode
> > pointers.
> > 
> > Coverity-id: 1443964
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c |   10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 625ddfb9653e..17c7168966c6 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -4254,9 +4254,13 @@ xfs_bmapi_write(
> >  	struct xfs_bmbt_irec	*mval,		/* output: map values */
> >  	int			*nmap)		/* i/o: mval size/count */
> >  {
> > +	struct xfs_bmalloca	bma = {
> > +		.tp		= tp,
> > +		.ip		= ip,
> > +		.total		= total,
> > +	};
> 
> This should continue to zero-init the rest of the structure, right?

I hope so.  If not, there's going to be a lot of corrupt in-core structs
in the kernel... :)

Thanks for the review, btw.

--D

> If so, looks fine:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct xfs_ifork	*ifp;
> > -	struct xfs_bmalloca	bma = { NULL };	/* args for xfs_bmap_alloc */
> >  	xfs_fileoff_t		end;		/* end of mapped file region */
> >  	bool			eof = false;	/* after the end of extents */
> >  	int			error;		/* error return */
> > @@ -4324,10 +4328,6 @@ xfs_bmapi_write(
> >  		eof = true;
> >  	if (!xfs_iext_peek_prev_extent(ifp, &bma.icur, &bma.prev))
> >  		bma.prev.br_startoff = NULLFILEOFF;
> > -	bma.tp = tp;
> > -	bma.ip = ip;
> > -	bma.total = total;
> > -	bma.datatype = 0;
> >  	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
> >  
> >  	n = 0;
