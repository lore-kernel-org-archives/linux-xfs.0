Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 871F97F55
	for <xfs@oss.sgi.com>; Sat,  4 Jul 2015 23:25:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B94D8F8037
	for <xfs@oss.sgi.com>; Sat,  4 Jul 2015 21:25:53 -0700 (PDT)
Received: from mail-vn0-f41.google.com (mail-vn0-f41.google.com
	[209.85.216.41]) by cuda.sgi.com with ESMTP id oRdsU0C1CO2dzyWZ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 04 Jul 2015 21:25:48 -0700 (PDT)
Received: by vnbg129 with SMTP id g129so13696326vnb.11
	for <xfs@oss.sgi.com>; Sat, 04 Jul 2015 21:25:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150704233802.GS7943@dastard>
References: <CADb9451tB71D3XCqcOkDxzpzbdEHqwj7XCZUpL8yg1DzYbpwBw@mail.gmail.com>
	<20150703235141.GQ7943@dastard>
	<CADb9451j0WEeL4m-fEHzrOf3ys+eSHJKNzcN9oHAOs2kDLL_kQ@mail.gmail.com>
	<20150704233802.GS7943@dastard>
Date: Sun, 5 Jul 2015 00:25:47 -0400
Message-ID: <CADb9452UYPqo_i2M=-sSwPKwqUrRSMJ4bhV10S=1k0sNCKCVfg@mail.gmail.com>
Subject: Re: Failing XFS filesystem underlying Ceph OSDs
From: Alex Gorbachev <ag@iss-integration.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8096616768619563181=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============8096616768619563181==
Content-Type: multipart/alternative; boundary=20cf302ef588ef8f88051a192ed3

--20cf302ef588ef8f88051a192ed3
Content-Type: text/plain; charset=UTF-8

Hi Dave,


> > sysctl vm.swappiness=20 (can probably be 1 as per article)
> >
> > sysctl vm.min_free_kbytes=262144
>
> That's not an explanation for what looks to be page cache radix
> tree coruption. Memory reclaim still occurs with the settings you
> have now and, well, those changes occurred back in 3.5 - some
> 3 years ago - so it's not really an explanation for a problem with a
> recent 4.1 kernel...
>
> > So far no issues, but I need to wait a week to see if anything shows up.
> > Thank you for reviewing the error codes.
>
> I expect that you'll see the problems again...
>

We have experienced the problem in various guises with kernels 3.14, 3.19,
4.1-rc2 and now 4.1, so it's not new to us, just different error stack.
Below are some other stack dumps of what manifested as the same error.

Do you think we need to look at RAM handling by this Supermicro machine
type?

