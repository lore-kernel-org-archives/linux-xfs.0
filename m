Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:57750 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727033AbeK1Qiu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 11:38:50 -0500
Date: Wed, 28 Nov 2018 16:38:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v1 5/7] xfs: Add device retry
Message-ID: <20181128053821.GM6311@dastard>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
 <1543376991-5764-6-git-send-email-allison.henderson@oracle.com>
 <20181128050850.GJ6311@dastard>
 <20181128052245.GD8125@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128052245.GD8125@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com

On Tue, Nov 27, 2018 at 09:22:45PM -0800, Darrick J. Wong wrote:
> On Wed, Nov 28, 2018 at 04:08:50PM +1100, Dave Chinner wrote:
> > On Tue, Nov 27, 2018 at 08:49:49PM -0700, Allison Henderson wrote:
> > > Check to see if the _xfs_buf_read fails.  If so loop over the
> > > available mirrors and retry the read
> > > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >  fs/xfs/xfs_buf.c | 28 +++++++++++++++++++++++++++-
> > >  1 file changed, 27 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index dd8ba59..f102d01 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -21,6 +21,7 @@
> > >  #include <linux/migrate.h>
> > >  #include <linux/backing-dev.h>
> > >  #include <linux/freezer.h>
> > > +#include <linux/blkdev.h>
> > >  
> > >  #include "xfs_format.h"
> > >  #include "xfs_log_format.h"
> > > @@ -808,6 +809,8 @@ xfs_buf_read_map(
> > >  	const struct xfs_buf_ops *ops)
> > >  {
> > >  	struct xfs_buf		*bp;
> > > +	struct request_queue	*q;
> > > +	unsigned short		i;
> > >  
> > >  	flags |= XBF_READ;
> > >  
> > > @@ -820,7 +823,30 @@ xfs_buf_read_map(
> > >  	if (!(bp->b_flags & XBF_DONE)) {
> > >  		XFS_STATS_INC(target->bt_mount, xb_get_read);
> > >  		bp->b_ops = ops;
> > > -		_xfs_buf_read(bp, flags);
> > > +		q = bdev_get_queue(bp->b_target->bt_bdev);
> > > +
> > > +		/*
> > > +		 * Mirrors are indexed 1 - n, specified through the rw_hint.
> > > +		 * Setting the hint to 0 is unspecified and allows the block
> > > +		 * layer to decide.
> > > +		 */
> > > +		for (i = 0; i <= blk_queue_get_mirrors(q); i++) {
> > > +			bp->b_error = 0;
> > > +			bp->b_rw_hint = i;
> > > +			_xfs_buf_read(bp, flags);
> > 
> > So the first time through this loop the block layer devices what
> > device to read from, then we iterate devices 1..n on error.
> > 
> > Whihc means if device 0 is the only one with good information in it,
> > we may not ever actually read from it.
> > 
> > I'd suggest that a hint of "-1" (or equivalent max value) should be
> > used for "device selects mirror leg" rather than 0, so we can
> > actually read from the first device on command.
> 
> "read from the first device on command" => "set bio.bi_rw_hint = 1"...

Landmine.

> > i.e.
> > 		bp->b_error = 0;
> > 		bp->b_rw_hint = -1;
> 
> ...which is confusing.  The intended behavior for this RFC (though not
> so well documented) is that bi_rw_hint == 0 means "let the device
> choose", and rw_hint > 1 means "choose mirror (rw_hint - 1)".  That's
> sort of an odd behavior because now we have:
> 
> blk_queue_get_mirrors(q) returns 5 (as in 5 mirrors) but we access the
> 5 mirrors as indices 1-5, not 0-4 like most programmers would probably
> expect.

Yeah, that's not nice, and will lead to bugs in future as it trips
up people who have forgotten about this quirk.

> Also, I think it's probably necessary to create a #define to attach a
> name to the "let the device choose" value...
> 
> #define BIO_RW_HINT_ANY_MIRROR	(0)
> 
> for (i = BIO_RW_HINT_ANY_MIRROR; i <= blk_queue_get_mirrors(q); i++) {
> 	...
> 	bp->b_rw_hint = i;
> 	...
> 	_xfs_buf_read(bp, flags);
> 	...
> }

The recovery algorithms are only going to get more complex as
time goes on, so I'd really like to see an explicit separation of
the simple, unchanging fast path and the fallback recovery code.

Cheers,

dave.
-- 
Dave Chinner
david@fromorbit.com
