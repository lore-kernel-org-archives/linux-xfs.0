Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9E0AlIa031335 for <xfs@oss.sgi.com>; Sat, 13 Oct 2012 19:10:47 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9AWFz9d2qW5fz094 for <xfs@oss.sgi.com>;
	Sat, 13 Oct 2012 17:12:21 -0700 (PDT)
Date: Sun, 14 Oct 2012 11:12:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 22/23] xfs: add pre-write metadata buffer verifier
	callbacks
Message-ID: <20121014001219.GR2739@dastard>
References: <1350020669-19504-1-git-send-email-david@fromorbit.com>
	<1350020669-19504-23-git-send-email-david@fromorbit.com>
	<20121013160212.GA24337@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121013160212.GA24337@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Oct 13, 2012 at 12:02:12PM -0400, Christoph Hellwig wrote:
> > +xfs_agfl_write_verify(
> > +	struct xfs_buf	*bp)
> > +{
> > +	xfs_agfl_verify(bp);
> > +}
> > +
> > +void
> > +xfs_agfl_read_verify(
> > +	struct xfs_buf	*bp)
> > +{
> > +	xfs_agfl_verify(bp);
> > +	bp->b_pre_io = xfs_agfl_write_verify;
> >  	bp->b_iodone = NULL;
> >  	xfs_buf_ioend(bp, 0);
> 
> I have to say I hate the way the API works for the buffer callbacks
> even more now that I see the write side.  I know you're a bit annoyed
> about churn from review requests, but I'd really prefer if this
> was redone.

No, I'm not annoyed about churn - I'm not entirely happy myself with
the b_io_done/b_pre_io split that I ended up with, but I needed
something that worked to make any further progress.  I certainly
didn't mean to come across as annoyed by suggestions that
modifications are needed.

It is, however, extremely time consuming to restructure a 50 patch
series that touches a few thousand lines of code from the first
patch (there's a bunch more on top of this set). Hence I'm not about
to do that unless there is good reason for doing it....

> Two ways to do this nicer come to mind:
> 
>  - Have one commone b_verify callback, which gets a bool for_write
>    argument to key of differences.  The xfs_buf_ioend call for reads
>    remains in the caller, b_iodone is not touched at all.  This will
>    remove the boilerplate code a lot in the current version.

I have considered that - it seemed kind of clumsy to have to pass a
bool into the function, because that meant having to determine at IO
completion whether it was a read or write by looking at the flags on
the buffer. Yes, that's a solvable problem but using the iodone
function makes things simple - if it's there just call it.

The other issue I had to handle is that buffers returned from
get_buf calls don't require a read verifier, as they are never read
from disk. And in some places, the actual use of the buffer may not
be known at the time the buffer is obtained (e.g. the extrablk in
the dir/attr code to handle splits), so passing a write verifier
callback to the get_buf call is not necessarily possible in all
cases.

>  - Expecting to have some more difference between the read and the
>    write side when we actually do the crcs from my work on the previous
>    iteration

I haven't seen a need for any specific differences at the CRC
calc/verify layers in any of the patch sets we iterated over in the
past - is there a particular concern that you have that I've missed?

>    of it it might make sense to have two callbacks, but I'd
>    again prefer to not overload b_iodone.  Maybe just pass a:
> 
> struct xfs_buf_ops {
> 	int (*verify_read)(struct xfs_buf *);
> 	int (*verify_write)(struct xfs_buf *);
> };
>
> to all the buffer read/write API calls, and let that deal with it.

This was the other option I considered (and would prefer), but again
had the issue of having to determine the write verifier at the time
of the get_buf call. The write verifiers are much harder to get
right, because we change the format of buffers all the time in the
directory code (e.g. leaf -> block, node -> leaf, etc) and that
means write verifiers have to be changed along with the magic number
of the buffer.

However, now that I have solved that problem, I can go back and
review how much of an issue it really is when it comes to using an
ops structure. It's probably less of a concern than I thought
initially, because now I actually know exactly what is needed in the
dir/attr code.

FWIW, one thing I'll look at doing is adding a patch on top of this
patch set to convert it to an ops structure, rather than rewriting
the patch set from the ground up. It will be much faster to do that
than rewrite the 20-odd patches in this series again....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
