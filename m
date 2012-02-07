Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17GZfgK241767 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 10:35:41 -0600
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id y9sB2FLHZcb02l99
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 07 Feb 2012 08:35:39 -0800 (PST)
Received: by wgbdy1 with SMTP id dy1so5723470wgb.32
	for <xfs@oss.sgi.com>; Tue, 07 Feb 2012 08:35:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120206225122.GF24840@quack.suse.cz>
References: <CAOgv-ziomS-+ML0Xb4oSoWTjzkG8BBBQcMjXwn7rjQV2pFtQ6Q@mail.gmail.com>
	<20120206225122.GF24840@quack.suse.cz>
Date: Tue, 7 Feb 2012 10:35:37 -0600
Message-ID: <CAOgv-zjjwoTnN7=a1kRHL_yVRzc5w3BfUfsY0_X61-rjzJJ2Hg@mail.gmail.com>
Subject: Re: Soft lockup problem
From: Gerard Saraber <gsaraber@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 6, 2012 at 4:51 PM, Jan Kara <jack@suse.cz> wrote:
> On Mon 06-02-12 09:40:45, Gerard Saraber wrote:
>> Greetings everyone,
>> I've been having a bit of a problem since upgrading to the linux 3.x
>> series, I have a machine that we're using as a NAS that runs various
>> rsync processes (mostly at night), lately after a day or two, I will
>> come in in the morning to a load average of 49, but the machine not
>> really doing anything, when trying to run 'dstat' the command just
>> hung with no output at all. there were no errors in the logs, or even
>> anything that would vaguely point at anything I could work with.
>> So needing to get the machine back to work I attempted to reboot it
>> "shutdown -r now" on console... it gives a nice message saying it's
>> going to reboot, but nothing ever happens.. the only way to reboot it
>> is by using ctrl + alt + sysrq + b. after which the machine reboots
>> and the raid array comes back clean.
>>
>> I'm not sure how to troubleshoot this, any pointers would be appreciated.
>>
>> I'm compiling 3.2.4 at the moment and found a bunch of possibly useful
>> options in the kernel debugging section:
>> detect hard/soft lockups and detect hung tasks, maybe it'll give me
>> something more to go on.
>>
>> Some details about the machine:
>> Linux xenbox 3.2.2 #1 SMP Sun Jan 29 10:28:22 CST 2012 x86_64 Intel(R)
>> Xeon(R) CPU 5140 @ 2.33GHz GenuineIntel GNU/Linux
>> It has 3 software raid arrays (2 x 5 drives and 1 x 4 drives) LVM'ed
>> together into a 23TB XFS filesystem.
>> 6GB memory and a pair of Intel Gigabit ethernet controllers bonded toget=
her.
> =A0Hmm, might be some deadlock in the filesystem. Adding XFS guys to CC.
> Can you run 'echo w >/proc/sysrq-trigger' and post output of dmesg here?
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

