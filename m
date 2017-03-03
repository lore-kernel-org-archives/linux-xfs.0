Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751333AbdCCNKz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 08:10:55 -0500
Date: Fri, 3 Mar 2017 08:00:13 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS failure in 4.10+
Message-ID: <20170303130012.GB21245@bfoster.bfoster>
References: <b1cfa7e4-34e0-ce7b-c65e-cfff6c6c3a3a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1cfa7e4-34e0-ce7b-c65e-cfff6c6c3a3a@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Thu, Mar 02, 2017 at 07:38:10PM -0700, Jens Axboe wrote:
> Hi,
> 
> Wanted to run some stability testing before sending in a pull
> request, and I get the below failure running generic/388 in
> the xfstest suite.
> 
> I'm on top of git as of earlier today, 821fd6f6cb65.
> 
> My local.config contains:
> 
> export TEST_DEV=/dev/nvme2n1p1
> export TEST_DIR=/mnt/test
> export SCRATCH_DEV=/dev/nvme4n1p1
> export SCRATCH_MNT=/mnt/scratch
> 
> dmesg output:
> 
> [ 8064.504559] run fstests generic/388 at 2017-03-02 18:07:40
> [ 8069.448841] XFS (nvme4n1p1): Mounting V4 Filesystem
> [ 8069.499344] XFS (nvme4n1p1): Ending clean mount
> [ 8069.521916] XFS (nvme4n1p1): Unmounting Filesystem
> [ 8073.306973] XFS (nvme4n1p1): Mounting V4 Filesystem
> [ 8073.316757] XFS (nvme4n1p1): Ending clean mount
> [ 8075.650699] XFS (nvme4n1p1): Unmounting Filesystem
> [ 8075.683976] XFS (nvme4n1p1): Mounting V4 Filesystem
> [ 8075.714329] XFS (nvme4n1p1): Starting recovery (logdev: internal)
> [ 8077.271261] XFS (nvme4n1p1): Ending recovery (logdev: internal)
> [ 8077.287136] XFS (nvme4n1p1): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
> [ 8077.483879] XFS (nvme4n1p1): Unmounting Filesystem
> [ 8077.513120] XFS (nvme4n1p1): Mounting V4 Filesystem
> [ 8077.531542] XFS (nvme4n1p1): Starting recovery (logdev: internal)
> [ 8077.548649] XFS (nvme4n1p1): Ending recovery (logdev: internal)
> [ 8079.704869] XFS (nvme4n1p1): Unmounting Filesystem
> [ 8079.736950] XFS (nvme4n1p1): Mounting V4 Filesystem
> [ 8079.786530] XFS (nvme4n1p1): Starting recovery (logdev: internal)
> [ 8081.394221] XFS (nvme4n1p1): Ending recovery (logdev: internal)
> [ 8083.411129] XFS (nvme4n1p1): xfs_do_force_shutdown(0x1) called from line 236 of file fs/xfs/libxfs/xfs_defer.c.  Return address = 0xffffffffa02313a1
> [ 8083.426496] buffer_io_error: 67587 callbacks suppressed
> [ 8083.432580] Buffer I/O error on dev nvme4n1p1, logical block 30554374, lost async page write
> [ 8083.442495] Buffer I/O error on dev nvme4n1p1, logical block 30554375, lost async page write
> [ 8083.452401] Buffer I/O error on dev nvme4n1p1, logical block 30554376, lost async page write
> [ 8083.462300] Buffer I/O error on dev nvme4n1p1, logical block 30554377, lost async page write
> [ 8083.472221] Buffer I/O error on dev nvme4n1p1, logical block 30554378, lost async page write
> [ 8083.482118] Buffer I/O error on dev nvme4n1p1, logical block 30554379, lost async page write
> [ 8083.492019] Buffer I/O error on dev nvme4n1p1, logical block 30554380, lost async page write
> [ 8083.502548] Buffer I/O error on dev nvme4n1p1, logical block 30554381, lost async page write
> [ 8083.512457] Buffer I/O error on dev nvme4n1p1, logical block 30554382, lost async page write
> [ 8083.522364] Buffer I/O error on dev nvme4n1p1, logical block 30554383, lost async page write
> [ 8083.558611] BUG: spinlock bad magic on CPU#27, kworker/27:25/31042
> [ 8083.565857] general protection fault: 0000 [#1] PREEMPT SMP
> [ 8083.572322] Modules linked in: loop dm_mod xfs libcrc32c x86_pkg_temp_thermal btrfs xor zlib_deflate raid6_pq sr_mod cdrom sd_mod igb ahci i2c_algo_bit libahci dca nvme libata nvme_core
> [ 8083.591520] CPU: 27 PID: 31042 Comm: kworker/27:25 Tainted: G        W       4.10.0+ #242
> [ 8083.601134] Hardware name: Dell Inc. PowerEdge T630/0NT78X, BIOS 2.3.4 11/09/2016
> [ 8083.610052] Workqueue: xfs-cil/nvme4n1p1 xlog_cil_push_work [xfs]
> [ 8083.617106] task: ffff883feb9d0f40 task.stack: ffff883ef3428000
> [ 8083.623968] RIP: 0010:spin_dump+0x4c/0xd0
> [ 8083.628681] RSP: 0018:ffff883ef342ba78 EFLAGS: 00010002
> [ 8083.634760] RAX: 0000000000000036 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000002
> [ 8083.642969] RDX: 0000000080000002 RSI: ffffffff81a0b368 RDI: 00000000ffffffff
> [ 8083.651270] RBP: ffff883ef342ba88 R08: 0000000000000000 R09: 000000006b6b6b6b
> [ 8083.659484] R10: ffffffff81c07a80 R11: 00000000ffffffff R12: ffff883fed44c160
> [ 8083.667691] R13: 0000000000000004 R14: 0000000000000001 R15: ffff883e9c763848
> [ 8083.675903] FS:  0000000000000000(0000) GS:ffff883fff140000(0000) knlGS:0000000000000000
> [ 8083.685405] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 8083.692048] CR2: 00007f95d83533a8 CR3: 0000001fd08d6000 CR4: 00000000003406e0
> [ 8083.700257] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 8083.708451] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 8083.716659] Call Trace:
> [ 8083.719623]  do_raw_spin_lock+0x6d/0xb0
> [ 8083.724140]  _raw_spin_lock_irqsave+0x1f/0x30
> [ 8083.729242]  up+0x11/0x50
> [ 8083.732435]  xfs_buf_unlock+0x15/0x80 [xfs]
> [ 8083.737367]  xfs_buf_item_unpin+0x15f/0x220 [xfs]
> [ 8083.742895]  xfs_trans_committed_bulk+0x16a/0x260 [xfs]
> [ 8083.748970]  ? __save_stack_trace+0x6e/0xd0
> [ 8083.753911]  ? xfs_log_ticket_put+0x1a/0x20 [xfs]
> [ 8083.759406]  ? debug_smp_processor_id+0x17/0x20
> [ 8083.764688]  ? set_track+0x84/0x100
> [ 8083.768815]  ? _raw_spin_unlock_irqrestore+0x19/0x30
> [ 8083.774594]  ? free_debug_processing+0x294/0x3e0
> [ 8083.779979]  ? preempt_count_add+0xa3/0xc0
> [ 8083.784785]  ? _raw_spin_unlock_irqrestore+0x19/0x30
> [ 8083.790562]  ? __slab_free+0x1cf/0x2f0
> [ 8083.795016]  xlog_cil_committed+0x3a/0x300 [xfs]

