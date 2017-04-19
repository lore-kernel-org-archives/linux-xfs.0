Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from firestarter.dermichi.com ([194.177.153.153]:48698 "EHLO
        firestarter.dermichi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762819AbdDSMkL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 08:40:11 -0400
Received: from noclinksys.net4you.net ([194.177.153.180] helo=[192.168.34.111])
        by firestarter.dermichi.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim)
        (envelope-from <mw@dermichi.com>)
        id 1d0ou0-0004y0-Mc
        for linux-xfs@vger.kernel.org; Wed, 19 Apr 2017 14:40:08 +0200
Subject: Re: xfsaild in D state seems to be blocking all other i/o
 sporadically
References: <e5f2ccc2-7923-934c-e655-59983903ca11@dermichi.com>
 <20170419121202.2m3pi4ffojpnqyxc@eorzea.usersys.redhat.com>
From: Michael Weissenbacher <mw@dermichi.com>
Message-ID: <ced08a44-d736-6250-c682-0f495a882bea@dermichi.com>
Date: Wed, 19 Apr 2017 14:40:08 +0200
MIME-Version: 1.0
In-Reply-To: <20170419121202.2m3pi4ffojpnqyxc@eorzea.usersys.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org



On 19.04.2017 14:12, Carlos Maiolino wrote:
> Hi,
> 
> On Wed, Apr 19, 2017 at 12:58:05PM +0200, Michael Weissenbacher wrote:
>> Hi List!
>> I have a storage server which primarily does around 15-20 parallel
>> rsync's, nothing special. Sometimes (3-4 times a day) i notice that all
>> I/O on the file system suddenly comes to a halt and the only process
>> that continues to do any I/O (according to iotop) is the process
>> xfsaild/md127. When this happens, xfsaild only does reads (according to
>> iotop) and consistently in D State (according to top).
>> Unfortunately this can sometimes stay like this for 5-15 minutes. During
>> this time even a simple "ls" our "touch" would block and be stuck in D
>> state. All other running processes accessing the fs are of course also
>> stuck in D state. It is a XFS V5 filesystem.
>> Then again, as sudden as it began, everything goes back to normal and
>> I/O continues. The problem is accompanied with several "process blocked
>> for xxx seconds" in dmesg and also some dropped connections due to
>> network timeouts.
>>
>> I've tried several things to remedy the problem, including:
>>   - changing I/O schedulers (tried noop, deadline and cfq). Deadline
>> seems to be best (the block goes away in less time compared with the
>> others).
>>   - removing all mount options (defaults + usrquota, grpquota)
>>   - upgrading to the latest 4.11.0-rc kernel (before that i was on 4.9.x)
>>
>> Nothing of the above seemed to have made a significant change to the
>> problem.
>>
>> xfs_info output of the fs in question:
>> meta-data=/dev/md127             isize=512    agcount=33,
>> agsize=268435440 blks
>>          =                       sectsz=4096  attr=2, projid32bit=1
>>          =                       crc=1        finobt=1 spinodes=0 rmapbt=0
>>          =                       reflink=0
>> data     =                       bsize=4096   blocks=8789917696, imaxpct=10
>>          =                       sunit=16     swidth=96 blks
>> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
>> log      =internal               bsize=4096   blocks=521728, version=2
>>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
> 
> This is really not enough to give any idea of what might be happening, although
> this looks more like a slow storage while xfsaild is flushing the log, but we
> really need more information to try to give a better idea of what is going on,
> please look at:
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> Specially for: storage layout (RAID arrays, LVMs, thin provisioning, etc), and
> the dmesg output with the traces from the hang tasks.
> 
Ok, including all of the info above:
* Kernel Vesion: 4.11.0-rc5 (currently), but also reproducable on 4.9.20+
* xfsprogs version: 4.9.0
* number of cpus: 1 socket, 6 cores
* contents of /proc/meminfo, /proc/mounts, /proc/partitions: see below
* RAID layout: Hardware RAID-10 + linear MD device (sdb == md127); XFS
on top of md127
md127 : active linear sdb[0]
      35159670784 blocks super 1.2 64k rounding
* LVM: no LVM
* type of disks 12x 6TB SAS disks (enterprise class)
* write cache state of disks: disabled
* write cache of BBWC controller: enabled, 2GB
* xfs_info output: already included
* dmesg output: samples see below
* iostat output: samples see below
* vmstat output: will capture when it occurs the next time
* D state processes: will capture when it occurs the next time; also see
top output below


