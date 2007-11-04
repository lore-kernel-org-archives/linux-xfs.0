Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 Nov 2007 04:52:05 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA4CptTc023254
	for <xfs@oss.sgi.com>; Sun, 4 Nov 2007 04:51:56 -0800
Date: Sun, 4 Nov 2007 07:52:00 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
In-Reply-To: <472DBF8C.2060508@msgid.tls.msk.ru>
Message-ID: <Pine.LNX.4.64.0711040750020.3956@p34.internal.lan>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
 <472DBF8C.2060508@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com



On Sun, 4 Nov 2007, Michael Tokarev wrote:

> Justin Piszcz wrote:
>> # ps auxww | grep D
>> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
>> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40 [pdflush]
>> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00 [pdflush]
>>
>> After several days/weeks, this is the second time this has happened,
>> while doing regular file I/O (decompressing a file), everything on the
>> device went into D-state.
>
> The next time you come across something like that, do a SysRq-T dump and
> post that.  It shows a stack trace of all processes - and in particular,
> where exactly each task is stuck.
>
> /mjt
>

Yes I got it before I rebooted, ran that and then dmesg > file.

Here it is:

[1172609.665902]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172609.668768]  ffffffff80747dc0 ffff81015c3aa918 ffff810091c899b4 ffff810091c899a8
[1172609.668871] Call Trace:
[1172609.674472]  [<ffffffff8059171f>] schedule_timeout+0x5f/0xd0
[1172609.677362]  [<ffffffff8022f920>] process_timeout+0x0/0x10
[1172609.680243]  [<ffffffff8027b528>] do_select+0x468/0x560
[1172609.683105]  [<ffffffff8027bbc0>] __pollwait+0x0/0x130
[1172609.685969]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172609.688851]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172609.691712]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172609.694534]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172609.697324]  [<ffffffff8050bd41>] skb_copy_datagram_iovec+0x1a1/0x260
[1172609.700103]  [<ffffffff80592da9>] _spin_lock_bh+0x9/0x20
[1172609.702856]  [<ffffffff80505743>] release_sock+0x13/0xb0
[1172609.705598]  [<ffffffff80547700>] tcp_recvmsg+0x370/0x940
[1172609.708303]  [<ffffffff80505080>] sock_common_recvmsg+0x30/0x50
[1172609.710999]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172609.713694]  [<ffffffff8027b829>] core_sys_select+0x209/0x300
[1172609.716397]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172609.719112]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172609.721824]  [<ffffffff8022b51e>] current_fs_time+0x1e/0x30
[1172609.724525]  [<ffffffff803e3582>] tty_ldisc_deref+0x52/0x80
[1172609.727215]  [<ffffffff8027bdc1>] sys_select+0xd1/0x1c0
[1172609.729880]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172609.732517] 
[1172609.735115] bash          S 0000000000000000     0 30959  30958
[1172609.737742]  ffff810091c8be88 0000000000000086 0000000000000000 ffff8101ea172e20
[1172609.740404]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172609.743087]  ffffffff80747dc0 ffff81015c3ab028 ffff810091c8be54 ffff810091c8be48
[1172609.743190] Call Trace:
[1172609.748404]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172609.751071]  [<ffffffff8021f7e3>] __wake_up+0x43/0x70
[1172609.753714]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172609.756345]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172609.758967] 
[1172609.761522] sr            S 0000000000000000     0 30966  30959
[1172609.764123]  ffff810122d7de88 0000000000000082 0000000000000000 ffff8101eab3ee20
[1172609.766769]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172609.769442]  ffffffff80747dc0 ffff8101ea173028 ffff810122d7de54 ffff810122d7de48
[1172609.769545] Call Trace:
[1172609.774734]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172609.777369]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172609.779999]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172609.782616] 
[1172609.785168] screen        S 0000000000000000     0 30972  30966
[1172609.787768]  ffff810144597f68 0000000000000086 ffff810144597f30 00000000ffffffff
[1172609.790416]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172609.793085]  ffffffff80747dc0 ffff8101eab3f028 ffff810144597f34 ffff810144597f28
[1172609.793188] Call Trace:
[1172609.798381]  [<ffffffff8022b0c5>] alarm_setitimer+0x35/0x70
[1172609.801049]  [<ffffffff80232a09>] sys_pause+0x19/0x30
[1172609.803705]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172609.806361] 
[1172609.808980] sshd          S 0000000000000000     0 30973   7582
[1172609.811659]  ffff810084003bf8 0000000000000082 0000000000000000 ffffffff80508e74
[1172609.814376]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172609.817104]  ffffffff80747dc0 ffff8101ea172208 ffff810084003bc4 ffff810084003bb8
[1172609.817207] Call Trace:
[1172609.822530]  [<ffffffff80508e74>] skb_queue_tail+0x24/0x60
[1172609.825292]  [<ffffffff80591755>] schedule_timeout+0x95/0xd0
[1172609.828060]  [<ffffffff8023ae53>] prepare_to_wait+0x23/0x80
[1172609.830820]  [<ffffffff80575ac6>] unix_stream_recvmsg+0x386/0x550
[1172609.833587]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172609.836344]  [<ffffffff80277aa0>] link_path_walk+0x80/0xf0
[1172609.839074]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172609.841794]  [<ffffffff8026b5f9>] get_unused_fd_flags+0x79/0x120
[1172609.844488]  [<ffffffff8026d349>] do_sync_read+0xd9/0x120
[1172609.847161]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172609.849848]  [<ffffffff8026b7cf>] __dentry_open+0x11f/0x1b0
[1172609.852541]  [<ffffffff8026b96a>] do_filp_open+0x3a/0x50
[1172609.855235]  [<ffffffff8026dcf7>] vfs_read+0x157/0x160
[1172609.857922]  [<ffffffff8026e113>] sys_read+0x53/0x90
[1172609.860620]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172609.863343] 
[1172609.866063] sshd          S 0000000000000000     0 30975  30973
[1172609.868838]  ffff810175c219e8 0000000000000086 ffff810175c219b0 0000000000000002
[1172609.871649]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172609.874490]  ffffffff80747dc0 ffff81021b27d738 ffff810175c219b4 ffff810175c219a8
[1172609.874594] Call Trace:
[1172609.880153]  [<ffffffff8059171f>] schedule_timeout+0x5f/0xd0
[1172609.883020]  [<ffffffff8022f920>] process_timeout+0x0/0x10
[1172609.885890]  [<ffffffff8027b528>] do_select+0x468/0x560
[1172609.888742]  [<ffffffff8027bbc0>] __pollwait+0x0/0x130
[1172609.891581]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172609.894430]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172609.897258]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172609.900060]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172609.902841]  [<ffffffff80267609>] add_partial+0x19/0x60
[1172609.905606]  [<ffffffff80268a0d>] __slab_free+0x15d/0x310
[1172609.908363]  [<ffffffff80592da9>] _spin_lock_bh+0x9/0x20
[1172609.911093]  [<ffffffff80505743>] release_sock+0x13/0xb0
[1172609.913795]  [<ffffffff80547700>] tcp_recvmsg+0x370/0x940
[1172609.916486]  [<ffffffff80505080>] sock_common_recvmsg+0x30/0x50
[1172609.919151]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172609.921799]  [<ffffffff8027b829>] core_sys_select+0x209/0x300
[1172609.924455]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172609.927122]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172609.929786]  [<ffffffff8022b51e>] current_fs_time+0x1e/0x30
[1172609.932438]  [<ffffffff803e3582>] tty_ldisc_deref+0x52/0x80
[1172609.935083]  [<ffffffff8027bdc1>] sys_select+0xd1/0x1c0
[1172609.937702]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172609.940292] 
[1172609.942843] bash          S 0000000000000000     0 30976  30975
[1172609.945423]  ffff8101bf371e88 0000000000000082 0000000000000000 ffff81021e322710
[1172609.948037]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172609.950671]  ffffffff80747dc0 ffff8101882bf738 ffff8101bf371e54 ffff8101bf371e48
[1172609.950774] Call Trace:
[1172609.955888]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172609.958505]  [<ffffffff8021f7e3>] __wake_up+0x43/0x70
[1172609.961098]  [<ffffffff8027a520>] vfs_ioctl+0x220/0x2c0
[1172609.963662]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172609.966234]  [<ffffffff8027a609>] sys_ioctl+0x49/0x80
[1172609.968766]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172609.971279] 
[1172609.973759] screen        S 0000000000000000     0 30991  30976
[1172609.976308]  ffff8101a8329f68 0000000000000086 0000000000000000 00000000ffffffff
[1172609.978892]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172609.981501]  ffffffff80747dc0 ffff81021e322918 ffff8101a8329f34 ffff8101a8329f28
[1172609.981605] Call Trace:
[1172609.986634]  [<ffffffff8022b0c5>] alarm_setitimer+0x35/0x70
[1172609.989220]  [<ffffffff80232a09>] sys_pause+0x19/0x30
[1172609.991766]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172609.994292] 
[1172609.996787] screen        D ffff8100a18ff800     0 30992  30991
[1172609.999344]  ffff8101a854dd28 0000000000000086 ffff81022854ddb7 ffff8101a854dcd8
[1172610.001953]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.004574]  ffffffff80747dc0 ffff810170233028 ffffffff80656bcb ffffffff8021f8bc
[1172610.004677] Call Trace:
[1172610.009752]  [<ffffffff8021f8bc>] task_rq_lock+0x4c/0x90
[1172610.012366]  [<ffffffff8021fb88>] try_to_wake_up+0x68/0x3b0
[1172610.014981]  [<ffffffff80590f9d>] wait_for_completion+0x7d/0xc0
[1172610.017594]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.020208]  [<ffffffff8023706a>] flush_cpu_workqueue+0x6a/0x90
[1172610.022828]  [<ffffffff802371b0>] wq_barrier_func+0x0/0x10
[1172610.025447]  [<ffffffff80237183>] flush_workqueue+0x33/0x50
[1172610.028076]  [<ffffffff803e633f>] release_dev+0x44f/0x750
[1172610.030710]  [<ffffffff80284847>] mntput_no_expire+0x27/0xb0
[1172610.033339]  [<ffffffff803e6651>] tty_release+0x11/0x20
[1172610.035958]  [<ffffffff8026e531>] __fput+0xb1/0x1a0
[1172610.038547]  [<ffffffff8026b544>] filp_close+0x54/0x90
[1172610.041106]  [<ffffffff8026ccc6>] sys_close+0x96/0x100
[1172610.043652]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.046160] 
[1172610.048618] bash          ? 0000000000000000     0 30993  30992
[1172610.051135]  ffff8101aa2a3ee8 0000000000000046 ffff8101aa2a3eb0 0000000000000011
[1172610.053708]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.056312]  ffffffff80747dc0 ffff810170233738 ffff8101aa2a3eb4 ffff8101aa2a3ea8
[1172610.056415] Call Trace:
[1172610.061510]  [<ffffffff8022a18e>] do_exit+0x5be/0x8a0
[1172610.064172]  [<ffffffff8022a49c>] do_group_exit+0x2c/0x80
[1172610.066859]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.069537] 
[1172610.072190] sshd          S 0000000000000000     0  7001   7582
[1172610.074908]  ffff8100792b1bf8 0000000000000082 0000000000000000 ffff8101e9c51b80
[1172610.077679]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.080477]  ffffffff80747dc0 ffff8102234ff738 ffff8100792b1bc4 ffff8100792b1bb8
[1172610.080580] Call Trace:
[1172610.086042]  [<ffffffff80591755>] schedule_timeout+0x95/0xd0
[1172610.088861]  [<ffffffff8023ae53>] prepare_to_wait+0x23/0x80
[1172610.091673]  [<ffffffff80575ac6>] unix_stream_recvmsg+0x386/0x550
[1172610.094492]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172610.097318]  [<ffffffff80277aa0>] link_path_walk+0x80/0xf0
[1172610.100148]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172610.102976]  [<ffffffff8026b5f9>] get_unused_fd_flags+0x79/0x120
[1172610.105822]  [<ffffffff8026d349>] do_sync_read+0xd9/0x120
[1172610.108651]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172610.111495]  [<ffffffff8026b7cf>] __dentry_open+0x11f/0x1b0
[1172610.114319]  [<ffffffff8026b96a>] do_filp_open+0x3a/0x50
[1172610.117118]  [<ffffffff8026dcf7>] vfs_read+0x157/0x160
[1172610.119902]  [<ffffffff8026e113>] sys_read+0x53/0x90
[1172610.122638]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.125360] 
[1172610.128056] sshd          S 0000000000000000     0  7003   7001
[1172610.130818]  ffff8100675a39e8 0000000000000082 ffff8100675a39b0 0000000000000002
[1172610.133623]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.136446]  ffffffff80747dc0 ffff810225459028 ffff8100675a39b4 ffff8100675a39a8
[1172610.136549] Call Trace:
[1172610.142064]  [<ffffffff8059171f>] schedule_timeout+0x5f/0xd0
[1172610.144899]  [<ffffffff8022f920>] process_timeout+0x0/0x10
[1172610.147716]  [<ffffffff8027b528>] do_select+0x468/0x560
[1172610.150495]  [<ffffffff8027bbc0>] __pollwait+0x0/0x130
[1172610.153260]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.156005]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.158707]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.161378]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.164026]  [<ffffffff8050bd41>] skb_copy_datagram_iovec+0x1a1/0x260
[1172610.166675]  [<ffffffff80592da9>] _spin_lock_bh+0x9/0x20
[1172610.169315]  [<ffffffff80505743>] release_sock+0x13/0xb0
[1172610.171917]  [<ffffffff80547700>] tcp_recvmsg+0x370/0x940
[1172610.174494]  [<ffffffff80505080>] sock_common_recvmsg+0x30/0x50
[1172610.177085]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172610.179638]  [<ffffffff8027b829>] core_sys_select+0x209/0x300
[1172610.182178]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172610.184734]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.187290]  [<ffffffff8022b51e>] current_fs_time+0x1e/0x30
[1172610.189837]  [<ffffffff803e3582>] tty_ldisc_deref+0x52/0x80
[1172610.192370]  [<ffffffff8027bdc1>] sys_select+0xd1/0x1c0
[1172610.194900]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.197426] 
[1172610.199919] bash          S 000000000000000e     0  7004   7003
[1172610.202470]  ffff8100cc263e88 0000000000000082 80000000804ca065 ffff81022367f530
[1172610.205071]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.207699]  ffffffff80747dc0 ffff8102234fe918 ffff8100cc263e38 ffff810035a16348
[1172610.207802] Call Trace:
[1172610.212949]  [<ffffffff8021cb22>] do_page_fault+0x202/0x890
[1172610.215618]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172610.218263]  [<ffffffff8021f7e3>] __wake_up+0x43/0x70
[1172610.220900]  [<ffffffff8027a520>] vfs_ioctl+0x220/0x2c0
[1172610.223509]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.226109]  [<ffffffff8027a609>] sys_ioctl+0x49/0x80
[1172610.228693]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.231240] 
[1172610.233746] aur           S 0000000000000000     0  7014   7004
[1172610.236319]  ffff810098071e88 0000000000000086 ffff810098071e50 ffffffff80232c93
[1172610.238941]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.241566]  ffffffff80747dc0 ffff81022367f738 ffff810098071e54 ffff810098071e48
[1172610.241669] Call Trace:
[1172610.246766]  [<ffffffff80232c93>] get_signal_to_deliver+0x73/0x470
[1172610.249380]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172610.251983]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.254563]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.257122] 
[1172610.259648] aur           S 0000000000000004     0  7066   7014
[1172610.262226]  ffff810085231e88 0000000000000086 ffff8101ea314ce8 ffffffff80232c93
[1172610.264844]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.267471]  ffffffff80747dc0 ffff8101ea314918 ffffffff802302ce ffffffff8020b3d6
[1172610.267574] Call Trace:
[1172610.272674]  [<ffffffff80232c93>] get_signal_to_deliver+0x73/0x470
[1172610.275315]  [<ffffffff802302ce>] recalc_sigpending+0xe/0x30
[1172610.277948]  [<ffffffff8020b3d6>] do_notify_resume+0x536/0x7a0
[1172610.280577]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172610.283199]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.285840]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.288491] 
[1172610.291116] unrar         D ffff8100aa785c80     0  7135   7066
[1172610.293792]  ffff8101ecf4ddb8 0000000000000086 ffff8101ecf4dd80 0000000000000000
[1172610.296525]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.299256]  ffffffff80747dc0 ffff81021e53f028 ffff8101ecf4dd84 ffff8101ecf4dd78
[1172610.299359] Call Trace:
[1172610.304629]  [<ffffffff80385635>] vn_iowait+0x75/0xa0
[1172610.307301]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172610.309979]  [<ffffffff8036d19c>] xfs_trans_alloc+0x9c/0xb0
[1172610.312653]  [<ffffffff80357fb5>] xfs_itruncate_start+0x35/0xe0
[1172610.315340]  [<ffffffff80372c3a>] xfs_free_eofblocks+0x17a/0x280
[1172610.318032]  [<ffffffff80377e74>] xfs_release+0x134/0x1e0
[1172610.320711]  [<ffffffff8037ed7a>] xfs_file_release+0x1a/0x30
[1172610.323417]  [<ffffffff8026e531>] __fput+0xb1/0x1a0
[1172610.326144]  [<ffffffff8026b544>] filp_close+0x54/0x90
[1172610.328895]  [<ffffffff8026ccc6>] sys_close+0x96/0x100
[1172610.331631]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.334353] 
[1172610.337050] sshd          D 0000000000000000     0  7187   7582
[1172610.339811]  ffff81002b62fd28 0000000000000086 ffff81002b62fcf0 ffff81002b62fcd8
[1172610.342618]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.345448]  ffffffff80747dc0 ffff8101ccda3028 ffff81002b62fcf4 ffff81002b62fce8
[1172610.345551] Call Trace:
[1172610.351072]  [<ffffffff80590f9d>] wait_for_completion+0x7d/0xc0
[1172610.353915]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.356765]  [<ffffffff8023706a>] flush_cpu_workqueue+0x6a/0x90
[1172610.359622]  [<ffffffff802371b0>] wq_barrier_func+0x0/0x10
[1172610.362477]  [<ffffffff80237183>] flush_workqueue+0x33/0x50
[1172610.365337]  [<ffffffff803e633f>] release_dev+0x44f/0x750
[1172610.368184]  [<ffffffff8026c04a>] sys_fchmodat+0x6a/0x120
[1172610.371026]  [<ffffffff803e6651>] tty_release+0x11/0x20
[1172610.373843]  [<ffffffff8026e531>] __fput+0xb1/0x1a0
[1172610.376628]  [<ffffffff8026b544>] filp_close+0x54/0x90
[1172610.379402]  [<ffffffff8026ccc6>] sys_close+0x96/0x100
[1172610.382135]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.384846] 
[1172610.387529] sshd          ? 0000000000000000     0  7218   7187
[1172610.390280]  ffff81013bd7bee8 0000000000000046 ffff81013bd7beb0 0000000000000011
[1172610.393084]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.395907]  ffffffff80747dc0 ffff8101bf6ae918 ffff81013bd7beb4 ffff81013bd7bea8
[1172610.396010] Call Trace:
[1172610.401528]  [<ffffffff8022246c>] __cond_resched+0x1c/0x50
[1172610.404362]  [<ffffffff8022a18e>] do_exit+0x5be/0x8a0
[1172610.407192]  [<ffffffff8022a49c>] do_group_exit+0x2c/0x80
[1172610.409993]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.412776] 
[1172610.415520] sshd          S 0000000000000000     0  7236   7582
[1172610.418293]  ffff8101e4a89bf8 0000000000000082 ffff8101e4a89bc0 ffff81013bf542c0
[1172610.421090]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.423898]  ffffffff80747dc0 ffff810168684208 ffff8101e4a89bc4 ffff8101e4a89bb8
[1172610.424001] Call Trace:
[1172610.429474]  [<ffffffff80591755>] schedule_timeout+0x95/0xd0
[1172610.432284]  [<ffffffff8023ae53>] prepare_to_wait+0x23/0x80
[1172610.435096]  [<ffffffff80575ac6>] unix_stream_recvmsg+0x386/0x550
[1172610.437896]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172610.440690]  [<ffffffff80277aa0>] link_path_walk+0x80/0xf0
[1172610.443487]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172610.446249]  [<ffffffff8026b5f9>] get_unused_fd_flags+0x79/0x120
[1172610.448997]  [<ffffffff8026d349>] do_sync_read+0xd9/0x120
[1172610.451737]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172610.454491]  [<ffffffff8026b7cf>] __dentry_open+0x11f/0x1b0
[1172610.457244]  [<ffffffff8026b96a>] do_filp_open+0x3a/0x50
[1172610.459989]  [<ffffffff8026dcf7>] vfs_read+0x157/0x160
[1172610.462724]  [<ffffffff8026e113>] sys_read+0x53/0x90
[1172610.465430]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.468131] 
[1172610.470765] sshd          S 0000000000000000     0  7238   7236
[1172610.473440]  ffff810046e1f9e8 0000000000000082 ffff810046e1f9b0 0000000000000002
[1172610.476161]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.478873]  ffffffff80747dc0 ffff810168685028 ffff810046e1f9b4 ffff810046e1f9a8
[1172610.478975] Call Trace:
[1172610.484236]  [<ffffffff8059171f>] schedule_timeout+0x5f/0xd0
[1172610.486940]  [<ffffffff8022f920>] process_timeout+0x0/0x10
[1172610.489645]  [<ffffffff8027b528>] do_select+0x468/0x560
[1172610.492340]  [<ffffffff8027bbc0>] __pollwait+0x0/0x130
[1172610.495030]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.497738]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.500417]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.503076]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.505711]  [<ffffffff8050bd41>] skb_copy_datagram_iovec+0x1a1/0x260
[1172610.508366]  [<ffffffff80592da9>] _spin_lock_bh+0x9/0x20
[1172610.511004]  [<ffffffff80505743>] release_sock+0x13/0xb0
[1172610.513638]  [<ffffffff80547700>] tcp_recvmsg+0x370/0x940
[1172610.516245]  [<ffffffff80505080>] sock_common_recvmsg+0x30/0x50
[1172610.518841]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172610.521423]  [<ffffffff8027b829>] core_sys_select+0x209/0x300
[1172610.523974]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172610.526518]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.529058]  [<ffffffff8022b51e>] current_fs_time+0x1e/0x30
[1172610.531592]  [<ffffffff803e3582>] tty_ldisc_deref+0x52/0x80
[1172610.534118]  [<ffffffff8027bdc1>] sys_select+0xd1/0x1c0
[1172610.536645]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.539162] 
[1172610.541651] bash          S 000000000000000e     0  7239   7238
[1172610.544203]  ffff8100aae5fe88 0000000000000082 80000001bab2c065 ffff810145b6ae20
[1172610.546809]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.549446]  ffffffff80747dc0 ffff810168685738 ffff8100aae5fe38 ffff810065785f18
[1172610.549550] Call Trace:
[1172610.554709]  [<ffffffff8021cb22>] do_page_fault+0x202/0x890
[1172610.557368]  [<ffffffff8021ed69>] update_curr+0x109/0x120
[1172610.560022]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172610.562647]  [<ffffffff805907c6>] __sched_text_start+0x166/0x23d
[1172610.565267]  [<ffffffff8021f7e3>] __wake_up+0x43/0x70
[1172610.567871]  [<ffffffff8027a520>] vfs_ioctl+0x220/0x2c0
[1172610.570435]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.572998]  [<ffffffff8027a609>] sys_ioctl+0x49/0x80
[1172610.575555]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.578118] 
[1172610.580652] sshd          S 0000000000000000     0  7248   7582
[1172610.583235]  ffff8101120d5bf8 0000000000000082 ffff8101120d5bc0 ffff81001e998dc0
[1172610.585865]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.588489]  ffffffff80747dc0 ffff810130906208 ffff8101120d5bc4 ffff8101120d5bb8
[1172610.588592] Call Trace:
[1172610.593666]  [<ffffffff80591755>] schedule_timeout+0x95/0xd0
[1172610.596253]  [<ffffffff8023ae53>] prepare_to_wait+0x23/0x80
[1172610.598824]  [<ffffffff80575ac6>] unix_stream_recvmsg+0x386/0x550
[1172610.601405]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172610.603992]  [<ffffffff80277aa0>] link_path_walk+0x80/0xf0
[1172610.606571]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172610.609138]  [<ffffffff8026b5f9>] get_unused_fd_flags+0x79/0x120
[1172610.611720]  [<ffffffff8026d349>] do_sync_read+0xd9/0x120
[1172610.614293]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172610.616883]  [<ffffffff8026b7cf>] __dentry_open+0x11f/0x1b0
[1172610.619463]  [<ffffffff8026b96a>] do_filp_open+0x3a/0x50
[1172610.622029]  [<ffffffff8026dcf7>] vfs_read+0x157/0x160
[1172610.624594]  [<ffffffff8026e113>] sys_read+0x53/0x90
[1172610.627144]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.629703] 
[1172610.632237] sshd          S 0000000000000000     0  7250   7248
[1172610.634822]  ffff810126f3d9e8 0000000000000086 ffff810126f3d9b0 0000000000000002
[1172610.637453]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.640086]  ffffffff80747dc0 ffff810130907028 ffff810126f3d9b4 ffff810126f3d9a8
[1172610.640190] Call Trace:
[1172610.645268]  [<ffffffff8059171f>] schedule_timeout+0x5f/0xd0
[1172610.647857]  [<ffffffff8022f920>] process_timeout+0x0/0x10
[1172610.650429]  [<ffffffff8027b528>] do_select+0x468/0x560
[1172610.652990]  [<ffffffff8027bbc0>] __pollwait+0x0/0x130
[1172610.655552]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.658131]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.660680]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.663230]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.665779]  [<ffffffff8050bd41>] skb_copy_datagram_iovec+0x1a1/0x260
[1172610.668368]  [<ffffffff80592da9>] _spin_lock_bh+0x9/0x20
[1172610.670946]  [<ffffffff80505743>] release_sock+0x13/0xb0
[1172610.673510]  [<ffffffff80547700>] tcp_recvmsg+0x370/0x940
[1172610.676075]  [<ffffffff80505080>] sock_common_recvmsg+0x30/0x50
[1172610.678653]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172610.681222]  [<ffffffff8027b829>] core_sys_select+0x209/0x300
[1172610.683798]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172610.686386]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.688970]  [<ffffffff8022b51e>] current_fs_time+0x1e/0x30
[1172610.691546]  [<ffffffff803e3582>] tty_ldisc_deref+0x52/0x80
[1172610.694114]  [<ffffffff8027bdc1>] sys_select+0xd1/0x1c0
[1172610.696683]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.699244] 
[1172610.701782] bash          S 000000000000000e     0  7251   7250
[1172610.704370]  ffff810121e8de88 0000000000000086 800000008e47c065 ffff8101afbec710
[1172610.707005]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.709641]  ffffffff80747dc0 ffff810130907738 ffff810121e8de38 ffff8101e65ef9d8
[1172610.709744] Call Trace:
[1172610.714827]  [<ffffffff8021cb22>] do_page_fault+0x202/0x890
[1172610.717419]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172610.719979]  [<ffffffff8021f7e3>] __wake_up+0x43/0x70
[1172610.722535]  [<ffffffff8027a520>] vfs_ioctl+0x220/0x2c0
[1172610.725088]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.727650]  [<ffffffff8027a609>] sys_ioctl+0x49/0x80
[1172610.730203]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.732759] 
[1172610.735278] su            S 0000000000000000     0  7269   7251
[1172610.737850]  ffff8101a5007e88 0000000000000086 ffff8101a5007e50 ffff8100219c0e20
[1172610.740475]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.743107]  ffffffff80747dc0 ffff8101afbec918 ffff8101a5007e54 ffff8101a5007e48
[1172610.743210] Call Trace:
[1172610.748316]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172610.750913]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.753518]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.756084] 
[1172610.758600] bash          S 0000000000000000     0  7270   7269
[1172610.761175]  ffff81014bc9be88 0000000000000086 ffff81014bc9be50 ffff810139e7c000
[1172610.763792]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.766419]  ffffffff80747dc0 ffff8100219c1028 ffff81014bc9be54 ffff81014bc9be48
[1172610.766521] Call Trace:
[1172610.771636]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172610.774264]  [<ffffffff8021f7e3>] __wake_up+0x43/0x70
[1172610.776885]  [<ffffffff8027a520>] vfs_ioctl+0x220/0x2c0
[1172610.779492]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.782107]  [<ffffffff8027a609>] sys_ioctl+0x49/0x80
[1172610.784719]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.787329] 
[1172610.789920] sshd          S 0000000000000000     0  7278   7582
[1172610.792579]  ffff810194cf5bf8 0000000000000086 ffff810194cf5bc0 ffff810010755600
[1172610.795276]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.797987]  ffffffff80747dc0 ffff81002d667738 ffff810194cf5bc4 ffff810194cf5bb8
[1172610.798090] Call Trace:
[1172610.803311]  [<ffffffff80591755>] schedule_timeout+0x95/0xd0
[1172610.805992]  [<ffffffff8023ae53>] prepare_to_wait+0x23/0x80
[1172610.808641]  [<ffffffff80575ac6>] unix_stream_recvmsg+0x386/0x550
[1172610.811284]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172610.813937]  [<ffffffff80277aa0>] link_path_walk+0x80/0xf0
[1172610.816593]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172610.819250]  [<ffffffff8026b5f9>] get_unused_fd_flags+0x79/0x120
[1172610.821914]  [<ffffffff8026d349>] do_sync_read+0xd9/0x120
[1172610.824602]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172610.827337]  [<ffffffff8026b7cf>] __dentry_open+0x11f/0x1b0
[1172610.830101]  [<ffffffff8026b96a>] do_filp_open+0x3a/0x50
[1172610.832855]  [<ffffffff8026dcf7>] vfs_read+0x157/0x160
[1172610.835593]  [<ffffffff8026e113>] sys_read+0x53/0x90
[1172610.838321]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.841049] 
[1172610.843744] sshd          S 0000000000000000     0  7280   7278
[1172610.846501]  ffff81013acb39e8 0000000000000082 ffff81013acb39b0 0000000000000002
[1172610.849305]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.852125]  ffffffff80747dc0 ffff81011060e918 ffff81013acb39b4 ffff81013acb39a8
[1172610.852228] Call Trace:
[1172610.857719]  [<ffffffff8059171f>] schedule_timeout+0x5f/0xd0
[1172610.860553]  [<ffffffff8022f920>] process_timeout+0x0/0x10
[1172610.863393]  [<ffffffff8027b528>] do_select+0x468/0x560
[1172610.866228]  [<ffffffff8027bbc0>] __pollwait+0x0/0x130
[1172610.869046]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.871874]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.874652]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.877377]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.880068]  [<ffffffff80267609>] add_partial+0x19/0x60
[1172610.882722]  [<ffffffff80268a0d>] __slab_free+0x15d/0x310
[1172610.885354]  [<ffffffff80592da9>] _spin_lock_bh+0x9/0x20
[1172610.887984]  [<ffffffff80505743>] release_sock+0x13/0xb0
[1172610.890616]  [<ffffffff80547700>] tcp_recvmsg+0x370/0x940
[1172610.893251]  [<ffffffff80505080>] sock_common_recvmsg+0x30/0x50
[1172610.895887]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172610.898512]  [<ffffffff8027b829>] core_sys_select+0x209/0x300
[1172610.901144]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172610.903780]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.906421]  [<ffffffff8022b51e>] current_fs_time+0x1e/0x30
[1172610.909040]  [<ffffffff803e3582>] tty_ldisc_deref+0x52/0x80
[1172610.911632]  [<ffffffff8027bdc1>] sys_select+0xd1/0x1c0
[1172610.914215]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.916754] 
[1172610.919253] bash          S 000000000000000e     0  7281   7280
[1172610.921808]  ffff8101919e3e88 0000000000000082 80000001542be065 ffff8100867c7530
[1172610.924409]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.927021]  ffffffff80747dc0 ffff81011060f028 ffff8101919e3e38 ffff8101aae8a930
[1172610.927124] Call Trace:
[1172610.932186]  [<ffffffff8021cb22>] do_page_fault+0x202/0x890
[1172610.934771]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172610.937337]  [<ffffffff8021f7e3>] __wake_up+0x43/0x70
[1172610.939863]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.942391]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.944923] 
[1172610.947429] su            S 0000000000000000     0  7288   7281
[1172610.949987]  ffff81004e873e88 0000000000000086 ffff81004e873e50 ffff81011060f530
[1172610.952588]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.955214]  ffffffff80747dc0 ffff8100867c7738 ffff81004e873e54 ffff81004e873e48
[1172610.955317] Call Trace:
[1172610.960412]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172610.963007]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.965602]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172610.968186] 
[1172610.970703] bash          S 0000000000000000     0  7289   7288
[1172610.973262]  ffff810043dbfdb8 0000000000000082 ffff810043dbfd80 0000000000000fee
[1172610.975867]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172610.978487]  ffffffff80747dc0 ffff81011060f738 ffff810043dbfd84 ffff810043dbfd78
[1172610.978590] Call Trace:
[1172610.983666]  [<ffffffff80591755>] schedule_timeout+0x95/0xd0
[1172610.986293]  [<ffffffff8023af8c>] add_wait_queue+0x1c/0x60
[1172610.988916]  [<ffffffff803e9bf8>] read_chan+0x228/0x6f0
[1172610.991531]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172610.994156]  [<ffffffff803e6710>] tty_read+0xb0/0x100
[1172610.996766]  [<ffffffff8026dc65>] vfs_read+0xc5/0x160
[1172610.999359]  [<ffffffff8026e113>] sys_read+0x53/0x90
[1172611.001936]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.004527] 
[1172611.007092] strace        S 0000000000000000     0  7319   7270
[1172611.009707]  ffff8101534a9e88 0000000000000086 ffff8101534a9e50 0000000000000092
[1172611.012368]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.015032]  ffffffff80747dc0 ffff810139e7c208 ffff8101534a9e54 ffff8101534a9e48
[1172611.015135] Call Trace:
[1172611.020281]  [<ffffffff80231215>] __group_send_sig_info+0x75/0xa0
[1172611.022914]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172611.025526]  [<ffffffff80231aa1>] kill_pid_info+0x51/0x90
[1172611.028133]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.030760]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.033389] 
[1172611.035983] rm            D 0000000000000000     0  7463   7239
[1172611.038664]  ffff8101254a3b08 0000000000000086 ffff8101254a3ad0 ffffffff80592c6c
[1172611.041422]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.044223]  ffffffff80747dc0 ffff810145b6b028 ffff8101254a3ad4 ffff8101254a3ac8
[1172611.044326] Call Trace:
[1172611.049792]  [<ffffffff80592c6c>] __down+0x10c/0x11f
[1172611.052604]  [<ffffffff80592c07>] __down+0xa7/0x11f
[1172611.055405]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.058227]  [<ffffffff80592886>] __down_failed+0x35/0x3a
[1172611.061044]  [<ffffffff8037c09e>] xfs_buf_lock+0x3e/0x40
[1172611.063866]  [<ffffffff80367be5>] xfs_getsb+0x15/0x40
[1172611.066676]  [<ffffffff8036e2da>] xfs_trans_getsb+0x5a/0xb0
[1172611.069478]  [<ffffffff8036d1bf>] xfs_trans_apply_sb_deltas+0xf/0x370
[1172611.072281]  [<ffffffff8036d5be>] _xfs_trans_commit+0x9e/0x3c0
[1172611.075085]  [<ffffffff8039c301>] __up_read+0x21/0xb0
[1172611.077884]  [<ffffffff80327522>] xfs_free_extent+0xe2/0x110
[1172611.080690]  [<ffffffff80379e9c>] kmem_zone_alloc+0x5c/0xd0
[1172611.083499]  [<ffffffff80379e9c>] kmem_zone_alloc+0x5c/0xd0
[1172611.086267]  [<ffffffff80379f42>] kmem_zone_zalloc+0x32/0x50
[1172611.089024]  [<ffffffff80357c9b>] xfs_itruncate_finish+0xdb/0x320
[1172611.091768]  [<ffffffff80378311>] xfs_inactive+0x3f1/0x520
[1172611.094486]  [<ffffffff80384629>] xfs_fs_clear_inode+0xa9/0x100
[1172611.097203]  [<ffffffff802821e8>] clear_inode+0x58/0xf0
[1172611.099883]  [<ffffffff80282369>] generic_delete_inode+0xe9/0xf0
[1172611.102557]  [<ffffffff802783fa>] do_unlinkat+0x14a/0x1c0
[1172611.105235]  [<ffffffff8059301d>] error_exit+0x0/0x84
[1172611.107916]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.110592] 
[1172611.113232] pickup        S 0000000000000000     0  7573  30580
[1172611.115922]  ffff81021d34be58 0000000000000086 ffff81021d34be20 0000000000000000
[1172611.118661]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.121398]  ffffffff80747dc0 ffff8101964af028 ffff81021d34be24 ffff81021d34be18
[1172611.121501] Call Trace:
[1172611.126801]  [<ffffffff8059171f>] schedule_timeout+0x5f/0xd0
[1172611.129501]  [<ffffffff8022f920>] process_timeout+0x0/0x10
[1172611.132189]  [<ffffffff8029af2d>] sys_epoll_wait+0x1bd/0x4e0
[1172611.134877]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.137570]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.140247] 
[1172611.142890] bash          D 0000000000000000     0  8896      1
[1172611.145570]  ffff8101cdf07ac8 0000000000000046 ffff8101cdf07a90 ffff810226a79800
[1172611.148276]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.150995]  ffffffff80747dc0 ffff810114417738 ffff8101cdf07a94 ffff8101cdf07a88
[1172611.151098] Call Trace:
[1172611.156317]  [<ffffffff80590f9d>] wait_for_completion+0x7d/0xc0
[1172611.159006]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.161706]  [<ffffffff8023706a>] flush_cpu_workqueue+0x6a/0x90
[1172611.164401]  [<ffffffff802371b0>] wq_barrier_func+0x0/0x10
[1172611.167086]  [<ffffffff80237183>] flush_workqueue+0x33/0x50
[1172611.169785]  [<ffffffff803e633f>] release_dev+0x44f/0x750
[1172611.172499]  [<ffffffff805907c6>] __sched_text_start+0x166/0x23d
[1172611.175232]  [<ffffffff803e6651>] tty_release+0x11/0x20
[1172611.177948]  [<ffffffff8026e531>] __fput+0xb1/0x1a0
[1172611.180652]  [<ffffffff8026b544>] filp_close+0x54/0x90
[1172611.183331]  [<ffffffff80228971>] put_files_struct+0xb1/0xd0
[1172611.185991]  [<ffffffff80229d79>] do_exit+0x1a9/0x8a0
[1172611.188636]  [<ffffffff80230c85>] __dequeue_signal+0x165/0x1f0
[1172611.191258]  [<ffffffff8022a49c>] do_group_exit+0x2c/0x80
[1172611.193857]  [<ffffffff80232ee7>] get_signal_to_deliver+0x2c7/0x470
[1172611.196464]  [<ffffffff8020af65>] do_notify_resume+0xc5/0x7a0
[1172611.199077]  [<ffffffff80230992>] send_signal+0x62/0x1f0
[1172611.201678]  [<ffffffff80231215>] __group_send_sig_info+0x75/0xa0
[1172611.204289]  [<ffffffff80231a2e>] group_send_sig_info+0x6e/0x90
[1172611.206890]  [<ffffffff8020b984>] sys_rt_sigreturn+0x324/0x3d0
[1172611.209498]  [<ffffffff802322be>] sys_rt_sigaction+0x8e/0xc0
[1172611.212068]  [<ffffffff8020bd66>] int_signal+0x12/0x17
[1172611.214618] 
[1172611.217129] su            ? 0000000000000000     0  8903   8896
[1172611.219666]  ffff8101e685dee8 0000000000000046 ffff8101e685deb0 0000000000000011
[1172611.222241]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.224859]  ffffffff80747dc0 ffff8101158e9028 ffff8101e685deb4 ffff8101e685dea8
[1172611.224962] Call Trace:
[1172611.230051]  [<ffffffff8022a18e>] do_exit+0x5be/0x8a0
[1172611.232666]  [<ffffffff8022a49c>] do_group_exit+0x2c/0x80
[1172611.235284]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.237904] 
[1172611.240493] bash          D ffff8101bfb7e600     0  8977      1
[1172611.243132]  ffff810106e37ac8 0000000000000046 ffff810106e37c08 ffff810226a79800
[1172611.245831]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.248548]  ffffffff80747dc0 ffff81018e79d738 0000000000000000 0000000000000000
[1172611.248652] Call Trace:
[1172611.253996]  [<ffffffff80590f9d>] wait_for_completion+0x7d/0xc0
[1172611.256787]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.259581]  [<ffffffff8023706a>] flush_cpu_workqueue+0x6a/0x90
[1172611.262374]  [<ffffffff802371b0>] wq_barrier_func+0x0/0x10
[1172611.265167]  [<ffffffff80237183>] flush_workqueue+0x33/0x50
[1172611.267952]  [<ffffffff803e633f>] release_dev+0x44f/0x750
[1172611.270733]  [<ffffffff803e6651>] tty_release+0x11/0x20
[1172611.273502]  [<ffffffff8026e531>] __fput+0xb1/0x1a0
[1172611.276259]  [<ffffffff8026b544>] filp_close+0x54/0x90
[1172611.279016]  [<ffffffff80228971>] put_files_struct+0xb1/0xd0
[1172611.281764]  [<ffffffff80229d79>] do_exit+0x1a9/0x8a0
[1172611.284504]  [<ffffffff80230c85>] __dequeue_signal+0x165/0x1f0
[1172611.287232]  [<ffffffff8022a49c>] do_group_exit+0x2c/0x80
[1172611.289939]  [<ffffffff80232ee7>] get_signal_to_deliver+0x2c7/0x470
[1172611.292654]  [<ffffffff8020af65>] do_notify_resume+0xc5/0x7a0
[1172611.295338]  [<ffffffff80230992>] send_signal+0x62/0x1f0
[1172611.298000]  [<ffffffff80231215>] __group_send_sig_info+0x75/0xa0
[1172611.300678]  [<ffffffff80231a2e>] group_send_sig_info+0x6e/0x90
[1172611.303357]  [<ffffffff8020b984>] sys_rt_sigreturn+0x324/0x3d0
[1172611.306036]  [<ffffffff802322be>] sys_rt_sigaction+0x8e/0xc0
[1172611.308696]  [<ffffffff8020bd66>] int_signal+0x12/0x17
[1172611.311338] 
[1172611.313951] su            ? 0000000000000000     0  8984   8977
[1172611.316601]  ffff810151203ee8 0000000000000046 ffff810151203eb0 0000000000000011
[1172611.319282]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.321981]  ffffffff80747dc0 ffff81021a284918 ffff810151203eb4 ffff810151203ea8
[1172611.322083] Call Trace:
[1172611.327263]  [<ffffffff8022a18e>] do_exit+0x5be/0x8a0
[1172611.329910]  [<ffffffff8022a49c>] do_group_exit+0x2c/0x80
[1172611.332547]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.335180] 
[1172611.337787] sshd          S 0000000000000000     0  9072   7582
[1172611.340453]  ffff81012ee91bf8 0000000000000082 ffff81012ee91bc0 ffff8101b0d95080
[1172611.343161]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.345879]  ffffffff80747dc0 ffff8101cb862918 ffff81012ee91bc4 ffff81012ee91bb8
[1172611.345982] Call Trace:
[1172611.351307]  [<ffffffff80591755>] schedule_timeout+0x95/0xd0
[1172611.354060]  [<ffffffff8023ae53>] prepare_to_wait+0x23/0x80
[1172611.356818]  [<ffffffff80575ac6>] unix_stream_recvmsg+0x386/0x550
[1172611.359584]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172611.362359]  [<ffffffff80277aa0>] link_path_walk+0x80/0xf0
[1172611.365126]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172611.367882]  [<ffffffff8026b5f9>] get_unused_fd_flags+0x79/0x120
[1172611.370649]  [<ffffffff8026d349>] do_sync_read+0xd9/0x120
[1172611.373404]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172611.376174]  [<ffffffff8021e992>] pick_next_task_fair+0x42/0x70
[1172611.378939]  [<ffffffff805907c6>] __sched_text_start+0x166/0x23d
[1172611.381719]  [<ffffffff8026b96a>] do_filp_open+0x3a/0x50
[1172611.384497]  [<ffffffff8026dcf7>] vfs_read+0x157/0x160
[1172611.387260]  [<ffffffff8026e113>] sys_read+0x53/0x90
[1172611.390008]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.392729] 
[1172611.395395] sshd          S 0000000000000000     0  9074   9072
[1172611.398114]  ffff8101677179e8 0000000000000086 ffff8101677179b0 0000000000000002
[1172611.400847]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.403591]  ffffffff80747dc0 ffff8101cb863738 ffff8101677179b4 ffff8101677179a8
[1172611.403694] Call Trace:
[1172611.409063]  [<ffffffff8059171f>] schedule_timeout+0x5f/0xd0
[1172611.411822]  [<ffffffff8022f920>] process_timeout+0x0/0x10
[1172611.414587]  [<ffffffff8027b528>] do_select+0x468/0x560
[1172611.417307]  [<ffffffff8027bbc0>] __pollwait+0x0/0x130
[1172611.420004]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.422704]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.425339]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.427923]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.430472]  [<ffffffff80267609>] add_partial+0x19/0x60
[1172611.433013]  [<ffffffff80268a0d>] __slab_free+0x15d/0x310
[1172611.435547]  [<ffffffff80592da9>] _spin_lock_bh+0x9/0x20
[1172611.438080]  [<ffffffff80505743>] release_sock+0x13/0xb0
[1172611.440607]  [<ffffffff80547700>] tcp_recvmsg+0x370/0x940
[1172611.443136]  [<ffffffff80505080>] sock_common_recvmsg+0x30/0x50
[1172611.445679]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172611.448224]  [<ffffffff8027b829>] core_sys_select+0x209/0x300
[1172611.450769]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172611.453330]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.455892]  [<ffffffff8022b51e>] current_fs_time+0x1e/0x30
[1172611.458451]  [<ffffffff803e3582>] tty_ldisc_deref+0x52/0x80
[1172611.460996]  [<ffffffff8027bdc1>] sys_select+0xd1/0x1c0
[1172611.463530]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.466056] 
[1172611.468545] bash          S 0000000000000000     0  9075   9074
[1172611.471088]  ffff8101a8d01db8 0000000000000086 ffff8101a8d01d80 0000000000000ff5
[1172611.473676]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.476296]  ffffffff80747dc0 ffff81010f26c208 ffff8101a8d01d84 ffff8101a8d01d78
[1172611.476398] Call Trace:
[1172611.481491]  [<ffffffff80591755>] schedule_timeout+0x95/0xd0
[1172611.484118]  [<ffffffff8023af8c>] add_wait_queue+0x1c/0x60
[1172611.486724]  [<ffffffff803e9bf8>] read_chan+0x228/0x6f0
[1172611.489303]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.491890]  [<ffffffff803e6710>] tty_read+0xb0/0x100
[1172611.494437]  [<ffffffff8026dc65>] vfs_read+0xc5/0x160
[1172611.496960]  [<ffffffff8026e113>] sys_read+0x53/0x90
[1172611.499471]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.501978] 
[1172611.504443] sshd          S 0000000000000000     0  9477   7582
[1172611.506967]  ffff810122bb5bf8 0000000000000082 ffff810122bb5bc0 ffff810102e23600
[1172611.509518]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.512071]  ffffffff80747dc0 ffff81019b72e918 ffff810122bb5bc4 ffff810122bb5bb8
[1172611.512174] Call Trace:
[1172611.517102]  [<ffffffff80591755>] schedule_timeout+0x95/0xd0
[1172611.519615]  [<ffffffff8023ae53>] prepare_to_wait+0x23/0x80
[1172611.522128]  [<ffffffff80575ac6>] unix_stream_recvmsg+0x386/0x550
[1172611.524648]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172611.527170]  [<ffffffff80277aa0>] link_path_walk+0x80/0xf0
[1172611.529681]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172611.532193]  [<ffffffff8026b5f9>] get_unused_fd_flags+0x79/0x120
[1172611.534712]  [<ffffffff8026d349>] do_sync_read+0xd9/0x120
[1172611.537222]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172611.539741]  [<ffffffff8021e992>] pick_next_task_fair+0x42/0x70
[1172611.542257]  [<ffffffff805907c6>] __sched_text_start+0x166/0x23d
[1172611.544776]  [<ffffffff8026b96a>] do_filp_open+0x3a/0x50
[1172611.547286]  [<ffffffff8026dcf7>] vfs_read+0x157/0x160
[1172611.549793]  [<ffffffff8026e113>] sys_read+0x53/0x90
[1172611.552298]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.554805] 
[1172611.557268] sshd          S 0000000000000000     0  9479   9477
[1172611.559791]  ffff8101d7f7b9e8 0000000000000082 ffff8101d7f7b9b0 0000000000000002
[1172611.562340]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.564892]  ffffffff80747dc0 ffff81019b72f738 ffff8101d7f7b9b4 ffff8101d7f7b9a8
[1172611.564995] Call Trace:
[1172611.569926]  [<ffffffff8059171f>] schedule_timeout+0x5f/0xd0
[1172611.572443]  [<ffffffff8022f920>] process_timeout+0x0/0x10
[1172611.574957]  [<ffffffff8027b528>] do_select+0x468/0x560
[1172611.577469]  [<ffffffff8027bbc0>] __pollwait+0x0/0x130
[1172611.579979]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.582500]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.585023]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.587546]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.590069]  [<ffffffff8050bd41>] skb_copy_datagram_iovec+0x1a1/0x260
[1172611.592602]  [<ffffffff80592da9>] _spin_lock_bh+0x9/0x20
[1172611.595136]  [<ffffffff80505743>] release_sock+0x13/0xb0
[1172611.597669]  [<ffffffff80547700>] tcp_recvmsg+0x370/0x940
[1172611.600206]  [<ffffffff80505080>] sock_common_recvmsg+0x30/0x50
[1172611.602755]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172611.605295]  [<ffffffff8027b829>] core_sys_select+0x209/0x300
[1172611.607838]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172611.610396]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.612949]  [<ffffffff8022b51e>] current_fs_time+0x1e/0x30
[1172611.615496]  [<ffffffff803e3582>] tty_ldisc_deref+0x52/0x80
[1172611.618033]  [<ffffffff8027bdc1>] sys_select+0xd1/0x1c0
[1172611.620569]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.623100] 
[1172611.625606] bash          S 7fffffffffffffff     0  9480   9479
[1172611.628160]  ffff8101d7ed1db8 0000000000000086 000000000000000b 0000000000000ff5
[1172611.630773]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.633395]  ffffffff80747dc0 ffff8101cb7ee208 0000000000000000 ffff8101657c8018
[1172611.633497] Call Trace:
[1172611.638557]  [<ffffffff80591755>] schedule_timeout+0x95/0xd0
[1172611.641136]  [<ffffffff8023af8c>] add_wait_queue+0x1c/0x60
[1172611.643699]  [<ffffffff803e9bf8>] read_chan+0x228/0x6f0
[1172611.646256]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.648829]  [<ffffffff803e6710>] tty_read+0xb0/0x100
[1172611.651389]  [<ffffffff8026dc65>] vfs_read+0xc5/0x160
[1172611.653928]  [<ffffffff8026e113>] sys_read+0x53/0x90
[1172611.656463]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.659013] 
[1172611.661536] su            S 0000000000000000     0  9613      1
[1172611.664103]  ffff8101c3c57e88 0000000000000086 ffff8101c3c57e50 ffff810117ac0000
[1172611.666717]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.669327]  ffffffff80747dc0 ffff810106581028 ffff8101c3c57e54 ffff8101c3c57e48
[1172611.669430] Call Trace:
[1172611.674472]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172611.677029]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.679584]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.682132] 
[1172611.684643] bash          S 000000000000000e     0  9614   9613
[1172611.687205]  ffff8101ebc27e88 0000000000000082 80000001df3f8065 ffff8101a86f6710
[1172611.689809]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.692439]  ffffffff80747dc0 ffff810117ac0208 ffff8101ebc27e38 ffff8101786d7a80
[1172611.692542] Call Trace:
[1172611.697656]  [<ffffffff8021cb22>] do_page_fault+0x202/0x890
[1172611.700289]  [<ffffffff8021ed69>] update_curr+0x109/0x120
[1172611.702917]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172611.705533]  [<ffffffff805907c6>] __sched_text_start+0x166/0x23d
[1172611.708163]  [<ffffffff8021f7e3>] __wake_up+0x43/0x70
[1172611.710787]  [<ffffffff8027a520>] vfs_ioctl+0x220/0x2c0
[1172611.713422]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.716078]  [<ffffffff8027a609>] sys_ioctl+0x49/0x80
[1172611.718716]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.721349] 
[1172611.723928] bash          D ffff81017bb82900     0  9632      1
[1172611.726540]  ffff8101514abac8 0000000000000046 ffff8101514abc08 ffff810226a79800
[1172611.729205]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.731857]  ffffffff80747dc0 ffff810136f4c918 ffff810007139a50 ffff810004cd4a50
[1172611.731960] Call Trace:
[1172611.737092]  [<ffffffff80590f9d>] wait_for_completion+0x7d/0xc0
[1172611.739754]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172611.742431]  [<ffffffff8023706a>] flush_cpu_workqueue+0x6a/0x90
[1172611.745109]  [<ffffffff802371b0>] wq_barrier_func+0x0/0x10
[1172611.747812]  [<ffffffff80237183>] flush_workqueue+0x33/0x50
[1172611.750540]  [<ffffffff803e633f>] release_dev+0x44f/0x750
[1172611.753296]  [<ffffffff805907c6>] __sched_text_start+0x166/0x23d
[1172611.756058]  [<ffffffff803e6651>] tty_release+0x11/0x20
[1172611.758805]  [<ffffffff8026e531>] __fput+0xb1/0x1a0
[1172611.761549]  [<ffffffff8026b544>] filp_close+0x54/0x90
[1172611.764295]  [<ffffffff80228971>] put_files_struct+0xb1/0xd0
[1172611.767039]  [<ffffffff80229d79>] do_exit+0x1a9/0x8a0
[1172611.769781]  [<ffffffff80230c85>] __dequeue_signal+0x165/0x1f0
[1172611.772533]  [<ffffffff8022a49c>] do_group_exit+0x2c/0x80
[1172611.775279]  [<ffffffff80232ee7>] get_signal_to_deliver+0x2c7/0x470
[1172611.778032]  [<ffffffff8020af65>] do_notify_resume+0xc5/0x7a0
[1172611.780784]  [<ffffffff80230992>] send_signal+0x62/0x1f0
[1172611.783537]  [<ffffffff80231215>] __group_send_sig_info+0x75/0xa0
[1172611.786308]  [<ffffffff80231a2e>] group_send_sig_info+0x6e/0x90
[1172611.789086]  [<ffffffff8020b984>] sys_rt_sigreturn+0x324/0x3d0
[1172611.791858]  [<ffffffff802322be>] sys_rt_sigaction+0x8e/0xc0
[1172611.794615]  [<ffffffff8020bd66>] int_signal+0x12/0x17
[1172611.797334] 
[1172611.799993] su            ? 0000000000000000     0  9639   9632
[1172611.802704]  ffff8101b98afee8 0000000000000046 ffff8101b98afeb0 0000000000000011
[1172611.805431]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.808166]  ffffffff80747dc0 ffff8101243a7028 ffff8101b98afeb4 ffff8101b98afea8
[1172611.808269] Call Trace:
[1172611.813600]  [<ffffffff8022a18e>] do_exit+0x5be/0x8a0
[1172611.816333]  [<ffffffff8022a49c>] do_group_exit+0x2c/0x80
[1172611.819057]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.821794] 
[1172611.824519] mdadm         D 0000000000000000     0  9783   9614
[1172611.827312]  ffff8101aea09a18 0000000000000082 ffff8101aea099e0 ffff8101aea09998
[1172611.830142]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.832994]  ffffffff80747dc0 ffff8101a86f6918 ffff8101aea099e4 ffff8101aea099d8
[1172611.833098] Call Trace:
[1172611.838611]  [<ffffffff8021f7e3>] __wake_up+0x43/0x70
[1172611.841427]  [<ffffffff80247ee0>] sync_page+0x0/0x50
[1172611.844200]  [<ffffffff80591348>] io_schedule+0x28/0x40
[1172611.846961]  [<ffffffff80247f1b>] sync_page+0x3b/0x50
[1172611.849716]  [<ffffffff8059181a>] __wait_on_bit_lock+0x4a/0x80
[1172611.852476]  [<ffffffff80247ebf>] __lock_page+0x5f/0x70
[1172611.855220]  [<ffffffff8023acf0>] wake_bit_function+0x0/0x30
[1172611.857968]  [<ffffffff8024f08a>] pagevec_lookup_tag+0x1a/0x30
[1172611.860699]  [<ffffffff8024d991>] write_cache_pages+0x191/0x340
[1172611.863407]  [<ffffffff8024d370>] __writepage+0x0/0x30
[1172611.866104]  [<ffffffff8024db90>] do_writepages+0x20/0x40
[1172611.868763]  [<ffffffff8028c179>] __writeback_single_inode+0x2d9/0x400
[1172611.871430]  [<ffffffff8021f7e3>] __wake_up+0x43/0x70
[1172611.874087]  [<ffffffff8028c6ca>] sync_sb_inodes+0x21a/0x300
[1172611.876755]  [<ffffffff8028c851>] sync_inodes_sb+0xa1/0xc0
[1172611.879405]  [<ffffffff8026f08b>] __fsync_super+0xb/0x70
[1172611.882049]  [<ffffffff8026f0f9>] fsync_super+0x9/0x20
[1172611.884692]  [<ffffffff80291486>] fsync_bdev+0x26/0x60
[1172611.887318]  [<ffffffff803929a7>] blkdev_ioctl+0x1c7/0x7a0
[1172611.889939]  [<ffffffff802560f1>] handle_mm_fault+0x1a1/0x8a0
[1172611.892573]  [<ffffffff804b072a>] md_open+0x6a/0x90
[1172611.895186]  [<ffffffff802962e0>] blkdev_open+0x0/0x90
[1172611.897799]  [<ffffffff8039c301>] __up_read+0x21/0xb0
[1172611.900374]  [<ffffffff8021cb22>] do_page_fault+0x202/0x890
[1172611.902936]  [<ffffffff8029631c>] blkdev_open+0x3c/0x90
[1172611.905489]  [<ffffffff8029548b>] block_ioctl+0x1b/0x30
[1172611.907994]  [<ffffffff8027a28f>] do_ioctl+0x2f/0xa0
[1172611.910470]  [<ffffffff8027a520>] vfs_ioctl+0x220/0x2c0
[1172611.912938]  [<ffffffff8027a609>] sys_ioctl+0x49/0x80
[1172611.915381]  [<ffffffff8059301d>] error_exit+0x0/0x84
[1172611.917816]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.920256] 
[1172611.922661] sshd          S 0000000000000000     0  9793   7582
[1172611.925122]  ffff8101a7fabbf8 0000000000000086 ffff8101a7fabbc0 ffff8101cd1f1600
[1172611.927626]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.930154]  ffffffff80747dc0 ffff8101536d0918 ffff8101a7fabbc4 ffff8101a7fabbb8
[1172611.930258] Call Trace:
[1172611.935198]  [<ffffffff80591755>] schedule_timeout+0x95/0xd0
[1172611.937753]  [<ffffffff8023ae53>] prepare_to_wait+0x23/0x80
[1172611.940308]  [<ffffffff80575ac6>] unix_stream_recvmsg+0x386/0x550
[1172611.942871]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172611.945439]  [<ffffffff80277aa0>] link_path_walk+0x80/0xf0
[1172611.947997]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172611.950553]  [<ffffffff8026b5f9>] get_unused_fd_flags+0x79/0x120
[1172611.953111]  [<ffffffff8026d349>] do_sync_read+0xd9/0x120
[1172611.955662]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172611.958225]  [<ffffffff8021e992>] pick_next_task_fair+0x42/0x70
[1172611.960800]  [<ffffffff805907c6>] __sched_text_start+0x166/0x23d
[1172611.963379]  [<ffffffff8026b96a>] do_filp_open+0x3a/0x50
[1172611.965946]  [<ffffffff8026dcf7>] vfs_read+0x157/0x160
[1172611.968507]  [<ffffffff8026e113>] sys_read+0x53/0x90
[1172611.971029]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172611.973523] 
[1172611.975978] sshd          S 0000000000000000     0  9795   9793
[1172611.978461]  ffff81021f41d9e8 0000000000000082 ffff81021f41d9b0 0000000000000002
[1172611.980981]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172611.983533]  ffffffff80747dc0 ffff8101536d1738 ffff81021f41d9b4 ffff81021f41d9a8
[1172611.983636] Call Trace:
[1172611.988598]  [<ffffffff8059171f>] schedule_timeout+0x5f/0xd0
[1172611.991157]  [<ffffffff8022f920>] process_timeout+0x0/0x10
[1172611.993698]  [<ffffffff8027b528>] do_select+0x468/0x560
[1172611.996208]  [<ffffffff8027bbc0>] __pollwait+0x0/0x130
[1172611.998705]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172612.001178]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172612.003617]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172612.006034]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172612.008424]  [<ffffffff80267609>] add_partial+0x19/0x60
[1172612.010813]  [<ffffffff80268a0d>] __slab_free+0x15d/0x310
[1172612.013194]  [<ffffffff80592da9>] _spin_lock_bh+0x9/0x20
[1172612.015567]  [<ffffffff80505743>] release_sock+0x13/0xb0
[1172612.017935]  [<ffffffff80547700>] tcp_recvmsg+0x370/0x940
[1172612.020296]  [<ffffffff80505080>] sock_common_recvmsg+0x30/0x50
[1172612.022667]  [<ffffffff80502b9b>] sock_aio_read+0x11b/0x130
[1172612.025029]  [<ffffffff8027b829>] core_sys_select+0x209/0x300
[1172612.027401]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172612.029774]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172612.032143]  [<ffffffff8022b51e>] current_fs_time+0x1e/0x30
[1172612.034510]  [<ffffffff803e3582>] tty_ldisc_deref+0x52/0x80
[1172612.036880]  [<ffffffff8027bdc1>] sys_select+0xd1/0x1c0
[1172612.039245]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172612.041607] 
[1172612.043951] bash          S 000000000000000e     0  9796   9795
[1172612.046358]  ffff81013de09e88 0000000000000086 8000000104441065 ffff8101125a2710
[1172612.048809]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172612.051282]  ffffffff80747dc0 ffff81014da80208 ffff81013de09e38 ffff8101eab7d5e8
[1172612.051385] Call Trace:
[1172612.056215]  [<ffffffff8021cb22>] do_page_fault+0x202/0x890
[1172612.058715]  [<ffffffff8021ed69>] update_curr+0x109/0x120
[1172612.061212]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172612.063714]  [<ffffffff805907c6>] __sched_text_start+0x166/0x23d
[1172612.066238]  [<ffffffff8021f7e3>] __wake_up+0x43/0x70
[1172612.068760]  [<ffffffff8027a520>] vfs_ioctl+0x220/0x2c0
[1172612.071291]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172612.073847]  [<ffffffff8027a609>] sys_ioctl+0x49/0x80
[1172612.076399]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172612.078935] 
[1172612.081438] su            S 0000000000000000     0  9804   9796
[1172612.083976]  ffff810184fdbe88 0000000000000082 ffff810184fdbe50 ffff810120808000
[1172612.086547]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172612.089126]  ffffffff80747dc0 ffff8101125a2918 ffff810184fdbe54 ffff810184fdbe48
[1172612.089229] Call Trace:
[1172612.094170]  [<ffffffff80229439>] do_wait+0x599/0xc90
[1172612.096703]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172612.099244]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172612.101772] 
[1172612.104264] bash          S 0000000000000000     0  9805   9804
[1172612.106820]  ffff8101e88f7db8 0000000000000082 ffff8101e88f7d80 0000000000000ff9
[1172612.109419]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172612.112036]  ffffffff80747dc0 ffff810120808208 ffff8101e88f7d84 ffff8101e88f7d78
[1172612.112139] Call Trace:
[1172612.117216]  [<ffffffff80591755>] schedule_timeout+0x95/0xd0
[1172612.119833]  [<ffffffff8023af8c>] add_wait_queue+0x1c/0x60
[1172612.122446]  [<ffffffff803e9bf8>] read_chan+0x228/0x6f0
[1172612.125058]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172612.127700]  [<ffffffff803e6710>] tty_read+0xb0/0x100
[1172612.130342]  [<ffffffff8026dc65>] vfs_read+0xc5/0x160
[1172612.132958]  [<ffffffff8026e113>] sys_read+0x53/0x90
[1172612.135554]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172612.138121] 
[1172612.140634] smtpd         S 0000000000000000     0  9847  30580
[1172612.143203]  ffff8101a6e25e58 0000000000000086 ffff8101a6e25e20 ffff81022583d318
[1172612.145786]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172612.148371]  ffffffff80747dc0 ffff8101d859a208 ffff8101a6e25e24 ffff8101a6e25e18
[1172612.148474] Call Trace:
[1172612.153514]  [<ffffffff8059171f>] schedule_timeout+0x5f/0xd0
[1172612.156129]  [<ffffffff8022f920>] process_timeout+0x0/0x10
[1172612.158743]  [<ffffffff8029af2d>] sys_epoll_wait+0x1bd/0x4e0
[1172612.161385]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172612.164066]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172612.166774] 
[1172612.169446] smtpd         S ffff81022583d318     0  9963  30580
[1172612.172187]  ffff8101c5f69eb8 0000000000000082 0000000000000000 ffffffff00000001
[1172612.174990]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172612.177819]  ffffffff80747dc0 ffff810105b04918 0000000000000000 000000008bcec672
[1172612.177922] Call Trace:
[1172612.183467]  [<ffffffff8022b4c9>] ns_to_timeval+0x9/0x40
[1172612.186321]  [<ffffffff8027da7d>] flock_lock_file_wait+0x14d/0x300
[1172612.189190]  [<ffffffff8023acc0>] autoremove_wake_function+0x0/0x30
[1172612.192057]  [<ffffffff8027e7ab>] sys_flock+0x16b/0x180
[1172612.194913]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172612.197759] 
[1172612.200578] cleanup       S 0000000000000000     0  9966  30580
[1172612.203466]  ffff8101b50b7e58 0000000000000082 ffff8101b50b7e20 ffff8101a496a828
[1172612.206409]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172612.209358]  ffffffff80747dc0 ffff810132074208 ffff8101b50b7e24 ffff8101b50b7e18
[1172612.209460] Call Trace:
[1172612.215203]  [<ffffffff8059171f>] schedule_timeout+0x5f/0xd0
[1172612.218127]  [<ffffffff8022f920>] process_timeout+0x0/0x10
[1172612.221046]  [<ffffffff8029af2d>] sys_epoll_wait+0x1bd/0x4e0
[1172612.223934]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172612.226813]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172612.229693] 
[1172612.232543] local         S 0000000000000000     0  9967  30580
[1172612.235450]  ffff8101c7bf9e58 0000000000000086 ffff8101c7bf9e20 0000000000000000
[1172612.238401]  ffffffff80747dc0 ffffffff80747dc0 ffffffff80747dc0 ffffffff80744d80
[1172612.241380]  ffffffff80747dc0 ffff8101b11bd738 ffff8101c7bf9e24 ffff8101c7bf9e18
[1172612.241483] Call Trace:
[1172612.247296]  [<ffffffff8059171f>] schedule_timeout+0x5f/0xd0
[1172612.250292]  [<ffffffff8022f920>] process_timeout+0x0/0x10
[1172612.253278]  [<ffffffff8029af2d>] sys_epoll_wait+0x1bd/0x4e0
[1172612.256265]  [<ffffffff8021fed0>] default_wake_function+0x0/0x10
[1172612.259237]  [<ffffffff8020bb4e>] system_call+0x7e/0x83
[1172612.262188]
