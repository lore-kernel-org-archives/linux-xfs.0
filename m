Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 May 2008 08:17:11 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4HFGRpZ027176
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 08:16:37 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 05B7616DF224
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 08:16:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id D0q01cWSKe5cCixf for <xfs@oss.sgi.com>; Sat, 17 May 2008 08:16:52 -0700 (PDT)
Message-ID: <482EF6A7.2020909@sandeen.net>
Date: Sat, 17 May 2008 10:15:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Regression- XFS won't mount on partitioned md array
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com>
In-Reply-To: <482EEFDA.50101@dgreaves.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>

David Greaves wrote:
> Eric Sandeen wrote:

>>> I get:
>>>  md_d0: p1 p2
>>> XFS mounting filesystem md_d0p1
>>> attempt to access beyond end of device
>>> md_d0p2: rw=0, want=195311, limit=195304
>> what does /proc/partitions say about md_d0p1 and p2?  Is it different
>> between the older & newer kernel?

...

> 2.6.25.4 (bad)
>  254     0 1250241792 md_d0
>  254     1 1250144138 md_d0p1
>  254     2      97652 md_d0p2
> 
> So nothing obvious there then...
> 
>> What does xfs_info /mount/point say about the filesystem when you mount
>> it under the older kernel?  Or... if you can't mount it,
> teak:~# xfs_info /media/
> meta-data=/dev/md_d0p1           isize=256    agcount=32, agsize=9766751 blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=312536032, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096
> log      =external               bsize=4096   blocks=24413, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=65536  blocks=0, rtextents=0

ok, and with:

> Partition Table for /dev/md_d0
> 
>                First       Last
>  # Type       Sector      Sector   Offset    Length   Filesystem Type (ID) Flag
> -- ------- ----------- ----------- ------ ----------- -------------------- ----
>  1 Primary           0  2500288279      4  2500288280 Linux (83)           None
>  2 Primary  2500288280  2500483583      0      195304 Non-FS data (DA)     None

So, xfs thinks the external log is 24413 4k blocks (from the sb geometry
printed by xfs_info).  This is 97652 1k units (matching your
/proc/partitions output) and 195304 512-byte sectors (matching the
partition table output).  So that all looks consistent.

So if xfs is doing:

>>> md_d0p2: rw=0, want=195311, limit=195304
>>> XFS: empty log check failed

it surely does seem to be trying to read past the end of what even it
thinks is the end of its log.

And, with your geometry I can reproduce this w/o md, partitioned or not.
 So looks like xfs itself is busted:

loop5: rw=0, want=195311, limit=195304

I'll see if I have a little time today to track down the problem.

Thanks,

-Eric