Thanks for the quick reply,
the machine is running good at the moment so I'm not sure if the
output helps, but here it is:
[I'll also be sure to grab this log the next time it locks]

-Gerard


Feb 07 10:32:04 [kernel] [88365.922121] SysRq : Show Blocked State
Feb 07 10:32:04 [kernel] [88365.922141]   task
PC stack   pid father
Feb 07 10:32:04 [kernel] [88365.922170] flush-253:0     D
0000000000000000  1320  2941      2 0x00000000
Feb 07 10:32:04 [kernel] [88365.922177]  ffff8801ada63570
0000000000000046 ffffffff8189813a ffff8801b554a800
Feb 07 10:32:04 [kernel] [88365.922182]  ffff880100000000
00000000001d2880 ffff8801ad8d8000 00000000001d2880
Feb 07 10:32:04 [kernel] [88365.922188]  ffff8801ada63fd8
ffff8801ada62000 00000000001d2880 00000000001d2880
Feb 07 10:32:04 [kernel] [88365.922193] Call Trace:
Feb 07 10:32:04 [kernel] [88365.922203]  [<ffffffff8189813a>] ?
__schedule+0x70a/0x920
Feb 07 10:32:04 [kernel] [88365.922207]  [<ffffffff8189841a>] schedule+0x3a=
/0x50
Feb 07 10:32:04 [kernel] [88365.922211]  [<ffffffff816bc640>]
get_active_stripe+0x2f0/0x660
Feb 07 10:32:04 [kernel] [88365.922217]  [<ffffffff810c0000>] ?
sysfs_show_available_clocksources+0x10/0xf0
Feb 07 10:32:04 [kernel] [88365.922222]  [<ffffffff81088560>] ?
try_to_wake_up+0x2d0/0x2d0
Feb 07 10:32:04 [kernel] [88365.922226]  [<ffffffff816c39b6>]
make_request+0x196/0x430
Feb 07 10:32:04 [kernel] [88365.922231]  [<ffffffff810b4e30>] ?
wake_up_bit+0x40/0x40
Feb 07 10:32:04 [kernel] [88365.922236]  [<ffffffff816da26b>] ?
dm_request+0x13b/0x230
Feb 07 10:32:04 [kernel] [88365.922239]  [<ffffffff816cf1a4>]
md_make_request+0x174/0x2b0
Feb 07 10:32:04 [kernel] [88365.922243]  [<ffffffff816cf098>] ?
md_make_request+0x68/0x2b0
Feb 07 10:32:04 [kernel] [88365.922247]  [<ffffffff810b9d5e>] ?
up_read+0x1e/0x40
Feb 07 10:32:04 [kernel] [88365.922250]  [<ffffffff816da26b>] ?
dm_request+0x13b/0x230
Feb 07 10:32:04 [kernel] [88365.922253]  [<ffffffff816da15e>] ?
dm_request+0x2e/0x230
Feb 07 10:32:04 [kernel] [88365.922259]  [<ffffffff8145c722>]
generic_make_request+0xc2/0x100
Feb 07 10:32:04 [kernel] [88365.922262]  [<ffffffff8145d4d5>]
submit_bio+0x75/0xf0
Feb 07 10:32:04 [kernel] [88365.922267]  [<ffffffff811ac88b>] ?
__mark_inode_dirty+0x3b/0x220
Feb 07 10:32:04 [kernel] [88365.922272]  [<ffffffff8133f512>]
xfs_submit_ioend_bio.clone.12+0x52/0x80
Feb 07 10:32:04 [kernel] [88365.922275]  [<ffffffff8133f62e>]
xfs_submit_ioend+0xee/0x110
Feb 07 10:32:04 [kernel] [88365.922278]  [<ffffffff8133f89c>]
xfs_vm_writepage+0x24c/0x520
Feb 07 10:32:04 [kernel] [88365.922284]  [<ffffffff81136115>]
__writepage+0x15/0x50
Feb 07 10:32:04 [kernel] [88365.922287]  [<ffffffff81136749>]
write_cache_pages+0x219/0x4c0
Feb 07 10:32:04 [kernel] [88365.922291]  [<ffffffff81136100>] ?
set_page_dirty+0x70/0x70
Feb 07 10:32:04 [kernel] [88365.922295]  [<ffffffff81136a3f>]
generic_writepages+0x4f/0x70
Feb 07 10:32:04 [kernel] [88365.922298]  [<ffffffff8133e4e8>]
xfs_vm_writepages+0x58/0x70
Feb 07 10:32:04 [kernel] [88365.922302]  [<ffffffff8113822f>]
do_writepages+0x1f/0x40
Feb 07 10:32:04 [kernel] [88365.922306]  [<ffffffff811ad5c9>]
writeback_single_inode+0x189/0x400
Feb 07 10:32:04 [kernel] [88365.922309]  [<ffffffff811adc28>]
writeback_sb_inodes+0x1a8/0x270
Feb 07 10:32:04 [kernel] [88365.922313]  [<ffffffff811add86>]
__writeback_inodes_wb+0x96/0xc0
Feb 07 10:32:04 [kernel] [88365.922316]  [<ffffffff811adf93>]
wb_writeback+0x1e3/0x2c0
Feb 07 10:32:04 [kernel] [88365.922319]  [<ffffffff811370e5>] ?
determine_dirtyable_memory+0x15/0x30
Feb 07 10:32:04 [kernel] [88365.922323]  [<ffffffff81137192>] ?
global_dirty_limits+0x32/0x160
Feb 07 10:32:04 [kernel] [88365.922326]  [<ffffffff811aee3e>]
wb_do_writeback+0x11e/0x210
Feb 07 10:32:04 [kernel] [88365.922330]  [<ffffffff811aefda>]
bdi_writeback_thread+0xaa/0x290
Feb 07 10:32:04 [kernel] [88365.922333]  [<ffffffff811aef30>] ?
wb_do_writeback+0x210/0x210
Feb 07 10:32:04 [kernel] [88365.922337]  [<ffffffff810b48c6>] kthread+0xa6/=
0xb0
Feb 07 10:32:04 [kernel] [88365.922342]  [<ffffffff8189e1b4>]
kernel_thread_helper+0x4/0x10
Feb 07 10:32:04 [kernel] [88365.922346]  [<ffffffff8189b8dd>] ?
retint_restore_args+0xe/0xe
Feb 07 10:32:04 [kernel] [88365.922350]  [<ffffffff810b4820>] ?
__init_kthread_worker+0x70/0x70
Feb 07 10:32:04 [kernel] [88365.922353]  [<ffffffff8189e1b0>] ?
gs_change+0xb/0xb
Feb 07 10:32:04 [kernel] [88365.922357] ssh             D
0000000000000000  4080 23086  23078 0x00000000
Feb 07 10:32:04 [kernel] [88365.922363]  ffff8801492d79a8
0000000000000046 ffffffff8189813a 0000000000000006
Feb 07 10:32:04 [kernel] [88365.922368]  0000000000000000
00000000001d2880 ffff8801b7902680 00000000001d2880
Feb 07 10:32:04 [kernel] [88365.922373]  ffff8801492d7fd8
ffff8801492d6000 00000000001d2880 00000000001d2880
Feb 07 10:32:04 [kernel] [88365.922379] Call Trace:
Feb 07 10:32:04 [kernel] [88365.922382]  [<ffffffff8189813a>] ?
__schedule+0x70a/0x920
Feb 07 10:32:04 [kernel] [88365.922385]  [<ffffffff8189841a>] schedule+0x3a=
/0x50
Feb 07 10:32:04 [kernel] [88365.922389]  [<ffffffff8189891e>]
schedule_timeout+0x18e/0x2e0
Feb 07 10:32:04 [kernel] [88365.922393]  [<ffffffff810a0a10>] ?
cascade+0xa0/0xa0
Feb 07 10:32:04 [kernel] [88365.922397]  [<ffffffff810be378>] ?
ktime_get_ts+0xa8/0xe0
Feb 07 10:32:04 [kernel] [88365.922401]  [<ffffffff8189871a>]
io_schedule_timeout+0x9a/0xf0
Feb 07 10:32:04 [kernel] [88365.922404]  [<ffffffff811372ec>] ?
bdi_dirty_limit+0x2c/0xc0
Feb 07 10:32:04 [kernel] [88365.922408]  [<ffffffff811379ea>]
balance_dirty_pages_ratelimited_nr+0x2ba/0x770
Feb 07 10:32:04 [kernel] [88365.922417]  [<ffffffff81348114>] ?
xfs_iunlock+0x74/0xf0
Feb 07 10:32:04 [kernel] [88365.922422]  [<ffffffff8112c349>]
generic_file_buffered_write+0x1b9/0x280
Feb 07 10:32:04 [kernel] [88365.922426]  [<ffffffff81345900>]
xfs_file_buffered_aio_write+0xf0/0x1a0
Feb 07 10:32:04 [kernel] [88365.922430]  [<ffffffff8114e7ab>] ?
might_fault+0x3b/0x90
Feb 07 10:32:04 [kernel] [88365.922434]  [<ffffffff81345b62>]
xfs_file_aio_write+0x1b2/0x2f0
Feb 07 10:32:04 [kernel] [88365.922439]  [<ffffffff81198677>] ?
core_sys_select+0x47/0x390
Feb 07 10:32:04 [kernel] [88365.922442]  [<ffffffff8114e7ab>] ?
might_fault+0x3b/0x90
Feb 07 10:32:04 [kernel] [88365.922446]  [<ffffffff8118432a>]
do_sync_write+0xda/0x120
Feb 07 10:32:04 [kernel] [88365.922452]  [<ffffffff8143f167>] ?
security_file_permission+0x27/0xb0
Feb 07 10:32:04 [kernel] [88365.922455]  [<ffffffff81184c46>]
vfs_write+0xc6/0x190
Feb 07 10:32:04 [kernel] [88365.922458]  [<ffffffff81184f7f>]
sys_write+0x4f/0xa0
Feb 07 10:32:04 [kernel] [88365.922462]  [<ffffffff8189bffb>]
system_call_fastpath+0x16/0x1b
Feb 07 10:32:04 [kernel] [88365.922465] ssh             D
0000000000000000  4080 23087  23078 0x00000000
Feb 07 10:32:04 [kernel] [88365.922471]  ffff88010e2159a8
0000000000000046 ffffffff8189813a 0000000000000006
Feb 07 10:32:04 [kernel] [88365.922476]  0000000000000000
00000000001d2880 ffff8801b32d2680 00000000001d2880
Feb 07 10:32:04 [kernel] [88365.922482]  ffff88010e215fd8
ffff88010e214000 00000000001d2880 00000000001d2880
Feb 07 10:32:04 [kernel] [88365.922487] Call Trace:
Feb 07 10:32:04 [kernel] [88365.922490]  [<ffffffff8189813a>] ?
__schedule+0x70a/0x920
Feb 07 10:32:04 [kernel] [88365.922493]  [<ffffffff8189841a>] schedule+0x3a=
/0x50
Feb 07 10:32:04 [kernel] [88365.922497]  [<ffffffff8189891e>]
schedule_timeout+0x18e/0x2e0
Feb 07 10:32:04 [kernel] [88365.922500]  [<ffffffff810a0a10>] ?
cascade+0xa0/0xa0
Feb 07 10:32:04 [kernel] [88365.922504]  [<ffffffff810be378>] ?
ktime_get_ts+0xa8/0xe0
Feb 07 10:32:04 [kernel] [88365.922507]  [<ffffffff8189871a>]
io_schedule_timeout+0x9a/0xf0
Feb 07 10:32:04 [kernel] [88365.922511]  [<ffffffff811372ec>] ?
bdi_dirty_limit+0x2c/0xc0
Feb 07 10:32:04 [kernel] [88365.922515]  [<ffffffff811379ea>]
balance_dirty_pages_ratelimited_nr+0x2ba/0x770
Feb 07 10:32:04 [kernel] [88365.922518]  [<ffffffff811ac88b>] ?
__mark_inode_dirty+0x3b/0x220
Feb 07 10:32:04 [kernel] [88365.922522]  [<ffffffff81348114>] ?
xfs_iunlock+0x74/0xf0
Feb 07 10:32:04 [kernel] [88365.922526]  [<ffffffff8112c349>]
generic_file_buffered_write+0x1b9/0x280
Feb 07 10:32:04 [kernel] [88365.922537]  [<ffffffff81345b62>]
xfs_file_aio_write+0x1b2/0x2f0
Feb 07 10:32:04 [kernel] [88365.922541]  [<ffffffff81198677>] ?
core_sys_select+0x47/0x390
Feb 07 10:32:04 [kernel] [88365.922544]  [<ffffffff8114e7ab>] ?
might_fault+0x3b/0x90
Feb 07 10:32:04 [kernel] [88365.922547]  [<ffffffff8118432a>]
do_sync_write+0xda/0x120
Feb 07 10:32:04 [kernel] [88365.922551]  [<ffffffff8143f167>] ?
security_file_permission+0x27/0xb0
Feb 07 10:32:04 [kernel] [88365.922555]  [<ffffffff81184c46>]
vfs_write+0xc6/0x190
Feb 07 10:32:04 [kernel] [88365.922558]  [<ffffffff81184f7f>]
sys_write+0x4f/0xa0
Feb 07 10:32:04 [kernel] [88365.922562]  [<ffffffff8189bffb>]
system_call_fastpath+0x16/0x1b
Feb 07 10:32:04 [kernel] [88365.922568] Sched Debug Version: v0.10, 3.2.4 #2
Feb 07 10:32:04 [kernel] [88365.922571] ktime
         : 88365922.568795
Feb 07 10:32:04 [kernel] [88365.922574] sched_clk
         : 88191370.131237
Feb 07 10:32:04 [kernel] [88365.922576] cpu_clk
         : 88365922.567625
Feb 07 10:32:04 [kernel] [88365.922578] jiffies
         : 4383033218
Feb 07 10:32:04 [kernel] [88365.922580] sched_clock_stable
         : 0
Feb 07 10:32:04 [kernel] [88365.922582]
Feb 07 10:32:04 [kernel] [88365.922583] sysctl_sched
Feb 07 10:32:04 [kernel] [88365.922585]   .sysctl_sched_latency
            : 18.000000
Feb 07 10:32:04 [kernel] [88365.922588]
.sysctl_sched_min_granularity            : 2.250000
Feb 07 10:32:04 [kernel] [88365.922590]
.sysctl_sched_wakeup_granularity         : 3.000000
Feb 07 10:32:04 [kernel] [88365.922592]
.sysctl_sched_child_runs_first           : 0
Feb 07 10:32:04 [kernel] [88365.922594]   .sysctl_sched_features
            : 24119
Feb 07 10:32:04 [kernel] [88365.922597]
.sysctl_sched_tunable_scaling            : 1 (logaritmic)
Feb 07 10:32:04 [kernel] [88365.922600]
Feb 07 10:32:04 [kernel] [88365.922600] cpu#0, 2333.231 MHz
Feb 07 10:32:04 [kernel] [88365.922602]   .nr_running                    : 2
Feb 07 10:32:04 [kernel] [88365.922605]   .load                          : =
2048
Feb 07 10:32:04 [kernel] [88365.922607]   .nr_switches
  : 47384343
Feb 07 10:32:04 [kernel] [88365.922609]   .nr_load_updates
  : 27680552
Feb 07 10:32:04 [kernel] [88365.922611]   .nr_uninterruptible            : =
5780
Feb 07 10:32:04 [kernel] [88365.922613]   .next_balance
  : 4383.033233
Feb 07 10:32:04 [kernel] [88365.922615]   .curr->pid                     : =
26616
Feb 07 10:32:04 [kernel] [88365.922620]   .cpu_load[0]                   : =
2048
Feb 07 10:32:04 [kernel] [88365.922622]   .cpu_load[1]                   : =
1024
Feb 07 10:32:04 [kernel] [88365.922623]   .cpu_load[2]                   : =
512
Feb 07 10:32:04 [kernel] [88365.922625]   .cpu_load[3]                   : =
256
Feb 07 10:32:04 [kernel] [88365.922627]   .cpu_load[4]                   : =
128
Feb 07 10:32:04 [kernel] [88365.922629]   .yld_count                     : 0
Feb 07 10:32:04 [kernel] [88365.922631]   .sched_switch                  : 0
Feb 07 10:32:04 [kernel] [88365.922633]   .sched_count
  : 47523458
Feb 07 10:32:04 [kernel] [88365.922635]   .sched_goidle
  : 22579080
Feb 07 10:32:04 [kernel] [88365.922637]   .avg_idle
  : 888834
Feb 07 10:32:04 [kernel] [88365.922639]   .ttwu_count
  : 25633221
Feb 07 10:32:04 [kernel] [88365.922641]   .ttwu_local
  : 19078353
Feb 07 10:32:04 [kernel] [88365.922645]
Feb 07 10:32:04 [kernel] [88365.922646] cfs_rq[0]:/autogroup-861
Feb 07 10:32:04 [kernel] [88365.922648]   .exec_clock
  : 13.544484
Feb 07 10:32:04 [kernel] [88365.922652]   .MIN_vruntime
  : 0.000001
Feb 07 10:32:04 [kernel] [88365.922654]   .min_vruntime
  : 6.378969
Feb 07 10:32:04 [kernel] [88365.922656]   .max_vruntime
  : 0.000001
Feb 07 10:32:04 [kernel] [88365.922658]   .spread
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922660]   .spread0
  : -3347531.515424
