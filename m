Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:24657 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726472AbeK3R5d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Nov 2018 12:57:33 -0500
Date: Fri, 30 Nov 2018 17:49:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Non-blocking socket stuck for multiple seconds on
 xfs_reclaim_inodes_ag()
Message-ID: <20181130064908.GX6311@dastard>
References: <CABWYdi1YZp+baxpON2R6mP09pjkUz5D-OE7Z2KmwVGycYTN-AA@mail.gmail.com>
 <20181129021800.GQ6311@dastard>
 <CABWYdi0Bd6sMAaTPkfHKupMGpw1QPSf_VohPF_Wg7Mm=W=j2bA@mail.gmail.com>
 <20181130021840.GV6311@dastard>
 <CABWYdi0nSJAV-RPdUSwGbRwqeoKo-83_X=ptuQwwH1CnPXCYmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABWYdi0nSJAV-RPdUSwGbRwqeoKo-83_X=ptuQwwH1CnPXCYmQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ivan Babrou <ivan@cloudflare.com>
Cc: linux-xfs@vger.kernel.org, Shawn Bohrer <sbohrer@cloudflare.com>

On Thu, Nov 29, 2018 at 07:31:44PM -0800, Ivan Babrou wrote:
> On Thu, Nov 29, 2018 at 6:18 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Thu, Nov 29, 2018 at 02:22:53PM -0800, Ivan Babrou wrote:
> > > On Wed, Nov 28, 2018 at 6:18 PM Dave Chinner <david@fromorbit.com> wrote:
> > > >
> > > > On Wed, Nov 28, 2018 at 04:36:25PM -0800, Ivan Babrou wrote:
> > > > > Hello,
> > > > >
> > > > > We're experiencing some interesting issues with memory reclaim, both
> > > > > kswapd and direct reclaim.
> > > > >
> > > > > A typical machine is 2 x NUMA with 128GB of RAM and 6 XFS filesystems.
> > > > > Page cache is around 95GB and dirty pages hover around 50MB, rarely
> > > > > jumping up to 1GB.
> > > >
> > > > What is your workload?
> > >
> > > My test setup is an empty machine with 256GB of RAM booted from
> > > network into memory with just systemd essentials running.
> >
> > What is your root filesystem?
> 
> It's whatever initramfs unpacks into, there is no storage involved:
> 
> rootfs / rootfs rw,size=131930052k,nr_inodes=32982513 0 0
> 
> > > I create XFS on a 10TB drive (via LUKS), mount the drive and write
> > > 300GiB of randomness:
> > >
> > > $ sudo mkfs.xfs /dev/mapper/luks-sda
> > > $ sudo mount /dev/mapper/luks-sda /mnt
> > > $ sudo dd if=/dev/urandom of=/mnt/300g.random bs=1M count=300K status=progress
> > >
> > > Then I reboot and just mount the drive again to run my test workload:
> > >
> > > $ dd if=/mnt/300g.random of=/dev/null bs=1M status=progress
> > >
> > > After running it once and populating page cache I restart it to collect traces.
> >
> > This isn't your production workload that is demonstrating problems -
> > it's your interpretation of the problem based on how you think
> > everything should work.
> 
> This is the simplest workload that exhibits the issue. My production
> workload is similar: serve most of the data from page cache,
> occasionally write some data on disk.

That's not a description of the workload that is generating delays
in the order of tens of seconds....

> To make it more real in terms of how I think things work, let's add a
> bit more fun with the following systemtap script:

Stop it already. I know exactly what can happen in that path and
you're not helping me at all by trying to tell me what you think the
problem is over and over again. I don't care what you think is the
problem - I want to know how to reproduce the symptoms you are
seeing.

I need to know what load your systems are being placed under when
they demonstrate the worst case latencies. I need to know about
about CPU load, memory pressure, concurrency, read rates, write
rates, the actual physical IO rates and patterns. It also helps to
know about the hardware, your storage setup and the type of physical
disks you are using.

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

