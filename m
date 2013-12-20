Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CCC1F29DF8
	for <xfs@oss.sgi.com>; Fri, 20 Dec 2013 04:29:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B5F908F8064
	for <xfs@oss.sgi.com>; Fri, 20 Dec 2013 02:29:23 -0800 (PST)
Received: from mail.pzystorm.de (mail.pzystorm.de [147.172.2.110]) by
	cuda.sgi.com with ESMTP id Z0A4nUGznGlboJ3I (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Dec 2013 02:29:18 -0800 (PST)
Received: from [147.172.250.17]
	by mail.pzystorm.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76) (envelope-from <xfs@pzystorm.de>)
	id 1VtxKU-0000Pa-L8; Fri, 20 Dec 2013 11:29:14 +0100
Message-ID: <52B41B67.9030308@pzystorm.de>
Date: Fri, 20 Dec 2013 11:26:47 +0100
From: Kevin Richter <xfs@pzystorm.de>
MIME-Version: 1.0
Subject: Re: XFS blocked task in xlog_cil_force_lsn
References: <52B102FF.8040404@pzystorm.de> <52B118A9.8080905@hardwarefreak.com>
	<52B178AA.6040302@pzystorm.de> <52B2FE9E.50307@hardwarefreak.com>
In-Reply-To: <52B2FE9E.50307@hardwarefreak.com>
Reply-To: xfs@pzystorm.de
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
To: stan@hardwarefreak.com, xfs@oss.sgi.com

Thanks a lot for your huge replies!

> Oh, that's quite old. I'd suggest upgrading to a much more recent
> kernel as we've fixed lots of issues in this area since then.

First I have switched to the newer kernel from Ubuntu Saucy:
$ uname -a
Linux 3.11.0-14-generic #21~precise1-Ubuntu SMP

Thus, it seems that the default scheduler has been changed to deadline.
I did not change anything. After a reboot the schedulers of all disks
are now deadline.

> Model # of the CPUs so I can look up the specs?
Intel(R) Xeon(R) CPU E5-2609 0 @ 2.40GHz

I have prepared a folder with 60GB for the tests. This is nearly twice
of the available memory, so the process should be forced to actually
write the stuff to the disk - and not only hold in the memory.

> $ echo 256 > /sys/block/md2/md/stripe_cache_size
> $ time cp -a /olddisk/testfolder /6tb/foo1/
> real    25m38.925s
> user    0m0.595s
> sys     1m23.182s
>
> $ echo 1024 > /sys/block/md2/md/stripe_cache_size
> $ time cp -a /olddisk/testfolder /raid/foo2/
> real    7m32.824s
> user    0m0.438s
> sys     1m6.759s
> 
> $ echo 2048 > /sys/block/md2/md/stripe_cache_size
> $ time cp -a /olddisk/testfolder /raid/foo3/
> real    5m32.847s
> user    0m0.418s
> sys     1m5.671s
> 
> $ echo 4096 > /sys/block/md2/md/stripe_cache_size
> $ time cp -a /olddisk/testfolder /raid/foo4/
> real    5m54.554s
> user    0m0.437s
> sys     1m6.268s

The difference is really amazing! So 2048 seems to be the best choice.
60GB in 5,5minutes are 180MB/sek. That sounds a bit high, doesnt it?
The RAID only consist of 5 SATA disks with 7200rpm.

