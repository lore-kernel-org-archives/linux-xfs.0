Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A018D7F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 01:56:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8DB0B8F8037
	for <xfs@oss.sgi.com>; Sun, 22 Feb 2015 23:56:31 -0800 (PST)
Received: from smtprelay.restena.lu (smtprelay.restena.lu [158.64.1.62]) by
	cuda.sgi.com with ESMTP id 5DttGmX9YH58a2gb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 22 Feb 2015 23:56:24 -0800 (PST)
Date: Mon, 23 Feb 2015 08:56:21 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: XFS crashing system with general protection fault
Message-ID: <20150223085621.09cd73fc@pluto.restena.lu>
In-Reply-To: <20150210080547.730f6180@pluto.restena.lu>
References: <20141224111403.54d7226b@neptune.home>
	<20141228115127.GN24183@dastard>
	<20141229084452.615e1900@pluto.restena.lu>
	<20150113081742.6c3a5823@pluto.restena.lu>
	<20150205151007.7c954c01@pluto.restena.lu>
	<20150205221516.GT4251@dastard>
	<20150209094701.6b1d480d@pluto.restena.lu>
	<20150209212420.GU12722@dastard>
	<20150210080547.730f6180@pluto.restena.lu>
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

Yet another crash (following assertion trace see further down), hopefully with
some more useful information.