Feb 07 10:32:04 [kernel] [88365.922663]   .nr_spread_over                : 0
Feb 07 10:32:04 [kernel] [88365.922664]   .nr_running                    : 1
Feb 07 10:32:04 [kernel] [88365.922666]   .load                          : =
1024
Feb 07 10:32:04 [kernel] [88365.922668]   .load_avg
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922671]   .load_period
  : 9.999999
Feb 07 10:32:04 [kernel] [88365.922673]   .load_contrib                  : 0
Feb 07 10:32:04 [kernel] [88365.922674]   .load_tg                       : 0
Feb 07 10:32:04 [kernel] [88365.922677]   .se->exec_start
  : 88365922.005056
Feb 07 10:32:04 [kernel] [88365.922679]   .se->vruntime
  : 3347529.024236
Feb 07 10:32:04 [kernel] [88365.922681]   .se->sum_exec_runtime
  : 13.544484
Feb 07 10:32:04 [kernel] [88365.922683]   .se->statistics.wait_start
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922686]   .se->statistics.sleep_start
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922688]   .se->statistics.block_start
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922690]   .se->statistics.sleep_max
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922692]   .se->statistics.block_max
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922694]   .se->statistics.exec_max
  : 1.397658
Feb 07 10:32:04 [kernel] [88365.922698]   .se->statistics.wait_max
  : 0.037956
