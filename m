Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934168AbdDFMvX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 08:51:23 -0400
Date: Thu, 6 Apr 2017 08:51:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS mount hangs during quotacheck
Message-ID: <20170406125120.GA50328@bfoster.bfoster>
References: <94fae78c-056b-3055-0714-c4df9239fffb@stepping-stone.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94fae78c-056b-3055-0714-c4df9239fffb@stepping-stone.ch>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christian Affolter <c.affolter@stepping-stone.ch>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 05, 2017 at 03:08:03PM +0200, Christian Affolter wrote:
> Hi everyone,
> 
> I'm having a system with a 15 TiB XFS volume with user and project quotas,
> which recently crashed.
> 
> After a successful xfs_repair run, I'm trying to mount the file system
> again. According to dmesg a quotacheck is needed (XFS (vdc): Quotacheck
> needed: Please wait.), for about 20 minutes I see expected read-activity on
> the device within iotop, then it suddenly stops but the mount command still
> hangs in uninterruptable sleep state (D+) while the system remains
> completely idle (I/O and CPU wise).
> 
> Without the quota mount options the volume can be mounted successfully.
> 
> I've currently booted the affected system with a sysresccd (live CD) in
> order to try different kernel versions.
> 
> Storage stack:
> Adaptec ASR7805 (disks in pass through mode) -> MD RAID 6 -> LVM LV ->
> Passthrough to QEMU/KVM VM -> XFS
> 
> Kernel:
> Linux sysresccd 4.4.57-std495-amd64 #2 SMP Wed Mar 29 18:07:40 UTC 2017
> x86_64 Intel Xeon E312xx (Sandy Bridge) GenuineIntel GNU/Linux
> 
> XFS Mount options:
> noatime,discard,inode64,uquota,pquota
> 
> The virtual machine currently has 12 GiB of RAM and 7 (virtual) CPUs. I've
> also tried to mount the volume with 60 GiB of available RAM without success,
> as I observed that the mount/quota check used almost all available memory
> (which was still the same with 60 GiB).
> 
> Another mount attempt was made with a 4.9.18 instead of the 4.4.57 kernel,
> which didn't made any difference.
> 
> On the #xfs IRC channel it was suggested to attach a dump of the task which
> are in uninterruptable sleep state (echo w > /proc/sysrq-trigger). The dump
> is attached to this mail.
> 
> Please let me know if I should provide further details in order to debug
> this.
> 
> 
> Many thanks and best regards,
> Chris

> Apr  5 10:33:48 sysresccd kernel: XFS (vdc): Mounting V5 Filesystem
> Apr  5 10:33:48 sysresccd kernel: XFS (vdc): Ending clean mount
> Apr  5 10:33:53 sysresccd kernel: XFS (vdc): Unmounting Filesystem
> Apr  5 10:34:00 sysresccd kernel: Adding 4193276k swap on /dev/vda2.  Priority:-1 extents:1 across:4193276k FS
> Apr  5 10:34:35 sysresccd kernel: XFS (vdc): Mounting V5 Filesystem
> Apr  5 10:34:35 sysresccd kernel: XFS (vdc): Ending clean mount
> Apr  5 10:34:35 sysresccd kernel: XFS (vdc): Quotacheck needed: Please wait.
> Apr  5 10:34:43 sysresccd su[2622]: Successful su for root by root
> Apr  5 10:34:43 sysresccd su[2622]: + /dev/tty2 root:root
> Apr  5 12:03:49 sysresccd kernel: sysrq: SysRq : Show Blocked State
> Apr  5 12:03:49 sysresccd kernel:   task                        PC stack   pid father
> Apr  5 12:03:49 sysresccd kernel: mount           D ffff880310653958     0  2611   2571 0x20020000
> Apr  5 12:03:49 sysresccd kernel:  ffff880310653958 ffff880310653958 0000000500370b74 ffff880002789d40
> Apr  5 12:03:49 sysresccd kernel:  ffff880310654000 ffff8803111da198 0000000000000002 ffffffff817fbb2a
> Apr  5 12:03:49 sysresccd kernel:  ffff880002789d40 ffff880310653970 ffffffff817f9f58 7fffffffffffffff
> Apr  5 12:03:49 sysresccd kernel: Call Trace:
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fbb2a>] ? usleep_range+0x3a/0x3a
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817f9f58>] schedule+0x70/0x7e
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fbb59>] schedule_timeout+0x2f/0x107
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff81170dcd>] ? __kmalloc+0xeb/0x114
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff81389780>] ? kmem_alloc+0x33/0x96
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff810b58f0>] ? arch_local_irq_save+0x15/0x1b
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fc3f7>] ? _raw_spin_unlock_irqrestore+0xf/0x11
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fa72d>] do_wait_for_common+0xe4/0x11a
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fa72d>] ? do_wait_for_common+0xe4/0x11a
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff810a315c>] ? wake_up_q+0x42/0x42
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fa7d9>] wait_for_common+0x36/0x4f
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fa80a>] wait_for_completion+0x18/0x1a
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8139a223>] xfs_qm_flush_one+0x42/0x7f
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8139a586>] xfs_qm_dquot_walk.isra.8+0xc1/0x106
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8139a1e1>] ? xfs_qm_dqattach_one+0xe3/0xe3
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8139bd27>] xfs_qm_quotacheck+0x131/0x252
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8139bedf>] xfs_qm_mount_quotas+0x97/0x143
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff813840a1>] xfs_mountfs+0x587/0x6b1
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff813868ea>] xfs_fs_fill_super+0x411/0x4b5
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff811846d1>] mount_bdev+0x141/0x195
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff813864d9>] ? xfs_parseargs+0x8e8/0x8e8
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff81168bff>] ? alloc_pages_current+0x96/0x9f
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8138502b>] xfs_fs_mount+0x10/0x12
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff811851f3>] mount_fs+0x62/0x12b
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff81199646>] vfs_kern_mount+0x64/0xd0
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8119bccd>] do_mount+0x8d5/0x9e6
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff811c07b1>] compat_SyS_mount+0x179/0x1a5
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff810039bb>] do_syscall_32_irqs_off+0x52/0x61
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817feee6>] entry_INT80_compat+0x36/0x50

This looks like a known quotacheck vs. reclaim deadlock. Quotacheck is
in the phase where it has completed all of the updates of in-core
accounting and now needs to flush the in-core xfs_dquot structures to
their associated backing buffers and submit them for I/O. The flush
sequence is stuck waiting on an xfs_dquot flush lock, however.

The problem is that quotacheck holds the underlying buffers and then
does a blocking xfs_dqflock(), which is effectively an inverse locking
order from xfs_dquot memory reclaim. If reclaim runs during the previous
quotacheck phase, it acquires the flush lock and fails to submit the
underlying buffer for I/O (because quotacheck effectively holds/pins the
buffer). When the quotacheck flush gets to the dquot, it thus waits
indefinitely on a flush lock that will never unlock.

If you're comfortable building a kernel from source, you could try the
following patch and see if it helps quotacheck to complete:

  http://www.spinics.net/lists/linux-xfs/msg04485.html

