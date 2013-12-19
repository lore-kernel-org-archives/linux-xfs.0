Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 20CA87F3F
	for <xfs@oss.sgi.com>; Thu, 19 Dec 2013 08:11:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0A2E98F8040
	for <xfs@oss.sgi.com>; Thu, 19 Dec 2013 06:11:35 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id c9vylNXOBFRzkxsL
	for <xfs@oss.sgi.com>; Thu, 19 Dec 2013 06:11:35 -0800 (PST)
Message-ID: <52B2FE9E.50307@hardwarefreak.com>
Date: Thu, 19 Dec 2013 08:11:42 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS blocked task in xlog_cil_force_lsn
References: <52B102FF.8040404@pzystorm.de> <52B118A9.8080905@hardwarefreak.com>
	<52B178AA.6040302@pzystorm.de>
In-Reply-To: <52B178AA.6040302@pzystorm.de>
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
To: xfs@pzystorm.de, xfs@oss.sgi.com

On 12/18/2013 4:27 AM, Kevin Richter wrote:
> Thanks for your mails!
> 
>> This is unusual. How long have you waited?
> 
> For the reboot? One night.
> After the copy process hangs: several hours. But mostly it recovers
> after several minutes.
> 
>> 1.  Switch to deadline.  CFQ is not suitable for RAID storage, and not
>> suitable for XFS.  This may not be a silver bullet but it will help.
> 
> Can I switch it while my copy process (from a separate hd to this raid)
> is running... without data loss? Otherwise I would wait a bit, because
> now it is actually running for 8 hours without kernel panics.

Yes, you can safely change the elevator on the fly.  Repeat the
following once for each disk, replacing X appropriately.

$ echo deadline > /sys/block/sdX/queue/scheduler

This on the fly change is not permanent.  Add "elevator=deadline" to
your kernel command line in your bootloader config file.  Or you can add
the commands to a startup script.  Or if you build your own kernels
simply make it the default, and/or remove all the other elevators from
your kernel config, which is what I do.

>> 2.  Post your chunk size and RAID6 stripe_cache_size value.  They may be
>> sub optimal for your workload.
> 
> $ cat /sys/block/md2/md/stripe_cache_size
> 256

256 is the default and it is way too low.  This is limiting your write
througput.  Increase this to a minimum of 1024 which will give you a
20MB stripe cache buffer.  This should become active immediately.  Add
it to a startup script to make it permanent.

$ echo 1024 > /sys/block/md2/md/stripe_cache_size

((4096*stripe-cache_size)*num_drives)= RAM consumed for stripe cache

At some future point when the system is idle, play with FIO write
testing and multiple jobs (threads) with stripe_cache_size values up to
2048 to see which value gives the best throughput.  Test 1024, 2048,
4096.  Going higher probably won't gain anything.  And at some point as
you go higher your throughput will decrease.  When you see that, select
the previous value and make it permanent.

> $ mdadm --detail /dev/md2 | grep Chunk
> Chunk Size : 512K
> 
>> 3.  Post 'xfs_info /dev/mdX'
> 
> There is a LUKS volume around /dev/md2, named '6tb'.

Ok, this adds a huge fly to the ointment.  LUKS is single threaded per
device.  You've encrypted the md device instead of the individual disks.
 This limits your encryption throughput to a single CPU core.  You've
not provided any data on your LUKS thread.  Is it pegging a core during
large file IO?  I'd bet it is.  That would explain all of this.

>> $ xfs_info /dev/md2
>> xfs_info: /dev/md2 is not a mounted XFS filesystem
>> $ xfs_info /dev/mapper/6tb
>> meta-data=/dev/mapper/6tb        isize=256    agcount=32, agsize=45631360 blks
>>          =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=1460203520, imaxpct=5
>>          =                       sunit=128    swidth=384 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal               bsize=4096   blocks=521728, version=2
>>          =                       sectsz=512   sunit=8 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0

md2 is 5 spindle RAID6, geometry 512KB * 3 = 1.5MB stripe width.  The
XFS alignment matches the md device.  This may be hurting you with LUKS
between XFS and md.  I don't know how LUKS handles 1.5MB inbound writes
and if it passes an aligned write to md after encrypting.  I also don't
know how it handles writes barriers passed down the stack by XFS, or if
it does at all.

>> 4.  You're getting a lot of kswapd timeouts because you have swap and
>> the md/RAID6 array on the same disks.  Relocate swap to disks that are
>> not part of this RAID6.  Small SSDs are cheap and fast.  Buy one and put
>> swap on it.  Or install more RAM in the machine.  Going the SSD route is
>> better as it gives flexibility.  For instance, you can also relocate
>> your syslog files to it and anything else that does IO without eating
>> lots of space.  This decreases the IOPS load on your rust.
> 
> No no, swap is not on any of the raid disks.
> 
>> # cat /proc/swaps
>> Filename                                Type            Size    Used    Priority
>> /dev/sda3                               partition       7812496 0       -1
> sda is not in the raid. In the raid there are sd[cdefg].

