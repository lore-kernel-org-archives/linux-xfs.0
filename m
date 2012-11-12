Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACDuGQf227224 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 07:56:17 -0600
Received: from galenis.iv.lt (galenis.iv.lt [195.14.170.242]) by cuda.sgi.com
	with ESMTP id UyrCQaHII2eyTusb (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 05:58:17 -0800 (PST)
Received: from fwdr-2.fwdr-0.fwdr-168.fwdr-192 ([192.168.0.2]
	helo=galenis.iv.lt) by galenis.iv.lt with esmtp (Exim 4.72)
	(envelope-from <linas.j@iv.lt>) id 1TXuWl-0006YI-Ng
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 15:58:15 +0200
Message-ID: <50A10077.2060908@iv.lt>
Date: Mon, 12 Nov 2012 15:58:15 +0200
From: Linas Jankauskas <linas.j@iv.lt>
MIME-Version: 1.0
Subject: Re: Slow performance after ~4.5TB
References: <50A0AFD5.2020607@iv.lt> <20121112090448.GS24575@dastard>
	<50A0C590.6020602@iv.lt> <20121112123222.GT24575@dastard>
In-Reply-To: <20121112123222.GT24575@dastard>
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
To: xfs@oss.sgi.com

Hi,

/dev is automaticaly mounted by automount and it is always equal to half 
physical memory.


RAID geometry:
  Logical Drive: 1
          Size: 20.0 TB
          Fault Tolerance: RAID 5
          Heads: 255
          Sectors Per Track: 32
          Cylinders: 65535
          Strip Size: 64 KB
          Status: OK
          Array Accelerator: Enabled
          Parity Initialization Status: Initialization Completed
          Unique Identifier: 600508B100104B395357373043370015
          Disk Name: /dev/sda
          Mount Points: /boot 128 MB, / 1024 MB, /usr 4.0 GB, /var 20.0 TB
          Logical Drive Label: A01365ABP61630K9SW70C7D093



Here is output of perf top:

18.42%  [kernel]            [k] _spin_lock
  16.07%  [xfs]               [k] xfs_alloc_busy_trim
  10.46%  [xfs]               [k] xfs_alloc_get_rec
   9.46%  [xfs]               [k] xfs_btree_get_rec
   8.38%  [xfs]               [k] xfs_btree_increment
   8.31%  [xfs]               [k] xfs_alloc_ag_vextent_near
   6.82%  [xfs]               [k] xfs_btree_get_block
   5.72%  [xfs]               [k] xfs_alloc_compute_aligned
   4.01%  [xfs]               [k] xfs_btree_readahead
   3.53%  [xfs]               [k] xfs_btree_rec_offset
   2.92%  [xfs]               [k] xfs_btree_rec_addr
   1.30%  [xfs]               [k] _xfs_buf_find


strace of rsync process:

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
  99.99   18.362863      165431       111           ftruncate
   0.00    0.000712           3       224       112 open
   0.00    0.000195           1       257           write
   0.00    0.000171           1       250           read
   0.00    0.000075           1       112           lchown
   0.00    0.000039           0       112           lstat
   0.00    0.000028           0       112           close
   0.00    0.000021           0       112           chmod
   0.00    0.000011           0       396           select
   0.00    0.000000           0       112           utimes
------ ----------- ----------- --------- --------- ----------------
100.00   18.364115                  1798       112 total


Linas

On 11/12/2012 02:32 PM, Dave Chinner wrote:
> On Mon, Nov 12, 2012 at 11:46:56AM +0200, Linas Jankauskas wrote:
>>
>> Servers are HP dl180 g6
>> OS centos 6.3 x86_64
>>
>> CPU
>> 2x Intel(R) Xeon(R) CPU           L5630  @ 2.13GHz
>>
>> uname -r
>> 2.6.32-279.5.2.el6.x86_64
>>
>> xfs_repair -V
>> xfs_repair version 3.1.1
>>
>>
>> cat /proc/meminfo
>> MemTotal:       12187500 kB
>> MemFree:          153080 kB
>> Buffers:         6400308 kB
>
> That looks strange - 6GB of buffers? That's block device cached
> pages, and XFS doesn't use the block device for caching. You don't
> have much in the way of ext4 filesystems, either, so i don't thik
> that is responsible.
>
>> cat /proc/mounts
>> rootfs / rootfs rw 0 0
>> proc /proc proc rw,relatime 0 0
>> sysfs /sys sysfs rw,relatime 0 0
>> devtmpfs /dev devtmpfs
>> rw,relatime,size=6084860k,nr_inodes=1521215,mode=755 0 0
>
> A 6GB devtmpfs? That seems unusual. What is the purpose of having a
> 6GB ramdisk mounting on /dev?  I wonder if that is consuming all
> that buffer space....
>
>>        logicaldrive 1 (20.0 TB, RAID 5, OK)
>>
>>        physicaldrive 1I:1:1 (port 1I:box 1:bay 1, SATA, 2 TB, OK)
>>        physicaldrive 1I:1:2 (port 1I:box 1:bay 2, SATA, 2 TB, OK)
>>        physicaldrive 1I:1:3 (port 1I:box 1:bay 3, SATA, 2 TB, OK)
>>        physicaldrive 1I:1:4 (port 1I:box 1:bay 4, SATA, 2 TB, OK)
>>        physicaldrive 1I:1:5 (port 1I:box 1:bay 5, SATA, 2 TB, OK)
>>        physicaldrive 1I:1:6 (port 1I:box 1:bay 6, SATA, 2 TB, OK)
>>        physicaldrive 1I:1:7 (port 1I:box 1:bay 7, SATA, 2 TB, OK)
>>        physicaldrive 1I:1:8 (port 1I:box 1:bay 8, SATA, 2 TB, OK)
>>        physicaldrive 1I:1:9 (port 1I:box 1:bay 9, SATA, 2 TB, OK)
>>        physicaldrive 1I:1:10 (port 1I:box 1:bay 10, SATA, 2 TB, OK)
>>        physicaldrive 1I:1:11 (port 1I:box 1:bay 11, SATA, 2 TB, OK)
>>        physicaldrive 1I:1:12 (port 1I:box 1:bay 12, SATA, 2 TB, OK)
>
> OK, so RAID5, but it doesn't tell me the geometry of it.
>
>> xfs_info /var
>> meta-data=/dev/sda5              isize=256    agcount=20,
>> agsize=268435455 blks
>>           =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=5368633873, imaxpct=5
>>           =                       sunit=0      swidth=0 blks
>
> And no geometry here, either.
>
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal               bsize=4096   blocks=521728, version=2
>>           =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>> No dmesg errors.
>>
>> vmstat 5
>> procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
>>   r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
>>   1  0   2788 150808 6318232 2475332    0    0   836   185    2    4 1 11 87  1  0
>>   1  0   2788 150608 6318232 2475484    0    0     0    89 1094  126 0 12 88  0  0
>>   1  0   2788 150500 6318232 2475604    0    0     0    60 1109   99 0 12 88  0  0
>>   1  0   2788 150252 6318232 2475720    0    0     0    49 1046   79 0 12 88  0  0
>>   1  0   2788 150344 6318232 2475844    0    0     1   157 1046   82 0 12 88  0  0
>>   1  0   2788 149972 6318232 2475960    0    0     0   197 1086  144 0 12 88  0  0
>>   1  0   2788 150020 6318232 2476088    0    0     0    76 1115   99 0 12 88  0  0
>>   1  0   2788 150012 6318232 2476204    0    0     0    81 1131  132 0 12 88  0  0
>>   1  0   2788 149624 6318232 2476340    0    0     0    53 1074   95 0 12 88  0  0
>
> basically idle, but burning a CPu in system time.
>
>> iostat -x -d -m 5
>> Linux 2.6.32-279.5.2.el6.x86_64 (storage)     11/12/2012
>> _x86_64_  (8 CPU)
>>
>> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
>> sda             103.27     1.51   92.43   37.65     6.52     1.44   125.36     0.73    5.60   1.13  14.74
>> sda               0.00     0.20    2.40   19.80     0.01     0.09     9.08     0.13    5.79   2.25   5.00
>> sda               0.00     3.60    0.60   36.80     0.00     4.15   227.45     0.12    3.21   0.64   2.38
>> sda               0.00     0.40    1.20   36.80     0.00     8.01   431.83     0.11    3.00   1.05   4.00
>> sda               0.00     0.60    0.00   20.60     0.00     0.08     8.39     0.01    0.69   0.69   1.42
>> sda               0.00    38.40    4.20   27.40     0.02     0.27    18.34     0.25    8.06   2.63   8.32
>
> Again, pretty much idle.
>
> So, it's not doing IO, it's not thrashing caches, so what is burning
> cpu? Can you take a profile? maybe just run 'perf top' for 15s and
> then just paste the top 10 samples?
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
