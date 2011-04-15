Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3F7LtLm050416 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 02:21:56 -0500
Received: from smtp-tls.univ-nantes.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 9385C3E2E4F
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 00:25:17 -0700 (PDT)
Received: from smtp-tls.univ-nantes.fr (smtp-tls2.univ-nantes.fr
	[193.52.101.146]) by cuda.sgi.com with SMTP id BecfrJyyZRL5e15A
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 00:25:17 -0700 (PDT)
Received: from localhost (debian [127.0.0.1])
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTP id 1BC9A40064D
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 09:25:17 +0200 (CEST)
Received: from smtp-tls.univ-nantes.fr ([127.0.0.1])
	by localhost (smtp-tls2.d101.univ-nantes.fr [127.0.0.1]) (amavisd-new,
	port 10024) with LMTP id s5pDEU2PL81r for <xfs@oss.sgi.com>;
	Fri, 15 Apr 2011 09:25:17 +0200 (CEST)
Received: from [172.20.13.9] (tomintoul.cri.univ-nantes.prive [172.20.13.9])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTPSA id 0263140064A
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 09:25:17 +0200 (CEST)
Message-ID: <4DA7F286.8090905@univ-nantes.fr>
Date: Fri, 15 Apr 2011 09:23:50 +0200
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfs: write back inodes during reclaim
References: <1302157196-1988-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1302157196-1988-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Le 07/04/2011 08:19, Dave Chinner a =E9crit :
> This series fixes an OOM problem where VFS-only dirty inodes
> accumulate on an XFS filesystem due to atime updates causing OOM to
> occur.
>
> The first patch fixes a deadlock triggering bdi-flusher writeback
> from memory reclaim when a new bdi-flusher thread needs to be forked
> and no memory is available.
>
> the second adds a bdi-flusher kick from XFS's inode cache shrinker
> so that when memory is low the VFS starts writing back dirty inodes
> so they can be reclaimed as they get cleaned rather than remaining
> dirty and pinning the inode cache in memory.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
Hello, we've been hit for some times by a bug (oom) which may been =

related to this one. Our server contains lots of samba server (in =

linux-vserver, this is NOT a vanilla kernel) and is also NFS kernel server.
The oom generally happens after 1 month of uptime, and last week we also =

had the problem after 1 week.

for example this one :
Feb 25 12:54:15 strathisla.u11.univ-nantes.prive kernel: =

[2743591.087102] Node 0 Normal free:8840kB min:12968kB low:16208kB =

high:19452kB active_anon:140168kB inactive_anon:21200kB =

active_file:1446724kB inactive_file:10741224kB unevictable:4172kB =

isolated(anon):0kB isolated(file):0kB present:13186560kB mlocked:4172kB =

dirty:42924kB writeback:249420kB mapped:60296kB shmem:7028kB =

slab_reclaimable:758752kB slab_unreclaimable:136528kB =

kernel_stack:6784kB pagetables:8388kB unstable:0kB bounce:0kB =

writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Feb 25 12:57:21 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877303] admind: page allocation failure. order:0, mode:0x4020
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877340] Pid: 10121, comm: admind Not tainted =

2.6.32-5-vserver-amd64 #1
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877369] Call Trace:
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877392] <IRQ>  [<ffffffff810c3f43>] ? =

__alloc_pages_nodemask+0x592/0x5f3
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877449]  [<ffffffff810f0d1e>] ? new_slab+0x5b/0x1ca
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877477]  [<ffffffff810f107d>] ? __slab_alloc+0x1f0/0x39b
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877507]  [<ffffffff812565c8>] ? __netdev_alloc_skb+0x29/0x45
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877537]  [<ffffffff810f1aaf>] ? =

__kmalloc_node_track_caller+0xbb/0x11b
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877568]  [<ffffffff812565c8>] ? __netdev_alloc_skb+0x29/0x45
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877598]  [<ffffffff812555f5>] ? __alloc_skb+0x69/0x15a
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877627]  [<ffffffff812565c8>] ? __netdev_alloc_skb+0x29/0x45
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877673]  [<ffffffffa00af52a>] ? bnx2_alloc_rx_skb+0x4c/0x1a3 [bnx2]
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877706]  [<ffffffffa00b34fb>] ? bnx2_poll_work+0x4f3/0xa7e [bnx2]
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877738]  [<ffffffffa00b3c47>] ? bnx2_poll+0x11b/0x229 [bnx2]
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877768]  [<ffffffff8125c851>] ? net_rx_action+0xae/0x1c9
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877799]  [<ffffffff8105430b>] ? __do_softirq+0xdd/0x1a2
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877828]  [<ffffffff81011cac>] ? call_softirq+0x1c/0x30
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877857]  [<ffffffff8101322b>] ? do_softirq+0x3f/0x7c
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877885]  [<ffffffff8105417a>] ? irq_exit+0x36/0x76
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877912]  [<ffffffff81012922>] ? do_IRQ+0xa0/0xb6
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877939]  [<ffffffff810114d3>] ? ret_from_intr+0x0/0x11
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.877966] <EOI>  [<ffffffffa02304cf>] ? =

xfs_reclaim_inode+0x0/0xe0 [xfs]
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878019]  [<ffffffff8130a7c5>] ? _write_lock+0x7/0xf
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878058]  [<ffffffffa0230e3d>] ? xfs_inode_ag_walk+0x4e/0xef [xfs]
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878098]  [<ffffffffa02304cf>] ? xfs_reclaim_inode+0x0/0xe0 [xfs]
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878138]  [<ffffffffa0230f4f>] ? xfs_inode_ag_iterator+0x71/0xb2 =

[xfs]
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878179]  [<ffffffffa02304cf>] ? xfs_reclaim_inode+0x0/0xe0 [xfs]
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878219]  [<ffffffffa0230feb>] ? =

xfs_reclaim_inode_shrink+0x5b/0x10d [xfs]
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878265]  [<ffffffff810c8dd1>] ? shrink_slab+0xe0/0x153
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878294]  [<ffffffff810c9d2e>] ? try_to_free_pages+0x26a/0x38e
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878323]  [<ffffffff810c6ceb>] ? isolate_pages_global+0x0/0x20f
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878353]  [<ffffffff810c3d7e>] ? __alloc_pages_nodemask+0x3cd/0x5f3
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878383]  [<ffffffff810f0d05>] ? new_slab+0x42/0x1ca
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878411]  [<ffffffff810f107d>] ? __slab_alloc+0x1f0/0x39b
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878441]  [<ffffffff8110437f>] ? getname+0x23/0x1a0
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878468]  [<ffffffff8110437f>] ? getname+0x23/0x1a0
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878495]  [<ffffffff810f1558>] ? kmem_cache_alloc+0x7f/0xf0
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878524]  [<ffffffff8110437f>] ? getname+0x23/0x1a0
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878552]  [<ffffffff810f75b3>] ? do_sys_open+0x1d/0xfc
Feb 25 12:57:22 strathisla.u11.univ-nantes.prive kernel: =

[2743777.878580]  [<ffffffff81037623>] ? ia32_sysret+0x0/0x5


I saw this on 2.6.32 kernels ; Since 2 days we're testing 2.6.38.2 =

kernel on the very same machine.

Some questions :

-What kernel versions are known to be impacted ?
-What is the plan for inclusion in kernel ? Is this considered =

appropriate material for 2.6.38.4 and older stable kernels ?
- Is mounting with noatime can alleviate the problem ?

Regards,

-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
