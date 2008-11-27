Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mARLt4UY003395 for <xfs@oss.sgi.com>; Thu, 27 Nov 2008 15:55:11 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1192C16178BD
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2008 13:55:02 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id qXL5X00zUfsRbtxi for
	<xfs@oss.sgi.com>; Thu, 27 Nov 2008 13:55:02 -0800 (PST)
Date: Thu, 27 Nov 2008 16:54:30 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Intel X25-E running Linux using XFS
Message-ID: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: smartmontools-support@lists.sourceforge.net, smartmontools-database-owner@lists.sourceforge.net, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com
Cc: Alan Piszcz <ap@solarrain.com>

Ordered the SSD from newegg.
http://www.newegg.com/Product/Product.aspx?Item=N82E16820167013

It comes in a small box with the SSD and a single page about how to 
install the SSD.  Attached it to a 2.5-3.5" converter so it would fit in a 
standard case.

====

When I got the SSD, it showed 54 hours of usage and 66 power cycles, I 
assume this is testing at the factory, in any case, this is what the smart 
stats look like and some basic dd speed tests, as shown in the techreport 
review, write speed is quite fast, 227MiB/s.

The machine used to take about 60-70 seconds to boot, it now takes about 
5-6 seconds.

When opening browsers etc, I no longer hear my (previously) 750 gig disk 
grinding away loading all the libraries, everything is instantaneous.

====

Btw, no temp sensor.

# hddtemp /dev/sda
WARNING: Drive /dev/sda doesn't seem to have a temperature sensor.
WARNING: This doesn't mean it hasn't got one.
WARNING: If you are sure it has one, please contact me (hddtemp@guzu.net).
WARNING: See --help, --debug and --drivebase options.
/dev/sda: SSDSA2SH032G1GN INTEL:  no sensor

====

# fdisk -l

Disk /dev/sda: 32.0 GB, 32000000000 bytes
255 heads, 63 sectors/track, 3890 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00000000

Disk /dev/sda doesn't contain a valid partition table

========================================================

# smartctl -a /dev/sda
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     SSDSA2SH032G1GN INTEL
Serial Number:    [snip]
Firmware Version: 045C8621
User Capacity:    32,000,000,000 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 1
Local Time is:    Thu Nov 27 16:32:46 2008 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                         was never started.
                                         Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                         without error or no self-test has ever
                                         been run.
Total time to complete Offline 
data collection:                 (   1) seconds.
Offline data collection
capabilities:                    (0x75) SMART execute Offline immediate.
                                         No Auto Offline data collection support.
                                         Abort Offline collection upon new
                                         command.
                                         No Offline surface scan supported.
                                         Self-test supported.
                                         Conveyance Self-test supported.
                                         Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                         power-saving mode.
                                         Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                         General Purpose Logging supported.
Short self-test routine 
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (   5) minutes.
Conveyance self-test routine
recommended polling time:        (   1) minutes.

SMART Attributes Data Structure revision number: 5
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_
FAILED RAW_VALUE
   3 Spin_Up_Time            0x0000   100   000   000    Old_age   Offline  In_th
e_past 0
   4 Start_Stop_Count        0x0000   100   000   000    Old_age   Offline  In_th
e_past 0
   5 Reallocated_Sector_Ct   0x0002   100   100   000    Old_age   Always       -
        0
   9 Power_On_Hours          0x0002   100   100   000    Old_age   Always       -
        58
  12 Power_Cycle_Count       0x0002   100   100   000    Old_age   Always       -
        66
192 Power-Off_Retract_Count 0x0002   100   100   000    Old_age   Always       -
        58
232 Unknown_Attribute       0x0003   100   100   010    Pre-fail  Always       -
        0
233 Unknown_Attribute       0x0002   099   099   000    Old_age   Always       -
        0
225 Load_Cycle_Count        0x0000   200   200   000    Old_age   Offline      -
        116201

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA
_of_first_error
# 1  Short offline       Completed without error       00%        58         -

SMART Selective Self-Test Log Data Structure Revision Number (0) should be 1
SMART Selective self-test log data structure revision number 0
Warning: ATA Specification requires selective self-test log data structure revis
ion number = 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

========================================================

# hdparm -i /dev/sda

/dev/sda:

  Model=SSDSA2SH032G1GN INTEL                   , FwRev=045C8621, SerialNo=[snip]
  Config={ Fixed }
  RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=0
  BuffType=unknown, BuffSize=0kB, MaxMultSect=16, MultSect=?16?
  CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=62500000
  IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
  PIO modes:  pio0 pio3 pio4
  DMA modes:  mdma0 mdma1 mdma2
  UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6
  AdvancedPM=no WriteCache=enabled
  Drive conforms to: ATA/ATAPI-7 T13 1532D revision 1:  ATA/ATAPI-2,3,4,5,6,7

  * signifies the current active mode

