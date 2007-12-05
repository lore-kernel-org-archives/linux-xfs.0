Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Dec 2007 04:26:16 -0800 (PST)
Received: from yergi.telenet-ops.be (yergi.telenet-ops.be [195.130.132.36])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lB5CQ4OR010596
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2007 04:26:06 -0800
Received: from astra.telenet-ops.be (unknown [195.130.132.58])
	by yergi.telenet-ops.be (Postfix) with ESMTP id EA2BF5CA424
	for <xfs@oss.sgi.com>; Wed,  5 Dec 2007 13:16:00 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by astra.telenet-ops.be (Postfix) with SMTP id 6AEBC38103
	for <xfs@oss.sgi.com>; Wed,  5 Dec 2007 13:15:55 +0100 (CET)
Received: from [81.164.41.199] (d51A429C7.access.telenet.be [81.164.41.199])
	by astra.telenet-ops.be (Postfix) with ESMTP id C9F26380F4
	for <xfs@oss.sgi.com>; Wed,  5 Dec 2007 13:15:52 +0100 (CET)
Message-ID: <475696D3.60007@pandora.be>
Date: Wed, 05 Dec 2007 13:17:23 +0100
From: Denis Wegge <denis_wegge@pandora.be>
MIME-Version: 1.0
Subject: XFS unable to mount, recover data
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello

I am having trouble with the XFS filesystem on a 320GB Western Digital
SATA harddisk. For no obvious reason the partition can no longer be
mounted. The following error occurs:

knoppix@Knoppix:~$ sudo mount /dev/sda1 /mnt/sda1
mount: /dev/sda1: can't read superblock

I tried to repair the filesystem with xfs_repair, but that didn't work.

knoppix@Knoppix:~$ sudo xfs_repair /dev/sda1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
         - zero log...
xfs_repair: read failed: Input/output error

I would like to recover the data on that disk. Unfortunately there isn't
enough space on any other disk to copy the partition to. I tried to copy
it partially with dd, but the image wouldn't mount. Is there any way to
recover the data on the partition?

The SMART info of the disk doesn't look very good either.

Below you can find the following information:
- dmesg messages after the failed mount
- the output of xfs_repair -n
- some outputs of a check for bad blocks
- SMART information (with errors!)


dmesg:
=====================================================================

XFS mounting filesystem sda1
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: (BMDMA stat 0x20)
ata3.00: tag 0 cmd 0x25 Emask 0x9 stat 0x51 err 0x40 (media error)
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: (BMDMA stat 0x20)
ata3.00: tag 0 cmd 0x25 Emask 0x9 stat 0x51 err 0x40 (media error)
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: (BMDMA stat 0x20)
ata3.00: tag 0 cmd 0x25 Emask 0x9 stat 0x51 err 0x40 (media error)
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: (BMDMA stat 0x20)
ata3.00: tag 0 cmd 0x25 Emask 0x9 stat 0x51 err 0x40 (media error)
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: (BMDMA stat 0x20)
ata3.00: tag 0 cmd 0x25 Emask 0x9 stat 0x51 err 0x40 (media error)
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: (BMDMA stat 0x20)
ata3.00: tag 0 cmd 0x25 Emask 0x9 stat 0x51 err 0x40 (media error)
sd 2:0:0:0: SCSI error: return code = 0x08000002
sda: Current: sense key=0x3
     ASC=0x11 ASCQ=0x4
end_request: I/O error, dev sda, sector 312632262
ata3: EH complete
I/O error in filesystem ("sda1") meta-data dev sda1 block 0x12a26387
    ("xlog_bread") error 5 buf count 512
XFS: failed to find log head
XFS: log mount/recovery failed: error 5
XFS: log mount failed


xfs_repair -n
=====================================================================

knoppix@Knoppix:~$ sudo xfs_repair -n /dev/sda1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
         - scan filesystem freespace and inode maps...
         - found root inode chunk
