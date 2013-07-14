Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7B3F57F37
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 11:56:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5A8C4304043
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 09:56:16 -0700 (PDT)
Received: from mail-ob0-f175.google.com (mail-ob0-f175.google.com
	[209.85.214.175]) by cuda.sgi.com with ESMTP id
	jlhByAc4fNzI9JAF (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 09:56:15 -0700 (PDT)
Received: by mail-ob0-f175.google.com with SMTP id xn12so13260703obc.34
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 09:56:14 -0700 (PDT)
Subject: Re: specify agsize?
Mime-Version: 1.0 (Apple Message framework v1085)
From: aurfalien <aurfalien@gmail.com>
In-Reply-To: <51E24E03.8010609@hardwarefreak.com>
Date: Sun, 14 Jul 2013 09:56:10 -0700
Message-Id: <D72E66F5-374F-46A5-B964-7B3AE97DC0F8@gmail.com>
References: <6A14EB72-A699-47AF-937D-D6DA1CF12ACB@gmail.com>
	<51E2092D.7090409@sandeen.net>
	<9AB8D1D3-29D7-4C43-A624-37024CA4EFD9@gmail.com>
	<51E24E03.8010609@hardwarefreak.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com


On Jul 14, 2013, at 12:06 AM, Stan Hoeppner wrote:

> On 7/13/2013 11:20 PM, aurfalien wrote:
> ...
>>>> mkfs.xfs -f -l size=512m -d su=128k,sw=14 /dev/mapper/vg_doofus_data-lv_data
> ...
>>>> meta-data=/dev/mapper/vg_doofus_data-lv_data isize=256    agcount=32, agsize=209428640 blks
>>>>        =                       sectsz=512   attr=2, projid32bit=0
>>>> data     =                       bsize=4096   blocks=6701716480, imaxpct=5
>>>>        =                       sunit=32     swidth=448 blks
>>>> naming   =version 2              bsize=4096   ascii-ci=0
>>>> log      =internal log           bsize=4096   blocks=131072, version=2
>>>>        =                       sectsz=512   sunit=32 blks, lazy-count=1
>>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
> ...
>> Autodesk has this software called Flame which requires very very fast local storage using XFS.  
> 
> If "Flame" does any random writes then you probably shouldn't be using
> RAID6.
> 
>> They have an entire write up on how to calc proper agsize for optimal performance.
> 
> I think you're confused.  Maximum agsize is 1TB.  Making your AGs
> smaller than that won't decrease application performance, so it's
> literally impossible to tune agsize to increase performance.  agcount on
> the other hand can potentially have an effect if the application is
> sufficiently threaded.  But agcount doesn't mean anything in isolation.
> It's tied directly to the characteristics of the RAID level and
> hardware.  For example, mkfs.xfs gave you 32 AGs for this 14 spindle
> array.  One could make 32 AGs on a single 4TB SATA disk and the
> performance difference between the two will be radically different.
> 
> ...
>> Well, it will give me a base line comparison of non tweaked agsize vs tweaked agsize.
> 
> No, it won't.  See above.
> 
>> Yea but based on what?
> 
> Based on the fact that your XFS is ~26TB.
> 
> mkfs.xfs could have given you 26 AGs of ~1TB each.  But it chose to give
> you 32 AGs of ~815GB each.  Whether you run bonnie, iozone, or your
> Flame application, you won't be able to measure a meaningful difference,
> if any difference, between 26 and 32 AGs.
> 
> ...
>> Problem is I run Centos so the line;
>> 
>> "As of kernel 3.2.12, the default i/o scheduler, CFQ, will defeat much of the parallelization in XFS. "
>> 
>> ... doesn't really apply.
> 
> This makes no sense.  What doesn't apply?

Well, I had assumed it meant Linux kernel version 3.2.12, were as CentOS is at whatever RHEL is at being 2.6.32.

At any rate, based on what I'm getting from you all, is that leave the agcount alone as agsize will max at 1TB and agcount will adjust depending on volume size.

This volume will encounter a lot of random IO so 32 AGs will suffice at any rate.  Un sure if increasing it to Autodesks 128 will really help my env.  I'm assuming they want a lot of parallelism which again doesn't apply in my case.. 

> You can change to noop or deadline with a single echo command in a
> startup script:
> 
> echo noop > /sys/block/sdX/queue/scheduler
> 
> where sdX is the name of your RAID device.
> 
> -- 
> Stan
> 
> 

- aurf
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
