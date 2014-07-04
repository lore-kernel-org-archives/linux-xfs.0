Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C9E07F47
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 17:22:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 692568F8049
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 15:22:16 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vBdTqH3xPWnG0ReQ for <xfs@oss.sgi.com>;
	Fri, 04 Jul 2014 15:22:14 -0700 (PDT)
Date: Sat, 5 Jul 2014 08:22:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] libxfs: reused invalidated buffers leak state and data
Message-ID: <20140704222210.GM9508@dastard>
References: <1404453435-1915-1-git-send-email-david@fromorbit.com>
	<1404453435-1915-5-git-send-email-david@fromorbit.com>
	<20140704141509.GB29520@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140704141509.GB29520@infradead.org>
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

On Fri, Jul 04, 2014 at 07:15:09AM -0700, Christoph Hellwig wrote:
> On Fri, Jul 04, 2014 at 03:57:13PM +1000, Dave Chinner wrote:
> > @@ -632,6 +632,12 @@ libxfs_putbuf(xfs_buf_t *bp)
> >  			pthread_mutex_unlock(&bp->b_lock);
> >  		}
> >  	}
> > +	/*
> > +	 * ensure that any errors on this use of the buffer don't carry
> > +	 * over to the next user.
> > +	 */
> > +	bp->b_error = 0;
> > +
> >  	cache_node_put(libxfs_bcache, (struct cache_node *)bp);
> 
> This seems a bit fishy to me.  For one I'm pretty sure it needs to be
> done before unlocking b_lock,

Fair enough.

> second it's different behavior from the
> kernel where we explicitly clear it in the caller for the rare case
> we want to reuse a buffer that had an error (xfs_buf_iodone_callbacks
> seems to be the only one).  Any reason to do this differently in
> userspace?

The userspace code that uses the buffer cache is much less
constrained than the kernel code. The userspace code is pretty nasty
in places, especially when it comes to buffer error handling.

We can't clear errors or zero buffer contents in libxfs_getbuf-*
like we do in the kernel, because those functions are used by the
libxfs_readbuf_* functions and hence need to leave the buffers
unchanged on cache hits. This is actually the only way to gather a
write error from a libxfs_writebuf() call - you need to
get the buffer again so you can check bp->b_error field - assuming
that the buffer is still in the cache when you check, that is.

This is very different to the kernel code which idoes not release
buffers on a write so we can wait on IO and check errors. The kernel
buffer cache also guarantees a buffer of a known initial state from
xfs_buf_get() even on a cache hit.

Hence the userspace buffer cache is behaving quite differently to
the kernel buffer cache and as a result it's leaking errors from
reads, invalidations and writes through
xfs_da_get_buf/libxfs_getbuf.  Current no userspace outside libxfs
code clears bp->b_error - very little code even checks it - so th
elibxfs code is tripping on stale errors left by the usrspace code.
libxfs_writebuf() already zeros bp->b_error to prevent propagation
of stale errors into future reads, so this patch is really just
closing the hole in the other buffer release path that the code
usually takes.

Doing a full audit and addition of error handling of all the
userspace code is a little beyond my resources right now. The only
thing I can really do quickly about the problem is clear the error
when we've finished with the buffer.

I'm open to other ways of fixing this, but right now we've got to
fix xfs_repair because it's currently breaking filesystems worse
than before xfs_repair was run...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
