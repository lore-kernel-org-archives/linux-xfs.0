Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Jan 2008 02:50:08 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m08Ao0I7017793
	for <linux-xfs@oss.sgi.com>; Tue, 8 Jan 2008 02:50:03 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FCE911A05EF
	for <linux-xfs@oss.sgi.com>; Tue,  8 Jan 2008 02:50:17 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id QhxOgjn036HylD8N for <linux-xfs@oss.sgi.com>; Tue, 08 Jan 2008 02:50:17 -0800 (PST)
Date: Tue, 8 Jan 2008 05:50:16 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mount option swalloc
In-Reply-To: <5d96567b0801071227i509402ccuce044106cc8959af@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801080549460.4085@p34.internal.lan>
References: <5d96567b0801071227i509402ccuce044106cc8959af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Raz <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com

Isn't 2.6.17 - 2.6.17.6 the bugged version of the kernel that corrupts XFS 
filesystems? I suggest you run a different kernel version and xfs_repair 
on your XFS filesystems.

Justin.

On Mon, 7 Jan 2008, Raz wrote:

> Does it work ?
> I have created several 100MBytes files over raid5 and they don't seem
> to be starting at modulo (swidth ) = 0.
> conf: sunit=1M ,  raid5 with 4 sata disks.  swidth=3MB.
>
> meta-data=/dev/md1               isize=256    agcount=32, agsize=5687296 blks
>         =                       sectsz=4096  attr=0
> data     =                       bsize=4096   blocks=181989888, imaxpct=25
>         =                       sunit=256    swidth=768 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=2
>         =                       sectsz=4096  sunit=1 blks
> realtime =none                   extsz=3145728 blocks=0, rtextents=0
>
> I am using 2.6.17 vanilla kernel .
>
> thank you
> -- 
> Raz
>
>
