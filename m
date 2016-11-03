Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from corp-mailer.zoner.com ([217.198.120.77]:36527 "EHLO
        corp-mailer.zoner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbcKCMEp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2016 08:04:45 -0400
Subject: Re: Quota-enabled XFS hangs during mount
References: <e26e98c9-d183-acde-0ebd-8e285d0ae03c@zoner.cz>
 <20161101215803.GA14023@dastard>
 <cad65166-6d77-3c6f-151b-5970b1b6fc85@zoner.cz>
 <20161103013153.GH9920@dastard>
From: Martin Svec <martin.svec@zoner.cz>
Message-ID: <7993e9b8-6eb8-6a0d-aa72-01346cca1b63@zoner.cz>
Date: Thu, 3 Nov 2016 13:04:39 +0100
MIME-Version: 1.0
In-Reply-To: <20161103013153.GH9920@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org


Dne 3.11.2016 v 2:31 Dave Chinner napsal(a):
> On Wed, Nov 02, 2016 at 05:31:00PM +0100, Martin Svec wrote:
>> Hello,
>>
>> Dne 1.11.2016 v 22:58 Dave Chinner napsal(a):
>>> On Tue, Nov 01, 2016 at 05:45:04PM +0100, Martin Svec wrote:
>>>> Hello,
>>>>
>>>> with user and group quotas enabled, XFS freezes during mount and the following error is reported to
>>>> dmesg (Debian 8 kernel 3.16.0-4):
>> <SNIP>
>>>> Ugh. Please turn on CONFIG_FRAME_POINTER=y. However, it still looks
>>>> like it's waiting on IO completion.
>> Below is a vanilla 4.6.7 calltrace compiled with frame pointers:
>>
>> [  360.235106] INFO: task mount:785 blocked for more than 120 seconds.
>> [  360.235143]       Tainted: G            E   4.6.7-xfs1 #20
>> [  360.235167] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [  360.235200] mount           D ffff88007a1df978     0   785    737 0x00000000
>> [  360.235238]  ffff88007a1df978 00000001c01d7770 ffffffff81c0d540 ffff880036d44240
>> [  360.235276]  ffff88007a1e0000 7fffffffffffffff ffff880079e5fe80 ffff880036d44240
>> [  360.235313]  ffff88007a1dfb08 ffff88007a1df990 ffffffff815fd4e5 ffff880079e5fe88
>> [  360.236367] Call Trace:
>> [  360.237057]  [<ffffffff815fd4e5>] schedule+0x35/0x80
>> [  360.237753]  [<ffffffff8160065f>] schedule_timeout+0x22f/0x2c0
>> [  360.238448]  [<ffffffff8133607d>] ? radix_tree_lookup+0xd/0x10
>> [  360.239238]  [<ffffffffc019c8da>] ? xfs_perag_get+0x2a/0xb0 [xfs]
>> [  360.239979]  [<ffffffff815fdfaa>] wait_for_completion+0xfa/0x130
>> [  360.240672]  [<ffffffff810aa250>] ? wake_up_q+0x70/0x70
>> [  360.241395]  [<ffffffffc01dce42>] xfs_qm_flush_one+0x82/0xc0 [xfs]
>> [  360.242094]  [<ffffffffc01dcdc0>] ? xfs_qm_dqattach_one+0x120/0x120 [xfs]
>> [  360.242795]  [<ffffffffc01dd23c>] xfs_qm_dquot_walk.isra.10+0xec/0x170 [xfs]
>> [  360.243513]  [<ffffffffc01df295>] xfs_qm_quotacheck+0x255/0x310 [xfs]
>> [  360.244202]  [<ffffffffc01df434>] xfs_qm_mount_quotas+0xe4/0x170 [xfs]
> So this is waiting for the flush lock to be released before writing
> the dquot to disk. Something else is holding on to it...
>
>>>>          =                       crc=0        finobt=0
>>>> data     =                       bsize=4096   blocks=66846464, imaxpct=25
>>>>          =                       sunit=0      swidth=0 blks
>>>> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
>>>> log      =internal               bsize=4096   blocks=2560, version=2
>>>>          =                       sectsz=512   sunit=0 blks, lazy-count=1
>>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>>>
>>>> Disk usage:
>>>>
>>>> orthosie:~# df
>>>> Filesystem     1K-blocks      Used Available Use% Mounted on
>>>> /dev/sdd1      267375616 225270324  42105292  85% /www
>>> How many inodes? How much RAM?
>> orthosie:~# df -i
>> Filesystem        Inodes   IUsed     IFree IUse% Mounted on
>> /dev/sdd1      173746096 5214637 168531459    4% /www
>>
>> The virtual machine has 2 virtual cores and 2 GB RAM. None of it is a bottleneck, I think.
> Even though you think this is irrelevant and not important, it
> actually points me directly at a potential vector and a reason as to
> why this is not a comonly seen problem.
>
> i.e. 5.2 million inodes with only 2GB RAM is enough to cause memory
> pressure during a quotacheck. inode buffers alone will require
> a minimum of 1.5GB RAM over the course of the quotacheck, and memory
> reclaim will iterate cached dquots and try to flush them, thereby
> exercising the flush lock /before/ the quotacheck scan completion
> dquot writeback tries to take it.
>
> Now I need to go read code....

Yes, that makes sense, I didn't know that quotacheck requires all inodes to be loaded in memory at
the same time. I temporarily increased virtual machine's RAM to 3GB and the problem is gone! Setting
RAM back to 2GB reproducibly causes the quotacheck to freeze again, 1GB of RAM results in OOM... So
you're right that the flush deadlock is triggered by a memory pressure.

>>>> Any ideas what's wrong? How can I help to fix the problem? Note
>>>> that the server is a non-production clone of a virtual machine
>>>> where the problem originally occurred. So I'm free to any tests
>>>> and experiments.
>>> What else is stuck when the hung task trigger fires (sysrq-w
>>> output)? Is there still IO going on when the hung task warning comes
>>> up, or it the system completely idle at this point?
>> The system is fully responsive, no other hung tasks or system stalls. Only load average is increased
>> to 1.0 due to the hung kernel task. There's no I/O on the affected block device and the system is idle.
> So there's no /visible/ issues. But, there's still other things that
> can be hidden (e.g. IO submission/completion stall resulting in the
> flush lock not being released) which is why I asked for the output
> of sysrq-w as it may fill in a missing piece of the puzzle.

Sorry, I forgot to attach sysrq-w output to the previous response. Here it is:

[  462.295305] sysrq: SysRq : Show Blocked State
[  462.296077]   task                        PC stack   pid father
[  462.296807] mount           D ffff880079407978     0  2396    751 0x00000000
[  462.297301]  ffff880079407978 ffffffff8106f8a0 ffff88007be28e80 ffff88007a766180
[  462.297800]  ffff880079408000 7fffffffffffffff ffff880036788ec0 ffff88007a766180
[  462.298239]  ffff880079407b08 ffff880079407990 ffffffff815fd4e5 ffff880036788ec8
[  462.298695] Call Trace:
[  462.299154]  [<ffffffff8106f8a0>] ? leave_mm+0xd0/0xd0
[  462.299626]  [<ffffffff815fd4e5>] schedule+0x35/0x80
[  462.300130]  [<ffffffff8160065f>] schedule_timeout+0x22f/0x2c0
[  462.300702]  [<ffffffff8106f8cf>] ? do_flush_tlb_all+0x2f/0x50
[  462.301247]  [<ffffffff810e61aa>] ? kfree_call_rcu+0x1a/0x20
[  462.301757]  [<ffffffff811c61bf>] ? __free_vmap_area+0xaf/0xe0
[  462.302282]  [<ffffffff815fdfaa>] wait_for_completion+0xfa/0x130
[  462.302886]  [<ffffffff810aa250>] ? wake_up_q+0x70/0x70
[  462.303484]  [<ffffffffc022ae42>] xfs_qm_flush_one+0x82/0xc0 [xfs]
[  462.304124]  [<ffffffffc022adc0>] ? xfs_qm_dqattach_one+0x120/0x120 [xfs]
[  462.304711]  [<ffffffffc022b23c>] xfs_qm_dquot_walk.isra.10+0xec/0x170 [xfs]
[  462.305333]  [<ffffffffc022d295>] xfs_qm_quotacheck+0x255/0x310 [xfs]
[  462.305989]  [<ffffffffc022d434>] xfs_qm_mount_quotas+0xe4/0x170 [xfs]
[  462.306604]  [<ffffffffc020eb64>] xfs_mountfs+0x804/0x870 [xfs]
[  462.307177]  [<ffffffffc02113df>] xfs_fs_fill_super+0x3af/0x4c0 [xfs]
[  462.307763]  [<ffffffff8120860d>] mount_bdev+0x17d/0x1b0
[  462.308317]  [<ffffffffc0211030>] ? xfs_test_remount_options.isra.11+0x60/0x60 [xfs]
[  462.308920]  [<ffffffffc020fe65>] xfs_fs_mount+0x15/0x20 [xfs]
[  462.309461]  [<ffffffff81208f08>] mount_fs+0x38/0x170
[  462.310006]  [<ffffffff812255e4>] vfs_kern_mount+0x64/0x110
[  462.310564]  [<ffffffff81227c88>] do_mount+0x248/0xde0
[  462.311120]  [<ffffffff811a2841>] ? strndup_user+0x41/0x80
[  462.311660]  [<ffffffff8122781c>] ? copy_mount_options+0x2c/0x230
[  462.312207]  [<ffffffff81228b14>] SyS_mount+0x94/0xd0
[  462.312743]  [<ffffffff816013b6>] entry_SYSCALL_64_fastpath+0x1e/0xa8
[  462.313317] Sched Debug Version: v0.11, 4.6.7-xfs1 #20
[  462.313851] ktime                                   : 462193.003345
[  462.314394] sched_clk                               : 462313.316138
[  462.314905] cpu_clk                                 : 462313.316200
[  462.315413] jiffies                                 : 4295007839
[  462.315953] sched_clock_stable()                    : 1

[  462.317109] sysctl_sched
[  462.317788]   .sysctl_sched_latency                    : 12.000000
[  462.318425]   .sysctl_sched_min_granularity            : 1.500000
[  462.318893]   .sysctl_sched_wakeup_granularity         : 2.000000
[  462.319381]   .sysctl_sched_child_runs_first           : 0
[  462.319858]   .sysctl_sched_features                   : 44859
[  462.320438]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)