So we're pushing the cil and calling the committed handler from the push
context, which probably means abort due to filesystem shutdown. This
test actually repeatedly induces filesystem shutdowns to test out log
recovery.

We eventually get to xfs_buf_unlock() and for some reason crash on the
internal spinlock for the semaphore. My first guess would be a use after
free or some such due to broken reference counting on a buffer in the
shutdown path. Could you send your kernel config file?

Also, is this reproducible or a one-off? Do you hit it only with nvme
devices? Thanks.

Brian

> [ 8083.800403]  ? kmem_cache_free+0x165/0x180
> [ 8083.805247]  xlog_cil_push+0x3e4/0x420 [xfs]
> [ 8083.810286]  xlog_cil_push_work+0x10/0x20 [xfs]
> [ 8083.815580]  process_one_work+0x18e/0x450
> [ 8083.820289]  worker_thread+0x49/0x4a0
> [ 8083.824611]  kthread+0x107/0x140
> [ 8083.828442]  ? process_one_work+0x450/0x450
> [ 8083.833345]  ? kthread_create_on_node+0x40/0x40
> [ 8083.838638]  ret_from_fork+0x29/0x40
> [ 8083.842860] Code: 44 8b 80 20 04 00 00 48 8d 88 d0 05 00 00 48 c7 c7 c8 9d 9b 81 65 8b 15 2b df f4 7e e8 b2 20 08 00 48 85 db 45 8b 4c 24 08 74 6a <44> 8b 83 20 04 00 00 48 8d 8b d0 05 00 00 41 8b 54 24 04 4c 89 
> [ 8083.864766] RIP: spin_dump+0x4c/0xd0 RSP: ffff883ef342ba78
> [ 8083.871680] ---[ end trace 48ff5b1f0b9378e8 ]---
> [ 8083.877136] Kernel panic - not syncing: Fatal exception
> [ 8083.883389] Kernel Offset: disabled
> [ 8083.887601] ---[ end Kernel panic - not syncing: Fatal exception
> 
> -- 
> Jens Axboe
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
