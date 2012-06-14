Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5EEVNK6258713 for <xfs@oss.sgi.com>; Thu, 14 Jun 2012 09:31:23 -0500
Received: from xsnews-ex.xsnews.local (exchange.xsnews.nl [78.152.36.69]) by
	cuda.sgi.com with ESMTP id ac2y08b47YbqujeE (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Jun 2012 07:31:18 -0700 (PDT)
Message-ID: <4FD9F5B3.3040901@xsnews.nl>
Date: Thu, 14 Jun 2012 16:31:15 +0200
From: Matthew Whittaker-Williams <matthew@xsnews.nl>
MIME-Version: 1.0
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
References: <4FD66513.2000108@xsnews.nl> <20120612011812.GK22848@dastard>
	<4FD766A7.9030908@xsnews.nl> <20120613011950.GN22848@dastard>
	<4FD8552C.4090208@xsnews.nl> <20120614000411.GY22848@dastard>
In-Reply-To: <20120614000411.GY22848@dastard>
Content-Type: multipart/mixed; boundary="------------050107000807030808070102"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--------------050107000807030808070102
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/12 2:04 AM, Dave Chinner wrote:
> On Wed, Jun 13, 2012 at 10:54:04AM +0200, Matthew Whittaker-Williams wrote:
>> On 6/13/12 3:19 AM, Dave Chinner wrote:
>>> With the valid stack traces, I see that it isn't related to the log,
>>> though.
>> Ah ok, we are triggering a new issue?
> No, your system appears to be stalling waiting for IO completion.

Yes, this is indeed what we experience.
> This is a fluke, we are running several new systems and this is just
> one of the new servers.
> Which indeed has a wrong stripe set, this should be 1MB.
> We actually found stripe size set of 1MB to give better performance
> overall than 64/256/512
> So if you fix that, does the problem go away?

No , unfortunately not.

Currently with 1MB stripe set and:

root@sd70:~# xfs_info /dev/sda
meta-data=/dev/sda               isize=256    agcount=41, 
agsize=268435200 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=10741350400, imaxpct=5
          =                       sunit=256    swidth=5632 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

It still stalled out with the same error.

>> I understand that RAID 10 is better for performance for reads on
>> small files sets.  But with raid 10 we of course loose a lot of
>> disk space compared to RAID 6.  Side note to this we have been
>> running RAID 6 for years now without any issues.
> but have you been running 24 disk RAID6 volumes? With RAID5/6, the
> number of disks of the volume really matters - for small write IOs,
> the more disks in the RAID6 volume, the slower it will be...
Yes we have, but haven't found large issues with performance in the past 
on a disk span of 24.
And most raid controllers don't support more than 32 disk in a raid 
array so we kept it at 24 disks per array with large arrays.

>
>> In the past we did tune our xfs filesystem with switches like
>> sunit and swidth.  But back then we couldn't see much peformance
>> difference between using:
>>
>> mkfs.xfs -f -L P.01 -l lazy-count=1 -d su=1m,sw=22 /dev/sda
>>
>> and
>>
>> mkfs.xfs -f -L P.01 -l lazy-count=1 /dev/sda
> You won't see much difference with the BBWC enabled. It does affect
> how files and inodes are allocated, though, so the aging
> characteristics of the filesystem will be better for an aligned
> filesystem. i.e. you might not notice the performance now, but after
> a coupl eof years in production you probably will...

We haven't seen this impact just yet and are doing about 120K number of 
reads of sector reads.
But this is probably not really high compared to our smaller arrays.

>
>> xfs_info from a system that shows no problems with an H800
>> Controller from dell ( same chipset as the LSI controllers )
>
I went and tried the H800 Controller with a single array of the new 
spool and unfortunately this also hung.

[ 6123.108138] INFO: task diablo:11963 blocked for more than 120 seconds.
[ 6123.108208] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 6123.108297] diablo          D ffff8805ec4e9068     0 11963  11210 
0x00000000
[ 6123.108444]  ffff88046fd315f8 0000000000000082 ffff8800dd1407a8 
ffff88025a8f5000
[ 6123.108681]  000000000025a8f5 ffff88046fd30010 0000000000013340 
0000000000013340
[ 6123.108935]  ffff88046fd31fd8 0000000000013340 ffff88046fd31fd8 
0000000000013340
[ 6123.109171] Call Trace:
[ 6123.109276]  [<ffffffff8137e3bf>] schedule+0x5f/0x61
[ 6123.109343]  [<ffffffff8137d0a5>] schedule_timeout+0x31/0xde
[ 6123.109415]  [<ffffffff810d0efe>] ? __probe_kernel_read+0x36/0x55
[ 6123.109487]  [<ffffffff8110b76d>] ? kmem_cache_alloc+0x61/0x118
[ 6123.109557]  [<ffffffff8137da22>] __down_common+0x96/0xe4
[ 6123.109634]  [<ffffffffa02e04b8>] ? _xfs_buf_find+0x1ea/0x299 [xfs]
[ 6123.109704]  [<ffffffff8137dacf>] __down+0x18/0x1a
[ 6123.109771]  [<ffffffff81060428>] down+0x28/0x38
[ 6123.109844]  [<ffffffffa02df786>] xfs_buf_lock+0x6f/0xc0 [xfs]
[ 6123.109922]  [<ffffffffa02e04b8>] _xfs_buf_find+0x1ea/0x299 [xfs]
[ 6123.110000]  [<ffffffffa02e0713>] xfs_buf_get+0x25/0x172 [xfs]
[ 6123.110090]  [<ffffffffa02e087a>] xfs_buf_read+0x1a/0xc5 [xfs]
[ 6123.110169]  [<ffffffffa033bc4c>] xfs_trans_read_buf+0x35d/0x54d [xfs]
[ 6123.110258]  [<ffffffffa0326507>] xfs_imap_to_bp+0x45/0x1fe [xfs]
[ 6123.110345]  [<ffffffffa032873e>] xfs_iread+0x5b/0x195 [xfs]
[ 6123.110423]  [<ffffffffa02e5e59>] xfs_iget_cache_miss+0x5e/0x1cf [xfs]
[ 6123.110507]  [<ffffffffa02e64e3>] xfs_iget+0xf7/0x184 [xfs]
[ 6123.110591]  [<ffffffffa0325b36>] xfs_ialloc+0xc1/0x5ef [xfs]
[ 6123.110673]  [<ffffffffa02f3b4d>] ? kmem_zone_zalloc+0x1f/0x30 [xfs]
[ 6123.110757]  [<ffffffffa0336007>] ? xlog_grant_head_check+0x8f/0x101 
[xfs]
[ 6123.110842]  [<ffffffffa02f00e1>] xfs_dir_ialloc+0x9d/0x284 [xfs]
[ 6123.110926]  [<ffffffffa02f382e>] xfs_create+0x2f5/0x547 [xfs]
[ 6123.111006]  [<ffffffffa02ea4a2>] xfs_vn_mknod+0xcc/0x160 [xfs]
[ 6123.111086]  [<ffffffffa02ea557>] xfs_vn_create+0xe/0x10 [xfs]
[ 6123.111156]  [<ffffffff8111aaba>] vfs_create+0x67/0x89
[ 6123.111224]  [<ffffffff8111b942>] do_last+0x236/0x565
[ 6123.111292]  [<ffffffff8111c23a>] path_openat+0xcb/0x30c
[ 6123.111360]  [<ffffffff8111c56a>] do_filp_open+0x38/0x84
[ 6123.111429]  [<ffffffff8111a32f>] ? getname_flags+0x15b/0x1e2
[ 6123.111499]  [<ffffffff8112694b>] ? alloc_fd+0x6c/0xfc
[ 6123.111566]  [<ffffffff8110f26c>] do_sys_open+0x6f/0x101
[ 6123.111634]  [<ffffffff8110f32b>] sys_open+0x1c/0x1e
[ 6123.111702]  [<ffffffff813858f9>] system_call_fastpath+0x16/0x1b


