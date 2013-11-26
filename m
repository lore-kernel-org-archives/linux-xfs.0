Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A31F27F51
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 18:45:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8B7BD8F8065
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 16:45:47 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id HyxjQt0okTox5tv6
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 16:45:43 -0800 (PST)
Message-ID: <5293EF32.9090301@hardwarefreak.com>
Date: Mon, 25 Nov 2013 18:45:38 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: ARC-1120 and MD very sloooow
References: <1385118796.8091.31.camel@bews002.euractiv.com>	<528FBBE5.80404@hardwarefreak.com>
	<1385369796.2076.16.camel@bews002.euractiv.com>
In-Reply-To: <1385369796.2076.16.camel@bews002.euractiv.com>
Reply-To: stan@hardwarefreak.com
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
To: Jimmy Thrasibule <thrasibule.jimmy@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 11/25/2013 2:56 AM, Jimmy Thrasibule wrote:
> Hello Stan,
> 
>> This may not be an md problem.  It appears you've mangled your XFS
>> filesystem alignment.  This may be a contributing factor to the low
>> write throughput.
>>
>>>         md3 : active raid10 sdc1[0] sdf1[3] sde1[2] sdd1[1]
>>>               7813770240 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
>> ...
>>>         /dev/md3 on /srv type xfs (rw,nosuid,nodev,noexec,noatime,attr2,delaylog,inode64,sunit=2048,swidth=4096,noquota)
>>
>> Beyond having a ridiculously unnecessary quantity of mount options, it
>> appears you've got your filesystem alignment messed up, still.  Your
>> RAID geometry is 512KB chunk, 1MB stripe width.  Your override above is
>> telling the filesystem that the RAID geometry is chunk size 1MB and
>> stripe width 2MB, so XFS is pumping double the IO size that md is
>> expecting.
> 
> The nosuid, nodev, noexec, noatime and inode64 options are mine, the
> others are added by the system.

Right.  It's unusual to see this many mount options.  FYI, the XFS
default is relatime, which is nearly identical to noatime.  Specifying
noatime won't gain you anything.  Do you really need nosuid, nodev, noexec?

>>>         # xfs_info /dev/md3 
>>>         meta-data=/dev/md3               isize=256    agcount=32, agsize=30523648 blks
>>>                  =                       sectsz=512   attr=2
>>>         data     =                       bsize=4096   blocks=976755712, imaxpct=5
>>>                  =                       sunit=256    swidth=512 blks
>>>         naming   =version 2              bsize=4096   ascii-ci=0
>>>         log      =internal               bsize=4096   blocks=476936, version=2
>>>                  =                       sectsz=512   sunit=8 blks, lazy-count=1
>>
>> You created your filesystem with stripe unit of 128KB and stripe width
>> of 256KB which don't match the RAID geometry.  I assume this is the
>> reason for the fstab overrides.  I suggest you try overriding with
>> values that match the RAID geometry, which should be sunit=1024 and
>> swidth=2048.  This may or may not cure the low write throughput but it's
>> a good starting point, and should be done anyway.  You could also try
>> specifying zeros to force all filesystem write IOs to be 4KB, i.e. no
>> alignment.
>>
>> Also, your log was created with a stripe unit alignment of 4KB, which is
>> 128 times smaller than your chunk.  The default value is zero, which
>> means use 4KB IOs.  This shouldn't be a problem, but I do wonder why you
>> manually specified a value equal to the default.
>>
>> mkfs.xfs automatically reads the stripe geometry from md and sets
>> sunit/swidth correctly (assuming non-nested arrays).  Why did you
>> specify these manually?
> 
> It is said to trust mkfs.xfs, that's what I did. No options have been
> specified by me and mkfs.xfs guessed everything by itself.

So the mkfs.xfs defaults in Wheezy did this.  Maybe I'm missing
something WRT the md/RAID10 near2 layout.  I know the alternate layouts
can play tricks with the resulting stripe width but I'm not sure if
that's the case here.  The log sunit of 8 blocks may be due to your
chunk being 512KB, which IIRC is greater than the XFS allowed maximum
for the log.  Hence it may have been dropped to 4KB for this reason.

>>> The issue is that disk access is very slow and I cannot spot why. Here
>>> is some data when I try to access the file system.
>>>
>>>
>>>         # dd if=/dev/zero of=/srv/test.zero bs=512K count=6000
>>>         6000+0 records in
>>>         6000+0 records out
>>>         3145728000 bytes (3.1 GB) copied, 82.2142 s, 38.3 MB/s
>>>         
>>>         # dd if=/srv/store/video/test.zero of=/dev/null
>>>         6144000+0 records in
>>>         6144000+0 records out
>>>         3145728000 bytes (3.1 GB) copied, 12.0893 s, 260 MB/s
>>
>> What percent of the filesystem space is currently used?
> 
> Very small, 3GB / 6TB, something like 0.05%.

So the low write speed shouldn't be related to free space fragmentation.

