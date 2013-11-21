Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B9F497F56
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 07:31:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A7D268F8052
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 05:31:40 -0800 (PST)
Received: from mail-ve0-f182.google.com (mail-ve0-f182.google.com
	[209.85.128.182]) by cuda.sgi.com with ESMTP id
	ETWVWZjLzrZN0WiZ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Nov 2013 05:31:39 -0800 (PST)
Received: by mail-ve0-f182.google.com with SMTP id jy13so1414986veb.41
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 05:31:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACtJ3HZAsOtmLArMWraygfQxpGymtZjr+a_reXv8o6LJzoMbvw@mail.gmail.com>
References: <CACtJ3HZxp6xEjY_wOucCcqX4scNzEGuiAsovQYObJS9whtYJsQ@mail.gmail.com>
	<528A5C45.4080906@redhat.com> <20131119005740.GY6188@dastard>
	<CACtJ3Ha3C7JNi5VZRnNMn+-okNheygmbj=j9AnUMvfzfZjNwug@mail.gmail.com>
	<20131121092606.GU11434@dastard>
	<CACtJ3HZAsOtmLArMWraygfQxpGymtZjr+a_reXv8o6LJzoMbvw@mail.gmail.com>
Date: Thu, 21 Nov 2013 08:31:38 -0500
Message-ID: <CACtJ3Ha5P2Heu4qiEEk6c4g+tKyR=RrD-4E-Cqj+bP8YDjKQ6w@mail.gmail.com>
Subject: Re: Filesystem writes on RAID5 too slow
From: Martin Boutin <martboutin@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, "Kernel.org-Linux-EXT4" <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

$ uname -a
Linux haswell1 3.10.10 #1 SMP PREEMPT Wed Oct 2 11:22:22 CEST 2013
i686 GNU/Linux

$ xfs_repair -V
xfs_repair version 3.1.4

$ cat /proc/cpuinfo | grep processor
processor    : 0
processor    : 1

$ mkfs.xfs -s size=4096 -f -l size=32m /dev/md0
$ mount -t xfs /dev/md0 /tmp/diskmnt/
$ dd if=/dev/zero of=/tmp/diskmnt/filewr.zero bs=1M count=1000 oflag=direct
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 28.0304 s, 37.4 MB/s

$ cat /proc/meminfo
MemTotal:        1313956 kB
MemFree:         1099936 kB
Buffers:           13232 kB
Cached:           141452 kB
SwapCached:            0 kB
Active:           128960 kB
Inactive:          55936 kB
Active(anon):      30548 kB
Inactive(anon):     1096 kB
Active(file):      98412 kB
Inactive(file):    54840 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:        626696 kB
HighFree:         452472 kB
LowTotal:         687260 kB
LowFree:          647464 kB
SwapTotal:         72256 kB
SwapFree:          72256 kB
Dirty:                 8 kB
Writeback:             0 kB
AnonPages:         30172 kB
Mapped:            15764 kB
Shmem:              1432 kB
Slab:              14720 kB
SReclaimable:       6632 kB
SUnreclaim:         8088 kB
KernelStack:        1792 kB
PageTables:         1176 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:      729232 kB
Committed_AS:     734116 kB
VmallocTotal:     327680 kB
VmallocUsed:       10192 kB
VmallocChunk:     294904 kB
DirectMap4k:       12280 kB
DirectMap4M:      692224 kB

$ cat /proc/mounts
(...)
/dev/md0 /tmp/diskmnt xfs
rw,relatime,attr2,inode64,sunit=1024,swidth=2048,noquota 0 0

$ cat /proc/partitions
major minor  #blocks  name

   8        0  976762584 sda
   8        1   10281600 sda1
   8        2  966479960 sda2
   8       16  976762584 sdb
   8       17   10281600 sdb1
   8       18  966479960 sdb2
   8       32  976762584 sdc
   8       33   10281600 sdc1
   8       34  966479960 sdc2
   (...)
   9        1   20560896 md1
   9        0 1932956672 md0

# same layout for other disks
$ fdisk -c -u /dev/sda

The device presents a logical sector size that is smaller than
the physical sector size. Aligning to a physical sector (or optimal
I/O) size boundary is recommended, or performance may be impacted.

Command (m for help): p

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048    20565247    10281600   83  Linux
/dev/sda2        20565248  1953525167   966479960   83  Linux

# unfortunately I had to reinitelize the array and recovery takes a
while.. it does not impact performance much though.
$ cat /proc/mdstat
Personalities : [linear] [raid6] [raid5] [raid4]
md0 : active raid5 sda2[0] sdc2[3] sdb2[1]
      1932956672 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [UU_]
      [>....................]  recovery =  2.4% (23588740/966478336)