'top' while copying with stripe size of 2048 (the source disk is ntfs):
> top - 10:48:24 up 1 day,  1:41,  2 users,  load average: 5.66, 3.53, 2.17
> Tasks: 210 total,   2 running, 208 sleeping,   0 stopped,   0 zombie
> Cpu(s):  0.1%us, 35.8%sy,  0.0%ni, 46.0%id, 17.9%wa,  0.0%hi,  0.2%si,  0.0%st
> Mem:  32913992k total, 32709208k used,   204784k free, 10770344k buffers
> Swap:  7812496k total,        0k used,  7812496k free, 20866844k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 19524 root      20   0     0    0    0 R   93  0.0   4:00.12 kworker/3:1
> 23744 root      20   0     0    0    0 S   55  0.0   0:50.84 kworker/0:1
> 23738 root      20   0     0    0    0 S   29  0.0   0:56.94 kworker/4:0
>  3893 root      20   0     0    0    0 S   28  0.0  36:47.50 md2_raid6
>  4551 root      20   0 22060 3328  720 D   25  0.0  20:21.61 mount.ntfs
> 23273 root      20   0     0    0    0 S   22  0.0   1:54.86 kworker/7:2
> 23734 root      20   0 21752 1280 1040 D   21  0.0   0:49.84 cp
>    84 root      20   0     0    0    0 S    7  0.0   8:19.34 kswapd1
>    83 root      20   0     0    0    0 S    6  0.0  11:55.81 kswapd0
> 23745 root      20   0     0    0    0 S    2  0.0   0:33.60 kworker/1:2
> 21598 root      20   0     0    0    0 D    1  0.0   0:11.33 kworker/u17:1


And the best thing at all:
While all of these tests there are no warnings/panics in the syslog.


With best regards,
Kevin



