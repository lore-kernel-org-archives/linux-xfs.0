Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAC9iwta211676 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 03:44:59 -0600
Received: from galenis.iv.lt (galenis.iv.lt [195.14.170.242]) by cuda.sgi.com
	with ESMTP id 4eEYCg3trttffrFO (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 01:46:58 -0800 (PST)
Received: from fwdr-2.fwdr-0.fwdr-168.fwdr-192 ([192.168.0.2]
	helo=galenis.iv.lt) by galenis.iv.lt with esmtp (Exim 4.72)
	(envelope-from <linas.j@iv.lt>) id 1TXqbY-0002vN-R4
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 11:46:56 +0200
Message-ID: <50A0C590.6020602@iv.lt>
Date: Mon, 12 Nov 2012 11:46:56 +0200
From: Linas Jankauskas <linas.j@iv.lt>
MIME-Version: 1.0
Subject: Re: Slow performance after ~4.5TB
References: <50A0AFD5.2020607@iv.lt> <20121112090448.GS24575@dastard>
In-Reply-To: <20121112090448.GS24575@dastard>
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


Servers are HP dl180 g6
OS centos 6.3 x86_64

CPU
2x Intel(R) Xeon(R) CPU           L5630  @ 2.13GHz

uname -r
2.6.32-279.5.2.el6.x86_64

xfs_repair -V
xfs_repair version 3.1.1


cat /proc/meminfo
MemTotal:       12187500 kB
MemFree:          153080 kB
Buffers:         6400308 kB
Cached:          2390008 kB
SwapCached:          604 kB
Active:           692940 kB
Inactive:        8991528 kB
Active(anon):     687228 kB
Inactive(anon):   206984 kB
Active(file):       5712 kB
Inactive(file):  8784544 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       8388600 kB
SwapFree:        8385784 kB
Dirty:               712 kB
Writeback:             0 kB
AnonPages:        893828 kB
Mapped:             4496 kB
Shmem:                16 kB
Slab:            1706980 kB
SReclaimable:    1596076 kB
SUnreclaim:       110904 kB
KernelStack:        1672 kB
PageTables:         2880 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    14482348 kB
Committed_AS:     910912 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      307080 kB
VmallocChunk:   34359416048 kB
HardwareCorrupted:     0 kB
AnonHugePages:    882688 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        5504 kB
DirectMap2M:     2082816 kB
DirectMap1G:    10485760 kB


cat /proc/mounts
rootfs / rootfs rw 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
devtmpfs /dev devtmpfs 
rw,relatime,size=6084860k,nr_inodes=1521215,mode=755 0 0
devpts /dev/pts devpts rw,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /dev/shm tmpfs rw,relatime 0 0
/dev/sda3 / ext4 rw,noatime,barrier=1,data=ordered 0 0
/proc/bus/usb /proc/bus/usb usbfs rw,relatime 0 0
/dev/sda1 /boot ext4 
rw,nosuid,nodev,noexec,noatime,barrier=1,data=ordered 0 0
/dev/sda4 /usr ext4 rw,nodev,noatime,barrier=1,data=ordered 0 0
/dev/sda5 /var xfs rw,nosuid,nodev,noexec,noatime,attr2,delaylog,noquota 0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0


cat /proc/partitions
major minor  #blocks  name

    8        0 21488299096 sda
    8        1     131072 sda1
    8        2    8388608 sda2
    8        3    1048576 sda3
    8        4    4194304 sda4
    8        5 21474535495 sda5


hpacucli ctrl all show config

Smart Array P410 in Slot 1                (sn: PACCRID122807DY)

    array A (SATA, Unused Space: 0 MB)


       logicaldrive 1 (20.0 TB, RAID 5, OK)

       physicaldrive 1I:1:1 (port 1I:box 1:bay 1, SATA, 2 TB, OK)
       physicaldrive 1I:1:2 (port 1I:box 1:bay 2, SATA, 2 TB, OK)
       physicaldrive 1I:1:3 (port 1I:box 1:bay 3, SATA, 2 TB, OK)
       physicaldrive 1I:1:4 (port 1I:box 1:bay 4, SATA, 2 TB, OK)
       physicaldrive 1I:1:5 (port 1I:box 1:bay 5, SATA, 2 TB, OK)
       physicaldrive 1I:1:6 (port 1I:box 1:bay 6, SATA, 2 TB, OK)
       physicaldrive 1I:1:7 (port 1I:box 1:bay 7, SATA, 2 TB, OK)
       physicaldrive 1I:1:8 (port 1I:box 1:bay 8, SATA, 2 TB, OK)
       physicaldrive 1I:1:9 (port 1I:box 1:bay 9, SATA, 2 TB, OK)
       physicaldrive 1I:1:10 (port 1I:box 1:bay 10, SATA, 2 TB, OK)
       physicaldrive 1I:1:11 (port 1I:box 1:bay 11, SATA, 2 TB, OK)
       physicaldrive 1I:1:12 (port 1I:box 1:bay 12, SATA, 2 TB, OK)

    Expander 250 (WWID: 5001438021432E30, Port: 1I, Box: 1)

    Enclosure SEP (Vendor ID HP, Model DL18xG6BP) 248 (WWID: 
5001438021432E43, Port: 1I, Box: 1)

    SEP (Vendor ID PMCSIERA, Model  SRC 8x6G) 249 (WWID: 5001438021D96E1F)

Disks HP 2TB SATA:
Port: 1I
          Box: 1
          Bay: 1
          Status: OK
          Drive Type: Data Drive
          Interface Type: SATA
          Size: 2 TB
          Firmware Revision: HPG3
          Serial Number: WMAY04060057
          Model: ATA     MB2000EAZNL
          SATA NCQ Capable: True
          SATA NCQ Enabled: True
          Current Temperature (C): 32
          Maximum Temperature (C): 37
          PHY Count: 1
          PHY Transfer Rate: 3.0GBPS


Other raid info:

Smart Array P410 in Slot 1
    Bus Interface: PCI
    Slot: 1
    Serial Number: PACCRID122807DY
    Cache Serial Number: PBCDF0CRH2M3DR
    RAID 6 (ADG) Status: Disabled
    Controller Status: OK
    Hardware Revision: Rev C
    Firmware Version: 5.70
    Rebuild Priority: Medium
    Expand Priority: Medium
    Surface Scan Delay: 15 secs
    Surface Scan Mode: Idle
    Queue Depth: Automatic
    Monitor and Performance Delay: 60 min
    Elevator Sort: Enabled
    Degraded Performance Optimization: Disabled
    Inconsistency Repair Policy: Disabled
    Wait for Cache Room: Disabled
    Surface Analysis Inconsistency Notification: Disabled
    Post Prompt Timeout: 0 secs
    Cache Board Present: True
    Cache Status: OK
    Accelerator Ratio: 25% Read / 75% Write
    Drive Write Cache: Disabled
    Total Cache Size: 1024 MB
    No-Battery Write Cache: Disabled
    Cache Backup Power Source: Capacitors
    Battery/Capacitor Count: 1
    Battery/Capacitor Status: OK
    SATA NCQ Supported: True


xfs_info /var
meta-data=/dev/sda5              isize=256    agcount=20, 
agsize=268435455 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=5368633873, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

No dmesg errors.

vmstat 5
procs -----------memory---------- ---swap-- -----io---- --system-- 
-----cpu-----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy 
id wa st
  1  0   2788 150808 6318232 2475332    0    0   836   185    2    4  1 
11 87  1  0
  1  0   2788 150608 6318232 2475484    0    0     0    89 1094  126  0 
12 88  0  0
  1  0   2788 150500 6318232 2475604    0    0     0    60 1109   99  0 
12 88  0  0
  1  0   2788 150252 6318232 2475720    0    0     0    49 1046   79  0 
12 88  0  0
  1  0   2788 150344 6318232 2475844    0    0     1   157 1046   82  0 
12 88  0  0
  1  0   2788 149972 6318232 2475960    0    0     0   197 1086  144  0 
12 88  0  0
  1  0   2788 150020 6318232 2476088    0    0     0    76 1115   99  0 
12 88  0  0
  1  0   2788 150012 6318232 2476204    0    0     0    81 1131  132  0 
12 88  0  0
  1  0   2788 149624 6318232 2476340    0    0     0    53 1074   95  0 
12 88  0  0
  1  0   2788 149484 6318232 2476476    0    0     0    54 1039   90  0 
12 88  0  0
  1  0   2788 149228 6318232 2476596    0    0     0   146 1043   84  0 
12 88  0  0
  1  0   2788 148980 6318232 2476724    0    0     0   204 1085  146  0 
12 88  0  0
  1  0   2788 149160 6318232 2476836    0    0     0    74 1074  104  0 
12 88  0  0
  1  0   2788 149160 6318232 2476960    0    0     0    70 1040   85  0 
12 88  0  0
  1  0   2788 149036 6318232 2477076    0    0     0    58 1097   91  0 
12 88  0  0
  1  0   2788 148772 6318232 2477196    0    0     0    49 1100  105  0 
12 88  0  0
  1  0   2788 148392 6318232 2477308    0    0     0   142 1042   85  0 
12 88  0  0
  1  0   2788 147904 6318232 2477428    0    0     0   178 1120  143  0 
12 88  0  0
  1  0   2788 147888 6318232 2477544    0    0     0    86 1077  103  0 
12 88  0  0
  1  0   2788 147888 6318232 2477672    0    0     0    82 1051   92  0 
12 88  0  0
  1  0   2788 147648 6318232 2477788    0    0     0    52 1040   87  0 
12 88  0  0
  1  0   2788 147476 6318232 2477912    0    0     2    50 1071   90  0 
12 88  0  0
  1  0   2788 147212 6318232 2478036    0    0     0   158 1279  108  0 
12 88  0  0


iostat -x -d -m 5
Linux 2.6.32-279.5.2.el6.x86_64 (storage)     11/12/2012     _x86_64_ 
  (8 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda             103.27     1.51   92.43   37.65     6.52     1.44 125.36 
     0.73    5.60   1.13  14.74

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.20    2.40   19.80     0.01     0.09 9.08 
    0.13    5.79   2.25   5.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     3.60    0.60   36.80     0.00     4.15 227.45 
     0.12    3.21   0.64   2.38

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.40    1.20   36.80     0.00     8.01 431.83 
     0.11    3.00   1.05   4.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.60    0.00   20.60     0.00     0.08 8.39 
    0.01    0.69   0.69   1.42

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00    38.40    4.20   27.40     0.02     0.27 18.34 
     0.25    8.06   2.63   8.32

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     4.40    0.00   32.00     0.00     4.16 266.00 
     0.08    2.51   0.46   1.48

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00   30.40     0.00    10.04 676.53 
     0.10    3.40   0.54   1.64

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     2.60    0.00   68.40     0.00     4.50 134.68 
     0.12    1.77   0.24   1.66

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.60    0.00   21.40     0.00     0.60 57.64 
     0.02    0.79   0.69   1.48

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.80    0.00   18.40     0.00     0.10 11.48 
     0.02    1.11   0.88   1.62

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00   15.97     0.00     0.06 7.91 
    0.01    0.86   0.86   1.38

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.20    0.00   12.40     0.00     0.05 8.65 
    0.02    1.40   1.40   1.74

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     1.20    0.00   11.20     0.00     0.05 9.14 
    0.02    1.45   1.45   1.62

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00    20.40    0.00   46.80     0.00     0.39 17.06 
     0.07    1.41   0.35   1.64

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     3.80    0.00   20.20     0.00     0.10 9.98 
    0.01    0.68   0.68   1.38

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     3.60    0.00   18.60     0.00     0.09 10.06 
     0.01    0.78   0.78   1.46

On 11/12/2012 11:04 AM, Dave Chinner wrote:
> On Mon, Nov 12, 2012 at 10:14:13AM +0200, Linas Jankauskas wrote:
>> Hello,
>>
>> we have 30 backup servers with 20TB backup partition each.
>> While server is new and empty rsync is compying data prety fast, but
>> when it reaches about 4.5TB write operation become very slow (about 10
>> times slower).
>>
>> I have attached cpu and disk graphs.
>>
>> As you can see first week, while server was empty, rsync was using "user"
>> cpu and data copying was fast. Later rsync started to use "system" cpu
>> and data copying became much slower. Same situation is on all our backup
>> servers. Before we had used smaller partition with ext4 and we had no
>> problems.
>>
>> Most time rsync is spending on ftruncate:
>>
>> % time     seconds  usecs/call     calls    errors syscall
>> ------ ----------- ----------- --------- --------- ----------------
>>   99.99   18.362863      165431       111           ftruncate
>>    0.00    0.000712           3       224       112 open
>>    0.00    0.000195           1       257           write
>>    0.00    0.000171           1       250           read
>>    0.00    0.000075           1       112           lchown
>>    0.00    0.000039           0       112           lstat
>>    0.00    0.000028           0       112           close
>>    0.00    0.000021           0       112           chmod
>>    0.00    0.000011           0       396           select
>>    0.00    0.000000           0       112           utimes
>> ------ ----------- ----------- --------- --------- ----------------
>> 100.00   18.364115                  1798       112 total
>
> Never seen that before. More info needed. Start here:
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> And we can go from there.
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
