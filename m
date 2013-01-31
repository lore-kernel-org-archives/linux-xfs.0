Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BC7A87F4E
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 20:34:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A82F630405F
	for <xfs@oss.sgi.com>; Wed, 30 Jan 2013 18:34:36 -0800 (PST)
Received: from thunder.skymagik.net (thunder.skymagik.net [76.75.207.68]) by
	cuda.sgi.com with ESMTP id 2r2LKPeEWDVCyWtx for
	<xfs@oss.sgi.com>; Wed, 30 Jan 2013 18:34:33 -0800 (PST)
Message-ID: <45719.75.149.17.233.1359599673.squirrel@secure.skymagik.net>
Date: Wed, 30 Jan 2013 21:34:33 -0500 (EST)
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
From: "Tom" <storm9c1@skymagik.com>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

In a previous message, Ben Myers wrote:
> Hi Tom,
>

Hi Ben,

>
> I think you should consider copying linux-raid@vger.kernel.org.
>

That will be next if you think it's appropriate.  Problem is that we
know how the RHEL/CentOS kernel is...


> Did you have a chance to get the sysrq output?  It would be helpful to
> see the other tasks on your machine.

Your wish is my command:

Script started on Wed 30 Jan 2013 09:12:25 PM EST
Stopping sshd: [  OK  ]
Shutting down postfix: [  OK  ]
Shutting down ntpd: [  OK  ]
Killing mdmonitor: [  OK  ]
Stopping mcstransd: [  OK  ]
Stopping portmap: [  OK  ]
Shutting down restorecond: [  OK  ]
Shutting down kernel logger: [  OK  ]
Shutting down system logger: [  OK  ]
Shutting down interface eth0:  [  OK  ]
Shutting down loopback interface:  [  OK  ]
Starting killall:  [  OK  ]
Sending all processes the TERM signal...
Sending all processes the KILL signal...
Saving random seed:
Syncing hardware clock to system time
Turning off swap:
Unmounting pipe file systems:
Unmounting file systems:
Please stand by while rebooting the system...
md: stopping all md devices.
md: md2 switched to read-only mode.
md: md1 switched to read-only mode.

telnet> send brk
t
SysRq : Show State

                                                       sibling
  task                 PC          pid father child younger older
init          S ffff810005e36420     0     1      0     2
(NOTLB)
 ffff81005be95a28 0000000000000086 00000000000002d0 ffff81005acfc3b4
0000000000000292 000000000000000a ffff81005be8c7a0 ffffffff8031cb60
000000444e0246a5 0000000000002014 ffff81005be8c988 0000000088061262
Call Trace:
 [<ffffffff8006389f>] schedule_timeout+0x8a/0xad
 [<ffffffff8009a92b>] process_timeout+0x0/0x5
 [<ffffffff80011bf0>] do_select+0x3dc/0x43c
 [<ffffffff8001f12b>] __pollwait+0x0/0xe2
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff80130625>] avc_alloc_node+0x3a/0x187
 [<ffffffff80130985>] avc_has_perm_noaudit+0x213/0x38a
 [<ffffffff80131590>] avc_has_perm+0x46/0x58
 [<ffffffff80131590>] avc_has_perm+0x46/0x58
 [<ffffffff80131e71>] inode_has_perm+0x56/0x63
 [<ffffffff8000a7b9>] __link_path_walk+0xf10/0xf39
 [<ffffffff800ee494>] core_sys_select+0x1bc/0x265
 [<ffffffff8002d0f1>] mntput_no_expire+0x19/0x89
 [<ffffffff8001b47a>] cp_new_stat+0xe5/0xfd
 [<ffffffff80016a1d>] sys_select+0x153/0x17c
 [<ffffffff8005d116>] system_call+0x7e/0x83

migration/0   S 0000000000000000     0     2      1             3
(L-TLB)
 ffff81005be99ea0 0000000000000046 ffff81005be8c040 ffff81005be8c078