Feb 07 10:32:04 [kernel] [88365.922700]   .se->statistics.wait_sum
  : 0.405641
Feb 07 10:32:04 [kernel] [88365.922702]   .se->statistics.wait_count     : =
43
Feb 07 10:32:04 [kernel] [88365.922704]   .se->load.weight               : =
1024
Feb 07 10:32:04 [kernel] [88365.922707]
Feb 07 10:32:04 [kernel] [88365.922707] cfs_rq[0]:/
Feb 07 10:32:04 [kernel] [88365.922709]   .exec_clock
  : 3857099.252074
Feb 07 10:32:04 [kernel] [88365.922712]   .MIN_vruntime
  : 3347528.894393
Feb 07 10:32:04 [kernel] [88365.922714]   .min_vruntime
  : 3347537.894393
Feb 07 10:32:04 [kernel] [88365.922716]   .max_vruntime
  : 3347528.894393
Feb 07 10:32:04 [kernel] [88365.922719]   .spread
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922721]   .spread0
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922723]   .nr_spread_over                : =
278
Feb 07 10:32:04 [kernel] [88365.922725]   .nr_running                    : 2
Feb 07 10:32:04 [kernel] [88365.922727]   .load                          : =
2048
Feb 07 10:32:04 [kernel] [88365.922729]   .load_avg
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922731]   .load_period
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922733]   .load_contrib                  : 0
Feb 07 10:32:04 [kernel] [88365.922734]   .load_tg                       : 0
Feb 07 10:32:04 [kernel] [88365.922737]
Feb 07 10:32:04 [kernel] [88365.922737] rt_rq[0]:
Feb 07 10:32:04 [kernel] [88365.922739]   .rt_nr_running                 : 0
Feb 07 10:32:04 [kernel] [88365.922741]   .rt_throttled                  : 0
Feb 07 10:32:04 [kernel] [88365.922743]   .rt_time
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922745]   .rt_runtime
  : 950.000000
