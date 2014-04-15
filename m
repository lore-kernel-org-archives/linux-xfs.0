Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 918707F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 16:47:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2DDF5AC001
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 14:46:58 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HB1xgjN5Rm5GTdqf for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 14:46:56 -0700 (PDT)
Date: Wed, 16 Apr 2014 07:46:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/9] repair: ensure prefetched buffers have CRCs validated
Message-ID: <20140415214642.GN15995@dastard>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-4-git-send-email-david@fromorbit.com>
	<20140415194000.GB3470@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140415194000.GB3470@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 15, 2014 at 03:40:00PM -0400, Brian Foster wrote:
> On Tue, Apr 15, 2014 at 06:24:55PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Prefetch currently does not do CRC validation when the IO completes
> > due to the optimisation it performs and the fact that it does not
> > know what the type of metadata into the buffer is supposed to be.
> > Hence, mark all prefetched buffers as "suspect" so that when the
> > end user tries to read it with a supplied validation function the
> > validation is run even though the buffer was already in the cache.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  include/libxfs.h  |  1 +
> >  libxfs/rdwr.c     | 36 +++++++++++++++++++++++++++++++-----
> >  repair/prefetch.c |  3 +++
> >  3 files changed, 35 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/libxfs.h b/include/libxfs.h
> > index 6bc6c94..6b1e276 100644
> > --- a/include/libxfs.h
> > +++ b/include/libxfs.h
> > @@ -333,6 +333,7 @@ enum xfs_buf_flags_t {	/* b_flags bits */
> >  	LIBXFS_B_STALE		= 0x0004,	/* buffer marked as invalid */
> >  	LIBXFS_B_UPTODATE	= 0x0008,	/* buffer is sync'd to disk */
> >  	LIBXFS_B_DISCONTIG	= 0x0010,	/* discontiguous buffer */
> > +	LIBXFS_B_UNCHECKED	= 0x0020,	/* needs verification */
> 
> This is used in the first couple patches, so it should probably be
> defined earlier (or shuffle those patches appropriately).

Ah, I busted that on shuffling the patchset, and hadn't done a
patch-by-patch compile. Well spotted!

> 
> >  };
> >  
> >  #define XFS_BUF_DADDR_NULL		((xfs_daddr_t) (-1LL))
> > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > index 7208a2f..a8f06aa 100644
> > --- a/libxfs/rdwr.c
> > +++ b/libxfs/rdwr.c
> > @@ -718,12 +718,25 @@ libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
> >  	bp = libxfs_getbuf(btp, blkno, len);
> >  	if (!bp)
> >  		return NULL;
> > -	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY)))
> > +
> > +	/*
> > +	 * if the buffer was prefetched, it is likely that it was not
> > +	 * validated. Hence if we are supplied an ops function and the
> > +	 * buffer is marked as unchecked, we need to validate it now.
> > +	 */
> > +	if ((bp->b_flags & (LIBXFS_B_UPTODATE|LIBXFS_B_DIRTY))) {
> > +		if (ops && (bp->b_flags & LIBXFS_B_UNCHECKED)) {
> > +			bp->b_error = 0;
> > +			bp->b_ops = ops;
> > +			bp->b_ops->verify_read(bp);
> > +			bp->b_flags &= ~LIBXFS_B_UNCHECKED;
> 
> Should we always expect an unchecked buffer to be read with an ops
> vector before being written? Even if so, this might look cleaner if we
> didn't encode the possibility of running a read verifier on a dirty
> buffer. I presume that would always fail as the crc is updated in the
> write verifier.

It should fail, and that's a good thing because writing to an
unchecked buffer would indicate that we didn't validate it properly
in the first place. Hence I thought that doing it this way leaves
a canary that traps other problem usage with unchecked buffers.

Realistically, we shouldn't be writing unchecked buffers - prefetch
doesn't touch buffers, it just does IO, and so someone else has to
read the buffers before they can be dirtied. If it's read without an
ops structure then modified and read again with an ops structure,
we'll catch it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
