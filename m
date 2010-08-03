Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o73M3hZh258401 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 17:03:43 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B033511C9331
	for <xfs@oss.sgi.com>; Tue,  3 Aug 2010 15:12:01 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id hXxs3nB5nvCBAzJp
	for <xfs@oss.sgi.com>; Tue, 03 Aug 2010 15:12:01 -0700 (PDT)
Received: by vws15 with SMTP id 15so3488604vws.26
	for <xfs@oss.sgi.com>; Tue, 03 Aug 2010 15:04:01 -0700 (PDT)
Date: Tue, 3 Aug 2010 17:03:53 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: Re: High latencies writing to a memory mapped file
Message-ID: <20100803220336.GA7282@BohrerMBP.rgmadvisors.com>
References: <20100722144706.GA2840@BohrerMBP.rgmadvisors.com>
	<20100722232846.GC32635@dastard>
	<20100726220909.GA3017@BohrerMBP.rgmadvisors.com>
	<20100726232224.GJ7362@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100726232224.GJ7362@dastard>
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

On Tue, Jul 27, 2010 at 09:22:24AM +1000, Dave Chinner wrote:
> On Mon, Jul 26, 2010 at 05:09:09PM -0500, Shawn Bohrer wrote:
> > On Fri, Jul 23, 2010 at 09:28:46AM +1000, Dave Chinner wrote:
> > > On Thu, Jul 22, 2010 at 09:47:06AM -0500, Shawn Bohrer wrote:
> > > > Hello,
> > > > 
> > > > We have an application that receives data over the network, and then
> > > > writes data out to a shared memory mapped file on xfs.  Previously
> > > > everything worked great when we were running a CentOS 5.3 kernel
> > > > (2.6.18-128.7.1.el5), but when we upgraded to the newer CentOS 5.4 or
> > > > 5.5 kernels we started to see occasional spikes (up to 1 second) in
> > > > the time it takes to write the data to the memory mapped file.  I
> > > > noticed that between the CentOS 5.3 and 5.4 kernels the upstream xfs
> > > > changes were backported.  Testing on 2.6.32.16 shows the same
> > > > occasional latency spikes.
> > > > 
> > > > After doing some debugging on 2.6.32.16 I have found the cause of the
> > > > latency spikes.  The spikes occur every time pdflush runs to flush the
> > > > dirty pages.  Note our app only writes data at about 1.5 MB/s and we
> > > > are well below both the dirty_background_ratio and the dirty_ratio so
> > > > these flushes are only of pages that are dirty_expire_centisecs old.
> > > > Capturing one of the spikes with ftrace shows:
> > > > 
> > > > ...
> > > > flush-8:0-601   [011] 1291592.127590: funcgraph_entry:                   |  xfs_ilock() {
> > > > flush-8:0-601   [011] 1291592.127590: funcgraph_entry:                   |    down_write() {
> > > > flush-8:0-601   [011] 1291592.127590: funcgraph_entry:        0.213 us   |      _cond_resched();
> > > > flush-8:0-601   [011] 1291592.127591: funcgraph_exit:         0.657 us   |    }
> > > > flush-8:0-601   [011] 1291592.127591: funcgraph_exit:         1.174 us   |  }
> > > > flush-8:0-601   [011] 1291592.127764: sched_switch:         task flush-8:0:601 [120] (D) ==> swapper:0 [120]
> > > > ...
> > > 
> > > what is the lead-in context to this hunk? i.e. how does xfs_ilock()
> > > get called? That will tell me if it is blocking on the iolock or the
> > > ilock...
> > 
> > I don't have the lead-in context here.  I'm using the function_graph
> > tracer and with stalls up to a second in length it easily overflowed
> > the ftrace ring buffer.  Once I found I my process was blocking on the
> > xfs_ilock(), I limited my traces to include xfs_ilock, xfs_iunlock,
> > handle_mm_fault, and the scheduler events.  If you are still
> > interested in seeing some more detail here I can try to collect some
> > more captures.
> 
> I'm not sure isthe tracepoint buffer is the same as the ftrace
> buffer, but if it is you can increase the size by doing this sort of
> thing:
> 
> # echo 32768 > /sys/kernel/debug/tracing/buffer_size_kb
> 
> I often do that to capture long XFS traces during testing....
> 
> [snip]
> 
> > > Hmmm - perhaps the issue is that the transaction commit has not been
> > > able to get a iclog buffer to write the transaction into and so is
> > > sleeping waiting for an iclog IO to complete. That would be woken by
> > > the xfslogd, and then the transaction would write into the
> > > now-available iclog and unlock the inode.
> > > 
> > > So, I'd say that in this case your application is waiting for log IO
> > > completion to occur. Nothing you can do to avoid that, but you can
> > > minimise the impact - increase the log buffer size via the mount
> > > option logbsize (i.e. -o logbsize=262144) to reduce the frequency of
> > > iclog buffer IOs and make it less likely the system will run stall
> > > having run out of iclog space.
> > > 
> > > The other possibility is that the log IO is being slowed by barriers
> > > being issued with the log writes. If you've got non-volatile caches
> > > on your storage, you can turn off barriers and that should help
> > > reduce log IO latency significantly.
> > 
> > I've tried mounting with "noatime,nobarrier,logbufs=8,logbsize=262144"
> > but I don't notice much difference and still see the stalls.
> 
> Ok. One other possibility came to mind - the transaction commit is
> blocking while locking the superblock buffer to apply free block
> count changes. Do you have the "lazy-count" option set (xfs_info
> <mtpt> will tell you). If it isn't set, then transaction commit
> latency can be quite high if the sb buffer is being written to disk
> when the transaction tries to lock it. If it is not set, you can use
> xfs_admin to set that bit (mkfs has defaulted to lazy-count=1 for
> some time now).

Setting lazy-count=1 looks like it has helped quite a bit to reduce
the frequency that I was seeing the spikes.  I am still seeing spikes
of up to a second, but I haven't had time to capture any more traces
to verify if they are the same issue.  Overall though this may be good
enough.

Thanks,
Shawn

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