Feb 07 10:32:04 [kernel] [88365.922747]
Feb 07 10:32:04 [kernel] [88365.922748] runnable tasks:
Feb 07 10:32:04 [kernel] [88365.922749]             task   PID
tree-key  switches  prio     exec-runtime         sum-exec
sum-sleep
Feb 07 10:32:04 [kernel] [88365.922750]
---------------------------------------------------------------------------=
-------------------------------
Feb 07 10:32:04 [kernel] [88365.922759]      kworker/0:1 25833
3347528.894393     19293   120   3347528.894393      1314.935421
2056117.209075 /
Feb 07 10:32:04 [kernel] [88365.922767] R           bash 26616
5.470536        54   120         5.470536        18.185136
37388.063060 /autogroup-861
Feb 07 10:32:04 [kernel] [88365.922777]
Feb 07 10:32:04 [kernel] [88365.922777] cpu#1, 2333.231 MHz
Feb 07 10:32:04 [kernel] [88365.922779]   .nr_running                    : 0
Feb 07 10:32:04 [kernel] [88365.922781]   .load                          : 0
Feb 07 10:32:04 [kernel] [88365.922783]   .nr_switches
  : 48208480
Feb 07 10:32:04 [kernel] [88365.922785]   .nr_load_updates
  : 28422632
Feb 07 10:32:04 [kernel] [88365.922788]   .nr_uninterruptible            : =
6243
Feb 07 10:32:04 [kernel] [88365.922790]   .next_balance
  : 4383.033438
Feb 07 10:32:04 [kernel] [88365.922792]   .curr->pid                     : 0
Feb 07 10:32:04 [kernel] [88365.922794]   .clock
  : 88365922.005609
Feb 07 10:32:04 [kernel] [88365.922796]   .cpu_load[0]                   : 0
Feb 07 10:32:04 [kernel] [88365.922798]   .cpu_load[1]                   : =
30
Feb 07 10:32:04 [kernel] [88365.922800]   .cpu_load[2]                   : =
78
Feb 07 10:32:04 [kernel] [88365.922802]   .cpu_load[3]                   : =
74
Feb 07 10:32:04 [kernel] [88365.922803]   .cpu_load[4]                   : =
62
Feb 07 10:32:04 [kernel] [88365.922805]   .yld_count                     : 2
Feb 07 10:32:04 [kernel] [88365.922807]   .sched_switch                  : 0
Feb 07 10:32:04 [kernel] [88365.922809]   .sched_count
  : 48351933
