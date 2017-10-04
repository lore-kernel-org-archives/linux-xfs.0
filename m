Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752409AbdJDPoF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Oct 2017 11:44:05 -0400
Date: Wed, 4 Oct 2017 23:43:41 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [RFC 0/5] fs: replace kthread freezing with filesystem
 freeze/thaw
Message-ID: <20171004154340.GE9713@ming.t460p>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003193300.GD5362@ming.t460p>
 <20171003200511.GD2294@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003200511.GD2294@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 03, 2017 at 10:05:11PM +0200, Luis R. Rodriguez wrote:
> On Wed, Oct 04, 2017 at 03:33:01AM +0800, Ming Lei wrote:
> > On Tue, Oct 03, 2017 at 11:53:08AM -0700, Luis R. Rodriguez wrote:
> > > INFO: task kworker/u8:8:1320 blocked for more than 10 seconds.
> > >       Tainted: G            E   4.13.0-next-20170907+ #88
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > kworker/u8:8    D    0  1320      2 0x80000000
> > > Workqueue: events_unbound async_run_entry_fn
> > > Call Trace:
> > >  __schedule+0x2ec/0x7a0
> > >  schedule+0x36/0x80
> > >  io_schedule+0x16/0x40
> > >  get_request+0x278/0x780
> > >  ? remove_wait_queue+0x70/0x70
> > >  blk_get_request+0x9c/0x110
> > >  scsi_execute+0x7a/0x310 [scsi_mod]
> > >  sd_sync_cache+0xa3/0x190 [sd_mod]
> > >  ? blk_run_queue+0x3f/0x50
> > >  sd_suspend_common+0x7b/0x130 [sd_mod]
> > >  ? scsi_print_result+0x270/0x270 [scsi_mod]
> > >  sd_suspend_system+0x13/0x20 [sd_mod]
> > >  do_scsi_suspend+0x1b/0x30 [scsi_mod]
> > >  scsi_bus_suspend_common+0xb1/0xd0 [scsi_mod]
> > >  ? device_for_each_child+0x69/0x90
> > >  scsi_bus_suspend+0x15/0x20 [scsi_mod]
> > >  dpm_run_callback+0x56/0x140
> > >  ? scsi_bus_freeze+0x20/0x20 [scsi_mod]
> > >  __device_suspend+0xf1/0x340
> > >  async_suspend+0x1f/0xa0
> > >  async_run_entry_fn+0x38/0x160
> > >  process_one_work+0x191/0x380
> > >  worker_thread+0x4e/0x3c0
> > >  kthread+0x109/0x140
> > >  ? process_one_work+0x380/0x380
> > >  ? kthread_create_on_node+0x70/0x70
> > >  ret_from_fork+0x25/0x30
> > 
> > Actually we are trying to fix this issue inside block layer/SCSI, please
> > see the following link:
> > 
> > https://marc.info/?l=linux-scsi&m=150703947029304&w=2
> > 
> > Even though this patch can make kthread to not do I/O during
> > suspend/resume, the SCSI quiesce still can cause similar issue
> > in other case, like when sending SCSI domain validation
> > to transport_spi, which happens in revalidate path, nothing
> > to do with suspend/resume.
> 
> Are you saying that the SCSI layer can generate IO even without the filesystem
> triggering it?

Yes, such as sg_io, in case of transport_spi, actually with SCSI
quiesced involved in the revalidate path, not related with PM.

> 
> If so then by all means these are certainly other areas we should address
> quiescing as I noted in my email.
> 
> Also, *iff* the generated IO is triggered on the SCSI suspend callback, then
> clearly the next question is if this is truly needed. If so then yes, it
> should be quiesced and all restrictions should be considered.
> 
> Note that device pm ops get called first, then later the notifiers are
> processed, and only later is userspace frozen. Its this gap this patch
> set addresses, and its also where where I saw the issue creep in. Depending on
> the questions above we may or not need more work in other layers.
> 
> So I am not saying this patch set is sufficient to address all IO quiescing,
> quite the contrary I acknowledged that each subsystem should vet if they have
> non-FS generated IO (seems you and Bart are doing  great job at doing this
> analysis on SCSI). This patchset however should help with odd corner cases
> which *are* triggered by the FS and the spaghetti code requirements of the
> kthread freezing clearly does not suffice.

Could you share us a bit what the odd corner case is?

> 
> > So IMO the root cause is in SCSI's quiesce.
> > 
> > You can find the similar description in above link:
> > 
> > 	Once SCSI device is put into QUIESCE, no new request except for
> > 	RQF_PREEMPT can be dispatched to SCSI successfully, and
> > 	scsi_device_quiesce() just simply waits for completion of I/Os
> > 	dispatched to SCSI stack. It isn't enough at all.
> 
> I see so the race here is *on* the pm ops of SCSI we have generated IO
> to QUIESCE.
> 
> > 
> > 	Because new request still can be coming, but all the allocated
> > 	requests can't be dispatched successfully, so request pool can be
> > 	consumed up easily. Then RQF_PREEMPT can't be allocated, and
> > 	hang forever, just like the stack trace you posted.
> > 
> 
> I see. Makes sense. So SCSI quiesce has restrictions and they're being
> violated.
> 
> Anyway, don't think of this as a replacement for yours or Bart's work then, but
> rather supplemental.
> 
> Are you saying we should not move forward with this patch set, or simply that
> the above splat is rather properly fixed with SCSI quiescing? Given you're
> explanation I'd have to agree. But even with this considered and accepted, from
> a theoretical perspective -- why would this patch set actually seem to fix the
> same issue? Is it, that it just *seems* to fix it?

Actually it is just because you posted out the very same stack trace,
and I am pretty sure that is caused by SCSI quiesce vs. RQF_PREEMPT.

Also IMO, SCSI quiesce vs. RQF_PREEMPT is one specific case wrt.
IO hang, and maybe there isn't same case on other disks. If that is
true, even without any change in kthread freeze, the patchset of
'making SCSI quiesce safe' should be enough for avoiding IO hang
in PM suspend/resume.

But I still don't understand your real motivation of this patchset
completely yet, is it only for avoiding I/O hang? Or is there other
purposes?  Looks I need to dig into more the patches.

-- 
Ming