[  462.321771] cpu#0, 2660.000 MHz
[  462.322431]   .nr_running                    : 0
[  462.323017]   .load                          : 0
[  462.323470]   .nr_switches                   : 454314
[  462.323897]   .nr_load_updates               : 42789
[  462.324318]   .nr_uninterruptible            : -3
[  462.324777]   .next_balance                  : 4295.007840
[  462.325187]   .curr->pid                     : 0
[  462.325588]   .clock                         : 462292.366411
[  462.326011]   .clock_task                    : 462292.366411
[  462.326454]   .cpu_load[0]                   : 0
[  462.326885]   .cpu_load[1]                   : 0
[  462.327259]   .cpu_load[2]                   : 0
[  462.327624]   .cpu_load[3]                   : 0
[  462.327977]   .cpu_load[4]                   : 0
[  462.328308]   .avg_idle                      : 1000000
[  462.328637]   .max_idle_balance_cost         : 500000
[  462.328973]
cfs_rq[0]:/autogroup-62
[  462.329602]   .exec_clock                    : 0.000000
[  462.329950]   .MIN_vruntime                  : 0.000001
[  462.330285]   .min_vruntime                  : 187.518705
[  462.330598]   .max_vruntime                  : 0.000001
[  462.330919]   .spread                        : 0.000000
[  462.331209]   .spread0                       : -91717.326560
[  462.331499]   .nr_spread_over                : 0
[  462.331791]   .nr_running                    : 0
[  462.332082]   .load                          : 0
[  462.332362]   .load_avg                      : 0
[  462.332640]   .runnable_load_avg             : 0
[  462.332945]   .util_avg                      : 0
[  462.333218]   .removed_load_avg              : 0
[  462.333488]   .removed_util_avg              : 0
[  462.333759]   .tg_load_avg_contrib           : 0
[  462.334029]   .tg_load_avg                   : 0
[  462.334304]   .throttled                     : 0
[  462.334549]   .throttle_count                : 0
[  462.334798]   .se->exec_start                : 404942.448560
[  462.335050]   .se->vruntime                  : 91865.832206
[  462.335299]   .se->sum_exec_runtime          : 148.354327
[  462.335551]   .se->load.weight               : 2
[  462.335838]   .se->avg.load_avg              : 0
[  462.336088]   .se->avg.util_avg              : 0
[  462.336332]
cfs_rq[0]:/autogroup-61
[  462.336806]   .exec_clock                    : 0.000000
[  462.337062]   .MIN_vruntime                  : 0.000001
[  462.337310]   .min_vruntime                  : 11.257044
[  462.337569]   .max_vruntime                  : 0.000001
[  462.337830]   .spread                        : 0.000000
[  462.338121]   .spread0                       : -91893.588221
[  462.338395]   .nr_spread_over                : 0
[  462.338656]   .nr_running                    : 0
[  462.338945]   .load                          : 0
[  462.339198]   .load_avg                      : 0
[  462.339446]   .runnable_load_avg             : 0
[  462.339688]   .util_avg                      : 0
[  462.339941]   .removed_load_avg              : 0
[  462.340184]   .removed_util_avg              : 0
[  462.340425]   .tg_load_avg_contrib           : 0
[  462.340677]   .tg_load_avg                   : 0
[  462.340926]   .throttled                     : 0
[  462.341162]   .throttle_count                : 0
[  462.341397]   .se->exec_start                : 51004.340340
[  462.341640]   .se->vruntime                  : 2865.114846
[  462.341896]   .se->sum_exec_runtime          : 0.305629
[  462.342160]   .se->load.weight               : 2
[  462.342440]   .se->avg.load_avg              : 980
[  462.342692]   .se->avg.util_avg              : 982
[  462.342955]
cfs_rq[0]:/autogroup-60
[  462.343446]   .exec_clock                    : 0.000000
[  462.343710]   .MIN_vruntime                  : 0.000001
[  462.343986]   .min_vruntime                  : 88.722500
[  462.344249]   .max_vruntime                  : 0.000001
[  462.344528]   .spread                        : 0.000000
[  462.344810]   .spread0                       : -91816.122765
[  462.345064]   .nr_spread_over                : 0
[  462.345319]   .nr_running                    : 0
[  462.345576]   .load                          : 0
[  462.345839]   .load_avg                      : 0
[  462.346088]   .runnable_load_avg             : 0
[  462.346333]   .util_avg                      : 0
[  462.346589]   .removed_load_avg              : 0
[  462.346845]   .removed_util_avg              : 0
[  462.347089]   .tg_load_avg_contrib           : 0
[  462.347357]   .tg_load_avg                   : 0
[  462.347637]   .throttled                     : 0
[  462.347903]   .throttle_count                : 0
[  462.348140]   .se->exec_start                : 456158.428284
[  462.348385]   .se->vruntime                  : 91895.352880
[  462.348635]   .se->sum_exec_runtime          : 89.786969
[  462.348897]   .se->load.weight               : 2
[  462.349150]   .se->avg.load_avg              : 0
[  462.349402]   .se->avg.util_avg              : 2
[  462.349655]
cfs_rq[0]:/autogroup-59
[  462.350180]   .exec_clock                    : 0.000000
[  462.350446]   .MIN_vruntime                  : 0.000001
[  462.350734]   .min_vruntime                  : 12.488910
[  462.351028]   .max_vruntime                  : 0.000001
[  462.351289]   .spread                        : 0.000000
[  462.351546]   .spread0                       : -91892.356355
[  462.351809]   .nr_spread_over                : 0
[  462.352065]   .nr_running                    : 0
[  462.352348]   .load                          : 0
[  462.352624]   .load_avg                      : 0
[  462.352883]   .runnable_load_avg             : 0
[  462.353126]   .util_avg                      : 0
[  462.353371]   .removed_load_avg              : 0
[  462.353625]   .removed_util_avg              : 0
[  462.353876]   .tg_load_avg_contrib           : 0
[  462.354121]   .tg_load_avg                   : 0
[  462.354363]   .throttled                     : 0
[  462.354614]   .throttle_count                : 0
[  462.354859]   .se->exec_start                : 33456.488236
[  462.355129]   .se->vruntime                  : 2837.717546
[  462.355380]   .se->sum_exec_runtime          : 1.690766
[  462.355631]   .se->load.weight               : 2
[  462.355891]   .se->avg.load_avg              : 0
[  462.356141]   .se->avg.util_avg              : 0
[  462.356406]
cfs_rq[0]:/autogroup-47
[  462.357014]   .exec_clock                    : 0.000000
[  462.357302]   .MIN_vruntime                  : 0.000001
[  462.357598]   .min_vruntime                  : 12.083386
[  462.357870]   .max_vruntime                  : 0.000001
[  462.358143]   .spread                        : 0.000000
[  462.358463]   .spread0                       : -91892.761879
[  462.358750]   .nr_spread_over                : 0
[  462.359052]   .nr_running                    : 0
[  462.359329]   .load                          : 0
[  462.359595]   .load_avg                      : 0
[  462.359852]   .runnable_load_avg             : 0
[  462.360095]   .util_avg                      : 0
[  462.360370]   .removed_load_avg              : 0
[  462.360626]   .removed_util_avg              : 0
[  462.360879]   .tg_load_avg_contrib           : 0
[  462.361124]   .tg_load_avg                   : 0
[  462.361379]   .throttled                     : 0
[  462.361691]   .throttle_count                : 0
[  462.361952]   .se->exec_start                : 113208.734565
[  462.362198]   .se->vruntime                  : 83282.297802
[  462.362464]   .se->sum_exec_runtime          : 13.137219
[  462.362779]   .se->load.weight               : 2
[  462.363058]   .se->avg.load_avg              : 0
[  462.363324]   .se->avg.util_avg              : 0
[  462.363618]
cfs_rq[0]:/autogroup-58
[  462.364141]   .exec_clock                    : 0.000000
[  462.364420]   .MIN_vruntime                  : 0.000001
[  462.364720]   .min_vruntime                  : 223.582544
[  462.365007]   .max_vruntime                  : 0.000001
[  462.365279]   .spread                        : 0.000000
[  462.365546]   .spread0                       : -91681.262721
[  462.365836]   .nr_spread_over                : 0
[  462.366102]   .nr_running                    : 0
[  462.366371]   .load                          : 0
[  462.366651]   .load_avg                      : 0
[  462.366917]   .runnable_load_avg             : 0
[  462.367163]   .util_avg                      : 0
[  462.367423]   .removed_load_avg              : 0
[  462.367701]   .removed_util_avg              : 0
[  462.367961]   .tg_load_avg_contrib           : 0
[  462.368207]   .tg_load_avg                   : 0
[  462.368462]   .throttled                     : 0
[  462.368709]   .throttle_count                : 0
[  462.368961]   .se->exec_start                : 113176.634023
[  462.369206]   .se->vruntime                  : 83294.933428
[  462.369471]   .se->sum_exec_runtime          : 20.437799
[  462.369733]   .se->load.weight               : 2
[  462.370009]   .se->avg.load_avg              : 0
[  462.370273]   .se->avg.util_avg              : 0
[  462.370574]
cfs_rq[0]:/autogroup-57
[  462.371157]   .exec_clock                    : 0.000000
[  462.371437]   .MIN_vruntime                  : 0.000001
[  462.371715]   .min_vruntime                  : 8.478759
[  462.371995]   .max_vruntime                  : 0.000001
[  462.372266]   .spread                        : 0.000000
[  462.372523]   .spread0                       : -91896.366506
[  462.372828]   .nr_spread_over                : 0
[  462.373084]   .nr_running                    : 0
[  462.373354]   .load                          : 0
[  462.373694]   .load_avg                      : 0
[  462.373973]   .runnable_load_avg             : 0
[  462.374250]   .util_avg                      : 0
[  462.374527]   .removed_load_avg              : 0
[  462.374864]   .removed_util_avg              : 0
[  462.375128]   .tg_load_avg_contrib           : 0
[  462.375426]   .tg_load_avg                   : 0
[  462.375680]   .throttled                     : 0
[  462.375985]   .throttle_count                : 0
[  462.376298]   .se->exec_start                : 82654.618332
[  462.376652]   .se->vruntime                  : 83206.046297
[  462.377067]   .se->sum_exec_runtime          : 9.527335
[  462.377471]   .se->load.weight               : 2
[  462.377847]   .se->avg.load_avg              : 0
[  462.378258]   .se->avg.util_avg              : 0
[  462.378679]
cfs_rq[0]:/autogroup-55
[  462.379437]   .exec_clock                    : 0.000000
[  462.379704]   .MIN_vruntime                  : 0.000001
[  462.380096]   .min_vruntime                  : 19879.466082
[  462.380361]   .max_vruntime                  : 0.000001
[  462.380718]   .spread                        : 0.000000
[  462.381013]   .spread0                       : -72025.379183
[  462.381314]   .nr_spread_over                : 0
[  462.381622]   .nr_running                    : 0
[  462.381981]   .load                          : 0
[  462.382344]   .load_avg                      : 0
[  462.382595]   .runnable_load_avg             : 0
[  462.382912]   .util_avg                      : 0
[  462.383179]   .removed_load_avg              : 0
[  462.383428]   .removed_util_avg              : 0
[  462.383673]   .tg_load_avg_contrib           : 0
[  462.383920]   .tg_load_avg                   : 0
[  462.384166]   .throttled                     : 0
[  462.384420]   .throttle_count                : 0
[  462.384693]   .se->exec_start                : 181692.001889
[  462.384965]   .se->vruntime                  : 90410.132225
[  462.385257]   .se->sum_exec_runtime          : 40599.541322
[  462.385626]   .se->load.weight               : 2
[  462.385994]   .se->avg.load_avg              : 625
[  462.386301]   .se->avg.util_avg              : 687
[  462.386610]
cfs_rq[0]:/autogroup-37
[  462.387344]   .exec_clock                    : 0.000000
[  462.387750]   .MIN_vruntime                  : 0.000001
[  462.388154]   .min_vruntime                  : 9.344022
[  462.388551]   .max_vruntime                  : 0.000001
[  462.388943]   .spread                        : 0.000000
[  462.389327]   .spread0                       : -91895.501243
[  462.389709]   .nr_spread_over                : 0
[  462.390141]   .nr_running                    : 0
[  462.390608]   .load                          : 0
[  462.391008]   .load_avg                      : 0
[  462.391412]   .runnable_load_avg             : 0
[  462.391780]   .util_avg                      : 0
[  462.392150]   .removed_load_avg              : 0
[  462.392519]   .removed_util_avg              : 0
[  462.392886]   .tg_load_avg_contrib           : 0
[  462.393254]   .tg_load_avg                   : 0
[  462.393630]   .throttled                     : 0
[  462.393987]   .throttle_count                : 0
[  462.394342]   .se->exec_start                : 422903.764171
[  462.394702]   .se->vruntime                  : 91876.772725
[  462.395068]   .se->sum_exec_runtime          : 10.397192
[  462.395445]   .se->load.weight               : 2
[  462.395841]   .se->avg.load_avg              : 0
[  462.396216]   .se->avg.util_avg              : 0
[  462.396591]
cfs_rq[0]:/autogroup-52
[  462.397384]   .exec_clock                    : 0.000000
[  462.397789]   .MIN_vruntime                  : 0.000001
[  462.398250]   .min_vruntime                  : 219.440001
[  462.398646]   .max_vruntime                  : 0.000001
[  462.399032]   .spread                        : 0.000000
[  462.399417]   .spread0                       : -91685.405264
[  462.399861]   .nr_spread_over                : 0
[  462.400242]   .nr_running                    : 0
[  462.400692]   .load                          : 0
[  462.401068]   .load_avg                      : 0
[  462.401498]   .runnable_load_avg             : 0
[  462.401907]   .util_avg                      : 0
[  462.402284]   .removed_load_avg              : 0
[  462.402679]   .removed_util_avg              : 0
[  462.403050]   .tg_load_avg_contrib           : 0
[  462.403385]   .tg_load_avg                   : 0
[  462.403750]   .throttled                     : 0
[  462.404038]   .throttle_count                : 0
[  462.404324]   .se->exec_start                : 460223.481983
[  462.404714]   .se->vruntime                  : 91897.963442
[  462.405086]   .se->sum_exec_runtime          : 217.488580
[  462.405450]   .se->load.weight               : 2
[  462.405827]   .se->avg.load_avg              : 0
[  462.406190]   .se->avg.util_avg              : 0
[  462.406554]
cfs_rq[0]:/autogroup-50
[  462.407339]   .exec_clock                    : 0.000000
[  462.407783]   .MIN_vruntime                  : 0.000001
[  462.408217]   .min_vruntime                  : 12.124731
[  462.408656]   .max_vruntime                  : 0.000001
[  462.409084]   .spread                        : 0.000000
[  462.409509]   .spread0                       : -91892.720534
[  462.409903]   .nr_spread_over                : 0
[  462.410318]   .nr_running                    : 0
[  462.410711]   .load                          : 0
[  462.411103]   .load_avg                      : 0
[  462.411526]   .runnable_load_avg             : 0
[  462.411935]   .util_avg                      : 0
[  462.412314]   .removed_load_avg              : 0
[  462.412753]   .removed_util_avg              : 0
[  462.413151]   .tg_load_avg_contrib           : 0
[  462.413528]   .tg_load_avg                   : 0
[  462.413904]   .throttled                     : 0
[  462.414271]   .throttle_count                : 0
[  462.414634]   .se->exec_start                : 461665.890376
[  462.415006]   .se->vruntime                  : 91898.375632
[  462.415391]   .se->sum_exec_runtime          : 13.173307
[  462.415833]   .se->load.weight               : 2
[  462.417002]   .se->avg.load_avg              : 0
[  462.417267]   .se->avg.util_avg              : 1
[  462.417539]
cfs_rq[0]:/autogroup-49
[  462.418054]   .exec_clock                    : 0.000000
[  462.418326]   .MIN_vruntime                  : 0.000001
[  462.418628]   .min_vruntime                  : 9.236210
[  462.418912]   .max_vruntime                  : 0.000001
[  462.419175]   .spread                        : 0.000000
[  462.419434]   .spread0                       : -91895.609055
[  462.419693]   .nr_spread_over                : 0
[  462.419963]   .nr_running                    : 0
[  462.420223]   .load                          : 0
[  462.420480]   .load_avg                      : 0
[  462.420743]   .runnable_load_avg             : 0
[  462.421003]   .util_avg                      : 0
[  462.421251]   .removed_load_avg              : 0
[  462.421499]   .removed_util_avg              : 0
[  462.421744]   .tg_load_avg_contrib           : 0
[  462.422002]   .tg_load_avg                   : 0
[  462.422245]   .throttled                     : 0
[  462.422484]   .throttle_count                : 0
[  462.422739]   .se->exec_start                : 431824.249417
[  462.423000]   .se->vruntime                  : 91884.161790
[  462.423252]   .se->sum_exec_runtime          : 9.521671
[  462.423505]   .se->load.weight               : 2
[  462.423761]   .se->avg.load_avg              : 0
[  462.424045]   .se->avg.util_avg              : 47
[  462.424301]
cfs_rq[0]:/autogroup-42
[  462.424805]   .exec_clock                    : 0.000000
[  462.425073]   .MIN_vruntime                  : 0.000001
[  462.425343]   .min_vruntime                  : 4.512197
[  462.425616]   .max_vruntime                  : 0.000001
[  462.425876]   .spread                        : 0.000000
[  462.426132]   .spread0                       : -91900.333068
[  462.426386]   .nr_spread_over                : 0
[  462.426641]   .nr_running                    : 0
[  462.426898]   .load                          : 0
[  462.427150]   .load_avg                      : 0
[  462.427397]   .runnable_load_avg             : 0
[  462.427646]   .util_avg                      : 0
[  462.427910]   .removed_load_avg              : 0
[  462.428155]   .removed_util_avg              : 0
[  462.428398]   .tg_load_avg_contrib           : 0
[  462.428641]   .tg_load_avg                   : 0
[  462.428883]   .throttled                     : 0
[  462.429120]   .throttle_count                : 0
[  462.429357]   .se->exec_start                : 434448.392510
[  462.429601]   .se->vruntime                  : 91882.921012
[  462.429852]   .se->sum_exec_runtime          : 7.259057
[  462.430124]   .se->load.weight               : 2
[  462.430379]   .se->avg.load_avg              : 0
[  462.430642]   .se->avg.util_avg              : 0
[  462.430897]
cfs_rq[0]:/autogroup-38
[  462.431404]   .exec_clock                    : 0.000000
[  462.431674]   .MIN_vruntime                  : 0.000001
[  462.431956]   .min_vruntime                  : 4.777201
[  462.432221]   .max_vruntime                  : 0.000001
[  462.432481]   .spread                        : 0.000000
[  462.432736]   .spread0                       : -91900.068064
[  462.432990]   .nr_spread_over                : 0
[  462.433245]   .nr_running                    : 0
[  462.433594]   .load                          : 0
[  462.433847]   .load_avg                      : 0
[  462.434093]   .runnable_load_avg             : 0
[  462.434335]   .util_avg                      : 0
[  462.434577]   .removed_load_avg              : 0
[  462.434821]   .removed_util_avg              : 0
[  462.435062]   .tg_load_avg_contrib           : 0
[  462.435305]   .tg_load_avg                   : 0
[  462.435546]   .throttled                     : 0
[  462.435783]   .throttle_count                : 0
[  462.436029]   .se->exec_start                : 12825.415658
[  462.436284]   .se->vruntime                  : 2649.784213
[  462.436586]   .se->sum_exec_runtime          : 5.825777
[  462.436894]   .se->load.weight               : 2
[  462.437146]   .se->avg.load_avg              : 874
[  462.437451]   .se->avg.util_avg              : 893
[  462.437813]
cfs_rq[0]:/autogroup-35
[  462.438479]   .exec_clock                    : 0.000000
[  462.438852]   .MIN_vruntime                  : 0.000001
[  462.439234]   .min_vruntime                  : 216.087685
[  462.439607]   .max_vruntime                  : 0.000001
[  462.439999]   .spread                        : 0.000000
[  462.440388]   .spread0                       : -91688.757580
[  462.440790]   .nr_spread_over                : 0
[  462.441182]   .nr_running                    : 0
[  462.441577]   .load                          : 0
[  462.441965]   .load_avg                      : 0
[  462.442348]   .runnable_load_avg             : 0
[  462.442711]   .util_avg                      : 0
[  462.443086]   .removed_load_avg              : 0
[  462.443466]   .removed_util_avg              : 0
[  462.443848]   .tg_load_avg_contrib           : 0
[  462.444224]   .tg_load_avg                   : 0
[  462.444600]   .throttled                     : 0
[  462.444968]   .throttle_count                : 0
[  462.445340]   .se->exec_start                : 243983.494595
[  462.445717]   .se->vruntime                  : 91767.490672
[  462.446101]   .se->sum_exec_runtime          : 177.704106
[  462.446496]   .se->load.weight               : 2
[  462.446885]   .se->avg.load_avg              : 0
[  462.447274]   .se->avg.util_avg              : 0
[  462.447676]
cfs_rq[0]:/autogroup-32
[  462.448438]   .exec_clock                    : 0.000000
[  462.448850]   .MIN_vruntime                  : 0.000001
[  462.449269]   .min_vruntime                  : 1.120529
[  462.449678]   .max_vruntime                  : 0.000001
[  462.450083]   .spread                        : 0.000000
[  462.450482]   .spread0                       : -91903.724736
[  462.450879]   .nr_spread_over                : 0
[  462.451272]   .nr_running                    : 0
[  462.451668]   .load                          : 0
[  462.452063]   .load_avg                      : 0
[  462.452411]   .runnable_load_avg             : 0
[  462.452745]   .util_avg                      : 0
[  462.453088]   .removed_load_avg              : 0
[  462.453425]   .removed_util_avg              : 0
[  462.453782]   .tg_load_avg_contrib           : 0
[  462.454110]   .tg_load_avg                   : 0
[  462.454445]   .throttled                     : 0
[  462.454773]   .throttle_count                : 0
[  462.455115]   .se->exec_start                : 12786.955843
[  462.455464]   .se->vruntime                  : 2620.170455
[  462.455827]   .se->sum_exec_runtime          : 2.169105
[  462.456193]   .se->load.weight               : 2
[  462.456563]   .se->avg.load_avg              : 919
[  462.456932]   .se->avg.util_avg              : 962
[  462.457313]
cfs_rq[0]:/autogroup-31
[  462.458071]   .exec_clock                    : 0.000000
[  462.458467]   .MIN_vruntime                  : 0.000001
[  462.458858]   .min_vruntime                  : 5.183863
[  462.459255]   .max_vruntime                  : 0.000001
[  462.459640]   .spread                        : 0.000000
[  462.460020]   .spread0                       : -91899.661402
[  462.460400]   .nr_spread_over                : 0
[  462.460789]   .nr_running                    : 0
[  462.461172]   .load                          : 0
[  462.461575]   .load_avg                      : 0
[  462.461946]   .runnable_load_avg             : 0
[  462.462308]   .util_avg                      : 0
[  462.462667]   .removed_load_avg              : 0
[  462.463020]   .removed_util_avg              : 0
[  462.463385]   .tg_load_avg_contrib           : 0
[  462.463796]   .tg_load_avg                   : 0
[  462.464159]   .throttled                     : 0
[  462.464558]   .throttle_count                : 0
[  462.464914]   .se->exec_start                : 50972.682116
[  462.465299]   .se->vruntime                  : 2857.839803
[  462.465675]   .se->sum_exec_runtime          : 6.232439
[  462.466051]   .se->load.weight               : 2
[  462.466430]   .se->avg.load_avg              : 0
[  462.466794]   .se->avg.util_avg              : 0
[  462.467171]
cfs_rq[0]:/autogroup-30
[  462.467999]   .exec_clock                    : 0.000000
[  462.468482]   .MIN_vruntime                  : 0.000001
[  462.468900]   .min_vruntime                  : 11.679088
[  462.469297]   .max_vruntime                  : 0.000001
[  462.469709]   .spread                        : 0.000000
[  462.470094]   .spread0                       : -91893.166177
[  462.470540]   .nr_spread_over                : 0
[  462.470940]   .nr_running                    : 0
[  462.471325]   .load                          : 0
[  462.471728]   .load_avg                      : 0
[  462.472102]   .runnable_load_avg             : 0
[  462.472457]   .util_avg                      : 0
[  462.472747]   .removed_load_avg              : 0
[  462.472999]   .removed_util_avg              : 0
[  462.473248]   .tg_load_avg_contrib           : 0
[  462.473498]   .tg_load_avg                   : 0
[  462.473747]   .throttled                     : 0
[  462.473988]   .throttle_count                : 0
[  462.474228]   .se->exec_start                : 431825.066078
[  462.474477]   .se->vruntime                  : 91887.715643
[  462.474995]   .se->sum_exec_runtime          : 12.727664
[  462.475344]   .se->load.weight               : 2
[  462.475759]   .se->avg.load_avg              : 59
[  462.476118]   .se->avg.util_avg              : 79
[  462.476462]
cfs_rq[0]:/autogroup-27
[  462.477217]   .exec_clock                    : 0.000000
[  462.477616]   .MIN_vruntime                  : 0.000001
[  462.478046]   .min_vruntime                  : 5.019920
[  462.478469]   .max_vruntime                  : 0.000001
[  462.478873]   .spread                        : 0.000000
[  462.479266]   .spread0                       : -91899.825345
[  462.480469]   .nr_spread_over                : 0
[  462.480901]   .nr_running                    : 0
[  462.481333]   .load                          : 0
[  462.481911]   .load_avg                      : 0
[  462.482380]   .runnable_load_avg             : 0
[  462.482866]   .util_avg                      : 0
[  462.483323]   .removed_load_avg              : 0
[  462.483722]   .removed_util_avg              : 0
[  462.484102]   .tg_load_avg_contrib           : 0
[  462.484494]   .tg_load_avg                   : 0
[  462.484962]   .throttled                     : 0
[  462.485396]   .throttle_count                : 0
[  462.485778]   .se->exec_start                : 12685.424743
[  462.486172]   .se->vruntime                  : 2605.811372
[  462.486572]   .se->sum_exec_runtime          : 0.068501
[  462.487021]   .se->load.weight               : 2
[  462.487479]   .se->avg.load_avg              : 1004
[  462.487939]   .se->avg.util_avg              : 1002
[  462.488355]
cfs_rq[0]:/autogroup-25
[  462.489172]   .exec_clock                    : 0.000000
[  462.489654]   .MIN_vruntime                  : 0.000001
[  462.490092]   .min_vruntime                  : 6.062059
[  462.490548]   .max_vruntime                  : 0.000001
[  462.490963]   .spread                        : 0.000000
[  462.491328]   .spread0                       : -91898.783206
[  462.491592]   .nr_spread_over                : 0
[  462.491920]   .nr_running                    : 0
[  462.492247]   .load                          : 0
[  462.492525]   .load_avg                      : 0
[  462.492800]   .runnable_load_avg             : 0
[  462.493077]   .util_avg                      : 0
[  462.493325]   .removed_load_avg              : 0
[  462.493575]   .removed_util_avg              : 0
[  462.493838]   .tg_load_avg_contrib           : 0
[  462.494099]   .tg_load_avg                   : 0
[  462.494372]   .throttled                     : 0
[  462.494632]   .throttle_count                : 0
[  462.494886]   .se->exec_start                : 433015.309969
[  462.495230]   .se->vruntime                  : 91882.215729
[  462.495498]   .se->sum_exec_runtime          : 7.114925
[  462.495759]   .se->load.weight               : 2
[  462.496042]   .se->avg.load_avg              : 0
[  462.496319]   .se->avg.util_avg              : 0
[  462.496576]
cfs_rq[0]:/autogroup-13
[  462.497115]   .exec_clock                    : 0.000000
[  462.497399]   .MIN_vruntime                  : 0.000001
[  462.497752]   .min_vruntime                  : 84.205281
[  462.498021]   .max_vruntime                  : 0.000001
[  462.498299]   .spread                        : 0.000000
[  462.498570]   .spread0                       : -91820.639984
[  462.498880]   .nr_spread_over                : 0
[  462.499150]   .nr_running                    : 0
[  462.499450]   .load                          : 0
[  462.499705]   .load_avg                      : 0
[  462.499977]   .runnable_load_avg             : 0
[  462.500239]   .util_avg                      : 0
[  462.500493]   .removed_load_avg              : 0
[  462.500760]   .removed_util_avg              : 0
[  462.501036]   .tg_load_avg_contrib           : 0
[  462.501382]   .tg_load_avg                   : 0
[  462.501629]   .throttled                     : 0
[  462.501888]   .throttle_count                : 0
[  462.502138]   .se->exec_start                : 15978.835141
[  462.502570]   .se->vruntime                  : 2779.755693
[  462.502930]   .se->sum_exec_runtime          : 316.039578
[  462.503293]   .se->load.weight               : 2
[  462.503562]   .se->avg.load_avg              : 0
[  462.503830]   .se->avg.util_avg              : 21
[  462.504118]
cfs_rq[0]:/autogroup-9
[  462.504698]   .exec_clock                    : 0.000000
[  462.505054]   .MIN_vruntime                  : 0.000001
[  462.505379]   .min_vruntime                  : 114.891206
[  462.505835]   .max_vruntime                  : 0.000001
[  462.506126]   .spread                        : 0.000000
[  462.506471]   .spread0                       : -91789.954059
[  462.506758]   .nr_spread_over                : 0
[  462.507035]   .nr_running                    : 0
[  462.507365]   .load                          : 0
[  462.507652]   .load_avg                      : 0
[  462.507934]   .runnable_load_avg             : 0
[  462.508193]   .util_avg                      : 0
[  462.508461]   .removed_load_avg              : 0
[  462.508710]   .removed_util_avg              : 0
[  462.509012]   .tg_load_avg_contrib           : 0
[  462.509322]   .tg_load_avg                   : 0
[  462.509586]   .throttled                     : 0
[  462.510031]   .throttle_count                : 0
[  462.510463]   .se->exec_start                : 414823.928222
[  462.510918]   .se->vruntime                  : 91873.289531
[  462.511413]   .se->sum_exec_runtime          : 115.976164
[  462.511821]   .se->load.weight               : 2
[  462.512245]   .se->avg.load_avg              : 0
[  462.512654]   .se->avg.util_avg              : 15
[  462.513081]
cfs_rq[0]:/autogroup-2
[  462.513926]   .exec_clock                    : 0.000000
[  462.514370]   .MIN_vruntime                  : 0.000001
[  462.514791]   .min_vruntime                  : 329.078508
[  462.515238]   .max_vruntime                  : 0.000001
[  462.515662]   .spread                        : 0.000000
[  462.516093]   .spread0                       : -91575.766757
[  462.516519]   .nr_spread_over                : 0
[  462.516952]   .nr_running                    : 0
[  462.517381]   .load                          : 0
[  462.517810]   .load_avg                      : 0
[  462.518215]   .runnable_load_avg             : 0
[  462.518619]   .util_avg                      : 0
[  462.519000]   .removed_load_avg              : 0
[  462.519399]   .removed_util_avg              : 0
[  462.519794]   .tg_load_avg_contrib           : 0
[  462.520188]   .tg_load_avg                   : 0
[  462.520601]   .throttled                     : 0
[  462.521005]   .throttle_count                : 0
[  462.521429]   .se->exec_start                : 422903.926696
[  462.521939]   .se->vruntime                  : 91876.842124
[  462.522346]   .se->sum_exec_runtime          : 244.785609
[  462.522760]   .se->load.weight               : 2
[  462.523165]   .se->avg.load_avg              : 0
[  462.523574]   .se->avg.util_avg              : 3
[  462.524023]
cfs_rq[0]:/
[  462.524834]   .exec_clock                    : 0.000000
[  462.525272]   .MIN_vruntime                  : 0.000001
[  462.525713]   .min_vruntime                  : 91904.845265
[  462.526167]   .max_vruntime                  : 0.000001
[  462.526578]   .spread                        : 0.000000
[  462.527000]   .spread0                       : 0.000000
[  462.527397]   .nr_spread_over                : 0
[  462.527850]   .nr_running                    : 0
[  462.528221]   .load                          : 0
[  462.528787]   .load_avg                      : 1
[  462.529175]   .runnable_load_avg             : 0
[  462.529674]   .util_avg                      : 1
[  462.530057]   .removed_load_avg              : 0
[  462.530452]   .removed_util_avg              : 0
[  462.530868]   .tg_load_avg_contrib           : 0
[  462.531475]   .tg_load_avg                   : 0
[  462.531876]   .throttled                     : 0
[  462.532268]   .throttle_count                : 0
[  462.532655]
rt_rq[0]:
[  462.533374]   .rt_nr_running                 : 0
[  462.533843]   .rt_throttled                  : 0
[  462.534264]   .rt_time                       : 0.000000
[  462.534742]   .rt_runtime                    : 950.000000
[  462.535125]
dl_rq[0]:
[  462.535885]   .dl_nr_running                 : 0
[  462.536271]   .dl_bw->bw                     : 996147
[  462.536674]   .dl_bw->total_bw               : 0
[  462.537056]
runnable tasks:
            task   PID         tree-key  switches  prio     wait-time             sum-exec       