Am 19.12.2013 15:11, schrieb Stan Hoeppner:
> On 12/18/2013 4:27 AM, Kevin Richter wrote:
>> Thanks for your mails!
>>
>>> This is unusual. How long have you waited?
>>
>> For the reboot? One night.
>> After the copy process hangs: several hours. But mostly it recovers
>> after several minutes.
>>
>>> 1.  Switch to deadline.  CFQ is not suitable for RAID storage, and not
>>> suitable for XFS.  This may not be a silver bullet but it will help.
>>
>> Can I switch it while my copy process (from a separate hd to this raid)
>> is running... without data loss? Otherwise I would wait a bit, because
>> now it is actually running for 8 hours without kernel panics.
> 
> Yes, you can safely change the elevator on the fly.  Repeat the
> following once for each disk, replacing X appropriately.
> 
> $ echo deadline > /sys/block/sdX/queue/scheduler
> 
> This on the fly change is not permanent.  Add "elevator=deadline" to
> your kernel command line in your bootloader config file.  Or you can add
> the commands to a startup script.  Or if you build your own kernels
> simply make it the default, and/or remove all the other elevators from
> your kernel config, which is what I do.
> 
>>> 2.  Post your chunk size and RAID6 stripe_cache_size value.  They may be
>>> sub optimal for your workload.
>>
>> $ cat /sys/block/md2/md/stripe_cache_size
>> 256
> 
> 256 is the default and it is way too low.  This is limiting your write
> througput.  Increase this to a minimum of 1024 which will give you a
> 20MB stripe cache buffer.  This should become active immediately.  Add
> it to a startup script to make it permanent.
> 
> $ echo 1024 > /sys/block/md2/md/stripe_cache_size
> 
> ((4096*stripe-cache_size)*num_drives)= RAM consumed for stripe cache
> 
> At some future point when the system is idle, play with FIO write
> testing and multiple jobs (threads) with stripe_cache_size values up to
> 2048 to see which value gives the best throughput.  Test 1024, 2048,
> 4096.  Going higher probably won't gain anything.  And at some point as
> you go higher your throughput will decrease.  When you see that, select
> the previous value and make it permanent.
> 
>> $ mdadm --detail /dev/md2 | grep Chunk
>> Chunk Size : 512K
>>
>>> 3.  Post 'xfs_info /dev/mdX'
>>
>> There is a LUKS volume around /dev/md2, named '6tb'.
> 
> Ok, this adds a huge fly to the ointment.  LUKS is single threaded per
> device.  You've encrypted the md device instead of the individual disks.
>  This limits your encryption throughput to a single CPU core.  You've
> not provided any data on your LUKS thread.  Is it pegging a core during
> large file IO?  I'd bet it is.  That would explain all of this.
> 
>>> $ xfs_info /dev/md2
>>> xfs_info: /dev/md2 is not a mounted XFS filesystem
>>> $ xfs_info /dev/mapper/6tb
>>> meta-data=/dev/mapper/6tb        isize=256    agcount=32, agsize=45631360 blks
>>>          =                       sectsz=512   attr=2
>>> data     =                       bsize=4096   blocks=1460203520, imaxpct=5
>>>          =                       sunit=128    swidth=384 blks
>>> naming   =version 2              bsize=4096   ascii-ci=0
>>> log      =internal               bsize=4096   blocks=521728, version=2
>>>          =                       sectsz=512   sunit=8 blks, lazy-count=1
>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> md2 is 5 spindle RAID6, geometry 512KB * 3 = 1.5MB stripe width.  The
> XFS alignment matches the md device.  This may be hurting you with LUKS
> between XFS and md.  I don't know how LUKS handles 1.5MB inbound writes
> and if it passes an aligned write to md after encrypting.  I also don't
> know how it handles writes barriers passed down the stack by XFS, or if
> it does at all.
> 
>>> 4.  You're getting a lot of kswapd timeouts because you have swap and
>>> the md/RAID6 array on the same disks.  Relocate swap to disks that are
>>> not part of this RAID6.  Small SSDs are cheap and fast.  Buy one and put
>>> swap on it.  Or install more RAM in the machine.  Going the SSD route is
>>> better as it gives flexibility.  For instance, you can also relocate
>>> your syslog files to it and anything else that does IO without eating
>>> lots of space.  This decreases the IOPS load on your rust.
>>
>> No no, swap is not on any of the raid disks.
>>
>>> # cat /proc/swaps
>>> Filename                                Type            Size    Used    Priority
>>> /dev/sda3                               partition       7812496 0       -1
>> sda is not in the raid. In the raid there are sd[cdefg].
> 
> I was wrong here.  After reading a little about kswapd I now know it
> doesn't simply move pages to/from disk.  It frees memory in other ways
> as well.  In this case it's apparently waiting to free an inode being
> reclaimed by xfs_reclaim_inode, which is stalled on lower level IO.  So
> kswapd times out as a result.  A slow LUKS thread would explain this as
> well.
> 
>>> 5.  Describe in some detail the workload(s) causing the heavy IO, and
>>> thus these timeouts.
>>
>> cd /olddharddisk
>> cp -av . /raid/
>>
>> oldhardddisk is a mounted 1tb old harddisk, /raid is the 6tb raid from
>> above.
> 
> So you are simply doing a huge file copy from an apparently slower
> single disk to an apparently faster striped RAID.  But you get horrible
> throughput and kernel timeout errors, and the RAID disks are apparently
> fairly idle.
> 
>> Heavy workload while this copy process (2 CPUs, each 4 cores):
> 
> Model # of the CPUs so I can look up the specs?
> 
>>> top - 11:13:37 up 4 days, 21:32,  2 users,  load average: 12.95, 11.33, 10.32
>>> Tasks: 155 total,   2 running, 153 sleeping,   0 stopped,   0 zombie
>>> Cpu(s):  0.0%us,  5.7%sy,  0.0%ni, 82.1%id, 11.8%wa,  0.0%hi,  0.3%si,  0.0%st
>>> Mem:  32916276k total, 32750240k used,   166036k free, 10076760k buffers
>>> Swap:  7812496k total,        0k used,  7812496k free, 21221136k cached
>>>
>>>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>>>   699 root      20   0     0    0    0 S   11  0.0 248:17.59 md2_raid6
>>
>> Dont know what consumes all of this 32GB RAM... 'top' sorted by memory
>> consumption does not tell me. All entries are only 0.0% and 0.1%
> 
> ~30GB of your RAM is being eaten by filesystem metadata buffers (10GB)
> and page cache (20GB).  Linux uses nearly all free memory for cache and
> buffers to prevent disk accesses, which speeds up access to frequently
> used data considerably.  This is normal.  A huge copy like this is going
> to cause a huge amount caching.
> 
> I assume this 1TB file copy has finally completed.  Start another large
> test copy and paste the CPU burn for the LUKS thread so we can confirm
> whether this is the root cause of your problem.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
