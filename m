Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p46C7f9f195588 for <xfs@oss.sgi.com>; Fri, 6 May 2011 07:07:41 -0500
Received: from acheron.ifi.lmu.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F5F815D3616
	for <xfs@oss.sgi.com>; Fri,  6 May 2011 05:11:19 -0700 (PDT)
Received: from acheron.ifi.lmu.de (acheron.ifi.lmu.de [129.187.214.135]) by
	cuda.sgi.com with ESMTP id gk8PdRdfvrqXuCAi for
	<xfs@oss.sgi.com>; Fri, 06 May 2011 05:11:19 -0700 (PDT)
Received: from [10.153.74.164] (aukena.pms.ifi.lmu.de [10.153.74.164])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested) (Authenticated sender: josko)
	by acheron.ifi.lmu.de (Postfix) with ESMTP id 8E4E494A089
	for <xfs@oss.sgi.com>; Fri,  6 May 2011 14:11:18 +0200 (CEST)
Message-ID: <4DC3E566.8070601@lrz.uni-muenchen.de>
Date: Fri, 06 May 2011 14:11:18 +0200
From: stefanx <stefanx@lrz.uni-muenchen.de>
MIME-Version: 1.0
Subject: __write_lock_failed
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


Hello,

some of my virtual machines (kvm/qemu) sometimes crash (xfs, Ubuntu 10.04, 2.6.32-31-x86_64).
I think it happens while taking LVM-snapshots from the XFS-Filesystem of that machines:

 BUG: soft lockup - CPU#7 stuck for 61s! [kswapd0:84]
 Modules linked in: reiserfs ipt_ULOG ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables kvm_intel kvm xfs exportfs bridge stp ppdev fbcon tileblit font bitblit softcursor parport_pc psmouse serio_raw i5000_edac bnx2 vga16fb vgastate edac_core i5k_amb shpchp lp parport raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 floppy multipath ahci e1000e linear
 CPU 7:
 Modules linked in: reiserfs ipt_ULOG ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables kvm_intel kvm xfs exportfs bridge stp ppdev fbcon tileblit font bitblit softcursor parport_pc psmouse serio_raw i5000_edac bnx2 vga16fb vgastate edac_core i5k_amb shpchp lp parport raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 floppy multipath ahci e1000e linear
 Pid: 84, comm: kswapd0 Not tainted 2.6.32-27-server #49-Ubuntu PRIMERGY TX200 S4
 RIP: 0010:[]  [] __write_lock_failed+0x9/0x20
 RSP: 0018:ffff88062237dbc8  EFLAGS: 00000206
 RAX: 0000000000000000 RBX: ffff88062237dbd0 RCX: 0000000000000000
 RDX: ffffffffa01c3a00 RSI: 0000000000000000 RDI: ffff8806190c6048
 RBP: ffffffff81012cae R08: 0000000000000000 R09: 0000000000000001
 R10: 0000000000000000 R11: 000000000000007c R12: ffff88061ae424d0
 R13: ffff8802b2c18c00 R14: ffff88061ae424d0 R15: 0000000000000202
 FS:  0000000000000000(0000) GS:ffff880016fc0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
 CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000026e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Call Trace:
  [] ? _write_lock+0x17/0x20
  [] ? xfs_inode_ag_walk+0x68/0x140 [xfs]
  [] ? xfs_reclaim_inode+0x0/0x120 [xfs]
  [] ? xfs_inode_ag_iterator+0x99/0xe0 [xfs]
  [] ? xfs_reclaim_inode+0x0/0x120 [xfs]
  [] ? xfs_reclaim_inode_shrink+0xfc/0x140 [xfs]
  [] ? shrink_slab+0x125/0x190
  [] ? balance_pgdat+0x526/0x6d0
  [] ? isolate_pages_global+0x0/0x50
  [] ? kswapd+0xfe/0x150
  [] ? autoremove_wake_function+0x0/0x40
  [] ? kswapd+0x0/0x150
  [] ? kthread+0x96/0xa0
  [] ? child_rip+0xa/0x20


This link seems to describe the same problem with Xen:

http://lists.xensource.com/archives/html/xen-users/2010-04/msg01135.html


Any ideas ?

Thanks

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