sum-sleep
----------------------------------------------------------------------------------------------------------
[  462.539560]         kthreadd     2     91811.440089       210   120  0 0 /
[  462.540324]      ksoftirqd/0     3     91894.083494      5178   120  0 0 /
[  462.540892]           rcu_bh     8       159.941246         2   120  0 0 /
[  462.541466]      migration/0     9         0.000000       124     0  0 0 /
[  462.542052]       watchdog/0    10         0.000000       118     0  0 0 /
[  462.542718]          cpuhp/0    11       166.945640         3   120  0 0 /
[  462.543332]      kworker/0:1    24     91904.845265     21871   120  0 0 /
[  462.543917]             ksmd    25       190.442452         3   125  0 0 /
[  462.544489]   kworker/u128:1    34     91872.072130      7815   120  0 0 /
[  462.545144]          kswapd0    36     90500.089372      2115   120  0 0 /
[  462.545747]           vmstat    37       612.109590         2   100  0 0 /
[  462.546361]         kthrotld    50       690.521744         2   100  0 0 /
[  462.546966]    ipv6_addrconf    51       696.665219         2   100  0 0 /
[  462.547585]          deferwq    56       708.148716         2   100  0 0 /
[  462.548145]           bioset    91       771.860716         2   100  0 0 /
[  462.548899]           bioset    93       781.842637         2   100  0 0 /
[  462.549623]           bioset    95       790.430772         2   100  0 0 /
[  462.550310]           bioset    96       791.482629         2   100  0 0 /
[  462.550966]           bioset    98       802.590800         2   100  0 0 /
[  462.551787]        kpsmoused    99       901.459332         2   100  0 0 /
[  462.552483]          ata_sff   100       900.771985         2   100  0 0 /
[  462.553169]       mpt_poll_0   102       904.111929         2   100  0 0 /
[  462.553803]            mpt/0   103       907.457071         2   100  0 0 /
[  462.554458]       scsi_tmf_0   104       910.792727         2   100  0 0 /
[  462.555129]  vmw_pvscsi_wq_0   105       915.400961         2   100  0 0 /
[  462.555770]       scsi_tmf_1   132      1037.281989         2   100  0 0 /
[  462.556466]        scsi_eh_2   134      1112.940612         4   120  0 0 /
[  462.557124]       scsi_tmf_2   135      1047.284707         2   100  0 0 /
[  462.557805]        scsi_eh_3   136      1839.973612        39   120  0 0 /
[  462.558534]           bioset   156      1118.949688         2   100  0 0 /
[  462.559214]     xfs-buf/sda1   182      1191.650044         2   100  0 0 /
[  462.559914]  xfs-reclaim/sda   186      1197.656541         2   100  0 0 /
[  462.560623]  xfs-eofblocks/s   188      1203.665215         2   100  0 0 /
[  462.561508]          kauditd   222      1368.959153         2   120  0 0 /
[  462.562313]      kworker/0:4   230      2938.711518       166   120  0 0 /
[  462.562926]     kworker/0:1H   308     91779.896668        55   100  0 0 /
[  462.563528]     xfs-buf/sdb1   371      2137.955692         2   100  0 0 /
[  462.564140]    xfs-data/sdb1   373      2143.961061         2   100  0 0 /
[  462.564711]    xfs-conv/sdb1   374      2147.996790         2   100  0 0 /
[  462.565282]     xfs-cil/sdb1   375      2151.357789         2   100  0 0 /
[  462.565899]     xfs-log/sdb1   384      2174.279884         2   100  0 0 /
[  462.566451]      jbd2/sde1-8   403      2210.784891         2   120  0 0 /
[  462.567048]  ext4-rsv-conver   404      2216.787706         2   100  0 0 /
[  462.567665]     xfs-buf/sdc1   410      2236.936894         2   100  0 0 /
[  462.568201]    xfs-data/sdc1   411      2240.938843         2   100  0 0 /
[  462.568754]    xfs-conv/sdc1   412      2244.940799         2   100  0 0 /
[  462.569291]     xfs-cil/sdc1   413      2248.942688         2   100  0 0 /
[  462.569821]  xfs-reclaim/sdc   414      2252.944454         2   100  0 0 /
[  462.570367]     xfs-log/sdc1   415      2256.946310         2   100  0 0 /
[  462.570931]  xfs-eofblocks/s   416      2260.948117         2   100  0 0 /
[  462.571448]     xfsaild/sdc1   417     91901.798444      4462   120  0 0 /
[  462.572077]          rpcbind   541         6.062059        47   120  0 0 /autogroup-25
[  462.572691]           rpciod   555      2618.686186         2   100  0 0 /
[  462.573262]             cron   566        11.679088        60   120  0 0 /autogroup-30
[  462.573865]             sshd   567         5.183863        31   120  0 0 /autogroup-31
[  462.574480]            inetd   569         1.120529         6   120  0 0 /autogroup-32
[  462.575088]             sshd   574         4.777201        12   120  0 0 /autogroup-38
[  462.575794]   systemd-logind   579         9.344022       170   120  0 0 /autogroup-37
[  462.576509]             nscd   590         4.512197       130   120  0 0 /autogroup-42
[  462.577249]             nscd   604         3.394059        21   120  0 0 /autogroup-42
[  462.577889]             nscd   608         0.389864        20   120  0 0 /autogroup-42
[  462.578547]      in:imuxsock   648         7.447796       104   120  0 0 /autogroup-49
[  462.579124]    rs:main Q:Reg   650         9.236210       144   120  0 0 /autogroup-49
[  462.579741]            acpid   641        12.124731       234   120  0 0 /autogroup-50
[  462.580334]            snmpd   646       219.440001       459   120  0 0 /autogroup-52
[  462.581037]            login   651        23.625560        98   120  0 0 /autogroup-55
[  462.581879]  console-kit-dae   675       213.404551        10   120  0 0 /autogroup-58
[  462.582458]  console-kit-dae   676       125.708346        14   120  0 0 /autogroup-58
[  462.583072]  console-kit-dae   678        15.347871         6   120  0 0 /autogroup-58
[  462.583663]  console-kit-dae   681        17.788519         4   120  0 0 /autogroup-58
[  462.584241]  console-kit-dae   684        65.757289         8   120  0 0 /autogroup-58
[  462.584839]  console-kit-dae   686       125.711327         8   120  0 0 /autogroup-58
[  462.585438]  console-kit-dae   687       125.708576         6   120  0 0 /autogroup-58
[  462.585979]  console-kit-dae   688       125.708979         6   120  0 0 /autogroup-58
[  462.586513]  console-kit-dae   691       125.708219         6   120  0 0 /autogroup-58
[  462.587076]  console-kit-dae   692       125.708265         6   120  0 0 /autogroup-58
[  462.587611]  console-kit-dae   696       125.708577         5   120  0 0 /autogroup-58
[  462.588120]  console-kit-dae   698       125.708235         8   120  0 0 /autogroup-58
[  462.588676]  console-kit-dae   701       125.709998         5   120  0 0 /autogroup-58
[  462.589178]  console-kit-dae   702       125.708696         4   120  0 0 /autogroup-58
[  462.589656]  console-kit-dae   703        65.752207         2   120  0 0 /autogroup-58
[  462.590178]  console-kit-dae   704       125.709634         3   120  0 0 /autogroup-58
[  462.590654]  console-kit-dae   705       125.708667         3   120  0 0 /autogroup-58
[  462.591125]  console-kit-dae   706       125.708904         3   120  0 0 /autogroup-58
[  462.591622]  console-kit-dae   707       125.708280         3   120  0 0 /autogroup-58
[  462.592162]  console-kit-dae   708        60.713960         3   120  0 0 /autogroup-58
[  462.592669]  console-kit-dae   710       125.708607         3   120  0 0 /autogroup-58
[  462.593109]  console-kit-dae   711       125.708183         3   120  0 0 /autogroup-58
[  462.593541]  console-kit-dae   712       125.708867         4   120  0 0 /autogroup-58
[  462.593995]  console-kit-dae   713       125.721446         2   120  0 0 /autogroup-58
[  462.594414]  console-kit-dae   714       125.717784         2   120  0 0 /autogroup-58
[  462.594794]  console-kit-dae   715       125.709235         2   120  0 0 /autogroup-58
[  462.595176]  console-kit-dae   716       125.708822         2   120  0 0 /autogroup-58
[  462.595666]  console-kit-dae   717       125.711658         2   120  0 0 /autogroup-58
[  462.596038]  console-kit-dae   718       125.708379         2   120  0 0 /autogroup-58
[  462.596408]  console-kit-dae   719       125.708324         2   120  0 0 /autogroup-58
[  462.596825]  console-kit-dae   720       125.708401         2   120  0 0 /autogroup-58
[  462.597180]  console-kit-dae   721       125.708249         2   120  0 0 /autogroup-58
[  462.597562]  console-kit-dae   722       125.708378         2   120  0 0 /autogroup-58
[  462.597902]  console-kit-dae   723       125.708303         2   120  0 0 /autogroup-58
[  462.598215]  console-kit-dae   724       125.708498         2   120  0 0 /autogroup-58
[  462.598508]  console-kit-dae   725       125.708357         2   120  0 0 /autogroup-58
[  462.598857]  console-kit-dae   726       125.708368         2   120  0 0 /autogroup-58
[  462.599140]  console-kit-dae   727       125.708470         2   120  0 0 /autogroup-58
[  462.599448]  console-kit-dae   728       125.712925         2   120  0 0 /autogroup-58
[  462.599740]  console-kit-dae   729       125.709008         2   120  0 0 /autogroup-58
[  462.600013]  console-kit-dae   730       125.709533         2   120  0 0 /autogroup-58
[  462.600300]  console-kit-dae   731       125.714935         2   120  0 0 /autogroup-58
[  462.600566]  console-kit-dae   732       125.712391         2   120  0 0 /autogroup-58
[  462.600861]  console-kit-dae   733       127.278435         4   120  0 0 /autogroup-58
[  462.601135]  console-kit-dae   735       129.691958         2   120  0 0 /autogroup-58
[  462.601411]  console-kit-dae   736       131.705909         1   120  0 0 /autogroup-58
[  462.601706]            gmain   738       213.385735         7   120  0 0 /autogroup-58
[  462.601997]            gdbus   739       181.010558        20   120  0 0 /autogroup-58
[  462.602322]            gmain   743        12.488910         3   120  0 0 /autogroup-59
[  462.602645]             sshd   760        17.527422        52   120  0 0 /autogroup-60
[  462.602972]         (sd-pam)   763         5.052313         1   120  0 0 /autogroup-61
[  462.603301]             sshd   768        88.722500      5152   120  0 0 /autogroup-60
[  462.603620]             bash   769         8.625220        24   120  0 0 /autogroup-62
[  462.603992]     kworker/0:2H  1948     91897.151042       105   100  0 0 /
[  462.604350]    xfs-data/sdd1  2398     83312.995619         2   100  0 0 /
[  462.604706]     xfs-cil/sdd1  2400     83316.022795         2   100  0 0 /
[  462.605108]     xfs-log/sdd1  2402     83322.024569         2   100  0 0 /
[  462.605486]     xfsaild/sdd1  2404     83328.028638         2   120  0 0 /