finish=156.6min speed=100343K/sec
      bitmap: 0/1 pages [0KB], 2097152KB chunk


# sda sdb and sdc are the same model
$ hdparm -I /dev/sda

/dev/sda:

ATA device, with non-removable media
    Model Number:       HGST HCC541010A9E680
    (...)
    Firmware Revision:  JA0OA560
    Transport:          Serial, ATA8-AST, SATA 1.0a, SATA II
Extensions, SATA Rev 2.5, SATA Rev 2.6; Revision: ATA8-AST T13 Project
D1697 Revision 0b
Standards:
    Used: unknown (minor revision code 0x0028)
    Supported: 8 7 6 5
    Likely used: 8
Configuration:
    Logical        max    current
    cylinders    16383    16383
    heads        16    16
    sectors/track    63    63
    --
    CHS current addressable sectors:   16514064
    LBA    user addressable sectors:  268435455
    LBA48  user addressable sectors: 1953525168
    Logical  Sector size:                   512 bytes
    Physical Sector size:                  4096 bytes
    Logical Sector-0 offset:                  0 bytes
    device size with M = 1024*1024:      953869 MBytes
    device size with M = 1000*1000:     1000204 MBytes (1000 GB)
    cache/buffer size  = 8192 KBytes (type=DualPortCache)
    Form Factor: 2.5 inch
    Nominal Media Rotation Rate: 5400
Capabilities:
    LBA, IORDY(can be disabled)
    Queue depth: 32
    Standby timer values: spec'd by Standard, no device specific minimum
    R/W multiple sector transfer: Max = 16    Current = 16
    Advanced power management level: 128
    DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
         Cycle time: min=120ns recommended=120ns
    PIO: pio0 pio1 pio2 pio3 pio4
         Cycle time: no flow control=120ns  IORDY flow control=120ns

$ hdparm -I /dev/sd{a,b,c} | grep "Write cache"
       *    Write cache
       *    Write cache
       *    Write cache
# therefore write cache is enabled in all drives

$ xfs_info /dev/md0
meta-data=/dev/md0               isize=256    agcount=32, agsize=15101312 blks
         =                       sectsz=4096  attr=2
data     =                       bsize=4096   blocks=483239168, imaxpct=5
         =                       sunit=128    swidth=256 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=8192, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

$ xfs_bmap -vvp /tmp/diskmnt/filewr.zero
/tmp/diskmnt/filewr.zero:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET            TOTAL FLAGS
   0: [0..2047999]:    2049056..4097055  0 (2049056..4097055) 2048000 01111
 FLAG Values:
    010000 Unwritten preallocated extent
    001000 Doesn't begin on stripe unit
    000100 Doesn't end   on stripe unit
    000010 Doesn't begin on stripe width
    000001 Doesn't end   on stripe width
# this does not look good, does it?

# run while dd was executing, looks like we have almost the half
writes as reads....
$ iostat -d -k 30 2 /dev/sda2 /dev/sdb2 /dev/sdc2
Linux 3.10.10 (haswell1)     11/21/2013     _i686_    (2 CPU)

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda2             13.75      6639.52       232.17   78863819    2757731
sdb2             13.74      6639.42       232.24   78862660    2758483
sdc2             13.68        55.86      6813.67     663443   80932375

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda2             78.27     11191.20     22556.07     335736     676682
sdb2             78.30     11175.73     22589.13     335272     677674
sdc2             78.30      5506.13     28258.47     165184     847754

Thanks
- Martin

