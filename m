Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p87MFFuA187219 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 17:15:15 -0500
Received: from peace.netnation.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 742331416523
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2011 15:15:12 -0700 (PDT)
Received: from peace.netnation.com (peace.netnation.com [204.174.223.2]) by
	cuda.sgi.com with ESMTP id gwavKR4TEsHgrcP4 for
	<xfs@oss.sgi.com>; Wed, 07 Sep 2011 15:15:12 -0700 (PDT)
Date: Wed, 7 Sep 2011 15:15:05 -0700
From: Simon Kirby <sim@hostway.ca>
Subject: [3.1-rc4] XFS+DRBD hangs
Message-ID: <20110907221505.GC21603@hostway.ca>
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
To: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, xfs@oss.sgi.com

We will try again with most recent Linus HEAD, but with a build of Linus
e9208a4eec8acbde7ede6516c39dea05f3b700dc (3.1-rc4), we are seeing awesome
VM performance (low memory fragmentation, good caching), followed quickly
by a hard lockup. APEI and pstore stuff just doesn't seem to like this
PowerEdge 2950 (ERST: Failed to get Error Log Address Range.), so this
was captured over an old-fashioned serial cable:

[   93.004364] block drbd0: Resync done (total 52 sec; paused 0 sec; 3884 K/sec)
[   93.008004] block drbd0: updated UUIDs D1D6A96AAE5E394E:0000000000000000:264787A8207F2376:7E86E22A1F92B7FB
[   93.008004] block drbd0: conn( SyncTarget -> Connected ) disk( Inconsistent -> UpToDate ) 
[   93.030394] block drbd0: helper command: /sbin/drbdadm after-resync-target minor-0
[   93.044631] block drbd0: helper command: /sbin/drbdadm after-resync-target minor-0 exit code 0 (0x0)
[   93.102981] block drbd0: bitmap WRITE of 3382 pages took 10 jiffies
[   93.109462] block drbd0: 0 KB (0 bits) marked out-of-sync by on disk bit-map.
[ 1114.600102] block drbd0: peer( Primary -> Secondary ) 
[ 1114.904031] block drbd0: role( Secondary -> Primary ) 
[ 1115.284503] XFS (drbd0): Mounting Filesystem
[ 1115.928766] XFS (drbd0): Ending clean mount
[ 1116.324036] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[ 1116.336050] NFSD: starting 90-second grace period
[ 1532.427149] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 1
[ 1532.427149] Pid: 3590, comm: lmtp Not tainted 3.1.0-rc4-hw+ #28
[ 1532.427149] Call Trace:
[ 1532.427149]  <NMI>  [<ffffffff816aa954>] panic+0xba/0x1f5
[ 1532.427149]  [<ffffffff8108f6d1>] watchdog_overflow_callback+0xb1/0xc0
[ 1532.427149]  [<ffffffff810bb442>] __perf_event_overflow+0xa2/0x1f0
[ 1532.427149]  [<ffffffff810b4981>] ? perf_event_update_userpage+0x11/0xc0
[ 1532.427149]  [<ffffffff810bb994>] perf_event_overflow+0x14/0x20
[ 1532.427149]  [<ffffffff81014bcb>] intel_pmu_handle_irq+0x21b/0x460
[ 1532.427149]  [<ffffffff816af286>] perf_event_nmi_handler+0x36/0xb0
[ 1532.427149]  [<ffffffff816b132f>] notifier_call_chain+0x3f/0x80
[ 1532.427149]  [<ffffffff816b1395>] atomic_notifier_call_chain+0x15/0x20
[ 1532.427149]  [<ffffffff816b13ce>] notify_die+0x2e/0x30
[ 1532.427149]  [<ffffffff816ae9e2>] do_nmi+0xa2/0x250
[ 1532.427149]  [<ffffffff816ae3ca>] nmi+0x1a/0x20
[ 1532.427149]  [<ffffffff8103d512>] ? try_to_wake_up+0xc2/0x270
[ 1532.427149]  <<EOE>>  <IRQ>  [<ffffffff8103d6cd>] default_wake_function+0xd/0x10
[ 1532.427149]  [<ffffffff81067041>] autoremove_wake_function+0x11/0x40
[ 1532.427149]  [<ffffffff8103075a>] __wake_up_common+0x5a/0x90
[ 1532.427149]  [<ffffffff81037c43>] __wake_up+0x43/0x70
[ 1532.427149]  [<ffffffffa0060579>] drbd_al_complete_io+0x99/0xd0 [drbd]
[ 1532.427149]  [<ffffffffa005b9b5>] _req_may_be_done+0x325/0x560 [drbd]
[ 1532.427149]  [<ffffffff810fabe1>] ? kmem_cache_free+0xe1/0xf0
[ 1532.427149]  [<ffffffffa005bc0d>] _req_may_be_done_not_susp+0x1d/0x30 [drbd]
[ 1532.427149]  [<ffffffffa005c0cb>] __req_mod+0x4ab/0xee0 [drbd]
[ 1532.427149]  [<ffffffffa004f22e>] drbd_endio_pri+0xae/0x120 [drbd]
[ 1532.427149]  [<ffffffff81130b6c>] bio_endio+0x1c/0x40
[ 1532.427149]  [<ffffffff813737d3>] req_bio_endio+0x83/0xb0
[ 1532.427149]  [<ffffffff81373900>] blk_update_request+0x100/0x470
[ 1532.427149]  [<ffffffff81373c92>] blk_update_bidi_request+0x22/0x90
[ 1532.427149]  [<ffffffff81374e5a>] blk_end_bidi_request+0x2a/0x80
[ 1532.427149]  [<ffffffff81374efb>] blk_end_request+0xb/0x10
[ 1532.427149]  [<ffffffff8146744d>] scsi_io_completion+0x11d/0x620
[ 1532.427149]  [<ffffffff8145f2ff>] scsi_finish_command+0xbf/0x120
[ 1532.427149]  [<ffffffff81467a9e>] scsi_softirq_done+0x13e/0x160
[ 1532.427149]  [<ffffffff8137ab7d>] blk_done_softirq+0x6d/0x80
[ 1532.427149]  [<ffffffff8104d0f0>] __do_softirq+0xd0/0x1c0
[ 1532.427149]  [<ffffffff816b726c>] call_softirq+0x1c/0x30
[ 1532.427149]  [<ffffffff81004035>] do_softirq+0x55/0x90
[ 1532.427149]  [<ffffffff8104ce2d>] irq_exit+0xad/0xe0
[ 1532.427149]  [<ffffffff81003824>] do_IRQ+0x64/0xe0
[ 1532.427149]  [<ffffffff816adf6b>] common_interrupt+0x6b/0x6b
[ 1532.427149]  <EOI> 
[ 1545.171011] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0
[ 1545.171011] Pid: 20283, comm: xfsbufd/drbd0 Not tainted 3.1.0-rc4-hw+ #28
[ 1545.171011] Call Trace:
[ 1545.171011]  <NMI>  [<ffffffff816aa954>] panic+0xba/0x1f5
[ 1545.171011]  [<ffffffff8108f6d1>] watchdog_overflow_callback+0xb1/0xc0
[ 1545.171011]  [<ffffffff810bb442>] __perf_event_overflow+0xa2/0x1f0
[ 1545.171011]  [<ffffffff810b4981>] ? perf_event_update_userpage+0x11/0xc0
[ 1545.171011]  [<ffffffff810bb994>] perf_event_overflow+0x14/0x20
[ 1545.171011]  [<ffffffff81014bcb>] intel_pmu_handle_irq+0x21b/0x460
[ 1545.171011]  [<ffffffff816af286>] perf_event_nmi_handler+0x36/0xb0
[ 1545.171011]  [<ffffffff816b132f>] notifier_call_chain+0x3f/0x80
[ 1545.171011]  [<ffffffff816b1395>] atomic_notifier_call_chain+0x15/0x20
[ 1545.171011]  [<ffffffff816b13ce>] notify_die+0x2e/0x30
[ 1545.171011]  [<ffffffff816ae9e2>] do_nmi+0xa2/0x250
[ 1545.171011]  [<ffffffff816ae3ca>] nmi+0x1a/0x20
[ 1545.171011]  [<ffffffff816adb07>] ? _raw_spin_lock_irqsave+0x17/0x20
[ 1545.171011]  <<EOE>>  <IRQ>  [<ffffffffa004f21c>] drbd_endio_pri+0x9c/0x120 [drbd]
[ 1545.171011]  [<ffffffff814302d2>] ? put_device+0x12/0x20
[ 1545.171011]  [<ffffffff81130b6c>] bio_endio+0x1c/0x40
[ 1545.171011]  [<ffffffff813737d3>] req_bio_endio+0x83/0xb0
[ 1545.171011]  [<ffffffff81373900>] blk_update_request+0x100/0x470
[ 1545.171011]  [<ffffffff81373c92>] blk_update_bidi_request+0x22/0x90
[ 1545.171011]  [<ffffffff81374e5a>] blk_end_bidi_request+0x2a/0x80
[ 1545.171011]  [<ffffffff81374efb>] blk_end_request+0xb/0x10
[ 1545.171011]  [<ffffffff8146744d>] scsi_io_completion+0x11d/0x620
[ 1545.171011]  [<ffffffff8145f2ff>] scsi_finish_command+0xbf/0x120
[ 1545.171011]  [<ffffffff81467a9e>] scsi_softirq_done+0x13e/0x160
[ 1545.171011]  [<ffffffff8137ab7d>] blk_done_softirq+0x6d/0x80
[ 1545.171011]  [<ffffffff8104d0f0>] __do_softirq+0xd0/0x1c0
[ 1545.171011]  [<ffffffff816b726c>] call_softirq+0x1c/0x30
[ 1545.171011]  [<ffffffff81004035>] do_softirq+0x55/0x90
[ 1545.171011]  [<ffffffff8104ce2d>] irq_exit+0xad/0xe0
[ 1545.171011]  [<ffffffff8101cd0f>] smp_call_function_single_interrupt+0x2f/0x40
[ 1545.171011]  [<ffffffff816b6d4b>] call_function_single_interrupt+0x6b/0x70
[ 1545.171011]  <EOI>  [<ffffffff8146635c>] ? scsi_request_fn+0xec/0x510
[ 1545.171011]  [<ffffffff8136fd25>] __blk_run_queue+0x15/0x20
[ 1545.171011]  [<ffffffff813876ec>] cfq_insert_request+0x49c/0x5c0
[ 1545.171011]  [<ffffffff8136f658>] __elv_add_request+0x198/0x2a0
[ 1545.171011]  [<ffffffff81376410>] blk_flush_plug_list+0x1d0/0x210
[ 1545.171011]  [<ffffffff816ab70a>] schedule+0x62a/0xad0
[ 1545.171011]  [<ffffffff810fb26e>] ? kmem_cache_alloc+0xee/0x100
[ 1545.171011]  [<ffffffffa0042199>] ? lc_get+0x49/0x250 [lru_cache]
[ 1545.171011]  [<ffffffffa0061815>] drbd_al_begin_io+0x1c5/0x200 [drbd]
[ 1545.171011]  [<ffffffff81132784>] ? bio_alloc_bioset+0x54/0xe0
[ 1545.171011]  [<ffffffff81067030>] ? wake_up_bit+0x40/0x40
[ 1545.171011]  [<ffffffff81131591>] ? __bio_clone+0x21/0x60
[ 1545.171011]  [<ffffffffa005d825>] drbd_make_request_common+0xd25/0x1650 [drbd]
[ 1545.171011]  [<ffffffff8136e916>] ? elv_set_request+0x16/0x40
[ 1545.171011]  [<ffffffffa005e48a>] drbd_make_request+0x33a/0x1150 [drbd]
[ 1545.171011]  [<ffffffff8137a175>] ? blk_recount_segments+0x25/0x40
[ 1545.171011]  [<ffffffff81131b81>] ? bio_phys_segments+0x21/0x30
[ 1545.171011]  [<ffffffff8137410e>] ? drive_stat_acct+0x11e/0x180
[ 1545.171011]  [<ffffffff8137665d>] ? __make_request+0x1bd/0x330
[ 1545.171011]  [<ffffffff81374713>] generic_make_request+0x3f3/0x540
[ 1545.171011]  [<ffffffff8138c327>] ? kobject_put+0x27/0x60
[ 1545.171011]  [<ffffffff813748d6>] submit_bio+0x76/0xf0
[ 1545.171011]  [<ffffffff81278a57>] _xfs_buf_ioapply+0xb7/0x1f0
[ 1545.171011]  [<ffffffff8127a3a5>] ? xfs_bdstrat_cb+0x85/0xb0
[ 1545.171011]  [<ffffffff8127a251>] xfs_buf_iorequest+0x71/0xc0
[ 1545.171011]  [<ffffffff8127a3a5>] xfs_bdstrat_cb+0x85/0xb0
[ 1545.171011]  [<ffffffff8127a4c6>] xfsbufd+0xf6/0x130
[ 1545.171011]  [<ffffffff8127a3d0>] ? xfs_bdstrat_cb+0xb0/0xb0
[ 1545.171011]  [<ffffffff81066b16>] kthread+0x96/0xb0
[ 1545.171011]  [<ffffffff816b7174>] kernel_thread_helper+0x4/0x10
[ 1545.171011]  [<ffffffff81066a80>] ? kthread_worker_fn+0x130/0x130
[ 1545.171011]  [<ffffffff816b7170>] ? gs_change+0xb/0xb

We upgraded from 2.6.36 which seemed to have a page leak (file pages left
on the LRU) and so would eventually perform very poorly. 2.6.37 and
2.6.38 seemed to have some unix socket issue that caused heartbeat to
wedge. Shall we enable lock debugging or something here?

More bits at http://0x.ca/sim/ref/3.1-rc4/.

Simon-

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