The server is always running under some memory pressure (also expressed by hpsa
having a hard time to allocate order-4 memory):
[1018038.443525] hpacucli: page allocation failure: order:4, mode:0xc0d0
[1018038.443528] CPU: 0 PID: 12482 Comm: hpacucli Not tainted 3.18.5-x86_64 #2
[1018038.443530] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[1018038.443533]  0000000000000000 ffff8800025bb978 ffffffff817b2be3 000000000000d4d4
[1018038.443535]  000000000000c0d0 ffff8800025bba08 ffffffff81104e9f 0000000000000004
[1018038.443537]  ffff8800ac2ae9e0 ffff8800025bba08 ffffffff817b0752 ffff8800025bb9d0
[1018038.443538] Call Trace:
[1018038.443544]  [<ffffffff817b2be3>] dump_stack+0x46/0x58
[1018038.443549]  [<ffffffff81104e9f>] warn_alloc_failed+0xcf/0x120
[1018038.443553]  [<ffffffff817b0752>] ? __alloc_pages_direct_compact+0x61/0x18e
[1018038.443556]  [<ffffffff811074d7>] __alloc_pages_nodemask+0x577/0x940
[1018038.443559]  [<ffffffff81107962>] alloc_kmem_pages+0x12/0x20
[1018038.443562]  [<ffffffff8111aaf3>] kmalloc_order+0x13/0x50
[1018038.443566]  [<ffffffff815740f6>] hpsa_scan_start+0x156/0x1830
[1018038.443568]  [<ffffffff81588c26>] ? sg_open+0x376/0x5b0
[1018038.443572]  [<ffffffff81150515>] ? chrdev_open+0xa5/0x1a0
[1018038.443576]  [<ffffffff811555fa>] ? generic_permission+0xda/0x1e0
[1018038.443578]  [<ffffffff81150470>] ? cdev_put+0x30/0x30
[1018038.443580]  [<ffffffff81575e7f>] hpsa_ioctl+0x1af/0xcd0
[1018038.443582]  [<ffffffff81159035>] ? do_last.isra.60+0x175/0xf60
[1018038.443584]  [<ffffffff81156d29>] ? link_path_walk+0x69/0x7e0
[1018038.443587]  [<ffffffff8113a3e6>] ? check_bytes_and_report+0x36/0x110
[1018038.443590]  [<ffffffff8113aec3>] ? check_object+0xa3/0x250
[1018038.443594]  [<ffffffff814d27aa>] scsi_ioctl+0x30a/0x410
[1018038.443596]  [<ffffffff8158982b>] sg_ioctl+0x1bb/0xc50
[1018038.443598]  [<ffffffff8115d708>] do_vfs_ioctl+0x2c8/0x4a0
[1018038.443601]  [<ffffffff8113c22f>] ? kmem_cache_free+0xef/0x120
[1018038.443602]  [<ffffffff8115a401>] ? final_putname+0x21/0x50
[1018038.443605]  [<ffffffff8114b428>] ? do_sys_open+0x198/0x220
[1018038.443607]  [<ffffffff8115d91c>] SyS_ioctl+0x3c/0x80
[1018038.443610]  [<ffffffff817bb756>] system_call_fastpath+0x16/0x1b
[1018038.443611] Mem-Info:
[1018038.443612] DMA per-cpu:
[1018038.443613] CPU    0: hi:    0, btch:   1 usd:   0
[1018038.443614] CPU    1: hi:    0, btch:   1 usd:   0
[1018038.443615] CPU    2: hi:    0, btch:   1 usd:   0
[1018038.443616] CPU    3: hi:    0, btch:   1 usd:   0
[1018038.443617] CPU    4: hi:    0, btch:   1 usd:   0
[1018038.443618] CPU    5: hi:    0, btch:   1 usd:   0
[1018038.443619] CPU    6: hi:    0, btch:   1 usd:   0
[1018038.443620] CPU    7: hi:    0, btch:   1 usd:   0
[1018038.443621] DMA32 per-cpu:
[1018038.443622] CPU    0: hi:  186, btch:  31 usd:   0
[1018038.443623] CPU    1: hi:  186, btch:  31 usd:   0
[1018038.443624] CPU    2: hi:  186, btch:  31 usd:   0
[1018038.443625] CPU    3: hi:  186, btch:  31 usd:   0
[1018038.443626] CPU    4: hi:  186, btch:  31 usd:   0
[1018038.443627] CPU    5: hi:  186, btch:  31 usd:   0
[1018038.443628] CPU    6: hi:  186, btch:  31 usd:   0
[1018038.443629] CPU    7: hi:  186, btch:  31 usd:   0
[1018038.443629] Normal per-cpu:
[1018038.443630] CPU    0: hi:  186, btch:  31 usd:   0
[1018038.443632] CPU    1: hi:  186, btch:  31 usd:   0
[1018038.443633] CPU    2: hi:  186, btch:  31 usd:   0
[1018038.443634] CPU    3: hi:  186, btch:  31 usd:   0
[1018038.443635] CPU    4: hi:  186, btch:  31 usd:   0
[1018038.443636] CPU    5: hi:  186, btch:  31 usd:   0
[1018038.443637] CPU    6: hi:  186, btch:  31 usd:   0
[1018038.443638] CPU    7: hi:  186, btch:  31 usd:   0
[1018038.443642] active_anon:175496 inactive_anon:196056 isolated_anon:0
[1018038.443642]  active_file:320293 inactive_file:1080120 isolated_file:0
[1018038.443642]  unevictable:8 dirty:3899 writeback:0 unstable:0
[1018038.443642]  free:108229 slab_reclaimable:115980 slab_unreclaimable:17333
[1018038.443642]  mapped:10797 shmem:40 pagetables:7135 bounce:0
[1018038.443642]  free_cma:0
[1018038.443647] DMA free:15836kB min:260kB low:324kB high:388kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15992kB managed:15908kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writ
eback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[1018038.443649] lowmem_reserve[]: 0 3533 8000 8000
[1018038.443655] DMA32 free:256676kB min:59584kB low:74480kB high:89376kB active_anon:340428kB inactive_anon:387756kB active_file:667068kB inactive_file:1671452kB unevictable:32kB isolated(anon):0kB isolated(file):0kB present:3643520kB managed:3630440kB mlocked:32kB dirty:7568kB writeback:0kB mapped:25180kB shmem:84kB slab_reclaimable:235772kB slab_unreclaimable:28068kB kernel_stack:1616kB 
pagetables:12260kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1018038.443656] lowmem_reserve[]: 0 0 4466 4466
[1018038.443662] Normal free:160404kB min:75316kB low:94144kB high:112972kB active_anon:361556kB inactive_anon:396468kB active_file:614104kB inactive_file:2649028kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4718588kB managed:4574088kB mlocked:0kB dirty:8028kB writeback:0kB mapped:18008kB shmem:76kB slab_reclaimable:228148kB slab_unreclaimable:41264kB kernel_stack:2336kB 
pagetables:16280kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1018038.443664] lowmem_reserve[]: 0 0 0 0
[1018038.443673] DMA: 1*4kB (U) 1*8kB (U) 1*16kB (U) 0*32kB 1*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (U) 3*4096kB (MR) = 15836kB
[1018038.443681] DMA32: 14482*4kB (UEM) 14822*8kB (UEM) 4479*16kB (UEM) 245*32kB (UEM) 17*64kB (UEM) 5*128kB (EM) 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 257736kB
[1018038.443689] Normal: 34007*4kB (UEM) 1494*8kB (UEM) 79*16kB (UEM) 65*32kB (UEM) 98*64kB (UM) 26*128kB (UM) 1*256kB (M) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 161180kB
[1018038.443690] 1431624 total pagecache pages
[1018038.443691] 31052 pages in swap cache
[1018038.443692] Swap cache stats: add 487562, delete 456510, find 302043467/302273642
[1018038.443692] Free swap  = 3038676kB
[1018038.443693] Total swap = 4192252kB
[1018038.443693] 2094525 pages RAM
[1018038.443694] 0 pages HighMem/MovableOnly
[1018038.443694] 39416 pages reserved

