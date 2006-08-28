Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Aug 2006 07:59:06 -0700 (PDT)
Received: from zenon.apartia.fr (zenon.apartia.fr [82.66.93.83])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7SEwuDW026315
	for <xfs@oss.sgi.com>; Mon, 28 Aug 2006 07:58:57 -0700
Received: from trajan.apartia.fr (trajan.apartia.fr [10.0.3.121])
	by zenon.apartia.fr (Postfix) with ESMTP id 02773F08B4401
	for <xfs@oss.sgi.com>; Mon, 28 Aug 2006 16:58:15 +0200 (CEST)
Date: Mon, 28 Aug 2006 16:57:51 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: Re: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate memory
Message-ID: <20060828145751.GA7993@apartia.fr>
References: <20060827072123.GA3875@apartia.fr> <200608280555.PAA03288@larry.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200608280555.PAA03288@larry.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Mon, Aug 28, 2006 at 03:57:02PM +1000, Barry Naujok wrote:
> > 
> > Hello,
> > 
> > Using xfs_repair on a 2TB partition I get:
> [snip] 
> > 	xfs_repair: libxfs_initbuf can't memalign 4096 bytes: 
> > Cannot allocate memory
>  
> Can you tell me how many inodes you have on your filesystem?
> 

	sylla:~# xfs_info /dev/md1
	meta-data=/dev/root              isize=256    agcount=32, agsize=15252656 blks
			 =                       sectsz=4096  attr=0
	data     =                       bsize=4096   blocks=488084704, imaxpct=25
			 =                       sunit=16     swidth=80 blks, unwritten=1
	naming   =version 2              bsize=4096  
	log      =internal               bsize=4096   blocks=32768, version=2
			 =                       sectsz=4096  sunit=1 blks
	realtime =none                   extsz=327680 blocks=0, rtextents=0

Hmmm, no inode info here... How do I find it?