Feb 07 10:32:04 [kernel] [88365.922811]   .sched_goidle
  : 22985997
Feb 07 10:32:04 [kernel] [88365.922813]   .avg_idle
  : 988263
Feb 07 10:32:04 [kernel] [88365.922815]   .ttwu_count
  : 26052282
Feb 07 10:32:04 [kernel] [88365.922817]   .ttwu_local
  : 19528683
Feb 07 10:32:04 [kernel] [88365.922820]
Feb 07 10:32:04 [kernel] [88365.922821] cfs_rq[1]:/autogroup-776
Feb 07 10:32:04 [kernel] [88365.922823]   .exec_clock
  : 358297.296203
Feb 07 10:32:04 [kernel] [88365.922826]   .MIN_vruntime
  : 0.000001
Feb 07 10:32:04 [kernel] [88365.922828]   .min_vruntime
  : 299834.428916
Feb 07 10:32:04 [kernel] [88365.922831]   .max_vruntime
  : 0.000001
Feb 07 10:32:04 [kernel] [88365.922833]   .spread
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922835]   .spread0
  : -3047703.465477
Feb 07 10:32:04 [kernel] [88365.922837]   .nr_spread_over                : =
322
Feb 07 10:32:04 [kernel] [88365.922839]   .nr_running                    : 0
Feb 07 10:32:04 [kernel] [88365.922841]   .load                          : 0
Feb 07 10:32:04 [kernel] [88365.922843]   .load_avg
  : 943.694796
Feb 07 10:32:04 [kernel] [88365.922845]   .load_period
  : 8.490465
Feb 07 10:32:04 [kernel] [88365.922849]   .load_tg                       : =
214
Feb 07 10:32:04 [kernel] [88365.922854]   .se->vruntime
  : 3442136.706757
Feb 07 10:32:04 [kernel] [88365.922856]   .se->sum_exec_runtime
  : 358335.275642
Feb 07 10:32:04 [kernel] [88365.922858]   .se->statistics.wait_start
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922860]   .se->statistics.sleep_start
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922862]   .se->statistics.block_start
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922864]   .se->statistics.sleep_max
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922866]   .se->statistics.block_max
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922869]   .se->statistics.exec_max
  : 6.979434
Feb 07 10:32:04 [kernel] [88365.922871]   .se->statistics.slice_max
  : 8.909837
Feb 07 10:32:04 [kernel] [88365.922873]   .se->statistics.wait_max
  : 335.735845
Feb 07 10:32:04 [kernel] [88365.922875]   .se->statistics.wait_sum
  : 4606.806398
Feb 07 10:32:04 [kernel] [88365.922877]   .se->statistics.wait_count
  : 318111
Feb 07 10:32:04 [kernel] [88365.922879]   .se->load.weight               : 2
Feb 07 10:32:04 [kernel] [88365.922881]
Feb 07 10:32:04 [kernel] [88365.922882] cfs_rq[1]:/
Feb 07 10:32:04 [kernel] [88365.922883]   .exec_clock
  : 3999784.031074
Feb 07 10:32:04 [kernel] [88365.922886]   .MIN_vruntime
  : 0.000001
Feb 07 10:32:04 [kernel] [88365.922888]   .min_vruntime
  : 3442142.654334
Feb 07 10:32:04 [kernel] [88365.922891]   .max_vruntime
  : 0.000001
Feb 07 10:32:04 [kernel] [88365.922893]   .spread
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922895]   .spread0
  : 94604.759941
Feb 07 10:32:04 [kernel] [88365.922897]   .nr_spread_over                : =
267
Feb 07 10:32:04 [kernel] [88365.922899]   .nr_running                    : 0
Feb 07 10:32:04 [kernel] [88365.922901]   .load                          : 0
Feb 07 10:32:04 [kernel] [88365.922903]   .load_avg
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922905]   .load_period
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922907]   .load_contrib                  : 0
Feb 07 10:32:04 [kernel] [88365.922909]   .load_tg                       : 0
Feb 07 10:32:04 [kernel] [88365.922911]
Feb 07 10:32:04 [kernel] [88365.922911] rt_rq[1]:
Feb 07 10:32:04 [kernel] [88365.922913]   .rt_nr_running                 : 0
Feb 07 10:32:04 [kernel] [88365.922915]   .rt_throttled                  : 0
Feb 07 10:32:04 [kernel] [88365.922917]   .rt_time
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922919]   .rt_runtime
  : 950.000000
Feb 07 10:32:04 [kernel] [88365.922921]
Feb 07 10:32:04 [kernel] [88365.922922] runnable tasks:
Feb 07 10:32:04 [kernel] [88365.922922]             task   PID
tree-key  switches  prio     exec-runtime         sum-exec
sum-sleep
Feb 07 10:32:04 [kernel] [88365.922924]
---------------------------------------------------------------------------=
-------------------------------
Feb 07 10:32:04 [kernel] [88365.922932]
Feb 07 10:32:04 [kernel] [88365.922932] cpu#2, 2333.231 MHz
Feb 07 10:32:04 [kernel] [88365.922934]   .nr_running                    : 0
Feb 07 10:32:04 [kernel] [88365.922936]   .load                          : 0
Feb 07 10:32:04 [kernel] [88365.922938]   .nr_switches
  : 46035661
Feb 07 10:32:04 [kernel] [88365.922940]   .nr_load_updates
  : 27665281
