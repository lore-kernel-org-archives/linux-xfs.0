Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 158397F4E
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2015 09:15:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 98609AC005
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2015 07:15:31 -0700 (PDT)
Received: from smtprelay.restena.lu (smtprelay.restena.lu [158.64.1.62]) by
	cuda.sgi.com with ESMTP id oMn2SLSwxA0cbJyY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Mar 2015 07:15:29 -0700 (PDT)
Date: Thu, 12 Mar 2015 15:15:27 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: XFS crashing system with general protection fault
Message-ID: <20150312151527.5c043a29@pluto.restena.lu>
In-Reply-To: <20150223085621.09cd73fc@pluto.restena.lu>
References: <20141224111403.54d7226b@neptune.home>
	<20141228115127.GN24183@dastard>
	<20141229084452.615e1900@pluto.restena.lu>
	<20150113081742.6c3a5823@pluto.restena.lu>
	<20150205151007.7c954c01@pluto.restena.lu>
	<20150205221516.GT4251@dastard>
	<20150209094701.6b1d480d@pluto.restena.lu>
	<20150209212420.GU12722@dastard>
	<20150210080547.730f6180@pluto.restena.lu>
	<20150223085621.09cd73fc@pluto.restena.lu>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

Same kind of crash, but different XFS assertion quite some time earlier:

