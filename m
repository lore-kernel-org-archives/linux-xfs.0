Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6MEiE9M144066 for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 09:44:15 -0500
Received: from mail-gw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 650E14680DE
	for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 07:47:15 -0700 (PDT)
Received: from mail-gw0-f53.google.com (mail-gw0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id WbkxR0fNUTMt3E3a
	for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 07:47:15 -0700 (PDT)
Received: by gwb1 with SMTP id 1so124473gwb.26
	for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 07:47:15 -0700 (PDT)
Date: Thu, 22 Jul 2010 09:47:06 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: High latencies writing to a memory mapped file
Message-ID: <20100722144706.GA2840@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hello,

We have an application that receives data over the network, and then
writes data out to a shared memory mapped file on xfs.  Previously
everything worked great when we were running a CentOS 5.3 kernel
(2.6.18-128.7.1.el5), but when we upgraded to the newer CentOS 5.4 or
5.5 kernels we started to see occasional spikes (up to 1 second) in
the time it takes to write the data to the memory mapped file.  I
noticed that between the CentOS 5.3 and 5.4 kernels the upstream xfs
changes were backported.  Testing on 2.6.32.16 shows the same
occasional latency spikes.

After doing some debugging on 2.6.32.16 I have found the cause of the
latency spikes.  The spikes occur every time pdflush runs to flush the
dirty pages.  Note our app only writes data at about 1.5 MB/s and we
are well below both the dirty_background_ratio and the dirty_ratio so
these flushes are only of pages that are dirty_expire_centisecs old.
Capturing one of the spikes with ftrace shows:

...
flush-8:0-601   [011] 1291592.127590: funcgraph_entry:                   |  xfs_ilock() {
flush-8:0-601   [011] 1291592.127590: funcgraph_entry:                   |    down_write() {
flush-8:0-601   [011] 1291592.127590: funcgraph_entry:        0.213 us   |      _cond_resched();
flush-8:0-601   [011] 1291592.127591: funcgraph_exit:         0.657 us   |    }
flush-8:0-601   [011] 1291592.127591: funcgraph_exit:         1.174 us   |  }
flush-8:0-601   [011] 1291592.127764: sched_switch:         task flush-8:0:601 [120] (D) ==> swapper:0 [120]
...

Here you can see flush-8:0 acquires the xfs_ilock() then I believe it
blocks waiting for the I/O to complete.  Next you can see my
file_writer process generates a page fault while writing new data to
the memory mapped file.  The page fault tries to acquire the
xfs_ilock() and then blocks because it is held by the flush-8:0
process.

...
file_writer-10549 [001] 1291593.100416: print:                00000000 write_delay start
file_writer-10549 [001] 1291593.100419: funcgraph_entry:                   |  handle_mm_fault() {
file_writer-10549 [001] 1291593.100420: funcgraph_entry:                   |    __do_fault() {
file_writer-10549 [001] 1291593.100420: funcgraph_entry:                   |      filemap_fault() {
file_writer-10549 [001] 1291593.100421: funcgraph_entry:        0.775 us   |        find_get_page();
file_writer-10549 [001] 1291593.100422: funcgraph_entry:        0.191 us   |        _cond_resched();
file_writer-10549 [001] 1291593.100422: funcgraph_exit:         1.980 us   |      }
file_writer-10549 [001] 1291593.100422: funcgraph_entry:                   |      unlock_page() {
file_writer-10549 [001] 1291593.100423: funcgraph_entry:        0.154 us   |        page_waitqueue();
file_writer-10549 [001] 1291593.100423: funcgraph_entry:        0.313 us   |        __wake_up_bit();
file_writer-10549 [001] 1291593.100423: funcgraph_exit:         1.080 us   |      }
file_writer-10549 [001] 1291593.100424: funcgraph_entry:                   |      xfs_vm_page_mkwrite() {
file_writer-10549 [001] 1291593.100424: funcgraph_entry:                   |        block_page_mkwrite() {
file_writer-10549 [001] 1291593.100424: funcgraph_entry:        0.240 us   |          _cond_resched();
file_writer-10549 [001] 1291593.100425: funcgraph_entry:                   |          block_prepare_write() {
file_writer-10549 [001] 1291593.100425: funcgraph_entry:                   |            __block_prepare_write() {
file_writer-10549 [001] 1291593.100426: funcgraph_entry:                   |              create_empty_buffers() {
file_writer-10549 [001] 1291593.100426: funcgraph_entry:                   |                alloc_page_buffers() {
file_writer-10549 [001] 1291593.100426: funcgraph_entry:                   |                  alloc_buffer_head() {
file_writer-10549 [001] 1291593.100426: funcgraph_entry:                   |                    kmem_cache_alloc() {
file_writer-10549 [001] 1291593.100427: funcgraph_entry:        0.491 us   |                      _cond_resched();
file_writer-10549 [001] 1291593.100427: funcgraph_exit:         1.043 us   |                    }
file_writer-10549 [001] 1291593.100428: funcgraph_entry:        0.185 us   |                    recalc_bh_state();
file_writer-10549 [001] 1291593.100428: funcgraph_exit:         2.003 us   |                  }
file_writer-10549 [001] 1291593.100428: funcgraph_entry:        0.137 us   |                  set_bh_page();
file_writer-10549 [001] 1291593.100428: funcgraph_exit:         2.701 us   |                }
file_writer-10549 [001] 1291593.100429: funcgraph_entry:        0.271 us   |                _spin_lock();
file_writer-10549 [001] 1291593.100429: funcgraph_exit:         3.751 us   |              }
file_writer-10549 [001] 1291593.100429: funcgraph_entry:                   |              xfs_get_blocks() {
file_writer-10549 [001] 1291593.100430: funcgraph_entry:                   |                __xfs_get_blocks() {
file_writer-10549 [001] 1291593.100430: funcgraph_entry:                   |                  xfs_iomap() {
file_writer-10549 [001] 1291593.100430: funcgraph_entry:                   |                    xfs_ilock() {
file_writer-10549 [001] 1291593.100430: funcgraph_entry:                   |                      down_write() {
file_writer-10549 [001] 1291593.100431: funcgraph_entry:        0.241 us   |                        _cond_resched();
file_writer-10549 [001] 1291593.100431: funcgraph_entry:        0.258 us   |                        _spin_lock_irq();
file_writer-10549 [001] 1291593.100432: funcgraph_entry:                   |                        schedule() {
file_writer-10549 [001] 1291593.100432: funcgraph_entry:        0.236 us   |                          rcu_sched_qs();
file_writer-10549 [001] 1291593.100432: funcgraph_entry:        0.152 us   |                          _spin_lock_irq();
file_writer-10549 [001] 1291593.100433: funcgraph_entry:                   |                          deactivate_task() {
file_writer-10549 [001] 1291593.100433: funcgraph_entry:                   |                            dequeue_task() {
file_writer-10549 [001] 1291593.100433: funcgraph_entry:                   |                              dequeue_task_fair() {
file_writer-10549 [001] 1291593.100433: funcgraph_entry:                   |                                dequeue_entity() {
file_writer-10549 [001] 1291593.100434: funcgraph_entry:                   |                                  update_curr() {
file_writer-10549 [001] 1291593.100434: funcgraph_entry:        0.351 us   |                                    task_of();
file_writer-10549 [001] 1291593.100434: funcgraph_exit:         0.862 us   |                                  }
file_writer-10549 [001] 1291593.100435: funcgraph_entry:        0.139 us   |                                  task_of();
file_writer-10549 [001] 1291593.100435: funcgraph_exit:         1.462 us   |                                }
file_writer-10549 [001] 1291593.100435: funcgraph_entry:        0.159 us   |                                hrtick_start_fair();
file_writer-10549 [001] 1291593.100435: funcgraph_exit:         2.188 us   |                              }
file_writer-10549 [001] 1291593.100435: funcgraph_exit:         2.627 us   |                            }
file_writer-10549 [001] 1291593.100436: funcgraph_exit:         2.934 us   |                          }
file_writer-10549 [001] 1291593.100436: funcgraph_entry:        0.138 us   |                          update_shares_locked();
file_writer-10549 [001] 1291593.100436: funcgraph_entry:                   |                          find_busiest_group() {
file_writer-10549 [001] 1291593.100436: funcgraph_entry:        0.144 us   |                            default_scale_smt_power();
file_writer-10549 [001] 1291593.100437: funcgraph_entry:                   |                            scale_rt_power() {
file_writer-10549 [001] 1291593.100437: funcgraph_entry:        0.140 us   |                              sched_avg_update();
file_writer-10549 [001] 1291593.100437: funcgraph_exit:         0.413 us   |                            }
file_writer-10549 [001] 1291593.100437: funcgraph_exit:         1.290 us   |                          }
file_writer-10549 [001] 1291593.100438: funcgraph_entry:        0.137 us   |                          msecs_to_jiffies();
file_writer-10549 [001] 1291593.100438: funcgraph_entry:        0.140 us   |                          update_shares_locked();
file_writer-10549 [001] 1291593.100438: funcgraph_entry:        0.502 us   |                          find_busiest_group();
file_writer-10549 [001] 1291593.100439: funcgraph_entry:        0.140 us   |                          msecs_to_jiffies();
file_writer-10549 [001] 1291593.100439: funcgraph_entry:        0.141 us   |                          update_shares_locked();
file_writer-10549 [001] 1291593.100439: funcgraph_entry:        0.706 us   |                          find_busiest_group();
file_writer-10549 [001] 1291593.100440: funcgraph_entry:        0.598 us   |                          find_busiest_queue();
file_writer-10549 [001] 1291593.100441: funcgraph_entry:        0.137 us   |                          msecs_to_jiffies();
file_writer-10549 [001] 1291593.100441: funcgraph_entry:        0.155 us   |                          put_prev_task_fair();
file_writer-10549 [001] 1291593.100442: funcgraph_entry:        0.152 us   |                          pick_next_task_fair();
file_writer-10549 [001] 1291593.100442: funcgraph_entry:        0.144 us   |                          pick_next_task_rt();
file_writer-10549 [001] 1291593.100442: funcgraph_entry:        0.149 us   |                          pick_next_task_fair();
file_writer-10549 [001] 1291593.100442: funcgraph_entry:        0.203 us   |                          pick_next_task_idle();
file_writer-10549 [001] 1291593.100443: funcgraph_entry:        0.143 us   |                          perf_event_task_sched_out();
file_writer-10549 [001] 1291593.100443: funcgraph_entry:                   |                          ftrace_raw_event_sched_switch() {
file_writer-10549 [001] 1291593.100443: sched_switch:         task file_writer:10549 [120] (D) ==> swapper:0 [120]
...

Finally xfslogd/1 wakes up the flush-8:0 process which releases the
xfs_ilock() waking up my file_writer process and allowing it to
continue.

...
xfslogd/1-213   [001] 1291593.158606: sched_wakeup:         task flush-8:0:601 [120] success=1 [011]
   <idle>-0     [011] 1291593.158609: sched_switch:         task swapper:0 [120] (R) ==> flush-8:0:601 [120]
flush-8:0-601   [011] 1291593.158623: funcgraph_entry:                   |  xfs_iunlock() {
flush-8:0-601   [011] 1291593.158623: funcgraph_entry:                   |    up_write() {
flush-8:0-601   [011] 1291593.158623: funcgraph_entry:        0.266 us   |      _spin_lock_irqsave();
flush-8:0-601   [011] 1291593.158624: funcgraph_entry:                   |      wake_up_process() {
flush-8:0-601   [011] 1291593.158624: funcgraph_entry:                   |        try_to_wake_up() {
flush-8:0-601   [011] 1291593.158625: funcgraph_entry:                   |          task_rq_lock() {
flush-8:0-601   [011] 1291593.158625: funcgraph_entry:        0.159 us   |            _spin_lock();
flush-8:0-601   [011] 1291593.158625: funcgraph_exit:         0.763 us   |          }
flush-8:0-601   [011] 1291593.158626: funcgraph_entry:        0.237 us   |          _spin_unlock_irqrestore();
flush-8:0-601   [011] 1291593.158626: funcgraph_entry:                   |          select_task_rq_fair() {
flush-8:0-601   [011] 1291593.158627: funcgraph_entry:        0.231 us   |            update_shares();
flush-8:0-601   [011] 1291593.158627: funcgraph_entry:        0.162 us   |            effective_load();
flush-8:0-601   [011] 1291593.158628: funcgraph_entry:        0.141 us   |            effective_load();
flush-8:0-601   [011] 1291593.158628: funcgraph_exit:         1.623 us   |          }
flush-8:0-601   [011] 1291593.158628: funcgraph_entry:                   |          task_rq_lock() {
flush-8:0-601   [011] 1291593.158628: funcgraph_entry:        0.142 us   |            _spin_lock();
flush-8:0-601   [011] 1291593.158628: funcgraph_exit:         0.420 us   |          }
flush-8:0-601   [011] 1291593.158629: funcgraph_entry:                   |          activate_task() {
flush-8:0-601   [011] 1291593.158629: funcgraph_entry:                   |            enqueue_task() {
flush-8:0-601   [011] 1291593.158629: funcgraph_entry:                   |              enqueue_task_fair() {
flush-8:0-601   [011] 1291593.158629: funcgraph_entry:                   |                enqueue_entity() {
flush-8:0-601   [011] 1291593.158630: funcgraph_entry:        0.277 us   |                  update_curr();
flush-8:0-601   [011] 1291593.158630: funcgraph_entry:        0.159 us   |                  place_entity();
flush-8:0-601   [011] 1291593.158630: funcgraph_entry:        0.137 us   |                  task_of();
flush-8:0-601   [011] 1291593.158631: funcgraph_entry:        0.172 us   |                  __enqueue_entity();
flush-8:0-601   [011] 1291593.158631: funcgraph_exit:         1.654 us   |                }
flush-8:0-601   [011] 1291593.158631: funcgraph_exit:         2.062 us   |              }
flush-8:0-601   [011] 1291593.158631: funcgraph_exit:         2.444 us   |            }
flush-8:0-601   [011] 1291593.158631: funcgraph_exit:         2.760 us   |          }
flush-8:0-601   [011] 1291593.158632: funcgraph_entry:                   |          ftrace_raw_event_sched_wakeup() {
flush-8:0-601   [011] 1291593.158632: sched_wakeup:         task file_writer:10549 [120] success=1 [001]
...

Looking back at the 2.6.18-128.7.1.el5 kernel I see that the old
kernel provided the following vm operations:

static struct vm_operations_struct xfs_file_vm_ops = {
        .nopage         = filemap_nopage,
        .populate       = filemap_populate,
};

Where the new kernels provides:

static struct vm_operations_struct xfs_file_vm_ops = {
        .nopage         = filemap_nopage,
        .populate       = filemap_populate,
        .page_mkwrite   = xfs_vm_page_mkwrite,
};

static const struct vm_operations_struct xfs_file_vm_ops = {
        .fault          = filemap_fault,
        .page_mkwrite   = xfs_vm_page_mkwrite,
};

So I can see that the xfs_vm_page_mkwrite is a new addition and this
is what is causing the stalls on the newer kernels.  I'll admit I know
very little about file systems, or the implications of these changes.
My question in general is what can we do to eliminate these latencies?

Thanks,
Shawn

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
