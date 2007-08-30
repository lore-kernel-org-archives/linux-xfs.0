Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 13:03:21 -0700 (PDT)
Received: from brmea-mail-2.sun.com ([192.18.98.43])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7UK3H4p028756
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 13:03:18 -0700
In-Reply-To: <1188454611.23311.13.camel@toonses.gghcwest.com>
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B6314154-AAB2-4955-9CAE-EAF54BB84922@sun.com>
Content-Transfer-Encoding: 7bit
From: eric kustarz <eric.kustarz@sun.com>
Subject: Re: [zfs-discuss] ZFS, XFS, and EXT4 compared
Date: Thu, 30 Aug 2007 12:07:59 -0700
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jeffrey W. Baker" <jwbaker@acm.org>
Cc: zfs-discuss@opensolaris.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org


On Aug 29, 2007, at 11:16 PM, Jeffrey W. Baker wrote:

> I have a lot of people whispering "zfs" in my virtual ear these days,
> and at the same time I have an irrational attachment to xfs based
> entirely on its lack of the 32000 subdirectory limit.  I'm not  
> afraid of
> ext4's newness, since really a lot of that stuff has been in Lustre  
> for
> years.  So a-benchmarking I went.  Results at the bottom:
>
> http://tastic.brillig.org/~jwb/zfs-xfs-ext4.html
>
> Short version: ext4 is awesome.  zfs has absurdly fast metadata
> operations but falls apart on sequential transfer.  xfs has great
> sequential transfer but really bad metadata ops, like 3 minutes to tar
> up the kernel.
>
> It would be nice if mke2fs would copy xfs's code for optimal layout  
> on a
> software raid.  The mkfs defaults and the mdadm defaults interact  
> badly.
>
> Postmark is somewhat bogus benchmark with some obvious quantization
> problems.
>
> Regards,
> jwb
>

Hey jwb,

Thanks for taking up the task, its benchmarking so i've got some  
questions...

What does it mean to have an external vs. internal journal for ZFS?

Can you show the output of 'zpool status' when using software RAID  
vs. hardware RAID for ZFS?

The hardware RAID has a cache on the controller.  ZFS will flush the  
"cache" when pushing out a txg (essentially before writing out the  
uberblock and after writing out the uberblock).  When you have a non- 
volatile cache with battery backing (such as your setup), its safe to  
disable that via putting 'set zfs:zfs_nocacheflush = 1' in /etc/ 
system and rebooting.  Its ugly but we're going through the final  
code review of a fix for this (its partly we aren't sending down the  
right command and partly even if we did, no storage devices actually  
support it quite yet).

What parameters did you give bonnie++?  compiled 64bit, right?

For the randomio test, it looks like you used an io_size of 4KB.  Are  
those aligned?  random?  How big is the '/dev/sdb' file?

Do you have the parameters given to FFSB?

eric
