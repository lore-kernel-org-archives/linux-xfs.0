Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 82EE57F3F
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 00:51:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 635568F8039
	for <xfs@oss.sgi.com>; Tue, 16 Jul 2013 22:51:09 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Pumbu1El4qB5VmZB for <xfs@oss.sgi.com>;
	Tue, 16 Jul 2013 22:51:07 -0700 (PDT)
Date: Wed, 17 Jul 2013 15:51:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130717055103.GK11674@dastard>
References: <CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
	<20130716023847.GA31481@redhat.com>
	<CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
	<20130716060351.GE11674@dastard> <20130716193332.GB3572@sgi.com>
	<CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
	<20130716204335.GH11674@dastard>
	<CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
	<20130717040616.GI11674@dastard>
	<CA+55aFz5xw9Qi9Q6mwoCSud5eQh5u-QZ-xrY+TqgZPoKOgn6ew@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFz5xw9Qi9Q6mwoCSud5eQh5u-QZ-xrY+TqgZPoKOgn6ew@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Ben Myers <bpm@sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>, xfs@oss.sgi.com

On Tue, Jul 16, 2013 at 09:54:09PM -0700, Linus Torvalds wrote:
> On Tue, Jul 16, 2013 at 9:06 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Right, and that's one of the biggest problems page based IO has - we
> > can't serialise it against other IO and other page cache
> > manipulation functions like hole punching. What happens when a
> > splice read or mmap page fault races with a hole punch? You get
> > stale data being left in the page cache because we can't serialise
> > the page read with the page cache invalidation and underlying extent
> > removal.
> 
> But Dave, that's *good*.
> 
> You call it "stale data".
> 
> I call it "the data was valid at some point".

Yes, that's true.

But When i say "stale data" I mean that the data being returned
might not have originally belonged to the underlying file you are
reading.

> This is what "splice()" is fundamentally all about.
> 
> Think of it this way: even if you are 100% serialized during the
> "splice()" operation, what do you think happens afterwards?

Same as for read(2) - I don't care. Indeed, the locking is not to
protect what splice does "afterwards". It's for IO serialisation,
not page cache serialisation.

For example, splice read races with hole punch - after the page is
invalidated, but before the blocks are punched out. So we get a
new page, a mapping from the inode, get_blocks() returns valid disk
mapping, we start an IO. it gets blocked in the elevator. Maybe it's
been throttled because the process has used it's blkio quota.
Whatever - the IO gets stuck on the dispatch queue.

Meanwhile, the holepunch runs the transaction to free the disk
blocks, and then something else reallocates those blocks - maybe
even the filesystem for new metadata. That then gets dispatched to
disk. We now have two IOs pending for the same disk blocks....

What that means is that what the splice read returns is undefined.
It *might* be the original data that belonged to the file, in which
case we are good to go, but if the write wins the IO race then the
splice read could return someone else's data or even filesystem
metadata - that's what "stale data" means. Any way you look at it,
that's a bad thing....

> Seriously, think it through.

I have ;)

> That data is in a kernel buffer - the pipe. The fact that it was
> serialized at the time of the original splice() doesn't make _one_
> whit of a difference, because after the splice is over, the data still
> sits around in that pipe buffer, and you're no longer serializing it.
> Somebody else truncating the file or punching a hole in the file DOES
> NOT MATTER. It's too late.

Yes, I agree that once we have a page with valid data in it, we
don't need serialisation for splice. Again, I'll stress that he
serialisation is not for splice page cache manipulations but for
the IO that splice may issue to initialise the pages it them
manipulates....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