See attached dmesg.txt

iostat:

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   81.80    1.40    10.22     0.18   
256.00   531.91 5349.11  12.02 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   83.40    1.20    10.37     0.15   
254.56   525.35 4350.67  11.82 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   79.20    0.80     9.90     0.10   
256.00   530.14 3153.38  12.50 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   72.80    2.20     9.09     0.13   
251.72   546.08 8709.54  13.33 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   79.80    1.40     9.95     0.12   
254.07   535.35 5172.22  12.32 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   99.60    1.20    12.41     0.08   
253.86   529.49 3560.89   9.92 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   60.80    1.40     7.59     0.11   
253.77   527.21 6545.50  16.08 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   79.00    1.80     9.84     0.08   
251.51   547.93 6400.42  12.38 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   82.20    2.20    10.25     0.01   
248.93   536.42 7415.77  11.85 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   89.40    2.20    11.17     0.01   
249.90   525.68 7232.96  10.92 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   82.00    1.20    10.22     0.08   
253.37   541.60 4170.95  12.02 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   62.80    2.60     7.85     0.14   
250.31   541.15 11260.81  15.29 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   85.00    1.80    10.61     0.21   
255.47   529.36 6514.85  11.52 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   75.20    1.40     9.38     0.11   
253.72   535.68 5416.70  13.05 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   66.80    1.20     8.33     0.11   
254.19   546.68 5459.11  14.71 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   81.40    0.80    10.15     0.10   
255.38   540.62 3171.57  12.17 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   72.20    1.20     9.02     0.15   
255.74   535.26 5345.51  13.62 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   91.00    1.00    11.35     0.12   
255.44   531.02 3637.72  10.87 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   81.00    1.60    10.12     0.20   
255.96   524.44 6513.22  12.11 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   72.80    2.40     9.04     0.26   
253.24   543.25 9071.66  13.30 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   73.80    1.20     9.18     0.15   
254.63   539.20 5087.91  13.33 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   79.20    1.40     9.90     0.18   
256.00   532.38 5592.38  12.41 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.20   79.40    1.00     9.90     0.12   
255.36   528.07 4091.22  12.44 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   88.40    1.20    11.05     0.15   
256.00   528.13 4349.35  11.16 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00   69.60    2.40     8.65     0.23   
252.71   527.46 9334.37  13.89 100.00


> Which indicates the problem is almost certainly related to the
> storage configuration or drivers, not the filesystem....
We have seen issues with xfs in the past but ofcourse this might be 
related to the drivers.
The storage configuration shouldn't be the problem here, note also 
changed it to 1MB stripe size.
I'll continue to look if I am able to find the issue in the hardware.

>
> Cheers,
>
> Dave.

Thanks

Kind regards

Matthew