[snip traces]

> The way I read this: kswapd got stuck behind one stalled io, that
> triggered later direct reclaim from dd, which also got stuck.

No, that's a stall waiting for the per-cpu free page magazines to
drain back into the free list. i.e. it's waiting on other CPUs to do
scheduled work that has absolutely nothing to do with kswapd and
the XFS shrinker waiting on IO to complete. Indeed:

/*
 * Spill all the per-cpu pages from all CPUs back into the buddy allocator.
 *
 * When zone parameter is non-NULL, spill just the single zone's pages.
 *
 * Note that this can be extremely slow as the draining happens in a workqueue.
 */
void drain_all_pages(struct zone *zone)
....

> 250GB of page cache to reclaim and yet one unlucky write made
> everything sad. Stack trace is somewhat different, but it illustrates
> the idea of one write blocking reclaim.

No, they aren't related at all. There are a lot of places where
memory reclaim can block, and very few of them have anything to do
with shrinkers and filesystems.

> > the latency problems myself. I do have some clue abou thow this is
> > all supposed to work, and I have abunch of workloads that are known
> > to trigger severe memory-reclaim based IO breakdowns if memory
> > reclaim doesn't balance and throttle appropriately.
> 
> I believe that you do have a clue and workloads. The problem is: those
> workloads are not mine.

Yes, but you won't tell me what your workload is.

> > > I'm only assuming things because documentation leaves room for
> > > interpretation. I would love to this worded in a way that's crystal
> > > clear and mentions possibility of IO.
> >
> > Send a patch. I wrote that years ago when all the people reviewing
> > the changes understood what "freeable" meant in the shrinker context.
> 
> Would you be happy with this patch?

No objections here. Send it to -fsdevel with the appropriate
sign-off.

> > > > above - this just means that when you have no easily reclaimable
> > > > page cache the system will OOM kill rather than wait for inodes to
> > > > be reclaimed. i.e. it looks good until everything suddenly goes
> > > > wrong and then everything dies a horrible death.
> > >
> > > We have hundreds of gigabytes of page cache, dirty pages are not
> > > allowed to go near that mark. There's a separate limit for dirty data.
> >
> > Well, yes, but we're not talking about dirty data here - I'm
> > talking about what happens when we turn off reclaim for a cache
> > that can grow without bound.  I can only say "this is a bad idea in
> > general because...." as I have to make the code work for lots of
> > different workloads.
> >
> > So while it might be a solution work for your specific workload -
> > which I know nothing about because you haven't described it to me -
> > it's not a solution we can use for the general case.
> 
> Facebook is still running with their patch that does async reclaim, so
> my workload is not that special.

Your workload is (apparently) *very different* to the FB workload.
Their workload was that filesystem traversal was causing severe
fluctuations in inode cache pressure - the huge numbers of inodes
that were being cycled in and out memory were causing problems when
kswapd occassionally blocked on a single inode out of millions. They
were chasing occasional long tail latencies on heavy loaded, highly
concurrent workloads, not delays that measured in multiples of tens
of seconds. i.e. their latency spikes were 50-100ms instead of
typical 5ms. That's very, very different to what you are reporting
and the worklaod you are implying is causing them.

And, really, I know exactly what the FB workload is because the FB
devs wrote a workload simulator to reproduce the problem offline. So
while I could reproduce the latency spikes they saw and could make
changes to get rid of them, it always came at the expense of
dramatic regressions on other memory pressure workloads I have.

IOWs, the change that FB made for their specific workload hid the
latency issue for their workload, but did not benefit any other
workloads. Maybe that change would also work for you, but it may not
and it may, in fact, make things worse. But I can't say, because I
don't know how to reproduce your problem so I can't test the FB
change against it.

Seriously: describe your workload in detail for me so I can write a
reproducer for it. Without that I cannot help you any further and I
am just wasting my time asking you to describe the workload over
and over again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
