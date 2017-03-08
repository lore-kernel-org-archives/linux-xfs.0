Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751924AbdCHP3o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 10:29:44 -0500
Date: Wed, 8 Mar 2017 10:19:36 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS failure in 4.10+
Message-ID: <20170308151936.GD23404@bfoster.bfoster>
References: <b1cfa7e4-34e0-ce7b-c65e-cfff6c6c3a3a@kernel.dk>
 <20170303130012.GB21245@bfoster.bfoster>
 <ffedba33-31d4-ee99-e385-72a0fcff8a77@kernel.dk>
 <a21b36b3-7a81-3bb4-175a-3164a169d831@kernel.dk>
 <20170303170353.GD21245@bfoster.bfoster>
 <01ebf482-e818-f802-a541-10ba52b5cb28@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01ebf482-e818-f802-a541-10ba52b5cb28@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Fri, Mar 03, 2017 at 10:45:10AM -0700, Jens Axboe wrote:
> On 03/03/2017 10:03 AM, Brian Foster wrote:
> > On Fri, Mar 03, 2017 at 08:13:43AM -0700, Jens Axboe wrote:
> >> On 03/03/2017 08:04 AM, Jens Axboe wrote:
> >>> On 03/03/2017 06:00 AM, Brian Foster wrote:
> >>>> On Thu, Mar 02, 2017 at 07:38:10PM -0700, Jens Axboe wrote:
> >>>>> Hi,
> >>>>>
> >>>>> Wanted to run some stability testing before sending in a pull
> >>>>> request, and I get the below failure running generic/388 in
> >>>>> the xfstest suite.
> >>>>>
> >>>>> I'm on top of git as of earlier today, 821fd6f6cb65.
> >>>>>
> >>>>> My local.config contains:
> >>>>>
> >>>>> export TEST_DEV=/dev/nvme2n1p1
> >>>>> export TEST_DIR=/mnt/test
> >>>>> export SCRATCH_DEV=/dev/nvme4n1p1
> >>>>> export SCRATCH_MNT=/mnt/scratch
> >>>>>
> >>>>> dmesg output:
> >>>>>
> >>>>> [ 8064.504559] run fstests generic/388 at 2017-03-02 18:07:40
> >>>>> [ 8069.448841] XFS (nvme4n1p1): Mounting V4 Filesystem
> >>>>> [ 8069.499344] XFS (nvme4n1p1): Ending clean mount
> >>>>> [ 8069.521916] XFS (nvme4n1p1): Unmounting Filesystem
> >>>>> [ 8073.306973] XFS (nvme4n1p1): Mounting V4 Filesystem
> >>>>> [ 8073.316757] XFS (nvme4n1p1): Ending clean mount
> >>>>> [ 8075.650699] XFS (nvme4n1p1): Unmounting Filesystem
> >>>>> [ 8075.683976] XFS (nvme4n1p1): Mounting V4 Filesystem
> >>>>> [ 8075.714329] XFS (nvme4n1p1): Starting recovery (logdev: internal)
> >>>>> [ 8077.271261] XFS (nvme4n1p1): Ending recovery (logdev: internal)
> >>>>> [ 8077.287136] XFS (nvme4n1p1): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
> >>>>> [ 8077.483879] XFS (nvme4n1p1): Unmounting Filesystem
> >>>>> [ 8077.513120] XFS (nvme4n1p1): Mounting V4 Filesystem
> >>>>> [ 8077.531542] XFS (nvme4n1p1): Starting recovery (logdev: internal)
> >>>>> [ 8077.548649] XFS (nvme4n1p1): Ending recovery (logdev: internal)
> >>>>> [ 8079.704869] XFS (nvme4n1p1): Unmounting Filesystem
> >>>>> [ 8079.736950] XFS (nvme4n1p1): Mounting V4 Filesystem
> >>>>> [ 8079.786530] XFS (nvme4n1p1): Starting recovery (logdev: internal)
> >>>>> [ 8081.394221] XFS (nvme4n1p1): Ending recovery (logdev: internal)
> >>>>> [ 8083.411129] XFS (nvme4n1p1): xfs_do_force_shutdown(0x1) called from line 236 of file fs/xfs/libxfs/xfs_defer.c.  Return address = 0xffffffffa02313a1
> >>>>> [ 8083.426496] buffer_io_error: 67587 callbacks suppressed
> >>>>> [ 8083.432580] Buffer I/O error on dev nvme4n1p1, logical block 30554374, lost async page write
> >>>>> [ 8083.442495] Buffer I/O error on dev nvme4n1p1, logical block 30554375, lost async page write
> >>>>> [ 8083.452401] Buffer I/O error on dev nvme4n1p1, logical block 30554376, lost async page write
> >>>>> [ 8083.462300] Buffer I/O error on dev nvme4n1p1, logical block 30554377, lost async page write
> >>>>> [ 8083.472221] Buffer I/O error on dev nvme4n1p1, logical block 30554378, lost async page write
> >>>>> [ 8083.482118] Buffer I/O error on dev nvme4n1p1, logical block 30554379, lost async page write
> >>>>> [ 8083.492019] Buffer I/O error on dev nvme4n1p1, logical block 30554380, lost async page write
> >>>>> [ 8083.502548] Buffer I/O error on dev nvme4n1p1, logical block 30554381, lost async page write
> >>>>> [ 8083.512457] Buffer I/O error on dev nvme4n1p1, logical block 30554382, lost async page write
> >>>>> [ 8083.522364] Buffer I/O error on dev nvme4n1p1, logical block 30554383, lost async page write
> >>>>> [ 8083.558611] BUG: spinlock bad magic on CPU#27, kworker/27:25/31042
> >>>>> [ 8083.565857] general protection fault: 0000 [#1] PREEMPT SMP
> >>>>> [ 8083.572322] Modules linked in: loop dm_mod xfs libcrc32c x86_pkg_temp_thermal btrfs xor zlib_deflate raid6_pq sr_mod cdrom sd_mod igb ahci i2c_algo_bit libahci dca nvme libata nvme_core
> >>>>> [ 8083.591520] CPU: 27 PID: 31042 Comm: kworker/27:25 Tainted: G        W       4.10.0+ #242
> >>>>> [ 8083.601134] Hardware name: Dell Inc. PowerEdge T630/0NT78X, BIOS 2.3.4 11/09/2016
> >>>>> [ 8083.610052] Workqueue: xfs-cil/nvme4n1p1 xlog_cil_push_work [xfs]
> >>>>> [ 8083.617106] task: ffff883feb9d0f40 task.stack: ffff883ef3428000
> >>>>> [ 8083.623968] RIP: 0010:spin_dump+0x4c/0xd0
> >>>>> [ 8083.628681] RSP: 0018:ffff883ef342ba78 EFLAGS: 00010002
> >>>>> [ 8083.634760] RAX: 0000000000000036 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000002
> >>>>> [ 8083.642969] RDX: 0000000080000002 RSI: ffffffff81a0b368 RDI: 00000000ffffffff
> >>>>> [ 8083.651270] RBP: ffff883ef342ba88 R08: 0000000000000000 R09: 000000006b6b6b6b
> >>>>> [ 8083.659484] R10: ffffffff81c07a80 R11: 00000000ffffffff R12: ffff883fed44c160
> >>>>> [ 8083.667691] R13: 0000000000000004 R14: 0000000000000001 R15: ffff883e9c763848
> >>>>> [ 8083.675903] FS:  0000000000000000(0000) GS:ffff883fff140000(0000) knlGS:0000000000000000
> >>>>> [ 8083.685405] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>>>> [ 8083.692048] CR2: 00007f95d83533a8 CR3: 0000001fd08d6000 CR4: 00000000003406e0
> >>>>> [ 8083.700257] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >>>>> [ 8083.708451] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >>>>> [ 8083.716659] Call Trace:
> >>>>> [ 8083.719623]  do_raw_spin_lock+0x6d/0xb0
> >>>>> [ 8083.724140]  _raw_spin_lock_irqsave+0x1f/0x30
> >>>>> [ 8083.729242]  up+0x11/0x50
> >>>>> [ 8083.732435]  xfs_buf_unlock+0x15/0x80 [xfs]
> >>>>> [ 8083.737367]  xfs_buf_item_unpin+0x15f/0x220 [xfs]
> >>>>> [ 8083.742895]  xfs_trans_committed_bulk+0x16a/0x260 [xfs]
> >>>>> [ 8083.748970]  ? __save_stack_trace+0x6e/0xd0
> >>>>> [ 8083.753911]  ? xfs_log_ticket_put+0x1a/0x20 [xfs]
> >>>>> [ 8083.759406]  ? debug_smp_processor_id+0x17/0x20
> >>>>> [ 8083.764688]  ? set_track+0x84/0x100
> >>>>> [ 8083.768815]  ? _raw_spin_unlock_irqrestore+0x19/0x30
> >>>>> [ 8083.774594]  ? free_debug_processing+0x294/0x3e0
> >>>>> [ 8083.779979]  ? preempt_count_add+0xa3/0xc0
> >>>>> [ 8083.784785]  ? _raw_spin_unlock_irqrestore+0x19/0x30
> >>>>> [ 8083.790562]  ? __slab_free+0x1cf/0x2f0
> >>>>> [ 8083.795016]  xlog_cil_committed+0x3a/0x300 [xfs]
> >>>>
> >>>> So we're pushing the cil and calling the committed handler from the push
> >>>> context, which probably means abort due to filesystem shutdown. This
> >>>> test actually repeatedly induces filesystem shutdowns to test out log
> >>>> recovery.
> >>>>
> >>>> We eventually get to xfs_buf_unlock() and for some reason crash on the
> >>>> internal spinlock for the semaphore. My first guess would be a use after
> >>>> free or some such due to broken reference counting on a buffer in the
> >>>> shutdown path. Could you send your kernel config file?
> >>>
> >>> Attached.
> >>>
> >>>> Also, is this reproducible or a one-off? Do you hit it only with nvme
> >>>> devices? Thanks.
> >>>
> >>> Just ran it twice, manually, and it didn't reproduce. I'm going to
> >>> enable free poisoning and lockdep and re-run, see if that catches
> >>> anything. I haven't run it on non-flash.
> >>
> >> First run after doing that, and we hit someone that fiddles a bit in
> >> memory that has been freed - spot the 0x6a below. This is definitely a
> >> regression in this merge window.
> >>
> > 
> > Ok, I can reproduce this one with memory poisoning and slub debug
> > enabled. That said, I'm not sure this is related to the original report.
> > Indeed, I can reproduce this one based on a late v4.10 rc kernel.
> > 
> > Do you not see any other issues similar to the original report (related
> > to xfs_buf's perhaps) with this configuration? What's the basis for this
> > being isolated to this merge window?
> 
> I've run a lot of xfstest for testing the new scheduler framework, and I
> haven't seen either of these before. So my assumption was that it's new
> in this merge window. I'm running a bisect now to check.
> 

Ever get anywhere with this?

Brian

> -- 
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