ffffffff8031c800 0000000000000001 ffff81005be8c040 ffff81005be8e7e0
00000004ce553f1e 000000000000056a ffff81005be8c228 000000005be95cc0
Call Trace:
 [<ffffffff80045299>] migration_thread+0x1a1/0x239
 [<ffffffff800450f8>] migration_thread+0x0/0x239
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

ksoftirqd/0   S ffff810005e36420     0     3      1             4     2
(L-TLB)
 ffff81005be9ded0 0000000000000046 ffff81005be8e7e0 ffff810037fef820
0000003cd0ba4d94 000000000000000a ffff81005be8e7e0 ffffffff8031cb60
0000003fec6ce025 000000000000759f ffff81005be8e9c8 000000008008e8b8
Call Trace:
 [<ffffffff800973ed>] ksoftirqd+0x0/0xbf
 [<ffffffff80097428>] ksoftirqd+0x3b/0xbf
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

watchdog/0    S ffff810005e36420     0     4      1             5     3
(L-TLB)
 ffff81005be9fec0 0000000000000046 0000000000000000 ffff810037d104d0
ffffffffffffffff 0000000000000001 ffff81005be8e080 ffffffff8031cb60
000000444e9a79f3 0000000000000197 ffff81005be8e268 00000000800a8484
Call Trace:
 [<ffffffff800be377>] watchdog+0x0/0x5f
 [<ffffffff800be3c6>] watchdog+0x4f/0x5f
 [<ffffffff800be377>] watchdog+0x0/0x5f
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

events/0      S ffff810005e36420     0     5      1             6     4
(L-TLB)
 ffff81005b907e70 0000000000000046 ffff810005e38920 ffff810005e38950
0000000300000000 000000000000000a ffff810037fef820 ffffffff8031cb60
00000044547f155f 000000000000950c ffff810037fefa08 000000008002e4bc
Call Trace:
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

khelper       S ffff810037d34780     0     6      1            19     5
(L-TLB)
 ffff810037f4be70 0000000000000046 ffff8100560bdcc8 ffff810037f4a000
0000000300000000 000000000000000a ffff810037fef0c0 ffff810059d80820
0000000ff1eecf8d 0000000000007485 ffff810037fef2a8 000000008002e4bc
Call Trace:
 [<ffffffff800a032f>] __call_usermodehelper+0x0/0x4f
 [<ffffffff8004d8d0>] run_workqueue+0xcd/0xfb
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

kthread       S ffff810037d34740     0    19      1    23    2050     6
(L-TLB)
 ffff81005b911e70 0000000000000046 000000000000072e ffff810057275d68
0000000300000000 000000000000000a ffff810037fc87e0 ffff810059490860
0000000eb6ada09a 0000000000000eba ffff810037fc89c8 000000008002e4bc
Call Trace:
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8004d8d0>] run_workqueue+0xcd/0xfb
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

kblockd/0     S ffff810037dfb820     0    23     19            24
(L-TLB)
 ffff81005b973e70 0000000000000046 ffffffff801554bc ffffffff8014a6e7
0000000300000000 000000000000000a ffff81005b969860 ffff810037dfb820
0000003fec6c5835 0000000000000f02 ffff81005b969a48 000000008002e4bc
Call Trace:
 [<ffffffff801554bc>] cfq_kick_queue+0x0/0x89
 [<ffffffff8014a6e7>] elv_next_request+0x168/0x178
 [<ffffffff801554bc>] cfq_kick_queue+0x0/0x89
 [<ffffffff8004d8d0>] run_workqueue+0xcd/0xfb
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

kacpid        S ffff810037fef0c0     0    24     19           127    23
(L-TLB)
 ffff81005b975e70 0000000000000046 ffff81005b96bc40 ffff81005b96bc48
0000000300000000 0000000000000001 ffff81005b969100 ffff810037fef0c0
00000004de51fab8 00000000000023cb ffff81005b9692e8 000000008002e4bc
Call Trace:
 [<ffffffff80186a34>] bind_to_cpu0+0x0/0x62
 [<ffffffff8004d8d0>] run_workqueue+0xcd/0xfb
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

