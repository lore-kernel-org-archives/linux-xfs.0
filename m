Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58LFoOg024950 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 16:15:51 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53BF247C903
	for <xfs@oss.sgi.com>; Thu, 29 Jul 2010 21:53:42 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	39cGioPnP3J38Wvq for <xfs@oss.sgi.com>;
	Thu, 29 Jul 2010 21:53:42 -0700 (PDT)
Date: Fri, 30 Jul 2010 14:53:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] dio: track and serialise unaligned direct IO
Message-ID: <20100730045331.GA2126@dastard>
References: <1280443516-14448-1-git-send-email-david@fromorbit.com>
	<20100730025324.GO25774@parisc-linux.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100730025324.GO25774@parisc-linux.org>
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
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org, sandeen@sandeen.net, xfs@oss.sgi.com

On Thu, Jul 29, 2010 at 08:53:24PM -0600, Matthew Wilcox wrote:
> On Fri, Jul 30, 2010 at 08:45:16AM +1000, Dave Chinner wrote:
> > If we get two unaligned direct IO's to the same filesystem block
> > that is marked as a new allocation (i.e. buffer_new), then both IOs will
> > zero the portion of the block they are not writing data to. As a
> > result, when the IOs complete there will be a portion of the block
> > that contains zeros from the last IO to complete rather than the
> > data that should be there.
> 
> Urgh.  Yuck.
> 
> > This is easily manifested by qemu using aio+dio with an unaligned
> > guest filesystem - every IO is unaligned and fileystem corruption is
> > encountered in the guest filesystem. xfstest 240 (from Eric Sandeen)
> > is also a simple reproducer.
> > 
> > To avoid this problem, track unaligned IO that triggers sub-block zeroing and
> > check new incoming unaligned IO that require sub-block zeroing against that
> > list. If we get an overlap where the start and end of unaligned IOs hit the
> > same filesystem block, then we need to block the incoming IOs until the IO that
> > is zeroing the block completes. The blocked IO can then continue without
> > needing to do any zeroing and hence won't overwrite valid data with zeros.
> 
> Urgh.  Yuck.

It's better than silent data corruption.

> Could we perhaps handle this by making an IO instantiate a page cache
> page for partial writes, and forcing that portion of the IO through the
> page cache?  The second IO would hit the same page and use the existing
> O_DIRECT vs page cache paths.

I don't want any direct IO for XFS to go through the page cache -
unaligned or not. using the page cache for the unaligned blocks
would also be much worse for performance that this method because it
turns unaligned direct IO into 3 IOs - the unaligned head block, the
aligned body and the unaligned tail block. It would also be a
performance hit you take on every single dio, whereas this way the
hit is only taken when an overlap is detected.

And besides, such decisions on whether to use buffered IO have to be
made high up in the filesystem when we are deciding how to lock the
inode for the dio - buffered IO requires exclusive locking, not the
shared locking we do for dio writes. That further reduces the
performance of unaligned direct IO even when there are no overlaps,
and it's a solution that every filesystem needs to implement
themselves in some way.

I've looked at a couple of different ways to fix this (e.g. passing
the unaligned state to get_blocks() to allow the filesystem to
serialise there) but they've all died a horrible death of dodgy
locking and hacky IO completion detection. not to mention
requiring a different solution in every filesystem.

This way may be a bit ugly, but it works, is isolated and seems to
me to be the least-worst way of solving the problem. It could be
made to scale better by making the tracking per-inode, but I don't
think that growing the struct inode for this corner case is a good
tradeoff, either...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
