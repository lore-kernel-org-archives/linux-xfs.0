Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2Q02WCU173665 for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 19:02:32 -0500
Received: from bifrost.lang.hm (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 028C51B40EDE
	for <xfs@oss.sgi.com>; Thu, 25 Mar 2010 17:04:13 -0700 (PDT)
Received: from bifrost.lang.hm (mail.lang.hm [64.81.33.126]) by cuda.sgi.com
	with ESMTP id aTSYh9rvx1kApZej for <xfs@oss.sgi.com>;
	Thu, 25 Mar 2010 17:04:13 -0700 (PDT)
Date: Thu, 25 Mar 2010 17:03:52 -0700 (PDT)
From: david@lang.hm
Subject: Re: 128TB filesystem limit?
In-Reply-To: <20100325235433.GM3335@dastard>
Message-ID: <alpine.DEB.2.00.1003251702190.12435@asgard.lang.hm>
References: <alpine.DEB.2.00.1003251609160.12435@asgard.lang.hm>
	<20100325235433.GM3335@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, 26 Mar 2010, Dave Chinner wrote:

> On Thu, Mar 25, 2010 at 04:15:42PM -0700, david@lang.hm wrote:
>> I'm working with a raid 0 (md) array on top of 10 16x1TB raid 6
>> hardware arrays.
>>
>> fdisk -l shows me 10 drives like
>>
>> WARNING: GPT (GUID Partition Table) detected on '/dev/sdk'! The util
>> fdisk doesn't support GPT. Use GNU Parted.
>>
>>
>> Disk /dev/sdk: 13999.9 GB, 13999999025152 bytes
>> 255 heads, 63 sectors/track, 1702069 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Disk identifier: 0x00000000
>>
>>    Device Boot      Start         End      Blocks   Id  System
>> /dev/sdk1               1      267350  2147483647+  ee  EFI GPT
>>
>> and then the md0 device as
>>
>> Disk /dev/md0: 139999.9 GB, 139999989596160 bytes
>> 2 heads, 4 sectors/track, -1 cylinders
>> Units = cylinders of 8 * 512 = 4096 bytes
>> Disk identifier: 0x00000000
>>
>> Disk /dev/md0 doesn't contain a valid partition table
>>
>>
>> I then did mkfs.xfs /dev/md0
>>
>> but a df is showing me 128TB
>
> What is in /proc/partitions?

# cat /proc/partitions
major minor  #blocks  name

    8        0  292542464 sda
    8        1    2048287 sda1
    8        2    2048287 sda2
    8        3    2048287 sda3
    8        4  286390755 sda4
    8       16 13671874048 sdb
    8       17 13671874014 sdb1
    8       32 13671874048 sdc
    8       33 13671874014 sdc1
    8       48 13671874048 sdd
    8       49 13671874014 sdd1
    8       64 13671874048 sde
    8       65 13671874014 sde1
    8       80 13671874048 sdf
    8       81 13671874014 sdf1
    8       96 13671874048 sdg
    8       97 13671874014 sdg1
    8      112 13671874048 sdh
    8      113 13671874014 sdh1
    8      128 13671874048 sdi
    8      129 13671874014 sdi1
    8      144 13671874048 sdj
    8      145 13671874014 sdj1
    8      160 13671874048 sdk
    8      161 13671874014 sdk1
    9        0 136718739840 md0

>> is this just rounding error combined with the 1000=1k vs 1024=1k
>> marketing stuff,
>
> Probably.
>
>> or is there some limit I am bumping into here.
>
> Unlikely to be an XFS limit - I was doing some "what happens if"
> testing on multi-PB sized XFS filesystems hosted on sparse files
> a couple of days ago....

Ok, 128TB is a suspiciously round (in computer terms) number, especially 
when the math is 10 sets of 14 drives (each 1TB), so I figured I'd double 
check.

David Lang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