[691082.588247] XFS: Assertion failed: !xfs_isiflocked(ip), file: /data/kernel/linux-git/fs/xfs/xfs_icache.c, line: 132
[691082.603852] ------------[ cut here ]------------
[691082.609927] WARNING: CPU: 0 PID: 80 at /data/kernel/linux-git/fs/xfs/xfs_message.c:99 asswarn+0x2e/0x30()
[691082.623914] Modules linked in:
[691082.627953] CPU: 0 PID: 80 Comm: kswapd0 Not tainted 3.18.5-x86_64 #2
[691082.627953] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[691082.627954]  0000000000000009 ffff8800da0b39c8 ffffffff817b2be3 000000000000c7c7
[691082.627958]  0000000000000000 ffff8800da0b3a08 ffffffff81088a97 ffff8800da0b3a28
[691082.627959]  ffff88000f64f000 ffff88000f64f0f4 0000000000000001 ffff880212d20288
[691082.627960] Call Trace:
[691082.627964]  [<ffffffff817b2be3>] dump_stack+0x46/0x58
[691082.627967]  [<ffffffff81088a97>] warn_slowpath_common+0x77/0xa0
[691082.627968]  [<ffffffff81088b65>] warn_slowpath_null+0x15/0x20
[691082.627969]  [<ffffffff812599fe>] asswarn+0x2e/0x30
[691082.627972]  [<ffffffff8124d095>] xfs_inode_free+0x105/0x130
[691082.627974]  [<ffffffff8124d2cb>] xfs_reclaim_inode+0x20b/0x330
[691082.627976]  [<ffffffff8124d647>] xfs_reclaim_inodes_ag+0x257/0x370
[691082.627978]  [<ffffffff8124df8e>] xfs_reclaim_inodes_nr+0x2e/0x40
[691082.627980]  [<ffffffff8125ca00>] xfs_fs_free_cached_objects+0x10/0x20
[691082.627983]  [<ffffffff8114f511>] super_cache_scan+0x161/0x170
[691082.627986]  [<ffffffff8110d3e2>] shrink_slab_node+0x112/0x1b0
[691082.627988]  [<ffffffff8110ddc8>] shrink_slab+0x78/0x110
[691082.627989]  [<ffffffff81110524>] kswapd_shrink_zone+0x104/0x1a0
[691082.627990]  [<ffffffff81110fe2>] kswapd+0x412/0x740
[691082.627992]  [<ffffffff81110bd0>] ? mem_cgroup_shrink_node_zone+0xa0/0xa0
[691082.627995]  [<ffffffff810a0a34>] kthread+0xc4/0xe0
[691082.627996]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[691082.627998]  [<ffffffff817bb6ac>] ret_from_fork+0x7c/0xb0
[691082.628000]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[691082.628000] ---[ end trace 32860615a046190a ]---
...
[1174615.998106] general protection fault: 0000 [#1] SMP 
[1174616.003878] Modules linked in:
[1174616.009712] CPU: 7 PID: 150 Comm: kworker/7:1H Tainted: G        W      3.18.5-x86_64 #2
[1174616.021656] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[1174616.029843] Workqueue: xfslogd xfs_buf_ioend_work
[1174616.037743] task: ffff8800da094410 ti: ffff880212d0c000 task.ti: ffff880212d0c000
[1174616.047840] RIP: 0010:[<ffffffff81271477>]  [<ffffffff81271477>] xfs_trans_ail_delete_bulk+0x87/0x1a0
[1174616.061787] RSP: 0018:ffff880212d0fcc8  EFLAGS: 00010202
[1174616.069774] RAX: dead000000100100 RBX: ffff8800da0ad1c8 RCX: ffff8800da0ad1d8
[1174616.079853] RDX: 6b6b6b6b6b6b6b6b RSI: 6b6b6b6b6b6b6b6b RDI: ffff8800da0ad1c8
[1174616.091660] RBP: ffff880212d0fd18 R08: 0000000000000000 R09: 0000000000000000
[1174616.101731] R10: ffff8801b6953920 R11: 0000000000000246 R12: ffff88017b911dc0
[1174616.111797] R13: ffff880212d0fd38 R14: ffff8801187242c0 R15: 0000000000000000
[1174616.121868] FS:  0000000000000000(0000) GS:ffff88021fbc0000(0000) knlGS:0000000000000000
[1174616.133877] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1174616.141940] CR2: ffffffffff600400 CR3: 0000000001c15000 CR4: 00000000000007e0
[1174616.153753] Stack:
[1174616.155886]  ffff880212d0fd28 00000008810aeaf9 ffff8800da0ad1d8 ffff880212d0fd38
[1174616.167781]  ffff8800da0ad1d8 0000000000000002 0000000000000002 ffff8800da0ad1c8
[1174616.177889]  0000000000000000 ffff880085fac370 ffff880212d0fd88 ffffffff81269614
[1174616.189731] Call Trace:
[1174616.191957]  [<ffffffff81269614>] xfs_iflush_done+0x1b4/0x1e0
[1174616.201870]  [<ffffffff810b008c>] ? put_prev_entity+0x2c/0x3b0
[1174616.209851]  [<ffffffff812675d1>] xfs_buf_do_callbacks+0x61/0x80
[1174616.217967]  [<ffffffff81267879>] xfs_buf_iodone_callbacks+0x29/0x140
[1174616.227939]  [<ffffffff81245c1b>] xfs_buf_ioend+0x9b/0xe0
[1174616.235912]  [<ffffffff81245c70>] xfs_buf_ioend_work+0x10/0x20
[1174616.245743]  [<ffffffff8109c564>] process_one_work+0x134/0x360
[1174616.253842]  [<ffffffff8109cb49>] worker_thread+0x119/0x440
[1174616.261864]  [<ffffffff8109ca30>] ? rescuer_thread+0x2a0/0x2a0
[1174616.269954]  [<ffffffff810a0a34>] kthread+0xc4/0xe0
[1174616.277852]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1174616.287813]  [<ffffffff817bb6ac>] ret_from_fork+0x7c/0xb0
[1174616.295865]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1174616.305776] Code: 1f 44 00 00 4d 8b 75 00 49 83 c5 08 41 f6 46 34 01 0f 84 9d 00 00 00 48 b8 00 01 10 00 00 00 ad de 49 8b 36 48 89 df 49 8b 56 08 <48> 89 56 08 48 89 32 4c 89 f6 49 89 06 48 b8 00 02 20 00 00 00 
[1174616.331988] RIP  [<ffffffff81271477>] xfs_trans_ail_delete_bulk+0x87/0x1a0
[1174616.341982]  RSP <ffff880212d0fcc8>
[1174616.519286] ---[ end trace 32860615a046190b ]---
[1174616.525298] BUG: unable to handle kernel paging request at ffffffffffffffd8
[1174616.525302] IP: [<ffffffff810a0efc>] kthread_data+0xc/0x20
[1174616.525305] PGD 1c16067 PUD 1c18067 PMD 0 
[1174616.525307] Oops: 0000 [#2] SMP 
[1174616.525308] Modules linked in:
[1174616.525309] CPU: 7 PID: 150 Comm: kworker/7:1H Tainted: G      D W      3.18.5-x86_64 #2
[1174616.525310] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[1174616.525318] task: ffff8800da094410 ti: ffff880212d0c000 task.ti: ffff880212d0c000
[1174616.525319] RIP: 0010:[<ffffffff810a0efc>]  [<ffffffff810a0efc>] kthread_data+0xc/0x20
[1174616.525321] RSP: 0018:ffff880212d0fa50  EFLAGS: 00010092
[1174616.525322] RAX: 0000000000000000 RBX: 0000000000000007 RCX: 000000000000000f
[1174616.525323] RDX: 0000000000000000 RSI: 0000000000000007 RDI: ffff8800da094410
[1174616.525323] RBP: ffff880212d0fa68 R08: 000000000000c000 R09: 000000000000bb57
[1174616.525324] R10: 0000000000000000 R11: ffffea00037c9400 R12: ffff8800da094818
[1174616.525325] R13: 0000000000000007 R14: 0000000000000000 R15: ffff8800da094410
[1174616.525326] FS:  0000000000000000(0000) GS:ffff88021fbc0000(0000) knlGS:0000000000000000
[1174616.525327] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1174616.525328] CR2: 0000000000000028 CR3: 0000000001c15000 CR4: 00000000000007e0
[1174616.525328] Stack:
[1174616.525328]  ffffffff8109cee0 ffff880212d0fa68 ffff88021fbd0980 ffff880212d0fad8
[1174616.525330]  ffffffff817b7e53 ffff880212d0fa88 ffff8800da094410 0000000000010980
[1174616.525331]  ffffffff8108946d ffff880212d0ffd8 0000000000010980 ffff880212d0faa8
[1174616.525332] Call Trace:
[1174616.525333]  [<ffffffff8109cee0>] ? wq_worker_sleeping+0x10/0xa0
[1174616.525335]  [<ffffffff817b7e53>] __schedule+0x393/0x5e0
[1174616.525338]  [<ffffffff8108946d>] ? release_task+0x2fd/0x3f0
[1174616.525341]  [<ffffffff817b80c4>] schedule+0x24/0x70
[1174616.525342]  [<ffffffff8108aa3a>] do_exit+0x65a/0x970
[1174616.525344]  [<ffffffff81005f29>] oops_end+0x89/0xd0
[1174616.525348]  [<ffffffff810060a6>] die+0x46/0x70
[1174616.525349]  [<ffffffff81003b0a>] do_general_protection+0xca/0x150
[1174616.525351]  [<ffffffff817bcd42>] general_protection+0x22/0x30
[1174616.525354]  [<ffffffff81271477>] ? xfs_trans_ail_delete_bulk+0x87/0x1a0
[1174616.525356]  [<ffffffff81271497>] ? xfs_trans_ail_delete_bulk+0xa7/0x1a0
[1174616.525357]  [<ffffffff81269614>] xfs_iflush_done+0x1b4/0x1e0
[1174616.525359]  [<ffffffff810b008c>] ? put_prev_entity+0x2c/0x3b0
[1174616.525360]  [<ffffffff812675d1>] xfs_buf_do_callbacks+0x61/0x80
[1174616.525362]  [<ffffffff81267879>] xfs_buf_iodone_callbacks+0x29/0x140
[1174616.525363]  [<ffffffff81245c1b>] xfs_buf_ioend+0x9b/0xe0
[1174616.525364]  [<ffffffff81245c70>] xfs_buf_ioend_work+0x10/0x20
[1174616.525366]  [<ffffffff8109c564>] process_one_work+0x134/0x360
[1174616.525368]  [<ffffffff8109cb49>] worker_thread+0x119/0x440
[1174616.525370]  [<ffffffff8109ca30>] ? rescuer_thread+0x2a0/0x2a0
[1174616.525371]  [<ffffffff810a0a34>] kthread+0xc4/0xe0
[1174616.525373]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1174616.525374]  [<ffffffff817bb6ac>] ret_from_fork+0x7c/0xb0
[1174616.525376]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1174616.525377] Code: 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 87 b0 03 00 00 55 48 89 e5 5d <48> 8b 40 d8 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 
[1174616.525393] RIP  [<ffffffff810a0efc>] kthread_data+0xc/0x20
[1174616.525395]  RSP <ffff880212d0fa50>
[1174616.525395] CR2: ffffffffffffffd8
[1174616.525396] ---[ end trace 32860615a046190c ]---
[1174616.525397] Fixing recursive fault but reboot is needed!
...


Cheers,
Bruno

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