Phase 3 - for each AG...
         - scan (but don't clear) agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
         - agno = 4
         - agno = 5
         - agno = 6
         - agno = 7
         - agno = 8
         - agno = 9
         - agno = 10
         - agno = 11
         - agno = 12
         - agno = 13
         - agno = 14
         - agno = 15
         - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - check for inodes claiming duplicate blocks...
         - agno = 0
         - agno = 1
         - agno = 2
         - agno = 3
         - agno = 4
         - agno = 5
         - agno = 6
         - agno = 7
         - agno = 8
         - agno = 9
         - agno = 10
         - agno = 11
         - agno = 12
         - agno = 13
         - agno = 14
         - agno = 15
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
         - traversing filesystem starting at / ...
         - traversal finished ...
         - traversing all unattached subtrees ...
         - traversals finished ...
         - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.


badblocks
=====================================================================

knoppix@0[knoppix]$ sudo badblocks -v /dev/sda1 10000000
Checking blocks 0 to 10000000
Checking for bad blocks (read-only test): done
Pass completed, 0 bad blocks found.

knoppix@0[knoppix]$ sudo badblocks -v /dev/sda1 299879969 299879649
Checking blocks 299879649 to 299879969
Checking for bad blocks (read-only test): 299879649879649/
done
Pass completed, 12 bad blocks found.

knoppix@0[knoppix]$ sudo badblocks -v /dev/sda1 300013300  300013113
Checking blocks 300013113 to 300013300
Checking for bad blocks (read-only test): 300013113013113/
done
Pass completed, 15 bad blocks found.

knoppix@3[knoppix]$ sudo badblocks -v /dev/sda1 312568641 310000000
Checking blocks 310000000 to 312568641
Checking for bad blocks (read-only test): done                        641
Pass completed, 0 bad blocks found.


SMART
=====================================================================

denis@athena64:~$ sudo smartctl -a /dev/sda
smartctl version 5.37 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar SE16 family
Device Model:     WDC WD3200KS-00PFB0
Serial Number:    WD-WCAPD1467148
Firmware Version: 21.00M21
User Capacity:    320,072,933,376 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Wed Dec  5 13:00:40 2007 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: FAILED!
Drive failure expected in less than 24 hours. SAVE ALL DATA.
See vendor-specific Attribute list for failed Attributes.

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activity
                                         was suspended by an 
interrupting command from host.
                                         Auto Offline Data Collection: 
Enabled.
Self-test execution status:      (  73) The previous self-test completed 
having
                                         a test element that failed and 
the test
                                         element that failed is not known.
Total time to complete Offline
data collection:                 (9600) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                         Auto Offline data collection 
on/off support.
                                         Suspend Offline collection upon new
                                         command.
                                         Offline surface scan supported.
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
recommended polling time:        ( 111) minutes.
Conveyance self-test routine
recommended polling time:        (   6) minutes.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE 
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail 
Always       -       0
   3 Spin_Up_Time            0x0003   239   223   021    Pre-fail 
Always       -       3041
   4 Start_Stop_Count        0x0032   099   099   000    Old_age 
Always       -       1142
   5 Reallocated_Sector_Ct   0x0033   104   104   140    Pre-fail 
Always   FAILING_NOW 763
   7 Seek_Error_Rate         0x000f   200   200   051    Pre-fail 
Always       -       0
   9 Power_On_Hours          0x0032   095   095   000    Old_age 
Always       -       4326
  10 Spin_Retry_Count        0x0013   100   100   051    Pre-fail 
Always       -       0
  11 Calibration_Retry_Count 0x0013   100   100   051    Pre-fail 
Always       -       0
  12 Power_Cycle_Count       0x0032   099   099   000    Old_age 
Always       -       1139
194 Temperature_Celsius     0x0022   120   001   000    Old_age   Always 
       -       30
196 Reallocated_Event_Count 0x0032   001   001   000    Old_age   Always 
       -       763
197 Current_Pending_Sector  0x0012   200   187   000    Old_age   Always 
       -       0
198 Offline_Uncorrectable   0x0010   200   190   000    Old_age 
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always 
       -       0
200 Multi_Zone_Error_Rate   0x0009   001   001   051    Pre-fail 
Offline  FAILING_NOW 55696

SMART Error Log Version: 1
ATA Error Count: 17663 (device log contains only the most recent five 
errors)
         CR = Command Register [HEX]
         FR = Features Register [HEX]
         SC = Sector Count Register [HEX]
         SN = Sector Number Register [HEX]
         CL = Cylinder Low Register [HEX]
         CH = Cylinder High Register [HEX]
         DH = Device/Head Register [HEX]
         DC = Device Command Register [HEX]
         ER = Error register [HEX]
         ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 17663 occurred at disk power-on lifetime: 4323 hours (180 days + 3 
hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 01 ce 63 a2 e0  Error: UNC 1 sectors at LBA = 0x00a263ce = 10642382

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 01 ce 63 a2 12 00      16:06:59.549  READ DMA EXT
   ec 00 00 ce 63 a2 00 00      16:06:59.549  IDENTIFY DEVICE
   25 00 01 ce 63 a2 12 00      16:06:57.499  READ DMA EXT
   ec 00 00 ce 63 a2 00 00      16:06:57.499  IDENTIFY DEVICE
   25 00 01 ce 63 a2 12 00      16:06:55.264  READ DMA EXT

Error 17662 occurred at disk power-on lifetime: 4323 hours (180 days + 3 
hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 01 ce 63 a2 e0  Error: UNC 1 sectors at LBA = 0x00a263ce = 10642382

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 01 ce 63 a2 12 00      16:06:57.499  READ DMA EXT
   ec 00 00 ce 63 a2 00 00      16:06:57.499  IDENTIFY DEVICE
   25 00 01 ce 63 a2 12 00      16:06:55.264  READ DMA EXT
   ec 00 00 ce 63 a2 00 00      16:06:55.264  IDENTIFY DEVICE
   25 00 01 ce 63 a2 12 00      16:06:53.212  READ DMA EXT

Error 17661 occurred at disk power-on lifetime: 4323 hours (180 days + 3 
hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 01 ce 63 a2 e0  Error: UNC 1 sectors at LBA = 0x00a263ce = 10642382

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 01 ce 63 a2 12 00      16:06:55.264  READ DMA EXT
   ec 00 00 ce 63 a2 00 00      16:06:55.264  IDENTIFY DEVICE
   25 00 01 ce 63 a2 12 00      16:06:53.212  READ DMA EXT
   ec 00 00 ce 63 a2 00 00      16:06:53.212  IDENTIFY DEVICE
   25 00 01 ce 63 a2 12 00      16:06:51.165  READ DMA EXT

Error 17660 occurred at disk power-on lifetime: 4323 hours (180 days + 3 
hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 01 ce 63 a2 e0  Error: UNC 1 sectors at LBA = 0x00a263ce = 10642382

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 01 ce 63 a2 12 00      16:06:53.212  READ DMA EXT
   ec 00 00 ce 63 a2 00 00      16:06:53.212  IDENTIFY DEVICE
   25 00 01 ce 63 a2 12 00      16:06:51.165  READ DMA EXT
   ec 00 00 ce 63 a2 00 00      16:06:51.165  IDENTIFY DEVICE
   25 00 01 ce 63 a2 12 00      16:06:49.280  READ DMA EXT

Error 17659 occurred at disk power-on lifetime: 4323 hours (180 days + 3 
hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 01 ce 63 a2 e0  Error: UNC 1 sectors at LBA = 0x00a263ce = 10642382

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 01 ce 63 a2 12 00      16:06:51.165  READ DMA EXT
   ec 00 00 ce 63 a2 00 00      16:06:51.165  IDENTIFY DEVICE
   25 00 01 ce 63 a2 12 00      16:06:49.280  READ DMA EXT
   25 00 01 be 63 a2 12 00      16:06:49.280  READ DMA EXT
   25 00 01 de 63 a2 12 00      16:06:49.264  READ DMA EXT

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed: unknown failure    90%      4324 
      -
# 2  Conveyance offline  Completed: unknown failure    90%      4324 
      -
# 3  Short offline       Completed: unknown failure    90%      4323 
      -
# 4  Extended offline    Completed: read failure       90%        53 
      158966062

SMART Selective self-test log data structure revision number 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.