Best regards,
Alex


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

 Apr 30 15:26:04 roc-4r-sca025 kernel: [1070485.999993]
 [<ffffffff817cf4b9>] schedule+0x29/0x70
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000010]
 [<ffffffffc07caee7>] _xfs_log_force+0x187/0x280 [xfs]
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000014]
 [<ffffffff810a4150>] ? try_to_wake_up+0x2a0/0x2a0
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000030]
 [<ffffffffc07cb019>] xfs_log_force+0x39/0xc0 [xfs]
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000047]
 [<ffffffffc07d6542>] xfsaild_push+0x552/0x5a0 [xfs]
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000050]
 [<ffffffff817d2264>] ? schedule_timeout+0x124/0x210
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000067]
 [<ffffffffc07d662f>] xfsaild+0x9f/0x140 [xfs]
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000083]
 [<ffffffffc07d6590>] ? xfsaild_push+0x5a0/0x5a0 [xfs]
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000086]
 [<ffffffff81095e29>] kthread+0xc9/0xe0
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000089]
 [<ffffffff81095d60>] ? flush_kthread_worker+0x90/0x90
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000093]
 [<ffffffff817d3718>] ret_from_fork+0x58/0x90
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000096]
 [<ffffffff81095d60>] ? flush_kthread_worker+0x90/0x90
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000100] INFO: task
xfsaild/sdg1:2606 blocked for more than 120 seconds.
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000113]       Not tainted
3.19.4-031904-generic #201504131440
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000125] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000140] xfsaild/sdg1    D
ffff8810102dfcd8     0  2606      2 0x00000000
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000143]  ffff8810102dfcd8
ffff8810344c2d80 ffff8810102dffd8 0000000000013e40
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000146]  ffff881033383b80
ffff8810389589d0 ffff881033491d70 ffff8810102dfcf8
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000149]  ffff8810344c3100
ffff881033491d70 ffff881032acd128 ffff88107fc75100
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000152] Call Trace:
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000155]
 [<ffffffff817cf4b9>] schedule+0x29/0x70
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000172]
 [<ffffffffc07caee7>] _xfs_log_force+0x187/0x280 [xfs]
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000175]
 [<ffffffff810a4150>] ? try_to_wake_up+0x2a0/0x2a0
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000192]
 [<ffffffffc07cb019>] xfs_log_force+0x39/0xc0 [xfs]
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000208]
 [<ffffffffc07d6542>] xfsaild_push+0x552/0x5a0 [xfs]
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000211]
 [<ffffffff817d2264>] ? schedule_timeout+0x124/0x210
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000228]
 [<ffffffffc07d662f>] xfsaild+0x9f/0x140 [xfs]
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000244]
 [<ffffffffc07d6590>] ? xfsaild_push+0x5a0/0x5a0 [xfs]
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000247]
 [<ffffffff81095e29>] kthread+0xc9/0xe0
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000251]
 [<ffffffff81095d60>] ? flush_kthread_worker+0x90/0x90
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000254]
 [<ffffffff817d3718>] ret_from_fork+0x58/0x90
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000257]
 [<ffffffff81095d60>] ? flush_kthread_worker+0x90/0x90
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000261] INFO: task
xfsaild/sdd1:2707 blocked for more than 120 seconds.
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000273]       Not tainted
3.19.4-031904-generic #201504131440
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000285] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000300] xfsaild/sdd1    D
ffff88100f813cd8     0  2707      2 0x00000000
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000303]  ffff88100f813cd8
ffff88102b1d9480 ffff88100f813fd8 0000000000013e40
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000306]  ffff881033387700
ffff881038959d70 ffff8810351a09d0 ffff88100f813cf8
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000310]  ffff88102b1d8800
ffff8810351a09d0 ffff8810329acd28 ffff88107fcb5100
Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000313] Call Trace:



Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.414753] BUG: unable to handle
kernel NULL pointer dereference at           (null)
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.414779] IP:
[<ffffffffc04be80f>] xfs_count_page_state+0x3f/0x70 [xfs]
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.414823] PGD 1013574067 PUD
100ffcb067 PMD 0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.414842] Oops: 0000 [#1] SMP
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.414856] Modules linked in:
xfs libcrc32c intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp
coretemp ipmi_ssif kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd sb_edac
edac_core joydev mei_me mei lpc_ich ioatdma ipmi_si 8250_fintek
ipmi_msghandler 8021q garp mrp stp llc wmi bonding mac_hid lp parport
mlx4_en vxlan ip6_udp_tunnel udp_tunnel hid_generic usbhid mpt2sas ahci igb
hid libahci i2c_algo_bit mlx4_core dca raid_class ptp scsi_transport_sas
pps_core arcmsr
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415068] CPU: 0 PID: 687310
Comm: ceph-osd Not tainted 4.1.0-040100rc2-generic #201505032335
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415084] Hardware name:
Supermicro X9DRD-7LN4F(-JBOD)/X9DRD-EF/X9DRD-7LN4F, BIOS 3.0a 12/05/2013
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415102] task:
ffff88100f33eeb0 ti: ffff880065cb0000 task.ti: ffff880065cb0000
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415116] RIP:
0010:[<ffffffffc04be80f>]  [<ffffffffc04be80f>]
xfs_count_page_state+0x3f/0x70 [xfs]
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415155] RSP:
0018:ffff880065cb32c8  EFLAGS: 00010286
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415165] RAX: 0000000000000000
RBX: ffff880065cb37b0 RCX: 0000000000000000
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415210] RDX: ffff880065cb32f4
RSI: ffff880065cb32f0 RDI: ffff880004000000
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415254] RBP: ffff880065cb32c8
R08: ffff880b687bf478 R09: ffff880065cb3270
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415297] R10: dead000000100100
R11: dead000000200200 R12: ffffea000ccf9840
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415341] R13: ffffea000ccf9860
R14: ffffea000ccf9840 R15: ffff880ab6ce39d0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415386] FS:
 00007ff4be95c700(0000) GS:ffff88103f200000(0000) knlGS:0000000000000000
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415432] CS:  0010 DS: 0000
ES: 0000 CR0: 0000000080050033
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415459] CR2: 0000000000000000
CR3: 000000007942d000 CR4: 00000000000407f0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415502] Stack:
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415523]  ffff880065cb3328
ffffffffc04be880 0000000000000000 ffffea000ccf9840
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415574]  ffff880065cb3498
0000000000000000 ffffea000ccf9840 ffff880065cb37b0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415626]  ffff880065cb3498
ffffea000ccf9860 ffffea000ccf9840 ffff880ab6ce3b28
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415677] Call Trace:
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415718]  [<ffffffffc04be880>]
xfs_vm_releasepage+0x40/0x120 [xfs]
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415751]  [<ffffffff8118a7d2>]
try_to_release_page+0x32/0x50
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415782]  [<ffffffff8119fe6d>]
shrink_page_list+0x69d/0x720
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415812]  [<ffffffff811a058d>]
shrink_inactive_list+0x1dd/0x5d0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415843]  [<ffffffff8119bf2d>]
? get_lru_size+0x3d/0x40
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415872]  [<ffffffff811a0fb4>]
shrink_lruvec+0x234/0x370
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415901]  [<ffffffff81198e25>]
? pagevec_lru_move_fn+0xf5/0x110
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415931]  [<ffffffff811a11db>]
shrink_zone+0xeb/0x300
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415961]  [<ffffffff811b38fd>]
? compact_zone+0x7d/0x4f0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415990]  [<ffffffff811a1864>]
shrink_zones+0x104/0x2a0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416019]  [<ffffffff811b3f6d>]
? compact_zone_order+0x5d/0x70
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416051]  [<ffffffff810f0666>]
? ktime_get+0x46/0xb0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416079]  [<ffffffff811a1ad7>]
do_try_to_free_pages+0xd7/0x160
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416110]  [<ffffffff811a1e17>]
try_to_free_pages+0xb7/0x170
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416139]  [<ffffffff8119450a>]
__alloc_pages_nodemask+0x5ba/0x9c0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416172]  [<ffffffff811db51c>]
alloc_pages_current+0x9c/0x110
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416203]  [<ffffffff811e3a8a>]
allocate_slab+0x20a/0x2e0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416232]  [<ffffffff811e3b91>]
new_slab+0x31/0x1f0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416261]  [<ffffffff817ef6a4>]
__slab_alloc+0x18e/0x2a3
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416290]  [<ffffffff816cea97>]
? __alloc_skb+0x87/0x2b0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416318]  [<ffffffff816cea67>]
? __alloc_skb+0x57/0x2b0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416348]  [<ffffffff811e8687>]
__kmalloc_node_track_caller+0xb7/0x290
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416379]  [<ffffffff816cea97>]
? __alloc_skb+0x87/0x2b0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416407]  [<ffffffff816ce5fc>]
__kmalloc_reserve.isra.57+0x3c/0xa0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416437]  [<ffffffff816cea97>]
__alloc_skb+0x87/0x2b0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416467]  [<ffffffff8172ee91>]
sk_stream_alloc_skb+0x41/0x130
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416496]  [<ffffffff8172f963>]
tcp_sendmsg+0x2d3/0xa90
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416526]  [<ffffffff8175b467>]
inet_sendmsg+0x67/0xa0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416555]  [<ffffffff816c5cb4>]
? copy_msghdr_from_user+0x154/0x1b0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416585]  [<ffffffff816c4f5d>]
sock_sendmsg+0x4d/0x60
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416613]  [<ffffffff816c61f3>]
___sys_sendmsg+0x2b3/0x2c0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416644]  [<ffffffff810fcf67>]
? futex_wait+0x1c7/0x2c0
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416673]  [<ffffffff810fd122>]
? futex_wake+0x72/0x140
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416703]  [<ffffffff81221185>]
? __fget_light+0x25/0x70
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416731]  [<ffffffff816c6c19>]
__sys_sendmsg+0x49/0x90
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416760]  [<ffffffff816c6c79>]
SyS_sendmsg+0x19/0x20
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416788]  [<ffffffff81803bb2>]
system_call_fastpath+0x16/0x75
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416816] Code: 07 48 89 e5 f6
c4 08 74 43 48 8b 7f 30 48 89 f8 eb 19 66 2e 0f 1f 84 00 00 00 00 00 c7 02
01 00 00 00 48 8b 40 08 48 39 c7 74 1f <48> 8b 08 80 e5 10 75 e9 48 8b 08
80 e5 02 74 e7 c7 06 01 00 00
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.417040] RIP
 [<ffffffffc04be80f>] xfs_count_page_state+0x3f/0x70 [xfs]
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.417094]  RSP
<ffff880065cb32c8>
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.417118] CR2: 0000000000000000
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.417402] ---[ end trace
71135a48b0dfd313 ]---
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.759401] BUG: unable to handle
kernel NULL pointer dereference at           (null)
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.759457] IP:
[<ffffffffc04be80f>] xfs_count_page_state+0x3f/0x70 [xfs]
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.759519] PGD 0
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.759543] Oops: 0000 [#2] SMP
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.759571] Modules linked in:
xfs libcrc32c intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp
coretemp ipmi_ssif kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd sb_edac
edac_core joydev mei_me mei lpc_ich ioatdma ipmi_si 8250_fintek
ipmi_msghandler 8021q garp mrp stp llc wmi bonding mac_hid lp parport
mlx4_en vxlan ip6_udp_tunnel udp_tunnel hid_generic usbhid mpt2sas ahci igb
hid libahci i2c_algo_bit mlx4_core dca raid_class ptp scsi_transport_sas
pps_core arcmsr
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.759889] CPU: 7 PID: 110 Comm:
kswapd0 Tainted: G      D         4.1.0-040100rc2-generic #201505032335
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.759939] Hardware name:
Supermicro X9DRD-7LN4F(-JBOD)/X9DRD-EF/X9DRD-7LN4F, BIOS 3.0a 12/05/2013
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.759987] task:
ffff88103712bc60 ti: ffff8810331bc000 task.ti: ffff8810331bc000
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760032] RIP:
0010:[<ffffffffc04be80f>]  [<ffffffffc04be80f>]
xfs_count_page_state+0x3f/0x70 [xfs]
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760100] RSP:
0018:ffff8810331bf818  EFLAGS: 00010282
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760127] RAX: 0000000000000000
RBX: ffffea000cd08d80 RCX: 0000000000000000
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760171] RDX: ffff8810331bf844
RSI: ffff8810331bf840 RDI: ffff880004000068
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760216] RBP: ffff8810331bf818
R08: ffff880b687bf478 R09: ffff8810331bf850
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760260] R10: ffff880b687bf518
R11: 0000000000000220 R12: ffffea000cd08d80
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760304] R13: 0000000000000000
R14: ffff880ab6ce3b28 R15: ffff880ab6ce39d0
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760348] FS:
 0000000000000000(0000) GS:ffff88103f3c0000(0000) knlGS:0000000000000000
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760394] CS:  0010 DS: 0000
ES: 0000 CR0: 0000000080050033
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760422] CR2: 0000000000000000
CR3: 0000000001e0f000 CR4: 00000000000407e0
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760466] Stack:
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760487]  ffff8810331bf878
ffffffffc04be880 ffff880ab6ce3b40 ffff880ab6ce3b28
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760539]  ffff8810331bf888
0000000000000000 ffff880b687bf478 ffffea000cd08d80
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760591]  ffff880ab6ce3b28
0000000000000000 ffff880ab6ce3b28 000000000000000b
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760643] Call Trace:
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760686]  [<ffffffffc04be880>]
xfs_vm_releasepage+0x40/0x120 [xfs]
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760720]  [<ffffffff8118a7d2>]
try_to_release_page+0x32/0x50
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760752]  [<ffffffff8119b431>]
invalidate_inode_page+0x71/0x90
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760783]  [<ffffffff8119b528>]
invalidate_mapping_pages+0xd8/0x1e0
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760815]  [<ffffffff8121ff22>]
inode_lru_isolate+0x122/0x1b0
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760846]  [<ffffffff811b54b1>]
__list_lru_walk_one.isra.6+0x81/0x150
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760877]  [<ffffffff8121fe00>]
? insert_inode_locked+0x190/0x190
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760907]  [<ffffffff8121fe00>]
? insert_inode_locked+0x190/0x190
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760938]  [<ffffffff811b566a>]
list_lru_walk_one+0x4a/0x60
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760966]  [<ffffffff81220274>]
prune_icache_sb+0x44/0x60
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760996]  [<ffffffff81207505>]
super_cache_scan+0x155/0x1a0
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761026]  [<ffffffff8119c06f>]
do_shrink_slab+0x13f/0x2c0
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761056]  [<ffffffff811a10b0>]
? shrink_lruvec+0x330/0x370
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761086]  [<ffffffff810aeb95>]
? sched_clock_cpu+0x85/0xc0
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761115]  [<ffffffff8119c358>]
shrink_slab+0xd8/0x110
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761143]  [<ffffffff811a13bf>]
shrink_zone+0x2cf/0x300
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761173]  [<ffffffff811aa500>]
? zone_statistics+0xa0/0xc0
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761203]  [<ffffffff811a16e0>]
kswapd_shrink_zone+0xe0/0x160
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761232]  [<ffffffff811a2323>]
balance_pgdat+0x2c3/0x430
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761261]  [<ffffffff811a25c3>]
kswapd+0x133/0x250
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761289]  [<ffffffff811a2490>]
? balance_pgdat+0x430/0x430
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761322]  [<ffffffff8109cdc9>]
kthread+0xc9/0xe0
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761350]  [<ffffffff8109cd00>]
? flush_kthread_worker+0x90/0x90
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761381]  [<ffffffff81803fe2>]
ret_from_fork+0x42/0x70
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761410]  [<ffffffff8109cd00>]
? flush_kthread_worker+0x90/0x90
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761439] Code: 07 48 89 e5 f6
c4 08 74 43 48 8b 7f 30 48 89 f8 eb 19 66 2e 0f 1f 84 00 00 00 00 00 c7 02
01 00 00 00 48 8b 40 08 48 39 c7 74 1f <48> 8b 08 80 e5 10 75 e9 48 8b 08
80 e5 02 74 e7 c7 06 01 00 00
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761669] RIP
 [<ffffffffc04be80f>] xfs_count_page_state+0x3f/0x70 [xfs]
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761725]  RSP
<ffff8810331bf818>
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761749] CR2: 0000000000000000
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.762039] ---[ end trace
71135a48b0dfd314 ]---