--------------050107000807030808070102
Content-Type: text/plain; name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.2-custom (root@squeeze) (gcc version 4.4.5 (Debian 4.4.5-8) ) #2 SMP Wed Jun 13 15:11:14 CEST 2012
[    0.000000] Command line: vga=normal initrd=debian/squeeze/diskless/initrd.img-3.4.2-custom boot=live live-config noeject noswap noprompt nolocales edd=on nomodeset nosplash quickreboot scandelay=5 panic=60 debug=1 fetch=http://10.0.0.59/debian/squeeze/filesystem-3.4.2.squashfs BOOT_IMAGE=debian/squeeze/diskless/vmlinuz-3.4.2-custom auto
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000099800 (usable)
[    0.000000]  BIOS-e820: 0000000000099800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df780000 (usable)
[    0.000000]  BIOS-e820: 00000000df78e000 - 00000000df790000 type 9
[    0.000000]  BIOS-e820: 00000000df790000 - 00000000df79e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000df79e000 - 00000000df7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000df7d0000 - 00000000df7e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000df7ec000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000620000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: Supermicro X8ST3/X8ST3, BIOS 2.0        07/29/10  
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x620000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-E3FFF write-protect
[    0.000000]   E4000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FC00000000 write-back
[    0.000000]   1 base 0400000000 mask FE00000000 write-back
[    0.000000]   2 base 0600000000 mask FFE0000000 write-back
[    0.000000]   3 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   4 base 00DF800000 mask FFFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000df800000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdf780 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000094000] 94000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000df780000
[    0.000000]  0000000000 - 00df780000 page 4k
[    0.000000] kernel direct mapping tables up to df780000 @ 1f8ff000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000620000000
[    0.000000]  0100000000 - 0620000000 page 4k
[    0.000000] kernel direct mapping tables up to 620000000 @ dc666000-df780000
[    0.000000] RAMDISK: 797e3000 - 80000000
[    0.000000] ACPI: RSDP 00000000000faa70 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000df790100 00074 (v01 SMCI            20100729 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000df790290 000F4 (v03 072910 FACP2001 20100729 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000df790630 06761 (v01  1F580 1F580000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000df79e000 00040
[    0.000000] ACPI: APIC 00000000df790390 000D2 (v01 072910 APIC2001 20100729 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000df790470 0003C (v01 072910 OEMMCFG  20100729 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000df79e040 0007B (v01 072910 OEMB2001 20100729 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000df79a630 00038 (v01 072910 OEMHPET  20100729 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000df79ee90 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: EINJ 00000000df79a670 00130 (v01  AMIER AMI_EINJ 20100729 MSFT 00000097)
[    0.000000] ACPI: BERT 00000000df79a800 00030 (v01  AMIER AMI_BERT 20100729 MSFT 00000097)
[    0.000000] ACPI: ERST 00000000df79a830 001B0 (v01  AMIER AMI_ERST 20100729 MSFT 00000097)
[    0.000000] ACPI: HEST 00000000df79a9e0 000A8 (v01  AMIER ABC_HEST 20100729 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000620000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000620000000
[    0.000000]   NODE_DATA [000000061fffc000 - 000000061fffffff]
[    0.000000]  [ffffea0000000000-ffffea00187fffff] PMD -> [ffff880607600000-ffff88061f5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00620000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000099
[    0.000000]     0: 0x00000100 -> 0x000df780
[    0.000000]     0: 0x00100000 -> 0x00620000
[    0.000000] On node 0 totalpages: 6289161
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3908 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 894912 pages, LIFO batch:31
[    0.000000]   Normal zone: 83968 pages used for memmap
[    0.000000]   Normal zone: 5289984 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 16 CPUs, 12 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000099000 - 000000000009a000
[    0.000000] PM: Registered nosave memory: 000000000009a000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000df780000 - 00000000df78e000
[    0.000000] PM: Registered nosave memory: 00000000df78e000 - 00000000df790000
[    0.000000] PM: Registered nosave memory: 00000000df790000 - 00000000df79e000
[    0.000000] PM: Registered nosave memory: 00000000df79e000 - 00000000df7d0000
[    0.000000] PM: Registered nosave memory: 00000000df7d0000 - 00000000df7e0000
[    0.000000] PM: Registered nosave memory: 00000000df7e0000 - 00000000df7ec000
[    0.000000] PM: Registered nosave memory: 00000000df7ec000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at f0000000 (gap: f0000000:ee00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88061fc00000 s81728 r8192 d20672 u131072
[    0.000000] pcpu-alloc: s81728 r8192 d20672 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 6188804
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: vga=normal initrd=debian/squeeze/diskless/initrd.img-3.4.2-custom boot=live live-config noeject noswap noprompt nolocales edd=on nomodeset nosplash quickreboot scandelay=5 panic=60 debug=1 fetch=http://10.0.0.59/debian/squeeze/filesystem-3.4.2.squashfs BOOT_IMAGE=debian/squeeze/diskless/vmlinuz-3.4.2-custom auto
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 24531272k/25690112k available (3621k kernel code, 533468k absent, 625372k reserved, 3042k data, 588k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:808 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2133.265 MHz processor.
[    0.000004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4266.53 BogoMIPS (lpj=8533060)
[    0.000136] pid_max: default: 32768 minimum: 301
[    0.000230] Security Framework initialized
[    0.000300] SELinux:  Disabled at boot.
[    0.006470] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.016036] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.019229] Mount-cache hash table entries: 256
[    0.019537] Initializing cgroup subsys cpuacct
[    0.019602] Initializing cgroup subsys devices
[    0.019665] Initializing cgroup subsys freezer
[    0.019729] Initializing cgroup subsys net_cls
[    0.019815] CPU: Physical Processor ID: 0
[    0.019877] CPU: Processor Core ID: 0
[    0.019942] mce: CPU supports 9 MCE banks
[    0.020014] CPU0: Thermal monitoring enabled (TM1)
[    0.020083] using mwait in idle threads.
[    0.021034] ACPI: Core revision 20120320
[    0.046538] Switched APIC routing to physical flat.
[    0.047001] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.086750] CPU0: Intel(R) Xeon(R) CPU           E5506  @ 2.13GHz stepping 05
[    0.192402] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events, Intel PMU driver.
[    0.192639] CPU erratum AAJ80 worked around
[    0.192701] CPUID marked event: 'bus cycles' unavailable
[    0.192769] ... version:                3
[    0.192831] ... bit width:              48
[    0.192892] ... generic registers:      4
[    0.192955] ... value mask:             0000ffffffffffff
[    0.193020] ... max period:             000000007fffffff
[    0.193085] ... fixed-purpose events:   3
[    0.193147] ... event mask:             000000070000000f
[    0.193545] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.193700] Booting Node   0, Processors  #1
[    0.206837] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.207050]  #2
[    0.220240] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.220460]  #3
[    0.233654] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.233808] Brought up 4 CPUs
[    0.233869] Total of 4 processors activated (17066.12 BogoMIPS).
[    0.236419] devtmpfs: initialized
[    0.243047] PM: Registering ACPI NVS region [mem 0xdf79e000-0xdf7cffff] (204800 bytes)
[    0.243236] dummy: 
[    0.243351] NET: Registered protocol family 16
[    0.243700] ACPI: bus type pci registered
[    0.243827] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.243920] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.267994] PCI: Using configuration type 1 for base access
[    0.269061] bio: create slab <bio-0> at 0
[    0.269196] ACPI: Added _OSI(Module Device)
[    0.269260] ACPI: Added _OSI(Processor Device)
[    0.269323] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.269388] ACPI: Added _OSI(Processor Aggregator Device)
[    0.270346] ACPI: EC: Look up EC in DSDT
[    0.270828] \_SB_:_OSC evaluation returned wrong type
[    0.270893] _OSC request data:1 7 
[    0.271838] ACPI: Executed 1 blocks of module-level executable AML code
[    0.276104] ACPI: SSDT 00000000df79e0c0 008F0 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.276546] ACPI: Dynamic OEM Table Load:
[    0.276682] ACPI: SSDT           (null) 008F0 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    0.276943] ACPI: SSDT 00000000df79e9b0 004D5 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.277319] ACPI: Dynamic OEM Table Load:
[    0.277455] ACPI: SSDT           (null) 004D5 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    0.278026] ACPI: Interpreter enabled
[    0.278089] ACPI: (supports S0 S1 S4 S5)
[    0.278314] ACPI: Using IOAPIC for interrupt routing
[    0.285806] ACPI: No dock devices found.
[    0.285871] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.286053] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.286277] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.286348] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.286417] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.286503] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.286589] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]
[    0.286702] PCI host bridge to bus 0000:00
[    0.286766] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.286835] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.286903] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.286974] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.287044] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfed8ffff]
[    0.287126] pci 0000:00:00.0: [8086:3405] type 00 class 0x060000
[    0.287252] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.287345] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    0.287474] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.287566] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    0.287693] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.287786] pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
[    0.287914] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.288005] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    0.288133] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.288225] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    0.288353] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.288452] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    0.288591] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    0.288733] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    0.288868] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    0.288999] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[    0.289079] pci 0000:00:16.0: reg 10: [mem 0xfbef8000-0xfbefbfff 64bit]
[    0.289223] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[    0.289302] pci 0000:00:16.1: reg 10: [mem 0xfbef4000-0xfbef7fff 64bit]
[    0.289446] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[    0.289525] pci 0000:00:16.2: reg 10: [mem 0xfbef0000-0xfbef3fff 64bit]
[    0.289669] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[    0.289748] pci 0000:00:16.3: reg 10: [mem 0xfbeec000-0xfbeeffff 64bit]
[    0.289893] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[    0.289972] pci 0000:00:16.4: reg 10: [mem 0xfbee8000-0xfbeebfff 64bit]
[    0.290115] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[    0.290194] pci 0000:00:16.5: reg 10: [mem 0xfbee4000-0xfbee7fff 64bit]
[    0.290341] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[    0.290420] pci 0000:00:16.6: reg 10: [mem 0xfbee0000-0xfbee3fff 64bit]
[    0.290565] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[    0.290644] pci 0000:00:16.7: reg 10: [mem 0xfbedc000-0xfbedffff 64bit]
[    0.290790] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    0.290900] pci 0000:00:1a.0: reg 20: [io  0xac00-0xac1f]
[    0.291019] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    0.291129] pci 0000:00:1a.1: reg 20: [io  0xa880-0xa89f]
[    0.291248] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    0.291358] pci 0000:00:1a.2: reg 20: [io  0xa800-0xa81f]
[    0.291486] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    0.291574] pci 0000:00:1a.7: reg 10: [mem 0xfbeda000-0xfbeda3ff]
[    0.291735] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.291826] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    0.291965] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.292056] pci 0000:00:1c.1: [8086:3a42] type 01 class 0x060400
[    0.292196] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.292299] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    0.292412] pci 0000:00:1d.0: reg 20: [io  0xa480-0xa49f]
[    0.292531] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    0.292641] pci 0000:00:1d.1: reg 20: [io  0xa400-0xa41f]
[    0.292759] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    0.292872] pci 0000:00:1d.2: reg 20: [io  0xa080-0xa09f]
[    0.293000] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    0.293088] pci 0000:00:1d.7: reg 10: [mem 0xfbed8000-0xfbed83ff]
[    0.293249] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.293338] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.293470] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    0.293620] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 4700 (mask 0097)
[    0.293708] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 03e8 (mask 000f)
[    0.293796] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1640 (mask 000f)
[    0.293885] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
[    0.294020] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
[    0.294106] pci 0000:00:1f.2: reg 10: [io  0x9480-0x9487]
[    0.294178] pci 0000:00:1f.2: reg 14: [io  0xa000-0xa003]
[    0.294251] pci 0000:00:1f.2: reg 18: [io  0x9c00-0x9c07]
[    0.294323] pci 0000:00:1f.2: reg 1c: [io  0x9880-0x9883]
[    0.294395] pci 0000:00:1f.2: reg 20: [io  0x9800-0x981f]
[    0.294468] pci 0000:00:1f.2: reg 24: [mem 0xfbed6000-0xfbed67ff]
[    0.294583] pci 0000:00:1f.2: PME# supported from D3hot
[    0.294666] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    0.294748] pci 0000:00:1f.3: reg 10: [mem 0xfbed4000-0xfbed40ff 64bit]
[    0.294838] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.300448] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.300558] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.300668] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    0.300789] pci 0000:04:00.0: [1000:0079] type 00 class 0x010400
[    0.300865] pci 0000:04:00.0: reg 10: [io  0xb000-0xb0ff]
[    0.300940] pci 0000:04:00.0: reg 14: [mem 0xfb87c000-0xfb87ffff 64bit]
[    0.301019] pci 0000:04:00.0: reg 1c: [mem 0xfb8c0000-0xfb8fffff 64bit]
[    0.301101] pci 0000:04:00.0: reg 30: [mem 0xfb880000-0xfb8bffff pref]
[    0.301210] pci 0000:04:00.0: supports D1 D2
[    0.308409] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.308480] pci 0000:00:07.0:   bridge window [io  0xb000-0xbfff]
[    0.308552] pci 0000:00:07.0:   bridge window [mem 0xfb800000-0xfb8fffff]
[    0.308848] pci 0000:05:00.0: [1000:0058] type 00 class 0x010000
[    0.308925] pci 0000:05:00.0: reg 10: [io  0xc000-0xc0ff]
[    0.309002] pci 0000:05:00.0: reg 14: [mem 0xfb9ec000-0xfb9effff 64bit]
[    0.309081] pci 0000:05:00.0: reg 1c: [mem 0xfb9f0000-0xfb9fffff 64bit]
[    0.309164] pci 0000:05:00.0: reg 30: [mem 0xfba00000-0xfbbfffff pref]
[    0.309273] pci 0000:05:00.0: supports D1 D2
[    0.309349] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.309447] pci 0000:00:09.0: PCI bridge to [bus 05-05]
[    0.309515] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    0.309584] pci 0000:00:09.0:   bridge window [mem 0xfb900000-0xfbbfffff]
[    0.309725] pci 0000:06:00.0: [8086:10d3] type 00 class 0x020000
[    0.309816] pci 0000:06:00.0: reg 10: [mem 0xfbce0000-0xfbcfffff]
[    0.309916] pci 0000:06:00.0: reg 18: [io  0xdc00-0xdc1f]
[    0.309997] pci 0000:06:00.0: reg 1c: [mem 0xfbcdc000-0xfbcdffff]
[    0.310206] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.316417] pci 0000:00:1c.0: PCI bridge to [bus 06-06]
[    0.316489] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.316559] pci 0000:00:1c.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    0.316700] pci 0000:07:00.0: [8086:10d3] type 00 class 0x020000
[    0.316791] pci 0000:07:00.0: reg 10: [mem 0xfbde0000-0xfbdfffff]
[    0.316890] pci 0000:07:00.0: reg 18: [io  0xec00-0xec1f]
[    0.316972] pci 0000:07:00.0: reg 1c: [mem 0xfbddc000-0xfbddffff]
[    0.317181] pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
[    0.324420] pci 0000:00:1c.1: PCI bridge to [bus 07-07]
[    0.324492] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    0.324562] pci 0000:00:1c.1:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    0.324672] pci 0000:08:04.0: [102b:0532] type 00 class 0x030000
[    0.324756] pci 0000:08:04.0: reg 10: [mem 0xf9000000-0xf9ffffff pref]
[    0.324833] pci 0000:08:04.0: reg 14: [mem 0xfaffc000-0xfaffffff]
[    0.324909] pci 0000:08:04.0: reg 18: [mem 0xfb000000-0xfb7fffff]
[    0.325075] pci 0000:00:1e.0: PCI bridge to [bus 08-08] (subtractive decode)
[    0.325149] pci 0000:00:1e.0:   bridge window [mem 0xfaf00000-0xfb7fffff]
[    0.325222] pci 0000:00:1e.0:   bridge window [mem 0xf9000000-0xf9ffffff 64bit pref]
[    0.325310] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.325398] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.325486] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.325577] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.325667] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff] (subtractive decode)
[    0.325788] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.326171] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.326348] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.326450] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.326560] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    0.326663] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    0.326766] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE5._PRT]
[    0.326870] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    0.326973] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9._PRT]
[    0.327075]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.327144]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.327232] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.345539] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.346053] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.346565] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.347076] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.347587] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    0.348191] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 *7 10 11 12 14 15)
[    0.348708] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
[    0.349316] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *6 7 10 11 12 14 15)
[    0.349874] vgaarb: device added: PCI:0000:08:04.0,decodes=io+mem,owns=io+mem,locks=none
[    0.349963] vgaarb: loaded
[    0.350022] vgaarb: bridge control possible 0000:08:04.0
[    0.350134] wmi: Mapper loaded
[    0.350194] PCI: Using ACPI for IRQ routing
[    0.356839] PCI: Discovered peer bus ff
[    0.356901] PCI: root bus ff: using default resources
[    0.356988] PCI host bridge to bus 0000:ff
[    0.357052] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    0.357120] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xffffffffff]
[    0.357195] pci 0000:ff:00.0: [8086:2c40] type 00 class 0x060000
[    0.357282] pci 0000:ff:00.1: [8086:2c01] type 00 class 0x060000
[    0.357370] pci 0000:ff:02.0: [8086:2c10] type 00 class 0x060000
[    0.357457] pci 0000:ff:02.1: [8086:2c11] type 00 class 0x060000
[    0.357543] pci 0000:ff:02.4: [8086:2c14] type 00 class 0x060000
[    0.357627] pci 0000:ff:02.5: [8086:2c15] type 00 class 0x060000
[    0.357713] pci 0000:ff:03.0: [8086:2c18] type 00 class 0x060000
[    0.357798] pci 0000:ff:03.1: [8086:2c19] type 00 class 0x060000
[    0.357882] pci 0000:ff:03.2: [8086:2c1a] type 00 class 0x060000
[    0.357967] pci 0000:ff:03.4: [8086:2c1c] type 00 class 0x060000
[    0.358052] pci 0000:ff:04.0: [8086:2c20] type 00 class 0x060000
[    0.358139] pci 0000:ff:04.1: [8086:2c21] type 00 class 0x060000
[    0.358223] pci 0000:ff:04.2: [8086:2c22] type 00 class 0x060000
[    0.358308] pci 0000:ff:04.3: [8086:2c23] type 00 class 0x060000
[    0.358394] pci 0000:ff:05.0: [8086:2c28] type 00 class 0x060000
[    0.358478] pci 0000:ff:05.1: [8086:2c29] type 00 class 0x060000
[    0.358563] pci 0000:ff:05.2: [8086:2c2a] type 00 class 0x060000
[    0.358647] pci 0000:ff:05.3: [8086:2c2b] type 00 class 0x060000
[    0.358733] pci 0000:ff:06.0: [8086:2c30] type 00 class 0x060000
[    0.358821] pci 0000:ff:06.1: [8086:2c31] type 00 class 0x060000
[    0.358906] pci 0000:ff:06.2: [8086:2c32] type 00 class 0x060000
[    0.358990] pci 0000:ff:06.3: [8086:2c33] type 00 class 0x060000
[    0.359546] PCI: pci_cache_line_size set to 64 bytes
[    0.359757] reserve RAM buffer: 0000000000099800 - 000000000009ffff 
[    0.359811] reserve RAM buffer: 00000000df780000 - 00000000dfffffff 
[    0.360088] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.360214] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.360467] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.369710] Switching to clocksource hpet
[    0.371688] pnp: PnP ACPI init
[    0.371760] ACPI: bus type pnp registered
[    0.371920] pnp 00:00: [bus 00-ff]
[    0.371982] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.372045] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.372110] pnp 00:00: [io  0x0d00-0xffff window]
[    0.372175] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.372241] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.372308] pnp 00:00: [mem 0xe0000000-0xdfffffff window disabled]
[    0.372376] pnp 00:00: [mem 0xf0000000-0xfed8ffff window]
[    0.372493] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.372589] pnp 00:01: [mem 0xfbf00000-0xfbffffff]
[    0.372654] pnp 00:01: [mem 0xfc000000-0xfcffffff]
[    0.372719] pnp 00:01: [mem 0xfd000000-0xfdffffff]
[    0.372783] pnp 00:01: [mem 0xfe000000-0xfebfffff]
[    0.372848] pnp 00:01: [mem 0xfec8a000-0xfec8afff]
[    0.372912] pnp 00:01: [mem 0xfed10000-0xfed10fff]
[    0.373038] system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
[    0.373109] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    0.373179] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    0.373249] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    0.373319] system 00:01: [mem 0xfec8a000-0xfec8afff] has been reserved
[    0.373389] system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
[    0.373459] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.373560] pnp 00:02: [dma 4]
[    0.373620] pnp 00:02: [io  0x0000-0x000f]
[    0.373683] pnp 00:02: [io  0x0081-0x0083]
[    0.373745] pnp 00:02: [io  0x0087]
[    0.373815] pnp 00:02: [io  0x0089-0x008b]
[    0.373878] pnp 00:02: [io  0x008f]
[    0.373941] pnp 00:02: [io  0x00c0-0x00df]
[    0.374027] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.374104] pnp 00:03: [io  0x0070-0x0071]
[    0.374175] pnp 00:03: [irq 8]
[    0.374254] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.374329] pnp 00:04: [io  0x0061]
[    0.374413] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.374490] pnp 00:05: [io  0x00f0-0x00ff]
[    0.374557] pnp 00:05: [irq 13]
[    0.374638] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.374982] pnp 00:06: [io  0x03f8-0x03ff]
[    0.375050] pnp 00:06: [irq 4]
[    0.375111] pnp 00:06: [dma 0 disabled]
[    0.375241] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.375575] pnp 00:07: [io  0x02f8-0x02ff]
[    0.375643] pnp 00:07: [irq 3]
[    0.375703] pnp 00:07: [dma 0 disabled]
[    0.375858] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.376401] pnp 00:08: [io  0x03e8-0x03ef]
[    0.376469] pnp 00:08: [irq 5]
[    0.376529] pnp 00:08: [dma 0 disabled]
[    0.376659] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.376785] pnp 00:09: [io  0x164e-0x164f]
[    0.376849] pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
[    0.376972] system 00:09: [io  0x164e-0x164f] has been reserved
[    0.377042] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.377241] pnp 00:0a: [io  0x0000-0xffffffffffffffff disabled]
[    0.377309] pnp 00:0a: [io  0x0a00-0x0a0f]
[    0.377372] pnp 00:0a: [io  0x0ca0-0x0caf]
[    0.382958] system 00:0a: [io  0x0a00-0x0a0f] has been reserved
[    0.383027] system 00:0a: [io  0x0ca0-0x0caf] has been reserved
[    0.383096] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.383290] pnp 00:0b: [io  0x0010-0x001f]
[    0.383354] pnp 00:0b: [io  0x0022-0x003f]
[    0.383417] pnp 00:0b: [io  0x0044-0x005f]
[    0.383479] pnp 00:0b: [io  0x0062-0x0063]
[    0.383542] pnp 00:0b: [io  0x0065-0x006f]
[    0.383605] pnp 00:0b: [io  0x0072-0x007f]
[    0.383667] pnp 00:0b: [io  0x0080]
[    0.383732] pnp 00:0b: [io  0x0084-0x0086]
[    0.383795] pnp 00:0b: [io  0x0088]
[    0.383856] pnp 00:0b: [io  0x008c-0x008e]
[    0.383918] pnp 00:0b: [io  0x0090-0x009f]
[    0.383981] pnp 00:0b: [io  0x00a2-0x00bf]
[    0.384043] pnp 00:0b: [io  0x00e0-0x00ef]
[    0.384106] pnp 00:0b: [io  0x04d0-0x04d1]
[    0.384169] pnp 00:0b: [io  0x0800-0x087f]
[    0.384232] pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
[    0.384299] pnp 00:0b: [io  0x0500-0x057f]
[    0.384362] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
[    0.384426] pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
[    0.384491] pnp 00:0b: [mem 0xfed40000-0xfed8ffff]
[    0.384637] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    0.384706] system 00:0b: [io  0x0800-0x087f] has been reserved
[    0.384774] system 00:0b: [io  0x0500-0x057f] has been reserved
[    0.384844] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.384914] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.384984] system 00:0b: [mem 0xfed40000-0xfed8ffff] has been reserved
[    0.385055] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.385184] pnp 00:0c: [mem 0xfed00000-0xfed003ff]
[    0.385274] pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.385426] pnp 00:0d: [io  0x0060]
[    0.385487] pnp 00:0d: [io  0x0064]
[    0.385549] pnp 00:0d: [mem 0xfec00000-0xfec00fff]
[    0.385614] pnp 00:0d: [mem 0xfee00000-0xfee00fff]
[    0.385740] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.385819] system 00:0d: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.385890] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.386008] pnp 00:0e: [mem 0xe0000000-0xefffffff]
[    0.386129] system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
[    0.386201] system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.386456] pnp 00:0f: [mem 0x00000000-0x0009ffff]
[    0.386521] pnp 00:0f: [mem 0x000c0000-0x000cffff]
[    0.386586] pnp 00:0f: [mem 0x000e0000-0x000fffff]
[    0.386651] pnp 00:0f: [mem 0x00100000-0xdfffffff]
[    0.386715] pnp 00:0f: [mem 0xfed90000-0xffffffff]
[    0.386855] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.386926] system 00:0f: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.386998] system 00:0f: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.387069] system 00:0f: [mem 0x00100000-0xdfffffff] could not be reserved
[    0.387139] system 00:0f: [mem 0xfed90000-0xffffffff] could not be reserved
[    0.387211] system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.387417] pnp: PnP ACPI: found 16 devices
[    0.387480] ACPI: ACPI bus type pnp unregistered
[    0.393885] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 06-06] add_size 200000
[    0.393987] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 07-07] add_size 200000
[    0.394097] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.394190] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.394286] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.394375] pci 0000:00:1c.1: BAR 15: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.394463] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.394536] pci 0000:00:03.0: PCI bridge to [bus 02-02]
[    0.394609] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    0.394681] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.394748] pci 0000:00:07.0:   bridge window [io  0xb000-0xbfff]
[    0.394819] pci 0000:00:07.0:   bridge window [mem 0xfb800000-0xfb8fffff]
[    0.394893] pci 0000:00:09.0: PCI bridge to [bus 05-05]
[    0.394959] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    0.395030] pci 0000:00:09.0:   bridge window [mem 0xfb900000-0xfbbfffff]
[    0.395105] pci 0000:00:1c.0: PCI bridge to [bus 06-06]
[    0.395171] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.395242] pci 0000:00:1c.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    0.395314] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.395405] pci 0000:00:1c.1: PCI bridge to [bus 07-07]
[    0.395472] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    0.395542] pci 0000:00:1c.1:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    0.395614] pci 0000:00:1c.1:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.395705] pci 0000:00:1e.0: PCI bridge to [bus 08-08]
[    0.395774] pci 0000:00:1e.0:   bridge window [mem 0xfaf00000-0xfb7fffff]
[    0.395845] pci 0000:00:1e.0:   bridge window [mem 0xf9000000-0xf9ffffff 64bit pref]
[    0.395979] pci 0000:00:1e.0: setting latency timer to 64
[    0.396047] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.396114] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.396181] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.396250] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.396318] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfed8ffff]
[    0.396386] pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
[    0.396452] pci_bus 0000:04: resource 1 [mem 0xfb800000-0xfb8fffff]
[    0.396521] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.396587] pci_bus 0000:05: resource 1 [mem 0xfb900000-0xfbbfffff]
[    0.396656] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    0.396723] pci_bus 0000:06: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    0.396791] pci_bus 0000:06: resource 2 [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.396877] pci_bus 0000:07: resource 0 [io  0xe000-0xefff]
[    0.396943] pci_bus 0000:07: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    0.397012] pci_bus 0000:07: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.397098] pci_bus 0000:08: resource 1 [mem 0xfaf00000-0xfb7fffff]
[    0.397166] pci_bus 0000:08: resource 2 [mem 0xf9000000-0xf9ffffff 64bit pref]
[    0.397252] pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
[    0.397319] pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
[    0.397386] pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
[    0.397454] pci_bus 0000:08: resource 7 [mem 0x000d0000-0x000dffff]
[    0.397521] pci_bus 0000:08: resource 8 [mem 0xf0000000-0xfed8ffff]
[    0.397590] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    0.397657] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xffffffffff]
[    0.397768] NET: Registered protocol family 2
[    0.398685] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.401045] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.402786] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.403019] TCP: Hash tables configured (established 524288 bind 65536)
[    0.403088] TCP: reno registered
[    0.403250] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    0.403523] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    0.403793] NET: Registered protocol family 1
[    0.404142] PCI: CLS mismatch (256 != 64), using 64 bytes
[    0.404216] pci 0000:08:04.0: Boot video device
[    0.404350] Unpacking initramfs...
[    2.883437] debug: unmapping init memory ffff8800797e3000..ffff880080000000
[    2.885419] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.885490] Placing 64MB software IO TLB between ffff8800d8666000 - ffff8800dc666000
[    2.885577] software IO TLB at phys 0xd8666000 - 0xdc666000
[    2.886217] audit: initializing netlink socket (disabled)
[    2.886294] type=2000 audit(1339704893.760:1): initialized
[    2.902216] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.903969] VFS: Disk quotas dquot_6.5.2
[    2.904081] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.904253] msgmni has been set to 32768
[    2.904491] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.904578] io scheduler noop registered
[    2.904640] io scheduler deadline registered
[    2.904759] io scheduler cfq registered (default)
[    2.905171] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    2.905331] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    2.905581] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.926053] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.946529] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.967002] serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
[    2.987608] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.008113] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.028615] 00:08: ttyS2 at I/O 0x3e8 (irq = 5) is a 16550A
[    3.028981] Non-volatile memory driver v1.3
[    3.029046] Linux agpgart interface v0.103
[    3.029252] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.031768] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.031837] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.032001] mousedev: PS/2 mouse device common for all mice
[    3.032108] rtc_cmos 00:03: RTC can wake from S4
[    3.032269] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    3.032362] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.032440] cpuidle: using governor ladder
[    3.032503] cpuidle: using governor menu
[    3.032685] fujitsu_laptop: driver 0.6.0 successfully loaded
[    3.032840] TCP: cubic registered
[    3.033012] NET: Registered protocol family 10
[    3.033317] Mobile IPv6
[    3.033377] NET: Registered protocol family 17
[    3.033443] Registering the dns_resolver key type
[    3.033678] PM: Hibernation image not present or could not be loaded.
[    3.033753] registered taskstats version 1
[    3.034424] rtc_cmos 00:03: setting system clock to 2012-06-14 20:14:54 UTC (1339704894)
[    3.034555] Initializing network drop monitor service
[    3.173806] debug: unmapping init memory ffffffff81684000..ffffffff81717000
[    3.179434] Write protecting the kernel read-only data: 6144k
[    3.179638] debug: unmapping init memory ffff88000138e000..ffff880001400000
[    3.179757] debug: unmapping init memory ffff880001548000..ffff880001600000
[    3.199066] udev[58]: starting version 164
[    3.220786] SCSI subsystem initialized
[    3.227955] Fusion MPT base driver 3.04.20
[    3.228022] Copyright (c) 1999-2008 LSI Corporation
[    3.229635] Fusion MPT SAS Host driver 3.04.20
[    3.255387] e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
[    3.255460] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    3.255553] e1000e 0000:06:00.0: Disabling ASPM L0s 
[    3.255767] e1000e 0000:06:00.0: (unregistered net_device): Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    3.255954] e1000e 0000:06:00.0: irq 42 for MSI/MSI-X
[    3.256007] usbcore: registered new interface driver usbfs
[    3.256034] usbcore: registered new interface driver hub
[    3.256156] e1000e 0000:06:00.0: irq 43 for MSI/MSI-X
[    3.256228] e1000e 0000:06:00.0: irq 44 for MSI/MSI-X
[    3.257978] usbcore: registered new device driver usb
[    3.258821] megasas: 00.00.06.15-rc1 Mon. Mar. 19 17:00:00 PDT 2012
[    3.258914] megasas: 0x1000:0x0079:0x1028:0x1f15: bus 4:slot 0:func 0
[    3.259044] mptbase: ioc0: Initiating bringup
[    3.259119] megasas: FW now in Ready state
[    3.259213] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.259299] megaraid_sas 0000:04:00.0: irq 45 for MSI/MSI-X
[    3.259321] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    3.259325] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.259350] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    3.259384] ehci_hcd 0000:00:1a.7: debug port 1
[    3.260733] libata version 3.00 loaded.
[    3.263280] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    3.263370] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfbeda000
[    3.273890] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    3.273982] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.274053] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.274139] usb usb1: Product: EHCI Host Controller
[    3.274204] usb usb1: Manufacturer: Linux 3.4.2-custom ehci_hcd
[    3.274273] usb usb1: SerialNumber: 0000:00:1a.7
[    3.274455] hub 1-0:1.0: USB hub found
[    3.274521] hub 1-0:1.0: 6 ports detected
[    3.274735] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.274804] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.274878] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    3.274991] ehci_hcd 0000:00:1d.7: debug port 1
[    3.278934] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    3.279020] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfbed8000
[    3.285809] megasas_init_mfi: fw_support_ieee=67108864
[    3.285869] megasas: INIT adapter done
[    3.289816] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.289903] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.289973] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.290059] usb usb2: Product: EHCI Host Controller
[    3.290124] usb usb2: Manufacturer: Linux 3.4.2-custom ehci_hcd
[    3.290191] usb usb2: SerialNumber: 0000:00:1d.7
[    3.290349] hub 2-0:1.0: USB hub found
[    3.290414] hub 2-0:1.0: 6 ports detected
[    3.290564] ahci 0000:00:1f.2: version 3.0
[    3.290689] ahci 0000:00:1f.2: irq 46 for MSI/MSI-X
[    3.290794] ahci: SSS flag set, parallel bus scan disabled
[    3.290903] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    3.290993] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems sxs 
[    3.291086] ahci 0000:00:1f.2: setting latency timer to 64
[    3.291399] uhci_hcd: USB Universal Host Controller Interface driver
[    3.330299] scsi1 : ahci
[    3.330438] scsi2 : ahci
[    3.330560] scsi3 : ahci
[    3.330688] scsi4 : ahci
[    3.330811] scsi5 : ahci
[    3.330933] scsi6 : ahci
[    3.331148] ata1: SATA max UDMA/133 abar m2048@0xfbed6000 port 0xfbed6100 irq 46
[    3.331237] ata2: SATA max UDMA/133 abar m2048@0xfbed6000 port 0xfbed6180 irq 46
[    3.331324] ata3: SATA max UDMA/133 abar m2048@0xfbed6000 port 0xfbed6200 irq 46
[    3.331411] ata4: SATA max UDMA/133 abar m2048@0xfbed6000 port 0xfbed6280 irq 46
[    3.331499] ata5: SATA max UDMA/133 abar m2048@0xfbed6000 port 0xfbed6300 irq 46
[    3.331586] ata6: SATA max UDMA/133 abar m2048@0xfbed6000 port 0xfbed6380 irq 46
[    3.331709] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.331779] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.331854] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    3.331978] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ac00
[    3.332083] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.332153] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.332239] usb usb3: Product: UHCI Host Controller
[    3.332304] usb usb3: Manufacturer: Linux 3.4.2-custom uhci_hcd
[    3.332371] usb usb3: SerialNumber: 0000:00:1a.0
[    3.332537] hub 3-0:1.0: USB hub found
[    3.332602] hub 3-0:1.0: 2 ports detected
[    3.332764] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    3.332833] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.332904] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    3.333021] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a880
[    3.333117] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.333188] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.333274] usb usb4: Product: UHCI Host Controller
[    3.333339] usb usb4: Manufacturer: Linux 3.4.2-custom uhci_hcd
[    3.333406] usb usb4: SerialNumber: 0000:00:1a.1
[    3.333560] hub 4-0:1.0: USB hub found
[    3.333625] hub 4-0:1.0: 2 ports detected
[    3.333768] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    3.333847] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    3.333918] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    3.334036] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000a800
[    3.334133] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.334203] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.334289] usb usb5: Product: UHCI Host Controller
[    3.334353] usb usb5: Manufacturer: Linux 3.4.2-custom uhci_hcd
[    3.334420] usb usb5: SerialNumber: 0000:00:1a.2
[    3.334573] hub 5-0:1.0: USB hub found
[    3.334638] hub 5-0:1.0: 2 ports detected
[    3.334781] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.334850] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.334925] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    3.335034] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a480
[    3.335129] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.335200] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.335285] usb usb6: Product: UHCI Host Controller
[    3.335350] usb usb6: Manufacturer: Linux 3.4.2-custom uhci_hcd
[    3.335417] usb usb6: SerialNumber: 0000:00:1d.0
[    3.335568] hub 6-0:1.0: USB hub found
[    3.335633] hub 6-0:1.0: 2 ports detected
[    3.335775] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.335844] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.335915] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    3.336023] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000a400
[    3.336121] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    3.336191] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.336277] usb usb7: Product: UHCI Host Controller
[    3.336342] usb usb7: Manufacturer: Linux 3.4.2-custom uhci_hcd
[    3.336409] usb usb7: SerialNumber: 0000:00:1d.1
[    3.336560] hub 7-0:1.0: USB hub found
[    3.336625] hub 7-0:1.0: 2 ports detected
[    3.336766] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.336835] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.336906] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    3.337014] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a080
[    3.337110] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    3.337180] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.337266] usb usb8: Product: UHCI Host Controller
[    3.337331] usb usb8: Manufacturer: Linux 3.4.2-custom uhci_hcd
[    3.342892] usb usb8: SerialNumber: 0000:00:1d.2
[    3.343044] hub 8-0:1.0: USB hub found
[    3.343108] hub 8-0:1.0: 2 ports detected
[    3.357808] scsi0 : LSI SAS based MegaRAID driver
[    3.365218] e1000e 0000:06:00.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:25:90:22:b5:de
[    3.365315] e1000e 0000:06:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.365481] e1000e 0000:06:00.0: eth0: MAC: 3, PHY: 8, PBA No: 0101FF-0FF
[    3.365569] e1000e 0000:07:00.0: Disabling ASPM L0s 
[    3.365811] e1000e 0000:07:00.0: (unregistered net_device): Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    3.366012] e1000e 0000:07:00.0: irq 47 for MSI/MSI-X
[    3.366088] e1000e 0000:07:00.0: irq 48 for MSI/MSI-X
[    3.366163] e1000e 0000:07:00.0: irq 49 for MSI/MSI-X
[    3.369434] scsi 0:1:44:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.372207] scsi 0:1:45:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.374954] scsi 0:1:46:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.377692] scsi 0:1:47:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.380459] scsi 0:1:48:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.384160] scsi 0:1:49:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.386904] scsi 0:1:50:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.389653] scsi 0:1:51:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.392433] scsi 0:1:52:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.395167] scsi 0:1:53:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.397894] scsi 0:1:54:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.400627] scsi 0:1:55:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.403362] scsi 0:1:56:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.406091] scsi 0:1:57:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.408805] scsi 0:1:58:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.411525] scsi 0:1:59:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.414256] scsi 0:1:60:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.416986] scsi 0:1:61:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.419715] scsi 0:1:62:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.422441] scsi 0:1:63:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.425162] scsi 0:1:64:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.427970] scsi 0:1:65:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.430696] scsi 0:1:66:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.433428] scsi 0:1:67:0: Direct-Access     ATA      Hitachi HDS5C302 A580 PQ: 0 ANSI: 5
[    3.436897] scsi 0:2:1:0: Direct-Access     DELL     PERC H800        2.10 PQ: 0 ANSI: 5
[    3.486731] e1000e 0000:07:00.0: eth1: (PCI Express:2.5GT/s:Width x1) 00:25:90:22:b5:df
[    3.486822] e1000e 0000:07:00.0: eth1: Intel(R) PRO/1000 Network Connection
[    3.486976] e1000e 0000:07:00.0: eth1: MAC: 3, PHY: 8, PBA No: 0101FF-0FF
[    3.649791] ata1: SATA link down (SStatus 0 SControl 300)
[    3.845780] ioc0: LSISAS1068E B3: Capabilities={Initiator}
[    3.881784] Refined TSC clocksource calibration: 2133.331 MHz.
[    3.881789] usb 3-1: new low-speed USB device number 2 using uhci_hcd
[    3.881932] Switching to clocksource tsc
[    3.969784] ata2: SATA link down (SStatus 0 SControl 300)
[    4.209083] usb 3-1: New USB device found, idVendor=046d, idProduct=c30e
[    4.209159] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.209230] usb 3-1: Product: HID compliant keyboard
[    4.209295] usb 3-1: Manufacturer: Logitech
[    4.289787] ata3: SATA link down (SStatus 0 SControl 300)
[    4.320296] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input0
[    4.320441] generic-usb 0003:046D:C30E.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1/input0
[    4.449166] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.1/input/input1
[    4.449300] generic-usb 0003:046D:C30E.0002: input,hidraw1: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1/input1
[    4.449415] usbcore: registered new interface driver usbhid
[    4.449482] usbhid: USB HID core driver
[    4.457781] usb 5-2: new full-speed USB device number 2 using uhci_hcd
[    4.609789] ata4: SATA link down (SStatus 0 SControl 300)
[    4.633135] usb 5-2: New USB device found, idVendor=046b, idProduct=ff10
[    4.633211] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.633282] usb 5-2: Product: Virtual Keyboard and Mouse
[    4.633347] usb 5-2: Manufacturer: American Megatrends Inc.
[    4.633414] usb 5-2: SerialNumber: serial
[    4.674343] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input2
[    4.674481] generic-usb 0003:046B:FF10.0003: input,hidraw2: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.2-2/input0
[    4.691306] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.1/input/input3
[    4.691460] generic-usb 0003:046B:FF10.0004: input,hidraw3: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.2-2/input1
[    4.929787] ata5: SATA link down (SStatus 0 SControl 300)
[    5.249784] ata6: SATA link down (SStatus 0 SControl 300)
[    5.254453] sd 0:2:1:0: [sda] 85930803200 512-byte logical blocks: (43.9 TB/40.0 TiB)
[    5.254599] sd 0:2:1:0: [sda] Write Protect is off
[    5.254672] sd 0:2:1:0: [sda] Mode Sense: 1f 00 00 08
[    5.254775] sd 0:2:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.267376]  sda: unknown partition table
[    5.267654] sd 0:2:1:0: [sda] Attached SCSI disk
[   17.075651] scsi7 : ioc0: LSISAS1068E B3, FwRev=011a0000h, Ports=1, MaxQ=478, IRQ=16
[   17.265656] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   17.347679] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   20.014769] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   20.016371] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   20.363519] Uniform Multi-Platform E-IDE driver
[   20.364148] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[   20.364248] Probing IDE interface ide0...
[   20.925821] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   20.925940] Probing IDE interface ide1...
[   21.485817] ide1 at 0x170-0x177,0x376 on irq 15
[   30.089802] eth0: no IPv6 routers present
[   59.033035] aufs 3.4-20120521
[   59.044924] loop: module loaded
[   59.106801] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   60.098888] udev[942]: starting version 164
[   60.140234] ACPI: Requesting acpi_cpufreq
[   60.143507] Monitor-Mwait will be used to enter C-1 state
[   60.143647] Monitor-Mwait will be used to enter C-2 state
[   60.144297] Monitor-Mwait will be used to enter C-3 state
[   60.144384] ACPI: acpi_idle registered with cpuidle
[   60.145441] dca service started, version 1.12.1
[   60.148621] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
[   60.148716] ACPI: Power Button [PWRB]
[   60.150451] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[   60.150546] ACPI: Power Button [PWRF]
[   60.167133] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   60.167364] ioatdma 0000:00:16.0: irq 50 for MSI/MSI-X
[   60.167797] ioatdma 0000:00:16.1: irq 51 for MSI/MSI-X
[   60.168227] ioatdma 0000:00:16.2: irq 52 for MSI/MSI-X
[   60.168609] ioatdma 0000:00:16.3: irq 53 for MSI/MSI-X
[   60.169000] ioatdma 0000:00:16.4: irq 54 for MSI/MSI-X
[   60.169478] ioatdma 0000:00:16.5: irq 55 for MSI/MSI-X
[   60.169895] ioatdma 0000:00:16.6: irq 56 for MSI/MSI-X
[   60.170396] ioatdma 0000:00:16.7: irq 57 for MSI/MSI-X
[   60.232097] microcode: CPU0 sig=0x106a5, pf=0x1, revision=0x11
[   60.286673] microcode: CPU1 sig=0x106a5, pf=0x1, revision=0x11
[   60.290266] microcode: CPU2 sig=0x106a5, pf=0x1, revision=0x11
[   60.293660] microcode: CPU3 sig=0x106a5, pf=0x1, revision=0x11
[   60.297192] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   61.516563] 8021q: 802.1Q VLAN Support v1.8
[   61.516641] 8021q: adding VLAN 0 to HW filter on device eth0
[   61.516721] 8021q: adding VLAN 0 to HW filter on device eth1
[   61.536632] myri10ge: Version 1.5.3-1.534
[   62.196031] fuse init (API version 7.18)

--------------050107000807030808070102
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------050107000807030808070102--
