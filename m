Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58112 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966099AbeBMXPF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Feb 2018 18:15:05 -0500
Date: Tue, 13 Feb 2018 15:14:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfs_buf_lock vs aio
Message-ID: <20180213231458.GE5217@magnolia>
References: <a0531d16-d872-548d-4821-273c072973e6@scylladb.com>
 <20180207233320.GB20367@dastard>
 <ed83833b-5024-40f2-b335-2dcab7fddf0e@scylladb.com>
 <20180208221153.GF20266@dastard>
 <30274e7a-4029-73b8-0d8b-cdfda450e3bc@scylladb.com>
 <20180209231015.GI20266@dastard>
 <697bf891-e7c4-4d60-e2ce-f1ba6935b38b@scylladb.com>
 <20180213051850.GE6778@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180213051850.GE6778@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Avi Kivity <avi@scylladb.com>, linux-xfs@vger.kernel.org

On Tue, Feb 13, 2018 at 04:18:51PM +1100, Dave Chinner wrote:
> On Mon, Feb 12, 2018 at 11:33:44AM +0200, Avi Kivity wrote:
> > On 02/10/2018 01:10 AM, Dave Chinner wrote:
> > >On Fri, Feb 09, 2018 at 02:11:58PM +0200, Avi Kivity wrote:
> > >>On 02/09/2018 12:11 AM, Dave Chinner wrote:
> > >>>On Thu, Feb 08, 2018 at 10:24:11AM +0200, Avi Kivity wrote:
> > >>>>On 02/08/2018 01:33 AM, Dave Chinner wrote:
> > >>>>>On Wed, Feb 07, 2018 at 07:20:17PM +0200, Avi Kivity wrote:
> > >>>>>>As usual, I'm having my lovely io_submit()s sleeping. This time some
> > >>>>>>detailed traces. 4.14.15.
> > >>>[....]
> > >>>
> > >>>>>>Forcing the log, so sleeping with ILOCK taken.
> > >>>>>Because it's trying to reallocate an extent that is pinned in the
> > >>>>>log and is marked stale. i.e. we are reallocating a recently freed
> > >>>>>metadata extent that hasn't been committed to disk yet. IOWs, it's
> > >>>>>the metadata form of the "log force to clear a busy extent so we can
> > >>>>>re-use it" condition....
> > >>>>>
> > >>>>>There's nothing you can do to reliably avoid this - it's a sign that
> > >>>>>you're running low on free space in an AG because it's recycling
> > >>>>>recently freed space faster than the CIL is being committed to disk.
> > >>>>>
> > >>>>>You could speed up background journal syncs to try to reduce the
> > >>>>>async checkpoint latency that allows busy extents to build up
> > >>>>>(/proc/sys/fs/xfs/xfssyncd_centisecs) but that also impacts on
> > >>>>>journal overhead and IO latency, etc.
> > >>>>Perhaps xfs should auto-tune this variable.
> > >>>That's not a fix. That's a nasty hack that attempts to hide the
> > >>>underlying problem of selecting AGs and/or free space that requires
> > >>>a log force to be used instead of finding other, un-encumbered
> > >>>freespace present in the filesystem.
> > >>Isn't the underlying problem that you have a foreground process
> > >>depending on the progress of a background process?
> > >At a very, very basic level.
> > >
> > >>i.e., no matter
> > >>how AG and free space selection improves, you can always find a
> > >>workload that consumes extents faster than they can be laundered?
> > >Sure, but that doesn't mean we have to fall back to a synchronous
> > >alogrithm to handle collisions. It's that synchronous behaviour that
> > >is the root cause of the long lock stalls you are seeing.
> > 
> > Well, having that algorithm be asynchronous will be wonderful. But I
> > imagine it will be a monstrous effort.
> 
> It's not clear yet whether we have to do any of this stuff to solve
> your problem.

The maintainer (me) would like to avoid fiddling with trylocks on the
metadata, especially when there's a significant amount of (unlocked)
activity between the trylock and the point where the actual lock is
needed.

