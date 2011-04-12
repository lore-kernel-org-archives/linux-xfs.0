Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3C8sdZ2141776 for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 03:54:39 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59AD13C6056
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 01:57:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	biSMfDjueQDGtlNd for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2011 01:57:59 -0700 (PDT)
Date: Tue, 12 Apr 2011 18:57:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdatad/1: page allocation failure
Message-ID: <20110412085756.GI21395@dastard>
References: <20110412053850.GA6720@phoenix.lab.swapon.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110412053850.GA6720@phoenix.lab.swapon.de>
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
To: Friedemann Stoyan <fstoyan@swapon.de>
Cc: xfs@oss.sgi.com

On Tue, Apr 12, 2011 at 07:38:51AM +0200, Friedemann Stoyan wrote:
> Dear XFS-Developers,
> 
> recently I copied a big file (>1TiB) over network into a
> XFS-Filesystem. During this I encountered this kernel trace
> from xfsdatad:
> 
> Apr 11 13:31:32 phoenix kernel: [504985.202258] xfsdatad/1: page allocation failure. order:1, mode:0x4020
> Apr 11 13:31:32 phoenix kernel: [504985.202268] Pid: 334, comm: xfsdatad/1 Not tainted 2.6.32-5-amd64 #1
> Apr 11 13:31:32 phoenix kernel: [504985.202272] Call Trace:
> Apr 11 13:31:32 phoenix kernel: [504985.202275]  <IRQ>  [<ffffffff810ba5f2>] ? __alloc_pages_nodemask+0x592/0x5f4
> Apr 11 13:31:32 phoenix kernel: [504985.202297]  [<ffffffff8128d63b>] ? tcp_v4_do_rcv+0x1bb/0x376
> Apr 11 13:31:32 phoenix kernel: [504985.202305]  [<ffffffff810e6912>] ? new_slab+0x5b/0x1ca
> Apr 11 13:31:32 phoenix kernel: [504985.202311]  [<ffffffff810e6c71>] ? __slab_alloc+0x1f0/0x39b
> Apr 11 13:31:32 phoenix kernel: [504985.202317]  [<ffffffff8124984c>] ? __netdev_alloc_skb+0x29/0x45
> Apr 11 13:31:32 phoenix kernel: [504985.202323]  [<ffffffff810e76a3>] ? __kmalloc_node_track_caller+0xbb/0x11b
> Apr 11 13:31:32 phoenix kernel: [504985.202328]  [<ffffffff8124984c>] ? __netdev_alloc_skb+0x29/0x45
> Apr 11 13:31:32 phoenix kernel: [504985.202333]  [<ffffffff81248879>] ? __alloc_skb+0x69/0x15a
> Apr 11 13:31:32 phoenix kernel: [504985.202338]  [<ffffffff8124984c>] ? __netdev_alloc_skb+0x29/0x45
> Apr 11 13:31:32 phoenix kernel: [504985.202375]  [<ffffffffa003d7c3>] ? rtl8169_rx_interrupt+0x1d8/0x416 [r8169]
> Apr 11 13:31:32 phoenix kernel: [504985.202386]  [<ffffffffa00408cb>] ? rtl8169_poll+0x3b/0x1aa [r8169]
> Apr 11 13:31:32 phoenix kernel: [504985.202393]  [<ffffffff8124f98f>] ? net_rx_action+0xae/0x1c9
> Apr 11 13:31:32 phoenix kernel: [504985.202402]  [<ffffffff81053c9f>] ? __do_softirq+0xdd/0x1a6
> Apr 11 13:31:32 phoenix kernel: [504985.202410]  [<ffffffff81011cac>] ? call_softirq+0x1c/0x30
> Apr 11 13:31:32 phoenix kernel: [504985.202415]  [<ffffffff8101322b>] ? do_softirq+0x3f/0x7c
> Apr 11 13:31:32 phoenix kernel: [504985.202420]  [<ffffffff81053b0f>] ? irq_exit+0x36/0x76
> Apr 11 13:31:32 phoenix kernel: [504985.202424]  [<ffffffff81012922>] ? do_IRQ+0xa0/0xb6
> Apr 11 13:31:32 phoenix kernel: [504985.202429]  [<ffffffff810114d3>] ? ret_from_intr+0x0/0x11
> Apr 11 13:31:32 phoenix kernel: [504985.202432]  <EOI>  [<ffffffff812fc165>] ? _spin_unlock_irqrestore+0x8/0xe
> Apr 11 13:31:32 phoenix kernel: [504985.202444]  [<ffffffff810ba8b5>] ? test_clear_page_writeback+0xbd/0xe8
> Apr 11 13:31:32 phoenix kernel: [504985.202453]  [<ffffffff810b4276>] ? end_page_writeback+0x1c/0x3d
> Apr 11 13:31:32 phoenix kernel: [504985.202460]  [<ffffffff8110e41a>] ? end_buffer_async_write+0x10a/0x13b
> Apr 11 13:31:32 phoenix kernel: [504985.202516]  [<ffffffffa0167848>] ? xfs_destroy_ioend+0x33/0x7e [xfs]
> Apr 11 13:31:32 phoenix kernel: [504985.202523]  [<ffffffff810618d7>] ? worker_thread+0x188/0x21d
> Apr 11 13:31:32 phoenix kernel: [504985.202548]  [<ffffffffa01679e2>] ? xfs_end_bio_delalloc+0x0/0x44 [xfs]
> Apr 11 13:31:32 phoenix kernel: [504985.202553]  [<ffffffff81064f02>] ? autoremove_wake_function+0x0/0x2e
> Apr 11 13:31:32 phoenix kernel: [504985.202559]  [<ffffffff8106174f>] ? worker_thread+0x0/0x21d
> Apr 11 13:31:32 phoenix kernel: [504985.202563]  [<ffffffff81064c35>] ? kthread+0x79/0x81
> Apr 11 13:31:32 phoenix kernel: [504985.202568]  [<ffffffff81011baa>] ? child_rip+0xa/0x20
> Apr 11 13:31:32 phoenix kernel: [504985.202573]  [<ffffffff81064bbc>] ? kthread+0x0/0x81
> Apr 11 13:31:32 phoenix kernel: [504985.202577]  [<ffffffff81011ba0>] ? child_rip+0x0/0x20

I's a network driver problem, not an XFS issue. You'd do best to
report it to linux-netdev@vger.kernel.org.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
