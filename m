Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 55FC87F37
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 10:16:36 -0500 (CDT)
Date: Sat, 25 May 2013 10:16:32 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 10/11] xfs: fix incorrect remote symlink block count
Message-ID: <20130525151631.GY20028@sgi.com>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
	<1369123330-9579-11-git-send-email-david@fromorbit.com>
	<20130524203633.GW20028@sgi.com> <20130524203910.GX20028@sgi.com>
	<20130524234144.GJ24543@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130524234144.GJ24543@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sat, May 25, 2013 at 09:41:44AM +1000, Dave Chinner wrote:
> On Fri, May 24, 2013 at 03:39:10PM -0500, Ben Myers wrote:
> > On Fri, May 24, 2013 at 03:36:33PM -0500, Ben Myers wrote:
> > > On Tue, May 21, 2013 at 06:02:09PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > When CRCs are enabled, the number of blocks needed to hold a remote
> > > > symlink on a 1k block size filesystem may be 2 instead of 1. The
> > > > transaction reservation for the allocated bloks was not taking this
> > > 					    blocks
> > > > into account and only allocating one block. hence when trying to
> > > 					      H
> > > 
> > > fixed.
> > > 
> > > > read or invalidate such symlinks, we are mapping a hole where there
> > > > should be a block and things go bad at that point.
> > > > 
> > > > Fix the reservation to use the correct block count, clean up the
> > > > block count calculation similar to the remote attribute calculation,
> > > > and add a debug guard to detect when we don't write the entire
> > > > symlink to disk.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ...
> 
> > > > @@ -525,9 +518,7 @@ xfs_symlink(
> > > >  			bp->b_ops = &xfs_symlink_buf_ops;
> > > >  
> > > >  			byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
> > > > -			if (pathlen < byte_cnt) {
> > > > -				byte_cnt = pathlen;
> > > > -			}
> > > > +			byte_cnt = min(byte_cnt, pathlen);
> > > 
> > > The min is necessary due since we can have up to three extents in here,
> > > according to the comment above the define for XFS_SYMLINK_MAPS.  So byte_cnt
> > > can be less than pathlen.
> > 
> > D'oh.  I wanted to point out that it looks like this issue with 'min' here
> > should be causing problems with symlinks on non-crc enabled filesystems.
> 
> What issue might that be? The result is identical in either case, I
> just converted this to min to be more concise and consistent with
> the same code loops in the remote attr copyin/copyout.

My impression was that if you have byte_cnt < pathlen we'll copy past the end
of the extent.  Looks like I was wrong.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
