Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Jan 2007 12:17:57 -0800 (PST)
Received: from netcenter.hu (ns.netcenter.hu [195.228.254.57])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0BKHoqw029286
	for <linux-xfs@oss.sgi.com>; Thu, 11 Jan 2007 12:17:52 -0800
Message-ID: <04e601c735bd$4bd17de0$0400a8c0@dcccs>
From: "Janos Haar" <djani22@netcenter.hu>
References: <026501c72237$0464f7a0$0400a8c0@dcccs> <20061218062444.GH44411608@melbourne.sgi.com> <027b01c7227d$0e26d1f0$0400a8c0@dcccs> <20061218223637.GP44411608@melbourne.sgi.com> <001a01c722fd$df5ca710$0400a8c0@dcccs> <20061219025229.GT33919298@melbourne.sgi.com> <20061219044700.GW33919298@melbourne.sgi.com> <041601c729b6$f81e4af0$0400a8c0@dcccs> <20070107231402.GU44411608@melbourne.sgi.com> <049c01c734db$5089aa70$0400a8c0@dcccs> <20070111033430.GA33919298@melbourne.sgi.com>
Subject: Re: xfslogd-spinlock bug?
Date: Thu, 11 Jan 2007 21:15:51 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-xfs@oss.sgi.com, linux-kernel@vger.kernel.org


----- Original Message ----- 
From: "David Chinner" <dgc@sgi.com>
To: "Janos Haar" <djani22@netcenter.hu>
Cc: "David Chinner" <dgc@sgi.com>; <linux-xfs@oss.sgi.com>;
<linux-kernel@vger.kernel.org>
Sent: Thursday, January 11, 2007 4:34 AM
Subject: Re: xfslogd-spinlock bug?


> On Wed, Jan 10, 2007 at 06:18:08PM +0100, Janos Haar wrote:
> > From: "David Chinner" <dgc@sgi.com>
> > > Different corruption in RBX here. Looks like semi-random garbage
there.
> > > I wonder - what's the mac and ip address(es) of your machine and nbd
> > > servers?
> >
> > dy-base:
>
> no matches. Oh well, it was a long shot.
>
> > Some new stuff:
> > Jan  8 18:11:16 dy-base RAX: ffffffff80810800 RBX: 000004f0e2850659 RCX:
>
> RBX trashed again with more random garbage.
>
> > Jan  8 18:11:16 dy-base  [<ffffffff80223f81>]
default_wake_function+0xd/0xf
> > Jan  8 18:11:16 dy-base  [<ffffffff8023c81d>]
> > autoremove_wake_function+0x11/0x38
> > Jan  8 18:11:16 dy-base  [<ffffffff802225b1>] __wake_up_common+0x3e/0x68
> > Jan  8 18:11:16 dy-base  [<ffffffff80222ac9>] __wake_up+0x38/0x50
> > Jan  8 18:11:16 dy-base  [<ffffffff80569d1c>]
> > sk_stream_write_space+0x5d/0x83
> > Jan  8 18:11:16 dy-base  [<ffffffff80591afd>] tcp_check_space+0x8f/0xcd
> > Jan  8 18:11:16 dy-base  [<ffffffff80596de0>]
> > tcp_rcv_established+0x116/0x76e
> > Jan  8 18:11:16 dy-base  [<ffffffff8059ce41>] tcp_v4_do_rcv+0x2d/0x322
> > Jan  8 18:11:16 dy-base  [<ffffffff8059f59e>] tcp_v4_rcv+0x8bb/0x925
> > Jan  8 18:11:16 dy-base  [<ffffffff80583b24>]
> > ip_local_deliver_finish+0x0/0x1ce
> > Jan  8 18:11:16 dy-base  [<ffffffff805843e6>]
ip_local_deliver+0x172/0x238
> > Jan  8 18:11:16 dy-base  [<ffffffff8058422c>] ip_rcv+0x44f/0x497
> > Jan  8 18:11:16 dy-base  [<ffffffff88004bbc>]
> > :e1000:e1000_alloc_rx_buffers+0x1e7/0x2cb
> > Jan  8 18:11:16 dy-base  [<ffffffff8056c0a6>]
netif_receive_skb+0x1ee/0x255
> > Jan  8 18:11:16 dy-base  [<ffffffff8056de0c>] process_backlog+0x8a/0x10f
> > Jan  8 18:11:16 dy-base  [<ffffffff8056e060>] net_rx_action+0xa9/0x16e
> > Jan  8 18:11:16 dy-base  [<ffffffff8022edf9>] __do_softirq+0x57/0xc7
> > Jan  8 18:11:16 dy-base  [<ffffffff8020aa1c>] call_softirq+0x1c/0x28
> > Jan  8 18:11:16 dy-base  [<ffffffff8020c68a>] do_softirq+0x34/0x87
> > Jan  8 18:11:16 dy-base  [<ffffffff8022ed0f>] irq_exit+0x3f/0x41
> > Jan  8 18:11:16 dy-base  [<ffffffff8020c786>] do_IRQ+0xa9/0xc7
> > Jan  8 18:11:16 dy-base  [<ffffffff80209e11>] ret_from_intr+0x0/0xa
> ......
> > > (i.e. I suspect this is a nbd problem, not an XFS problem)
>
> There's something seriously wrong in your kernel that has, AFAICT,
> nothing to do with XFS. I suggest talking to the NBD folk as that is
> the only unusualy thing that I can see that you are using....
>
> Cheers,

OK, i will try....

Thanks a lot,

Janos


>
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
