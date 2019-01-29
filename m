Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbfA2Nrx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Jan 2019 08:47:53 -0500
Date: Tue, 29 Jan 2019 08:47:51 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: end sync buffer I/O properly on shutdown error
Message-ID: <20190129134750.GB24998@bfoster>
References: <20190128145548.20726-1-bfoster@redhat.com>
 <20190128213041.GR4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128213041.GR4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 29, 2019 at 08:30:41AM +1100, Dave Chinner wrote:
> On Mon, Jan 28, 2019 at 09:55:48AM -0500, Brian Foster wrote:
> > As of commit e339dd8d8b ("xfs: use sync buffer I/O for sync delwri
> > queue submission"), the delwri submission code uses sync buffer I/O
> > for sync delwri I/O. Instead of waiting on async I/O to unlock the
> > buffer, it uses the underlying sync I/O completion mechanism.
> > 
> > If delwri buffer submission fails due to a shutdown scenario, an
> > error is set on the buffer and buffer completion never occurs. This
> > can cause xfs_buf_delwri_submit() to deadlock waiting on a
> > completion event.
> > 
> > We could check the error state before waiting on such buffers, but
> > that doesn't serialize against the case of an error set via a racing
> > I/O completion. Instead, invoke I/O completion in the shutdown case
> > regardless of buffer I/O type.
> 
> How did you find this? i.e. what are the symptoms of the bug? I'm
> guessing that it's a shutdown/unmount hang from the above, but I'm
> really not sure.
> 

A shutdown during log recovery via generic/034 reproduced the deadlock
described in the commit log. The shutdown itself was caused by developer
error (missing an xfs_buf_ops assignment when working on the magic
stuff), so I'm not aware of a current upstream reproducer (that wouldn't
be related to some already corrupted fs).

> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index eedc5e0156ff..1f9857e3630a 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1536,8 +1536,7 @@ __xfs_buf_submit(
> >  		xfs_buf_ioerror(bp, -EIO);
> >  		bp->b_flags &= ~XBF_DONE;
> >  		xfs_buf_stale(bp);
> > -		if (bp->b_flags & XBF_ASYNC)
> > -			xfs_buf_ioend(bp);
> > +		xfs_buf_ioend(bp);
> >  		return -EIO;
> >  	}
> 
> That said, it definitely looks like it fixes a bug. Will test.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 

Thanks.

Brian

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
