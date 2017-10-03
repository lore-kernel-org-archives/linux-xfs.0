Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53042 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdJCTdX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 15:33:23 -0400
Date: Wed, 4 Oct 2017 03:33:01 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [RFC 0/5] fs: replace kthread freezing with filesystem
 freeze/thaw
Message-ID: <20171003193300.GD5362@ming.t460p>
References: <20171003185313.1017-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003185313.1017-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 03, 2017 at 11:53:08AM -0700, Luis R. Rodriguez wrote:
> At the 2015 South Korea kernel summit Jiri Kosina had pointd out the issue of
> the sloppy semantics of the kthread freezer, lwn covered this pretty well [0].
> In short, he explained how the original purpose of the freezer was to aid
> in going to suspend to ensure no uwanted IO activity would cause filesystem
> corruption. Kernel kthreads require special freezer handling though, the call
> try_to_freeze() is often sprinkled at strategic places, but sometimes this is
> done without set_freezable() making try_to_freeze() useless. Other helpers such
> as freezable_schedule_timeout() exist, and very likely they are not used in any
> consistent and proper way either all over the kernel. Dealing with these
> helpers alone also does not and cannot ensure that everything that has been
> spawned asynchronously from a kthread (such as timers) are stopped as well,
> these are left to the kthread user implementation, and chances are pretty high
> there are many bugs lurking here. There are even non-IO bounds kthreads now
> using the freezer APIs, where this is not even needed!
> 
> Jiri suggested we can easily replace the complexities of the kthread freezer
> by just using the existing filesystem freeze/thaw callbacks on hibernation and
> suspend.
> 
> I've picked up Jiri's work given there are bugs which after inspection don't
> see like real bugs, but just random IO loosely waiting to be completed and the
> kernel not really being able to tell me who the culprit is. In fact even if one
> plugs a fix, one ends up in another random place and its really unclear who is
> to blaim for next.
> 
> For instance, to reproduce a simple suspend bug on what may at first seem to be
> an XFS bug, one can issue a dd onto disk prior to suspend, and we'll get a
> stall on our way to suspend, claiming the issue was the SCSI layer not being
> able to quiesce the disk. This was reported on OpenSUSE and reproduced on
> linux-next easily [1]. The following script can be run while we loop on
> systemctl suspend and qemu system_wakeup calls to resume:
> 
> 	while true; do
> 		dd if=/dev/zero of=crap bs=1M count=1024 &> /dev/null
> 	done
> 
> You end up with with a hung suspend attempt, and eventually a splat
> as follows with a hunk task notification:
> 
> INFO: task kworker/u8:8:1320 blocked for more than 10 seconds.
>       Tainted: G            E   4.13.0-next-20170907+ #88
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/u8:8    D    0  1320      2 0x80000000
> Workqueue: events_unbound async_run_entry_fn
> Call Trace:
>  __schedule+0x2ec/0x7a0
>  schedule+0x36/0x80
>  io_schedule+0x16/0x40
>  get_request+0x278/0x780
>  ? remove_wait_queue+0x70/0x70
>  blk_get_request+0x9c/0x110
>  scsi_execute+0x7a/0x310 [scsi_mod]
>  sd_sync_cache+0xa3/0x190 [sd_mod]
>  ? blk_run_queue+0x3f/0x50
>  sd_suspend_common+0x7b/0x130 [sd_mod]
>  ? scsi_print_result+0x270/0x270 [scsi_mod]
>  sd_suspend_system+0x13/0x20 [sd_mod]
>  do_scsi_suspend+0x1b/0x30 [scsi_mod]
>  scsi_bus_suspend_common+0xb1/0xd0 [scsi_mod]
>  ? device_for_each_child+0x69/0x90
>  scsi_bus_suspend+0x15/0x20 [scsi_mod]
>  dpm_run_callback+0x56/0x140
>  ? scsi_bus_freeze+0x20/0x20 [scsi_mod]
>  __device_suspend+0xf1/0x340
>  async_suspend+0x1f/0xa0
>  async_run_entry_fn+0x38/0x160
>  process_one_work+0x191/0x380
>  worker_thread+0x4e/0x3c0
>  kthread+0x109/0x140
>  ? process_one_work+0x380/0x380
>  ? kthread_create_on_node+0x70/0x70
>  ret_from_fork+0x25/0x30

Actually we are trying to fix this issue inside block layer/SCSI, please
see the following link:

https://marc.info/?l=linux-scsi&m=150703947029304&w=2

Even though this patch can make kthread to not do I/O during
suspend/resume, the SCSI quiesce still can cause similar issue
in other case, like when sending SCSI domain validation
to transport_spi, which happens in revalidate path, nothing
to do with suspend/resume.

So IMO the root cause is in SCSI's quiesce.

You can find the similar description in above link:

	Once SCSI device is put into QUIESCE, no new request except for
	RQF_PREEMPT can be dispatched to SCSI successfully, and
	scsi_device_quiesce() just simply waits for completion of I/Os
	dispatched to SCSI stack. It isn't enough at all.

	Because new request still can be coming, but all the allocated
	requests can't be dispatched successfully, so request pool can be
	consumed up easily. Then RQF_PREEMPT can't be allocated, and
	hang forever, just like the stack trace you posted.

-- 
Ming