(above OOM complaint happened multiple times, no at each hpaccucli run but for
 some runs multiple times in a row)


The XFS trace:
[1020178.803465] XFS: Assertion failed: xfs_isiflocked(ip), file: /data/kernel/linux-git/fs/xfs/xfs_inode.c, line: 3195
[1020178.817795] ------------[ cut here ]------------
[1020178.825680] WARNING: CPU: 6 PID: 630 at /data/kernel/linux-git/fs/xfs/xfs_message.c:99 asswarn+0x2e/0x30()
[1020178.839685] Modules linked in:
[1020178.839689] CPU: 6 PID: 630 Comm: xfsaild/sda3 Not tainted 3.18.5-x86_64 #2
[1020178.839690] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[1020178.839693]  0000000000000009 ffff8802143a3c28 ffffffff817b2be3 000000000000a8a8
[1020178.839694]  0000000000000000 ffff8802143a3c68 ffffffff81088a97 ffff8802143a3c88
[1020178.839696]  ffff8801008ab400 ffff880122d89dc0 0000000000000008 ffff880213c5bb00
[1020178.839698] Call Trace:
[1020178.839705]  [<ffffffff817b2be3>] dump_stack+0x46/0x58
[1020178.839708]  [<ffffffff81088a97>] warn_slowpath_common+0x77/0xa0
[1020178.839710]  [<ffffffff81088b65>] warn_slowpath_null+0x15/0x20
[1020178.839712]  [<ffffffff812599fe>] asswarn+0x2e/0x30
[1020178.839714]  [<ffffffff812546e1>] xfs_iflush_int+0x81/0x480
[1020178.839716]  [<ffffffff81254cd3>] xfs_iflush_cluster+0x1f3/0x3c0
[1020178.839718]  [<ffffffff812584f3>] xfs_iflush+0x1e3/0x2f0
[1020178.839723]  [<ffffffff817ba747>] ? schedule_timeout+0x107/0x190
[1020178.839726]  [<ffffffff81269306>] xfs_inode_item_push+0x146/0x190
[1020178.839729]  [<ffffffff81270d29>] xfsaild+0x1d9/0x4b0
[1020178.839731]  [<ffffffff81270b50>] ? xfs_trans_ail_cursor_first+0x90/0x90
[1020178.839734]  [<ffffffff810a0a34>] kthread+0xc4/0xe0
[1020178.839737]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1020178.839739]  [<ffffffff817bb6ac>] ret_from_fork+0x7c/0xb0
[1020178.839741]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1020178.839743] ---[ end trace 8908bf05bbd238cf ]---
[1020179.700610] general protection fault: 0000 [#1] SMP 
[1020179.708213] Modules linked in:
[1020179.712243] CPU: 0 PID: 175 Comm: kworker/0:1H Tainted: G        W      3.18.5-x86_64 #2
[1020179.724201] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[1020179.734151] Workqueue: xfslogd xfs_buf_ioend_work
[1020179.740276] task: ffff880212decba0 ti: ffff880213788000 task.ti: ffff880213788000
[1020179.752158] RIP: 0010:[<ffffffff81271477>]  [<ffffffff81271477>] xfs_trans_ail_delete_bulk+0x87/0x1a0
[1020179.766094] RSP: 0018:ffff88021378bcc8  EFLAGS: 00010202
[1020179.772314] RAX: dead000000100100 RBX: ffff880213869980 RCX: ffff880213869990
[1020179.784156] RDX: 6b6b6b6b6b6b6b6b RSI: 6b6b6b6b6b6b6b6b RDI: ffff880213869980
[1020179.794234] RBP: ffff88021378bd18 R08: 0000000000000000 R09: 0000000000000bfd
[1020179.804273] R10: 0000000000001c1e R11: ffffea00006e0180 R12: ffff88001b806000
[1020179.814335] R13: ffff88021378bd38 R14: ffff880122d89dc0 R15: 0000000000000000
[1020179.826195] FS:  0000000000000000(0000) GS:ffff88021fa00000(0000) knlGS:0000000000000000
[1020179.838174] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1020179.846235] CR2: 00007fabeb28cff8 CR3: 0000000001c15000 CR4: 00000000000007f0
[1020179.856292] Stack:
[1020179.860196]  ffff88021378bd28 00000008810aeaf9 ffff880213869990 ffff88021378bd38
[1020179.870324]  ffff880213869980 0000000000000002 0000000000000002 ffff880213869980
[1020179.882184]  0000000000000000 ffff8801bd4b36e0 ffff88021378bd88 ffffffff81269614
[1020179.892310] Call Trace:
[1020179.896275]  [<ffffffff81269614>] xfs_iflush_done+0x1b4/0x1e0
[1020179.904318]  [<ffffffff810b008c>] ? put_prev_entity+0x2c/0x3b0
[1020179.912395]  [<ffffffff812675d1>] xfs_buf_do_callbacks+0x61/0x80
[1020179.922280]  [<ffffffff81267879>] xfs_buf_iodone_callbacks+0x29/0x140
[1020179.932220]  [<ffffffff81245c1b>] xfs_buf_ioend+0x9b/0xe0
[1020179.940235]  [<ffffffff81245c70>] xfs_buf_ioend_work+0x10/0x20
[1020179.948328]  [<ffffffff8109c564>] process_one_work+0x134/0x360
[1020179.956376]  [<ffffffff8109cb49>] worker_thread+0x119/0x440
[1020179.964401]  [<ffffffff8109ca30>] ? rescuer_thread+0x2a0/0x2a0
[1020179.974254]  [<ffffffff810a0a34>] kthread+0xc4/0xe0
[1020179.980395]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1020179.990359]  [<ffffffff817bb6ac>] ret_from_fork+0x7c/0xb0
[1020179.998371]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1020180.008332] Code: 1f 44 00 00 4d 8b 75 00 49 83 c5 08 41 f6 46 34 01 0f 84 9d 00 00 00 48 b8 00 01 10 00 00 00 ad de 49 8b 36 48 89 df 49 8b 56 08 <48> 89 56 08 48 89 32 4c 89 f6 49 89 06 48 b8 00 02 20 00 00 00 
[1020180.036304] RIP  [<ffffffff81271477>] xfs_trans_ail_delete_bulk+0x87/0x1a0
[1020180.046295]  RSP <ffff88021378bcc8>
[1020180.221761] ---[ end trace 8908bf05bbd238d0 ]---
[1020180.230144] BUG: unable to handle kernel paging request at ffffffffffffffd8
[1020180.240440] IP: [<ffffffff810a0efc>] kthread_data+0xc/0x20
[1020180.248467] PGD 1c16067 PUD 1c18067 PMD 0 
[1020180.254511] Oops: 0000 [#2] SMP 
[1020180.258656] Modules linked in:
[1020180.264457] CPU: 0 PID: 175 Comm: kworker/0:1H Tainted: G      D W      3.18.5-x86_64 #2
[1020180.276417] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[1020180.284579] task: ffff880212decba0 ti: ffff880213788000 task.ti: ffff880213788000
[1020180.296517] RIP: 0010:[<ffffffff810a0efc>]  [<ffffffff810a0efc>] kthread_data+0xc/0x20
[1020180.308433] RSP: 0018:ffff88021378ba50  EFLAGS: 00010092
[1020180.316420] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000f
[1020180.326483] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880212decba0
[1020180.336554] RBP: ffff88021378ba68 R08: 000000000000c000 R09: 000000000000bb23
[1020180.346618] R10: 0000000000000000 R11: ffffea00084f1a00 R12: ffff880212decfa8
[1020180.358445] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880212decba0
[1020180.368507] FS:  0000000000000000(0000) GS:ffff88021fa00000(0000) knlGS:0000000000000000
[1020180.380496] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1020180.388568] CR2: 0000000000000028 CR3: 0000000001c15000 CR4: 00000000000007f0
[1020180.398621] Stack:
[1020180.402532]  ffffffff8109cee0 ffff88021378ba68 ffff88021fa10980 ffff88021378bad8
[1020180.412656]  ffffffff817b7e53 ffff88021378ba88 ffff880212decba0 0000000000010980
[1020180.424540]  ffffffff8108946d ffff88021378bfd8 0000000000010980 ffff88021378baa8
[1020180.434650] Call Trace:
[1020180.438585]  [<ffffffff8109cee0>] ? wq_worker_sleeping+0x10/0xa0
[1020180.448461]  [<ffffffff817b7e53>] __schedule+0x393/0x5e0
[1020180.454680]  [<ffffffff8108946d>] ? release_task+0x2fd/0x3f0
[1020180.464506]  [<ffffffff817b80c4>] schedule+0x24/0x70
[1020180.470659]  [<ffffffff8108aa3a>] do_exit+0x65a/0x970
[1020180.478619]  [<ffffffff81005f29>] oops_end+0x89/0xd0
[1020180.486555]  [<ffffffff810060a6>] die+0x46/0x70
[1020180.492643]  [<ffffffff81003b0a>] do_general_protection+0xca/0x150
[1020180.502534]  [<ffffffff817bcd42>] general_protection+0x22/0x30
[1020180.510617]  [<ffffffff81271477>] ? xfs_trans_ail_delete_bulk+0x87/0x1a0
[1020180.520616]  [<ffffffff81271497>] ? xfs_trans_ail_delete_bulk+0xa7/0x1a0
[1020180.530604]  [<ffffffff81269614>] xfs_iflush_done+0x1b4/0x1e0
[1020180.538667]  [<ffffffff810b008c>] ? put_prev_entity+0x2c/0x3b0
[1020180.546738]  [<ffffffff812675d1>] xfs_buf_do_callbacks+0x61/0x80
[1020180.556625]  [<ffffffff81267879>] xfs_buf_iodone_callbacks+0x29/0x140
[1020180.566630]  [<ffffffff81245c1b>] xfs_buf_ioend+0x9b/0xe0
[1020180.574567]  [<ffffffff81245c70>] xfs_buf_ioend_work+0x10/0x20
[1020180.582643]  [<ffffffff8109c564>] process_one_work+0x134/0x360
[1020180.590716]  [<ffffffff8109cb49>] worker_thread+0x119/0x440
[1020180.598756]  [<ffffffff8109ca30>] ? rescuer_thread+0x2a0/0x2a0
[1020180.608596]  [<ffffffff810a0a34>] kthread+0xc4/0xe0
[1020180.614739]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1020180.624709]  [<ffffffff817bb6ac>] ret_from_fork+0x7c/0xb0
[1020180.632721]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1020180.642671] Code: 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 87 b0 03 00 00 55 48 89 e5 5d <48> 8b 40 d8 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 
[1020180.670633] RIP  [<ffffffff810a0efc>] kthread_data+0xc/0x20
[1020180.678649]  RSP <ffff88021378ba50>
[1020180.682790] CR2: ffffffffffffffd8
[1020180.688680] ---[ end trace 8908bf05bbd238d1 ]---
[1020180.694787] Fixing recursive fault but reboot is needed!
[1021280.341447] Clocksource tsc unstable (delta = 899898448637 ns)
[1025061.698138] INFO: rcu_sched detected stalls on CPUs/tasks: { 0 1 2 5 7} (detected by 3, t=482838 jiffies, g=32626328, c=32626327, q=3381)
[1025061.716261] Task dump for CPU 0:
[1025061.720357] kworker/0:1H    D 0000000000000046     0   175      2 0x00000000
[1025061.730423]  00000001000f000d ffff880213c68840 ffff88021378b968 ffffffff810ae624
[1025061.742300]  ffff880212decc08 ffff880212decc08 ffff88021fa109f0 0000000000000001
[1025061.752446]  ffff880212decfa8 0000000000000000 0000000000000000 ffff880212decba0
[1025061.764260] Call Trace:
[1025061.766477]  [<ffffffff810ae624>] ? update_curr+0xa4/0x100
[1025061.774495]  [<ffffffff8103945c>] ? do_page_fault+0xc/0x10
[1025061.784271]  [<ffffffff817bcd72>] ? page_fault+0x22/0x30
[1025061.790497]  [<ffffffff810a0efc>] ? kthread_data+0xc/0x20
[1025061.798505]  [<ffffffff8109cee0>] ? wq_worker_sleeping+0x10/0xa0
[1025061.808376]  [<ffffffff817b7e53>] ? __schedule+0x393/0x5e0
[1025061.816395]  [<ffffffff8108946d>] ? release_task+0x2fd/0x3f0
[1025061.824450]  [<ffffffff817b80c4>] ? schedule+0x24/0x70
[1025061.832454]  [<ffffffff8108aa3a>] ? do_exit+0x65a/0x970
[1025061.840379]  [<ffffffff81005f29>] ? oops_end+0x89/0xd0
[1025061.848341]  [<ffffffff810060a6>] ? die+0x46/0x70
[1025061.854462]  [<ffffffff81003b0a>] ? do_general_protection+0xca/0x150
[1025061.864407]  [<ffffffff817bcd42>] ? general_protection+0x22/0x30
[1025061.872522]  [<ffffffff81271477>] ? xfs_trans_ail_delete_bulk+0x87/0x1a0
[1025061.882480]  [<ffffffff81271497>] ? xfs_trans_ail_delete_bulk+0xa7/0x1a0
[1025061.892480]  [<ffffffff81269614>] ? xfs_iflush_done+0x1b4/0x1e0
[1025061.902352]  [<ffffffff810b008c>] ? put_prev_entity+0x2c/0x3b0
[1025061.910423]  [<ffffffff812675d1>] ? xfs_buf_do_callbacks+0x61/0x80
[1025061.918549]  [<ffffffff81267879>] ? xfs_buf_iodone_callbacks+0x29/0x140
[1025061.928543]  [<ffffffff81245c1b>] ? xfs_buf_ioend+0x9b/0xe0
[1025061.936555]  [<ffffffff81245c70>] ? xfs_buf_ioend_work+0x10/0x20
[1025061.946434]  [<ffffffff8109c564>] ? process_one_work+0x134/0x360
[1025061.954540]  [<ffffffff8109cb49>] ? worker_thread+0x119/0x440
[1025061.964373]  [<ffffffff8109ca30>] ? rescuer_thread+0x2a0/0x2a0
[1025061.972446]  [<ffffffff810a0a34>] ? kthread+0xc4/0xe0
[1025061.980430]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1025061.988587]  [<ffffffff817bb6ac>] ? ret_from_fork+0x7c/0xb0
[1025061.998393]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1025062.006579] Task dump for CPU 1:
[1025062.012454] nrpe            R  running task        0  2998   1612 0x00000008
[1025062.022521]  00000001002e0018 ffff880059317c30 ffffffff81106beb ffffffff81c8b248
[1025062.032619]  0000000100000141 0000000000002200 0000000100200013 ffff880059317c50
[1025062.044507]  ffffffff8113b7d8 ffff880216843010 ffff880216843030 ffffea0000af48a0
[1025062.054633] Call Trace:
[1025062.058578]  [<ffffffff81106beb>] ? get_page_from_freelist+0x32b/0x6a0
[1025062.068530]  [<ffffffff8113b7d8>] ? deactivate_slab+0x118/0x400
[1025062.076615]  [<ffffffff8113b7d8>] ? deactivate_slab+0x118/0x400
[1025062.086502]  [<ffffffff8113aec3>] ? check_object+0xa3/0x250
[1025062.094524]  [<ffffffff8113a378>] ? init_object+0x38/0x70
[1025062.102512]  [<ffffffff8109ebf9>] ? alloc_pid+0x29/0x480
[1025062.110514]  [<ffffffff8108718b>] ? copy_process.part.52+0xb7b/0x1600
[1025062.120469]  [<ffffffff810a44db>] ? task_rq_lock+0x4b/0xa0
[1025062.128484]  [<ffffffff810aa5ad>] ? sched_move_task+0x9d/0x120
[1025062.136551]  [<ffffffff810a681c>] ? set_task_cpu+0x2c/0xe0
[1025062.144576]  [<ffffffff812bb7f0>] ? cpumask_next_and+0x30/0x50
[1025062.152664]  [<ffffffff810acb7e>] ? select_task_rq_fair+0x1de/0x7d0
[1025062.162564]  [<ffffffff810ac496>] ? sched_slice.isra.61+0x46/0x90
[1025062.170681]  [<ffffffff810adf5a>] ? init_task_runnable_average+0x2a/0x60
[1025062.180678]  [<ffffffff810a89ca>] ? wake_up_new_task+0x9a/0x140
[1025062.190547]  [<ffffffff8116720d>] ? __alloc_fd+0x7d/0x120
[1025062.198541]  [<ffffffff81087e0b>] ? do_fork+0x11b/0x2b0
[1025062.206517]  [<ffffffff811672db>] ? get_unused_fd_flags+0x2b/0x30
[1025062.214654]  [<ffffffff81154495>] ? __do_pipe_flags+0x65/0xb0
[1025062.222703]  [<ffffffff811672ff>] ? __fd_install+0x1f/0x60
[1025062.230715]  [<ffffffff81088021>] ? SyS_clone+0x11/0x20
[1025062.238689]  [<ffffffff817bba39>] ? stub_clone+0x69/0x90
[1025062.246699]  [<ffffffff817bb756>] ? system_call_fastpath+0x16/0x1b
[1025062.256582] Task dump for CPU 2:
[1025062.260700] xfsaild/sda3    R  running task        0   630      2 0x00000008
[1025062.270738]  ffff8802143a3d18 ffffffff810c96c6 ffff8802143a3d88 ffff8802143a3d88
[1025062.282649]  ffffffff82807340 0000000000000282 ffff8802143a3d48 ffffffff810c9793
[1025062.292776]  ffff8802143a3d68 0000000000000282 ffff8802143a3d88 ffff8802143a3d88
[1025062.304665] Call Trace:
[1025062.308578]  [<ffffffff810c96c6>] ? lock_timer_base.isra.30+0x26/0x50
[1025062.316753]  [<ffffffff810c9793>] try_to_del_timer_sync+0x43/0x60
[1025062.326667]  [<ffffffff810c97fa>] del_timer_sync+0x4a/0x60
[1025062.334686]  [<ffffffff817ba747>] schedule_timeout+0x107/0x190
[1025062.343966]  [<ffffffff817bb28c>] ? _raw_spin_lock+0x1c/0x30
[1025062.351780]  [<ffffffff81270c6f>] xfsaild+0x11f/0x4b0
[1025062.359727]  [<ffffffff81270b50>] ? xfs_trans_ail_cursor_first+0x90/0x90
[1025062.369714]  [<ffffffff810a0a34>] kthread+0xc4/0xe0
[1025062.377657]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1025062.387590]  [<ffffffff817bb6ac>] ret_from_fork+0x7c/0xb0
[1025062.395595]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1025062.403791] Task dump for CPU 5:
[1025062.409690] swapper/5       R  running task        0     0      1 0x00200000
[1025062.419715]  ffff88021454ff18 ffffffff810d82c8 0000000000001000 0000000000001000
[1025062.429831]  ffff88021fb90980 0000000000000000 0000000000200000 0100000000000000
[1025062.441734]  ffff88021454ffd8 0000000000000000 ffff88021fb4bee0 ffffffffffffff1d
[1025062.451835] Call Trace:
[1025062.455782]  [<ffffffff810d82c8>] ? __tick_nohz_idle_enter+0xd8/0x400
[1025062.465761]  [<ffffffff810b86a2>] ? cpu_startup_entry+0x102/0x2e0
[1025062.473858]  [<ffffffff810b8685>] ? cpu_startup_entry+0xe5/0x2e0
[1025062.483723]  [<ffffffff8102cda3>] start_secondary+0x183/0x190
[1025062.491779] Task dump for CPU 7:
[1025062.497647] swapper/7       R  running task        0     0      1 0x00200000
[1025062.507703]  ffff880214557e98 ffffffff810d82c8 ffff880214557e68 00000001061abf32
[1025062.517826]  00000001061abf31 00000000145dd330 ffff880214557fd8 ffffffffffffffff
[1025062.529688]  ffff88021fbcbee0 0000000000000096 ffff880214557ea8 0000000000000096
[1025062.539813] Call Trace:
[1025062.543770]  [<ffffffff810d82c8>] ? __tick_nohz_idle_enter+0xd8/0x400
[1025062.553713]  [<ffffffff810b8685>] ? cpu_startup_entry+0xe5/0x2e0
[1025062.561817]  [<ffffffff8102cda3>] ? start_secondary+0x183/0x190
[1025062.586685] =============================================================================
[1025062.596941] BUG xfs_ili (Tainted: G      D W     ): Poison overwritten
[1025062.606904] -----------------------------------------------------------------------------
[1025062.606904] 
[1025062.620946] INFO: 0xffff880122d89df8-0xffff880122d89e53. First byte 0x0 instead of 0x6b
[1025062.632938] INFO: Slab 0xffffea00048b6240 objects=23 used=0 fp=0xffff880122d89790 flags=0x8000000000000080
[1025062.646949] INFO: Object 0xffff880122d89dc0 @offset=3520 fp=0xffff880122d89bb0
[1025062.646949] 
[1025062.660839] Bytes b4 ffff880122d89db0: b0 90 d8 22 01 88 ff ff 5a 5a 5a 5a 5a 5a 5a 5a  ..."....ZZZZZZZZ
[1025062.674834] Object ffff880122d89dc0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1025062.688799] Object ffff880122d89dd0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1025062.700991] Object ffff880122d89de0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1025062.714958] Object ffff880122d89df0: 6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 00 00 00 00  kkkkkkkk........
[1025062.728935] Object ffff880122d89e00: 60 94 26 81 ff ff ff ff 6b 6b 6b 6b 6b 6b 6b 6b  `.&.....kkkkkkkk
[1025062.742883] Object ffff880122d89e10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1025062.756849] Object ffff880122d89e20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1025062.770808] Object ffff880122d89e30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[1025062.782997] Object ffff880122d89e40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 01 00 6b 6b 6b 6b  kkkkkkkkkk..kkkk
[1025062.796976] Object ffff880122d89e50: 00 00 00 00 6b 6b 6b a5                          ....kkk.
[1025062.809043] Redzone ffff880122d89e58: bb bb bb bb bb bb bb bb                          ........
[1025062.822922] Padding ffff880122d89e68: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
[1025062.835006] CPU: 3 PID: 25139 Comm: kworker/3:2 Tainted: G    B D W      3.18.5-x86_64 #2
[1025062.847001] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
[1025062.856957] Workqueue: xfs-reclaim/sda3 xfs_reclaim_worker
[1025062.864974]  ffff880122d89dc0 ffff88011e7939a8 ffffffff817b2be3 00000000000000fc
[1025062.875094]  ffff8800da170700 ffff88011e7939e8 ffffffff8113a288 0000000000000008
[1025062.886964]  ffff880100000001 ffff880122d89e54 ffff8800da170700 000000000000006b
[1025062.897098] Call Trace:
[1025062.901052]  [<ffffffff817b2be3>] dump_stack+0x46/0x58
[1025062.908996]  [<ffffffff8113a288>] print_trailer+0x148/0x200
[1025062.917031]  [<ffffffff8113a47f>] check_bytes_and_report+0xcf/0x110
[1025062.926948]  [<ffffffff8113aff7>] check_object+0x1d7/0x250
[1025062.934963]  [<ffffffff8113b1b0>] __free_slab+0x140/0x180
[1025062.942961]  [<ffffffff8126a4d7>] ? xfs_inode_item_destroy+0x17/0x20
[1025062.951164]  [<ffffffff8113b21c>] discard_slab+0x2c/0x40
[1025062.959168]  [<ffffffff817b1a29>] __slab_free+0x297/0x2a6
[1025062.967116]  [<ffffffff810c6ec2>] ? call_rcu_sched+0x12/0x20
[1025062.976944]  [<ffffffff812c0db8>] ? __radix_tree_delete_node+0x58/0x150
[1025062.985135]  [<ffffffff8113c22f>] kmem_cache_free+0xef/0x120
[1025062.994968]  [<ffffffff8126a4d7>] xfs_inode_item_destroy+0x17/0x20
[1025063.003091]  [<ffffffff8124d009>] xfs_inode_free+0x79/0x130
[1025063.011120]  [<ffffffff8124d2cb>] xfs_reclaim_inode+0x20b/0x330
[1025063.020991]  [<ffffffff8124d647>] xfs_reclaim_inodes_ag+0x257/0x370
[1025063.029126]  [<ffffffff8124de48>] xfs_reclaim_worker+0x28/0x40
[1025063.038989]  [<ffffffff8109c564>] process_one_work+0x134/0x360
[1025063.047059]  [<ffffffff8109cb49>] worker_thread+0x119/0x440
[1025063.055105]  [<ffffffff8109ca30>] ? rescuer_thread+0x2a0/0x2a0
[1025063.063192]  [<ffffffff810a0a34>] kthread+0xc4/0xe0
[1025063.071079]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1025063.081050]  [<ffffffff817bb6ac>] ret_from_fork+0x7c/0xb0
[1025063.089063]  [<ffffffff810a0970>] ? kthread_create_on_node+0x170/0x170
[1025063.099093] FIX xfs_ili: Restoring 0xffff880122d89df8-0xffff880122d89e53=0x6b
[1025063.099093] 



Cheers,
Bruno

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