cqueue/0      S ffff810037fef0c0     0   127     19           130    24
(L-TLB)
 ffff810037df3e70 0000000000000046 00000004e0693e36 0000000000000000
ffff810037fc87e0 0000000000000001 ffff810037df47a0 ffff810037fef0c0
00000004e069e550 00000000000008a5 ffff810037df4988 000000008031c800
Call Trace:
 [<ffffffff80063002>] thread_return+0x62/0xfe
 [<ffffffff8009cb11>] recalc_sigpending_and_wake+0x9/0x1a
 [<ffffffff800294aa>] do_sigaction+0x14d/0x199
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff800a05ce>] request_module+0x0/0x14d
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

khubd         S 0000000000000282     0   130     19           132   127
(L-TLB)
 ffff81005b9a3e10 0000000000000046 ffffffff8008f34a 8000018000000000
ffff81005b144800 000000000000000a ffff810037df8080 ffff81005bac70c0
00000005c414c5b0 0000000000003798 ffff810037df8268 000000005b1412a0
Call Trace:
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff801fc8d2>] hub_port_status+0x59/0xcf
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff801ff591>] hub_thread+0xa83/0xb01
 [<ffffffff800a3bc2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff801feb0e>] hub_thread+0x0/0xb01
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff800a05ce>] request_module+0x0/0x14d
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff801d0013>] klist_drivers_get+0x0/0xc
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

kseriod       S 0000000000000282     0   132     19           202   130
(L-TLB)
 ffff810037dafe90 0000000000000046 0000000000008080 ffffffff8011481b
ffffffff80351640 000000000000000a ffff810037dfb0c0 ffff810058fe2040
0000000bf55568a9 000000000001e65e ffff810037dfb2a8 00000000881cb950
Call Trace:
 [<ffffffff8011481b>] sysfs_make_dirent+0x1b/0x85
 [<ffffffff801d1120>] driver_create_file+0x31/0x39
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80213a26>] serio_thread+0x29c/0x2e7
 [<ffffffff800a3bc2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8021378a>] serio_thread+0x0/0x2e7
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff800a05ce>] request_module+0x0/0x14d
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80133566>] selinux_d_instantiate+0x0/0x14
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

khungtaskd    S ffff810005e36420     0   202     19           203   132
(L-TLB)
 ffff81005baede60 0000000000000046 ffff81005baeddd0 ffffffff8008ed60
00000004e1c15ef4 000000000000000a ffff81005bacb860 ffffffff8031cb60
0000003ca8be31a6 0000000000002e7a ffff81005bacba48 000000005bacb898
Call Trace:
 [<ffffffff8008ed60>] __activate_task+0x56/0x6d
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8006389f>] schedule_timeout+0x8a/0xad
 [<ffffffff8009a92b>] process_timeout+0x0/0x5
 [<ffffffff800be421>] watchdog+0x4b/0x1a3
 [<ffffffff800be3d6>] watchdog+0x0/0x1a3
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

pdflush       S ffff810037fc87e0     0   203     19           204   202
(L-TLB)
 ffff81005baefe70 0000000000000046 ffff81005bacb100 ffff81005be95d60
0000000000000282 0000000000000001 ffff81005bacb100 ffff810037fc87e0
00000004e1c1e550 000000000000084c ffff81005bacb2e8 000000008008e8b8
Call Trace:
 [<ffffffff8008eaf9>] task_rq_lock+0x3d/0x6f
 [<ffffffff800b2e06>] guarantee_online_cpus+0x59/0x87
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8005689a>] pdflush+0x0/0x1fb
 [<ffffffff80056987>] pdflush+0xed/0x1fb
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

pdflush       S ffff810005e36420     0   204     19           205   203
(L-TLB)
 ffff81005baf3e70 0000000000000046 0000000000000000 ffffffff8032c100
