Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6QM6C14144468 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 17:06:12 -0500
Received: from mail-gy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 270DE47235E
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 15:09:16 -0700 (PDT)
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	kGMtYAfCqOp43BJ8 for <xfs@oss.sgi.com>;
	Mon, 26 Jul 2010 15:09:16 -0700 (PDT)
Received: by gyf1 with SMTP id 1so1265689gyf.26
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 15:09:16 -0700 (PDT)
Date: Mon, 26 Jul 2010 17:09:09 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: Re: High latencies writing to a memory mapped file
Message-ID: <20100726220909.GA3017@BohrerMBP.rgmadvisors.com>
References: <20100722144706.GA2840@BohrerMBP.rgmadvisors.com>
	<20100722232846.GC32635@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100722232846.GC32635@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hey Dave,

Thanks for the suggestions.

On Fri, Jul 23, 2010 at 09:28:46AM +1000, Dave Chinner wrote:
> On Thu, Jul 22, 2010 at 09:47:06AM -0500, Shawn Bohrer wrote:
> > Hello,
> > 
> > We have an application that receives data over the network, and then
> > writes data out to a shared memory mapped file on xfs.  Previously
> > everything worked great when we were running a CentOS 5.3 kernel
> > (2.6.18-128.7.1.el5), but when we upgraded to the newer CentOS 5.4 or
> > 5.5 kernels we started to see occasional spikes (up to 1 second) in
> > the time it takes to write the data to the memory mapped file.  I
> > noticed that between the CentOS 5.3 and 5.4 kernels the upstream xfs
> > changes were backported.  Testing on 2.6.32.16 shows the same
> > occasional latency spikes.
> > 
> > After doing some debugging on 2.6.32.16 I have found the cause of the
> > latency spikes.  The spikes occur every time pdflush runs to flush the
> > dirty pages.  Note our app only writes data at about 1.5 MB/s and we
> > are well below both the dirty_background_ratio and the dirty_ratio so
> > these flushes are only of pages that are dirty_expire_centisecs old.
> > Capturing one of the spikes with ftrace shows:
> > 
> > ...
> > flush-8:0-601   [011] 1291592.127590: funcgraph_entry:                   |  xfs_ilock() {
> > flush-8:0-601   [011] 1291592.127590: funcgraph_entry:                   |    down_write() {
> > flush-8:0-601   [011] 1291592.127590: funcgraph_entry:        0.213 us   |      _cond_resched();
> > flush-8:0-601   [011] 1291592.127591: funcgraph_exit:         0.657 us   |    }
> > flush-8:0-601   [011] 1291592.127591: funcgraph_exit:         1.174 us   |  }
> > flush-8:0-601   [011] 1291592.127764: sched_switch:         task flush-8:0:601 [120] (D) ==> swapper:0 [120]
> > ...
> 
> what is the lead-in context to this hunk? i.e. how does xfs_ilock()
> get called? That will tell me if it is blocking on the iolock or the
> ilock...

I don't have the lead-in context here.  I'm using the function_graph
tracer and with stalls up to a second in length it easily overflowed
the ftrace ring buffer.  Once I found I my process was blocking on the
xfs_ilock(), I limited my traces to include xfs_ilock, xfs_iunlock,
handle_mm_fault, and the scheduler events.  If you are still
interested in seeing some more detail here I can try to collect some
more captures.