I was wrong here.  After reading a little about kswapd I now know it
doesn't simply move pages to/from disk.  It frees memory in other ways
as well.  In this case it's apparently waiting to free an inode being
reclaimed by xfs_reclaim_inode, which is stalled on lower level IO.  So
kswapd times out as a result.  A slow LUKS thread would explain this as
well.

>> 5.  Describe in some detail the workload(s) causing the heavy IO, and
>> thus these timeouts.
> 
> cd /olddharddisk
> cp -av . /raid/
> 
> oldhardddisk is a mounted 1tb old harddisk, /raid is the 6tb raid from
> above.

So you are simply doing a huge file copy from an apparently slower
single disk to an apparently faster striped RAID.  But you get horrible
throughput and kernel timeout errors, and the RAID disks are apparently
fairly idle.

> Heavy workload while this copy process (2 CPUs, each 4 cores):

Model # of the CPUs so I can look up the specs?

>> top - 11:13:37 up 4 days, 21:32,  2 users,  load average: 12.95, 11.33, 10.32
>> Tasks: 155 total,   2 running, 153 sleeping,   0 stopped,   0 zombie
>> Cpu(s):  0.0%us,  5.7%sy,  0.0%ni, 82.1%id, 11.8%wa,  0.0%hi,  0.3%si,  0.0%st
>> Mem:  32916276k total, 32750240k used,   166036k free, 10076760k buffers
>> Swap:  7812496k total,        0k used,  7812496k free, 21221136k cached
>>
>>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>>   699 root      20   0     0    0    0 S   11  0.0 248:17.59 md2_raid6
> 
> Dont know what consumes all of this 32GB RAM... 'top' sorted by memory
> consumption does not tell me. All entries are only 0.0% and 0.1%

~30GB of your RAM is being eaten by filesystem metadata buffers (10GB)
and page cache (20GB).  Linux uses nearly all free memory for cache and
buffers to prevent disk accesses, which speeds up access to frequently
used data considerably.  This is normal.  A huge copy like this is going
to cause a huge amount caching.

I assume this 1TB file copy has finally completed.  Start another large
test copy and paste the CPU burn for the LUKS thread so we can confirm
whether this is the root cause of your problem.

-- 
Stan



> 
> 
> 
> Thanks,
> Kevin
> 
> 
> 
> 
> Am 18.12.2013 04:38, schrieb Stan Hoeppner:
>> On 12/17/2013 8:05 PM, Kevin Richter wrote:
>>> Hi,
>>>
>>> around April 2012 there was a similar thread on this list which I have
>>> found via Google, so my mail topic is the same.
>>>
>>> I have a RAID6 array with 5 disks (each 2TB, net: 6TB). While copying
>>> under heavy load there are always these blocks. At the bottom of this
>>> message I have included some line from the syslog.
>>>
>>> Even a reboot is now not possible anymore, because the whole system
>>> hangs while executing the "sync" command in one of the shutdown scripts.
>>>
>>> So... first I have thought that my disks are faulty.
>>> But with smartmontools I have started a short and a long test on all of
>>> the 5 disks: no errors
>>>
>>> Then I have even recreated the whole array, but no improvement.
>>>
>>> Details about my server: 3.2.0-57-generic, Ubuntu 12.04.3 LTS
>>> Details about the array: soft array with mdadm v3.2.5, no hardware raid
>>> controller in the server
>>>
>>> The scheduler of the raid disks:
>>>> $ cat /sys/block/sd[cdefg]/queue/scheduler
>>>> noop deadline [cfq]
>>>> noop deadline [cfq]
>>>> noop deadline [cfq]
>>>> noop deadline [cfq]
>>>> noop deadline [cfq]
>>>
>>>
>>> Any ideas what I can do?
>>
>> Your workload is seeking the disks to death, which is why you're getting
>> these timeouts.  The actuators simply can't keep up.
>>
>> 1.  Switch to deadline.  CFQ is not suitable for RAID storage, and not
>> suitable for XFS.  This may not be a silver bullet but it will help.
>>
>> 2.  Post your chunk size and RAID6 stripe_cache_size value.  They may be
>> sub optimal for your workload.  For the latter
>>
>> $ cat /sys/block/mdX/md/stripe_cache_size
>>
>> 3.  Post 'xfs_info /dev/mdX'
>>
>> 4.  You're getting a lot of kswapd timeouts because you have swap and
>> the md/RAID6 array on the same disks.  Relocate swap to disks that are
>> not part of this RAID6.  Small SSDs are cheap and fast.  Buy one and put
>> swap on it.  Or install more RAM in the machine.  Going the SSD route is
>> better as it gives flexibility.  For instance, you can also relocate
>> your syslog files to it and anything else that does IO without eating
>> lots of space.  This decreases the IOPS load on your rust.
>>
>> 5.  Describe in some detail the workload(s) causing the heavy IO, and
>> thus these timeouts.
>>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