(Note that I've not been able to get this patch merged.)

Otherwise, you'd probably have to go a ways back to a kernel before this
regression was introduced. That looks like v3.4 according to the code
(but it's also possible other changes may have prevented this state
between then and with more recent kernels, particularly since it seems
to have only turned up more recently).

Brian

> Apr  5 12:03:49 sysresccd kernel: parted          D ffff880191a13c98     0  2691   2682 0x20020004
> Apr  5 12:03:49 sysresccd kernel:  ffff880191a13c98 024280ca00000001 00000000000001c1 ffff88030ea70000
> Apr  5 12:03:49 sysresccd kernel:  ffff880191a14000 ffff88030ea70000 ffffffff00000000 0000000000000003
> Apr  5 12:03:49 sysresccd kernel:  ffff88031009c000 ffff880191a13cb0 ffffffff817f9f58 ffff8800dba01870
> Apr  5 12:03:49 sysresccd kernel: Call Trace:
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817f9f58>] schedule+0x70/0x7e
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fbabe>] rwsem_down_read_failed+0xcc/0xea
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8119a24f>] ? mntput+0x28/0x2a
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff814c5584>] call_rwsem_down_read_failed+0x14/0x30
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff814c5584>] ? call_rwsem_down_read_failed+0x14/0x30
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fb2d2>] ? down_read+0x1b/0x1e
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff81183ba6>] get_super+0x5f/0xa4
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff811acbb1>] fsync_bdev+0xf/0x3a
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff814a8133>] blkdev_ioctl+0x7c1/0x80a
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff814b6d89>] compat_blkdev_ioctl+0x372/0x12de
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8119a122>] ? mntput_no_expire+0x18/0x11d
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8119a24f>] ? mntput+0x28/0x2a
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff81183622>] ? __fput+0x17d/0x18a
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff811c11e9>] compat_SyS_ioctl+0x1bc/0xf42
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff81099d41>] ? task_work_run+0x6f/0x82
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff810037d8>] ? prepare_exit_to_usermode+0x2f/0xbc
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff810039bb>] do_syscall_32_irqs_off+0x52/0x61
> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817feee6>] entry_INT80_compat+0x36/0x50
> Apr  5 12:03:49 sysresccd kernel: Sched Debug Version: v0.11, 4.4.57-std495-amd64 #2
> Apr  5 12:03:49 sysresccd kernel: ktime                                   : 5431156.552475
> Apr  5 12:03:49 sysresccd kernel: sched_clk                               : 5442742.784208
> Apr  5 12:03:49 sysresccd kernel: cpu_clk                                 : 5431156.552543
> Apr  5 12:03:49 sysresccd kernel: jiffies                                 : 4300098455
> Apr  5 12:03:49 sysresccd kernel: sched_clock_stable()                    : 0
> Apr  5 12:03:49 sysresccd kernel: 
> Apr  5 12:03:49 sysresccd kernel: sysctl_sched
> Apr  5 12:03:49 sysresccd kernel:   .sysctl_sched_latency                    : 18.000000
> Apr  5 12:03:49 sysresccd kernel:   .sysctl_sched_min_granularity            : 2.250000
> Apr  5 12:03:49 sysresccd kernel:   .sysctl_sched_wakeup_granularity         : 3.000000
> Apr  5 12:03:49 sysresccd kernel:   .sysctl_sched_child_runs_first           : 0
> Apr  5 12:03:49 sysresccd kernel:   .sysctl_sched_features                   : 44859
> Apr  5 12:03:49 sysresccd kernel:   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
> Apr  5 12:03:49 sysresccd kernel: 
> Apr  5 12:03:49 sysresccd kernel: cpu#0, 1999.999 MHz
> Apr  5 12:03:49 sysresccd kernel:   .nr_running                    : 3
> Apr  5 12:03:49 sysresccd kernel:   .load                          : 3072
> Apr  5 12:03:49 sysresccd kernel:   .nr_switches                   : 939016
> Apr  5 12:03:49 sysresccd kernel:   .nr_load_updates               : 383710
> Apr  5 12:03:49 sysresccd kernel:   .nr_uninterruptible            : -1
> Apr  5 12:03:49 sysresccd kernel:   .next_balance                  : 4300.098896
> Apr  5 12:03:49 sysresccd kernel:   .curr->pid                     : 2626
> Apr  5 12:03:49 sysresccd kernel:   .clock                         : 5431169.633512
> Apr  5 12:03:49 sysresccd kernel:   .clock_task                    : 5431117.526824
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[0]                   : 1850
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[1]                   : 1870
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[2]                   : 1815
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[3]                   : 1727
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[4]                   : 1475
> Apr  5 12:03:49 sysresccd kernel:   .yld_count                     : 0
> Apr  5 12:03:49 sysresccd kernel:   .sched_count                   : 948531
> Apr  5 12:03:49 sysresccd kernel:   .sched_goidle                  : 368553
> Apr  5 12:03:49 sysresccd kernel:   .avg_idle                      : 1000000
> Apr  5 12:03:49 sysresccd kernel:   .max_idle_balance_cost         : 500000
> Apr  5 12:03:49 sysresccd kernel:   .ttwu_count                    : 510600
> Apr  5 12:03:49 sysresccd kernel:   .ttwu_local                    : 498274
> Apr  5 12:03:49 sysresccd kernel: \x0acfs_rq[0]:
> Apr  5 12:03:49 sysresccd kernel:   .exec_clock                    : 155461.434734
> Apr  5 12:03:49 sysresccd kernel:   .MIN_vruntime                  : 148975.185707
> Apr  5 12:03:49 sysresccd kernel:   .min_vruntime                  : 148984.185707
> Apr  5 12:03:49 sysresccd kernel:   .max_vruntime                  : 148975.185707
> Apr  5 12:03:49 sysresccd kernel:   .spread                        : 0.000000
> Apr  5 12:03:49 sysresccd kernel:   .spread0                       : 0.000000
> Apr  5 12:03:49 sysresccd kernel:   .nr_spread_over                : 2
> Apr  5 12:03:49 sysresccd kernel:   .nr_running                    : 3
> Apr  5 12:03:49 sysresccd kernel:   .load                          : 3072
> Apr  5 12:03:49 sysresccd kernel:   .load_avg                      : 2007
> Apr  5 12:03:49 sysresccd kernel:   .runnable_load_avg             : 2006
> Apr  5 12:03:49 sysresccd kernel:   .util_avg                      : 712
> Apr  5 12:03:49 sysresccd kernel:   .removed_load_avg              : 0
> Apr  5 12:03:49 sysresccd kernel:   .removed_util_avg              : 0
> Apr  5 12:03:49 sysresccd kernel: \x0art_rq[0]:
> Apr  5 12:03:49 sysresccd kernel:   .rt_nr_running                 : 0
> Apr  5 12:03:49 sysresccd kernel:   .rt_throttled                  : 0
> Apr  5 12:03:49 sysresccd kernel:   .rt_time                       : 0.000000
> Apr  5 12:03:49 sysresccd kernel:   .rt_runtime                    : 950.000000
> Apr  5 12:03:49 sysresccd kernel: \x0adl_rq[0]:
> Apr  5 12:03:49 sysresccd kernel:   .dl_nr_running                 : 0
> Apr  5 12:03:49 sysresccd kernel: \x0arunnable tasks:\x0a            task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep\x0a----------------------------------------------------------------------------------------------------------
> Apr  5 12:03:49 sysresccd kernel:      ksoftirqd/0     3    148975.185707        99   120       105.777851        52.232218   5430954.639940 0 0
> Apr  5 12:03:49 sysresccd kernel:     kworker/0:0H     5      1113.307548         7   100         0.026333         0.036095     10318.962625 0 0
> Apr  5 12:03:49 sysresccd kernel:    kworker/u14:0     6       632.302858        28   120         0.231829         3.250665      2154.847594 0 0
> Apr  5 12:03:49 sysresccd kernel:           rcu_bh     8        18.539371         2   120         0.007643         0.001261         0.001351 0 0
> Apr  5 12:03:49 sysresccd kernel:          rcuob/0    10        22.541710         3   120         0.055361         0.002366         0.302220 0 0
> Apr  5 12:03:49 sysresccd kernel:      migration/0    11         0.000000       207     0         0.001668         2.788428         0.001681 0 0
> Apr  5 12:03:49 sysresccd kernel:       watchdog/0    12         0.001906      1362     0         1.983382        25.997967         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:          rcuos/1    18    148972.915887      2234   120       114.041611      7082.159742   5422690.265940 0 0
> Apr  5 12:03:49 sysresccd kernel:          rcuob/1    19        38.116826         2   120         0.909323         0.001408         0.001348 0 0
> Apr  5 12:03:49 sysresccd kernel:          rcuos/2    25    148972.056113      4417   120       417.843717      5895.119235   5419247.197182 0 0
> Apr  5 12:03:49 sysresccd kernel:          rcuob/2    26        90.400406         3   120         0.956883         0.002841         0.972315 0 0
> Apr  5 12:03:49 sysresccd kernel:          rcuos/3    32    148967.672182      2441   120        86.765728      3136.567724   5421414.888383 0 0
> Apr  5 12:03:49 sysresccd kernel:          rcuob/3    33        96.399705         2   120         0.933138         0.001318         0.001329 0 0
> Apr  5 12:03:49 sysresccd kernel:          rcuos/4    39    148931.571079      3456   120       167.155432      1169.326665   4968320.436573 0 0
> Apr  5 12:03:49 sysresccd kernel:          rcuob/4    40       173.918438         3   120         0.952088         0.002861         0.974304 0 0
> Apr  5 12:03:49 sysresccd kernel:          rcuos/5    46    148928.813692      2402   120       101.348054      1939.192338   4961459.438259 0 0
> Apr  5 12:03:49 sysresccd kernel:          rcuob/5    47       182.917811         2   120         0.933001         0.001385         0.001360 0 0
> Apr  5 12:03:49 sysresccd kernel:          rcuos/6    53    148861.837485      9144   120       333.740020      3431.962254   4718532.227078 0 0
> Apr  5 12:03:49 sysresccd kernel:          rcuob/6    54       228.130162         3   120         1.521995         0.004661         0.391252 0 0
> Apr  5 12:03:49 sysresccd kernel:      kworker/0:1    68      2698.898483        66   120         0.292497         3.325393     12035.776140 0 0
> Apr  5 12:03:49 sysresccd kernel:          kswapd0    77    148380.826017      2331   120       167.592038      7120.425542   1349159.233145 0 0
> Apr  5 12:03:49 sysresccd kernel:    kworker/u14:1   115    148972.965349       659   120         6.011072        25.228205   5429084.237968 0 0
> Apr  5 12:03:49 sysresccd kernel:      kworker/0:2   184    148973.217008    355036   120      2804.771884     30527.329453   5395604.969361 0 0
> Apr  5 12:03:49 sysresccd kernel:     kworker/0:1H   653    148931.557459        59   100         0.355959         0.679267   4959334.507222 0 0
> Apr  5 12:03:49 sysresccd kernel:            hwrng  1219    148971.714793       768   120         8.017892         7.563769   5413135.936890 0 0
> Apr  5 12:03:49 sysresccd kernel:        syslog-ng  1508    148975.185707      1050   120        12.724370        99.942825   5417113.630619 0 0
> Apr  5 12:03:49 sysresccd kernel:            gdbus  1557    148709.096638        44   120        13.126497         6.692239   3169933.655905 0 0
> Apr  5 12:03:49 sysresccd kernel:     ModemManager  1790      4832.841610        48   120         0.632133       112.793261      2513.304501 0 0
> Apr  5 12:03:49 sysresccd kernel:         dhclient  1794    148966.956198       239   120         6.127904       161.530797   5404357.847080 0 0
> Apr  5 12:03:49 sysresccd kernel:              zsh  2384      5840.681389      1550   120         6.813357       449.733946     65940.089995 0 0
> Apr  5 12:03:49 sysresccd kernel:              zsh  2386    148489.040112      1634   120         3.627703       465.623582   2241636.336782 0 0
> Apr  5 12:03:49 sysresccd kernel:             bash  2571      5848.408044       209   120         3.475497       160.006476     51053.260995 0 0
> Apr  5 12:03:49 sysresccd kernel:              zsh  2622      5857.967475        52   120         0.632669        99.591336      4824.002603 0 0
> Apr  5 12:03:49 sysresccd kernel: R           bash  2626    149040.270120       198   120         2.706627       166.312755   5341177.673326 0 0
> Apr  5 12:03:49 sysresccd kernel:             bash  2682    148467.806324        97   120         3.478670       131.152460      6035.978909 0 0
> Apr  5 12:03:49 sysresccd kernel:           parted  2691    148492.461480        32   120         3.778900        54.290399         7.817922 0 0
> Apr  5 12:03:49 sysresccd kernel:             bash  2701    148735.927655        61   120         2.293054        73.850948   1158597.639399 0 0
> Apr  5 12:03:49 sysresccd kernel: 
> Apr  5 12:03:49 sysresccd kernel: cpu#1, 1999.999 MHz
> Apr  5 12:03:49 sysresccd kernel:   .nr_running                    : 0
> Apr  5 12:03:49 sysresccd kernel:   .load                          : 0
> Apr  5 12:03:49 sysresccd kernel:   .nr_switches                   : 672707
> Apr  5 12:03:49 sysresccd kernel:   .nr_load_updates               : 291790
> Apr  5 12:03:49 sysresccd kernel:   .nr_uninterruptible            : -1
> Apr  5 12:03:49 sysresccd kernel:   .next_balance                  : 4300.098510
> Apr  5 12:03:49 sysresccd kernel:   .curr->pid                     : 0
> Apr  5 12:03:49 sysresccd kernel:   .clock                         : 5431207.164920
> Apr  5 12:03:49 sysresccd kernel:   .clock_task                    : 5431179.375259
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[0]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[1]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[2]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[3]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[4]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .yld_count                     : 0
> Apr  5 12:03:49 sysresccd kernel:   .sched_count                   : 674801
> Apr  5 12:03:49 sysresccd kernel:   .sched_goidle                  : 273696
> Apr  5 12:03:49 sysresccd kernel:   .avg_idle                      : 1000000
> Apr  5 12:03:49 sysresccd kernel:   .max_idle_balance_cost         : 500000
> Apr  5 12:03:49 sysresccd kernel:   .ttwu_count                    : 355502
> Apr  5 12:03:49 sysresccd kernel:   .ttwu_local                    : 349050
> Apr  5 12:03:49 sysresccd kernel: \x0acfs_rq[1]:
> Apr  5 12:03:49 sysresccd kernel:   .exec_clock                    : 134962.129060
> Apr  5 12:03:49 sysresccd kernel:   .MIN_vruntime                  : 0.000001
> Apr  5 12:03:49 sysresccd kernel:   .min_vruntime                  : 131617.448886
> Apr  5 12:03:49 sysresccd kernel:   .max_vruntime                  : 0.000001
> Apr  5 12:03:49 sysresccd kernel:   .spread                        : 0.000000
> Apr  5 12:03:49 sysresccd kernel:   .spread0                       : -17366.736821
> Apr  5 12:03:49 sysresccd kernel:   .nr_spread_over                : 0
> Apr  5 12:03:49 sysresccd kernel:   .nr_running                    : 0
> Apr  5 12:03:49 sysresccd kernel:   .load                          : 0
> Apr  5 12:03:49 sysresccd kernel:   .load_avg                      : 0
> Apr  5 12:03:49 sysresccd kernel:   .runnable_load_avg             : 0
> Apr  5 12:03:49 sysresccd kernel:   .util_avg                      : 0
> Apr  5 12:03:49 sysresccd kernel:   .removed_load_avg              : 0
> Apr  5 12:03:49 sysresccd kernel:   .removed_util_avg              : 0
> Apr  5 12:03:49 sysresccd kernel: \x0art_rq[1]:
> Apr  5 12:03:49 sysresccd kernel:   .rt_nr_running                 : 0
> Apr  5 12:03:49 sysresccd kernel:   .rt_throttled                  : 0
> Apr  5 12:03:49 sysresccd kernel:   .rt_time                       : 0.000000
> Apr  5 12:03:49 sysresccd kernel:   .rt_runtime                    : 950.000000
> Apr  5 12:03:49 sysresccd kernel: \x0adl_rq[1]:
> Apr  5 12:03:49 sysresccd kernel:   .dl_nr_running                 : 0
> Apr  5 12:03:49 sysresccd kernel: \x0arunnable tasks:\x0a            task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep\x0a----------------------------------------------------------------------------------------------------------
> Apr  5 12:03:49 sysresccd kernel:          rcuos/0     9    131608.534375     59808   120      1232.828577      9521.708366   5420431.173814 0 0
> Apr  5 12:03:49 sysresccd kernel:       watchdog/1    13        -5.985187      1362     0         0.038095         4.305329         0.001852 0 0
> Apr  5 12:03:49 sysresccd kernel:      migration/1    14         0.000000       195     0         0.006930         2.528403         0.001606 0 0
> Apr  5 12:03:49 sysresccd kernel:      ksoftirqd/1    15     79732.503016         6   120         0.041663         0.041218    892041.942540 0 0
> Apr  5 12:03:49 sysresccd kernel:     kworker/1:0H    17      1337.696214         8   100         0.047491         0.045437      9450.805823 0 0
> Apr  5 12:03:49 sysresccd kernel:            netns    56        11.356406         2   100         0.000000         0.011537         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:             perf    57        17.364813         2   100         0.000000         0.008409         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:        writeback    58        23.374443         2   100         0.000000         0.009632         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:             ksmd    59        29.381888         2   125         0.000000         0.007447         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:       khugepaged    60        35.381886         2   139         0.000000         0.000000         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:           crypto    61        41.381884         2   100         0.000000         0.000000         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:      kintegrityd    62        47.381882         2   100         0.000000         0.000000         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset    63        53.381880         2   100         0.000000         0.000000         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:          kblockd    64        59.381878         2   100         0.000000         0.000000         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:          ata_sff    65        65.387360         2   100         0.000000         0.005484         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:               md    66        71.396766         2   100         0.000000         0.009408         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:       devfreq_wq    67        77.396764         2   100         0.000000         0.000000         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:      kworker/1:1    69    131608.464981    297967   120      1059.187850     23741.932749   5401533.789683 0 0
> Apr  5 12:03:49 sysresccd kernel:     kworker/1:1H   406    131241.575764       139   100        30.615769         2.786049   3163522.912079 0 0
> Apr  5 12:03:49 sysresccd kernel:      kworker/1:2   407      3965.407619        17   120         0.049939         0.665578      4630.335618 0 0
> Apr  5 12:03:49 sysresccd kernel:         vballoon  1216      2933.853570         2   120         0.412830         0.073941         0.634735 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1567    131342.323501        14   120         2.220452         0.003651   4941370.155571 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1568    131342.323501        14   120         1.401057         0.001941   4941370.951516 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1569    131342.323501        13   120         2.485573         0.000000   4941369.736244 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1570    131342.323501        13   120         1.396052         0.086658   4941370.696886 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1571    131342.323501        13   120         2.122573         0.003345   4941370.027629 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1572    131342.323501        12   120         2.316082         0.000000   4941369.837465 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1573    131342.333733        12   120         2.371003         0.045474   4941369.640418 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1574    131342.323501        11   120         2.366251         0.087004   4941369.603640 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1575    131342.323501        12   120         2.331880         0.000000   4941369.671347 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1576    131342.323501        12   120         1.383032         0.014261   4941370.605934 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1577    131342.323501        12   120         2.138176         0.027778   4941369.721685 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1578    131342.323501        12   120         2.170713         0.000000   4941369.689148 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1579    131342.383783        12   120         0.482501         0.155152   4941371.222208 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1580    131342.323501        12   120         1.411899         0.001907   4941370.339168 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1581    131342.323501        12   120         2.313479         0.000000   4941369.384475 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1582    131342.323501        13   120         2.415708         0.149487   4941369.132759 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1583    131342.323501        12   120         2.331344         0.008008   4941369.276885 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1584    131342.323501        11   120         2.440327         0.000000   4941369.175910 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1585    131342.323501        11   120         1.399149         0.052843   4941370.061233 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1586    131342.323501        11   120         1.385482         0.000000   4941370.074900 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1587    131342.323501        11   120         2.316926         0.009363   4941369.134093 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1588    131342.323501        11   120         2.224485         0.001372   4941369.134365 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1589    131342.323501        11   120         2.135492         0.000000   4941369.165112 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1590    131342.376641        11   120         2.193567         0.061702   4941369.016217 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1591    131342.323501        11   120         2.197916         0.064507   4941368.988931 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1592    131342.323501        11   120         0.529161         0.020049   4941370.626169 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1593    131342.323501        11   120         0.549812         0.002226   4941370.583479 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1594    131342.323501        11   120         1.501926         0.002024   4941369.579010 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1595    131342.323501        12   120         2.314078         0.023579   4941368.724919 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1596    131342.323501        12   120         2.223497         0.094610   4941368.641351 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1597    131342.323501        10   120         2.398793         0.029310   4941368.491599 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1598    131342.323501        10   120         2.340743         0.024935   4941368.467020 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1599    131342.323501        10   120         2.336568         0.055428   4941368.409931 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1600    131342.369623        10   120         2.331132         0.046122   4941368.361330 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1601    131342.323501        10   120         1.396797         0.000000   4941369.341787 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1602    131342.323501        10   120         1.393997         0.000000   4941369.344587 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1603    131342.323501        10   120         1.384801         0.000000   4941369.353783 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1604    131342.323501        10   120         2.207723         0.042807   4941368.488054 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1605    131342.323501        10   120         2.209476         0.000000   4941368.375305 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1606    131342.323501        10   120         2.236864         0.037814   4941368.296546 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1607    131342.323501        10   120         2.138843         0.007308   4941368.375578 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1608    131342.323501        10   120         2.137587         0.000000   4941368.384142 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1609    131342.323501        10   120         2.134580         0.000000   4941368.387149 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1610    131342.323501        10   120         2.239809         0.044535   4941368.237385 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1611    131342.323501        10   120         2.226502         0.000000   4941368.173080 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1612    131342.323501        11   120         2.461866         0.042851   4941367.825282 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1613    131342.323501        10   120         2.168098         0.020582   4941368.141319 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1614    131342.323501        10   120         2.280924         0.000000   4941368.049075 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1615    131342.323501        10   120         0.544804         0.003088   4941369.667839 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1616    131342.323501        10   120         0.608793         0.001874   4941369.546790 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1617    131342.323501        10   120         0.551082         0.001834   4941369.533815 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1618    131342.323501        10   120         1.402594         0.109352   4941368.539599 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1619    131342.323501        10   120         1.399955         0.002194   4941368.610444 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1620    131342.323501        10   120         1.400262         0.001787   4941368.610544 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1621    131342.323501        10   120         2.372049         0.045954   4941367.594590 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1622    131342.323501        10   120         2.277425         0.016515   4941367.626679 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1623    131342.323501        10   120         2.308347         0.000000   4941367.552455 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  1624    131342.323501         9   120         2.744964         0.000000   4941367.056009 0 0
> Apr  5 12:03:49 sysresccd kernel:          polkitd  1561    131299.163495       203   120        23.088031       224.105287   3169700.670696 0 0
> Apr  5 12:03:49 sysresccd kernel:            gmain  1791      4721.170892         4   120         0.000000         0.121002         0.281405 0 0
> Apr  5 12:03:49 sysresccd kernel:              zsh  2387      5732.094896      1450   120         5.084420       433.757171       416.763318 0 0
> Apr  5 12:03:49 sysresccd kernel: 
> Apr  5 12:03:49 sysresccd kernel: cpu#2, 1999.999 MHz
> Apr  5 12:03:49 sysresccd kernel:   .nr_running                    : 0
> Apr  5 12:03:49 sysresccd kernel:   .load                          : 0
> Apr  5 12:03:49 sysresccd kernel:   .nr_switches                   : 600934
> Apr  5 12:03:49 sysresccd kernel:   .nr_load_updates               : 270009
> Apr  5 12:03:49 sysresccd kernel:   .nr_uninterruptible            : 3
> Apr  5 12:03:49 sysresccd kernel:   .next_balance                  : 4300.098510
> Apr  5 12:03:49 sysresccd kernel:   .curr->pid                     : 0
> Apr  5 12:03:49 sysresccd kernel:   .clock                         : 5431207.170256
> Apr  5 12:03:49 sysresccd kernel:   .clock_task                    : 5431181.753652
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[0]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[1]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[2]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[3]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[4]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .yld_count                     : 0
> Apr  5 12:03:49 sysresccd kernel:   .sched_count                   : 602989
> Apr  5 12:03:49 sysresccd kernel:   .sched_goidle                  : 247694
> Apr  5 12:03:49 sysresccd kernel:   .avg_idle                      : 597081
> Apr  5 12:03:49 sysresccd kernel:   .max_idle_balance_cost         : 500000
> Apr  5 12:03:49 sysresccd kernel:   .ttwu_count                    : 319726
> Apr  5 12:03:49 sysresccd kernel:   .ttwu_local                    : 314844
> Apr  5 12:03:49 sysresccd kernel: \x0acfs_rq[2]:
> Apr  5 12:03:49 sysresccd kernel:   .exec_clock                    : 124178.428863
> Apr  5 12:03:49 sysresccd kernel:   .MIN_vruntime                  : 0.000001
> Apr  5 12:03:49 sysresccd kernel:   .min_vruntime                  : 119938.412231
> Apr  5 12:03:49 sysresccd kernel:   .max_vruntime                  : 0.000001
> Apr  5 12:03:49 sysresccd kernel:   .spread                        : 0.000000
> Apr  5 12:03:49 sysresccd kernel:   .spread0                       : -29045.773476
> Apr  5 12:03:49 sysresccd kernel:   .nr_spread_over                : 0
> Apr  5 12:03:49 sysresccd kernel:   .nr_running                    : 0
> Apr  5 12:03:49 sysresccd kernel:   .load                          : 0
> Apr  5 12:03:49 sysresccd kernel:   .load_avg                      : 820
> Apr  5 12:03:49 sysresccd kernel:   .runnable_load_avg             : 0
> Apr  5 12:03:49 sysresccd kernel:   .util_avg                      : 0
> Apr  5 12:03:49 sysresccd kernel:   .removed_load_avg              : 0
> Apr  5 12:03:49 sysresccd kernel:   .removed_util_avg              : 0
> Apr  5 12:03:49 sysresccd kernel: \x0art_rq[2]:
> Apr  5 12:03:49 sysresccd kernel:   .rt_nr_running                 : 0
> Apr  5 12:03:49 sysresccd kernel:   .rt_throttled                  : 0
> Apr  5 12:03:49 sysresccd kernel:   .rt_time                       : 0.000000
> Apr  5 12:03:49 sysresccd kernel:   .rt_runtime                    : 950.000000
> Apr  5 12:03:49 sysresccd kernel: \x0adl_rq[2]:
> Apr  5 12:03:49 sysresccd kernel:   .dl_nr_running                 : 0
> Apr  5 12:03:49 sysresccd kernel: \x0arunnable tasks:\x0a            task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep\x0a----------------------------------------------------------------------------------------------------------
> Apr  5 12:03:49 sysresccd kernel:             init     1    119929.482441      2268   120        47.224424      2233.346276   5424280.204339 0 0
> Apr  5 12:03:49 sysresccd kernel:        rcu_sched     7    119929.492449    107070   120       954.111552      2227.897615   5428004.636305 0 0
> Apr  5 12:03:49 sysresccd kernel:       watchdog/2    20        -6.000000      1362     0         0.006010         5.267378         0.001812 0 0
> Apr  5 12:03:49 sysresccd kernel:      migration/2    21         0.000000       105     0         0.000739         1.384916         0.001353 0 0
> Apr  5 12:03:49 sysresccd kernel:      ksoftirqd/2    22      2391.270426         4   120         0.009574         0.003636     18592.012382 0 0
> Apr  5 12:03:49 sysresccd kernel:     kworker/2:0H    24       128.121250         8   100         0.089485         0.059511      9463.890095 0 0
> Apr  5 12:03:49 sysresccd kernel:          rcuos/2    25    119929.415187      4418   120       417.857033      5895.122191   5424871.076425 0 0
> Apr  5 12:03:49 sysresccd kernel:      kworker/2:1    70    119929.444813    269710   120       642.951176     21012.599195   5404675.906524 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset   181        59.328852         2   100         0.019090         0.017219         0.027469 0 0
> Apr  5 12:03:49 sysresccd kernel:          deferwq   182        68.409169         2   100         0.000000         0.081265         0.025054 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset   183        77.430197         2   100         0.005200         0.021982         0.027500 0 0
> Apr  5 12:03:49 sysresccd kernel:     kworker/2:1H   409    119915.855255       579   100        97.903361        10.695212   5415976.410174 0 0
> Apr  5 12:03:49 sysresccd kernel:      kworker/2:2   410      2270.572204         7   120        10.529228         0.273125      8422.921413 0 0
> Apr  5 12:03:49 sysresccd kernel:            loop0   450    119914.317011      1911   100        70.981552       241.269709   5415646.103216 0 0
> Apr  5 12:03:49 sysresccd kernel:        syslog-ng  1507      1624.232190         2   120         0.000000         0.466719         6.718311 0 0
> Apr  5 12:03:49 sysresccd kernel:        syslog-ng  1508    119930.041686      1055   120        99.124700       100.572280   5417113.774952 0 0
> Apr  5 12:03:49 sysresccd kernel:            gmain  1546      1704.141392         4   120         0.139347         0.319113        74.440974 0 0
> Apr  5 12:03:49 sysresccd kernel:  console-kit-dae  1559      1704.186036         2   120         0.220513         0.291566        58.939650 0 0
> Apr  5 12:03:49 sysresccd kernel:            gmain  1657      1958.834596         4   120         0.000000         0.359247      1105.168396 0 0
> Apr  5 12:03:49 sysresccd kernel:            gdbus  1658    119845.213862        25   120         0.173565         4.535275   3169671.578897 0 0
> Apr  5 12:03:49 sysresccd kernel:          polkitd  1659      1747.215496         1   120         0.000000         0.158016         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:          polkitd  1660      1756.418957         3   120         0.000000         0.203466        22.482751 0 0
> Apr  5 12:03:49 sysresccd kernel:             sshd  1909      2079.591842         1   120         0.000000         0.593772         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:              zsh  2383      2711.454860      1643   120         6.044877       578.473983      6954.162384 0 0
> Apr  5 12:03:49 sysresccd kernel: 
> Apr  5 12:03:49 sysresccd kernel: cpu#3, 1999.999 MHz
> Apr  5 12:03:49 sysresccd kernel:   .nr_running                    : 3
> Apr  5 12:03:49 sysresccd kernel:   .load                          : 3072
> Apr  5 12:03:49 sysresccd kernel:   .nr_switches                   : 248587
> Apr  5 12:03:49 sysresccd kernel:   .nr_load_updates               : 128638
> Apr  5 12:03:49 sysresccd kernel:   .nr_uninterruptible            : -16
> Apr  5 12:03:49 sysresccd kernel:   .next_balance                  : 4300.098510
> Apr  5 12:03:49 sysresccd kernel:   .curr->pid                     : 2849
> Apr  5 12:03:49 sysresccd kernel:   .clock                         : 5431207.931181
> Apr  5 12:03:49 sysresccd kernel:   .clock_task                    : 5431191.097870
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[0]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[1]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[2]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[3]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[4]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .yld_count                     : 0
> Apr  5 12:03:49 sysresccd kernel:   .sched_count                   : 250439
> Apr  5 12:03:49 sysresccd kernel:   .sched_goidle                  : 103534
> Apr  5 12:03:49 sysresccd kernel:   .avg_idle                      : 862510
> Apr  5 12:03:49 sysresccd kernel:   .max_idle_balance_cost         : 500000
> Apr  5 12:03:49 sysresccd kernel:   .ttwu_count                    : 128240
> Apr  5 12:03:49 sysresccd kernel:   .ttwu_local                    : 121723
> Apr  5 12:03:49 sysresccd kernel: \x0acfs_rq[3]:
> Apr  5 12:03:49 sysresccd kernel:   .exec_clock                    : 60606.248035
> Apr  5 12:03:49 sysresccd kernel:   .MIN_vruntime                  : 59500.397570
> Apr  5 12:03:49 sysresccd kernel:   .min_vruntime                  : 59500.397570
> Apr  5 12:03:49 sysresccd kernel:   .max_vruntime                  : 59501.158495
> Apr  5 12:03:49 sysresccd kernel:   .spread                        : 0.760925
> Apr  5 12:03:49 sysresccd kernel:   .spread0                       : -89483.788137
> Apr  5 12:03:49 sysresccd kernel:   .nr_spread_over                : 0
> Apr  5 12:03:49 sysresccd kernel:   .nr_running                    : 3
> Apr  5 12:03:49 sysresccd kernel:   .load                          : 3072
> Apr  5 12:03:49 sysresccd kernel:   .load_avg                      : 46
> Apr  5 12:03:49 sysresccd kernel:   .runnable_load_avg             : 45
> Apr  5 12:03:49 sysresccd kernel:   .util_avg                      : 30
> Apr  5 12:03:49 sysresccd kernel:   .removed_load_avg              : 0
> Apr  5 12:03:49 sysresccd kernel:   .removed_util_avg              : 0
> Apr  5 12:03:49 sysresccd kernel: \x0art_rq[3]:
> Apr  5 12:03:49 sysresccd kernel:   .rt_nr_running                 : 0
> Apr  5 12:03:49 sysresccd kernel:   .rt_throttled                  : 0
> Apr  5 12:03:49 sysresccd kernel:   .rt_time                       : 0.000000
> Apr  5 12:03:49 sysresccd kernel:   .rt_runtime                    : 950.000000
> Apr  5 12:03:49 sysresccd kernel: \x0adl_rq[3]:
> Apr  5 12:03:49 sysresccd kernel:   .dl_nr_running                 : 0
> Apr  5 12:03:49 sysresccd kernel: \x0arunnable tasks:\x0a            task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep\x0a----------------------------------------------------------------------------------------------------------
> Apr  5 12:03:49 sysresccd kernel:         kthreadd     2     59472.260602       240   120         2.481391        26.487111   5424559.633949 0 0
> Apr  5 12:03:49 sysresccd kernel:       watchdog/3    27        -9.000000      1362     0         0.006139         5.861740         0.001811 0 0
> Apr  5 12:03:49 sysresccd kernel:      migration/3    28         0.000000       145     0         0.000773         1.782304         0.001539 0 0
> Apr  5 12:03:49 sysresccd kernel:      ksoftirqd/3    29      2366.391103         9   120         0.190981         0.020291     15319.872583 0 0
> Apr  5 12:03:49 sysresccd kernel:     kworker/3:0H    31      1248.100047         8   100         0.006720         0.045506     11306.618524 0 0
> Apr  5 12:03:49 sysresccd kernel:      kworker/3:1    71     59481.680512    103691   120       548.824657     11630.984979   5418154.794599 0 0
> Apr  5 12:03:49 sysresccd kernel:  acpi_thermal_pm   132        18.817835         2   100         0.008815         0.015947         0.026387 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset   133        27.832921         2   100         0.003980         0.016056         0.023680 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset   134        36.847711         2   100         0.004086         0.015784         0.024029 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset   135        45.862434         2   100         0.008390         0.015657         0.023752 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset   139        54.878825         2   100         0.015984         0.017363         0.029252 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset   140        63.912178         2   100         0.000000         0.034226         0.025296 0 0
> Apr  5 12:03:49 sysresccd kernel:        scsi_eh_0   141       384.712540        10   120         0.007238         2.788610       542.206939 0 0
> Apr  5 12:03:49 sysresccd kernel:       scsi_tmf_0   142        81.986461         2   100         0.000000         0.034143         0.029051 0 0
> Apr  5 12:03:49 sysresccd kernel:        scsi_eh_1   143       145.509870         4   120         0.103908         2.021379       151.883619 0 0
> Apr  5 12:03:49 sysresccd kernel:       scsi_tmf_1   144       100.047526         2   100         0.000000         0.021985         0.019364 0 0
> Apr  5 12:03:49 sysresccd kernel:   dm_bufio_cache   148       127.136881         2   100         0.017743         0.017229         0.037809 0 0
> Apr  5 12:03:49 sysresccd kernel:    ipv6_addrconf   149       136.152954         2   100         0.008643         0.017049         0.025908 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset   364       399.530945         2   100         0.024898         0.016013         0.024345 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset   366       405.557898         2   100         0.000000         0.027873         0.021290 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset   369       423.660882         2   100         0.964654         0.009253         0.036601 0 0
> Apr  5 12:03:49 sysresccd kernel:          raid5wq   400       541.808733         2   100         0.000000         0.032263         0.018354 0 0
> Apr  5 12:03:49 sysresccd kernel:         kdmflush   415       577.913300         2   100         0.000000         0.029979         0.022290 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset   416       586.925834         2   100         0.023342         0.013403         0.026080 0 0
> Apr  5 12:03:49 sysresccd kernel:         kdmflush   419       596.219900         2   100         0.565060         0.020455         0.034463 0 0
> Apr  5 12:03:49 sysresccd kernel:     kworker/3:1H   948     59053.940174       219   100        39.973315         5.156849   3161909.805896 0 0
> Apr  5 12:03:49 sysresccd kernel:          lvmetad  1243      3588.025268         2   120         0.000000         0.641197      4698.905039 0 0
> Apr  5 12:03:49 sysresccd kernel:      dbus-daemon  1480     59098.062807       424   120        15.386322        65.708187   3170414.353015 0 0
> Apr  5 12:03:49 sysresccd kernel: R      syslog-ng  2849     59491.397575         2   120         0.000000         0.717068         0.775081 0 0
> Apr  5 12:03:49 sysresccd kernel:        syslog-ng  2850     59501.158495         1   120         0.000000         0.760925         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:        syslog-ng  2851     59500.397570         0   120         0.000000         0.000000         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:  console-kit-dae  1534     59281.492141        92   120         2.751703        79.281910   4941366.650347 0 0
> Apr  5 12:03:49 sysresccd kernel:            gmain  1778      3997.330638        34   120         0.166755         0.503307      3396.827020 0 0
> Apr  5 12:03:49 sysresccd kernel:            gdbus  1793      2374.172223        10   120         2.857965         0.813531        88.810517 0 0
> Apr  5 12:03:49 sysresccd kernel:              zsh  2385     58878.087137      1527   120        19.770580       407.800061   2202271.014049 0 0
> Apr  5 12:03:49 sysresccd kernel:      kworker/3:0  2828     59472.243317       149   120         0.000000        59.945287    301049.992980 0 0
> Apr  5 12:03:49 sysresccd kernel:      kworker/3:2  2847     59481.380729         4   120         0.000000        54.100175      4553.944220 0 0
> Apr  5 12:03:49 sysresccd kernel: 
> Apr  5 12:03:49 sysresccd kernel: cpu#4, 1999.999 MHz
> Apr  5 12:03:49 sysresccd kernel:   .nr_running                    : 0
> Apr  5 12:03:49 sysresccd kernel:   .load                          : 0
> Apr  5 12:03:49 sysresccd kernel:   .nr_switches                   : 98148
> Apr  5 12:03:49 sysresccd kernel:   .nr_load_updates               : 56486
> Apr  5 12:03:49 sysresccd kernel:   .nr_uninterruptible            : 20
> Apr  5 12:03:49 sysresccd kernel:   .next_balance                  : 4300.098510
> Apr  5 12:03:49 sysresccd kernel:   .curr->pid                     : 0
> Apr  5 12:03:49 sysresccd kernel:   .clock                         : 5431206.431764
> Apr  5 12:03:49 sysresccd kernel:   .clock_task                    : 5431199.099590
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[0]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[1]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[2]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[3]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[4]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .yld_count                     : 0
> Apr  5 12:03:49 sysresccd kernel:   .sched_count                   : 99867
> Apr  5 12:03:49 sysresccd kernel:   .sched_goidle                  : 41561
> Apr  5 12:03:49 sysresccd kernel:   .avg_idle                      : 1000000
> Apr  5 12:03:49 sysresccd kernel:   .max_idle_balance_cost         : 500000
> Apr  5 12:03:49 sysresccd kernel:   .ttwu_count                    : 50332
> Apr  5 12:03:49 sysresccd kernel:   .ttwu_local                    : 46276
> Apr  5 12:03:49 sysresccd kernel: \x0acfs_rq[4]:
> Apr  5 12:03:49 sysresccd kernel:   .exec_clock                    : 24122.910111
> Apr  5 12:03:49 sysresccd kernel:   .MIN_vruntime                  : 0.000001
> Apr  5 12:03:49 sysresccd kernel:   .min_vruntime                  : 26194.681168
> Apr  5 12:03:49 sysresccd kernel:   .max_vruntime                  : 0.000001
> Apr  5 12:03:49 sysresccd kernel:   .spread                        : 0.000000
> Apr  5 12:03:49 sysresccd kernel:   .spread0                       : -122789.504539
> Apr  5 12:03:49 sysresccd kernel:   .nr_spread_over                : 0
> Apr  5 12:03:49 sysresccd kernel:   .nr_running                    : 0
> Apr  5 12:03:49 sysresccd kernel:   .load                          : 0
> Apr  5 12:03:49 sysresccd kernel:   .load_avg                      : 0
> Apr  5 12:03:49 sysresccd kernel:   .runnable_load_avg             : 0
> Apr  5 12:03:49 sysresccd kernel:   .util_avg                      : 0
> Apr  5 12:03:49 sysresccd kernel:   .removed_load_avg              : 0
> Apr  5 12:03:49 sysresccd kernel:   .removed_util_avg              : 0
> Apr  5 12:03:49 sysresccd kernel: \x0art_rq[4]:
> Apr  5 12:03:49 sysresccd kernel:   .rt_nr_running                 : 0
> Apr  5 12:03:49 sysresccd kernel:   .rt_throttled                  : 0
> Apr  5 12:03:49 sysresccd kernel:   .rt_time                       : 0.000000
> Apr  5 12:03:49 sysresccd kernel:   .rt_runtime                    : 950.000000
> Apr  5 12:03:49 sysresccd kernel: \x0adl_rq[4]:
> Apr  5 12:03:49 sysresccd kernel:   .dl_nr_running                 : 0
> Apr  5 12:03:49 sysresccd kernel: \x0arunnable tasks:\x0a            task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep\x0a----------------------------------------------------------------------------------------------------------
> Apr  5 12:03:49 sysresccd kernel:       watchdog/4    34        -9.000000      1362     0         0.006824        24.360134         0.001677 0 0
> Apr  5 12:03:49 sysresccd kernel:      migration/4    35         0.000000       201     0         0.000800         2.550088         0.001391 0 0
> Apr  5 12:03:49 sysresccd kernel:      ksoftirqd/4    36       -10.048576         3   120         0.003111         0.001098         0.001322 0 0
> Apr  5 12:03:49 sysresccd kernel:     kworker/4:0H    38       783.974774         8   100         0.007329         0.046228      9567.272996 0 0
> Apr  5 12:03:49 sysresccd kernel:      kworker/4:1    72     26063.645790     36243   120       192.395831      4217.720416   4965916.144255 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset   136       132.364619         2   100         0.000000         0.029406         0.025765 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset   137       141.390069         2   100         0.000000         0.026730         0.024649 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset   138       150.415368         2   100         0.000000         0.026476         0.024554 0 0
> Apr  5 12:03:49 sysresccd kernel:        kpsmoused   146       159.452174         2   100         0.000000         0.038141         0.028116 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset   421       762.377551         2   100         0.071709         0.012824         0.024281 0 0
> Apr  5 12:03:49 sysresccd kernel:     kworker/4:1H   443     25699.565365        95   100        24.781973         1.636993   3163571.009820 0 0
> Apr  5 12:03:49 sysresccd kernel:      kworker/4:2   444      2664.390898         8   120         0.050837         0.368796      4541.480145 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  2693     26003.081138         5   120         0.210137         0.571834   2708178.428288 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  2799     26003.113060         5   120         0.179972         1.676926    890319.641715 0 0
> Apr  5 12:03:49 sysresccd kernel:  vt_thread_start  2806     26021.327906         1   120         0.000000         0.260183         0.000000 0 0
> Apr  5 12:03:49 sysresccd kernel:           bioset  2241      4164.123943         2   100         0.051425         0.005379         0.157865 0 0
> Apr  5 12:03:49 sysresccd kernel:              zsh  2388      4875.676891      1721   120         9.367340       423.306395       422.477611 0 0
> Apr  5 12:03:49 sysresccd kernel:      xfs-buf/vdc  2612      5038.771141         2   100         0.013530         0.000220         0.235610 0 0
> Apr  5 12:03:49 sysresccd kernel:     xfs-data/vdc  2613      5044.772594         2   100         0.015453         0.001455         0.246295 0 0
> Apr  5 12:03:49 sysresccd kernel:     xfs-conv/vdc  2614      5050.775487         2   100         0.166678         0.002895         0.129783 0 0
> Apr  5 12:03:49 sysresccd kernel:      xfs-cil/vdc  2615      5056.777547         2   100         0.165622         0.002062         0.060237 0 0
> Apr  5 12:03:49 sysresccd kernel:  xfs-reclaim/vdc  2616      5062.779618         2   100         0.146726         0.002073         0.140547 0 0
> Apr  5 12:03:49 sysresccd kernel:      xfs-log/vdc  2617      5071.782868         2   100         0.028886         0.003255         0.275874 0 0
> Apr  5 12:03:49 sysresccd kernel:  xfs-eofblocks/v  2618      5077.782866         2   100         0.009020         0.000000         0.193890 0 0
> Apr  5 12:03:49 sysresccd kernel:      xfsaild/vdc  2619      5086.836615         2   120         0.000000         0.053754         0.064192 0 0
> Apr  5 12:03:49 sysresccd kernel: 
> Apr  5 12:03:49 sysresccd kernel: cpu#5, 1999.999 MHz
> Apr  5 12:03:49 sysresccd kernel:   .nr_running                    : 0
> Apr  5 12:03:49 sysresccd kernel:   .load                          : 0
> Apr  5 12:03:49 sysresccd kernel:   .nr_switches                   : 198971
> Apr  5 12:03:49 sysresccd kernel:   .nr_load_updates               : 100272
> Apr  5 12:03:49 sysresccd kernel:   .nr_uninterruptible            : -1
> Apr  5 12:03:49 sysresccd kernel:   .next_balance                  : 4300.098510
> Apr  5 12:03:49 sysresccd kernel:   .curr->pid                     : 0
> Apr  5 12:03:49 sysresccd kernel:   .clock                         : 5431206.433544
> Apr  5 12:03:49 sysresccd kernel:   .clock_task                    : 5431197.439108
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[0]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[1]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[2]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[3]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[4]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .yld_count                     : 0
> Apr  5 12:03:49 sysresccd kernel:   .sched_count                   : 200763
> Apr  5 12:03:49 sysresccd kernel:   .sched_goidle                  : 81429
> Apr  5 12:03:49 sysresccd kernel:   .avg_idle                      : 1000000
> Apr  5 12:03:49 sysresccd kernel:   .max_idle_balance_cost         : 500000
> Apr  5 12:03:49 sysresccd kernel:   .ttwu_count                    : 105328
> Apr  5 12:03:49 sysresccd kernel:   .ttwu_local                    : 99782
> Apr  5 12:03:49 sysresccd kernel: \x0acfs_rq[5]:
> Apr  5 12:03:49 sysresccd kernel:   .exec_clock                    : 45642.096041
> Apr  5 12:03:49 sysresccd kernel:   .MIN_vruntime                  : 0.000001
> Apr  5 12:03:49 sysresccd kernel:   .min_vruntime                  : 45180.528878
> Apr  5 12:03:49 sysresccd kernel:   .max_vruntime                  : 0.000001
> Apr  5 12:03:49 sysresccd kernel:   .spread                        : 0.000000
> Apr  5 12:03:49 sysresccd kernel:   .spread0                       : -103803.656829
> Apr  5 12:03:49 sysresccd kernel:   .nr_spread_over                : 0
> Apr  5 12:03:49 sysresccd kernel:   .nr_running                    : 0
> Apr  5 12:03:49 sysresccd kernel:   .load                          : 0
> Apr  5 12:03:49 sysresccd kernel:   .load_avg                      : 0
> Apr  5 12:03:49 sysresccd kernel:   .runnable_load_avg             : 0
> Apr  5 12:03:49 sysresccd kernel:   .util_avg                      : 0
> Apr  5 12:03:49 sysresccd kernel:   .removed_load_avg              : 0
> Apr  5 12:03:49 sysresccd kernel:   .removed_util_avg              : 0
> Apr  5 12:03:49 sysresccd kernel: \x0art_rq[5]:
> Apr  5 12:03:49 sysresccd kernel:   .rt_nr_running                 : 0
> Apr  5 12:03:49 sysresccd kernel:   .rt_throttled                  : 0
> Apr  5 12:03:49 sysresccd kernel:   .rt_time                       : 0.000000
> Apr  5 12:03:49 sysresccd kernel:   .rt_runtime                    : 950.000000
> Apr  5 12:03:49 sysresccd kernel: \x0adl_rq[5]:
> Apr  5 12:03:49 sysresccd kernel:   .dl_nr_running                 : 0
> Apr  5 12:03:49 sysresccd kernel: \x0arunnable tasks:\x0a            task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep\x0a----------------------------------------------------------------------------------------------------------
> Apr  5 12:03:49 sysresccd kernel:       watchdog/5    41        -9.000000      1362     0         0.005970        10.089367         0.001800 0 0
> Apr  5 12:03:49 sysresccd kernel:      migration/5    42         0.000000        64     0         0.000725         1.430291         0.001326 0 0
> Apr  5 12:03:49 sysresccd kernel:      ksoftirqd/5    43      1626.341892         5   120         6.527365         0.006087     14580.933142 0 0
> Apr  5 12:03:49 sysresccd kernel:     kworker/5:0H    45       451.594376         8   100         0.006465         0.042406      9584.619358 0 0
> Apr  5 12:03:49 sysresccd kernel:      kworker/5:1    73      1477.915076       473   120        65.628438        30.134438     13676.501363 0 0
> Apr  5 12:03:49 sysresccd kernel:           rpciod    75        16.994491         2   100         0.000000         0.043077         0.032350 0 0
> Apr  5 12:03:49 sysresccd kernel:           vmstat    78        41.157533         2   100         0.005917         0.036262         0.028595 0 0
> Apr  5 12:03:49 sysresccd kernel:    fsnotify_mark    79      1453.668875        13   120         0.809648         0.297575     12112.451029 0 0
> Apr  5 12:03:49 sysresccd kernel:           nfsiod    80        56.214307         2   100         0.000000         0.027017         0.027439 0 0
> Apr  5 12:03:49 sysresccd kernel:            jfsIO    81        65.261761         2   120         0.000000         0.047459         0.027160 0 0
> Apr  5 12:03:49 sysresccd kernel:        jfsCommit    82        74.299958         2   120         0.000000         0.038202         0.024990 0 0
> Apr  5 12:03:49 sysresccd kernel:        jfsCommit    83        83.346346         2   120         0.000000         0.046393         0.026649 0 0
> Apr  5 12:03:49 sysresccd kernel:        jfsCommit    84        92.381796         2   120         0.000000         0.035455         0.024061 0 0
> Apr  5 12:03:49 sysresccd kernel:        jfsCommit    85       101.416914         2   120         0.000000         0.035123         0.031556 0 0
> Apr  5 12:03:49 sysresccd kernel:        jfsCommit    86       110.454878         2   120         0.000000         0.037969         0.022765 0 0
> Apr  5 12:03:49 sysresccd kernel:        jfsCommit    87       119.490315         2   120         0.000000         0.035442         0.020344 0 0
> Apr  5 12:03:49 sysresccd kernel:        jfsCommit    88       128.524455         2   120         0.000000         0.034145         0.020489 0 0
> Apr  5 12:03:49 sysresccd kernel:          jfsSync    89       137.558313         2   120         0.000000         0.033863         0.020628 0 0
> Apr  5 12:03:49 sysresccd kernel:         xfsalloc    90       143.575654         2   100         0.005629         0.018269         0.023108 0 0
> Apr  5 12:03:49 sysresccd kernel:    xfs_mru_cache    91       149.600353         2   100         0.005315         0.025454         0.022205 0 0
> Apr  5 12:03:49 sysresccd kernel:     kworker/5:1H   452     45147.843158       481   100        53.205311         7.405779   3163561.671002 0 0
> Apr  5 12:03:49 sysresccd kernel:            udevd  1117      3558.160431       233   120         9.232918       562.360300      9109.982225 0 0
> Apr  5 12:03:49 sysresccd kernel:      kworker/5:2  1635     45171.548658     80670   120       376.197631      7382.592839   4934810.987833 0 0
> Apr  5 12:03:49 sysresccd kernel:            gdbus  1781     45152.682164       301   120         2.490431        22.588405   3168790.679538 0 0
> Apr  5 12:03:49 sysresccd kernel:            mount  2611     43738.332241    321227   120      6545.697555    432544.246531    844231.914370 0 0
> Apr  5 12:03:49 sysresccd kernel: 
> Apr  5 12:03:49 sysresccd kernel: cpu#6, 1999.999 MHz
> Apr  5 12:03:49 sysresccd kernel:   .nr_running                    : 0
> Apr  5 12:03:49 sysresccd kernel:   .load                          : 0
> Apr  5 12:03:49 sysresccd kernel:   .nr_switches                   : 372920
> Apr  5 12:03:49 sysresccd kernel:   .nr_load_updates               : 185357
> Apr  5 12:03:49 sysresccd kernel:   .nr_uninterruptible            : -2
> Apr  5 12:03:49 sysresccd kernel:   .next_balance                  : 4300.098510
> Apr  5 12:03:49 sysresccd kernel:   .curr->pid                     : 0
> Apr  5 12:03:49 sysresccd kernel:   .clock                         : 5431206.435240
> Apr  5 12:03:49 sysresccd kernel:   .clock_task                    : 5431179.168739
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[0]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[1]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[2]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[3]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .cpu_load[4]                   : 0
> Apr  5 12:03:49 sysresccd kernel:   .yld_count                     : 0
> Apr  5 12:03:49 sysresccd kernel:   .sched_count                   : 374767
> Apr  5 12:03:49 sysresccd kernel:   .sched_goidle                  : 152099
> Apr  5 12:03:49 sysresccd kernel:   .avg_idle                      : 1000000
> Apr  5 12:03:49 sysresccd kernel:   .max_idle_balance_cost         : 500000
> Apr  5 12:03:49 sysresccd kernel:   .ttwu_count                    : 205133
> Apr  5 12:03:49 sysresccd kernel:   .ttwu_local                    : 194650
> Apr  5 12:03:49 sysresccd kernel: \x0acfs_rq[6]:
> Apr  5 12:03:49 sysresccd kernel:   .exec_clock                    : 77700.634577
> Apr  5 12:03:49 sysresccd kernel:   .MIN_vruntime                  : 0.000001
> Apr  5 12:03:49 sysresccd kernel:   .min_vruntime                  : 76454.784880
> Apr  5 12:03:49 sysresccd kernel:   .max_vruntime                  : 0.000001
> Apr  5 12:03:49 sysresccd kernel:   .spread                        : 0.000000
> Apr  5 12:03:49 sysresccd kernel:   .spread0                       : -72529.400827
> Apr  5 12:03:49 sysresccd kernel:   .nr_spread_over                : 0
> Apr  5 12:03:49 sysresccd kernel:   .nr_running                    : 0
> Apr  5 12:03:49 sysresccd kernel:   .load                          : 0
> Apr  5 12:03:49 sysresccd kernel:   .load_avg                      : 0
> Apr  5 12:03:49 sysresccd kernel:   .runnable_load_avg             : 0
> Apr  5 12:03:49 sysresccd kernel:   .util_avg                      : 0
> Apr  5 12:03:49 sysresccd kernel:   .removed_load_avg              : 0
> Apr  5 12:03:49 sysresccd kernel:   .removed_util_avg              : 0
> Apr  5 12:03:49 sysresccd kernel: \x0art_rq[6]:
> Apr  5 12:03:49 sysresccd kernel:   .rt_nr_running                 : 0
> Apr  5 12:03:49 sysresccd kernel:   .rt_throttled                  : 0
> Apr  5 12:03:49 sysresccd kernel:   .rt_time                       : 0.000000
> Apr  5 12:03:49 sysresccd kernel:   .rt_runtime                    : 950.000000
> Apr  5 12:03:49 sysresccd kernel: \x0adl_rq[6]:
> Apr  5 12:03:49 sysresccd kernel:   .dl_nr_running                 : 0
> Apr  5 12:03:49 sysresccd kernel: \x0arunnable tasks:\x0a            task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep\x0a----------------------------------------------------------------------------------------------------------
> Apr  5 12:03:49 sysresccd kernel:       watchdog/6    48        -8.996082      1362     0         0.005317         8.434528         0.001878 0 0
> Apr  5 12:03:49 sysresccd kernel:      migration/6    49         0.000000       138     0         0.000698         1.169702         0.001366 0 0
> Apr  5 12:03:49 sysresccd kernel:      ksoftirqd/6    50      1565.456823        82   120         0.031438         0.184278      2356.951185 0 0
> Apr  5 12:03:49 sysresccd kernel:     kworker/6:0H    52      1714.416778         8   100         0.023846         0.052774      9620.884917 0 0
> Apr  5 12:03:49 sysresccd kernel:        kdevtmpfs    55      5732.831278       200   120         1.843946         3.649216     18491.949009 0 0
> Apr  5 12:03:49 sysresccd kernel:      kworker/6:1    74     76454.784880    154877   120       598.081463     12370.456720   5417756.641002 0 0
> Apr  5 12:03:49 sysresccd kernel:      kworker/6:2   147      1611.700595        14   120         0.062795         0.515034       503.143827 0 0
> Apr  5 12:03:49 sysresccd kernel:     kworker/6:1H   547     70202.968976        83   100        16.865324         1.089153   3163459.927213 0 0
> Apr  5 12:03:49 sysresccd kernel:   NetworkManager  1777     76442.662486       213   120         3.862983       252.283980   5399641.054454 0 0
> Apr  5 12:03:49 sysresccd kernel: 

