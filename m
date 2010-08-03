Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o73MuuDO260360 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 17:56:56 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84B70491AB0
	for <xfs@oss.sgi.com>; Tue,  3 Aug 2010 15:57:14 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	Igv7edpWS3wNFw5c for <xfs@oss.sgi.com>;
	Tue, 03 Aug 2010 15:57:14 -0700 (PDT)
Date: Wed, 4 Aug 2010 08:56:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] dio: track and serialise unaligned direct IO
Message-ID: <20100803225658.GB26402@dastard>
References: <1280443516-14448-1-git-send-email-david@fromorbit.com>
	<20100730025324.GO25774@parisc-linux.org>
	<20100730045331.GA2126@dastard>
	<1280856865.2436.31.camel@mingming-laptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280856865.2436.31.camel@mingming-laptop>
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
To: Mingming Cao <cmm@us.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, sandeen@sandeen.net, Matthew Wilcox <matthew@wil.cx>

On Tue, Aug 03, 2010 at 10:34:25AM -0700, Mingming Cao wrote:
> On Fri, 2010-07-30 at 14:53 +1000, Dave Chinner wrote:
> > On Thu, Jul 29, 2010 at 08:53:24PM -0600, Matthew Wilcox wrote:
> > > On Fri, Jul 30, 2010 at 08:45:16AM +1000, Dave Chinner wrote:
> > > > If we get two unaligned direct IO's to the same filesystem block
> > > > that is marked as a new allocation (i.e. buffer_new), then both IOs will
> > > > zero the portion of the block they are not writing data to. As a
> > > > result, when the IOs complete there will be a portion of the block
> > > > that contains zeros from the last IO to complete rather than the
> > > > data that should be there.
....
> > I don't want any direct IO for XFS to go through the page cache -
> > unaligned or not. using the page cache for the unaligned blocks
> > would also be much worse for performance that this method because it
> > turns unaligned direct IO into 3 IOs - the unaligned head block, the
> > aligned body and the unaligned tail block. It would also be a
> > performance hit you take on every single dio, whereas this way the
> > hit is only taken when an overlap is detected.
> 
> Does this problem also possible for DIO and non AIO case? (Ext4 case
> this only happy with AIO+DIO+unaligned).  If not, could we simply force
> unaligned AIO+DIO to be synchronous? Still direct IO...

There is nothing specific to AIO about this bug. XFS (at least)
allows concurrent DIO writes to the same inode regardless of whether
they are dispatched via AIO or multiple separate threads and so the
race condition exists outside just the AIO context...

> > And besides, such decisions on whether to use buffered IO have to be
> > made high up in the filesystem when we are deciding how to lock the
> > inode for the dio - buffered IO requires exclusive locking, not the
> > shared locking we do for dio writes. That further reduces the
> > performance of unaligned direct IO even when there are no overlaps,
> > and it's a solution that every filesystem needs to implement
> > themselves in some way.
> > 
> > I've looked at a couple of different ways to fix this (e.g. passing
> > the unaligned state to get_blocks() to allow the filesystem to
> > serialise there) but they've all died a horrible death of dodgy
> > locking and hacky IO completion detection. not to mention
> > requiring a different solution in every filesystem.
> 
> I also have been thinking other ways to fix this, initial thoughts about
> this but concerned about the scalability. 
> 
> I was looking at ways to use buffer head state to indicate any unaligned
> AIO DIO write to buffer_new buffers(do_direct_IO set the state), then
> for any futhur unaligned IO need to wait for the AIO+DIO complete on
> that buffer.

That's effectively what my fix does, except it does not overload
bufferheads to do it.

> but the buffer head passed from do_direct_IO to
> get_blocks() is a dummy buffer, have to get the buffer head from
> device...

Which, IMO, seems like a dangerous layering violation - it's mixing
device associated bufferheads with filesystem IO (i.e. from
different address spaces) and, as such, the two are never guaranteed
to be coherent.  To make matters more complex, XFS can have at least two
block devices (data and real-time) that direct IO is targeted at, so
doing something that is block device specific seems much more
complex than just tracking the IO in a separate list...

> this would only impact to all IOs that are really conflict with
> pending AIO DIOs... it should work for ext4 case...would this something
> usable for XFS? I have got the approach started last week but not very
> far.

It might, but I don't think it's a viable approach.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
