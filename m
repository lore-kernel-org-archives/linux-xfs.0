Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6E7D7CA6
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2016 20:43:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 415FAAC002
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2016 18:43:39 -0700 (PDT)
Received: from legacy.ddn.com (legacy.ddn.com [64.47.133.206]) by cuda.sgi.com
	with ESMTP id 95CSN8Onkr6cYUPE (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jul 2016 18:43:35 -0700 (PDT)
From: Wang Shilong <wshilong@ddn.com>
Subject: RE: Bad Metadata performances for XFS?
Date: Tue, 5 Jul 2016 01:43:33 +0000
Message-ID: <3ED34739A4E85E4F894367D57617CDEF9ED955AB@LAX-EX-MB2.datadirect.datadirectnet.com>
References: <3ED34739A4E85E4F894367D57617CDEF9ED9518B@LAX-EX-MB2.datadirect.datadirectnet.com>
	<20160704225226.GD27480@dastard>,<20160705001854.GY12670@dastard>
In-Reply-To: <20160705001854.GY12670@dastard>
Content-Language: en-US
MIME-Version: 1.0
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
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hello Dave Chinner,

________________________________________
From: Dave Chinner [david@fromorbit.com]
Sent: Tuesday, July 05, 2016 8:18
To: Wang Shilong
Cc: linux-xfs@vger.kernel.org; xfs@oss.sgi.com
Subject: Re: Bad Metadata performances for XFS?

On Tue, Jul 05, 2016 at 08:52:26AM +1000, Dave Chinner wrote:
> [xfs@oss.sgi.com is where you'll find the XFS developers]
>
> On Mon, Jul 04, 2016 at 05:32:40AM +0000, Wang Shilong wrote:
> > Hello Guys,
> >
> >       I happened run some benchmarks for XFS, and found some intresting to share here:
> > Kernel version:
> > [root@localhost shm]# uname -r
> > 4.7.0-rc5+
> >
> > [root@localhost shm]# cat /proc/cpuinfo  | grep Intel
> > vendor_id   : GenuineIntel
> > model name  : Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz

What's the rest of the hardware in the machine?
[root@localhost ~]# cat /proc/meminfo 
MemTotal:       32823104 kB
MemFree:        29981320 kB
MemAvailable:   31672712 kB
Buffers:            6176 kB
Cached:          1241192 kB
SwapCached:            0 kB
Active:           938332 kB
Inactive:         692420 kB
Active(anon):     384576 kB
Inactive(anon):   111320 kB
Active(file):     553756 kB
Inactive(file):   581100 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:             11324 kB
Writeback:             0 kB
AnonPages:        383496 kB
Mapped:           186516 kB
Shmem:            112496 kB
Slab:            1059544 kB
SReclaimable:    1020764 kB
SUnreclaim:        38780 kB
KernelStack:        6896 kB
PageTables:        22160 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    16411552 kB
Committed_AS:    2382640 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
CmaTotal:              0 kB
CmaFree:               0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      194868 kB
DirectMap2M:     3874816 kB
DirectMap1G:    30408704 kB

[root@localhost ~]# dmidecode -t memory
# dmidecode 3.0
Getting SMBIOS data from sysfs.
SMBIOS 2.8 present.

Handle 0x0041, DMI type 16, 23 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 32 GB
	Error Information Handle: Not Provided
	Number Of Devices: 4

Handle 0x0042, DMI type 17, 40 bytes
Memory Device
	Array Handle: 0x0041
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 8192 MB
	Form Factor: DIMM
	Set: None
	Locator: ChannelA-DIMM0
	Bank Locator: BANK 0
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1600 MHz
	Manufacturer: Kingston
	Serial Number: 692A784E
	Asset Tag: 9876543210
	Part Number: KHX1600C10D3/8GX  
	Rank: 2
	Configured Clock Speed: 1333 MHz
	Minimum Voltage: 1.5 V
	Maximum Voltage: 1.5 V
	Configured Voltage: 1.5 V

Handle 0x0044, DMI type 17, 40 bytes
Memory Device
	Array Handle: 0x0041
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 8192 MB
	Form Factor: DIMM
	Set: None
	Locator: ChannelA-DIMM1
	Bank Locator: BANK 1
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1600 MHz
	Manufacturer: Kingston
	Serial Number: 672A954E
	Asset Tag: 9876543210
	Part Number: KHX1600C10D3/8GX  
	Rank: 2
	Configured Clock Speed: 1333 MHz
	Minimum Voltage: 1.5 V
	Maximum Voltage: 1.5 V
	Configured Voltage: 1.5 V

Handle 0x0046, DMI type 17, 40 bytes
Memory Device
	Array Handle: 0x0041
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 8192 MB
	Form Factor: DIMM
	Set: None
	Locator: ChannelB-DIMM0
	Bank Locator: BANK 2
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1600 MHz
	Manufacturer: Kingston
	Serial Number: 712AE08D
	Asset Tag: 9876543210
	Part Number: KHX1600C10D3/8GX  
	Rank: 2
	Configured Clock Speed: 1333 MHz
	Minimum Voltage: 1.5 V
	Maximum Voltage: 1.5 V
	Configured Voltage: 1.5 V

Handle 0x0048, DMI type 17, 40 bytes
Memory Device
	Array Handle: 0x0041
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 8192 MB
	Form Factor: DIMM
	Set: None
	Locator: ChannelB-DIMM1
	Bank Locator: BANK 3
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1600 MHz
	Manufacturer: Kingston
	Serial Number: 6A2A144E
	Asset Tag: 9876543210
	Part Number: KHX1600C10D3/8GX  
	Rank: 2
	Configured Clock Speed: 1333 MHz
	Minimum Voltage: 1.5 V
	Maximum Voltage: 1.5 V
	Configured Voltage: 1.5 V



> > dd 16GB to /dev/shm/data to use memory backend storage to benchmark metadata performaces.

I've never seen anyone create a ramdisk like that before.
What's the backing device type? i.e. what block device driver does
this use?

I guess you mean loop device here? It is common file and setup
as loop0 device here.

> > Benchmark tool is mdtest, you can download it from
> > https://sourceforge.net/projects/mdtest/

What version? The sourceforge version, of the github fork that the
sourceforge page points to? Or the forked branch of recent
development in the github fork?

I don't think sourceforge version or github version make some
differences here, you could use any of them.(I used Souceforge version)


> > Steps to run benchmark
> > #mkfs.xfs /dev/shm/data

Output of this command so we can recreate the same filesystem
structure?

[root@localhost shm]# mkfs.xfs data
meta-data=data                   isize=512    agcount=4, agsize=1025710 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0
data     =                       bsize=4096   blocks=4102840, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


> > #mount /dev/shm/data /mnt/test
> > #mdtest -d /mnt/test -n 2000000
> >
> > 1 tasks, 2000000 files/directories
> >
> > SUMMARY: (of 1 iterations)
> >    Operation                      Max            Min           Mean        Std Dev
> >    ---------                      ---            ---           ----        -------
> >    Directory creation:      24724.717      24724.717      24724.717          0.000
> >    Directory stat    :    1156009.290    1156009.290    1156009.290          0.000
> >    Directory removal :     103496.353     103496.353     103496.353          0.000
> >    File creation     :      23094.444      23094.444      23094.444          0.000
> >    File stat         :    1158704.969    1158704.969    1158704.969          0.000
> >    File read         :     752731.595     752731.595     752731.595          0.000
> >    File removal      :     105481.766     105481.766     105481.766          0.000
> >    Tree creation     :       2229.827       2229.827       2229.827          0.000
> >    Tree removal      :          1.275          1.275          1.275          0.000
> >
> > -- finished at 07/04/2016 12:54:26 --

A table of numbers with no units or explanation as to what they
mean. Let me guess - I have to read the benchmark source code to
understand what the numbers mean?

You could look File Creation, Units mean number of files create per seconds.
(Here it is 23094.444)


> > IOPS for file creation is only 2.3W, however compare to Ext4 with same testing.

Ummm - what unit of measurement is "W"? Watts?

Sorry, same as above..


Please, when presenting benchmark results to ask for help with
analysis, be *extremely specific* about what you running and what
the results mean. It's no different from reporting a bug from this
perspective:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

That said, this is a single threaded benchmark. It's well
known that XFS uses more CPU per metadata operation than either ext4
or btrfs, so it won't be any surprise that they are faster than XFS
on this particular test. We've known this for many years now -
perhaps you should watch/read this presentation I did more than 4
years ago now:

http://xfs.org/index.php/File:Xfs-scalability-lca2012.pdf
http://www.youtube.com/watch?v=FegjLbCnoBw

IOWs: Being CPU bound at 25,000 file creates/s is in line with
what I'd expect on XFS for a single threaded, single directory
create over 2 million directory entries with the default 4k
directory block size....
----------

I understand that this is single thread Limit, but I guess there are some
other Limit here, because even single thread creating 50W files speed
is twice than 200W files.

Thanks,
Shilong

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