--20cf302ef588ef8f88051a192ed3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote"><div=
>Hi Dave,</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,20=
4,204);border-left-style:solid;padding-left:1ex"><span class=3D"">&gt; sysc=
tl vm.swappiness=3D20 (can probably be 1 as per article)<br>
&gt;<br>
&gt; sysctl vm.min_free_kbytes=3D262144<br>
<br>
</span>That&#39;s not an explanation for what looks to be page cache radix<=
br>
tree coruption. Memory reclaim still occurs with the settings you<br>
have now and, well, those changes occurred back in 3.5 - some<br>
3 years ago - so it&#39;s not really an explanation for a problem with a<br=
>
recent 4.1 kernel...<br>
<span class=3D""><br>
&gt; So far no issues, but I need to wait a week to see if anything shows u=
p.<br>
&gt; Thank you for reviewing the error codes.<br>
<br>
</span>I expect that you&#39;ll see the problems again...<br></blockquote><=
div><br></div><div>We have experienced the problem in various guises with k=
ernels 3.14, 3.19, 4.1-rc2 and now 4.1, so it&#39;s not new to us, just dif=
ferent error stack.=C2=A0 Below are some other stack dumps of what manifest=
ed as the same error. =C2=A0</div><div><br></div><div>Do you think we need =
to look at RAM handling by this Supermicro machine type?=C2=A0</div><div><b=
r></div><div>Best regards,</div><div>Alex</div><div>=C2=A0</div><blockquote=
 class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:=
