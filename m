Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BB7977F67
	for <xfs@oss.sgi.com>; Wed, 24 Dec 2014 04:14:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9B8CC8F8033
	for <xfs@oss.sgi.com>; Wed, 24 Dec 2014 02:14:11 -0800 (PST)
Received: from hygieia.santi-shop.eu (hygieia.santi-shop.eu [78.46.175.2]) by
	cuda.sgi.com with ESMTP id dBBSQRuG7EQFzJMH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Dec 2014 02:14:09 -0800 (PST)
Date: Wed, 24 Dec 2014 11:14:03 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: XFS crashing system with general protection fault
Message-ID: <20141224111403.54d7226b@neptune.home>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

Hi,

On a server I've got the following traces, the first on Monday, the second
one today. On Monday kernel was 3.14.17 and 3.14.27 for today (both captured
via netconsole).

Is that fixed in a newer kernel?

I've xfs_repaired one of the two XFS partitions on the server though it
found nothing to complain about. The other partition, containing /, has
not been explicitly checked yet.

If there is some information I should gather before xfs_repairing, please
tell as soon as possible!


Thanks,
Bruno

[6149136.014757] general protection fault: 0000 [#1] SMP 
[6149136.022825] Modules linked in: netconsole configfs
[6149136.028996] CPU: 4 PID: 151 Comm: kworker/4:1H Not tainted 3.14.18-x86_64 #1
[6149136.040750] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[6149136.048936] Workqueue: xfslogd xfs_buf_iodone_work
[6149136.056836] task: ffff880212c67500 ti: ffff8800def3c000 task.ti: ffff8800def3c000
[6149136.067023] RIP: 0010:[<ffffffff81255b67>]  [<ffffffff81255b67>] xfs_trans_ail_delete_bulk+0x87/0x1a0
[6149136.080940] RSP: 0018:ffff8800def3dce8  EFLAGS: 00010202
[6149136.088889] RAX: dead000000100100 RBX: ffff88000211bd10 RCX: ffff88010e23fbb1
[6149136.098962] RDX: 6b6b6b6b6b6b6b6b RSI: 6b6b6b6b6b6b6b6b RDI: ffff88000211bd10
[6149136.110787] RBP: ffff8800def3dd38 R08: 6b6b6b6b6b6b6b6b R09: 2900000000000000
[6149136.120883] R10: dffa63ad34950520 R11: 0000000000000000 R12: ffff8800db0ed580
[6149136.130916] R13: ffff8800def3dd58 R14: ffff88010e23f790 R15: 0000000000000000
[6149136.140986] FS:  0000000000000000(0000) GS:ffff88021fb00000(0000) knlGS:0000000000000000
[6149136.152971] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[6149136.161053] CR2: 00007f2bba484000 CR3: 0000000001c0c000 CR4: 00000000000007e0
[6149136.172859] Stack:
[6149136.175056]  ffff88021fb119c0 0000000800000000 ffff88000211bd20 ffff8800def3dd70
[6149136.186873]  ffff88021fb0cff0 ffff88010e23fbb0 ffff88000211bd10 ffff8800def3dd78
[6149136.197004]  ffff8800def3dd48 ffff88021fb17d00 ffff8800def3dd98 ffffffff81254660
[6149136.208843] Call Trace:
[6149136.211082]  [<ffffffff81254660>] xfs_iflush_done+0x190/0x1c0
[6149136.220882]  [<ffffffff81252bfc>] xfs_buf_do_callbacks+0x3c/0x50
[6149136.229035]  [<ffffffff81252cae>] xfs_buf_iodone_callbacks+0x2e/0x110
[6149136.238947]  [<ffffffff811fc686>] xfs_buf_iodone_work+0x56/0xb0
[6149136.247044]  [<ffffffff810981f9>] process_one_work+0x149/0x3d0
[6149136.256875]  [<ffffffff81099549>] worker_thread+0x119/0x370
[6149136.264905]  [<ffffffff81099430>] ? manage_workers.isra.29+0x2a0/0x2a0
[6149136.292563]  [<ffffffff8109ee54>] kthread+0xc4/0xe0
[6149136.353067]  [<ffffffff8109ed90>] ? flush_kthread_worker+0x70/0x70
[6149136.362955]  [<ffffffff8174647c>] ret_from_fork+0x7c/0xb0
[6149136.370938]  [<ffffffff8109ed90>] ? flush_kthread_worker+0x70/0x70
[6149136.379095] Code: 1f 44 00 00 4d 8b 75 00 49 83 c5 08 41 f6 46 34 01 0f 84 9d 00 00 00 48 b8 00 01 10 00 00 00 ad de 49 8b 36 48 89 df 49 8b 56 08 <48> 89 56 08 48 89 32 4c 89 f6 49 89 06 48 b8 00 02 20 00 00 00 
[6149136.407027] RIP  [<ffffffff81255b67>] xfs_trans_ail_delete_bulk+0x87/0x1a0
[6149136.417074]  RSP <ffff8800def3dce8>
[6149136.449592] ---[ end trace b521f2cb9560abb9 ]---
[6149136.455198] BUG: unable to handle kernel paging request at ffffffffffffffd8
[6149136.461042] IP: [<ffffffff8109efdc>] kthread_data+0xc/0x20
[6149136.461049] PGD 1c0d067 PUD 1c0f067 PMD 0 
[6149136.461051] Oops: 0000 [#2] SMP 
[6149136.461052] Modules linked in: netconsole configfs
[6149136.461054] CPU: 4 PID: 151 Comm: kworker/4:1H Tainted: G      D      3.14.18-x86_64 #1
[6149136.461055] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[6149136.461064] task: ffff880212c67500 ti: ffff8800def3c000 task.ti: ffff8800def3c000
[6149136.461066] RIP: 0010:[<ffffffff8109efdc>]  [<ffffffff8109efdc>] kthread_data+0xc/0x20
[6149136.461067] RSP: 0018:ffff8800def3da50  EFLAGS: 00010092
[6149136.461067] RAX: 0000000000000000 RBX: 0000000000000004 RCX: 000000000000000f
[6149136.461068] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff880212c67500
[6149136.461069] RBP: ffff8800def3da68 R08: 0000000000000000 R09: 0000000000000000
[6149136.461069] R10: 000000000000bbfb R11: 0000000000000000 R12: ffff880212c678a0
[6149136.461070] R13: 0000000000000004 R14: 0000000000000001 R15: ffff880212c67500
[6149136.461071] FS:  0000000000000000(0000) GS:ffff88021fb00000(0000) knlGS:0000000000000000
[6149136.461072] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[6149136.461072] CR2: 0000000000000028 CR3: 0000000001c0c000 CR4: 00000000000007e0
[6149136.461073] Stack:
[6149136.461074]  ffffffff810999a0 ffff8800def3da68 ffff88021fb119c0 ffff8800def3dae8
[6149136.461075]  ffffffff8174294c ffff880212c67500 ffff880212c67500 0000000000000000
[6149136.461077]  ffff880212c67500 00000000000119c0 ffff8800def3dfd8 00000000000119c0
[6149136.461077] Call Trace:
[6149136.461081]  [<ffffffff810999a0>] ? wq_worker_sleeping+0x10/0x90
[6149136.461086]  [<ffffffff8174294c>] __schedule+0x3cc/0x5f0
[6149136.461087]  [<ffffffff81742b94>] schedule+0x24/0x70
[6149136.461091]  [<ffffffff81084dd2>] do_exit+0x642/0x950
[6149136.461094]  [<ffffffff81005f50>] oops_end+0x90/0xd0
[6149136.461095]  [<ffffffff810060d3>] die+0x53/0x80
[6149136.461097]  [<ffffffff8100383a>] do_general_protection+0xca/0x150
[6149136.461098]  [<ffffffff81746012>] general_protection+0x22/0x30
[6149136.461101]  [<ffffffff81255b67>] ? xfs_trans_ail_delete_bulk+0x87/0x1a0
[6149136.461103]  [<ffffffff81255b87>] ? xfs_trans_ail_delete_bulk+0xa7/0x1a0
[6149136.461104]  [<ffffffff81254660>] xfs_iflush_done+0x190/0x1c0
[6149136.461106]  [<ffffffff81252bfc>] xfs_buf_do_callbacks+0x3c/0x50
[6149136.461107]  [<ffffffff81252cae>] xfs_buf_iodone_callbacks+0x2e/0x110
[6149136.461110]  [<ffffffff811fc686>] xfs_buf_iodone_work+0x56/0xb0
[6149136.461112]  [<ffffffff810981f9>] process_one_work+0x149/0x3d0
[6149136.461113]  [<ffffffff81099549>] worker_thread+0x119/0x370
[6149136.461115]  [<ffffffff81099430>] ? manage_workers.isra.29+0x2a0/0x2a0
[6149136.461117]  [<ffffffff8109ee54>] kthread+0xc4/0xe0
[6149136.461118]  [<ffffffff8109ed90>] ? flush_kthread_worker+0x70/0x70
[6149136.461120]  [<ffffffff8174647c>] ret_from_fork+0x7c/0xb0
[6149136.461121]  [<ffffffff8109ed90>] ? flush_kthread_worker+0x70/0x70
[6149136.461134] Code: 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 87 48 03 00 00 55 48 89 e5 5d <48> 8b 40 d8 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 
[6149136.461135] RIP  [<ffffffff8109efdc>] kthread_data+0xc/0x20
[6149136.461135]  RSP <ffff8800def3da50>
[6149136.461136] CR2: ffffffffffffffd8
[6149136.461137] ---[ end trace b521f2cb9560abba ]---
[6149136.461137] Fixing recursive fault but reboot is needed!
...




[85339.553604] general protection fault: 0000 [#1] SMP 
[85339.561909] Modules linked in: netconsole configfs
[85339.567957] CPU: 0 PID: 423 Comm: kworker/0:1H Not tainted 3.14.27-x86_64 #2
[85339.577975] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[85339.587892] Workqueue: xfslogd xfs_buf_iodone_work
[85339.593989] task: ffff88021344e900 ti: ffff880214250000 task.ti: ffff880214250000
[85339.605848] RIP: 0010:[<ffffffff8124a437>]  [<ffffffff8124a437>] xfs_trans_ail_delete_bulk+0x87/0x1a0
[85339.617992] RSP: 0018:ffff880214251d28  EFLAGS: 00010202
[85339.625989] RAX: dead000000100100 RBX: ffff880214302390 RCX: ffff8802143023a0
[85339.635989] RDX: 6b6b6b6b6b6b6b6b RSI: 6b6b6b6b6b6b6b6b RDI: ffff880214302390
[85339.646016] RBP: ffff880214251d68 R08: ffff8801ba86b210 R09: 6b6b6b6b6b6b6b6b
[85339.657820] R10: dffb5af32ec37720 R11: 0000000000005ffc R12: ffff880039bd4e70
[85339.667857] R13: ffff880214251d88 R14: ffff8801bcaeddc0 R15: 0000000000000000
[85339.677882] FS:  0000000000000000(0000) GS:ffff88021fa00000(0000) knlGS:0000000000000000
[85339.689852] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[85339.697883] CR2: ffffffffff600400 CR3: 0000000001c0c000 CR4: 00000000000007f0
[85339.707947] Stack:
[85339.710022]  0000000800000000 ffff8802143023a0 ffff880214251da8 ffff8801ba86bf20
[85339.721870]  ffff880214302390 ffff880214251db0 ffff880214251d78 ffff88021fa17000
[85339.731956]  ffff880214251dd0 ffffffff81248df0 ffff8801ba86bf20 ffff8801bcaeddc0
[85339.742029] Call Trace:
[85339.745989]  [<ffffffff81248df0>] xfs_iflush_done+0x190/0x1c0
[85339.754010]  [<ffffffff810b170b>] ? idle_balance+0x19b/0x1b0
[85339.762021]  [<ffffffff812476b4>] xfs_buf_do_callbacks+0x34/0x50
[85339.770109]  [<ffffffff8124785a>] xfs_buf_iodone_callbacks+0x2a/0x110
[85339.780035]  [<ffffffff811f3d3e>] xfs_buf_iodone_work+0x4e/0xa0
[85339.788131]  [<ffffffff81096856>] process_one_work+0x146/0x3d0
[85339.797888]  [<ffffffff81097469>] worker_thread+0x119/0x390
[85339.805891]  [<ffffffff81097350>] ? manage_workers.isra.29+0x2a0/0x2a0
[85339.814065]  [<ffffffff8109c834>] kthread+0xc4/0xe0
[85339.821954]  [<ffffffff8109c770>] ? kthread_create_on_node+0x170/0x170
[85339.830138]  [<ffffffff817426bc>] ret_from_fork+0x7c/0xb0
[85339.838103]  [<ffffffff8109c770>] ? kthread_create_on_node+0x170/0x170
[85339.848028] Code: 1f 44 00 00 4d 8b 75 00 49 83 c5 08 41 f6 46 34 01 0f 84 9d 00 00 00 48 b8 00 01 10 00 00 00 ad de 49 8b 36 48 89 df 49 8b 56 08 <48> 89 56 08 48 89 32 4c 89 f6 49 89 06 48 b8 00 02 20 00 00 00 
[85339.875944] RIP  [<ffffffff8124a437>] xfs_trans_ail_delete_bulk+0x87/0x1a0
[85339.884164]  RSP <ffff880214251d28>
[85339.916120] ---[ end trace 31fb29ebbb6da4e3 ]---
[85339.922468] BUG: unable to handle kernel 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
