Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3C5ZcVP133945 for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 00:35:38 -0500
Received: from swapon.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74BF314BA5D1
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 22:38:57 -0700 (PDT)
Received: from swapon.de (swapon.de [81.169.139.143]) by cuda.sgi.com with
	ESMTP id G6H6bgvBWtzpWQJl for <xfs@oss.sgi.com>;
	Mon, 11 Apr 2011 22:38:57 -0700 (PDT)
Received: from mail.lab.swapon.de (mail.lab.swapon.de
	[IPv6:2001:6f8:12ec:10::25])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "mail.lab.swapon.de", Issuer "Waitstate CA" (verified OK))
	by swapon.de (Postfix) with ESMTPS id 0E6968196
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 07:38:54 +0200 (CEST)
Received: from phoenix.lab.swapon.de (phoenix.lab.swapon.de
	[IPv6:2001:6f8:12ec:11::1024:0])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "phoenix.lab.swapon.de", Issuer "Waitstate CA" (verified OK))
	by mail.lab.swapon.de (Postfix) with ESMTPS id 352AE3320A3
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 07:38:53 +0200 (CEST)
Received: from phoenix.lab.swapon.de (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	by phoenix.lab.swapon.de (Postfix) with ESMTPS id C7DF6800377
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 07:38:52 +0200 (CEST)
Date: Tue, 12 Apr 2011 07:38:51 +0200
From: Friedemann Stoyan <fstoyan@swapon.de>
Subject: xfsdatad/1: page allocation failure
Message-ID: <20110412053850.GA6720@phoenix.lab.swapon.de>
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
To: xfs@oss.sgi.com

Dear XFS-Developers,

recently I copied a big file (>1TiB) over network into a
XFS-Filesystem. During this I encountered this kernel trace
from xfsdatad:

Apr 11 13:31:32 phoenix kernel: [504985.202258] xfsdatad/1: page allocation failure. order:1, mode:0x4020
Apr 11 13:31:32 phoenix kernel: [504985.202268] Pid: 334, comm: xfsdatad/1 Not tainted 2.6.32-5-amd64 #1
Apr 11 13:31:32 phoenix kernel: [504985.202272] Call Trace:
Apr 11 13:31:32 phoenix kernel: [504985.202275]  <IRQ>  [<ffffffff810ba5f2>] ? __alloc_pages_nodemask+0x592/0x5f4
Apr 11 13:31:32 phoenix kernel: [504985.202297]  [<ffffffff8128d63b>] ? tcp_v4_do_rcv+0x1bb/0x376
Apr 11 13:31:32 phoenix kernel: [504985.202305]  [<ffffffff810e6912>] ? new_slab+0x5b/0x1ca
Apr 11 13:31:32 phoenix kernel: [504985.202311]  [<ffffffff810e6c71>] ? __slab_alloc+0x1f0/0x39b
Apr 11 13:31:32 phoenix kernel: [504985.202317]  [<ffffffff8124984c>] ? __netdev_alloc_skb+0x29/0x45
Apr 11 13:31:32 phoenix kernel: [504985.202323]  [<ffffffff810e76a3>] ? __kmalloc_node_track_caller+0xbb/0x11b
Apr 11 13:31:32 phoenix kernel: [504985.202328]  [<ffffffff8124984c>] ? __netdev_alloc_skb+0x29/0x45
Apr 11 13:31:32 phoenix kernel: [504985.202333]  [<ffffffff81248879>] ? __alloc_skb+0x69/0x15a
Apr 11 13:31:32 phoenix kernel: [504985.202338]  [<ffffffff8124984c>] ? __netdev_alloc_skb+0x29/0x45
Apr 11 13:31:32 phoenix kernel: [504985.202375]  [<ffffffffa003d7c3>] ? rtl8169_rx_interrupt+0x1d8/0x416 [r8169]
Apr 11 13:31:32 phoenix kernel: [504985.202386]  [<ffffffffa00408cb>] ? rtl8169_poll+0x3b/0x1aa [r8169]
Apr 11 13:31:32 phoenix kernel: [504985.202393]  [<ffffffff8124f98f>] ? net_rx_action+0xae/0x1c9
Apr 11 13:31:32 phoenix kernel: [504985.202402]  [<ffffffff81053c9f>] ? __do_softirq+0xdd/0x1a6
Apr 11 13:31:32 phoenix kernel: [504985.202410]  [<ffffffff81011cac>] ? call_softirq+0x1c/0x30
Apr 11 13:31:32 phoenix kernel: [504985.202415]  [<ffffffff8101322b>] ? do_softirq+0x3f/0x7c
Apr 11 13:31:32 phoenix kernel: [504985.202420]  [<ffffffff81053b0f>] ? irq_exit+0x36/0x76
Apr 11 13:31:32 phoenix kernel: [504985.202424]  [<ffffffff81012922>] ? do_IRQ+0xa0/0xb6
Apr 11 13:31:32 phoenix kernel: [504985.202429]  [<ffffffff810114d3>] ? ret_from_intr+0x0/0x11
Apr 11 13:31:32 phoenix kernel: [504985.202432]  <EOI>  [<ffffffff812fc165>] ? _spin_unlock_irqrestore+0x8/0xe
Apr 11 13:31:32 phoenix kernel: [504985.202444]  [<ffffffff810ba8b5>] ? test_clear_page_writeback+0xbd/0xe8
Apr 11 13:31:32 phoenix kernel: [504985.202453]  [<ffffffff810b4276>] ? end_page_writeback+0x1c/0x3d
Apr 11 13:31:32 phoenix kernel: [504985.202460]  [<ffffffff8110e41a>] ? end_buffer_async_write+0x10a/0x13b
Apr 11 13:31:32 phoenix kernel: [504985.202516]  [<ffffffffa0167848>] ? xfs_destroy_ioend+0x33/0x7e [xfs]
Apr 11 13:31:32 phoenix kernel: [504985.202523]  [<ffffffff810618d7>] ? worker_thread+0x188/0x21d
Apr 11 13:31:32 phoenix kernel: [504985.202548]  [<ffffffffa01679e2>] ? xfs_end_bio_delalloc+0x0/0x44 [xfs]
Apr 11 13:31:32 phoenix kernel: [504985.202553]  [<ffffffff81064f02>] ? autoremove_wake_function+0x0/0x2e
Apr 11 13:31:32 phoenix kernel: [504985.202559]  [<ffffffff8106174f>] ? worker_thread+0x0/0x21d
Apr 11 13:31:32 phoenix kernel: [504985.202563]  [<ffffffff81064c35>] ? kthread+0x79/0x81
Apr 11 13:31:32 phoenix kernel: [504985.202568]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
Apr 11 13:31:32 phoenix kernel: [504985.202573]  [<ffffffff81064bbc>] ? kthread+0x0/0x81
Apr 11 13:31:32 phoenix kernel: [504985.202577]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
Apr 11 13:31:32 phoenix kernel: [504985.202580] Mem-Info:
Apr 11 13:31:32 phoenix kernel: [504985.202583] Node 0 DMA per-cpu:
Apr 11 13:31:32 phoenix kernel: [504985.202588] CPU    0: hi:    0, btch:   1 usd:   0
Apr 11 13:31:32 phoenix kernel: [504985.202592] CPU    1: hi:    0, btch:   1 usd:   0
Apr 11 13:31:32 phoenix kernel: [504985.202595] Node 0 DMA32 per-cpu:
Apr 11 13:31:32 phoenix kernel: [504985.202599] CPU    0: hi:  186, btch:  31 usd: 105
Apr 11 13:31:32 phoenix kernel: [504985.202602] CPU    1: hi:  186, btch:  31 usd:  31
Apr 11 13:31:32 phoenix kernel: [504985.202605] Node 0 Normal per-cpu:
Apr 11 13:31:32 phoenix kernel: [504985.202608] CPU    0: hi:  186, btch:  31 usd: 180
Apr 11 13:31:32 phoenix kernel: [504985.202612] CPU    1: hi:  186, btch:  31 usd:  41
Apr 11 13:31:32 phoenix kernel: [504985.202620] active_anon:8468 inactive_anon:22059 isolated_anon:0
Apr 11 13:31:32 phoenix kernel: [504985.202622]  active_file:416521 inactive_file:421496 isolated_file:0
Apr 11 13:31:32 phoenix kernel: [504985.202624]  unevictable:0 dirty:63467 writeback:38500 unstable:0
Apr 11 13:31:32 phoenix kernel: [504985.202625]  free:8455 slab_reclaimable:43821 slab_unreclaimable:11089
Apr 11 13:31:32 phoenix kernel: [504985.202627]  mapped:2171 shmem:1117 pagetables:2587 bounce:0
Apr 11 13:31:32 phoenix kernel: [504985.202631] Node 0 DMA free:15052kB min:28kB low:32kB high:40kB active_anon:0kB inactive_anon:0kB active_file:52kB inactive_file:712kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15260kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:20kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr 11 13:31:32 phoenix kernel: [504985.202648] lowmem_reserve[]: 0 3254 3759 3759
Apr 11 13:31:32 phoenix kernel: [504985.202654] Node 0 DMA32 free:17524kB min:6780kB low:8472kB high:10168kB active_anon:22372kB inactive_anon:21396kB active_file:1492664kB inactive_file:1509428kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3333024kB mlocked:0kB dirty:219156kB writeback:131692kB mapped:2076kB shmem:1168kB slab_reclaimable:154832kB slab_unreclaimable:26132kB kernel_stack:184kB pagetables:1568kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr 11 13:31:32 phoenix kernel: [504985.202671] lowmem_reserve[]: 0 0 505 505
Apr 11 13:31:32 phoenix kernel: [504985.202676] Node 0 Normal free:1244kB min:1052kB low:1312kB high:1576kB active_anon:11500kB inactive_anon:66840kB active_file:173368kB inactive_file:175844kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:517120kB mlocked:0kB dirty:34712kB writeback:22308kB mapped:6608kB shmem:3300kB slab_reclaimable:20432kB slab_unreclaimable:18216kB kernel_stack:2352kB pagetables:8780kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr 11 13:31:32 phoenix kernel: [504985.202693] lowmem_reserve[]: 0 0 0 0
Apr 11 13:31:32 phoenix kernel: [504985.202698] Node 0 DMA: 5*4kB 3*8kB 0*16kB 3*32kB 3*64kB 3*128kB 2*256kB 1*512kB 3*1024kB 3*2048kB 1*4096kB = 15052kB
Apr 11 13:31:32 phoenix kernel: [504985.202712] Node 0 DMA32: 4088*4kB 1*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 17560kB
Apr 11 13:31:32 phoenix kernel: [504985.202725] Node 0 Normal: 287*4kB 0*8kB 0*16kB 3*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1244kB
Apr 11 13:31:32 phoenix kernel: [504985.202738] 841251 total pagecache pages
Apr 11 13:31:32 phoenix kernel: [504985.202741] 2081 pages in swap cache
Apr 11 13:31:32 phoenix kernel: [504985.202744] Swap cache stats: add 3458, delete 1377, find 410/410
Apr 11 13:31:32 phoenix kernel: [504985.202747] Free swap  = 4185972kB
Apr 11 13:31:32 phoenix kernel: [504985.202750] Total swap = 4194296kB
Apr 11 13:31:32 phoenix kernel: [504985.205016] 983024 pages RAM
Apr 11 13:31:32 phoenix kernel: [504985.205016] 32340 pages reserved
Apr 11 13:31:32 phoenix kernel: [504985.205016] 853076 pages shared
Apr 11 13:31:32 phoenix kernel: [504985.205016] 101458 pages non-shared
Apr 11 13:31:32 phoenix kernel: [504985.205016] SLUB: Unable to allocate memory on node 0 (gfp=0x20)
Apr 11 13:31:32 phoenix kernel: [504985.205016]   cache: kmalloc-8192, object size: 8192, buffer size: 8192, default order: 3, min order: 1
Apr 11 13:31:32 phoenix kernel: [504985.205016]   node 0: slabs: 233, objs: 932, free: 69
Apr 11 13:31:32 phoenix kernel: [504985.276161] xfsdatad/1: page allocation failure. order:1, mode:0x4020
Apr 11 13:31:32 phoenix kernel: [504985.276169] Pid: 334, comm: xfsdatad/1 Not tainted 2.6.32-5-amd64 #1
Apr 11 13:31:32 phoenix kernel: [504985.276173] Call Trace:
Apr 11 13:31:32 phoenix kernel: [504985.276176]  <IRQ>  [<ffffffff810ba5f2>] ? __alloc_pages_nodemask+0x592/0x5f4
Apr 11 13:31:32 phoenix kernel: [504985.276200]  [<ffffffff8128d63b>] ? tcp_v4_do_rcv+0x1bb/0x376
Apr 11 13:31:32 phoenix kernel: [504985.276210]  [<ffffffff810e6912>] ? new_slab+0x5b/0x1ca
Apr 11 13:31:32 phoenix kernel: [504985.276215]  [<ffffffff810e6c71>] ? __slab_alloc+0x1f0/0x39b
Apr 11 13:31:32 phoenix kernel: [504985.276222]  [<ffffffff8124984c>] ? __netdev_alloc_skb+0x29/0x45
Apr 11 13:31:32 phoenix kernel: [504985.276228]  [<ffffffff810e76a3>] ? __kmalloc_node_track_caller+0xbb/0x11b
Apr 11 13:31:32 phoenix kernel: [504985.276232]  [<ffffffff8124984c>] ? __netdev_alloc_skb+0x29/0x45
Apr 11 13:31:32 phoenix kernel: [504985.276237]  [<ffffffff81248879>] ? __alloc_skb+0x69/0x15a
Apr 11 13:31:32 phoenix kernel: [504985.276242]  [<ffffffff8124984c>] ? __netdev_alloc_skb+0x29/0x45
Apr 11 13:31:32 phoenix kernel: [504985.276272]  [<ffffffffa003d7c3>] ? rtl8169_rx_interrupt+0x1d8/0x416 [r8169]
Apr 11 13:31:32 phoenix kernel: [504985.276281]  [<ffffffffa00408cb>] ? rtl8169_poll+0x3b/0x1aa [r8169]
Apr 11 13:31:32 phoenix kernel: [504985.276289]  [<ffffffff8106924f>] ? sched_clock_local+0x13/0x74
Apr 11 13:31:32 phoenix kernel: [504985.276298]  [<ffffffff8124f98f>] ? net_rx_action+0xae/0x1c9
Apr 11 13:31:32 phoenix kernel: [504985.276309]  [<ffffffff81053c9f>] ? __do_softirq+0xdd/0x1a6
Apr 11 13:31:32 phoenix kernel: [504985.276316]  [<ffffffff81011cac>] ? call_softirq+0x1c/0x30
Apr 11 13:31:32 phoenix kernel: [504985.276321]  [<ffffffff8101322b>] ? do_softirq+0x3f/0x7c
Apr 11 13:31:32 phoenix kernel: [504985.276326]  [<ffffffff81053b0f>] ? irq_exit+0x36/0x76
Apr 11 13:31:32 phoenix kernel: [504985.276330]  [<ffffffff81012922>] ? do_IRQ+0xa0/0xb6
Apr 11 13:31:32 phoenix kernel: [504985.276336]  [<ffffffff810114d3>] ? ret_from_intr+0x0/0x11
Apr 11 13:31:32 phoenix kernel: [504985.276339]  <EOI>  [<ffffffff8110e39e>] ? end_buffer_async_write+0x8e/0x13b
Apr 11 13:31:32 phoenix kernel: [504985.276405]  [<ffffffffa0167848>] ? xfs_destroy_ioend+0x33/0x7e [xfs]
Apr 11 13:31:32 phoenix kernel: [504985.276412]  [<ffffffff810618d7>] ? worker_thread+0x188/0x21d
Apr 11 13:31:32 phoenix kernel: [504985.276436]  [<ffffffffa01679e2>] ? xfs_end_bio_delalloc+0x0/0x44 [xfs]
Apr 11 13:31:32 phoenix kernel: [504985.276442]  [<ffffffff81064f02>] ? autoremove_wake_function+0x0/0x2e
Apr 11 13:31:32 phoenix kernel: [504985.276447]  [<ffffffff8106174f>] ? worker_thread+0x0/0x21d
Apr 11 13:31:32 phoenix kernel: [504985.276452]  [<ffffffff81064c35>] ? kthread+0x79/0x81
Apr 11 13:31:32 phoenix kernel: [504985.276457]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
Apr 11 13:31:32 phoenix kernel: [504985.276461]  [<ffffffff81064bbc>] ? kthread+0x0/0x81
Apr 11 13:31:32 phoenix kernel: [504985.276466]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
Apr 11 13:31:32 phoenix kernel: [504985.276469] Mem-Info:
Apr 11 13:31:32 phoenix kernel: [504985.276472] Node 0 DMA per-cpu:
Apr 11 13:31:32 phoenix kernel: [504985.276476] CPU    0: hi:    0, btch:   1 usd:   0
Apr 11 13:31:32 phoenix kernel: [504985.276479] CPU    1: hi:    0, btch:   1 usd:   0
Apr 11 13:31:32 phoenix kernel: [504985.276482] Node 0 DMA32 per-cpu:
Apr 11 13:31:32 phoenix kernel: [504985.276486] CPU    0: hi:  186, btch:  31 usd:  24
Apr 11 13:31:32 phoenix kernel: [504985.276490] CPU    1: hi:  186, btch:  31 usd:  34
Apr 11 13:31:32 phoenix kernel: [504985.276492] Node 0 Normal per-cpu:
Apr 11 13:31:32 phoenix kernel: [504985.276496] CPU    0: hi:  186, btch:  31 usd: 168
Apr 11 13:31:32 phoenix kernel: [504985.276499] CPU    1: hi:  186, btch:  31 usd:  41
Apr 11 13:31:32 phoenix kernel: [504985.276507] active_anon:8468 inactive_anon:22059 isolated_anon:0
Apr 11 13:31:32 phoenix kernel: [504985.276509]  active_file:416595 inactive_file:422458 isolated_file:0
Apr 11 13:31:32 phoenix kernel: [504985.276510]  unevictable:0 dirty:62172 writeback:29100 unstable:0
Apr 11 13:31:32 phoenix kernel: [504985.276512]  free:7841 slab_reclaimable:43821 slab_unreclaimable:10723
Apr 11 13:31:32 phoenix kernel: [504985.276514]  mapped:2171 shmem:1117 pagetables:2587 bounce:0
Apr 11 13:31:32 phoenix kernel: [504985.276518] Node 0 DMA free:15052kB min:28kB low:32kB high:40kB active_anon:0kB inactive_anon:0kB active_file:52kB inactive_file:712kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15260kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:20kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr 11 13:31:32 phoenix kernel: [504985.276534] lowmem_reserve[]: 0 3254 3759 3759
Apr 11 13:31:32 phoenix kernel: [504985.276540] Node 0 DMA32 free:15120kB min:6780kB low:8472kB high:10168kB active_anon:22372kB inactive_anon:21396kB active_file:1492960kB inactive_file:1513276kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3333024kB mlocked:0kB dirty:213976kB writeback:100020kB mapped:2076kB shmem:1168kB slab_reclaimable:154832kB slab_unreclaimable:24640kB kernel_stack:184kB pagetables:1568kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr 11 13:31:32 phoenix kernel: [504985.276558] lowmem_reserve[]: 0 0 505 505
Apr 11 13:31:32 phoenix kernel: [504985.276563] Node 0 Normal free:1192kB min:1052kB low:1312kB high:1576kB active_anon:11500kB inactive_anon:66840kB active_file:173368kB inactive_file:175844kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:517120kB mlocked:0kB dirty:34712kB writeback:16380kB mapped:6608kB shmem:3300kB slab_reclaimable:20432kB slab_unreclaimable:18244kB kernel_stack:2352kB pagetables:8780kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr 11 13:31:32 phoenix kernel: [504985.276579] lowmem_reserve[]: 0 0 0 0
Apr 11 13:31:32 phoenix kernel: [504985.276584] Node 0 DMA: 5*4kB 3*8kB 0*16kB 3*32kB 3*64kB 3*128kB 2*256kB 1*512kB 3*1024kB 3*2048kB 1*4096kB = 15052kB
Apr 11 13:31:32 phoenix kernel: [504985.276598] Node 0 DMA32: 3470*4kB 1*8kB 1*16kB 0*32kB 1*64kB 1*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 15120kB
Apr 11 13:31:32 phoenix kernel: [504985.276611] Node 0 Normal: 256*4kB 7*8kB 7*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1192kB
Apr 11 13:31:32 phoenix kernel: [504985.276624] 842250 total pagecache pages
Apr 11 13:31:32 phoenix kernel: [504985.276627] 2081 pages in swap cache
Apr 11 13:31:32 phoenix kernel: [504985.276630] Swap cache stats: add 3458, delete 1377, find 410/410
Apr 11 13:31:32 phoenix kernel: [504985.276633] Free swap  = 4185972kB
Apr 11 13:31:32 phoenix kernel: [504985.276635] Total swap = 4194296kB
Apr 11 13:31:32 phoenix kernel: [504985.309459] 983024 pages RAM
Apr 11 13:31:32 phoenix kernel: [504985.309459] 32340 pages reserved
Apr 11 13:31:32 phoenix kernel: [504985.309459] 853992 pages shared
Apr 11 13:31:32 phoenix kernel: [504985.309459] 101097 pages non-shared
Apr 11 13:31:32 phoenix kernel: [504985.309459] SLUB: Unable to allocate memory on node 0 (gfp=0x20)
Apr 11 13:31:32 phoenix kernel: [504985.309459]   cache: kmalloc-8192, object size: 8192, buffer size: 8192, default order: 3, min order: 1
Apr 11 13:31:32 phoenix kernel: [504985.309459]   node 0: slabs: 212, objs: 827, free: 15
Apr 11 13:31:32 phoenix kernel: [504985.337943] xfsdatad/1: page allocation failure. order:1, mode:0x4020
Apr 11 13:31:32 phoenix kernel: [504985.337952] Pid: 334, comm: xfsdatad/1 Not tainted 2.6.32-5-amd64 #1
Apr 11 13:31:32 phoenix kernel: [504985.337955] Call Trace:
Apr 11 13:31:32 phoenix kernel: [504985.337958]  <IRQ>  [<ffffffff810ba5f2>] ? __alloc_pages_nodemask+0x592/0x5f4
Apr 11 13:31:32 phoenix kernel: [504985.337982]  [<ffffffff8128d63b>] ? tcp_v4_do_rcv+0x1bb/0x376
Apr 11 13:31:32 phoenix kernel: [504985.337989]  [<ffffffff810e6912>] ? new_slab+0x5b/0x1ca
Apr 11 13:31:32 phoenix kernel: [504985.337995]  [<ffffffff810e6c71>] ? __slab_alloc+0x1f0/0x39b
Apr 11 13:31:32 phoenix kernel: [504985.338001]  [<ffffffff8124984c>] ? __netdev_alloc_skb+0x29/0x45
Apr 11 13:31:32 phoenix kernel: [504985.338007]  [<ffffffff810e76a3>] ? __kmalloc_node_track_caller+0xbb/0x11b
Apr 11 13:31:32 phoenix kernel: [504985.338011]  [<ffffffff8124984c>] ? __netdev_alloc_skb+0x29/0x45
Apr 11 13:31:32 phoenix kernel: [504985.338017]  [<ffffffff81248879>] ? __alloc_skb+0x69/0x15a
Apr 11 13:31:32 phoenix kernel: [504985.338021]  [<ffffffff8124984c>] ? __netdev_alloc_skb+0x29/0x45
Apr 11 13:31:32 phoenix kernel: [504985.338052]  [<ffffffffa003d7c3>] ? rtl8169_rx_interrupt+0x1d8/0x416 [r8169]
Apr 11 13:31:32 phoenix kernel: [504985.338059]  [<ffffffff81012922>] ? do_IRQ+0xa0/0xb6
Apr 11 13:31:32 phoenix kernel: [504985.338068]  [<ffffffffa00408cb>] ? rtl8169_poll+0x3b/0x1aa [r8169]
Apr 11 13:31:32 phoenix kernel: [504985.338076]  [<ffffffff8124f98f>] ? net_rx_action+0xae/0x1c9
Apr 11 13:31:32 phoenix kernel: [504985.338085]  [<ffffffff81053c9f>] ? __do_softirq+0xdd/0x1a6
Apr 11 13:31:32 phoenix kernel: [504985.338090]  [<ffffffff81011cac>] ? call_softirq+0x1c/0x30
Apr 11 13:31:32 phoenix kernel: [504985.338095]  [<ffffffff8101322b>] ? do_softirq+0x3f/0x7c
Apr 11 13:31:32 phoenix kernel: [504985.338100]  [<ffffffff81053b0f>] ? irq_exit+0x36/0x76
Apr 11 13:31:32 phoenix kernel: [504985.338104]  [<ffffffff81012922>] ? do_IRQ+0xa0/0xb6
Apr 11 13:31:32 phoenix kernel: [504985.338109]  [<ffffffff810114d3>] ? ret_from_intr+0x0/0x11
Apr 11 13:31:32 phoenix kernel: [504985.338112]  <EOI>  [<ffffffff812fc165>] ? _spin_unlock_irqrestore+0x8/0xe
Apr 11 13:31:32 phoenix kernel: [504985.338123]  [<ffffffff810ba8b5>] ? test_clear_page_writeback+0xbd/0xe8
Apr 11 13:31:32 phoenix kernel: [504985.338132]  [<ffffffff810b4276>] ? end_page_writeback+0x1c/0x3d
Apr 11 13:31:32 phoenix kernel: [504985.338139]  [<ffffffff8110e41a>] ? end_buffer_async_write+0x10a/0x13b
Apr 11 13:31:32 phoenix kernel: [504985.338194]  [<ffffffffa0167848>] ? xfs_destroy_ioend+0x33/0x7e [xfs]
Apr 11 13:31:32 phoenix kernel: [504985.338202]  [<ffffffff810618d7>] ? worker_thread+0x188/0x21d
Apr 11 13:31:32 phoenix kernel: [504985.338226]  [<ffffffffa01679e2>] ? xfs_end_bio_delalloc+0x0/0x44 [xfs]
Apr 11 13:31:32 phoenix kernel: [504985.338231]  [<ffffffff81064f02>] ? autoremove_wake_function+0x0/0x2e
Apr 11 13:31:32 phoenix kernel: [504985.338237]  [<ffffffff8106174f>] ? worker_thread+0x0/0x21d
Apr 11 13:31:32 phoenix kernel: [504985.338241]  [<ffffffff81064c35>] ? kthread+0x79/0x81
Apr 11 13:31:32 phoenix kernel: [504985.338246]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
Apr 11 13:31:32 phoenix kernel: [504985.338251]  [<ffffffff81064bbc>] ? kthread+0x0/0x81
Apr 11 13:31:32 phoenix kernel: [504985.338255]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20
Apr 11 13:31:32 phoenix kernel: [504985.338258] Mem-Info:
Apr 11 13:31:32 phoenix kernel: [504985.338261] Node 0 DMA per-cpu:
Apr 11 13:31:32 phoenix kernel: [504985.338266] CPU    0: hi:    0, btch:   1 usd:   0
Apr 11 13:31:32 phoenix kernel: [504985.338269] CPU    1: hi:    0, btch:   1 usd:   0
Apr 11 13:31:32 phoenix kernel: [504985.338272] Node 0 DMA32 per-cpu:
Apr 11 13:31:32 phoenix kernel: [504985.338276] CPU    0: hi:  186, btch:  31 usd:  20
Apr 11 13:31:32 phoenix kernel: [504985.338279] CPU    1: hi:  186, btch:  31 usd:  28
Apr 11 13:31:32 phoenix kernel: [504985.338282] Node 0 Normal per-cpu:
Apr 11 13:31:32 phoenix kernel: [504985.338286] CPU    0: hi:  186, btch:  31 usd:  30
Apr 11 13:31:32 phoenix kernel: [504985.338289] CPU    1: hi:  186, btch:  31 usd:  29
Apr 11 13:31:32 phoenix kernel: [504985.338296] active_anon:8468 inactive_anon:22059 isolated_anon:0
Apr 11 13:31:32 phoenix kernel: [504985.338298]  active_file:416632 inactive_file:423018 isolated_file:0
Apr 11 13:31:32 phoenix kernel: [504985.338300]  unevictable:0 dirty:62859 writeback:23378 unstable:0
Apr 11 13:31:32 phoenix kernel: [504985.338302]  free:7789 slab_reclaimable:43821 slab_unreclaimable:10323
Apr 11 13:31:32 phoenix kernel: [504985.338303]  mapped:2171 shmem:1117 pagetables:2587 bounce:0
Apr 11 13:31:32 phoenix kernel: [504985.338308] Node 0 DMA free:15052kB min:28kB low:32kB high:40kB active_anon:0kB inactive_anon:0kB active_file:52kB inactive_file:712kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15260kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:20kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr 11 13:31:32 phoenix kernel: [504985.338324] lowmem_reserve[]: 0 3254 3759 3759
Apr 11 13:31:32 phoenix kernel: [504985.338330] Node 0 DMA32 free:14820kB min:6780kB low:8472kB high:10168kB active_anon:22372kB inactive_anon:21396kB active_file:1493108kB inactive_file:1515136kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3333024kB mlocked:0kB dirty:216344kB writeback:80780kB mapped:2076kB shmem:1168kB slab_reclaimable:154832kB slab_unreclaimable:22892kB kernel_stack:184kB pagetables:1568kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr 11 13:31:32 phoenix kernel: [504985.338347] lowmem_reserve[]: 0 0 505 505
Apr 11 13:31:32 phoenix kernel: [504985.338352] Node 0 Normal free:1284kB min:1052kB low:1312kB high:1576kB active_anon:11500kB inactive_anon:66840kB active_file:173368kB inactive_file:176224kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:517120kB mlocked:0kB dirty:35092kB writeback:12732kB mapped:6608kB shmem:3300kB slab_reclaimable:20432kB slab_unreclaimable:18392kB kernel_stack:2352kB pagetables:8780kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Apr 11 13:31:32 phoenix kernel: [504985.338369] lowmem_reserve[]: 0 0 0 0
Apr 11 13:31:32 phoenix kernel: [504985.338374] Node 0 DMA: 5*4kB 3*8kB 0*16kB 3*32kB 3*64kB 3*128kB 2*256kB 1*512kB 3*1024kB 3*2048kB 1*4096kB = 15052kB
Apr 11 13:31:32 phoenix kernel: [504985.338387] Node 0 DMA32: 3405*4kB 4*8kB 1*16kB 0*32kB 0*64kB 1*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 14820kB
Apr 11 13:31:32 phoenix kernel: [504985.338400] Node 0 Normal: 297*4kB 0*8kB 4*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1284kB
Apr 11 13:31:32 phoenix kernel: [504985.338413] 842900 total pagecache pages
Apr 11 13:31:32 phoenix kernel: [504985.338417] 2081 pages in swap cache
Apr 11 13:31:32 phoenix kernel: [504985.338420] Swap cache stats: add 3458, delete 1377, find 410/410
Apr 11 13:31:32 phoenix kernel: [504985.338423] Free swap  = 4185972kB
Apr 11 13:31:32 phoenix kernel: [504985.338425] Total swap = 4194296kB
Apr 11 13:31:32 phoenix kernel: [504985.365246] 983024 pages RAM
Apr 11 13:31:32 phoenix kernel: [504985.365246] 32340 pages reserved
Apr 11 13:31:32 phoenix kernel: [504985.365246] 853440 pages shared
Apr 11 13:31:32 phoenix kernel: [504985.365246] 100860 pages non-shared
Apr 11 13:31:32 phoenix kernel: [504985.365246] SLUB: Unable to allocate memory on node 0 (gfp=0x20)
Apr 11 13:31:32 phoenix kernel: [504985.365246]   cache: kmalloc-8192, object size: 8192, buffer size: 8192, default order: 3, min order: 1
Apr 11 13:31:32 phoenix kernel: [504985.365246]   node 0: slabs: 201, objs: 804, free: 14

This happens at a Debian/Squeeze amd64 box with kernel
2.6.32-5-amd64 (Debian 2.6.32-33) and 4GB RAM.

What I want to know is:

It seems to me that there was a low memory situation. Is the watched
behavior known and what impact it have? Should I be concerned about
the file integrity?

Regards
Friedemann

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