1px;border-left-color:rgb(204,204,204);border-left-style:solid;padding-left=
:1ex">
<div class=3D""><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a></div></div><=
/blockquote><div><br></div><div>=C2=A0Apr 30 15:26:04 roc-4r-sca025 kernel:=
 [1070485.999993] =C2=A0[&lt;ffffffff817cf4b9&gt;] schedule+0x29/0x70</div>=
<div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000010] =C2=A0[&lt;ffff=
ffffc07caee7&gt;] _xfs_log_force+0x187/0x280 [xfs]</div><div>Apr 30 15:26:0=
4 roc-4r-sca025 kernel: [1070486.000014] =C2=A0[&lt;ffffffff810a4150&gt;] ?=
 try_to_wake_up+0x2a0/0x2a0</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel:=
 [1070486.000030] =C2=A0[&lt;ffffffffc07cb019&gt;] xfs_log_force+0x39/0xc0 =
[xfs]</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000047] =C2=
=A0[&lt;ffffffffc07d6542&gt;] xfsaild_push+0x552/0x5a0 [xfs]</div><div>Apr =
30 15:26:04 roc-4r-sca025 kernel: [1070486.000050] =C2=A0[&lt;ffffffff817d2=
264&gt;] ? schedule_timeout+0x124/0x210</div><div>Apr 30 15:26:04 roc-4r-sc=
a025 kernel: [1070486.000067] =C2=A0[&lt;ffffffffc07d662f&gt;] xfsaild+0x9f=
/0x140 [xfs]</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.00008=
3] =C2=A0[&lt;ffffffffc07d6590&gt;] ? xfsaild_push+0x5a0/0x5a0 [xfs]</div><=
div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000086] =C2=A0[&lt;fffff=
fff81095e29&gt;] kthread+0xc9/0xe0</div><div>Apr 30 15:26:04 roc-4r-sca025 =
kernel: [1070486.000089] =C2=A0[&lt;ffffffff81095d60&gt;] ? flush_kthread_w=
orker+0x90/0x90</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.00=
0093] =C2=A0[&lt;ffffffff817d3718&gt;] ret_from_fork+0x58/0x90</div><div>Ap=
r 30 15:26:04 roc-4r-sca025 kernel: [1070486.000096] =C2=A0[&lt;ffffffff810=
95d60&gt;] ? flush_kthread_worker+0x90/0x90</div><div>Apr 30 15:26:04 roc-4=
r-sca025 kernel: [1070486.000100] INFO: task xfsaild/sdg1:2606 blocked for =
more than 120 seconds.</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [107=
0486.000113] =C2=A0 =C2=A0 =C2=A0 Not tainted 3.19.4-031904-generic #201504=
131440</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000125] &qu=
ot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disables this =
message.</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000140] x=
fsaild/sdg1 =C2=A0 =C2=A0D ffff8810102dfcd8 =C2=A0 =C2=A0 0 =C2=A02606 =C2=
=A0 =C2=A0 =C2=A02 0x00000000</div><div>Apr 30 15:26:04 roc-4r-sca025 kerne=
l: [1070486.000143] =C2=A0ffff8810102dfcd8 ffff8810344c2d80 ffff8810102dffd=
8 0000000000013e40</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486=
.000146] =C2=A0ffff881033383b80 ffff8810389589d0 ffff881033491d70 ffff88101=
02dfcf8</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000149] =
=C2=A0ffff8810344c3100 ffff881033491d70 ffff881032acd128 ffff88107fc75100</=
div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000152] Call Trace:=
</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000155] =C2=A0[&l=
t;ffffffff817cf4b9&gt;] schedule+0x29/0x70</div><div>Apr 30 15:26:04 roc-4r=
-sca025 kernel: [1070486.000172] =C2=A0[&lt;ffffffffc07caee7&gt;] _xfs_log_=
force+0x187/0x280 [xfs]</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [10=
70486.000175] =C2=A0[&lt;ffffffff810a4150&gt;] ? try_to_wake_up+0x2a0/0x2a0=
</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000192] =C2=A0[&l=
t;ffffffffc07cb019&gt;] xfs_log_force+0x39/0xc0 [xfs]</div><div>Apr 30 15:2=
6:04 roc-4r-sca025 kernel: [1070486.000208] =C2=A0[&lt;ffffffffc07d6542&gt;=
] xfsaild_push+0x552/0x5a0 [xfs]</div><div>Apr 30 15:26:04 roc-4r-sca025 ke=
rnel: [1070486.000211] =C2=A0[&lt;ffffffff817d2264&gt;] ? schedule_timeout+=
0x124/0x210</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000228=
] =C2=A0[&lt;ffffffffc07d662f&gt;] xfsaild+0x9f/0x140 [xfs]</div><div>Apr 3=
0 15:26:04 roc-4r-sca025 kernel: [1070486.000244] =C2=A0[&lt;ffffffffc07d65=
90&gt;] ? xfsaild_push+0x5a0/0x5a0 [xfs]</div><div>Apr 30 15:26:04 roc-4r-s=
ca025 kernel: [1070486.000247] =C2=A0[&lt;ffffffff81095e29&gt;] kthread+0xc=
9/0xe0</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000251] =C2=
=A0[&lt;ffffffff81095d60&gt;] ? flush_kthread_worker+0x90/0x90</div><div>Ap=
r 30 15:26:04 roc-4r-sca025 kernel: [1070486.000254] =C2=A0[&lt;ffffffff817=
d3718&gt;] ret_from_fork+0x58/0x90</div><div>Apr 30 15:26:04 roc-4r-sca025 =
kernel: [1070486.000257] =C2=A0[&lt;ffffffff81095d60&gt;] ? flush_kthread_w=
orker+0x90/0x90</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.00=
0261] INFO: task xfsaild/sdd1:2707 blocked for more than 120 seconds.</div>=
<div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000273] =C2=A0 =C2=A0 =
=C2=A0 Not tainted 3.19.4-031904-generic #201504131440</div><div>Apr 30 15:=
26:04 roc-4r-sca025 kernel: [1070486.000285] &quot;echo 0 &gt; /proc/sys/ke=
rnel/hung_task_timeout_secs&quot; disables this message.</div><div>Apr 30 1=
5:26:04 roc-4r-sca025 kernel: [1070486.000300] xfsaild/sdd1 =C2=A0 =C2=A0D =
ffff88100f813cd8 =C2=A0 =C2=A0 0 =C2=A02707 =C2=A0 =C2=A0 =C2=A02 0x0000000=
0</div><div>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000303] =C2=A0ff=
ff88100f813cd8 ffff88102b1d9480 ffff88100f813fd8 0000000000013e40</div><div=
>Apr 30 15:26:04 roc-4r-sca025 kernel: [1070486.000306] =C2=A0ffff881033387=
700 ffff881038959d70 ffff8810351a09d0 ffff88100f813cf8</div><div>Apr 30 15:=
26:04 roc-4r-sca025 kernel: [1070486.000310] =C2=A0ffff88102b1d8800 ffff881=
0351a09d0 ffff8810329acd28 ffff88107fcb5100</div><div>Apr 30 15:26:04 roc-4=
r-sca025 kernel: [1070486.000313] Call Trace:</div><div><br></div><div><br>=
</div><div><br></div><div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [46243=
7.414753] BUG: unable to handle kernel NULL pointer dereference at =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 (null)</div><div>Jun 26 07:02:56 roc-4r-sca015 =
kernel: [462437.414779] IP: [&lt;ffffffffc04be80f&gt;] xfs_count_page_state=
+0x3f/0x70 [xfs]</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.41=
4823] PGD 1013574067 PUD 100ffcb067 PMD 0=C2=A0</div><div>Jun 26 07:02:56 r=
oc-4r-sca015 kernel: [462437.414842] Oops: 0000 [#1] SMP=C2=A0</div><div>Ju=
n 26 07:02:56 roc-4r-sca015 kernel: [462437.414856] Modules linked in: xfs =
libcrc32c intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretem=
p ipmi_ssif kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_int=
el aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd sb_edac edac_core=
 joydev mei_me mei lpc_ich ioatdma ipmi_si 8250_fintek ipmi_msghandler 8021=
q garp mrp stp llc wmi bonding mac_hid lp parport mlx4_en vxlan ip6_udp_tun=
nel udp_tunnel hid_generic usbhid mpt2sas ahci igb hid libahci i2c_algo_bit=
 mlx4_core dca raid_class ptp scsi_transport_sas pps_core arcmsr</div><div>=
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415068] CPU: 0 PID: 687310 Co=
mm: ceph-osd Not tainted 4.1.0-040100rc2-generic #201505032335</div><div>Ju=
n 26 07:02:56 roc-4r-sca015 kernel: [462437.415084] Hardware name: Supermic=
ro X9DRD-7LN4F(-JBOD)/X9DRD-EF/X9DRD-7LN4F, BIOS 3.0a 12/05/2013</div><div>=
Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415102] task: ffff88100f33eeb=
0 ti: ffff880065cb0000 task.ti: ffff880065cb0000</div><div>Jun 26 07:02:56 =
roc-4r-sca015 kernel: [462437.415116] RIP: 0010:[&lt;ffffffffc04be80f&gt;] =
=C2=A0[&lt;ffffffffc04be80f&gt;] xfs_count_page_state+0x3f/0x70 [xfs]</div>=
<div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415155] RSP: 0018:ffff88=
0065cb32c8 =C2=A0EFLAGS: 00010286</div><div>Jun 26 07:02:56 roc-4r-sca015 k=
ernel: [462437.415165] RAX: 0000000000000000 RBX: ffff880065cb37b0 RCX: 000=
0000000000000</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.41521=
0] RDX: ffff880065cb32f4 RSI: ffff880065cb32f0 RDI: ffff880004000000</div><=
div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415254] RBP: ffff880065cb=
32c8 R08: ffff880b687bf478 R09: ffff880065cb3270</div><div>Jun 26 07:02:56 =
roc-4r-sca015 kernel: [462437.415297] R10: dead000000100100 R11: dead000000=
200200 R12: ffffea000ccf9840</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel=
: [462437.415341] R13: ffffea000ccf9860 R14: ffffea000ccf9840 R15: ffff880a=
b6ce39d0</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415386] FS=
: =C2=A000007ff4be95c700(0000) GS:ffff88103f200000(0000) knlGS:000000000000=
0000</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415432] CS: =
=C2=A00010 DS: 0000 ES: 0000 CR0: 0000000080050033</div><div>Jun 26 07:02:5=
6 roc-4r-sca015 kernel: [462437.415459] CR2: 0000000000000000 CR3: 00000000=
7942d000 CR4: 00000000000407f0</div><div>Jun 26 07:02:56 roc-4r-sca015 kern=
el: [462437.415502] Stack:</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: =
[462437.415523] =C2=A0ffff880065cb3328 ffffffffc04be880 0000000000000000 ff=
ffea000ccf9840</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.4155=
74] =C2=A0ffff880065cb3498 0000000000000000 ffffea000ccf9840 ffff880065cb37=
b0</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415626] =C2=A0ff=
ff880065cb3498 ffffea000ccf9860 ffffea000ccf9840 ffff880ab6ce3b28</div><div=
>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415677] Call Trace:</div><di=
v>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415718] =C2=A0[&lt;ffffffff=
c04be880&gt;] xfs_vm_releasepage+0x40/0x120 [xfs]</div><div>Jun 26 07:02:56=
 roc-4r-sca015 kernel: [462437.415751] =C2=A0[&lt;ffffffff8118a7d2&gt;] try=
