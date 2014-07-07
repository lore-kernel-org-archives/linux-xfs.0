Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3BD0F29DF8
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2014 19:09:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C723EAC002
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2014 17:09:36 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3XO8VCYgDyc1is0e for <xfs@oss.sgi.com>;
	Sun, 06 Jul 2014 17:09:31 -0700 (PDT)
Date: Mon, 7 Jul 2014 10:09:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] libxfs: reused invalidated buffers leak state and data
Message-ID: <20140707000929.GR9508@dastard>
References: <1404453435-1915-1-git-send-email-david@fromorbit.com>
	<1404453435-1915-5-git-send-email-david@fromorbit.com>
	<20140704141509.GB29520@infradead.org>
	<20140704222210.GM9508@dastard>
	<20140705094807.GB18130@infradead.org>
	<20140706235444.GP9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140706235444.GP9508@dastard>
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

On Mon, Jul 07, 2014 at 09:54:44AM +1000, Dave Chinner wrote:
> On Sat, Jul 05, 2014 at 02:48:07AM -0700, Christoph Hellwig wrote:
> > On Sat, Jul 05, 2014 at 08:22:10AM +1000, Dave Chinner wrote:
> > > I'm open to other ways of fixing this, but right now we've got to
> > > fix xfs_repair because it's currently breaking filesystems worse
> > > than before xfs_repair was run...
> > 
> > Ok, so clearly mark this as difference from kernel code in a long
> > comment explaining the situation similar to wrote you above. 
> 
> Will do.

Ok, I added this to the top of the libxfs/rdwr.c file:

/*
 * Important design/architecture note:
 *
 * The userspace code that uses the buffer cache is much less constrained than
 * the kernel code. The userspace code is pretty nasty in places, especially
 * when it comes to buffer error handling.  Very little of the userspace code
 * outside libxfs clears bp->b_error - very little code even checks it - so the
 * libxfs code is tripping on stale errors left by the userspace code.
 *
 * We can't clear errors or zero buffer contents in libxfs_getbuf-* like we do
 * in the kernel, because those functions are used by the libxfs_readbuf_*
 * functions and hence need to leave the buffers unchanged on cache hits. This
 * is actually the only way to gather a write error from a libxfs_writebuf()
 * call - you need to get the buffer again so you can check bp->b_error field -
 * assuming that the buffer is still in the cache when you check, that is.
 *
 * This is very different to the kernel code which does not release buffers on a
 * write so we can wait on IO and check errors. The kernel buffer cache also
 * guarantees a buffer of a known initial state from xfs_buf_get() even on a
 * cache hit.
 *
 * IOWs, userspace is behaving quite differently to the kernel and as a result
 * it leaks errors from reads, invalidations and writes through
 * libxfs_getbuf/libxfs_readbuf.
 *
 * The result of this is that until the userspace code outside libxfs is cleaned
 * up, functions that release buffers from userspace control (i.e
 * libxfs_writebuf/libxfs_putbuf) need to zero bp->b_error to prevent
 * propagation of stale errors into future buffer operations.
 */

Is that sufficient for the moment?

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
