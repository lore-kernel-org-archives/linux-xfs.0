Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2611D7F3F
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 04:29:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 06EE2304043
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 02:29:15 -0800 (PST)
Received: from mail.pzystorm.de (mail.pzystorm.de [147.172.2.110]) by
	cuda.sgi.com with ESMTP id ddyVnG4Mw5OXEE0N (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Dec 2013 02:29:13 -0800 (PST)
Received: from [147.172.250.17]
	by mail.pzystorm.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76) (envelope-from <xfs@pzystorm.de>) id 1VtENK-0005je-Hc
	for xfs@oss.sgi.com; Wed, 18 Dec 2013 11:29:10 +0100
Message-ID: <52B178AA.6040302@pzystorm.de>
Date: Wed, 18 Dec 2013 11:27:54 +0100
From: Kevin Richter <xfs@pzystorm.de>
MIME-Version: 1.0
Subject: Re: XFS blocked task in xlog_cil_force_lsn
References: <52B102FF.8040404@pzystorm.de> <52B118A9.8080905@hardwarefreak.com>
In-Reply-To: <52B118A9.8080905@hardwarefreak.com>
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
To: xfs@oss.sgi.com

Thanks for your mails!

> This is unusual. How long have you waited?

For the reboot? One night.
After the copy process hangs: several hours. But mostly it recovers
after several minutes.

> 1.  Switch to deadline.  CFQ is not suitable for RAID storage, and not
> suitable for XFS.  This may not be a silver bullet but it will help.

Can I switch it while my copy process (from a separate hd to this raid)
is running... without data loss? Otherwise I would wait a bit, because
now it is actually running for 8 hours without kernel panics.

> 2.  Post your chunk size and RAID6 stripe_cache_size value.  They may be
> sub optimal for your workload.

$ cat /sys/block/md2/md/stripe_cache_size
256
$ mdadm --detail /dev/md2 | grep Chunk
Chunk Size : 512K

> 3.  Post 'xfs_info /dev/mdX'

There is a LUKS volume around /dev/md2, named '6tb'.
> $ xfs_info /dev/md2
> xfs_info: /dev/md2 is not a mounted XFS filesystem
> $ xfs_info /dev/mapper/6tb
> meta-data=/dev/mapper/6tb        isize=256    agcount=32, agsize=45631360 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=1460203520, imaxpct=5
>          =                       sunit=128    swidth=384 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0


> 4.  You're getting a lot of kswapd timeouts because you have swap and
> the md/RAID6 array on the same disks.  Relocate swap to disks that are
> not part of this RAID6.  Small SSDs are cheap and fast.  Buy one and put
> swap on it.  Or install more RAM in the machine.  Going the SSD route is
> better as it gives flexibility.  For instance, you can also relocate
> your syslog files to it and anything else that does IO without eating
> lots of space.  This decreases the IOPS load on your rust.

No no, swap is not on any of the raid disks.

> # cat /proc/swaps
> Filename                                Type            Size    Used    Priority
> /dev/sda3                               partition       7812496 0       -1
sda is not in the raid. In the raid there are sd[cdefg].


> 5.  Describe in some detail the workload(s) causing the heavy IO, and
> thus these timeouts.

cd /olddharddisk
cp -av . /raid/

oldhardddisk is a mounted 1tb old harddisk, /raid is the 6tb raid from
above.

Heavy workload while this copy process (2 CPUs, each 4 cores):
> top - 11:13:37 up 4 days, 21:32,  2 users,  load average: 12.95, 11.33, 10.32
> Tasks: 155 total,   2 running, 153 sleeping,   0 stopped,   0 zombie
> Cpu(s):  0.0%us,  5.7%sy,  0.0%ni, 82.1%id, 11.8%wa,  0.0%hi,  0.3%si,  0.0%st
> Mem:  32916276k total, 32750240k used,   166036k free, 10076760k buffers
> Swap:  7812496k total,        0k used,  7812496k free, 21221136k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>   699 root      20   0     0    0    0 S   11  0.0 248:17.59 md2_raid6

Dont know what consumes all of this 32GB RAM... 'top' sorted by memory
consumption does not tell me. All entries are only 0.0% and 0.1%




Thanks,
Kevin




Am 18.12.2013 04:38, schrieb Stan Hoeppner:
> On 12/17/2013 8:05 PM, Kevin Richter wrote:
>> Hi,
>>
>> around April 2012 there was a similar thread on this list which I have
>> found via Google, so my mail topic is the same.
>>
>> I have a RAID6 array with 5 disks (each 2TB, net: 6TB). While copying
>> under heavy load there are always these blocks. At the bottom of this
>> message I have included some line from the syslog.
>>
>> Even a reboot is now not possible anymore, because the whole system
>> hangs while executing the "sync" command in one of the shutdown scripts.
>>
>> So... first I have thought that my disks are faulty.
>> But with smartmontools I have started a short and a long test on all of
>> the 5 disks: no errors
>>
>> Then I have even recreated the whole array, but no improvement.
>>
>> Details about my server: 3.2.0-57-generic, Ubuntu 12.04.3 LTS
>> Details about the array: soft array with mdadm v3.2.5, no hardware raid
>> controller in the server
>>
>> The scheduler of the raid disks:
>>> $ cat /sys/block/sd[cdefg]/queue/scheduler
>>> noop deadline [cfq]
>>> noop deadline [cfq]
>>> noop deadline [cfq]
>>> noop deadline [cfq]
>>> noop deadline [cfq]
>>
>>
>> Any ideas what I can do?
> 
> Your workload is seeking the disks to death, which is why you're getting
> these timeouts.  The actuators simply can't keep up.
> 
> 1.  Switch to deadline.  CFQ is not suitable for RAID storage, and not
> suitable for XFS.  This may not be a silver bullet but it will help.
> 
> 2.  Post your chunk size and RAID6 stripe_cache_size value.  They may be
> sub optimal for your workload.  For the latter
> 
> $ cat /sys/block/mdX/md/stripe_cache_size
> 
> 3.  Post 'xfs_info /dev/mdX'
> 
> 4.  You're getting a lot of kswapd timeouts because you have swap and
> the md/RAID6 array on the same disks.  Relocate swap to disks that are
> not part of this RAID6.  Small SSDs are cheap and fast.  Buy one and put
> swap on it.  Or install more RAM in the machine.  Going the SSD route is
> better as it gives flexibility.  For instance, you can also relocate
> your syslog files to it and anything else that does IO without eating
> lots of space.  This decreases the IOPS load on your rust.
> 
> 5.  Describe in some detail the workload(s) causing the heavy IO, and
> thus these timeouts.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