========================================================

# hdparm -vI /dev/sda

/dev/sda:
  IO_support    =  0 (default)
  readonly      =  0 (off)
  readahead     = 256 (on)
  geometry      = 3890/255/63, sectors = 62500000, start = 0

ATA device, with non-removable media
         Model Number:       SSDSA2SH032G1GN INTEL
         Serial Number:      [snip]
         Firmware Revision:  045C8621
         Transport:          Serial, ATA8-AST, SATA 1.0a, SATA II Extensions, SATA Rev 2.5
Standards:
         Used: ATA/ATAPI-7 T13 1532D revision 1
         Supported: 7 6 5 4 
Configuration:
         Logical         max     current
         cylinders       16383   16383
         heads           16      16
         sectors/track   63      63
         --
         CHS current addressable sectors:   16514064
         LBA    user addressable sectors:   62500000
         LBA48  user addressable sectors:   62500000
         device size with M = 1024*1024:       30517 MBytes
         device size with M = 1000*1000:       32000 MBytes (32 GB)
Capabilities:
         LBA, IORDY(can be disabled)
         Queue depth: 31
         Standby timer values: spec'd by Standard, no device specific minimum
         R/W multiple sector transfer: Max = 16  Current = 16
         DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
              Cycle time: min=120ns recommended=120ns
         PIO: pio0 pio1 pio2 pio3 pio4
              Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
         Enabled Supported:
            *    SMART feature set
                 Security Mode feature set
            *    Power Management feature set
            *    Write cache
            *    Look-ahead
            *    Host Protected Area feature set
            *    WRITE_BUFFER command
            *    READ_BUFFER command
            *    NOP cmd
            *    DOWNLOAD_MICROCODE
            *    48-bit Address feature set
            *    Device Configuration Overlay feature set
            *    Mandatory FLUSH_CACHE
            *    FLUSH_CACHE_EXT
            *    SMART error logging
            *    SMART self-test
            *    General Purpose Logging feature set
            *    WRITE_{DMA|MULTIPLE}_FUA_EXT
            *    64-bit World wide name
            *    IDLE_IMMEDIATE with UNLOAD
            *    WRITE_UNCORRECTABLE_EXT command
            *    {READ,WRITE}_DMA_EXT_GPL commands
            *    Segmented DOWNLOAD_MICROCODE
            *    SATA-I signaling speed (1.5Gb/s)
            *    SATA-II signaling speed (3.0Gb/s)
            *    Native Command Queueing (NCQ)
                 Device-initiated interface power management
            *    Software settings preservation
Security:
         Master password revision code = 65534
                 supported
         not     enabled
         not     locked
         not     frozen
         not     expired: security count
                 supported: enhanced erase
         2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 500151795870198c
         NAA             : 5
         IEEE OUI        : 1517
         Unique ID       : 95870198c
Checksum: correct

========================================================

# mkfs.xfs /dev/sda
meta-data=/dev/sda               isize=256    agcount=4, agsize=1953125 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=7812500, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=3814, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

# mkdir /disk
# mount /dev/sda /disk

========================================================

Incase you are wondering, both disks are using no barriers.

time to decompress kernel tree (linux, xfs):

$ /usr/bin/time tar xf linux-2.6.27.7.tar 
Total bytes read: 293857280 (281MiB, 75MiB/s)
0.15user 1.12system 0:03.74elapsed 34%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+645minor)pagefaults 0swaps

The same thing on a 750 gigabyte hdd:

$ /usr/bin/time tar xf linux-2.6.27.7.tar 
Total bytes read: 293857280 (281MiB, 6.5MiB/s)
0.15user 1.22system 0:43.29elapsed 3%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+643minor)pagefaults 0swaps

========================================================

# dd if=/dev/zero of=1gigabyte bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 4.71984 s, 227 MB/s

(yeah probably should of run echo 1 > to drop_caches here) but never the 
less its fast

# dd if=1gigabyte of=/dev/null bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 0.302331 s, 3.6 GB/s

(bunzip2'd the kernel and:)
$ /usr/bin/time dd if=linux-2.6.27.7.tar of=/dev/null bs=1M
280+1 records in
280+1 records out
293857280 bytes (294 MB) copied, 0.0760212 s, 3.9 GB/s
0.00user 0.06system 0:00.07elapsed 90%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+485minor)pagefaults 0swaps

========================================================

Due to the 100k write cycle lifetime, I will not be performing any 
more benchmarks on the SSD itself, such benchmarks are available on 
techreport.com but just wanted to send out the smart data for the 
smartmontools list and point out it is working with linux+ich7+xfs.

Overall, whenever I do anything now its just like the entire machine is
sitting in a ramdisk (similar when you boot knoppix and load to ramdisk).

The techreport benchmarks are here:
http://techreport.com/articles.x/15931

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
