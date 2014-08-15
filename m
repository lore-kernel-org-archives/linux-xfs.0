Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD1A029DF9
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 18:37:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 894B18F8084
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 16:37:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	S1RYVlhA3dtXNx7O for <xfs@oss.sgi.com>;
	Fri, 15 Aug 2014 16:37:57 -0700 (PDT)
Date: Sat, 16 Aug 2014 09:37:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/9] xfs: introduce xfs_buf_submit[_wait]
Message-ID: <20140815233743.GX26465@dastard>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-9-git-send-email-david@fromorbit.com>
	<20140815131020.GB27856@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140815131020.GB27856@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Aug 15, 2014 at 06:10:20AM -0700, Christoph Hellwig wrote:
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 2f1e30d..c53cc03 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -1157,12 +1157,7 @@ xfs_zero_remaining_bytes(
> 
> xfs_zero_remaining_bytes really should be switched to
> xfs_buf_read_uncached + xfs_bwrite instead of all this mess just to
> micro-optimize a few memory allocation away that don't even happen for
> the common case of blocksize == PAGE_SIZE.  I'm not even sure we
> should be using the buffer cache at all for something inside a regular
> file, but that's a discussion for another time.

xfs_zero_remaining_bytes is uses an uncached buffer, so we're not
using the buffer cache at all for the blocks being zeroed. That is
why it does the flag twiddling dance it does. However, consolidation
all the different block zeroing functions we have is an exercise for
a different day....

> 
> >  void
> > +xfs_buf_submit(
> > +	struct xfs_buf	*bp)
> >  {
> >  	trace_xfs_buf_iorequest(bp, _RET_IP_);
> 
> I suspect these two should have properly name and separate trace
> points now?

Yes. Just haven't got to it.

> It also seems like a lot of the guts of the two functions are
> still the same, so factoring that into a __xfs_buf_submit helper
> would be useful.

Possibly, if we can ensure that the helper it never called directly
by any other code. Then we end up back in the mess we are currently
in.

> > +	 * If _xfs_buf_ioapply failed, 
> > +	 * we can get back here with only the IO
> >  	 * reference we took above.  _xfs_buf_ioend will drop it to zero, so
> >  	 * we'd better run completion processing synchronously so that the we
> > +	 * don't return to the caller with completion still pending.
> > +	 * this allows the caller to check b_error safely without
> > +	 * waiting
> >  	 */
> >  	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
> >  		if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
> 
> I don't think the !ASYNC case can happen here, can it?

Right, I forget to clean that part up when I was splitting up the
functions.

> 
> > +		if (!wait)
> >  			list_del_init(&bp->b_list);
> > +		else
> > +			xfs_buf_hold(bp);
> 
> Maybe switch this around to avoid the negated condition in the if else?
> 
> Also might this be worth a change of it's own?

Yeah, that's probably a good idea - the algorithm change is not
directly related to the interface change.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