_to_release_page+0x32/0x50</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: =
[462437.415782] =C2=A0[&lt;ffffffff8119fe6d&gt;] shrink_page_list+0x69d/0x7=
20</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415812] =C2=A0[&=
lt;ffffffff811a058d&gt;] shrink_inactive_list+0x1dd/0x5d0</div><div>Jun 26 =
07:02:56 roc-4r-sca015 kernel: [462437.415843] =C2=A0[&lt;ffffffff8119bf2d&=
gt;] ? get_lru_size+0x3d/0x40</div><div>Jun 26 07:02:56 roc-4r-sca015 kerne=
l: [462437.415872] =C2=A0[&lt;ffffffff811a0fb4&gt;] shrink_lruvec+0x234/0x3=
70</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415901] =C2=A0[&=
lt;ffffffff81198e25&gt;] ? pagevec_lru_move_fn+0xf5/0x110</div><div>Jun 26 =
07:02:56 roc-4r-sca015 kernel: [462437.415931] =C2=A0[&lt;ffffffff811a11db&=
gt;] shrink_zone+0xeb/0x300</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel:=
 [462437.415961] =C2=A0[&lt;ffffffff811b38fd&gt;] ? compact_zone+0x7d/0x4f0=
</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.415990] =C2=A0[&lt=
;ffffffff811a1864&gt;] shrink_zones+0x104/0x2a0</div><div>Jun 26 07:02:56 r=
oc-4r-sca015 kernel: [462437.416019] =C2=A0[&lt;ffffffff811b3f6d&gt;] ? com=
pact_zone_order+0x5d/0x70</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [=
462437.416051] =C2=A0[&lt;ffffffff810f0666&gt;] ? ktime_get+0x46/0xb0</div>=
<div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416079] =C2=A0[&lt;fffff=
fff811a1ad7&gt;] do_try_to_free_pages+0xd7/0x160</div><div>Jun 26 07:02:56 =
roc-4r-sca015 kernel: [462437.416110] =C2=A0[&lt;ffffffff811a1e17&gt;] try_=
to_free_pages+0xb7/0x170</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [4=
62437.416139] =C2=A0[&lt;ffffffff8119450a&gt;] __alloc_pages_nodemask+0x5ba=
/0x9c0</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416172] =C2=
=A0[&lt;ffffffff811db51c&gt;] alloc_pages_current+0x9c/0x110</div><div>Jun =
26 07:02:56 roc-4r-sca015 kernel: [462437.416203] =C2=A0[&lt;ffffffff811e3a=
8a&gt;] allocate_slab+0x20a/0x2e0</div><div>Jun 26 07:02:56 roc-4r-sca015 k=
ernel: [462437.416232] =C2=A0[&lt;ffffffff811e3b91&gt;] new_slab+0x31/0x1f0=
</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416261] =C2=A0[&lt=
;ffffffff817ef6a4&gt;] __slab_alloc+0x18e/0x2a3</div><div>Jun 26 07:02:56 r=
oc-4r-sca015 kernel: [462437.416290] =C2=A0[&lt;ffffffff816cea97&gt;] ? __a=
lloc_skb+0x87/0x2b0</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437=
.416318] =C2=A0[&lt;ffffffff816cea67&gt;] ? __alloc_skb+0x57/0x2b0</div><di=
v>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416348] =C2=A0[&lt;ffffffff=
811e8687&gt;] __kmalloc_node_track_caller+0xb7/0x290</div><div>Jun 26 07:02=
:56 roc-4r-sca015 kernel: [462437.416379] =C2=A0[&lt;ffffffff816cea97&gt;] =
? __alloc_skb+0x87/0x2b0</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [4=
62437.416407] =C2=A0[&lt;ffffffff816ce5fc&gt;] __kmalloc_reserve.isra.57+0x=
3c/0xa0</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416437] =C2=
=A0[&lt;ffffffff816cea97&gt;] __alloc_skb+0x87/0x2b0</div><div>Jun 26 07:02=
:56 roc-4r-sca015 kernel: [462437.416467] =C2=A0[&lt;ffffffff8172ee91&gt;] =
sk_stream_alloc_skb+0x41/0x130</div><div>Jun 26 07:02:56 roc-4r-sca015 kern=
el: [462437.416496] =C2=A0[&lt;ffffffff8172f963&gt;] tcp_sendmsg+0x2d3/0xa9=
0</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416526] =C2=A0[&l=
t;ffffffff8175b467&gt;] inet_sendmsg+0x67/0xa0</div><div>Jun 26 07:02:56 ro=
c-4r-sca015 kernel: [462437.416555] =C2=A0[&lt;ffffffff816c5cb4&gt;] ? copy=
_msghdr_from_user+0x154/0x1b0</div><div>Jun 26 07:02:56 roc-4r-sca015 kerne=
l: [462437.416585] =C2=A0[&lt;ffffffff816c4f5d&gt;] sock_sendmsg+0x4d/0x60<=
/div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416613] =C2=A0[&lt;=
ffffffff816c61f3&gt;] ___sys_sendmsg+0x2b3/0x2c0</div><div>Jun 26 07:02:56 =
roc-4r-sca015 kernel: [462437.416644] =C2=A0[&lt;ffffffff810fcf67&gt;] ? fu=
tex_wait+0x1c7/0x2c0</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [46243=
7.416673] =C2=A0[&lt;ffffffff810fd122&gt;] ? futex_wake+0x72/0x140</div><di=
v>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416703] =C2=A0[&lt;ffffffff=
81221185&gt;] ? __fget_light+0x25/0x70</div><div>Jun 26 07:02:56 roc-4r-sca=
015 kernel: [462437.416731] =C2=A0[&lt;ffffffff816c6c19&gt;] __sys_sendmsg+=
0x49/0x90</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.416760] =
=C2=A0[&lt;ffffffff816c6c79&gt;] SyS_sendmsg+0x19/0x20</div><div>Jun 26 07:=
02:56 roc-4r-sca015 kernel: [462437.416788] =C2=A0[&lt;ffffffff81803bb2&gt;=
] system_call_fastpath+0x16/0x75</div><div>Jun 26 07:02:56 roc-4r-sca015 ke=
rnel: [462437.416816] Code: 07 48 89 e5 f6 c4 08 74 43 48 8b 7f 30 48 89 f8=
 eb 19 66 2e 0f 1f 84 00 00 00 00 00 c7 02 01 00 00 00 48 8b 40 08 48 39 c7=
 74 1f &lt;48&gt; 8b 08 80 e5 10 75 e9 48 8b 08 80 e5 02 74 e7 c7 06 01 00 =