On Thu, Nov 21, 2013 at 4:50 AM, Martin Boutin <martboutin@gmail.com> wrote:
> On Thu, Nov 21, 2013 at 4:26 AM, Dave Chinner <david@fromorbit.com> wrote:
>> On Thu, Nov 21, 2013 at 04:11:41AM -0500, Martin Boutin wrote:
>>> On Mon, Nov 18, 2013 at 7:57 PM, Dave Chinner <david@fromorbit.com> wrote:
>>> > On Mon, Nov 18, 2013 at 12:28:21PM -0600, Eric Sandeen wrote:
>>> >> On 11/18/13, 10:02 AM, Martin Boutin wrote:
>>> >> > Dear list,
>>> >> >
>>> >> > I am writing about an apparent issue (or maybe it is normal, that's my
>>> >> > question) regarding filesystem write speed in in a linux raid device.
>>> >> > More specifically, I have linux-3.10.10 running in an Intel Haswell
>>> >> > embedded system with 3 HDDs in a RAID-5 configuration.
>>> >> > The hard disks have 4k physical sectors which are reported as 512
>>> >> > logical size. I made sure the partitions underlying the raid device
>>> >> > start at sector 2048.
>>> >>
>>> >> (fixed cc: to xfs list)
>>> >>
>>> >> > The RAID device has version 1.2 metadata and 4k (bytes) of data
>>> >> > offset, therefore the data should also be 4k aligned. The raid chunk
>>> >> > size is 512K.
>>> >> >
>>> >> > I have the md0 raid device formatted as ext3 with a 4k block size, and
>>> >> > stride and stripes correctly chosen to match the raid chunk size, that
>>> >> > is, stride=128,stripe-width=256.
>>> >> >
>>> >> > While I was working in a small university project, I just noticed that
>>> >> > the write speeds when using a filesystem over raid are *much* slower
>>> >> > than when writing directly to the raid device (or even compared to
>>> >> > filesystem read speeds).
>>> >> >
>>> >> > The command line for measuring filesystem read and write speeds was:
>>> >> >
>>> >> > $ dd if=/tmp/diskmnt/filerd.zero of=/dev/null bs=1M count=1000 iflag=direct
>>> >> > $ dd if=/dev/zero of=/tmp/diskmnt/filewr.zero bs=1M count=1000 oflag=direct
>>> >> >
>>> >> > The command line for measuring raw read and write speeds was:
>>> >> >
>>> >> > $ dd if=/dev/md0 of=/dev/null bs=1M count=1000 iflag=direct
>>> >> > $ dd if=/dev/zero of=/dev/md0 bs=1M count=1000 oflag=direct
>>> >> >
>>> >> > Here are some speed measures using dd (an average of 20 runs).:
>>> >> >
>>> >> > device       raw/fs  mode   speed (MB/s)    slowdown (%)
>>> >> > /dev/md0    raw    read    207
>>> >> > /dev/md0    raw    write    209
>>> >> > /dev/md1    raw    read    214
>>> >> > /dev/md1    raw    write    212
>>> >
>>> > So, that's writing to the first 1GB of /dev/md0, and all the writes
>>> > are going to be aligned to the MD stripe.
>>> >
>>> >> > /dev/md0    xfs    read    188    9
>>> >> > /dev/md0    xfs    write    35    83o
>>> >
>>> > And these will not be written to the first 1GB of the block device
>>> > but somewhere else. Most likely a region that hasn't otherwise been
>>> > used, and so isn't going to be overwriting the same blocks like the
>>> > /dev/md0 case is going to be. Perhaps there's some kind of stripe
>>> > caching effect going on here? Was the md device fully initialised
>>> > before you ran these tests?
>>> >
>>> >> >
>>> >> > /dev/md1    ext3    read    199    7
>>> >> > /dev/md1    ext3    write    36    83
>>> >> >
>>> >> > /dev/md0    ufs    read    212    0
>>> >> > /dev/md0    ufs    write    53    75
>>> >> >
>>> >> > /dev/md0    ext2    read    202    2
>>> >> > /dev/md0    ext2    write    34    84
>>> >
>>> > I suspect what you are seeing here is either the latency introduced
>>> > by having to allocate blocks before issuing the IO, or the file
>>> > layout due to allocation is not idea. Single threaded direct IO is
>>> > latency bound, not bandwidth bound and, as such, is IO size
>>> > sensitive. Allocation for direct IO is also IO size sensitive -
>>> > there's typically an allocation per IO, so the more IO you have to
>>> > do, the more allocation that occurs.
>>>
>>> I just did a few more tests, this time with ext4:
>>>
>>> device       raw/fs  mode   speed (MB/s)    slowdown (%)
>>> /dev/md0    ext4    read    199    4%
>>> /dev/md0    ext4    write    210    0%
>>>
>>> This time, no slowdown at all on ext4. I believe this is due to the
>>> multiblock allocation feature of ext4 (I'm using O_DIRECT, so it
>>> should be it). So I guess for the other filesystems, it was indeed
>>> the latency introduced by block allocation.
>>
>> Except that XFS does extent based allocation as well, so that's not
>> likely the reason. The fact that ext4 doesn't see a slowdown like
>> every other filesystem really doesn't make a lot of sense to
>> me, either from an IO dispatch point of view or an IO alignment
>> point of view.
>>
>> Why? Because all the filesystems align identically to the underlying
>> device and all should be doing 4k block aligned IO, and XFS has
>> roughly the same allocation overhead for this workload as ext4.
>> Did you retest XFS or any of the other filesystems directly after
>> running the ext4 tests (i.e. confirm you are testing apples to
>> apples)?
>
> Yes I did, the performance figures did not change for either XFS or ext3.
>>
>> What we need to determine why other filesystems are slow (and why
>> ext4 is fast) is more information about your configuration and block
>> traces showing what is happening at the IO level, like was requested
>> in a previous email....
>
> Ok, I'm going to try coming up with meaningful data. Thanks.
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>
>
>
> --
> Martin Boutin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