0000000000000286 000000000000000a ffff81005bacc7a0 ffffffff8031cb60
000000438fd6cfea 0000000000000895 ffff81005bacc988 0000000000000282
Call Trace:
 [<ffffffff800cd832>] wb_kupdate+0x161/0x16a
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8005689a>] pdflush+0x0/0x1fb
 [<ffffffff80056987>] pdflush+0xed/0x1fb
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

kswapd0       S ffff810037fc87e0     0   205     19           206   204
(L-TLB)
 ffff81005baf5dd0 0000000000000046 ffff81005bacc040 ffff810000014000
0000000000000282 0000000000000001 ffff81005bacc040 ffff810037fc87e0
00000004e1c367bd 0000000000000b35 ffff81005bacc228 0000000000000000
Call Trace:
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80057c42>] kswapd+0x12c/0x495
 [<ffffffff80063002>] thread_return+0x62/0xfe
 [<ffffffff800a3bc2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80057b16>] kswapd+0x0/0x495
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

aio/0         S ffff810005e36420     0   206     19           348   205
(L-TLB)
 ffff81005baf7e70 0000000000000046 00000004e1c39d2a 0000000000000000
ffff810037fc87e0 0000000000000001 ffff81005bad67e0 ffffffff8031cb60
00000004e1c78cec 0000000000000917 ffff81005bad69c8 000000008031c800
Call Trace:
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

kpsmoused     S 0000000000000282     0   348     19           365   206
(L-TLB)
 ffff81005b099e70 0000000000000046 000000059b4e55f1 0000000000000000
ffff810037fc87e0 0000000000000009 ffff81005b06c860 ffff81005b06c100
000000059b50f97d 00000000000009cd ffff81005b06ca48 000000008031c800
Call Trace:
 [<ffffffff80063002>] thread_return+0x62/0xfe
 [<ffffffff8009cb11>] recalc_sigpending_and_wake+0x9/0x1a
 [<ffffffff800294aa>] do_sigaction+0x14d/0x199
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff800a05ce>] request_module+0x0/0x14d
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

xfs_mru_cache S 0000000000000282     0   365     19           366   348
(L-TLB)
 ffff81005b39be70 0000000000000046 00000005c5c42f44 0000000000000000
ffff810037fc87e0 0000000000000007 ffff81005b0657e0 ffff81005bac7820
00000005c5c443bf 0000000000000726 ffff81005b0659c8 0000000000000000
Call Trace:
 [<ffffffff80063002>] thread_return+0x62/0xfe
 [<ffffffff8009cb11>] recalc_sigpending_and_wake+0x9/0x1a
 [<ffffffff800294aa>] do_sigaction+0x14d/0x199
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

xfslogd/0     S 0000000000000282     0   366     19           367   365
(L-TLB)
 ffff81005b39de70 0000000000000046 ffff81005b2da400 ffff81005b1b9a80
0000000300000000 000000000000000a ffff81005b065080 ffff810058b25080
0000003fec06893f 0000000000001235 ffff81005b065268 000000008002e4bc
Call Trace:
 [<ffffffff8807fa47>] :xfs:xfs_buf_iodone_work+0x0/0x6a
 [<ffffffff8004d8d0>] run_workqueue+0xcd/0xfb
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

xfsdatad/0    S ffff810005e36420     0   367     19           376   366
(L-TLB)
 ffff81005b3a1e70 0000000000000046 0000000000000000 0000000000000001
0000000300000000 000000000000000a ffff81005b068820 ffffffff8031cb60
0000003fd568cbf7 0000000000001498 ffff81005b068a08 000000008002e4bc
Call Trace:
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

ata/0         S 0000000000000282     0   376     19           377   367
(L-TLB)
 ffff81005ac03e70 0000000000000046 00000000fffb825b 00000001800638a7
0000000300000000 000000000000000a ffff81005bac7820 ffff81005b06c100
00000006122b8b9e 0000000000070d1d ffff81005bac7a08 000000008002e4bc
Call Trace:
 [<ffffffff88110856>] :libata:ata_pio_task+0x0/0xd7
 [<ffffffff8004d8d0>] run_workqueue+0xcd/0xfb
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