If you need the [cma]time to be accurate and newly allocated buffers end
up stuck on busy extent cleanup when there's plenty of free space
available, then I think fixing the collision between the allocator and
the busy extents processing sounds like a reasonable solution.

> > >>I'm not saying that free extent selection can't or shouldn't be
> > >>improved, just that it can never completely fix the problem on its
> > >>own.
> > >Righto, if you say so.
> > >
> > >After all, what do I know about the subject at hand? I'm just the
> > >poor dumb guy
> > 
> > 
> > Just because you're an XFS expert, and even wrote the code at hand,
> > doesn't mean I have nothing to contribute. If I'm wrong, it's enough
> > to tell me that and why.
> 
> It takes time and effort to have to explain why someone's suggestion
> for fixing a bug will not work. It's tiring, unproductive work and I
> get no thanks for it at all. I'm just seen as the nasty guy who says

Thank you for helping me to say no to things. :)

> "no" to everything because I eventually run out of patience trying
> to explain everything in simple enough terms for non-XFS people to
> understand that they don't really understand XFS or what I'm talking
> about.
> 
> IOWs, sometimes the best way to contribute is to know when you're in
> way over you head and to step back and simply help the master
> crafters get on with weaving their magic.....

Not always easy, even if you /have/ been scribbling XFS magic for a while.

Anyway... is it getting a little hot in here?

(Yes, why is it 75F in February?)

> > >  who wrote the current busy extent list handling
> > >algorithm years ago.  Perhaps you'd like to read the commit message
> > >(below), because it explains these sycnhronous slow paths and why
> > >they exist. I'll quote the part relevant to the discussion here,
> > >though:
> > >
> > >	    Ideally we should not reallocate busy extents. That is a
> > >	    much more complex fix to the problem as it involves
> > >	    direct intervention in the allocation btree searches in
> > >	    many places. This is left to a future set of
> > >	    modifications.
> > 
> > Thanks, that commit was interesting.
> > 
> > So, this future set of modifications is to have the extent allocator
> > consult this rbtree and continue searching if locked?
> 
> See, this is exactly what I mean.
> 
> You're now trying to guess how we'd solve the busy extent blocking
> problem. i.e. you now appear to be assuming we have a plan to fix
> this problem and are going to do it immediately.  Nothing could be
> further from the truth - I said:
> 
> > >this is now important, and so we now need to revisit the issues we
> > >laid out some 8 years ago and work from there.
> 
> That does not mean "we're going to fix this now" - it means we need
> to look at the problem again and determine if it's the best solution
> to the problem being presented to us. There are other avenues we
> still need to explore.

Upstream XFS is a general-purpose solution, which means that the code we
add to it must be suitable for everyone -- that means it has to work for
most everyone and be understandable by everyone who reads the code.
I'd like to try to avoid adding weird hacks.

Solving whatever is the problem here requires someone to pin down the
problem, understand the code already built, design some test cases, and
then wire up all the new functionality.  After that, someone /else/ has
to reach the same knowledge levels to review the code.  It's way too
early to be jumping from conjectural solutions to software design.

In other words, more discussion needed:

> Indeed, does your application and/or users even care about
> [acm]times on your files being absolutely accurate and crash
> resilient? i.e. do you use fsync() or fdatasync() to guarantee the
> data is on stable storage?
> 
> [....]
> 
> > I still think reducing the amount of outstanding busy extents is
> > important.  Modern disks write multiple GB/s, and big-data
> > applications like to do large sequential writes and deletes,
> 
> Hah! "modern disks"
> 
> You need to recalibrate what "big data" and "high performance IO"
> means. This was what we were doing with XFS on linux back in 2006:
> 
> https://web.archive.org/web/20171010112452/http://oss.sgi.com/projects/xfs/papers/ols2006/ols-2006-paper.pdf
> 
> i.e. 10 years ago we were already well into the *tens of GB/s* on
> XFS filesystems for big-data applications with large sequential
> reads and writes. These "modern disks" are so slow! :)

Yeah, and XFS performance is crap on my wall of 3.5" floppy mdraid. :P

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
