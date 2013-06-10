Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AE4B27F37
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 15:53:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F693AC003
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 13:53:22 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	hI5WgAhr7in4daNu for <xfs@oss.sgi.com>;
	Mon, 10 Jun 2013 13:53:19 -0700 (PDT)
Date: Tue, 11 Jun 2013 06:53:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.10-rc4 stalls during mmap writes
Message-ID: <20130610205315.GB29376@dastard>
References: <20130607193712.GD2995@sbohrermbp13-local.rgmadvisors.com>
	<20130609033744.GA29376@dastard>
	<20130610184559.GA3594@sbohrermbp13-local.rgmadvisors.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130610184559.GA3594@sbohrermbp13-local.rgmadvisors.com>
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
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jun 10, 2013 at 01:45:59PM -0500, Shawn Bohrer wrote:
> On Sun, Jun 09, 2013 at 01:37:44PM +1000, Dave Chinner wrote:
> > On Fri, Jun 07, 2013 at 02:37:12PM -0500, Shawn Bohrer wrote:
> > > So I guess my question is does anyone know why I'm now seeing these
> > > stalls with 3.10?
> > 
> > Because we made all metadata updates in XFS fully transactional in
> > 3.4:
> > 
> > commit 8a9c9980f24f6d86e0ec0150ed35fba45d0c9f88
> > Author: Christoph Hellwig <hch@infradead.org>
> > Date:   Wed Feb 29 09:53:52 2012 +0000
> > 
> >     xfs: log timestamp updates
> >     
> >     Timestamps on regular files are the last metadata that XFS does not update
> >     transactionally.  Now that we use the delaylog mode exclusively and made
> >     the log scode scale extremly well there is no need to bypass that code for
> >     timestamp updates.  Logging all updates allows to drop a lot of code, and
> >     will allow for further performance improvements later on.
> >     
> >     Note that this patch drops optimized handling of fdatasync - it will be
> >     added back in a separate commit.
> >     
> >     Reviewed-by: Dave Chinner <dchinner@redhat.com>
> >     Signed-off-by: Christoph Hellwig <hch@lst.de>
> >     Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> >     Signed-off-by: Ben Myers <bpm@sgi.com>
> > $ git describe --contains 8a9c998
> > v3.4-rc1~55^2~23
> > 
> > IOWs, you're just lucky you haven't noticed it on 3.4....
> > 
> > > Are there any suggestions for how to eliminate them?
> > 
> > Nope. You're stuck with it - there's far more places in the page
> > fault path where you can get stuck on the same lock for the same
> > reason - e.g. during block mapping for the newly added pagecache
> > page...
> > 
> > Hint: mmap() does not provide -deterministic- low latency access to
> > mapped pages - it is only "mostly low latency".
> 
> Hi Dave, I appreciate your time and analysis.  I am sadly aware that
> doing file I/O and expecting low latency is a bit of a stretch.  This
> is also not the first time I've battled these types of stalls and
> realize that the best I can do is search for opportunities to reduce
> the probability of a stall, or find ways to reduce the duration of a
> stall.
> 
> In this case since updating timestamps has been transactional and in
> place since 3.4, it is obvious to me that this is not the cause of
> both the increased rate and duration of the stalls on 3.10.  I assure
> you on 3.4 we have very few stalls that are greater than 10
> milliseconds in our normal workload and with 3.10 I'm seeing them
> regularly.  Since we know I can, and likely do, hit the same code path
> on 3.4 that tells me that me that the xfs_ilock() is likely being held
> for a longer duration on the new kernel.  Let's see if we can
> determine why the lock is held for so long.
> 
> Here is an attempt at that, as events unfold in time order.  I'm in no
> way a filesystem developer so any input or analysis of what we're
> waiting on is appreciated.  There is also multiple kworker threads
> involved which certainly complicates things.
> 
> 
> It starts with kworker/u49:0 which aquires xfs_ilock() inside
> iomap_write_allocate().
> 
> 
>    kworker/u49:0-15748 [004] 256032.180361: funcgraph_entry:                   |  xfs_iomap_write_allocate() {
>    kworker/u49:0-15748 [004] 256032.180363: funcgraph_entry:        0.074 us   |    xfs_ilock();
> 
> 
> In the next two chunks it appears that kworker/u49:0 calls
> xfs_bmapi_allocate which offloads that work to kworker/4:0 calling
> __xfs_bmapi_allocate().  kworker/4:0 ends up blocking on xfs_buf_lock().
> 
> 
>      kworker/4:0-27520 [004] 256032.180389: sched_switch:         prev_comm=kworker/4:0 prev_pid=27520 prev_prio=120 prev_state=D ==> next_comm=kworker/u49:0 next_pid=15748 next_prio=120
>      kworker/4:0-27520 [004] 256032.180393: kernel_stack:         <stack trace>
> => schedule (ffffffff814ca379)
> => schedule_timeout (ffffffff814c810d)
> => __down_common (ffffffff814c8e5e)
> => __down (ffffffff814c8f26)
> => down (ffffffff810658e1)
> => xfs_buf_lock (ffffffff811c12a4)
> => _xfs_buf_find (ffffffff811c1469)
> => xfs_buf_get_map (ffffffff811c16e4)
> => xfs_buf_read_map (ffffffff811c2691)
> => xfs_trans_read_buf_map (ffffffff81225fa9)
> => xfs_btree_read_buf_block.constprop.6 (ffffffff811f2242)
> => xfs_btree_lookup_get_block (ffffffff811f22fb)
> => xfs_btree_lookup (ffffffff811f6707)
> => xfs_alloc_ag_vextent_near (ffffffff811d9d52)
> => xfs_alloc_ag_vextent (ffffffff811da8b5)
> => xfs_alloc_vextent (ffffffff811db545)
> => xfs_bmap_btalloc (ffffffff811e6951)
> => xfs_bmap_alloc (ffffffff811e6dee)
> => __xfs_bmapi_allocate (ffffffff811ec024)
> => xfs_bmapi_allocate_worker (ffffffff811ec283)
> => process_one_work (ffffffff81059104)
> => worker_thread (ffffffff8105a1bc)
> => kthread (ffffffff810605f0)
> => ret_from_fork (ffffffff814d395c)

It has blocked waiting for freespace btree IO to complete....

> kworker/u49:0-15748 [004] 256032.180403: sched_switch:         prev_comm=kworker/u49:0 prev_pid=15748 prev_prio=120 prev_state=D ==> next_comm=kworker/4:1H next_pid=3921 next_prio=100
>    kworker/u49:0-15748 [004] 256032.180408: kernel_stack:         <stack trace>
> => schedule (ffffffff814ca379)
> => schedule_timeout (ffffffff814c810d)
> => wait_for_completion (ffffffff814ca2e5)
> => xfs_bmapi_allocate (ffffffff811eea57)
> => xfs_bmapi_write (ffffffff811eef33)
> => xfs_iomap_write_allocate (ffffffff811ce49e)
> => return_to_handler (ffffffff814d3845)
> => xfs_map_blocks (ffffffff811bf145)
> => xfs_vm_writepage (ffffffff811bfbc2)
> => __writepage (ffffffff810f14e7)
> => write_cache_pages (ffffffff810f189e)
> => generic_writepages (ffffffff810f1b3a)
> => xfs_vm_writepages (ffffffff811bef8d)
> => do_writepages (ffffffff810f3380)
> => __writeback_single_inode (ffffffff81166ae5)
> => writeback_sb_inodes (ffffffff81167d4d)
> => __writeback_inodes_wb (ffffffff8116800e)
> => wb_writeback (ffffffff811682bb)
> => wb_check_old_data_flush (ffffffff811683ff)
> => wb_do_writeback (ffffffff81169bd1)
> => bdi_writeback_workfn (ffffffff81169cca)
> => process_one_work (ffffffff81059104)
> => worker_thread (ffffffff8105a1bc)
> => kthread (ffffffff810605f0)
> => ret_from_fork (ffffffff814d395c)

which is during allocation triggered by writeback IO.
> Here I have kworker/2:1H which appears to get its work scheduled from
> a softirq.
> 
>           <idle>-0     [002] 256032.890594: sched_wakeup:         comm=kworker/2:1H pid=2176 prio=100 success=1 target_cpu=002
>           <idle>-0     [002] 256032.890598: kernel_stack:         <stack trace>
> => ttwu_do_activate.constprop.34 (ffffffff8106c556)
> => try_to_wake_up (ffffffff8106e996)
> => wake_up_process (ffffffff8106ea87)
> => wake_up_worker (ffffffff810568c4)
> => insert_work (ffffffff8105821d)
> => __queue_work (ffffffff81058391)
> => queue_work_on (ffffffff81058605)
> => xfs_buf_ioend (ffffffff811c1a37)
> => _xfs_buf_ioend.constprop.1 (ffffffff811c1aaa)
> => xfs_buf_bio_end_io (ffffffff811c1f58)
> => bio_endio (ffffffff8117362d)
> => blk_update_request (ffffffff8124f1b8)
> => blk_update_bidi_request (ffffffff8124f511)
> => blk_end_bidi_request (ffffffff8124f59c)
> => blk_end_request (ffffffff8124f630)
> => scsi_io_completion (ffffffff8136156f)
> => scsi_finish_command (ffffffff81357e11)
> => scsi_softirq_done (ffffffff813613bf)
> => blk_done_softirq (ffffffff81255fe3)
> => __do_softirq (ffffffff81044230)
> => irq_exit (ffffffff81044505)
> => smp_call_function_single_interrupt (ffffffff81024475)
> => call_function_single_interrupt (ffffffff814d477a)
> => arch_cpu_idle (ffffffff8100ad8e)
> => cpu_startup_entry (ffffffff8107b39e)
> => start_secondary (ffffffff81b259f3)
>           <idle>-0     [002] 256032.890603: sched_switch:         prev_comm=swapper/2 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=kworker/2:1H next_pid=2176 next_prio=100
> 

That's physical IO completion occurring, up to the point where XFS
queues it to a different workqueue...

> 
> kworker/2:1H calls xfs_buf_unlock() which then wakes up kworker/4:0
> 
> 
>     kworker/2:1H-2176  [002] 256032.890607: sched_wakeup:         comm=kworker/4:0 pid=27520 prio=120 success=1 target_cpu=004
>     kworker/2:1H-2176  [002] 256032.890609: kernel_stack:         <stack trace>
> => ttwu_do_activate.constprop.34 (ffffffff8106c556)
> => try_to_wake_up (ffffffff8106e996)
> => wake_up_process (ffffffff8106ea87)
> => __up (ffffffff814c8dce)
> => up (ffffffff81065762)
> => xfs_buf_unlock (ffffffff811c163d)
> => xfs_buf_iodone_work (ffffffff811c1908)
> => xfs_buf_ioend (ffffffff811c198b)
> => xfs_buf_iodone_callbacks (ffffffff812222b6)
> => xfs_buf_iodone_work (ffffffff811c18be)
> => process_one_work (ffffffff81059104)
> => worker_thread (ffffffff8105a1bc)
> => kthread (ffffffff810605f0)
> => ret_from_fork (ffffffff814d395c)
> 
> kworker/4:0 wakes up kworker/u49:0 which which releases xfs_iunlock()
> ending the delay.

And that's the IO completed.

> 
>      kworker/4:0-27520 [004] 256032.890646: sched_wakeup:         comm=kworker/u49:0 pid=15748 prio=120 success=1 target_cpu=006
>    kworker/u49:0-15748 [006] 256032.890665: funcgraph_entry:        1.143 us   |    xfs_iunlock();
>    kworker/u49:0-15748 [006] 256032.890666: funcgraph_exit:       ! 710304.855 us |  }
> 
> 
> So to summarize it appears that most of the time was spent with
> kworker/4:0 blocking in xfs_buf_lock() and kworker/2:1H, which is woken
> up by a softirq, is the one that calls xfs_buf_unlock().  Assuming I'm
> not missing some important intermediate steps does this provide any
> more information about what resource I'm actually waiting for?  Does
> this point to any changes that happened after 3.4?  Are there any tips
> that could help minimize these contentions?

The only difference between this and 3.4 is the allocation workqueue
thread. That, however, won't be introducing second long delays. What
you are seeing here is simply a the latency of waiting for
background metadata IO to complete during an allocation which has
the ilock held....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