ata_aux       S 0000000000000282     0   377     19           380   376
(L-TLB)
 ffff81005ac05e70 0000000000000046 00000005c8415ad8 0000000000000000
ffff810037fc87e0 0000000000000003 ffff81005b0740c0 ffff81005b06c100
00000005c8417824 0000000000000288 ffff81005b0742a8 0000000000000000
Call Trace:
 [<ffffffff80063002>] thread_return+0x62/0xfe
 [<ffffffff8009cb11>] recalc_sigpending_and_wake+0x9/0x1a
 [<ffffffff800294aa>] do_sigaction+0x14d/0x199
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

scsi_eh_0     S 0000000000000282     0   380     19           381   377
(L-TLB)
 ffff81005b9d5e60 0000000000000046 ffff81005be16fc8 ffffffff8008d76f
0000000300000000 0000000000000005 ffff81005b0680c0 ffff81005b074820
00000005dabf7fba 0000000000008ca1 ffff81005b0682a8 000000008002e4bc
Call Trace:
 [<ffffffff8008d76f>] __wake_up_common+0x3e/0x68
 [<ffffffff880bf269>] :scsi_mod:__scsi_iterate_devices+0x56/0x6f
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff880c32fa>] :scsi_mod:scsi_error_handler+0x6a/0x4ce
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff880c3290>] :scsi_mod:scsi_error_handler+0x0/0x4ce
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff80015f17>] do_exit+0x925/0x931
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

scsi_eh_1     S 0000000000000282     0   381     19           382   380
(L-TLB)
 ffff81005b2cbe60 0000000000000046 ffff81005b28afc8 ffffffff8008d76f
0000000300000000 0000000000000008 ffff81005b071080 ffff81005b074820
00000005ece5556e 00000000000070e6 ffff81005b071268 000000008002e4bc
Call Trace:
 [<ffffffff8008d76f>] __wake_up_common+0x3e/0x68
 [<ffffffff880bf269>] :scsi_mod:__scsi_iterate_devices+0x56/0x6f
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff880c32fa>] :scsi_mod:scsi_error_handler+0x6a/0x4ce
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff880c3290>] :scsi_mod:scsi_error_handler+0x0/0x4ce
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

scsi_eh_2     S 0000000000000282     0   382     19           383   381
(L-TLB)
 ffff81005b2c7e60 0000000000000046 ffff81005b2cefc8 ffffffff8008d76f
0000000300000000 000000000000000a ffff81005bac70c0 ffff81005b074820
00000005ff8dbbf1 0000000000005494 ffff81005bac72a8 000000008002e4bc
Call Trace:
 [<ffffffff8008d76f>] __wake_up_common+0x3e/0x68
 [<ffffffff880bf269>] :scsi_mod:__scsi_iterate_devices+0x56/0x6f
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff880c32fa>] :scsi_mod:scsi_error_handler+0x6a/0x4ce
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff880c3290>] :scsi_mod:scsi_error_handler+0x0/0x4ce
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff80015f17>] do_exit+0x925/0x931
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

scsi_eh_3     S 0000000000000282     0   383     19           388   382
(L-TLB)
 ffff81005b3e7e60 0000000000000046 ffff81005b282fc8 ffffffff8008d76f
0000000300000000 000000000000000a ffff81005b06c100 ffff81005b074820
00000006122d75fa 0000000000004a1e ffff81005b06c2e8 000000008002e4bc
Call Trace:
 [<ffffffff8008d76f>] __wake_up_common+0x3e/0x68
 [<ffffffff880bf269>] :scsi_mod:__scsi_iterate_devices+0x56/0x6f
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff880c32fa>] :scsi_mod:scsi_error_handler+0x6a/0x4ce
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff880c3290>] :scsi_mod:scsi_error_handler+0x0/0x4ce
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

kstriped      S 0000000000000282     0   388     19           399   383
(L-TLB)
 ffff81005ac23e70 0000000000000046 00000006137fb3c8 0000000000000000