Feb 07 10:32:04 [kernel] [88365.922942]   .nr_uninterruptible            : =
-5740
Feb 07 10:32:04 [kernel] [88365.922944]   .next_balance
  : 4383.033403
Feb 07 10:32:04 [kernel] [88365.922946]   .curr->pid                     : 0
Feb 07 10:32:04 [kernel] [88365.922949]   .clock
  : 88365922.005806
Feb 07 10:32:04 [kernel] [88365.922951]   .cpu_load[0]                   : 0
Feb 07 10:32:04 [kernel] [88365.922953]   .cpu_load[1]                   : =
256
Feb 07 10:32:04 [kernel] [88365.922954]   .cpu_load[2]                   : =
197
Feb 07 10:32:04 [kernel] [88365.922956]   .cpu_load[3]                   : =
134
Feb 07 10:32:04 [kernel] [88365.922958]   .cpu_load[4]                   : =
94
Feb 07 10:32:04 [kernel] [88365.922960]   .yld_count                     : 1
Feb 07 10:32:04 [kernel] [88365.922962]   .sched_switch                  : 0
Feb 07 10:32:04 [kernel] [88365.922964]   .sched_count
  : 46171251
Feb 07 10:32:04 [kernel] [88365.922966]   .sched_goidle
  : 22169750
Feb 07 10:32:04 [kernel] [88365.922968]   .avg_idle
  : 674493
Feb 07 10:32:04 [kernel] [88365.922970]   .ttwu_count
  : 22246832
Feb 07 10:32:04 [kernel] [88365.922972]   .ttwu_local
  : 17360455
Feb 07 10:32:04 [kernel] [88365.922975]
Feb 07 10:32:04 [kernel] [88365.922976] cfs_rq[2]:/autogroup-860
Feb 07 10:32:04 [kernel] [88365.922978]   .exec_clock
  : 11.396092
Feb 07 10:32:04 [kernel] [88365.922981]   .MIN_vruntime
  : 0.000001
Feb 07 10:32:04 [kernel] [88365.922983]   .min_vruntime
  : 9.488006
Feb 07 10:32:04 [kernel] [88365.922985]   .max_vruntime
  : 0.000001
Feb 07 10:32:04 [kernel] [88365.922987]   .spread
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.922989]   .spread0
  : -3347528.406387
Feb 07 10:32:04 [kernel] [88365.922991]   .nr_spread_over                : 0
Feb 07 10:32:04 [kernel] [88365.922993]   .nr_running                    : 0
Feb 07 10:32:04 [kernel] [88365.923002]   .load_contrib                  : =
1021
Feb 07 10:32:04 [kernel] [88365.923004]   .load_tg                       : =
1021
Feb 07 10:32:04 [kernel] [88365.923004]   .se->exec_start
  : 88365921.858706
Feb 07 10:32:04 [kernel] [88365.923004]   .se->vruntime
  : 2777211.488892
Feb 07 10:32:04 [kernel] [88365.923004]   .se->sum_exec_runtime
  : 11.396092
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.wait_start
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.sleep_start
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.block_start
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.sleep_max
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.block_max
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.exec_max
  : 0.999893
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.slice_max
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.wait_max
  : 0.051092
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.wait_sum
  : 0.064620
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.wait_count     : =
36
Feb 07 10:32:04 [kernel] [88365.923004]   .se->load.weight               : 2
Feb 07 10:32:04 [kernel] [88365.923004]
Feb 07 10:32:04 [kernel] [88365.923004] cfs_rq[2]:/autogroup-776
Feb 07 10:32:04 [kernel] [88365.923004]   .exec_clock
  : 342105.615121
Feb 07 10:32:04 [kernel] [88365.923004]   .MIN_vruntime
  : 0.000001
Feb 07 10:32:04 [kernel] [88365.923004]   .min_vruntime
  : 289931.479153
Feb 07 10:32:04 [kernel] [88365.923004]   .max_vruntime
  : 0.000001
Feb 07 10:32:04 [kernel] [88365.923004]   .spread
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .spread0
  : -3057606.415240
Feb 07 10:32:04 [kernel] [88365.923004]   .nr_spread_over                : =
307
Feb 07 10:32:04 [kernel] [88365.923004]   .nr_running                    : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .load                          : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .load_avg
  : 525.511404
Feb 07 10:32:04 [kernel] [88365.923004]   .load_period
  : 5.090393
Feb 07 10:32:04 [kernel] [88365.923004]   .load_contrib                  : =
103
Feb 07 10:32:04 [kernel] [88365.923004]   .load_tg                       : =
214
Feb 07 10:32:04 [kernel] [88365.923004]   .se->exec_start
  : 88365920.891042
Feb 07 10:32:04 [kernel] [88365.923004]   .se->vruntime
  : 2777220.245050
Feb 07 10:32:04 [kernel] [88365.923004]   .se->sum_exec_runtime
  : 342139.770710
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.wait_start
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.sleep_start
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.block_start
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.sleep_max
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.block_max
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.exec_max
  : 6.074755
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.slice_max
  : 15.625920
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.wait_max
  : 16.153034
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.wait_sum
  : 4251.654869
Feb 07 10:32:04 [kernel] [88365.923004]   .se->statistics.wait_count
  : 308775