>> Storage Subsystem: Dell Perc H730P Controller 2GB NVCACHE, 12 6TB Disks,
>> RAID-10, latest Firmware Updates
>>
>> I would be happy to dig out more information if needed. How can i find
>> out if the RAID Controller itself gets stuck? Nothing bad shows up in
>> the hardware and SCSI controller logs.
>>
> 

# cat /proc/meminfo
MemTotal:       65886208 kB
MemFree:         3490480 kB
MemAvailable:   41531280 kB
Buffers:              84 kB
Cached:         26125688 kB
SwapCached:           64 kB
Active:         20010544 kB
Inactive:        6142828 kB
Active(anon):        856 kB
Inactive(anon):    27576 kB
Active(file):   20009688 kB
Inactive(file):  6115252 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:      64511996 kB
SwapFree:       64505852 kB
Dirty:                 8 kB
Writeback:             0 kB
AnonPages:         27536 kB
Mapped:            14000 kB
Shmem:               832 kB
Slab:           27037624 kB
SReclaimable:   20569360 kB
SUnreclaim:      6468264 kB
KernelStack:        2976 kB
PageTables:         6228 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    97455100 kB
Committed_AS:     210904 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       88820 kB
DirectMap2M:     7155712 kB
DirectMap1G:    61865984 kB


# cat /proc/mounts
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs rw,relatime,size=10240k,nr_inodes=8233000,mode=755 0 0
devpts /dev/pts devpts
rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=6588624k,mode=755 0 0
/dev/sda4 / xfs rw,relatime,attr2,inode64,usrquota,grpquota 0 0
tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
pstore /sys/fs/pstore pstore rw,relatime 0 0
tmpfs /run/shm tmpfs rw,nosuid,nodev,noexec,relatime,size=26079640k 0 0
/dev/sda2 /boot ext2 rw,relatime,block_validity,barrier,user_xattr,acl 0 0
-> /dev/md127 /backup xfs
rw,noatime,attr2,inode64,sunit=128,swidth=768,usrquota,grpquota 0 0
none /sys/kernel/config configfs rw,relatime 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0


# cat /proc/partitions
major minor  #blocks  name

   8        0  292421632 sda
   8        1       1024 sda1
   8        2    1021952 sda2
   8        3   64512000 sda3
   8        4  226884608 sda4
   8       16 35159801856 sdb
   9      127 35159670784 md127



top - 12:30:03 up 11 days,  7:07,  1 user,  load average: 22.89, 19.86,
12.53
Tasks: 247 total,   1 running, 246 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.4 sy,  0.0 ni, 99.6 id,  0.0 wa,  0.0 hi,  0.0 si,
0.0 st
KiB Mem:  65886208 total, 62923220 used,  2962988 free,       84 buffers
KiB Swap: 64511996 total,     6144 used, 64505852 free. 38382400 cached Mem

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+
COMMAND

   1609 root      20   0       0      0      0 D   2.0  0.0  54:39.51
xfsaild/md127

1703883 root      20   0       0      0      0 D   0.0  0.0   2:28.31
kworker/u12:0

1704625 checker+  20   0   37512  11700   2416 D   0.0  0.0   1:19.68
rsync

1704627 checker+  20   0   67104   9396   1628 D   0.0  0.0   1:10.44
rsync

1704845 10003     20   0    9148   3836   1744 D   0.0  0.0   0:33.56 rm


1705051 nospam.+  20   0   24392   2240   1616 D   0.0  0.0   0:22.67
rsync

1705262 atacama+  20   0   20740   9120   2436 D   0.0  0.0   0:11.27
rsync

1705265 10021     20   0   38144  11404   3800 D   0.0  0.0   0:00.06
rsnapshot

1705371 smtp1.n+  20   0    7088   1892   1604 D   0.0  0.0   0:06.39 rm


1705373 kalahar+  20   0   38144  11440   3840 D   0.0  0.0   0:00.07
rsnapshot

1705475 cvs.net+  20   0   17248   4996   2332 D   0.0  0.0   0:04.66
rsync

1705584 hoth.ne+  20   0   38040  11488   3888 D   0.0  0.0   0:00.06
rsnapshot