00=C2=A0</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.417040] RI=
P =C2=A0[&lt;ffffffffc04be80f&gt;] xfs_count_page_state+0x3f/0x70 [xfs]</di=
v><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [462437.417094] =C2=A0RSP &lt;=
ffff880065cb32c8&gt;</div><div>Jun 26 07:02:56 roc-4r-sca015 kernel: [46243=
7.417118] CR2: 0000000000000000</div><div>Jun 26 07:02:56 roc-4r-sca015 ker=
nel: [462437.417402] ---[ end trace 71135a48b0dfd313 ]---</div><div>Jun 26 =
07:40:55 roc-4r-sca015 kernel: [464718.759401] BUG: unable to handle kernel=
 NULL pointer dereference at =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (null)</div=
><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.759457] IP: [&lt;ffffff=
ffc04be80f&gt;] xfs_count_page_state+0x3f/0x70 [xfs]</div><div>Jun 26 07:40=
:55 roc-4r-sca015 kernel: [464718.759519] PGD 0=C2=A0</div><div>Jun 26 07:4=
0:55 roc-4r-sca015 kernel: [464718.759543] Oops: 0000 [#2] SMP=C2=A0</div><=
div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.759571] Modules linked in=
: xfs libcrc32c intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp c=
oretemp ipmi_ssif kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aes=
ni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd sb_edac eda=
c_core joydev mei_me mei lpc_ich ioatdma ipmi_si 8250_fintek ipmi_msghandle=
r 8021q garp mrp stp llc wmi bonding mac_hid lp parport mlx4_en vxlan ip6_u=
dp_tunnel udp_tunnel hid_generic usbhid mpt2sas ahci igb hid libahci i2c_al=
go_bit mlx4_core dca raid_class ptp scsi_transport_sas pps_core arcmsr</div=
><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.759889] CPU: 7 PID: 110=
 Comm: kswapd0 Tainted: G =C2=A0 =C2=A0 =C2=A0D =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 4.1.0-040100rc2-generic #201505032335</div><div>Jun 26 07:40:55 roc-4r-sca=