Feb 07 10:32:04 [kernel] [88365.923004]   .se->load.weight               : 2
Feb 07 10:32:04 [kernel] [88365.923004]
Feb 07 10:32:04 [kernel] [88365.923004] cfs_rq[2]:/
Feb 07 10:32:04 [kernel] [88365.923004]   .exec_clock
  : 3362268.845416
Feb 07 10:32:04 [kernel] [88365.923004]   .MIN_vruntime
  : 0.000001
Feb 07 10:32:04 [kernel] [88365.923004]   .min_vruntime
  : 2777220.368423
Feb 07 10:32:04 [kernel] [88365.923004]   .max_vruntime
  : 0.000001
Feb 07 10:32:04 [kernel] [88365.923004]   .spread
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .spread0
  : -570317.525970
Feb 07 10:32:04 [kernel] [88365.923004]   .nr_spread_over                : =
500
Feb 07 10:32:04 [kernel] [88365.923004]   .nr_running                    : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .load                          : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .load_avg
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .load_period
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .load_contrib                  : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .load_tg                       : 0
Feb 07 10:32:04 [kernel] [88365.923004]
Feb 07 10:32:04 [kernel] [88365.923004] rt_rq[2]:
Feb 07 10:32:04 [kernel] [88365.923004]   .rt_nr_running                 : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .rt_throttled                  : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .rt_time
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .rt_runtime
  : 950.000000
Feb 07 10:32:04 [kernel] [88365.923004]
Feb 07 10:32:04 [kernel] [88365.923004] runnable tasks:
Feb 07 10:32:04 [kernel] [88365.923004]             task   PID
tree-key  switches  prio     exec-runtime         sum-exec
sum-sleep
Feb 07 10:32:04 [kernel] [88365.923004]
Feb 07 10:32:04 [kernel] [88365.923004] cpu#3, 2333.231 MHz
Feb 07 10:32:04 [kernel] [88365.923004]   .nr_running                    : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .load                          : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .nr_switches
  : 45074548
Feb 07 10:32:04 [kernel] [88365.923004]   .nr_load_updates
  : 27257305
Feb 07 10:32:04 [kernel] [88365.923004]   .nr_uninterruptible            : =
-6280
Feb 07 10:32:04 [kernel] [88365.923004]   .next_balance
  : 4383.033407
Feb 07 10:32:04 [kernel] [88365.923004]   .curr->pid                     : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .clock
  : 88365923.004961
Feb 07 10:32:04 [kernel] [88365.923004]   .cpu_load[0]                   : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .cpu_load[1]                   : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .cpu_load[2]                   : 2
Feb 07 10:32:04 [kernel] [88365.923004]   .cpu_load[3]                   : =
31
Feb 07 10:32:04 [kernel] [88365.923004]   .cpu_load[4]                   : =
71
Feb 07 10:32:04 [kernel] [88365.923004]   .yld_count                     : 1
Feb 07 10:32:04 [kernel] [88365.923004]   .sched_switch                  : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .sched_count
  : 45213014
Feb 07 10:32:04 [kernel] [88365.923004]   .sched_goidle
  : 21712500
Feb 07 10:32:04 [kernel] [88365.923004]   .avg_idle
  : 1000000
Feb 07 10:32:04 [kernel] [88365.923004]   .ttwu_count
  : 21742662
Feb 07 10:32:04 [kernel] [88365.923004]   .ttwu_local
  : 16876989
Feb 07 10:32:04 [kernel] [88365.923004]
Feb 07 10:32:04 [kernel] [88365.923004] cfs_rq[3]:/
Feb 07 10:32:04 [kernel] [88365.923004]   .exec_clock
  : 3311584.271942
Feb 07 10:32:04 [kernel] [88365.923004]   .MIN_vruntime
  : 0.000001
Feb 07 10:32:04 [kernel] [88365.923004]   .min_vruntime
  : 2796366.160205
Feb 07 10:32:04 [kernel] [88365.923004]   .max_vruntime
  : 0.000001
Feb 07 10:32:04 [kernel] [88365.923004]   .spread
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .spread0
  : -551171.734188
Feb 07 10:32:04 [kernel] [88365.923004]   .nr_spread_over                : =
1027
Feb 07 10:32:04 [kernel] [88365.923004]   .nr_running                    : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .load                          : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .load_avg
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .load_period
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .load_contrib                  : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .load_tg                       : 0
Feb 07 10:32:04 [kernel] [88365.923004]
Feb 07 10:32:04 [kernel] [88365.923004] rt_rq[3]:
Feb 07 10:32:04 [kernel] [88365.923004]   .rt_nr_running                 : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .rt_throttled                  : 0
Feb 07 10:32:04 [kernel] [88365.923004]   .rt_time
  : 0.000000
Feb 07 10:32:04 [kernel] [88365.923004]   .rt_runtime
  : 950.000000
Feb 07 10:32:04 [kernel] [88365.923004]
Feb 07 10:32:04 [kernel] [88365.923004] runnable tasks:
Feb 07 10:32:04 [kernel] [88365.923004]             task   PID
tree-key  switches  prio     exec-runtime         sum-exec
sum-sleep
Feb 07 10:32:04 [kernel] [88365.923004]
---------------------------------------------------------------------------=
-------------------------------
Feb 07 10:32:04 [kernel] [88365.923004]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
