Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0E1AT2a207140 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 19:10:29 -0600
Received: from omr4.networksolutionsemail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 736991645F5
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 17:11:24 -0800 (PST)
Received: from omr4.networksolutionsemail.com (omr4.networksolutionsemail.com
	[205.178.146.54]) by cuda.sgi.com with ESMTP id
	4pfZyCmeBdLay8dZ for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2010 17:11:24 -0800 (PST)
Received: from localhcloudmarkgw1 (mail.networksolutionsemail.com
	[205.178.146.50])
	by omr4.networksolutionsemail.com (8.13.6/8.13.6) with ESMTP id
	o0E1BOoi012386 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 20:11:24 -0500
Message-ID: <4B4E6F3F.1090901@chaven.com>
Date: Wed, 13 Jan 2010 19:11:27 -0600
From: Steve Costaras <stevecs@chaven.com>
MIME-Version: 1.0
Subject: XFS data corruption with high I/O even on hardware raid
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0175561438600760243=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============0175561438600760243==
Content-Type: multipart/alternative;
 boundary="------------090000090608090002030900"

This is a multi-part message in MIME format.
--------------090000090608090002030900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ok, I've been seeing a problem here since had to move over to XFS from 
JFS due to file system size issues.   I am seeing XFS Data corruption 
under ?heavy io?   Basically, what happens is that under heavy load 
(i.e. if I'm doing say a xfs_fsr (which nearly always triggers the 
freeze issue) on a volume the system hovers around 90% utilization for 
the dm device for a while (sometimes an hour+, sometimes minutes) the 
subsystem goes into 100% utilization and then freezes solid forcing me 
to do a hard reboot of the box.  When coming back up generally the XFS 
volumes are really screwed up (see below).    Areca cards all have BBU's 
and the only write cache is on the BBU (drive cache disabled).   Systems 
are all UPS protected as well.    These freezes have happened too 
frequently and unfortunatly nothing is logged anywhere.    It's not 
worth doing a repair as the amount of corruption is too extensive so 
requires a complete restore from backup.    I just mention xfs_fsr here 
as that /seems/ to generate an I/O pattern that nearly always results in 
a freeze.   I have done it with other high-i/o functions though not as 
reliably.

I don't know what else can be done to remove this issue (and not really 
sure it's really directly related to XFS, as LVM and the areca driver 
are also involved) however the main result is that XFS gets really 
screwed up.   I did NOT have these issues w/ JFS (same subsystem lvm + 
areca set up so it /seems/ to point to XFS or at least it's tied in 
there somewhere) unfortunately JFS has issues with file systems larger 
than 32TiB so the only file system I can use is XFS.