>>>         First run:
>>>         $ time ls /srv/files
>>>         [...]
>>>         real	9m59.609s
>>>         user	0m0.408s
>>>         sys	0m0.176s
>>
>> This is a separate problem and has nothing to do with the hardware, md,
>> or XFS.  I assisted with a similar, probably identical, ls completion
>> time issue last week on the XFS list.  I'd guess you're storing user and
>> group data on a remote LDAP server and it is responding somewhat slowly.
>>  Use 'strace -T' with ls and you'll see lots of poll calls and the time
>> taken by each.  17,189 files at 35ms avg latency per LDAP query yields
>> 10m02s, if my math is correct, so 35ms is your current avg latency per
>> query.  Be aware that even if you get the average LDAP latency per file
>> down to 2ms, you're still looking at 34s for ls to complete on this
>> directory.  Much better than 10 minutes, but nothing close to the local
>> speed you're used to.
>>
>>>         Second run:
>>>         $ time ls /srv/files
>>>         [...]
>>>         real	0m0.257s
>>>         user	0m0.108s
>>>         sys	0m0.088s
>>
>> Here the LDAP data has been cached.  Wait an hour, run ls again, and
>> it'll be slow again.
>>
>>>         $ ls -l /srv/files | wc -l
>>>         17189
>>
>>> I guess the controller is what's is blocking here as I encounter the
>>> issue only on servers where it is installed. I tried many settings like
>>> enabling or disabling cache but nothing changed.
> 
> Just using the old good `/etc/passwd` and `/etc/group` files here. There
> is no special permissions configuration.

You'll need to run "strace -T ls -l" to determine what's eating all the
time.  The user and kernel code is taking less than 0.5s combined.  The
other 9m58s is spent waiting on something.  You need to identify that.

This is interesting.  You have low linear write speed to a file with dd,
yet also horrible latency with a read operation.

Do you see any errors in dmesg relating to the Areca, or anything else?

>> The controller is not the cause of the 10 minute ls delay.  If you see
>> the ls delay only on servers with this controller it is coincidence.
>> The cause lay elsewhere.
>>
>> Areca are pretty crappy controllers generally, but I doubt they're at
>> fault WRT your low write throughput, though it is possible.
> 
> Well I have issues only on those servers. Strange enough.

Yes, this is a strange case thus far.

Do you also see the low write speed and slow ls on md0, any/all of your
md/RAID10 arrays?


> I see however that I messed the outputs concerning the filesystem
> details. Let me put everything in order.
> 
> 
> Server 1
> --------
> 
> # xfs_info /dev/md3
> meta-data=/dev/mapper/data-video isize=256    agcount=33, agsize=50331520 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=1610612736, imaxpct=5
>          =                       sunit=128    swidth=256 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> # mdadm -D /dev/md3
> /dev/md3:
>         Version : 1.2
>   Creation Time : Thu Oct 24 14:33:59 2013
>      Raid Level : raid10
>      Array Size : 7813770240 (7451.79 GiB 8001.30 GB)
>   Used Dev Size : 3906885120 (3725.90 GiB 4000.65 GB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
> 
>     Update Time : Fri Nov 22 12:30:20 2013
>           State : clean 
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : near=2
>      Chunk Size : 512K
> 
>            Name : srv1:data  (local to host srv1)
>            UUID : ea612767:5870a6f5:38e8537a:8fd03631
>          Events : 22
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       33        0      active sync   /dev/sdc1
>        1       8       49        1      active sync   /dev/sdd1
>        2       8       65        2      active sync   /dev/sde1
>        3       8       81        3      active sync   /dev/sdf1
> 
> # grep md3 /etc/fstab
> /dev/md3        /srv        xfs        defaults,inode64        0        0
> 
> 
> Server 2
> --------
> 
> # xfs_info /dev/md0
> meta-data=/dev/md0               isize=256    agcount=32, agsize=30523648 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=976755712, imaxpct=5
>          =                       sunit=256    swidth=512 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=476936, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> # mdadm -D /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Thu Nov  8 11:20:57 2012
>      Raid Level : raid10
>      Array Size : 3907022848 (3726.03 GiB 4000.79 GB)
>   Used Dev Size : 1953511424 (1863.01 GiB 2000.40 GB)
>    Raid Devices : 4
>   Total Devices : 5
>     Persistence : Superblock is persistent
> 
>     Update Time : Mon Nov 25 08:37:33 2013
>           State : active 
>  Active Devices : 4
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 1
> 
>          Layout : near=2
>      Chunk Size : 1024K
> 
>            Name : srv2:0
>            UUID : 0bb3f599:e414f7ae:0ba93fa2:7a2b4e67
>          Events : 280490
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       17        0      active sync   /dev/sdb1
>        1       8       33        1      active sync   /dev/sdc1
>        2       8       49        2      active sync   /dev/sdd1
>        5       8       65        3      active sync   /dev/sde1
> 
>        4       8       81        -      spare   /dev/sdf1
> 
> # grep md0 /etc/fstab
> /dev/md0        /srv       noatime,nodev,nosuid,noexec,inode64        0        0

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
