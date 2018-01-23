Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53964 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751436AbeAWRjF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Jan 2018 12:39:05 -0500
Date: Tue, 23 Jan 2018 12:39:03 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_extent_busy_flush vs. aio
Message-ID: <20180123173902.GF32478@bfoster.bfoster>
References: <dde543cc-6641-c5ee-3385-520ef4ca821e@scylladb.com>
 <20180123152852.GA32478@bfoster.bfoster>
 <509e33df-4f76-2937-0425-98c26b3a1207@scylladb.com>
 <20180123161120.GC32478@bfoster.bfoster>
 <5f67219e-e48b-a954-69d4-318268645377@scylladb.com>
 <20180123164718.GE32478@bfoster.bfoster>
 <e1229a02-33ea-e5d5-d66f-36fa553a3393@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e1229a02-33ea-e5d5-d66f-36fa553a3393@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 23, 2018 at 07:00:31PM +0200, Avi Kivity wrote:
> 
> 
> On 01/23/2018 06:47 PM, Brian Foster wrote:
> > On Tue, Jan 23, 2018 at 06:22:07PM +0200, Avi Kivity wrote:
> > > 
> > > On 01/23/2018 06:11 PM, Brian Foster wrote:
> > > > On Tue, Jan 23, 2018 at 05:45:39PM +0200, Avi Kivity wrote:
> > > > > On 01/23/2018 05:28 PM, Brian Foster wrote:
> > > > > > On Tue, Jan 23, 2018 at 04:57:03PM +0200, Avi Kivity wrote:
> > > > > > > I'm seeing the equivalent[*] of xfs_extent_busy_flush() sleeping in my
> > > > > > > beautiful io_submit() calls.
> > > > > > > 
> > > > > > > 
> > > > > > > Questions:
> > > > > > > 
> > > > > > >     - Is it correct that RWF_NOWAIT will not detect the condition that led to
> > > > > > > the log being forced?
> > > > > > > 
> > > > > > >     - If so, can it be fixed?
> > > > > > > 
> > > > > > >     - Can I do something to reduce the odds of this occurring? larger logs,
> > > > > > > more logs, flush more often, resurrect extinct species and sacrifice them to
> > > > > > > the xfs gods?
> > > > > > > 
> > > > > > >     - Can an xfs developer do something? For example, make it RWF_NOWAIT
> > > > > > > friendly (if the answer to the first question was "correct")
> > > > > > > 
> > > > > > So RWF_NOWAIT eventually works its way to IOMAP_NOWAIT, which looks like
> > > > > > it skips any write call that would require allocation in
> > > > > > xfs_file_iomap_begin(). The busy flush should only happen in the block
> > > > > > allocation path, so something is missing here. Do you have a backtrace
> > > > > > for the log force you're seeing?
> > > > > > 
> > > > > > 
> > > > > Here's a trace. It's from a kernel that lacks RWF_NOWAIT.
> > > > > 
> > > > Oh, so the case below is roughly how I would have expected to hit the
> > > > flush/wait without RWF_NOWAIT. The latter flag should prevent this, to
> > > > answer your first question.
> > > Thanks, that's very encouraging. We are exploring recommending upstream-ish
> > > kernels to users and customers, given their relative stability these days
> > > and aio-related improvements (not to mention the shame of having to admit to
> > > running an old kernel when reporting a problem to an upstream list).
> > > 
> > > > For the follow up question, I think this should only occur when the fs
> > > > is fairly low on free space. Is that the case here?
> > > No:
> > > 
> > > /dev/md0        3.0T  1.2T  1.8T  40% /var/lib/scylla
> > > 
> > > 
> > > > I'm not sure there's
> > > > a specific metric, fwiw, but it's just a matter of attempting an (user
> > > > data) allocation that only finds busy extents in the free space btrees
> > > > and thus has to the force the log to satisfy the allocation.
> > > What does "busy" mean here? recently freed so we want to force the log to
> > > make sure the extent isn't doubly-allocated? (wild guess)
> > > 
> > Recently freed and the transaction that freed the blocks has not yet
> > been persisted to the on-disk log. A subsequent attempt to allocate
> > those blocks for user data waits for the transaction to commit to disk
> > to ensure that the block is not written before the filesystem has
> > persisted the fact that it has been freed. Otherwise, my understanding
> > is that if the blocks are written to and the filesystem crashes before
> > the previous free was persisted, we'd have allowed an overwrite of a
> > still-used metadata block.
> 
> Understood, thanks.
> 
> > 
> > > >    I suppose
> > > > running with more free space available would avoid this. I think running
> > > > with less in-core log space could indirectly reduce extent busy time,
> > > > but that may also have other performance ramifications and so is
> > > > probably not a great idea.
> > > At 60%, I hope low free space  is not a problem.
> > > 
> > Yeah, that seems strange. I wouldn't expect busy extents to be a problem
> > with that much free space.
> 
> The workload creates new files, appends to them, lets them stew for a while,
> then deletes them. Maybe something is preventing xfs from seeing non-busy
> extents?
> 

