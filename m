Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 01:16:43 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l978Gbqb001979
	for <linux-xfs@oss.sgi.com>; Sun, 7 Oct 2007 01:16:39 -0700
Date: Sun, 7 Oct 2007 04:16:37 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mounting raid5 with different unit values
In-Reply-To: <5d96567b0710070015j723810aag20dc3e2866868684@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710070416160.741@p34.internal.lan>
References: <5d96567b0710070015j723810aag20dc3e2866868684@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Raz <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com



On Sun, 7 Oct 2007, Raz wrote:

> Hello
> I am trying to mount xfs over raid5. I am trying to mount it with
> different values than
> the true ones. the mount fails with a general error of :
> mount -osunit=6144,swidth=18432 /dev/md1 /d1/
> mount: wrong fs type, bad option, bad superblock on /dev/md1,
>        or too many mounted file systems
> 
> the true values are:
> xfs_info /d1/
> meta-data=/dev/md1               isize=256    agcount=32, agsize=5687296 blks
>          =                       sectsz=4096  attr=0
> data     =                       bsize=4096   blocks=181989888, imaxpct=25
>          =                       sunit=256    swidth=768 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=4096  sunit=1 blks
> realtime =none                   extsz=3145728 blocks=0, rtextents=0
> 
> 
> this same command did work on 2.6.15  while it failing on 2.6.17 .
> why ?
> -- 
> Raz
> 
>

Good question but also be alert that 2.6.17-2.6.17.6 will/may corrupt your 
XFS filesystem due to a nasty bug.

Justin.