015 kernel: [464718.759939] Hardware name: Supermicro X9DRD-7LN4F(-JBOD)/X9=
DRD-EF/X9DRD-7LN4F, BIOS 3.0a 12/05/2013</div><div>Jun 26 07:40:55 roc-4r-s=
ca015 kernel: [464718.759987] task: ffff88103712bc60 ti: ffff8810331bc000 t=
ask.ti: ffff8810331bc000</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [4=
64718.760032] RIP: 0010:[&lt;ffffffffc04be80f&gt;] =C2=A0[&lt;ffffffffc04be=
80f&gt;] xfs_count_page_state+0x3f/0x70 [xfs]</div><div>Jun 26 07:40:55 roc=
-4r-sca015 kernel: [464718.760100] RSP: 0018:ffff8810331bf818 =C2=A0EFLAGS:=
 00010282</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760127] R=
AX: 0000000000000000 RBX: ffffea000cd08d80 RCX: 0000000000000000</div><div>=
Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760171] RDX: ffff8810331bf844=
 RSI: ffff8810331bf840 RDI: ffff880004000068</div><div>Jun 26 07:40:55 roc-=
4r-sca015 kernel: [464718.760216] RBP: ffff8810331bf818 R08: ffff880b687bf4=
78 R09: ffff8810331bf850</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [4=
64718.760260] R10: ffff880b687bf518 R11: 0000000000000220 R12: ffffea000cd0=
8d80</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760304] R13: 0=
000000000000000 R14: ffff880ab6ce3b28 R15: ffff880ab6ce39d0</div><div>Jun 2=
6 07:40:55 roc-4r-sca015 kernel: [464718.760348] FS: =C2=A00000000000000000=
(0000) GS:ffff88103f3c0000(0000) knlGS:0000000000000000</div><div>Jun 26 07=
:40:55 roc-4r-sca015 kernel: [464718.760394] CS: =C2=A00010 DS: 0000 ES: 00=
00 CR0: 0000000080050033</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [4=
64718.760422] CR2: 0000000000000000 CR3: 0000000001e0f000 CR4: 000000000004=
07e0</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760466] Stack:=
</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760487] =C2=A0ffff=
8810331bf878 ffffffffc04be880 ffff880ab6ce3b40 ffff880ab6ce3b28</div><div>J=
un 26 07:40:55 roc-4r-sca015 kernel: [464718.760539] =C2=A0ffff8810331bf888=
 0000000000000000 ffff880b687bf478 ffffea000cd08d80</div><div>Jun 26 07:40:=