Yeah, could be.. perhaps the issue is that despite the large amount of
total free space, the free space is too fragmented to satisfy a
particular allocation request..?

> The disk is writing at 300-600MB/s for several days, so quite some churn.
> 
> > 
> > > btw, I'm also seeing 10ms+ periods of high CPU utilization:
> > > 
> > >   0xffffffff816ab97a : _cond_resched+0x3a/0x50 [kernel]
> > >   0xffffffff811e1495 : kmem_cache_alloc+0x35/0x1e0 [kernel]
> > >   0xffffffffc00d8477 : kmem_zone_alloc+0x97/0x130 [xfs]
> > >   0xffffffffc00deae2 : xfs_buf_item_init+0x42/0x190 [xfs]
> > >   0xffffffffc00e89c3 : _xfs_trans_bjoin+0x23/0x60 [xfs]
> > >   0xffffffffc00e8f17 : xfs_trans_read_buf_map+0x247/0x400 [xfs]
> > >   0xffffffffc008f248 : xfs_btree_read_buf_block.constprop.29+0x78/0xc0 [xfs]
> > >   0xffffffffc009221e : xfs_btree_increment+0x21e/0x350 [xfs]
> > >   0xffffffffc00796a8 : xfs_alloc_ag_vextent_near+0x368/0xab0 [xfs]
> > >   0xffffffffc0079efd : xfs_alloc_ag_vextent+0x10d/0x150 [xfs]
> > >   0xffffffffc007abc6 : xfs_alloc_vextent+0x446/0x5f0 [xfs]
> > >   0xffffffffc008b123 : xfs_bmap_btalloc+0x3f3/0x780 [xfs]
> > >   0xffffffffc008b4be : xfs_bmap_alloc+0xe/0x10 [xfs]
> > > 
> > > Is it normal for xfs to spend 10ms+ of CPU time to allocate an extent?
> > > Should I be increasing my extent hint (currently at 32MB)?
> > > 
> > I haven't done enough performance testing to have an intuition on the
> > typical CPU time required to allocate blocks. Somebody else may be able
> > to chime in on that. I suppose it could depend on the level of free
> > space fragmentation, which can be observed via 'xfs_db -c "freesp -s"
> > <dev>', whether I/Os or btree splits/joins were required, etc.
> > 
> > FWIW, the above stack looks like it's stuck waiting on a memory
> > allocation for a btree buffer xfs_buf_log_item, which is an internal
> > data structure used to track metadata objects through the log subsystem.
> > We have a kmem zone for such objects because they are allocated/freed
> > frequently, but perhaps the zone had to grow..? We do pass KM_SLEEP
> > there..
> 
> It's not really waiting, that's a cond_resched. The scheduler switched away
> because some other task needed its attention, not because memory was not
> available. That's understandable since xfs hogged the cpu for 10ms.
> 

Ah, I misread it as you were blocked in that callchain. I suppose ftrace
or something could help annotate the time spent in the allocation path.
Free space fragmentation could potentially be a factor here as well,
causing the search algorithm(s) to run through a lot of records/blocks
to find something usable, for example.

Brian

> I will look at xfs_bmap output later, after I renew my friendship with
> trace-cmd.
> 
> > Brian
> > 
> > > > Brian
> > > > 
> > > > >    0xffffffff816ab231 : __schedule+0x531/0x9b0 [kernel]
> > > > >    0xffffffff816ab6d9 : schedule+0x29/0x70 [kernel]
> > > > >    0xffffffff816a90e9 : schedule_timeout+0x239/0x2c0 [kernel]
> > > > >    0xffffffff816aba8d : wait_for_completion+0xfd/0x140 [kernel]
> > > > >    0xffffffff810ab41d : flush_work+0xfd/0x190 [kernel]
> > > > >    0xffffffffc00ddb3a : xlog_cil_force_lsn+0x8a/0x210 [xfs]
> > > > >    0xffffffffc00dbbf5 : _xfs_log_force+0x85/0x2c0 [xfs]
> > > > >    0xffffffffc00dbe5c : xfs_log_force+0x2c/0x70 [xfs]
> > > > >    0xffffffffc0078f60 : xfs_alloc_ag_vextent_size+0x250/0x630 [xfs]
> > > > >    0xffffffffc0079ed5 : xfs_alloc_ag_vextent+0xe5/0x150 [xfs]
> > > > >    0xffffffffc007abc6 : xfs_alloc_vextent+0x446/0x5f0 [xfs]
> > > > >    0xffffffffc008b123 : xfs_bmap_btalloc+0x3f3/0x780 [xfs]
> > > > >    0xffffffffc008b4be : xfs_bmap_alloc+0xe/0x10 [xfs]
> > > > >    0xffffffffc008bef9 : xfs_bmapi_write+0x499/0xab0 [xfs]
> > > > >    0xffffffffc00c6ec8 : xfs_iomap_write_direct+0x1b8/0x390 [xfs]
> > > > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