> > Here you can see flush-8:0 acquires the xfs_ilock() then I believe it
> > blocks waiting for the I/O to complete.  Next you can see my
> > file_writer process generates a page fault while writing new data to
> > the memory mapped file.  The page fault tries to acquire the
> > xfs_ilock() and then blocks because it is held by the flush-8:0
> > process.
> > 
> > ...
> > file_writer-10549 [001] 1291593.100416: print:                00000000 write_delay start
> > file_writer-10549 [001] 1291593.100419: funcgraph_entry:                   |  handle_mm_fault() {
> > file_writer-10549 [001] 1291593.100420: funcgraph_entry:                   |    __do_fault() {
> > file_writer-10549 [001] 1291593.100420: funcgraph_entry:                   |      filemap_fault() {
> > file_writer-10549 [001] 1291593.100421: funcgraph_entry:        0.775 us   |        find_get_page();
> > file_writer-10549 [001] 1291593.100422: funcgraph_entry:        0.191 us   |        _cond_resched();
> > file_writer-10549 [001] 1291593.100422: funcgraph_exit:         1.980 us   |      }
> > file_writer-10549 [001] 1291593.100422: funcgraph_entry:                   |      unlock_page() {
> > file_writer-10549 [001] 1291593.100423: funcgraph_entry:        0.154 us   |        page_waitqueue();
> > file_writer-10549 [001] 1291593.100423: funcgraph_entry:        0.313 us   |        __wake_up_bit();
> > file_writer-10549 [001] 1291593.100423: funcgraph_exit:         1.080 us   |      }
> > file_writer-10549 [001] 1291593.100424: funcgraph_entry:                   |      xfs_vm_page_mkwrite() {
> > file_writer-10549 [001] 1291593.100424: funcgraph_entry:                   |        block_page_mkwrite() {
> > file_writer-10549 [001] 1291593.100424: funcgraph_entry:        0.240 us   |          _cond_resched();
> > file_writer-10549 [001] 1291593.100425: funcgraph_entry:                   |          block_prepare_write() {
> > file_writer-10549 [001] 1291593.100425: funcgraph_entry:                   |            __block_prepare_write() {
> > file_writer-10549 [001] 1291593.100426: funcgraph_entry:                   |              create_empty_buffers() {
> > file_writer-10549 [001] 1291593.100426: funcgraph_entry:                   |                alloc_page_buffers() {
> > file_writer-10549 [001] 1291593.100426: funcgraph_entry:                   |                  alloc_buffer_head() {
> > file_writer-10549 [001] 1291593.100426: funcgraph_entry:                   |                    kmem_cache_alloc() {
> > file_writer-10549 [001] 1291593.100427: funcgraph_entry:        0.491 us   |                      _cond_resched();
> > file_writer-10549 [001] 1291593.100427: funcgraph_exit:         1.043 us   |                    }
> > file_writer-10549 [001] 1291593.100428: funcgraph_entry:        0.185 us   |                    recalc_bh_state();
> > file_writer-10549 [001] 1291593.100428: funcgraph_exit:         2.003 us   |                  }
> > file_writer-10549 [001] 1291593.100428: funcgraph_entry:        0.137 us   |                  set_bh_page();
> > file_writer-10549 [001] 1291593.100428: funcgraph_exit:         2.701 us   |                }
> > file_writer-10549 [001] 1291593.100429: funcgraph_entry:        0.271 us   |                _spin_lock();
> > file_writer-10549 [001] 1291593.100429: funcgraph_exit:         3.751 us   |              }
> > file_writer-10549 [001] 1291593.100429: funcgraph_entry:                   |              xfs_get_blocks() {
> > file_writer-10549 [001] 1291593.100430: funcgraph_entry:                   |                __xfs_get_blocks() {
> > file_writer-10549 [001] 1291593.100430: funcgraph_entry:                   |                  xfs_iomap() {
> > file_writer-10549 [001] 1291593.100430: funcgraph_entry:                   |                    xfs_ilock() {
> 
> So this is trying to lock the ilock exclusively to map the range or
> do delayed allocation reservations.
> 
> > Finally xfslogd/1 wakes up the flush-8:0 process which releases the
> > xfs_ilock() waking up my file_writer process and allowing it to
> > continue.
> > ...
> > xfslogd/1-213   [001] 1291593.158606: sched_wakeup:         task flush-8:0:601 [120] success=1 [011]
> >    <idle>-0     [011] 1291593.158609: sched_switch:         task swapper:0 [120] (R) ==> flush-8:0:601 [120]
> 
> xfslogd? Inodes do not get locked across log writes; they are
> unlocked in the transaction commit.
> 
> Hmmm - perhaps the issue is that the transaction commit has not been
> able to get a iclog buffer to write the transaction into and so is
> sleeping waiting for an iclog IO to complete. That would be woken by
> the xfslogd, and then the transaction would write into the
> now-available iclog and unlock the inode.
> 
> So, I'd say that in this case your application is waiting for log IO
> completion to occur. Nothing you can do to avoid that, but you can
> minimise the impact - increase the log buffer size via the mount
> option logbsize (i.e. -o logbsize=262144) to reduce the frequency of
> iclog buffer IOs and make it less likely the system will run stall
> having run out of iclog space.
> 
> The other possibility is that the log IO is being slowed by barriers
> being issued with the log writes. If you've got non-volatile caches
> on your storage, you can turn off barriers and that should help
> reduce log IO latency significantly.

I've tried mounting with "noatime,nobarrier,logbufs=8,logbsize=262144"
but I don't notice much difference and still see the stalls.

> Another possibility is to switch to the deadline or no-op IO
> scheduler to avoid log IO being delayed by (the ever changing)
> CFQ IO scheduling idiosyncracies.

I also tried using the noop IO scheduler, but also didn't see any
improvement.

Thanks,
Shawn

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
