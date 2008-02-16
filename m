Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Feb 2008 20:41:34 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1G4fVHM031787
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 20:41:32 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C75AFE364C4
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 20:41:56 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id huPkmAxRnNUr2XH7 for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 20:41:56 -0800 (PST)
Message-ID: <47B66991.5040504@sandeen.net>
Date: Fri, 15 Feb 2008 22:41:53 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Differences in mkfs.xfs and xfs_info output.
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
In-Reply-To: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Derfinak <ja@mail.upjs.sk>
Cc: xfs@oss.sgi.com

Jan Derfinak wrote:
> Hello.
> 
> I found following problem with xfs_info (xfs_grows -p xfs_info) command:
> 
> # mkfs.xfs -f /dev/loop0     
> meta-data=/dev/loop0             isize=256    agcount=4, agsize=32000 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=128000, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096  
> log      =internal log           bsize=4096   blocks=1200, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> # mount /dev/loop0 /mnt/usb
> # xfs_info /mnt/usb
> meta-data=/dev/loop0             isize=256    agcount=4, agsize=32000 blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=128000, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096  
> log      =internal               bsize=4096   blocks=1200, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0

... sorry for replying to my own thread 100 times, but...

do you happen to have a 32-bit mkfs and a 64-bit kernrel?

-Eric