ffff810037fc87e0 0000000000000007 ffff81005bac07e0 ffff81005b06f040
00000006137fd135 00000000000006d0 ffff81005bac09c8 0000000000000000
Call Trace:
 [<ffffffff80063002>] thread_return+0x62/0xfe
 [<ffffffff8009cb11>] recalc_sigpending_and_wake+0x9/0x1a
 [<ffffffff800294aa>] do_sigaction+0x14d/0x199
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

md3_raid1     S ffff810005e36420     0   399     19           402   388
(L-TLB)
 ffff81005beb1e40 0000000000000046 ffff81005be959c8 ffff81000617bd00
0000000000000246 000000000000000a ffff810037dfb820 ffffffff8031cb60
00000040674952a4 0000000000000480 ffff810037dfba08 0000000000007000
Call Trace:
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80063833>] schedule_timeout+0x1e/0xad
 [<ffffffff8003b128>] prepare_to_wait+0x34/0x61
 [<ffffffff8022501f>] md_thread+0xc4/0x10e
 [<ffffffff800a3bc2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80224f5b>] md_thread+0x0/0x10e
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

md1_raid1     S 0000000000000282     0   402     19           405   399
(L-TLB)
 ffff81005beb7e40 0000000000000046 ffff81005be959c8 ffff81005ba9ef00
0000000000000246 000000000000000a ffff81005b074820 ffff81005a07d7e0
0000004067491c2e 00000000000006e4 ffff81005b074a08 000000008008eb43
Call Trace:
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80063833>] schedule_timeout+0x1e/0xad
 [<ffffffff8003b128>] prepare_to_wait+0x34/0x61
 [<ffffffff8022501f>] md_thread+0xc4/0x10e
 [<ffffffff800a3bc2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80224f5b>] md_thread+0x0/0x10e
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

md2_raid1     S 0000000000000282     0   405     19           406   402
(L-TLB)
 ffff81005ac45e40 0000000000000046 ffff81005be959c8 ffff81005ba9ed00
0000000000000246 000000000000000a ffff81005b2a9100 ffff81005a07d7e0
0000004066228847 000000000000090b ffff81005b2a92e8 000000008008eb43
Call Trace:
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80063833>] schedule_timeout+0x1e/0xad
 [<ffffffff8003b128>] prepare_to_wait+0x34/0x61
 [<ffffffff8022501f>] md_thread+0xc4/0x10e
 [<ffffffff800a3bc2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80224f5b>] md_thread+0x0/0x10e
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

xfsbufd       S ffff810005e36420     0   406     19           407   405
(L-TLB)
 ffff81005acf5e60 0000000000000046 0000000000000008 0000000000000001
00000000589057c0 000000000000000a ffff81005b0717e0 ffffffff8031cb60
0000004438c41ed2 000000000000029e ffff81005b0719c8 0000000000000086
Call Trace:
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8006389f>] schedule_timeout+0x8a/0xad
 [<ffffffff8009a92b>] process_timeout+0x0/0x5
 [<ffffffff8807fede>] :xfs:xfsbufd+0x4e/0xe6
 [<ffffffff8807fe90>] :xfs:xfsbufd+0x0/0xe6
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

xfsaild       S ffff810005e36420     0   407     19           408   406
(L-TLB)
 ffff81005ad6de60 0000000000000046 ffff81005ad6ddd0 ffffffff8008ed60
0000000acc805abe 000000000000000a ffff81005b2a9860 ffffffff8031cb60
0000004433f247e2 00000000000002b0 ffff81005b2a9a48 000000005b2a9898
Call Trace:
 [<ffffffff8008ed60>] __activate_task+0x56/0x6d
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8006389f>] schedule_timeout+0x8a/0xad
 [<ffffffff8009a92b>] process_timeout+0x0/0x5
 [<ffffffff880864fe>] :xfs:xfsaild+0x33/0x77
 [<ffffffff880864cb>] :xfs:xfsaild+0x0/0x77
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