Since I'm using hardware raid w/ BBU when I reboot and it comes back up 
the raid controller writes out to the drives any outstanding data in 
it's cache and from the hardware point of view (as well as lvm's point 
of view) the array is ok.    The file system however generally can't be 
mounted (about 4 out of 5 times, some times it does get auto-mounted but 
when I then run an xfs_repair -n -v in those cases there are pages of 
errors (badly aligned inode rec, bad starting inode #'s, dubious inode 
btree block headers among others).    When I let a repair actually run 
in one case out of 4,500,000 files it linked about 2,000,000 or so but 
there was no way to identify and verify file integrity.  The others were 
just lost.

This is not limited to large volume sizes I have seen similar on small 
~2TiB file systems as well.  Also when it happened in a couple cases the 
file system that was taking the I/O (say xfs_fsr -v /home ) another XFS 
filesystem on the same system which was NOT taking much if any I/O gets 
badly corrupted (say /var/test ).   Both would be using the same areca 
controllers and same physical discs (same PV's and same VG's but 
different LV's).

Any suggestions on how to isolate or eliminate this would be greatly 
appreciated.


Steve


Technical data is below:
==============
$iostat -m -x 15
(IOSTAT capture right up to a freeze event:)
(system sits here for a long bit hovering around 90% for the DM device 
and about 30% for the the PV's)
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     7.80    0.07    2.00     0.00     0.04    
38.19     0.00    2.26   0.97   0.20
sdb             120.07    34.47  253.00  706.67    24.98    28.96   
115.11     1.06    1.10   0.28  26.87
sdc              48.80    28.93  324.73  730.87    24.98    28.94   
104.62     1.19    1.13   0.29  30.60
sdd             121.73    33.13  251.60  700.40    24.99    28.94   
116.01     1.11    1.17   0.29  27.40
sde              49.00    28.60  324.33  731.47    24.99    28.95   
104.65     1.22    1.15   0.26  27.53
sdf             120.27    33.20  253.00  701.00    24.99    28.97   
115.84     1.14    1.20   0.33  31.67
sdg              48.80    29.07  324.73  731.80    25.00    28.95   
104.59     1.37    1.29   0.35  36.93
sdh             120.47    33.47  252.73  702.53    25.00    28.96   
115.68     1.24    1.30   0.35  33.67
sdi              50.73    28.27  322.73  735.13    24.99    29.01   
104.54     1.34    1.26   0.31  32.27
dm-0              0.00     0.00    0.13    0.13     0.00     0.00    
12.00     0.01   25.00  25.00   0.67
dm-1              0.00     0.00 1602.67  992.73   199.93   231.69   
340.59     4.12    1.59   0.34  88.40
dm-2              0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00


(Then it jumps up to 99-100% for the majority of devices (here sdf,sdg, 
sdh, sdi are all on the same physical areca card).
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.00    0.00    0.60   24.71    0.00   74.69

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     4.07    0.00    1.13     0.00     0.02    
36.71     0.00    1.18   1.18   0.13
sdb               2.07     1.93    8.00   17.00     0.63     0.84   
120.33     0.04    1.49   0.35   0.87
sdc               2.87     1.20    7.40   22.13     0.63     0.83   
101.86     0.04    1.49   0.25   0.73
sdd               2.13     1.80    8.07   17.20     0.63     0.84   
119.64     0.04    1.45   0.32   0.80
sde               2.93     1.07    7.20   21.80     0.63     0.83   
103.65     0.05    1.89   0.34   1.00
sdf               1.93     1.87    8.13   13.67     0.63     0.64   
119.78    46.58    2.35  45.63  99.47
sdg               2.87     1.00    7.13   17.80     0.62     0.64   
104.04    64.12    2.41  39.84  99.33
sdh               2.07     1.67    7.93   13.47     0.62     0.64   
121.22    47.85    2.12  46.39  99.27
sdi               2.93     1.07    7.07   18.47     0.62     0.64   
101.77    62.15    2.32  38.83  99.13
dm-0              0.00     0.00    0.20    0.07     0.00     0.00    
10.00     0.00    2.50   2.50   0.07
dm-1              0.00     0.00   40.20   30.13     5.03     6.68   
340.96    74.73    2.13  14.19  99.80
dm-2              0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00

(Then here it hits 100% and the system locks)
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.00    0.00    0.81   24.95    0.00   74.24

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     8.40    0.00    2.13     0.00     0.04    
39.50     0.00    1.88   0.63   0.13
sdb               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdc               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdd               0.00     0.00    0.00    0.07     0.00     0.00    
16.00     0.00    0.00   0.00   0.00
sde               0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00
sdf               0.00     0.00    0.00    0.00     0.00     0.00     
0.00    50.00    0.00   0.00 100.00
sdg               0.00     0.00    0.00    0.00     0.00     0.00     
0.00    69.00    0.00   0.00 100.00
sdh               0.00     0.00    0.00    0.00     0.00     0.00     
0.00    50.00    0.00   0.00 100.00
sdi               0.00     0.00    0.00    0.00     0.00     0.00     
0.00    65.00    0.00   0.00 100.00
dm-0              0.00     0.00    0.00    0.07     0.00     0.00    
16.00     0.00    0.00   0.00   0.00
dm-1              0.00     0.00    0.00    0.00     0.00     0.00     
0.00    85.00    0.00   0.00 100.00
dm-2              0.00     0.00    0.00    0.00     0.00     0.00     
0.00     0.00    0.00   0.00   0.00



============ (System)
(Ubuntu 8.04.3 LTS):
Linux loki 2.6.24-26-server #1 SMP Tue Dec 1 18:26:43 UTC 2009 x86_64 
GNU/Linux

--------------
xfs_repair version 2.9.4

============= (modinfo's)
filename:       /lib/modules/2.6.24-26-server/kernel/fs/xfs/xfs.ko
license:        GPL
description:    SGI XFS with ACLs, security attributes, realtime, large 
block/inode numbers, no debug enabled
author:         Silicon Graphics, Inc.
srcversion:     A2E6459B3A4C96355F95E61
depends:
vermagic:       2.6.24-26-server SMP mod_unload
============
filename:       
/lib/modules/2.6.24-26-server/kernel/drivers/scsi/arcmsr/arcmsr.ko
version:        Driver Version 1.20.00.15 2007/08/30
license:        Dual BSD/GPL
description:    ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID HOST Adapter
author:         Erich Chen <support@areca.com.tw>
srcversion:     38E576EB40C1A58E8B9E007
alias:          pci:v000017D3d00001681sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001680sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001381sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001380sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001280sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001270sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001260sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001230sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001220sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001210sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001202sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001201sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001200sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001170sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001160sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001130sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001120sv*sd*bc*sc*i*
alias:          pci:v000017D3d00001110sv*sd*bc*sc*i*
depends:        scsi_mod
vermagic:       2.6.24-26-server SMP mod_unload
===========
filename:       /lib/modules/2.6.24-26-server/kernel/drivers/md/dm-mod.ko
license:        GPL
author:         Joe Thornber <dm-devel@redhat.com>
description:    device-mapper driver
srcversion:     A7E89E997173E41CB6AAF04
depends:
vermagic:       2.6.24-26-server SMP mod_unload
parm:           major:The major number of the device mapper (uint)
===========

============
mounted with:
/dev/vg_media/lv_ftpshare       /var/ftp        xfs     
defaults,relatime,nobarrier,logbufs=8,logbsize=256k,sunit=256,swidth=2048,inode64,noikeep,largeio,swalloc,allocsize=128k       
0       2

============
XFS info:
meta-data=/dev/mapper/vg_media-lv_ftpshare isize=2048   agcount=41, 
agsize=268435424 blks
          =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=10737418200, imaxpct=1
          =                       sunit=32     swidth=256 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=512   sunit=32 blks, lazy-count=0
realtime =none                   extsz=1048576 blocks=0, rtextents=0

=============
XFS is running on top of LVM:
  --- Logical volume ---
   LV Name                /dev/vg_media/lv_ftpshare
   VG Name                vg_media
   LV UUID                MgEBWv-x9fn-KUoJ-3y5X-snlk-7F9E-A3CiHh
   LV Write Access        read/write
   LV Status              available
   # open                 1
   LV Size                40.00 TB
   Current LE             40960
   Segments               1
   Allocation             inherit
   Read ahead sectors     0
   Block device           254:1

==============
LVM is using as it's base physical volumes 8 hardware raids 
(MediaVol00-70 inclusive):
[  175.320738] ARECA RAID ADAPTER4: FIRMWARE VERSION V1.47 2009-07-16
[  175.336238] scsi4 : Areca SAS Host Adapter RAID Controller( RAID6 
capable)
[  175.336239]  Driver Version 1.20.00.15 2007/08/30
[  175.336387] ACPI: PCI Interrupt 0000:0a:00.0[A] -> GSI 17 (level, 
low) -> IRQ 17
[  175.336395] PCI: Setting latency timer of device 0000:0a:00.0 to 64
[  175.336990] scsi 4:0:0:0: Direct-Access     Areca    BootVol#00       
R001 PQ: 0 ANSI: 5
[  175.337096] scsi 4:0:0:1: Direct-Access     Areca    MediaVol#00      
R001 PQ: 0 ANSI: 5
[  175.337169] scsi 4:0:0:2: Direct-Access     Areca    MediaVol#10      
R001 PQ: 0 ANSI: 5
[  175.337240] scsi 4:0:0:3: Direct-Access     Areca    MediaVol#20      
R001 PQ: 0 ANSI: 5
[  175.337312] scsi 4:0:0:4: Direct-Access     Areca    MediaVol#30      
R001 PQ: 0 ANSI: 5
[  175.337907] scsi 4:0:16:0: Processor         Areca    RAID 
controller  R001 PQ: 0 ANSI: 0
[  175.356231] ARECA RAID ADAPTER5: FIRMWARE VERSION V1.47 2009-10-22
[  175.376144] scsi5 : Areca SAS Host Adapter RAID Controller( RAID6 
capable)
[  175.376145]  Driver Version 1.20.00.15 2007/08/30
[  175.377354] scsi 5:0:0:5: Direct-Access     Areca    MediaVol#40      
R001 PQ: 0 ANSI: 5
[  175.377434] scsi 5:0:0:6: Direct-Access     Areca    MediaVol#50      
R001 PQ: 0 ANSI: 5
[  175.377495] scsi 5:0:0:7: Direct-Access     Areca    MediaVol#60      
R001 PQ: 0 ANSI: 5
[  175.377587] scsi 5:0:1:0: Direct-Access     Areca    MediaVol#70      
R001 PQ: 0 ANSI: 5
[  175.378156] scsi 5:0:16:0: Processor         Areca    RAID 
controller  R001 PQ: 0 ANSI: 0

=================


--------------090000090608090002030900
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
</head>
<body bgcolor="#ffffff" text="#000000">
<font face="Courier New">Ok, I've been seeing a problem here since had
to move over to XFS from JFS due to file system size issues.&nbsp;&nbsp; I am
seeing XFS Data corruption under ?heavy io? &nbsp; Basically, what happens
is that under heavy load (i.e. if I'm doing say a xfs_fsr (which nearly
always triggers the freeze issue) on a volume the system hovers around
90% utilization for the dm device for a while (sometimes an hour+,
sometimes minutes) the subsystem goes into 100% utilization and then
freezes solid forcing me to do a hard reboot of the box.&nbsp; When coming
back up generally the XFS volumes are really screwed up (see below).&nbsp;&nbsp;&nbsp;
Areca cards all have BBU's and the only write cache is on the BBU
(drive cache disabled).&nbsp;&nbsp; Systems are all UPS protected as well.&nbsp;&nbsp;&nbsp;
These freezes have happened too frequently and unfortunatly nothing is
logged anywhere.&nbsp;&nbsp;&nbsp; It's not worth doing a repair as the amount of
corruption is too extensive so requires a complete restore from
backup.&nbsp;&nbsp;&nbsp; I just mention xfs_fsr here as that /seems/ to generate an
I/O pattern that nearly always results in a freeze.&nbsp;&nbsp; I have done it
with other high-i/o functions though not as reliably.<br>
<br>
I don't know what else can be done to remove this issue (and not really
sure it's really directly related to XFS, as LVM and the areca driver
are also involved) however the main result is that XFS gets really
screwed up.&nbsp;&nbsp; I did NOT have these issues w/ JFS (same subsystem lvm +
areca set up so it /seems/ to point to XFS or at least it's tied in
there somewhere) unfortunately JFS has issues with file systems larger
than 32TiB so the only file system I can use is XFS.<br>
<br>
Since I'm using hardware raid w/ BBU when I reboot and it comes back up
the raid controller writes out to the drives any outstanding data in
it's cache and from the hardware point of view (as well as lvm's point
of view) the array is ok.&nbsp;&nbsp;&nbsp; The file system however generally can't be
mounted (about 4 out of 5 times, some times it does get auto-mounted
but when I then run an xfs_repair -n -v in those cases there are pages
of errors (badly aligned inode rec, bad starting inode #'s, dubious
inode btree block headers among others).&nbsp;&nbsp;&nbsp; When I let a repair
actually run in one case out of 4,500,000 files it linked about
2,000,000 or so but there was no way to identify and verify file
integrity.&nbsp; The others were just lost.<br>
<br>
This is not limited to large volume sizes I have seen similar on small
~2TiB file systems as well.&nbsp; Also when it happened in a couple cases
the file system that was taking the I/O (say xfs_fsr -v /home ) another
XFS filesystem on the same system which was NOT taking much if any I/O
gets badly corrupted (say /var/test ).&nbsp;&nbsp; Both would be using the same
areca controllers and same physical discs (same PV's and same VG's but
different LV's).<br>
<br>
Any suggestions on how to isolate or eliminate this would be greatly
appreciated.<br>
<br>
<br>
Steve<br>
<br>
<br>
</font><font face="Courier New">Technical data is below:</font><br>
<font face="Courier New">==============<br>
$iostat -m -x 15<br>
(IOSTAT capture right up to a freeze event:)<br>
(system sits here for a long bit hovering around 90% for the DM device
and about 30% for the the PV's)<br>
Device:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbsp;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/s&nbsp;&nbsp;&nbsp; wMB/s
avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&nbsp; %util<br>
sda&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 7.80&nbsp;&nbsp;&nbsp; 0.07&nbsp;&nbsp;&nbsp; 2.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.04&nbsp;&nbsp;&nbsp;
38.19&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 2.26&nbsp;&nbsp; 0.97&nbsp;&nbsp; 0.20<br>
sdb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 120.07&nbsp;&nbsp;&nbsp; 34.47&nbsp; 253.00&nbsp; 706.67&nbsp;&nbsp;&nbsp; 24.98&nbsp;&nbsp;&nbsp; 28.96&nbsp;&nbsp;
115.11&nbsp;&nbsp;&nbsp;&nbsp; 1.06&nbsp;&nbsp;&nbsp; 1.10&nbsp;&nbsp; 0.28&nbsp; 26.87<br>
sdc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 48.80&nbsp;&nbsp;&nbsp; 28.93&nbsp; 324.73&nbsp; 730.87&nbsp;&nbsp;&nbsp; 24.98&nbsp;&nbsp;&nbsp; 28.94&nbsp;&nbsp;
104.62&nbsp;&nbsp;&nbsp;&nbsp; 1.19&nbsp;&nbsp;&nbsp; 1.13&nbsp;&nbsp; 0.29&nbsp; 30.60<br>
sdd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 121.73&nbsp;&nbsp;&nbsp; 33.13&nbsp; 251.60&nbsp; 700.40&nbsp;&nbsp;&nbsp; 24.99&nbsp;&nbsp;&nbsp; 28.94&nbsp;&nbsp;
116.01&nbsp;&nbsp;&nbsp;&nbsp; 1.11&nbsp;&nbsp;&nbsp; 1.17&nbsp;&nbsp; 0.29&nbsp; 27.40<br>
sde&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 49.00&nbsp;&nbsp;&nbsp; 28.60&nbsp; 324.33&nbsp; 731.47&nbsp;&nbsp;&nbsp; 24.99&nbsp;&nbsp;&nbsp; 28.95&nbsp;&nbsp;
104.65&nbsp;&nbsp;&nbsp;&nbsp; 1.22&nbsp;&nbsp;&nbsp; 1.15&nbsp;&nbsp; 0.26&nbsp; 27.53<br>
sdf&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 120.27&nbsp;&nbsp;&nbsp; 33.20&nbsp; 253.00&nbsp; 701.00&nbsp;&nbsp;&nbsp; 24.99&nbsp;&nbsp;&nbsp; 28.97&nbsp;&nbsp;
115.84&nbsp;&nbsp;&nbsp;&nbsp; 1.14&nbsp;&nbsp;&nbsp; 1.20&nbsp;&nbsp; 0.33&nbsp; 31.67<br>
sdg&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 48.80&nbsp;&nbsp;&nbsp; 29.07&nbsp; 324.73&nbsp; 731.80&nbsp;&nbsp;&nbsp; 25.00&nbsp;&nbsp;&nbsp; 28.95&nbsp;&nbsp;
104.59&nbsp;&nbsp;&nbsp;&nbsp; 1.37&nbsp;&nbsp;&nbsp; 1.29&nbsp;&nbsp; 0.35&nbsp; 36.93<br>
sdh&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 120.47&nbsp;&nbsp;&nbsp; 33.47&nbsp; 252.73&nbsp; 702.53&nbsp;&nbsp;&nbsp; 25.00&nbsp;&nbsp;&nbsp; 28.96&nbsp;&nbsp;
115.68&nbsp;&nbsp;&nbsp;&nbsp; 1.24&nbsp;&nbsp;&nbsp; 1.30&nbsp;&nbsp; 0.35&nbsp; 33.67<br>
sdi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 50.73&nbsp;&nbsp;&nbsp; 28.27&nbsp; 322.73&nbsp; 735.13&nbsp;&nbsp;&nbsp; 24.99&nbsp;&nbsp;&nbsp; 29.01&nbsp;&nbsp;
104.54&nbsp;&nbsp;&nbsp;&nbsp; 1.34&nbsp;&nbsp;&nbsp; 1.26&nbsp;&nbsp; 0.31&nbsp; 32.27<br>
dm-0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.13&nbsp;&nbsp;&nbsp; 0.13&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;
12.00&nbsp;&nbsp;&nbsp;&nbsp; 0.01&nbsp;&nbsp; 25.00&nbsp; 25.00&nbsp;&nbsp; 0.67<br>
dm-1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00 1602.67&nbsp; 992.73&nbsp;&nbsp; 199.93&nbsp;&nbsp; 231.69&nbsp;&nbsp;
340.59&nbsp;&nbsp;&nbsp;&nbsp; 4.12&nbsp;&nbsp;&nbsp; 1.59&nbsp;&nbsp; 0.34&nbsp; 88.40<br>
dm-2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp;
0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00<br>
<br>
<br>
(Then it jumps up to 99-100% for the majority of devices (here sdf,sdg,
sdh, sdi are all on the same physical areca card).<br>
avg-cpu:&nbsp; %user&nbsp;&nbsp; %nice %system %iowait&nbsp; %steal&nbsp;&nbsp; %idle<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.60&nbsp;&nbsp; 24.71&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 74.69<br>
<br>
Device:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbsp;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/s&nbsp;&nbsp;&nbsp; wMB/s
avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&nbsp; %util<br>
sda&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 4.07&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 1.13&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.02&nbsp;&nbsp;&nbsp;
36.71&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 1.18&nbsp;&nbsp; 1.18&nbsp;&nbsp; 0.13<br>
sdb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.07&nbsp;&nbsp;&nbsp;&nbsp; 1.93&nbsp;&nbsp;&nbsp; 8.00&nbsp;&nbsp; 17.00&nbsp;&nbsp;&nbsp;&nbsp; 0.63&nbsp;&nbsp;&nbsp;&nbsp; 0.84&nbsp;&nbsp;
120.33&nbsp;&nbsp;&nbsp;&nbsp; 0.04&nbsp;&nbsp;&nbsp; 1.49&nbsp;&nbsp; 0.35&nbsp;&nbsp; 0.87<br>
sdc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.87&nbsp;&nbsp;&nbsp;&nbsp; 1.20&nbsp;&nbsp;&nbsp; 7.40&nbsp;&nbsp; 22.13&nbsp;&nbsp;&nbsp;&nbsp; 0.63&nbsp;&nbsp;&nbsp;&nbsp; 0.83&nbsp;&nbsp;
101.86&nbsp;&nbsp;&nbsp;&nbsp; 0.04&nbsp;&nbsp;&nbsp; 1.49&nbsp;&nbsp; 0.25&nbsp;&nbsp; 0.73<br>
sdd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.13&nbsp;&nbsp;&nbsp;&nbsp; 1.80&nbsp;&nbsp;&nbsp; 8.07&nbsp;&nbsp; 17.20&nbsp;&nbsp;&nbsp;&nbsp; 0.63&nbsp;&nbsp;&nbsp;&nbsp; 0.84&nbsp;&nbsp;
119.64&nbsp;&nbsp;&nbsp;&nbsp; 0.04&nbsp;&nbsp;&nbsp; 1.45&nbsp;&nbsp; 0.32&nbsp;&nbsp; 0.80<br>
sde&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.93&nbsp;&nbsp;&nbsp;&nbsp; 1.07&nbsp;&nbsp;&nbsp; 7.20&nbsp;&nbsp; 21.80&nbsp;&nbsp;&nbsp;&nbsp; 0.63&nbsp;&nbsp;&nbsp;&nbsp; 0.83&nbsp;&nbsp;
103.65&nbsp;&nbsp;&nbsp;&nbsp; 0.05&nbsp;&nbsp;&nbsp; 1.89&nbsp;&nbsp; 0.34&nbsp;&nbsp; 1.00<br>
sdf&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.93&nbsp;&nbsp;&nbsp;&nbsp; 1.87&nbsp;&nbsp;&nbsp; 8.13&nbsp;&nbsp; 13.67&nbsp;&nbsp;&nbsp;&nbsp; 0.63&nbsp;&nbsp;&nbsp;&nbsp; 0.64&nbsp;&nbsp;
119.78&nbsp;&nbsp;&nbsp; 46.58&nbsp;&nbsp;&nbsp; 2.35&nbsp; 45.63&nbsp; 99.47<br>
sdg&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.87&nbsp;&nbsp;&nbsp;&nbsp; 1.00&nbsp;&nbsp;&nbsp; 7.13&nbsp;&nbsp; 17.80&nbsp;&nbsp;&nbsp;&nbsp; 0.62&nbsp;&nbsp;&nbsp;&nbsp; 0.64&nbsp;&nbsp;
104.04&nbsp;&nbsp;&nbsp; 64.12&nbsp;&nbsp;&nbsp; 2.41&nbsp; 39.84&nbsp; 99.33<br>
sdh&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.07&nbsp;&nbsp;&nbsp;&nbsp; 1.67&nbsp;&nbsp;&nbsp; 7.93&nbsp;&nbsp; 13.47&nbsp;&nbsp;&nbsp;&nbsp; 0.62&nbsp;&nbsp;&nbsp;&nbsp; 0.64&nbsp;&nbsp;
121.22&nbsp;&nbsp;&nbsp; 47.85&nbsp;&nbsp;&nbsp; 2.12&nbsp; 46.39&nbsp; 99.27<br>
sdi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.93&nbsp;&nbsp;&nbsp;&nbsp; 1.07&nbsp;&nbsp;&nbsp; 7.07&nbsp;&nbsp; 18.47&nbsp;&nbsp;&nbsp;&nbsp; 0.62&nbsp;&nbsp;&nbsp;&nbsp; 0.64&nbsp;&nbsp;
101.77&nbsp;&nbsp;&nbsp; 62.15&nbsp;&nbsp;&nbsp; 2.32&nbsp; 38.83&nbsp; 99.13<br>
dm-0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.20&nbsp;&nbsp;&nbsp; 0.07&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;
10.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 2.50&nbsp;&nbsp; 2.50&nbsp;&nbsp; 0.07<br>
dm-1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 40.20&nbsp;&nbsp; 30.13&nbsp;&nbsp;&nbsp;&nbsp; 5.03&nbsp;&nbsp;&nbsp;&nbsp; 6.68&nbsp;&nbsp;
340.96&nbsp;&nbsp;&nbsp; 74.73&nbsp;&nbsp;&nbsp; 2.13&nbsp; 14.19&nbsp; 99.80<br>
dm-2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp;
0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00<br>
<br>
(Then here it hits 100% and the system locks)<br>
avg-cpu:&nbsp; %user&nbsp;&nbsp; %nice %system %iowait&nbsp; %steal&nbsp;&nbsp; %idle<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.81&nbsp;&nbsp; 24.95&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 74.24<br>
<br>
Device:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbsp;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/s&nbsp;&nbsp;&nbsp; wMB/s
avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&nbsp; %util<br>
sda&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 8.40&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 2.13&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.04&nbsp;&nbsp;&nbsp;
39.50&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 1.88&nbsp;&nbsp; 0.63&nbsp;&nbsp; 0.13<br>
sdb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp;
0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00<br>
sdc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp;
0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00<br>
sdd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.07&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;
16.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00<br>
sde&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp;
0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00<br>
sdf&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp;
0.00&nbsp;&nbsp;&nbsp; 50.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00 100.00<br>
sdg&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp;
0.00&nbsp;&nbsp;&nbsp; 69.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00 100.00<br>
sdh&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp;
0.00&nbsp;&nbsp;&nbsp; 50.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00 100.00<br>
sdi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp;
0.00&nbsp;&nbsp;&nbsp; 65.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00 100.00<br>
dm-0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.07&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;
16.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00<br>
dm-1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp;
0.00&nbsp;&nbsp;&nbsp; 85.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00 100.00<br>
dm-2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp;
0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00&nbsp;&nbsp; 0.00<br>
<br>
<br>
<br>
============ (System)<br>
(Ubuntu 8.04.3 LTS):<br>
Linux loki 2.6.24-26-server #1 SMP Tue Dec 1 18:26:43 UTC 2009 x86_64
GNU/Linux<br>
<br>
--------------<br>
xfs_repair version 2.9.4<br>
<br>
============= (modinfo's)<br>
filename:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /lib/modules/2.6.24-26-server/kernel/fs/xfs/xfs.ko<br>
license:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; GPL<br>
description:&nbsp;&nbsp;&nbsp; SGI XFS with ACLs, security attributes, realtime, large
block/inode numbers, no debug enabled<br>
author:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Silicon Graphics, Inc.<br>
srcversion:&nbsp;&nbsp;&nbsp;&nbsp; A2E6459B3A4C96355F95E61<br>
depends:<br>
vermagic:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.24-26-server SMP mod_unload<br>
============<br>
filename:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
/lib/modules/2.6.24-26-server/kernel/drivers/scsi/arcmsr/arcmsr.ko<br>
version:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Driver Version 1.20.00.15 2007/08/30<br>
license:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Dual BSD/GPL<br>
description:&nbsp;&nbsp;&nbsp; ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID HOST
Adapter<br>
author:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Erich Chen <a class="moz-txt-link-rfc2396E" href="mailto:support@areca.com.tw">&lt;support@areca.com.tw&gt;</a><br>
srcversion:&nbsp;&nbsp;&nbsp;&nbsp; 38E576EB40C1A58E8B9E007<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001681sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001680sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001381sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001380sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001280sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001270sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001260sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001230sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001220sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001210sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001202sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001201sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001200sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001170sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001160sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001130sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001120sv*sd*bc*sc*i*<br>
alias:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pci:v000017D3d00001110sv*sd*bc*sc*i*<br>
depends:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; scsi_mod<br>
vermagic:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.24-26-server SMP mod_unload<br>
===========<br>
filename:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
/lib/modules/2.6.24-26-server/kernel/drivers/md/dm-mod.ko<br>
license:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; GPL<br>
author:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Joe Thornber <a class="moz-txt-link-rfc2396E" href="mailto:dm-devel@redhat.com">&lt;dm-devel@redhat.com&gt;</a><br>
description:&nbsp;&nbsp;&nbsp; device-mapper driver<br>
srcversion:&nbsp;&nbsp;&nbsp;&nbsp; A7E89E997173E41CB6AAF04<br>
depends:<br>
vermagic:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.24-26-server SMP mod_unload<br>
parm:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; major:The major number of the device mapper (uint)<br>
===========<br>
<br>
============<br>
mounted with:<br>
/dev/vg_media/lv_ftpshare&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/ftp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; xfs&nbsp;&nbsp;&nbsp;&nbsp;
defaults,relatime,nobarrier,logbufs=8,logbsize=256k,sunit=256,swidth=2048,inode64,noikeep,largeio,swalloc,allocsize=128k&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2<br>
<br>
============<br>
XFS info:<br>
meta-data=/dev/mapper/vg_media-lv_ftpshare isize=2048&nbsp;&nbsp; agcount=41,
agsize=268435424 blks<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=512&nbsp;&nbsp; attr=0<br>
data&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=4096&nbsp;&nbsp; blocks=10737418200,
imaxpct=1<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sunit=32&nbsp;&nbsp;&nbsp;&nbsp; swidth=256 blks,
unwritten=1<br>
naming&nbsp;&nbsp; =version 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=4096<br>
log&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =internal&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=4096&nbsp;&nbsp; blocks=32768, version=2<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=512&nbsp;&nbsp; sunit=32 blks,
lazy-count=0<br>
realtime =none&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; extsz=1048576 blocks=0, rtextents=0<br>
<br>
=============<br>
XFS is running on top of LVM:<br>
&nbsp;--- Logical volume ---<br>
&nbsp; LV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/vg_media/lv_ftpshare<br>
&nbsp; VG Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vg_media<br>
&nbsp; LV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; MgEBWv-x9fn-KUoJ-3y5X-snlk-7F9E-A3CiHh<br>
&nbsp; LV Write Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; read/write<br>
&nbsp; LV Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; available<br>
&nbsp; # open&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>
&nbsp; LV Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 40.00 TB<br>
&nbsp; Current LE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 40960<br>
&nbsp; Segments&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>
&nbsp; Allocation&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; inherit<br>
&nbsp; Read ahead sectors&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
&nbsp; Block device&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 254:1<br>
<br>
==============<br>
LVM is using as it's base physical volumes 8 hardware raids
(MediaVol00-70 inclusive):<br>
[&nbsp; 175.320738] ARECA RAID ADAPTER4: FIRMWARE VERSION V1.47 2009-07-16<br>
[&nbsp; 175.336238] scsi4 : Areca SAS Host Adapter RAID Controller( RAID6
capable)<br>
[&nbsp; 175.336239]&nbsp; Driver Version 1.20.00.15 2007/08/30<br>
[&nbsp; 175.336387] ACPI: PCI Interrupt 0000:0a:00.0[A] -&gt; GSI 17 (level,
low) -&gt; IRQ 17<br>
[&nbsp; 175.336395] PCI: Setting latency timer of device 0000:0a:00.0 to 64<br>
[&nbsp; 175.336990] scsi 4:0:0:0: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; Areca&nbsp;&nbsp;&nbsp;
BootVol#00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; R001 PQ: 0 ANSI: 5<br>
[&nbsp; 175.337096] scsi 4:0:0:1: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; Areca&nbsp;&nbsp;&nbsp;
MediaVol#00&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; R001 PQ: 0 ANSI: 5<br>
[&nbsp; 175.337169] scsi 4:0:0:2: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; Areca&nbsp;&nbsp;&nbsp;
MediaVol#10&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; R001 PQ: 0 ANSI: 5<br>
[&nbsp; 175.337240] scsi 4:0:0:3: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; Areca&nbsp;&nbsp;&nbsp;
MediaVol#20&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; R001 PQ: 0 ANSI: 5<br>
[&nbsp; 175.337312] scsi 4:0:0:4: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; Areca&nbsp;&nbsp;&nbsp;
MediaVol#30&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; R001 PQ: 0 ANSI: 5<br>
[&nbsp; 175.337907] scsi 4:0:16:0: Processor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Areca&nbsp;&nbsp;&nbsp; RAID
controller&nbsp; R001 PQ: 0 ANSI: 0<br>
[&nbsp; 175.356231] ARECA RAID ADAPTER5: FIRMWARE VERSION V1.47 2009-10-22<br>
[&nbsp; 175.376144] scsi5 : Areca SAS Host Adapter RAID Controller( RAID6
capable)<br>
[&nbsp; 175.376145]&nbsp; Driver Version 1.20.00.15 2007/08/30<br>
[&nbsp; 175.377354] scsi 5:0:0:5: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; Areca&nbsp;&nbsp;&nbsp;
MediaVol#40&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; R001 PQ: 0 ANSI: 5<br>
[&nbsp; 175.377434] scsi 5:0:0:6: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; Areca&nbsp;&nbsp;&nbsp;
MediaVol#50&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; R001 PQ: 0 ANSI: 5<br>
[&nbsp; 175.377495] scsi 5:0:0:7: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; Areca&nbsp;&nbsp;&nbsp;
MediaVol#60&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; R001 PQ: 0 ANSI: 5<br>
[&nbsp; 175.377587] scsi 5:0:1:0: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; Areca&nbsp;&nbsp;&nbsp;
MediaVol#70&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; R001 PQ: 0 ANSI: 5<br>
[&nbsp; 175.378156] scsi 5:0:16:0: Processor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Areca&nbsp;&nbsp;&nbsp; RAID
controller&nbsp; R001 PQ: 0 ANSI: 0<br>
<br>
=================<br>
<br>
</font>
</body>
</html>

--------------090000090608090002030900--


--===============0175561438600760243==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0175561438600760243==--
