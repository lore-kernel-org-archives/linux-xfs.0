Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:39719 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726549AbeK3N0X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Nov 2018 08:26:23 -0500
Date: Fri, 30 Nov 2018 13:18:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Non-blocking socket stuck for multiple seconds on
 xfs_reclaim_inodes_ag()
Message-ID: <20181130021840.GV6311@dastard>
References: <CABWYdi1YZp+baxpON2R6mP09pjkUz5D-OE7Z2KmwVGycYTN-AA@mail.gmail.com>
 <20181129021800.GQ6311@dastard>
 <CABWYdi0Bd6sMAaTPkfHKupMGpw1QPSf_VohPF_Wg7Mm=W=j2bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABWYdi0Bd6sMAaTPkfHKupMGpw1QPSf_VohPF_Wg7Mm=W=j2bA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ivan Babrou <ivan@cloudflare.com>
Cc: linux-xfs@vger.kernel.org, Shawn Bohrer <sbohrer@cloudflare.com>

On Thu, Nov 29, 2018 at 02:22:53PM -0800, Ivan Babrou wrote:
> On Wed, Nov 28, 2018 at 6:18 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Wed, Nov 28, 2018 at 04:36:25PM -0800, Ivan Babrou wrote:
> > > Hello,
> > >
> > > We're experiencing some interesting issues with memory reclaim, both
> > > kswapd and direct reclaim.
> > >
> > > A typical machine is 2 x NUMA with 128GB of RAM and 6 XFS filesystems.
> > > Page cache is around 95GB and dirty pages hover around 50MB, rarely
> > > jumping up to 1GB.
> >
> > What is your workload?
> 
> My test setup is an empty machine with 256GB of RAM booted from
> network into memory with just systemd essentials running.

What is your root filesystem?

> I create XFS on a 10TB drive (via LUKS), mount the drive and write
> 300GiB of randomness:
> 
> $ sudo mkfs.xfs /dev/mapper/luks-sda
> $ sudo mount /dev/mapper/luks-sda /mnt
> $ sudo dd if=/dev/urandom of=/mnt/300g.random bs=1M count=300K status=progress
> 
> Then I reboot and just mount the drive again to run my test workload:
> 
> $ dd if=/mnt/300g.random of=/dev/null bs=1M status=progress
> 
> After running it once and populating page cache I restart it to collect traces.

This isn't your production workload that is demonstrating problems -
it's your interpretation of the problem based on how you think
everything should work.

I need to know what the workload is so I can reproduce and observe a
the latency problems myself. I do have some clue abou thow this is
all supposed to work, and I have abunch of workloads that are known
to trigger severe memory-reclaim based IO breakdowns if memory
reclaim doesn't balance and throttle appropriately.

> Here's xfs_info:
> 
> $ sudo xfs_info /mnt
> meta-data=/dev/mapper/luks-sda   isize=512    agcount=10, agsize=268435455 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1 spinodes=0 rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=2441608704, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal               bsize=4096   blocks=521728, version=2

You've got a maximally sized log (2GB), so there's basically no bound on
dirty metadata in the filesystem.

> $ sudo cat /proc/slabinfo
....
> slabinfo - version: 2.1
> # name            <active_objs> <num_objs> <objsize> <objperslab>
> xfs_ili              144    144    168   48    2 : tunables    0    0
> xfs_inode            170    170    960   34    8 : tunables    0    0
> xfs_efd_item           0      0    416   39    4 : tunables    0    0
> xfs_buf_item         132    132    248   33    2 : tunables    0    0
> xfs_da_state           0      0    480   34    4 : tunables    0    0
> xfs_btree_cur        420    420    232   35    2 : tunables    0    0
> xfs_log_ticket       308    308    184   44    2 : tunables    0    0

That doesn't add up to a single XFS filesystem with 2 inodes in it.
where are the other 168 cached XFS inodes coming from? And I note
that 144 of them are currently or have been previously dirtied, too.