xfssyncd      S ffff810005e36420     0   408     19           434   407
(L-TLB)
 ffff81005adc1e50 0000000000000046 ffff81005b1b9600 ffff81005b2da400
ffff81005b2da4a8 000000000000000a ffff810037df87e0 ffffffff8031cb60
0000004299bccd8b 00000000000007ff ffff810037df89c8 000000008806c185
Call Trace:
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8006389f>] schedule_timeout+0x8a/0xad
 [<ffffffff8009a92b>] process_timeout+0x0/0x5
 [<ffffffff88086059>] :xfs:xfssyncd+0x29/0x138
 [<ffffffff88086030>] :xfs:xfssyncd+0x0/0x138
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80133566>] selinux_d_instantiate+0x0/0x14
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

kauditd       S 0000000000000282     0   434     19           845   408
(L-TLB)
 ffff81005abafe90 0000000000000046 ffff81005ab8e7e0 ffff81005ab8e7e0
ffff81005ab8e7e0 0000000000000009 ffff81005ab8e7e0 ffff810037fc8080
0000000b6309ec99 000000000000058e ffff81005ab8e9c8 0000000080063002
Call Trace:
 [<ffffffff8002e4bc>] __wake_up+0x38/0x4f
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800b6abf>] kauditd_thread+0x146/0x17d
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff800b6979>] kauditd_thread+0x0/0x17d
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

kedac         S ffff810005e36420     0   845     19          1459   434
(L-TLB)
 ffff81005a07fe70 0000000000000046 0000000000000016 ffffffff8022f6ef
0000000000000246 000000000000000a ffff810059d800c0 ffffffff8031cb60
000000442c1795b2 000000000000046c ffff810059d802a8 0000000000000000
Call Trace:
 [<ffffffff8022f6ef>] pci_conf1_read+0xcc/0xd7
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8832ba13>] :edac_mc:edac_kernel_thread+0x0/0xfb
 [<ffffffff8006389f>] schedule_timeout+0x8a/0xad
 [<ffffffff8009a92b>] process_timeout+0x0/0x5
 [<ffffffff8832bae6>] :edac_mc:edac_kernel_thread+0xd3/0xfb
 [<ffffffff8832ba13>] :edac_mc:edac_kernel_thread+0x0/0xfb
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

kmpathd/0     S 0000000000000282     0  1459     19          1460   845
(L-TLB)
 ffff8100588bfe70 0000000000000046 0000000d1b7a2dfd 0000000000000000
ffff810037fc87e0 0000000000000003 ffff81005a5460c0 ffff81005a2d9080
0000000d1b7a449b 0000000000000461 ffff81005a5462a8 0000000000000000
Call Trace:
 [<ffffffff80063002>] thread_return+0x62/0xfe
 [<ffffffff8009cb11>] recalc_sigpending_and_wake+0x9/0x1a
 [<ffffffff800294aa>] do_sigaction+0x14d/0x199
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

kmpath_handle S 0000000000000282     0  1460     19          1834  1459
(L-TLB)
 ffff81005a58de70 0000000000000046 0000000d1b7a75b6 0000000000000000
ffff810037fc87e0 0000000000000003 ffff81005bac0080 ffff81005a2d9080
0000000d1b7a966a 00000000000002e6 ffff81005bac0268 0000000000000000
Call Trace:
 [<ffffffff80063002>] thread_return+0x62/0xfe
 [<ffffffff8009cb11>] recalc_sigpending_and_wake+0x9/0x1a
 [<ffffffff800294aa>] do_sigaction+0x14d/0x199
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

rpciod/0      S 0000000000000282     0  1834     19                1460
(L-TLB)
 ffff810056c21e70 0000000000000046 0000000eac2d4565 0000000000000000
