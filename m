Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:16622 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751594AbcJJUxC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 16:53:02 -0400
Date: Tue, 11 Oct 2016 07:25:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/7] xfs: rework refcount cow recovery error handling
Message-ID: <20161010202528.GE23194@dastard>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588164562.12127.10503063159516084342.stgit@birch.djwong.org>
 <20161010061122.GC5619@birch.djwong.org>
 <20161010102113.GC18359@infradead.org>
 <20161010182152.GC22379@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161010182152.GC22379@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Mon, Oct 10, 2016 at 11:21:52AM -0700, Darrick J. Wong wrote:
> On Mon, Oct 10, 2016 at 03:21:13AM -0700, Christoph Hellwig wrote:
> > On Sun, Oct 09, 2016 at 11:11:22PM -0700, Darrick J. Wong wrote:
> > > The error handling in xfs_refcount_recover_cow_leftovers is confused
> > > and can potentially leak memory, so rework it to release resources
> > > correctly on error.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > Reported-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_refcount.c |   16 ++++++----------
> > >  1 file changed, 6 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > > index 56bfef1..955b1d9 100644
> > > --- a/fs/xfs/libxfs/xfs_refcount.c
> > > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > > @@ -1643,7 +1643,7 @@ xfs_refcount_recover_cow_leftovers(
> > >  	error = xfs_btree_query_range(cur, &low, &high,
> > >  			xfs_refcount_recover_extent, &debris);
> > >  	if (error)
> > > -		goto out_error;
> > > +		goto out_cursor;
> > >  	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> > >  	xfs_buf_relse(agbp);

Cursor is freed here when everything works...

I almost modified this to be:

	error = xfs_btree_query_range(cur, &low, &high,
			xfs_refcount_recover_extent, &debris);
	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
	xfs_buf_relse(agbp);
	if (error)
		goto out_free;

so the "out_cursor" branch could go away....

> > > @@ -1675,26 +1675,22 @@ xfs_refcount_recover_cow_leftovers(
> > >  
> > >  		error = xfs_trans_commit(tp);
> > >  		if (error)
> > > +			goto out_free;
> > >  	}
> > >  	goto out_free;
> > 
> > don't we need to also delete the cursor after a successful exit?
> 
> Gah.  Yeah.  Serves me right for trying to code patches on Sunday night.

It all looked ok to me - what did I miss?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