1705880 10035     20   0   38120  11372   3768 D   0.0  0.0   0:00.07
rsnapshot

1705983 smtp2.n+  20   0   38144  11444   3844 D   0.0  0.0   0:00.07
rsnapshot

1706080 endor.n+  20   0   38124  11456   3844 D   0.0  0.0   0:00.07
rsnapshot

1706081 10031     20   0   38040  11400   3800 D   0.0  0.0   0:00.06
rsnapshot

1706181 10032     20   0   38144  11380   3780 D   0.0  0.0   0:00.07
rsnapshot

1706182 10004     20   0   38144  11384   3780 D   0.0  0.0   0:00.06
rsnapshot

1706388 dns2.ne+  20   0   38120  11376   3768 D   0.0  0.0   0:00.06
rsnapshot

1706485 10034     20   0   38144  11392   3788 D   0.0  0.0   0:00.06
rsnapshot

1706491 10022     20   0   38124  11372   3768 D   0.0  0.0   0:00.06
rsnapshot

1706786 wiki.ne+  20   0   38124  11404   3800 D   0.0  0.0   0:00.06
rsnapshot


iostat output when the problem occurs:
04/19/2017 12:30:17 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.17    0.00    0.00   99.80

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00     0.00  190.40    0.00  3046.40     0.00
32.00     0.98    5.16    5.16    0.00   5.14  97.92

04/19/2017 12:30:22 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.20    0.00    0.00   99.80

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00     0.00  159.80    0.00  2556.80     0.00
32.00     0.98    6.15    6.15    0.00   6.14  98.16

04/19/2017 12:30:27 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.23    0.03    0.00   99.70

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00     0.00  235.80    0.00  3772.80     0.00
32.00     0.97    4.13    4.13    0.00   4.13  97.36

04/19/2017 12:30:32 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.93    0.00    1.17    0.07    0.00   97.83

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00     0.00  161.00    3.40  2576.00    54.40
32.00     0.98    5.98    6.10    0.24   5.98  98.24

04/19/2017 12:30:37 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.20    0.00    0.00   99.77

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00     0.00  194.80    0.00  3116.80     0.00
32.00     0.98    5.02    5.02    0.00   5.02  97.84

04/19/2017 12:30:42 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.20    0.00    0.00   99.80

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00     0.00  192.20    0.00  3075.20     0.00
32.00     0.99    5.14    5.14    0.00   5.14  98.72
...
(after it suddendly stops blocking and starts writing again)
04/19/2017 12:31:37 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    2.51    3.38    0.00   94.08

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00  4911.80   55.60 4664.00   889.60 137985.60
58.85   122.10   25.18    8.95   25.37   0.20  94.80

04/19/2017 12:31:42 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.81    7.86    0.00   91.30

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00  2239.80    0.00 2592.20     0.00 70144.80
54.12   271.25  105.12    0.00  105.12   0.39 100.00

04/19/2017 12:31:47 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.14    0.00    1.57    7.90    0.00   89.39

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00  2620.40    0.00 2632.20     0.00 77292.00
58.73   270.84  102.98    0.00  102.98   0.38 100.00

04/19/2017 12:31:52 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    1.11    7.82    0.00   91.08

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00  2592.80    0.00 2661.40     0.00 76693.60
57.63   270.95  101.39    0.00  101.39   0.38 100.00

04/19/2017 12:32:32 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.03    0.00    0.87    7.43    0.00   91.66

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00  2007.60    0.00 2321.80     0.00 58285.60
50.21   271.18  116.05    0.00  116.05   0.43 100.00

04/19/2017 12:32:37 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.80    0.00    4.09   13.70    0.00   81.41

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.20  1234.00    6.40 1912.40    43.20 66422.40
69.28   224.64  118.18  135.38  118.13   0.52 100.00
...
followed by "normal" I/O with both reads and writes
04/19/2017 12:32:42 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           3.98    0.00   10.23   35.92    0.00   49.87

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               2.00     0.00  423.20  374.80  9460.00 66360.00
190.03    18.15   25.78   47.33    1.44   1.25 100.00

04/19/2017 12:32:47 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           9.26    0.00    7.95   56.36    0.00   26.43

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb              24.60     0.00 1826.00  188.00 53184.80  5222.40
58.00    17.24    8.25    9.08    0.21   0.50 100.00


with kind regards,
Michael