ffff810037fc87e0 0000000000000008 ffff810059f15080 ffff810059f3d860
0000000eac2d600a 000000000000077d ffff810059f15268 0000000000000000
Call Trace:
 [<ffffffff80063002>] thread_return+0x62/0xfe
 [<ffffffff8009cb11>] recalc_sigpending_and_wake+0x9/0x1a
 [<ffffffff800294aa>] do_sigaction+0x14d/0x199
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff8004a0ea>] worker_thread+0x0/0x122
 [<ffffffff8004a1aa>] worker_thread+0xc0/0x122
 [<ffffffff8008f34a>] default_wake_function+0x0/0xe
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032c26>] kthread+0xfe/0x132
 [<ffffffff8005dfc1>] child_rip+0xa/0x11
 [<ffffffff800a39aa>] keventd_create_kthread+0x0/0xc4
 [<ffffffff80032b28>] kthread+0x0/0x132
 [<ffffffff8005dfb7>] child_rip+0x0/0x11

reboot        D ffff810037dfb820     0  2050      1                  19
(NOTLB)
 ffff81005ab37a08 0000000000000082 ffff81005ab37a58 ffff81005beb1ea0
0000000000000001 0000000000000007 ffff81005a07d7e0 ffff810037dfb820
0000004067494e24 00000000000031f6 ffff81005a07d9c8 000000008008d76f
Call Trace:
 [<ffffffff8002e4bc>] __wake_up+0x38/0x4f
 [<ffffffff80223bce>] md_write_start+0xf2/0x108
 [<ffffffff800a3bc2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff880b102c>] :raid1:make_request+0x38/0x5d8
 [<ffffffff8001c839>] generic_make_request+0x211/0x228
 [<ffffffff8002389f>] mempool_alloc+0x31/0xe7
 [<ffffffff8001a98f>] vsnprintf+0x5d7/0xb54
 [<ffffffff80033695>] submit_bio+0xe6/0xed
 [<ffffffff8807f801>] :xfs:_xfs_buf_ioapply+0x1f2/0x254
 [<ffffffff8807f89c>] :xfs:xfs_buf_iorequest+0x39/0x64
 [<ffffffff8808386c>] :xfs:xfs_bdstrat_cb+0x36/0x3a
 [<ffffffff8807c0a8>] :xfs:xfs_bwrite+0x5e/0xba
 [<ffffffff88077669>] :xfs:xfs_syncsub+0x119/0x226
 [<ffffffff88084ce2>] :xfs:xfs_fs_sync_super+0x33/0xdd
 [<ffffffff8010aa44>] quota_sync_sb+0x2e/0xf0
 [<ffffffff800e55bd>] __fsync_super+0x1b/0x9e
 [<ffffffff800e578a>] fsync_super+0x9/0x16
 [<ffffffff800e57c1>] fsync_bdev+0x2a/0x3b
 [<ffffffff8014ea59>] invalidate_partition+0x28/0x40
 [<ffffffff802225a8>] do_md_stop+0xa0/0x2ec
 [<ffffffff80224d41>] md_notify_reboot+0x5f/0x120
 [<ffffffff80067565>] notifier_call_chain+0x20/0x32
 [<ffffffff8009de98>] blocking_notifier_call_chain+0x22/0x36
 [<ffffffff8009e220>] kernel_restart_prepare+0x18/0x29
 [<ffffffff8009e280>] kernel_restart+0x9/0x46
 [<ffffffff8009e40a>] sys_reboot+0x146/0x1c7
 [<ffffffff8003b291>] hrtimer_try_to_cancel+0x4a/0x53
 [<ffffffff8005a753>] hrtimer_cancel+0xc/0x16
 [<ffffffff80063cf9>] do_nanosleep+0x47/0x70
 [<ffffffff8005a640>] hrtimer_nanosleep+0x58/0x118
 [<ffffffff800a5b84>] hrtimer_wakeup+0x0/0x22
 [<ffffffff8001e2f2>] sigprocmask+0xb7/0xdb
 [<ffffffff80054fe6>] sys_nanosleep+0x4c/0x62
 [<ffffffff8005d116>] system_call+0x7e/0x83


telnet> quit
Connection closed.
Script done on Wed 30 Jan 2013 09:13:47 PM EST



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
