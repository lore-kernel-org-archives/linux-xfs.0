Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45169 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752057AbcJJVsP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 17:48:15 -0400
Date: Mon, 10 Oct 2016 14:46:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 1/7] xfs: rework refcount cow recovery error handling
Message-ID: <20161010214616.GD22379@birch.djwong.org>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588164562.12127.10503063159516084342.stgit@birch.djwong.org>
 <20161010061122.GC5619@birch.djwong.org>
 <20161010102113.GC18359@infradead.org>
 <20161010182152.GC22379@birch.djwong.org>
 <20161010202528.GE23194@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161010202528.GE23194@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Tue, Oct 11, 2016 at 07:25:28AM +1100, Dave Chinner wrote:
> On Mon, Oct 10, 2016 at 11:21:52AM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 10, 2016 at 03:21:13AM -0700, Christoph Hellwig wrote:
> > > On Sun, Oct 09, 2016 at 11:11:22PM -0700, Darrick J. Wong wrote:
> > > > The error handling in xfs_refcount_recover_cow_leftovers is confused
> > > > and can potentially leak memory, so rework it to release resources
> > > > correctly on error.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > Reported-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_refcount.c |   16 ++++++----------
> > > >  1 file changed, 6 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > > > index 56bfef1..955b1d9 100644
> > > > --- a/fs/xfs/libxfs/xfs_refcount.c
> > > > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > > > @@ -1643,7 +1643,7 @@ xfs_refcount_recover_cow_leftovers(
> > > >  	error = xfs_btree_query_range(cur, &low, &high,
> > > >  			xfs_refcount_recover_extent, &debris);
> > > >  	if (error)
> > > > -		goto out_error;
> > > > +		goto out_cursor;
> > > >  	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> > > >  	xfs_buf_relse(agbp);
> 
> Cursor is freed here when everything works...
> 
> I almost modified this to be:
> 
> 	error = xfs_btree_query_range(cur, &low, &high,
> 			xfs_refcount_recover_extent, &debris);
> 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> 	xfs_buf_relse(agbp);
> 	if (error)
> 		goto out_free;
> 
> so the "out_cursor" branch could go away....
> 
> > > > @@ -1675,26 +1675,22 @@ xfs_refcount_recover_cow_leftovers(
> > > >  
> > > >  		error = xfs_trans_commit(tp);
> > > >  		if (error)
> > > > +			goto out_free;
> > > >  	}
> > > >  	goto out_free;
> > > 
> > > don't we need to also delete the cursor after a successful exit?
> > 
> > Gah.  Yeah.  Serves me right for trying to code patches on Sunday night.
> 
> It all looked ok to me - what did I miss?

The current code in your for-next tree looks fine.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