[  462.606250] cpu#1, 2660.000 MHz
[  462.606603]   .nr_running                    : 0
[  462.606992]   .load                          : 0
[  462.607367]   .nr_switches                   : 453166
[  462.607939]   .nr_load_updates               : 34036
[  462.608394]   .nr_uninterruptible            : 4
[  462.608852]   .next_balance                  : 4295.007918
[  462.609433]   .curr->pid                     : 0
[  462.609967]   .clock                         : 462609.676134
[  462.610397]   .clock_task                    : 462609.676134
[  462.610993]   .cpu_load[0]                   : 0
[  462.611482]   .cpu_load[1]                   : 0
[  462.611915]   .cpu_load[2]                   : 0
[  462.612363]   .cpu_load[3]                   : 0
[  462.612809]   .cpu_load[4]                   : 0
[  462.613289]   .avg_idle                      : 1000000
[  462.613710]   .max_idle_balance_cost         : 500000
[  462.614151]
cfs_rq[1]:/autogroup-62
[  462.615115]   .exec_clock                    : 0.000000
[  462.615750]   .MIN_vruntime                  : 0.000001
[  462.616253]   .min_vruntime                  : 100.207673
[  462.616771]   .max_vruntime                  : 0.000001
[  462.617273]   .spread                        : 0.000000
[  462.617783]   .spread0                       : -91804.637592
[  462.618246]   .nr_spread_over                : 0
[  462.618731]   .nr_running                    : 0
[  462.619314]   .load                          : 0
[  462.619784]   .load_avg                      : 0
[  462.620240]   .runnable_load_avg             : 0
[  462.620682]   .util_avg                      : 0
[  462.621138]   .removed_load_avg              : 0
[  462.621575]   .removed_util_avg              : 0
[  462.622002]   .tg_load_avg_contrib           : 0
[  462.622430]   .tg_load_avg                   : 0
[  462.622860]   .throttled                     : 0
[  462.623270]   .throttle_count                : 0
[  462.623673]   .se->exec_start                : 456158.367218
[  462.624089]   .se->vruntime                  : 96256.746452
[  462.624535]   .se->sum_exec_runtime          : 73.375191
[  462.624967]   .se->load.weight               : 2
[  462.625412]   .se->avg.load_avg              : 0
[  462.625815]   .se->avg.util_avg              : 7
[  462.626224]
cfs_rq[1]:/autogroup-61
[  462.627013]   .exec_clock                    : 0.000000
[  462.627433]   .MIN_vruntime                  : 0.000001
[  462.627898]   .min_vruntime                  : 15.554767
[  462.628319]   .max_vruntime                  : 0.000001
[  462.628730]   .spread                        : 0.000000
[  462.629162]   .spread0                       : -91889.290498
[  462.629588]   .nr_spread_over                : 0
[  462.630033]   .nr_running                    : 0
[  462.630445]   .load                          : 0
[  462.630909]   .load_avg                      : 0
[  462.631315]   .runnable_load_avg             : 0
[  462.631756]   .util_avg                      : 0
[  462.632154]   .removed_load_avg              : 0
[  462.632569]   .removed_util_avg              : 0
[  462.632986]   .tg_load_avg_contrib           : 0
[  462.633382]   .tg_load_avg                   : 0
[  462.633789]   .throttled                     : 0
[  462.634190]   .throttle_count                : 0
[  462.634585]   .se->exec_start                : 160444.892784
[  462.634997]   .se->vruntime                  : 82835.815607
[  462.635427]   .se->sum_exec_runtime          : 16.608561
[  462.635836]   .se->load.weight               : 2
[  462.636273]   .se->avg.load_avg              : 32
[  462.636680]   .se->avg.util_avg              : 59
[  462.637108]
cfs_rq[1]:/autogroup-60
[  462.637946]   .exec_clock                    : 0.000000
[  462.638376]   .MIN_vruntime                  : 0.000001
[  462.638808]   .min_vruntime                  : 51.482128
[  462.639263]   .max_vruntime                  : 0.000001
[  462.639685]   .spread                        : 0.000000
[  462.640100]   .spread0                       : -91853.363137
[  462.640513]   .nr_spread_over                : 0
[  462.640928]   .nr_running                    : 0
[  462.641347]   .load                          : 0
[  462.641766]   .load_avg                      : 0
[  462.642187]   .runnable_load_avg             : 0
[  462.642580]   .util_avg                      : 0
[  462.642999]   .removed_load_avg              : 0
[  462.643400]   .removed_util_avg              : 0
[  462.643809]   .tg_load_avg_contrib           : 0
[  462.644224]   .tg_load_avg                   : 0
[  462.644618]   .throttled                     : 0
[  462.645020]   .throttle_count                : 0
[  462.645419]   .se->exec_start                : 177037.746075
[  462.645877]   .se->vruntime                  : 90411.039925
[  462.646297]   .se->sum_exec_runtime          : 40.641666
[  462.646718]   .se->load.weight               : 2
[  462.647156]   .se->avg.load_avg              : 0
[  462.647586]   .se->avg.util_avg              : 2
[  462.648019]
cfs_rq[1]:/autogroup-59
[  462.648852]   .exec_clock                    : 0.000000
[  462.649294]   .MIN_vruntime                  : 0.000001
[  462.649782]   .min_vruntime                  : 9.646785
[  462.650223]   .max_vruntime                  : 0.000001
[  462.650738]   .spread                        : 0.000000
[  462.651169]   .spread0                       : -91895.198480
[  462.651584]   .nr_spread_over                : 0
[  462.652073]   .nr_running                    : 0
[  462.652491]   .load                          : 0
[  462.652933]   .load_avg                      : 0
[  462.653350]   .runnable_load_avg             : 0
[  462.653763]   .util_avg                      : 0
[  462.654177]   .removed_load_avg              : 0
[  462.654589]   .removed_util_avg              : 0
[  462.654986]   .tg_load_avg_contrib           : 0
[  462.655398]   .tg_load_avg                   : 0
[  462.655805]   .throttled                     : 0
[  462.656208]   .throttle_count                : 0
[  462.656635]   .se->exec_start                : 54144.878777
[  462.657045]   .se->vruntime                  : 4025.267645
[  462.657468]   .se->sum_exec_runtime          : 11.936382
[  462.657885]   .se->load.weight               : 2
[  462.658317]   .se->avg.load_avg              : 3
[  462.658733]   .se->avg.util_avg              : 2
[  462.659141]
cfs_rq[1]:/autogroup-58
[  462.659963]   .exec_clock                    : 0.000000
[  462.660410]   .MIN_vruntime                  : 0.000001
[  462.660841]   .min_vruntime                  : 107.724609
[  462.661296]   .max_vruntime                  : 0.000001
[  462.661733]   .spread                        : 0.000000
[  462.662162]   .spread0                       : -91797.120656
[  462.662579]   .nr_spread_over                : 0
[  462.663007]   .nr_running                    : 0
[  462.663454]   .load                          : 0
[  462.663880]   .load_avg                      : 0
[  462.664298]   .runnable_load_avg             : 0
[  462.664725]   .util_avg                      : 0
[  462.665154]   .removed_load_avg              : 0
[  462.665671]   .removed_util_avg              : 0
[  462.666081]   .tg_load_avg_contrib           : 0
[  462.666468]   .tg_load_avg                   : 0
[  462.666875]   .throttled                     : 0
[  462.667276]   .throttle_count                : 0
[  462.667669]   .se->exec_start                : 455568.845851
[  462.668082]   .se->vruntime                  : 96256.025299
[  462.668512]   .se->sum_exec_runtime          : 40.894209
[  462.668937]   .se->load.weight               : 2
[  462.669371]   .se->avg.load_avg              : 0
[  462.669774]   .se->avg.util_avg              : 0
[  462.670252]
cfs_rq[1]:/autogroup-57
[  462.671106]   .exec_clock                    : 0.000000
[  462.671566]   .MIN_vruntime                  : 0.000001
[  462.672047]   .min_vruntime                  : 11.321708
[  462.672490]   .max_vruntime                  : 0.000001
[  462.672911]   .spread                        : 0.000000
[  462.673344]   .spread0                       : -91893.523557
[  462.673754]   .nr_spread_over                : 0
[  462.674185]   .nr_running                    : 0
[  462.674606]   .load                          : 0
[  462.675016]   .load_avg                      : 0
[  462.675435]   .runnable_load_avg             : 0
[  462.675831]   .util_avg                      : 0
[  462.676241]   .removed_load_avg              : 0
[  462.676636]   .removed_util_avg              : 0
[  462.677047]   .tg_load_avg_contrib           : 0
[  462.677440]   .tg_load_avg                   : 0
[  462.677857]   .throttled                     : 0
[  462.678273]   .throttle_count                : 0
[  462.678702]   .se->exec_start                : 160455.062923
[  462.679181]   .se->vruntime                  : 82837.417723
[  462.679600]   .se->sum_exec_runtime          : 5.015129
[  462.680033]   .se->load.weight               : 2
[  462.680447]   .se->avg.load_avg              : 54
[  462.680926]   .se->avg.util_avg              : 51
[  462.681434]
cfs_rq[1]:/autogroup-55
[  462.682378]   .exec_clock                    : 0.000000
[  462.682834]   .MIN_vruntime                  : 0.000001
[  462.683297]   .min_vruntime                  : 26353.557990
[  462.683841]   .max_vruntime                  : 0.000001
[  462.684265]   .spread                        : 0.000000
[  462.684720]   .spread0                       : -65551.287275
[  462.685168]   .nr_spread_over                : 0
[  462.685603]   .nr_running                    : 0
[  462.686036]   .load                          : 0
[  462.686440]   .load_avg                      : 0
[  462.686848]   .runnable_load_avg             : 0
[  462.687244]   .util_avg                      : 0
[  462.687672]   .removed_load_avg              : 0
[  462.688088]   .removed_util_avg              : 0
[  462.688487]   .tg_load_avg_contrib           : 0
[  462.688878]   .tg_load_avg                   : 0
[  462.689177]   .throttled                     : 0
[  462.689424]   .throttle_count                : 0
[  462.689669]   .se->exec_start                : 184443.301360
[  462.689941]   .se->vruntime                  : 95679.992291
[  462.690212]   .se->sum_exec_runtime          : 45623.192994
[  462.690561]   .se->load.weight               : 2
[  462.691061]   .se->avg.load_avg              : 927
[  462.691441]   .se->avg.util_avg              : 991
[  462.691707]
cfs_rq[1]:/autogroup-52
[  462.692249]   .exec_clock                    : 0.000000
[  462.692553]   .MIN_vruntime                  : 0.000001
[  462.692888]   .min_vruntime                  : 0.432282
[  462.693304]   .max_vruntime                  : 0.000001
[  462.693753]   .spread                        : 0.000000
[  462.694126]   .spread0                       : -91905.277547
[  462.694539]   .nr_spread_over                : 0
[  462.694965]   .nr_running                    : 0
[  462.695435]   .load                          : 0
[  462.695877]   .load_avg                      : 0
[  462.696330]   .runnable_load_avg             : 0
[  462.696943]   .util_avg                      : 0
[  462.697346]   .removed_load_avg              : 0
[  462.697766]   .removed_util_avg              : 0
[  462.698165]   .tg_load_avg_contrib           : 0
[  462.698553]   .tg_load_avg                   : 0
[  462.698948]   .throttled                     : 0
[  462.699333]   .throttle_count                : 0
[  462.699719]   .se->exec_start                : 12941.094671
[  462.700116]   .se->vruntime                  : 3421.487880
[  462.700546]   .se->sum_exec_runtime          : 0.616294
[  462.700974]   .se->load.weight               : 2
[  462.701502]   .se->avg.load_avg              : 1002
[  462.701952]   .se->avg.util_avg              : 1014
[  462.702381]
cfs_rq[1]:/autogroup-49
[  462.703187]   .exec_clock                    : 0.000000
[  462.703664]   .MIN_vruntime                  : 0.000001
[  462.704104]   .min_vruntime                  : 21.956887
[  462.704540]   .max_vruntime                  : 0.000001
[  462.704966]   .spread                        : 0.000000
[  462.705509]   .spread0                       : -91882.888378
[  462.705926]   .nr_spread_over                : 0
[  462.706347]   .nr_running                    : 0
[  462.706858]   .load                          : 0
[  462.707319]   .load_avg                      : 0
[  462.707774]   .runnable_load_avg             : 0
[  462.708187]   .util_avg                      : 0
[  462.708590]   .removed_load_avg              : 0
[  462.708996]   .removed_util_avg              : 0
[  462.709397]   .tg_load_avg_contrib           : 0
[  462.709801]   .tg_load_avg                   : 0
[  462.710204]   .throttled                     : 0
[  462.710765]   .throttle_count                : 0
[  462.711261]   .se->exec_start                : 414820.418682
[  462.711665]   .se->vruntime                  : 96223.234461
[  462.712228]   .se->sum_exec_runtime          : 25.392322
[  462.712719]   .se->load.weight               : 2
[  462.713155]   .se->avg.load_avg              : 0
[  462.713569]   .se->avg.util_avg              : 1
[  462.714006]
cfs_rq[1]:/autogroup-48
[  462.714832]   .exec_clock                    : 0.000000
[  462.715273]   .MIN_vruntime                  : 0.000001
[  462.715718]   .min_vruntime                  : 78.978747
[  462.716157]   .max_vruntime                  : 0.000001
[  462.716585]   .spread                        : 0.000000
[  462.717008]   .spread0                       : -91825.866518
[  462.717453]   .nr_spread_over                : 0
[  462.718085]   .nr_running                    : 0
[  462.718605]   .load                          : 0
[  462.719272]   .load_avg                      : 0
[  462.719684]   .runnable_load_avg             : 0
[  462.720185]   .util_avg                      : 0
[  462.720729]   .removed_load_avg              : 0
[  462.721200]   .removed_util_avg              : 0
[  462.721616]   .tg_load_avg_contrib           : 0
[  462.722035]   .tg_load_avg                   : 0
[  462.722523]   .throttled                     : 0
[  462.723069]   .throttle_count                : 0
[  462.723537]   .se->exec_start                : 461625.088839
[  462.723957]   .se->vruntime                  : 96259.858363
[  462.724449]   .se->sum_exec_runtime          : 80.057670
[  462.724946]   .se->load.weight               : 2
[  462.725377]   .se->avg.load_avg              : 0
[  462.725818]   .se->avg.util_avg              : 0
[  462.726248]
cfs_rq[1]:/autogroup-47
[  462.727077]   .exec_clock                    : 0.000000
[  462.727524]   .MIN_vruntime                  : 0.000001
[  462.727988]   .min_vruntime                  : 29.560219
[  462.728422]   .max_vruntime                  : 0.000001
[  462.729004]   .spread                        : 0.000000
[  462.729515]   .spread0                       : -91875.285046
[  462.730046]   .nr_spread_over                : 0
[  462.730475]   .nr_running                    : 0
[  462.730913]   .load                          : 0
[  462.731700]   .load_avg                      : 0
[  462.732117]   .runnable_load_avg             : 0
[  462.732523]   .util_avg                      : 0
[  462.733069]   .removed_load_avg              : 0
[  462.733526]   .removed_util_avg              : 0
[  462.733929]   .tg_load_avg_contrib           : 0
[  462.734402]   .tg_load_avg                   : 0
[  462.734852]   .throttled                     : 0
[  462.735337]   .throttle_count                : 0
[  462.735743]   .se->exec_start                : 455568.915713
[  462.736149]   .se->vruntime                  : 96255.900570
[  462.736786]   .se->sum_exec_runtime          : 30.620209
[  462.737222]   .se->load.weight               : 2
[  462.737666]   .se->avg.load_avg              : 0
[  462.738102]   .se->avg.util_avg              : 0
[  462.738523]
cfs_rq[1]:/autogroup-42
[  462.739346]   .exec_clock                    : 0.000000
[  462.739812]   .MIN_vruntime                  : 0.000001
[  462.740284]   .min_vruntime                  : 14.553354
[  462.740767]   .max_vruntime                  : 0.000001
[  462.741223]   .spread                        : 0.000000
[  462.741676]   .spread0                       : -91890.291911
[  462.742125]   .nr_spread_over                : 0
[  462.742618]   .nr_running                    : 0
[  462.743088]   .load                          : 0
[  462.743537]   .load_avg                      : 0
[  462.743978]   .runnable_load_avg             : 0
[  462.744391]   .util_avg                      : 0
[  462.744818]   .removed_load_avg              : 0
[  462.745236]   .removed_util_avg              : 0
[  462.745653]   .tg_load_avg_contrib           : 0
[  462.746058]   .tg_load_avg                   : 0
[  462.746478]   .throttled                     : 0
[  462.746915]   .throttle_count                : 0
[  462.747344]   .se->exec_start                : 461202.818601
[  462.747774]   .se->vruntime                  : 96259.039296
[  462.748183]   .se->sum_exec_runtime          : 27.834565
[  462.748622]   .se->load.weight               : 2
[  462.749058]   .se->avg.load_avg              : 0
[  462.749474]   .se->avg.util_avg              : 0
[  462.750076]
cfs_rq[1]:/autogroup-38
[  462.751200]   .exec_clock                    : 0.000000
[  462.751834]   .MIN_vruntime                  : 0.000001
[  462.752118]   .min_vruntime                  : 0.622215
[  462.752395]   .max_vruntime                  : 0.000001
[  462.752726]   .spread                        : 0.000000
[  462.753016]   .spread0                       : -91905.467480
[  462.753436]   .nr_spread_over                : 0
[  462.753827]   .nr_running                    : 0
[  462.754169]   .load                          : 0
[  462.754583]   .load_avg                      : 0
[  462.755091]   .runnable_load_avg             : 0
[  462.755450]   .util_avg                      : 0
[  462.755718]   .removed_load_avg              : 0
[  462.756184]   .removed_util_avg              : 0
[  462.756475]   .tg_load_avg_contrib           : 0
[  462.756831]   .tg_load_avg                   : 0
[  462.757133]   .throttled                     : 0
[  462.757397]   .throttle_count                : 0
[  462.757675]   .se->exec_start                : 12813.831796
[  462.757975]   .se->vruntime                  : 3373.789788
[  462.758247]   .se->sum_exec_runtime          : 0.290298
[  462.758622]   .se->load.weight               : 2
[  462.759003]   .se->avg.load_avg              : 1008
[  462.759443]   .se->avg.util_avg              : 1008
[  462.759806]
cfs_rq[1]:/autogroup-37
[  462.760471]   .exec_clock                    : 0.000000
[  462.760940]   .MIN_vruntime                  : 0.000001
[  462.761234]   .min_vruntime                  : 4.576649
[  462.761535]   .max_vruntime                  : 0.000001
[  462.761920]   .spread                        : 0.000000
[  462.762179]   .spread0                       : -91900.268616
[  462.762550]   .nr_spread_over                : 0
[  462.762809]   .nr_running                    : 0
[  462.763069]   .load                          : 0
[  462.763364]   .load_avg                      : 0
[  462.763671]   .runnable_load_avg             : 0
[  462.763936]   .util_avg                      : 0
[  462.764181]   .removed_load_avg              : 0
[  462.764514]   .removed_util_avg              : 0
[  462.764816]   .tg_load_avg_contrib           : 0
[  462.765062]   .tg_load_avg                   : 0
[  462.765382]   .throttled                     : 0
[  462.765622]   .throttle_count                : 0
[  462.765860]   .se->exec_start                : 51013.370967
[  462.766105]   .se->vruntime                  : 4020.556935
[  462.766468]   .se->sum_exec_runtime          : 5.462578
[  462.766813]   .se->load.weight               : 2
[  462.767066]   .se->avg.load_avg              : 17
[  462.767343]   .se->avg.util_avg              : 16
[  462.767624]
cfs_rq[1]:/autogroup-35
[  462.768120]   .exec_clock                    : 0.000000
[  462.768420]   .MIN_vruntime                  : 0.000001
[  462.768709]   .min_vruntime                  : 352.981057
[  462.769010]   .max_vruntime                  : 0.000001
[  462.769305]   .spread                        : 0.000000
[  462.769617]   .spread0                       : -91551.864208
[  462.769876]   .nr_spread_over                : 0
[  462.770168]   .nr_running                    : 0
[  462.770473]   .load                          : 0
[  462.770772]   .load_avg                      : 1
[  462.771046]   .runnable_load_avg             : 0
[  462.771406]   .util_avg                      : 1
[  462.771751]   .removed_load_avg              : 0
[  462.772089]   .removed_util_avg              : 0
[  462.772424]   .tg_load_avg_contrib           : 1
[  462.772790]   .tg_load_avg                   : 1
[  462.773157]   .throttled                     : 0
[  462.773574]   .throttle_count                : 0
[  462.773944]   .se->exec_start                : 462751.372563
[  462.774384]   .se->vruntime                  : 96265.932391
[  462.774686]   .se->sum_exec_runtime          : 339.060496
[  462.774979]   .se->load.weight               : 2
[  462.775306]   .se->avg.load_avg              : 0
[  462.775690]   .se->avg.util_avg              : 0
[  462.776080]
cfs_rq[1]:/autogroup-31
[  462.776948]   .exec_clock                    : 0.000000
[  462.777347]   .MIN_vruntime                  : 0.000001
[  462.777761]   .min_vruntime                  : 9.795279
[  462.778150]   .max_vruntime                  : 0.000001
[  462.778551]   .spread                        : 0.000000
[  462.778960]   .spread0                       : -91895.049986
[  462.779367]   .nr_spread_over                : 0
[  462.779753]   .nr_running                    : 0
[  462.780147]   .load                          : 0
[  462.780576]   .load_avg                      : 0
[  462.781071]   .runnable_load_avg             : 0
[  462.781454]   .util_avg                      : 0
[  462.781829]   .removed_load_avg              : 0
[  462.782225]   .removed_util_avg              : 0
[  462.782618]   .tg_load_avg_contrib           : 0
[  462.782995]   .tg_load_avg                   : 0
[  462.783532]   .throttled                     : 0
[  462.783942]   .throttle_count                : 0
[  462.784339]   .se->exec_start                : 48298.106526
[  462.784745]   .se->vruntime                  : 3973.803045
[  462.785154]   .se->sum_exec_runtime          : 4.843860
[  462.785551]   .se->load.weight               : 2
[  462.785958]   .se->avg.load_avg              : 0
[  462.786374]   .se->avg.util_avg              : 0
[  462.786781]
cfs_rq[1]:/autogroup-30
[  462.787694]   .exec_clock                    : 0.000000
[  462.788136]   .MIN_vruntime                  : 0.000001
[  462.788738]   .min_vruntime                  : 9.827771
[  462.789164]   .max_vruntime                  : 0.000001
[  462.789567]   .spread                        : 0.000000
[  462.790031]   .spread0                       : -91895.017494
[  462.790396]   .nr_spread_over                : 0
[  462.790947]   .nr_running                    : 0
[  462.791349]   .load                          : 0
[  462.791761]   .load_avg                      : 0
[  462.792149]   .runnable_load_avg             : 0
[  462.792548]   .util_avg                      : 0
[  462.792932]   .removed_load_avg              : 0
[  462.793558]   .removed_util_avg              : 0
[  462.793946]   .tg_load_avg_contrib           : 0
[  462.794327]   .tg_load_avg                   : 0
[  462.794758]   .throttled                     : 0
[  462.795110]   .throttle_count                : 0
[  462.795640]   .se->exec_start                : 431824.993065
[  462.796051]   .se->vruntime                  : 96236.729688
[  462.796509]   .se->sum_exec_runtime          : 4.876352
[  462.796958]   .se->load.weight               : 2
[  462.797353]   .se->avg.load_avg              : 10
[  462.797764]   .se->avg.util_avg              : 58
[  462.798248]
cfs_rq[1]:/autogroup-28
[  462.799243]   .exec_clock                    : 0.000000
[  462.799867]   .MIN_vruntime                  : 0.000001
[  462.800439]   .min_vruntime                  : 0.799425
[  462.800982]   .max_vruntime                  : 0.000001
[  462.801480]   .spread                        : 0.000000
[  462.802000]   .spread0                       : -91905.644690
[  462.802408]   .nr_spread_over                : 0
[  462.802902]   .nr_running                    : 0
[  462.803314]   .load                          : 0
[  462.803852]   .load_avg                      : 0
[  462.804341]   .runnable_load_avg             : 0
[  462.804798]   .util_avg                      : 0
[  462.805229]   .removed_load_avg              : 0
[  462.805771]   .removed_util_avg              : 0
[  462.806181]   .tg_load_avg_contrib           : 0
[  462.806714]   .tg_load_avg                   : 0
[  462.807234]   .throttled                     : 0
[  462.807741]   .throttle_count                : 0
[  462.808243]   .se->exec_start                : 12745.691690
[  462.808677]   .se->vruntime                  : 3348.098018
[  462.809129]   .se->sum_exec_runtime          : 0.249151
[  462.809617]   .se->load.weight               : 2
[  462.810080]   .se->avg.load_avg              : 1002
[  462.810500]   .se->avg.util_avg              : 1007
[  462.810971]
cfs_rq[1]:/autogroup-27
[  462.811824]   .exec_clock                    : 0.000000
[  462.812281]   .MIN_vruntime                  : 0.000001
[  462.812719]   .min_vruntime                  : 1.465336
[  462.813208]   .max_vruntime                  : 0.000001
[  462.813640]   .spread                        : 0.000000
[  462.814085]   .spread0                       : -91903.379929
[  462.814532]   .nr_spread_over                : 0
[  462.814952]   .nr_running                    : 0
[  462.815474]   .load                          : 0
[  462.815972]   .load_avg                      : 0
[  462.816395]   .runnable_load_avg             : 0
[  462.817027]   .util_avg                      : 0
[  462.817450]   .removed_load_avg              : 0
[  462.817852]   .removed_util_avg              : 0
[  462.818257]   .tg_load_avg_contrib           : 0
[  462.818719]   .tg_load_avg                   : 0
[  462.819120]   .throttled                     : 0
[  462.819511]   .throttle_count                : 0
[  462.819887]   .se->exec_start                : 12691.176851
[  462.820339]   .se->vruntime                  : 3304.991222
[  462.820774]   .se->sum_exec_runtime          : 4.475751
[  462.821172]   .se->load.weight               : 2
[  462.821682]   .se->avg.load_avg              : 910
[  462.822080]   .se->avg.util_avg              : 966
[  462.822529]
cfs_rq[1]:/autogroup-13
[  462.823412]   .exec_clock                    : 0.000000
[  462.823945]   .MIN_vruntime                  : 0.000001
[  462.824423]   .min_vruntime                  : 316.674841
[  462.824962]   .max_vruntime                  : 0.000001
[  462.825443]   .spread                        : 0.000000
[  462.825845]   .spread0                       : -91588.170424
[  462.826226]   .nr_spread_over                : 0
[  462.826642]   .nr_running                    : 0
[  462.827111]   .load                          : 0
[  462.827489]   .load_avg                      : 0
[  462.827964]   .runnable_load_avg             : 0
[  462.828382]   .util_avg                      : 0
[  462.828786]   .removed_load_avg              : 0
[  462.829305]   .removed_util_avg              : 0
[  462.829715]   .tg_load_avg_contrib           : 0
[  462.830162]   .tg_load_avg                   : 0
[  462.830520]   .throttled                     : 0
[  462.830927]   .throttle_count                : 0
[  462.831366]   .se->exec_start                : 163418.525100
[  462.831804]   .se->vruntime                  : 82852.021456
[  462.832184]   .se->sum_exec_runtime          : 377.435432
[  462.832601]   .se->load.weight               : 2
[  462.833034]   .se->avg.load_avg              : 10
[  462.833453]   .se->avg.util_avg              : 33
[  462.833876]
cfs_rq[1]:/autogroup-9
[  462.834627]   .exec_clock                    : 0.000000
[  462.834977]   .MIN_vruntime                  : 0.000001
[  462.835362]   .min_vruntime                  : 35.351011
[  462.835743]   .max_vruntime                  : 0.000001
[  462.836129]   .spread                        : 0.000000
[  462.836527]   .spread0                       : -91869.494254
[  462.837004]   .nr_spread_over                : 0
[  462.837477]   .nr_running                    : 0
[  462.838113]   .load                          : 0
[  462.838533]   .load_avg                      : 0
[  462.838973]   .runnable_load_avg             : 0
[  462.839390]   .util_avg                      : 0
[  462.840072]   .removed_load_avg              : 0
[  462.840625]   .removed_util_avg              : 0
[  462.841041]   .tg_load_avg_contrib           : 0
[  462.841424]   .tg_load_avg                   : 0
[  462.841889]   .throttled                     : 0
[  462.842350]   .throttle_count                : 0
[  462.842765]   .se->exec_start                : 431829.036822
[  462.843144]   .se->vruntime                  : 96236.111682
[  462.843635]   .se->sum_exec_runtime          : 36.430792
[  462.844051]   .se->load.weight               : 2
[  462.844490]   .se->avg.load_avg              : 6
[  462.845236]   .se->avg.util_avg              : 51
[  462.845729]
cfs_rq[1]:/autogroup-2
[  462.846582]   .exec_clock                    : 0.000000
[  462.847001]   .MIN_vruntime                  : 0.000001
[  462.847381]   .min_vruntime                  : 187.660129
[  462.847817]   .max_vruntime                  : 0.000001
[  462.848262]   .spread                        : 0.000000
[  462.848608]   .spread0                       : -91717.185136
[  462.848870]   .nr_spread_over                : 0
[  462.849250]   .nr_running                    : 0
[  462.849569]   .load                          : 0
[  462.849968]   .load_avg                      : 0
[  462.850431]   .runnable_load_avg             : 0
[  462.851109]   .util_avg                      : 0
[  462.851523]   .removed_load_avg              : 0
[  462.851981]   .removed_util_avg              : 0
[  462.852406]   .tg_load_avg_contrib           : 0
[  462.852812]   .tg_load_avg                   : 0
[  462.853264]   .throttled                     : 0
[  462.853688]   .throttle_count                : 0
[  462.854071]   .se->exec_start                : 431817.188929
[  462.854451]   .se->vruntime                  : 96233.301006
[  462.854922]   .se->sum_exec_runtime          : 164.839432
[  462.855352]   .se->load.weight               : 2
[  462.855726]   .se->avg.load_avg              : 0
[  462.856207]   .se->avg.util_avg              : 0
[  462.856605]
cfs_rq[1]:/
[  462.857433]   .exec_clock                    : 0.000000
[  462.857867]   .MIN_vruntime                  : 0.000001
[  462.858254]   .min_vruntime                  : 96265.988073
[  462.858769]   .max_vruntime                  : 0.000001
[  462.859210]   .spread                        : 0.000000
[  462.859608]   .spread0                       : 4361.142808
[  462.860015]   .nr_spread_over                : 0
[  462.860418]   .nr_running                    : 0
[  462.860842]   .load                          : 0
[  462.861252]   .load_avg                      : 5
[  462.861666]   .runnable_load_avg             : 0
[  462.862093]   .util_avg                      : 6
[  462.862482]   .removed_load_avg              : 0
[  462.862916]   .removed_util_avg              : 0
[  462.863303]   .tg_load_avg_contrib           : 0
[  462.863711]   .tg_load_avg                   : 0
[  462.864110]   .throttled                     : 0
[  462.864505]   .throttle_count                : 0
[  462.864898]
rt_rq[1]:
[  462.865648]   .rt_nr_running                 : 0
[  462.866035]   .rt_throttled                  : 0
[  462.866400]   .rt_time                       : 0.000000
[  462.866802]   .rt_runtime                    : 950.000000
[  462.867190]
dl_rq[1]:
[  462.867927]   .dl_nr_running                 : 0
[  462.868293]   .dl_bw->bw                     : 996147
[  462.868684]   .dl_bw->total_bw               : 0
[  462.869093]
runnable tasks:
            task   PID         tree-key  switches  prio     wait-time             sum-exec       
