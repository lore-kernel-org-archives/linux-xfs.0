Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:3939 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725766AbeJJHsU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 03:48:20 -0400
Date: Wed, 10 Oct 2018 11:28:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs.xfs: don't go into multidisk mode if there is only
 one stripe
Message-ID: <20181010002846.GG6311@dastard>
References: <20181004175839.18736-1-idryomov@gmail.com>
 <24d229f3-1a75-a65d-5ad3-c8565cb32e76@sandeen.net>
 <20181004222952.GV31060@dastard>
 <CAOi1vP_U-QpABgs+a9oYpYvLWs4D2qVmff=-JEikn7S_=eCAXQ@mail.gmail.com>
 <67627995-714c-5c38-a796-32b503de7d13@sandeen.net>
 <20181005232710.GH12041@dastard>
 <CAOi1vP-Z7xZk1YvWHYWQGOHfyWccFCkyn8je0HBvGhGuUrXmaQ@mail.gmail.com>
 <20181006232037.GB18095@dastard>
 <CAOi1vP_cZi9zDKYbgdq6T2uiPEwTjsP35Qdzi4DPcbvatrvMEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP_cZi9zDKYbgdq6T2uiPEwTjsP35Qdzi4DPcbvatrvMEQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>, Mark Nelson <mnelson@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Mike Snitzer <snitzer@redhat.com>

On Sun, Oct 07, 2018 at 03:54:57PM +0200, Ilya Dryomov wrote:
> On Sun, Oct 7, 2018 at 1:20 AM Dave Chinner <david@fromorbit.com> wrote:
> > On Sat, Oct 06, 2018 at 02:17:54PM +0200, Ilya Dryomov wrote:
> > > On Sat, Oct 6, 2018 at 1:27 AM Dave Chinner <david@fromorbit.com> wrote:
> > > > On Fri, Oct 05, 2018 at 08:51:59AM -0500, Eric Sandeen wrote:
> > The defaults are appropriate for the vast majority of installations
> > and use cases. The defaults are not ideal for everyone, but there's
> > years of thought, observation, problem solving and knowledge behind
> > them.
> >
> > If you don't like the defaults, then override them on the command
> > line, post your benchmarked improvements and make the argument why
> > this particular workload and tuning is better to everyone.
> 
> We were doing some tests with XFS on top of rbd, with multiple rbd
> devices on the same client machine (pretty beefy in terms of number of
> cores and RAM).  We ran the smallfile benchmark and found that with
> just a dozen devices mkfs.xfs with -d agcount=4 improved per device
> throughput by over 2x, with no degradation but rather a small bump on
> a single device.  Mark (CCed) can share the details.

So you're hosting multiple filesystems on the same spindles, then
running an IO intensive write workload that distributes the IO
across the entire filesystem on each filesystem and te result is you
see a massive amount of "random" write IO at the back end.

That's not really a general workload - that's driving a complex
setup to the point of degradation via targetted stress. How many
production workloads do you see that run concurrent write IO to 32
AGs at once across multiple devices and sustain them for long enough
that back end seek load is the perofrmance limitation?

i.e. what you are effectively testing is how many concurrent IO
streams the back end can support before performance is compromised.
Reducing the number of AGs per filesystem reduces the number of
streams from a fixed number of filesystems. I'm sure if you bump the
number of devices up by a factor of 8 (you reduced AG count by that
factor) you'd end up with the same performance degradation because
you have an identical number of concurrent write streams...

But the real question is this: how many of the filesystems in a
multi-tenant hosting situation like this actually sustain full write
stream concurrency for any extended period of time? I'd expect that
it's a very low percentage (needs writes sustained modifications to
at least 32 different directories to trigger these write patterns),
and those that do only do so in relatively short bursts. IOWs, 32
AGs can make sense from a storage stack longevity and aging
perspective, whilst the potential negative performance impact of
allowing greating concurrency can be largely ignored because no
hosted workload ever uses that /potential/.

IME, multi-tenented hosting requires much more careful configuration
than tuning for a highly stressful IO workload.  It requires knowing
what the typical workloads are and what their IO patterns look like
for the hosting that is being done....

> > > > Changing the existing behaviour doesn't make much sense to me. :)
> > >
> > > The existing behaviour is to create 4 AGs on both spinning rust and
> > > e.g. Intel DC P3700.
> >
> > That's a really bad example.  The p3700 has internal RAID with a
> > 128k page size that it doesn't expose to iomin/ioopt. It has
> > *really* bad IO throughput for sub-128k sized or aligned IO (think
> > 100x slower, not just a little). It's a device that absolutely
> > should be exposing preferred alignment characteristics to the
> > filesystem...
> 
> That was deliberate, as an example of a device that is generally
> considered to be pretty good -- even though the internal stripe size is
> public information, it's not passed through the stack.

*cough*

The p3700 is considered to be a device to avoid around here. Not
only is performance completely non-deterministic (i.e. garbage) when
the IO is not 128k aligned/sized, it was full of firmware bugs, too.
e.g. it had data corruption bugs w/ sub-4k IOs and discard
operations could hang the device and/or corrupt data.  Yeah, yet
more hardware bugs that were initially blamed on XFS....

> > > If I then put dm-thinp on top of that spinner,
> > > it's suddenly deemed worthy of 32 AGs.  The issue here is that unlike
> > > other filesystems, XFS is inherently parallel and perfectly capable of
> > > subjecting it to 32 concurrent write streams.  This is pretty silly.
> >
> > COW algorithms linearise and serialise concurrent write streams -
> > that's exactly what they are designed to do and why they perform so
> > well on random write workloads.  Optimising the filesystem layout
> > and characteristics to take advantage of COW algorithms in the
> > storage laye is not "pretty silly" - it's the smart thing to do
> > because the dm-thinp COW algorithms are only as good as the garbage
> > they are fed.
> 
> Right, that's pretty much what I expected to hear.  But I picked on
> dm-thinp because Mike has attempted to make mkfs.xfs go with the lower
> agcount for dm-thinp in fdfb4c8c1a9f ("dm thin: set minimum_io_size to
> pool's data block size").

But the commit didn't do that. That whole discussion was about
dm-thinp having an invalid iomin/ioopt configuration (which was
iomin != 0, ioopt == 0), not about the number of AG the filesystem
ended up with. Maybe the original bug raised by a user was about
mkfs differences between normal and thin LVs, but that wasn't the
issue that needed fixing.

> Both the commit message and his reply in
> this thread indicate that he wasn't just following your suggestion to
> set both iomin and ioopt to the same value, but actually intended it to
> defeat the agcount heuristic.  Mike, are there different expectations
> here?

If dm-thinp is trying to defeat a filesystem's mkfs layout by
screwing around with iomin/ioopt configuration, then that is a
layering violation at architectural, design and implementation
levels. This is not a game that block devices should be playing -
they provide information about their preferred IO sizes, and the
filesystem decides what to do from there.

If you want the filesystem to change behaviour, then you change the
filesystem code or use non-default filesystem options.  Every
filesystem has their own take on how to optimise for different block
device configurations, and if the block device is trying to game one
of the filesystems, then it's going to have unintended adverse
impact on what other filesystems do. Block devices must be
filesystem agnostic, because they don't know what data they are
going to contain.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
