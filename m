Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36476 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751428AbeAYNIc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Jan 2018 08:08:32 -0500
Date: Thu, 25 Jan 2018 08:08:31 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_extent_busy_flush vs. aio
Message-ID: <20180125130830.GD43198@bfoster.bfoster>
References: <dde543cc-6641-c5ee-3385-520ef4ca821e@scylladb.com>
 <20180123152852.GA32478@bfoster.bfoster>
 <509e33df-4f76-2937-0425-98c26b3a1207@scylladb.com>
 <20180123161120.GC32478@bfoster.bfoster>
 <5f67219e-e48b-a954-69d4-318268645377@scylladb.com>
 <20180123164718.GE32478@bfoster.bfoster>
 <e1229a02-33ea-e5d5-d66f-36fa553a3393@scylladb.com>
 <20180123173902.GF32478@bfoster.bfoster>
 <f4751375-0710-cec8-ac6d-1f9546bba1ce@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f4751375-0710-cec8-ac6d-1f9546bba1ce@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 25, 2018 at 10:50:40AM +0200, Avi Kivity wrote:
> On 01/23/2018 07:39 PM, Brian Foster wrote:
> > On Tue, Jan 23, 2018 at 07:00:31PM +0200, Avi Kivity wrote:
> > > 
> > > On 01/23/2018 06:47 PM, Brian Foster wrote:
> > > > On Tue, Jan 23, 2018 at 06:22:07PM +0200, Avi Kivity wrote:
> > > > > On 01/23/2018 06:11 PM, Brian Foster wrote:
> > > > > > On Tue, Jan 23, 2018 at 05:45:39PM +0200, Avi Kivity wrote:
> > > > > > > On 01/23/2018 05:28 PM, Brian Foster wrote:
> > > > > > > > On Tue, Jan 23, 2018 at 04:57:03PM +0200, Avi Kivity wrote:
> > > > > > > > > I'm seeing the equivalent[*] of xfs_extent_busy_flush() sleeping in my
> > > > > > > > > beautiful io_submit() calls.
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > Questions:
> > > > > > > > > 
> > > > > > > > >      - Is it correct that RWF_NOWAIT will not detect the condition that led to
> > > > > > > > > the log being forced?
> > > > > > > > > 
> > > > > > > > >      - If so, can it be fixed?
> > > > > > > > > 
> > > > > > > > >      - Can I do something to reduce the odds of this occurring? larger logs,
> > > > > > > > > more logs, flush more often, resurrect extinct species and sacrifice them to
> > > > > > > > > the xfs gods?
> > > > > > > > > 
> > > > > > > > >      - Can an xfs developer do something? For example, make it RWF_NOWAIT
> > > > > > > > > friendly (if the answer to the first question was "correct")
> > > > > > > > > 
> > > > > > > > So RWF_NOWAIT eventually works its way to IOMAP_NOWAIT, which looks like
> > > > > > > > it skips any write call that would require allocation in
> > > > > > > > xfs_file_iomap_begin(). The busy flush should only happen in the block
> > > > > > > > allocation path, so something is missing here. Do you have a backtrace
> > > > > > > > for the log force you're seeing?
> > > > > > > > 
> > > > > > > > 
> > > > > > > Here's a trace. It's from a kernel that lacks RWF_NOWAIT.
> > > > > > > 
> > > > > > Oh, so the case below is roughly how I would have expected to hit the
> > > > > > flush/wait without RWF_NOWAIT. The latter flag should prevent this, to
> > > > > > answer your first question.
> > > > > Thanks, that's very encouraging. We are exploring recommending upstream-ish
> > > > > kernels to users and customers, given their relative stability these days
> > > > > and aio-related improvements (not to mention the shame of having to admit to
> > > > > running an old kernel when reporting a problem to an upstream list).
> > > > > 
> > > > > > For the follow up question, I think this should only occur when the fs
> > > > > > is fairly low on free space. Is that the case here?
> > > > > No:
> > > > > 
> > > > > /dev/md0        3.0T  1.2T  1.8T  40% /var/lib/scylla
> > > > > 
> > > > > 
> > > > > > I'm not sure there's
> > > > > > a specific metric, fwiw, but it's just a matter of attempting an (user
> > > > > > data) allocation that only finds busy extents in the free space btrees
> > > > > > and thus has to the force the log to satisfy the allocation.
> > > > > What does "busy" mean here? recently freed so we want to force the log to
> > > > > make sure the extent isn't doubly-allocated? (wild guess)
> > > > > 
> > > > Recently freed and the transaction that freed the blocks has not yet
> > > > been persisted to the on-disk log. A subsequent attempt to allocate
> > > > those blocks for user data waits for the transaction to commit to disk
> > > > to ensure that the block is not written before the filesystem has
> > > > persisted the fact that it has been freed. Otherwise, my understanding
> > > > is that if the blocks are written to and the filesystem crashes before
> > > > the previous free was persisted, we'd have allowed an overwrite of a
> > > > still-used metadata block.
> > > Understood, thanks.
> > > 
> > > > > >     I suppose
> > > > > > running with more free space available would avoid this. I think running
> > > > > > with less in-core log space could indirectly reduce extent busy time,
> > > > > > but that may also have other performance ramifications and so is
> > > > > > probably not a great idea.
> > > > > At 60%, I hope low free space  is not a problem.
> > > > > 
> > > > Yeah, that seems strange. I wouldn't expect busy extents to be a problem
> > > > with that much free space.
> > > The workload creates new files, appends to them, lets them stew for a while,
> > > then deletes them. Maybe something is preventing xfs from seeing non-busy
> > > extents?
> > > 
> > Yeah, could be.. perhaps the issue is that despite the large amount of
> > total free space, the free space is too fragmented to satisfy a
> > particular allocation request..?
> 
>    from      to extents  blocks    pct
>       1       1    2702    2702   0.00
>       2       3     690    1547   0.00
>       4       7     115     568   0.00
>       8      15      60     634   0.00
>      16      31      63    1457   0.00
>      32      63     102    4751   0.00
>      64     127    7940  895365   0.19
>     128     255   49680 12422100   2.67
>     256     511    1025  417078   0.09
>     512    1023    4170 3660771   0.79
>    1024    2047    2168 3503054   0.75
>    2048    4095    2567 7729442   1.66
>    4096    8191    8688 59394413  12.76
>    8192   16383     310 3100186   0.67
>   16384   32767     112 2339935   0.50
>   32768   65535      35 1381122   0.30
>   65536  131071       8  651391   0.14
>  131072  262143       2  344196   0.07
>  524288 1048575       4 2909925   0.62
> 1048576 2097151       3 3550680   0.76
> 4194304 8388607      10 82497658  17.72
> 8388608 16777215      10 158022653  33.94
> 16777216 24567552       5 122778062  26.37
> total free extents 80469
> total free blocks 465609690
> average free extent size 5786.2
> 
> Looks like plenty of free large extents, with most of the free space
> completely, unfragmented.
> 

Indeed..

> Lots of 16MB-32MB extents, too. 32MB is our allocation hint size, could have
> something to do with it.
> 

Most likely. Based on this, it's hard to say for certain why you'd be
running into allocation latency caused by busy extents. Does this
filesystem use the '-o discard' mount option by any chance?

I suppose it's possible that this was some kind of transient state, or
perhaps only a small set of AGs are affected, etc. It's also possible
this may have been improved in more recent kernels by Christoph's rework
of some of that code. In any event, this would probably require a bit
more runtime analysis to figure out where/why allocations are getting
stalled as such. I'd probably start by looking at the xfs_extent_busy_*
tracepoints (also note that if there's potentially something to be
improved on here, it's more useful to do so against current upstream).

Or you could just move to something that supports RWF_NOWAIT.. ;)

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