sum-sleep
----------------------------------------------------------------------------------------------------------
[  462.871988]          systemd     1       187.660129      1263   120  0 0 /autogroup-2
[  462.872653]        rcu_sched     7     96262.560605     31233   120  0 0 /
[  462.873274]          cpuhp/1    12        -4.001371         3   120  0 0 /
[  462.873948]       watchdog/1    13        -2.997144       118     0  0 0 /
[  462.874633]      migration/1    14         0.000000       169     0  0 0 /
[  462.875284]      ksoftirqd/1    15     96259.619447      5522   120  0 0 /
[  462.875965]     kworker/1:0H    17      3114.045475        14   100  0 0 /
[  462.876531]        kdevtmpfs    18      3434.000330       150   120  0 0 /
[  462.877279]            netns    19         7.172672         2   100  0 0 /
[  462.877915]       khungtaskd    20     96166.201839         5   120  0 0 /
[  462.878680]       oom_reaper    21        15.211226         2   120  0 0 /
[  462.879356]        writeback    22        19.229876         2   100  0 0 /
[  462.880019]       kcompactd0    23        23.243939         2   120  0 0 /
[  462.880711]       khugepaged    26        29.801148         2   139  0 0 /
[  462.881387]           crypto    27        32.812834         2   100  0 0 /
[  462.882102]      kintegrityd    28        36.824467         2   100  0 0 /
[  462.882773]           bioset    29        39.871309         2   100  0 0 /
[  462.883411]          kblockd    30        43.883099         2   100  0 0 /
[  462.883999]       devfreq_wq    31        47.930633         2   100  0 0 /
[  462.884534]        watchdogd    32        51.953906         2   100  0 0 /
[  462.885233]      kworker/1:1    33     96259.517165     28128   120  0 0 /
[  462.885894]           bioset    92       515.955294         2   100  0 0 /
[  462.886548]           bioset    94       522.688145         2   100  0 0 /
[  462.887209]           bioset    97       532.644641         2   100  0 0 /
[  462.887878]        scsi_eh_0   101       617.961556         2   120  0 0 /
[  462.888532]           bioset   106       629.270466         2   100  0 0 /
[  462.889256]           bioset   108       637.282872         2   100  0 0 /
[  462.889911]           bioset   109       643.286268         2   100  0 0 /
[  462.890589]           bioset   110       649.289726         2   100  0 0 /
[  462.891319]        scsi_eh_1   131       731.116219         2   120  0 0 /
[  462.891898]           bioset   133       735.177922         2   100  0 0 /
[  462.892549]       scsi_tmf_3   137       745.187360         2   100  0 0 /
[  462.893185]           bioset   139       757.209148         2   100  0 0 /
[  462.893811]   kworker/u128:5   154     96259.669581      4337   120  0 0 /
[  462.894457]         xfsalloc   174       866.844640         2   100  0 0 /
[  462.895075]    xfs_mru_cache   175       870.863763         2   100  0 0 /
[  462.895676]    xfs-data/sda1   183       899.925278         2   100  0 0 /
[  462.896293]    xfs-conv/sda1   184       905.944020         2   100  0 0 /
[  462.896807]     xfs-cil/sda1   185       911.959871         2   100  0 0 /
[  462.897338]     xfs-log/sda1   187       917.973007         2   100  0 0 /
[  462.897859]     xfsaild/sda1   189       923.988270         2   120  0 0 /
[  462.898545]  systemd-journal   227        35.351011       485   120  0 0 /autogroup-9
[  462.899118]    systemd-udevd   246       311.017304       751   120  0 0 /autogroup-13
[  462.899753]         ttm_swap   271      2499.990314         2   100  0 0 /
[  462.900297]  xfs-reclaim/sdb   376      3039.227631         2   100  0 0 /
[  462.900855]  xfs-eofblocks/s   385      3043.465616         2   100  0 0 /
[  462.901383]     xfsaild/sdb1   387      3050.732265         2   120  0 0 /
[  462.901910]      kworker/1:3   399     96117.933567       320   120  0 0 /
[  462.902444]     kworker/1:1H   434     96259.431277      1196   100  0 0 /
[  462.903113]        rpc.statd   550         1.465336         8   120  0 0 /autogroup-27
[  462.903705]           nfsiod   557      3338.106063         2   100  0 0 /
[  462.904292]       rpc.idmapd   564         0.799425         1   120  0 0 /autogroup-28
[  462.904943]         vmtoolsd   572       355.289029      4929   120  0 0 /autogroup-35
[  462.905815]            gmain   654        68.221840         2   120  0 0 /autogroup-35
[  462.906465]             nscd   603         7.375038         5   120  0 0 /autogroup-42
[  462.907109]             nscd   605        14.553354        63   120  0 0 /autogroup-42
[  462.907716]             nscd   606         5.683672         2   120  0 0 /autogroup-42
[  462.908431]             nscd   607         5.515528         2   120  0 0 /autogroup-42
[  462.909188]             nscd   609         7.129925        24   120  0 0 /autogroup-42
[  462.909812]             nscd   610         8.765209        33   120  0 0 /autogroup-42
[  462.910562]             nscd   611         6.105933        16   120  0 0 /autogroup-42
[  462.911079]             nscd   612         6.302314        19   120  0 0 /autogroup-42
[  462.911662]      dbus-daemon   619        29.560219       311   120  0 0 /autogroup-47
[  462.912297]       irqbalance   627        78.978747        90   120  0 0 /autogroup-48
[  462.912968]         rsyslogd   637         8.279283        44   120  0 0 /autogroup-49
[  462.913589]        in:imklog   649        19.853490        43   120  0 0 /autogroup-49
[  462.914169]          systemd   670        11.321708        63   120  0 0 /autogroup-57
[  462.914775]         (sd-pam)   672         0.370105         1   120  0 0 /autogroup-57
[  462.915338]  console-kit-dae   674       107.724609       238   120  0 0 /autogroup-58
[  462.916056]  console-kit-dae   677        54.042896        12   120  0 0 /autogroup-58
[  462.916625]  console-kit-dae   679        54.044860        11   120  0 0 /autogroup-58
[  462.917203]  console-kit-dae   680        51.037488         6   120  0 0 /autogroup-58
[  462.917735]  console-kit-dae   682        54.039183         9   120  0 0 /autogroup-58
[  462.918301]  console-kit-dae   683        51.040915         5   120  0 0 /autogroup-58
[  462.918835]  console-kit-dae   685        54.042352         6   120  0 0 /autogroup-58
[  462.919387]  console-kit-dae   689        54.039137         7   120  0 0 /autogroup-58
[  462.919912]  console-kit-dae   690        54.043948         6   120  0 0 /autogroup-58
[  462.920424]  console-kit-dae   693        51.049337         4   120  0 0 /autogroup-58
[  462.920903]  console-kit-dae   694        51.037635         4   120  0 0 /autogroup-58
[  462.921395]  console-kit-dae   695        51.035322         4   120  0 0 /autogroup-58
[  462.921958]  console-kit-dae   697        54.050037         3   120  0 0 /autogroup-58
[  462.922436]  console-kit-dae   699        53.034403         3   120  0 0 /autogroup-58
[  462.922905]  console-kit-dae   700        57.038216         3   120  0 0 /autogroup-58
[  462.923376]  console-kit-dae   709        54.744888         2   120  0 0 /autogroup-58
[  462.923844]  console-kit-dae   734        60.036506         1   120  0 0 /autogroup-58
[  462.924239]          polkitd   740         9.646785        71   120  0 0 /autogroup-59
[  462.924734]            gdbus   742         5.616440        41   120  0 0 /autogroup-59
[  462.925180]             bash   751     15054.761917       144   120  0 0 /autogroup-55
[  462.925609]          systemd   762        15.554767        58   120  0 0 /autogroup-61
[  462.926178]               su   774        23.331971        31   120  0 0 /autogroup-62
[  462.926604]             bash   781        95.054656       122   120  0 0 /autogroup-62
[  462.927039]            mount  2396     26353.557990     37559   120  0 0 /autogroup-55
[  462.927472]     xfs-buf/sdd1  2397     82860.647130         2   100  0 0 /
[  462.927972]    xfs-conv/sdd1  2399     82864.659496         2   100  0 0 /
[  462.928417]  xfs-reclaim/sdd  2401     82868.671386         2   100  0 0 /
[  462.928873]  xfs-eofblocks/s  2403     82872.683865         2   100  0 0 /
[  462.929308]      kworker/1:0  2409     96262.284211       332   120  0 0 /


Thank you,
Martin