> The following can easily happen (correct me if it can't for some reason):
> 
> 1. kswapd gets stuck because of slow storage and memory is not getting reclaimed
> 2. memory allocation doesn't have any free pages and kicks in direct reclaim
> 3. direct reclaim is stuck behind kswapd
> 
> I'm not sure why you say direct reclaim happens first, allocstall is zero.

Because I thought we were talking about your production workload
that you pasted stack traces from showing direct reclaim blocking.
When you have a highly concurrent workload which has tens to
hundreds of processes all producing memory pressure, dirtying files
and page cache, etc, direct reclaim is almost always occurring.

i.e. your artificial test workload doesn't tell me anything about
the problems you are seeing on your production systems....

> > > My gut feeling is that
> > > they should not do that, because there's already writeback mechanism
> > > with own tunables for limits to take care of that. If a system runs
> > > out of memory reclaimable without IO and dirty pages are under limit,
> > > it's totally fair to OOM somebody.
> > >
> > > It's totally possible that I'm wrong about this feeling, but either
> > > way I think docs need an update on this matter:
> > >
> > > * https://elixir.bootlin.com/linux/v4.14.55/source/Documentation/filesystems/vfs.txt
> > >
> > >   nr_cached_objects: called by the sb cache shrinking function for the
> > >   filesystem to return the number of freeable cached objects it contains.
> >
> > You are assuming that "freeable" means "instantly freeable object",
> > not "unreferenced object that can be freed in the near future". We
> > use the latter definition in the shrinkers, not the former.
> 
> I'm only assuming things because documentation leaves room for
> interpretation. I would love to this worded in a way that's crystal
> clear and mentions possibility of IO.

Send a patch. I wrote that years ago when all the people reviewing
the changes understood what "freeable" meant in the shrinker context.

> > > My second question is conditional on the first one: if filesystems are
> > > supposed to flush dirty data in response to shrinkers, then how can I
> > > stop this, given my knowledge about combination of lots of available
> > > page cache and terrible disks?
> >
> > Filesystems have more caches that just the page cache.
> >
> > > I've tried two things to address this problem ad-hoc.
> > >
> > > 1. Run the following systemtap script to trick shrinkers into thinking
> > > that XFS has nothing to free:
> > >
> > > probe kernel.function("xfs_fs_nr_cached_objects").return {
> > >   $return = 0
> > > }
> > >
> > > That did the job and shrink_node latency dropped considerably, while
> > > calls to xfs_fs_free_cached_objects disappeared.
> >
> > Which effectively turned off direct reclaim for XFS inodes. See
> > above - this just means that when you have no easily reclaimable
> > page cache the system will OOM kill rather than wait for inodes to
> > be reclaimed. i.e. it looks good until everything suddenly goes
> > wrong and then everything dies a horrible death.
> 
> We have hundreds of gigabytes of page cache, dirty pages are not
> allowed to go near that mark. There's a separate limit for dirty data.

Well, yes, but we're not talking about dirty data here - I'm
talking about what happens when we turn off reclaim for a cache
that can grow without bound.  I can only say "this is a bad idea in
general because...." as I have to make the code work for lots of
different workloads.

So while it might be a solution work for your specific workload -
which I know nothing about because you haven't described it to me -
it's not a solution we can use for the general case.

> What I want to have is a way to tell the kernel to not try to flush
> data to disk in response to reclaim, because that's choosing a very
> real horrible life over imaginary horrible death.  I can't possibly
> create enough dirty inodes to cause the horrible death you describe.

Sure you can. Just keep filling memory with dirty inodes until the
log runs out of space. With disks that are as slow as you say, the
system will take hours to recover log space and return to decent
steady state performance, if it ever manages to catch up at all.

And this deomnstrates the fact that there can be many causes of the
symptoms you are describing.  But without a description of the
production workload that is demonstrating problems, I cannot
reproduce it, do any root cause analysis, or even validate that your
analysis is correct.

So, please, rather than tell me what you think the problem is and
how it should be fixed, frist describe the workload that is causing
problems in enough detail that I can reproduce it myself.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