55 roc-4r-sca015 kernel: [464718.760591] =C2=A0ffff880ab6ce3b28 00000000000=
00000 ffff880ab6ce3b28 000000000000000b</div><div>Jun 26 07:40:55 roc-4r-sc=
a015 kernel: [464718.760643] Call Trace:</div><div>Jun 26 07:40:55 roc-4r-s=
ca015 kernel: [464718.760686] =C2=A0[&lt;ffffffffc04be880&gt;] xfs_vm_relea=
sepage+0x40/0x120 [xfs]</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [46=
4718.760720] =C2=A0[&lt;ffffffff8118a7d2&gt;] try_to_release_page+0x32/0x50=
</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760752] =C2=A0[&lt=
;ffffffff8119b431&gt;] invalidate_inode_page+0x71/0x90</div><div>Jun 26 07:=
40:55 roc-4r-sca015 kernel: [464718.760783] =C2=A0[&lt;ffffffff8119b528&gt;=
] invalidate_mapping_pages+0xd8/0x1e0</div><div>Jun 26 07:40:55 roc-4r-sca0=
15 kernel: [464718.760815] =C2=A0[&lt;ffffffff8121ff22&gt;] inode_lru_isola=
te+0x122/0x1b0</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.7608=
46] =C2=A0[&lt;ffffffff811b54b1&gt;] __list_lru_walk_one.isra.6+0x81/0x150<=
/div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760877] =C2=A0[&lt;=
ffffffff8121fe00&gt;] ? insert_inode_locked+0x190/0x190</div><div>Jun 26 07=
:40:55 roc-4r-sca015 kernel: [464718.760907] =C2=A0[&lt;ffffffff8121fe00&gt=
;] ? insert_inode_locked+0x190/0x190</div><div>Jun 26 07:40:55 roc-4r-sca01=
5 kernel: [464718.760938] =C2=A0[&lt;ffffffff811b566a&gt;] list_lru_walk_on=
e+0x4a/0x60</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.760966]=
 =C2=A0[&lt;ffffffff81220274&gt;] prune_icache_sb+0x44/0x60</div><div>Jun 2=
6 07:40:55 roc-4r-sca015 kernel: [464718.760996] =C2=A0[&lt;ffffffff8120750=
5&gt;] super_cache_scan+0x155/0x1a0</div><div>Jun 26 07:40:55 roc-4r-sca015=
 kernel: [464718.761026] =C2=A0[&lt;ffffffff8119c06f&gt;] do_shrink_slab+0x=
13f/0x2c0</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761056] =
=C2=A0[&lt;ffffffff811a10b0&gt;] ? shrink_lruvec+0x330/0x370</div><div>Jun =
26 07:40:55 roc-4r-sca015 kernel: [464718.761086] =C2=A0[&lt;ffffffff810aeb=
95&gt;] ? sched_clock_cpu+0x85/0xc0</div><div>Jun 26 07:40:55 roc-4r-sca015=
 kernel: [464718.761115] =C2=A0[&lt;ffffffff8119c358&gt;] shrink_slab+0xd8/=
0x110</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761143] =C2=
=A0[&lt;ffffffff811a13bf&gt;] shrink_zone+0x2cf/0x300</div><div>Jun 26 07:4=
0:55 roc-4r-sca015 kernel: [464718.761173] =C2=A0[&lt;ffffffff811aa500&gt;]=
 ? zone_statistics+0xa0/0xc0</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel=
: [464718.761203] =C2=A0[&lt;ffffffff811a16e0&gt;] kswapd_shrink_zone+0xe0/=
0x160</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761232] =C2=
=A0[&lt;ffffffff811a2323&gt;] balance_pgdat+0x2c3/0x430</div><div>Jun 26 07=
:40:55 roc-4r-sca015 kernel: [464718.761261] =C2=A0[&lt;ffffffff811a25c3&gt=
;] kswapd+0x133/0x250</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [4647=
18.761289] =C2=A0[&lt;ffffffff811a2490&gt;] ? balance_pgdat+0x430/0x430</di=
v><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761322] =C2=A0[&lt;fff=
fffff8109cdc9&gt;] kthread+0xc9/0xe0</div><div>Jun 26 07:40:55 roc-4r-sca01=
5 kernel: [464718.761350] =C2=A0[&lt;ffffffff8109cd00&gt;] ? flush_kthread_=
worker+0x90/0x90</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.76=
1381] =C2=A0[&lt;ffffffff81803fe2&gt;] ret_from_fork+0x42/0x70</div><div>Ju=
n 26 07:40:55 roc-4r-sca015 kernel: [464718.761410] =C2=A0[&lt;ffffffff8109=
cd00&gt;] ? flush_kthread_worker+0x90/0x90</div><div>Jun 26 07:40:55 roc-4r=
-sca015 kernel: [464718.761439] Code: 07 48 89 e5 f6 c4 08 74 43 48 8b 7f 3=
0 48 89 f8 eb 19 66 2e 0f 1f 84 00 00 00 00 00 c7 02 01 00 00 00 48 8b 40 0=
8 48 39 c7 74 1f &lt;48&gt; 8b 08 80 e5 10 75 e9 48 8b 08 80 e5 02 74 e7 c7=
 06 01 00 00=C2=A0</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.=
761669] RIP =C2=A0[&lt;ffffffffc04be80f&gt;] xfs_count_page_state+0x3f/0x70=
 [xfs]</div><div>Jun 26 07:40:55 roc-4r-sca015 kernel: [464718.761725] =C2=
=A0RSP &lt;ffff8810331bf818&gt;</div><div>Jun 26 07:40:55 roc-4r-sca015 ker=
nel: [464718.761749] CR2: 0000000000000000</div><div>Jun 26 07:40:55 roc-4r=
-sca015 kernel: [464718.762039] ---[ end trace 71135a48b0dfd314 ]---</div><=
/div><div><br></div><div><br></div></div><br></div></div>

--20cf302ef588ef8f88051a192ed3--


--===============8096616768619563181==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8096616768619563181==--
