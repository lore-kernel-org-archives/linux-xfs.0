Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 May 2008 07:46:16 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4HEk7ZP025934
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 07:46:09 -0700
Received: from mail.ukfsn.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1EB151B95618
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 07:46:55 -0700 (PDT)
Received: from mail.ukfsn.org (mx1.ukfsn.org [77.75.108.10]) by cuda.sgi.com with ESMTP id OdzABENfs3T4QTzv for <xfs@oss.sgi.com>; Sat, 17 May 2008 07:46:55 -0700 (PDT)
Message-ID: <482EEFDA.50101@dgreaves.com>
Date: Sat, 17 May 2008 15:46:50 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: Regression- XFS won't mount on partitioned md array
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net>
In-Reply-To: <482DD981.5070004@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>

Eric Sandeen wrote:
> David Greaves wrote:
>> I just attempted a kernel upgrade from 2.6.20.7 to 2.6.25.3 and it no longer
>> mounts my xfs filesystem.
>>
>> I bisected it to around
>> a67d7c5f5d25d0b13a4dfb182697135b014fa478
>> [XFS] Move platform specific mount option parse out of core XFS code
> 
> around that... not exactly?  That commit should have been largely a code
> move, which is not to say that it can't contain a bug... :)
I got to within 4 on the bisect and my xfs partition containing the kernel src
and the bisect history blew up telling me that files were directories and then
exploding in a  heap of lost+found/  fragments. Quite, erm, "interesting" really.

At that point I decided I was close enough to ask for advice, looked at the
commits and took this one as the most likely to cause the bug :)

But, thinking about it, I can decode the kernel extraversion tags in /boot. From
that I think my bounds were:
40ebd81d1a7635cf92a59c387a599fce4863206b
[XFS] Use kernel-supplied "roundup_pow_of_two" for simplicity
and:
3ed6526441053d79b85d206b14d75125e6f51cc2
[XFS] Implement fallocate.

so those bound:
[XFS] Remove the BPCSHIFT and NB* based macros from XFS.
[XFS] Remove bogus assert
[XFS] optimize XFS_IS_REALTIME_INODE w/o realtime config
[XFS] Move platform specific mount option parse out of core XFS code

and just glancing through the patches I didn't see any changes that looked
likely in the others...


> 
>> I have a RAID5 array with partitions:
>>
>> Partition Table for /dev/md_d0
>>
>>                First       Last
>>  # Type       Sector      Sector   Offset    Length   Filesystem Type (ID) Flag
>> -- ------- ----------- ----------- ------ ----------- -------------------- ----
>>  1 Primary           0  2500288279      4  2500288280 Linux (83)           None
>>  2 Primary  2500288280  2500483583      0      195304 Non-FS data (DA)     None
>>
>>
>> when I attempt to mount /media:
>> /dev/md_d0p1 /media xfs rw,nobarrier,noatime,logdev=/dev/md_d0p2,allocsize=512m 0 0
> 
> mythbox?  :)
Hey - we test some interesting corner cases... :)
My *wife* just told *me* to buy, and I quote "No more than 10" 1Tb Samsung
drives... I decided 5 would be plenty.

> Hm, so it's the external log size that it doesn't much like...
Yep - I noticed that - and ISTR that Neil has been fiddling in the md
partitioning code over the last 6 months or so.
I wondered where it got the larger figure from and if, somehow, md was changing
the partition size somehow...


>> I get:
>>  md_d0: p1 p2
>> XFS mounting filesystem md_d0p1
>> attempt to access beyond end of device
>> md_d0p2: rw=0, want=195311, limit=195304
> 
> what does /proc/partitions say about md_d0p1 and p2?  Is it different
> between the older & newer kernel?
2.6.20.7 (good)
 254     0 1250241792 md_d0
 254     1 1250144138 md_d0p1
 254     2      97652 md_d0p2

2.6.25.3 (bad)
 254     0 1250241792 md_d0
 254     1 1250144138 md_d0p1
 254     2      97652 md_d0p2

2.6.25.4 (bad)
 254     0 1250241792 md_d0
 254     1 1250144138 md_d0p1
 254     2      97652 md_d0p2

So nothing obvious there then...

> 
> What does xfs_info /mount/point say about the filesystem when you mount
> it under the older kernel?  Or... if you can't mount it,
teak:~# xfs_info /media/
meta-data=/dev/md_d0p1           isize=256    agcount=32, agsize=9766751 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=312536032, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =external               bsize=4096   blocks=24413, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0
