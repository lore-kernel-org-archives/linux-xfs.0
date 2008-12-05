Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB5DPTIF018017 for <xfs@oss.sgi.com>; Fri, 5 Dec 2008 07:25:29 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CD041BF091C
	for <xfs@oss.sgi.com>; Fri,  5 Dec 2008 05:25:27 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id MEqfdPHDMuF9JKgJ for
	<xfs@oss.sgi.com>; Fri, 05 Dec 2008 05:25:27 -0800 (PST)
Date: Fri, 5 Dec 2008 08:19:55 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Velociraptor drive related to the use of NCQ.
Message-ID: <alpine.DEB.1.10.0812050602400.3188@p34.internal.lan>
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
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, smartmontools-support@lists.sourceforge.net

I swapped out my power supply, changed ALL cables and bought a $1000 raid
controller with BBU, the drives are still having problems, when writing to
them in a RAID10 configuration, it locks up the card:

SMART shows the same thing on many of the disks in the RAID10:

Error 1 occurred at disk power-on lifetime: 3708 hours (154 days + 12 hours)
   When the command that caused the error occurred, the device was active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   10 51 00 00 8d b8 40

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   61 80 18 00 6c 91 19 08      00:57:50.230  WRITE FPDMA QUEUED
   61 80 18 00 cd b7 19 08      00:57:50.148  WRITE FPDMA QUEUED
   61 80 e8 80 cc b7 19 08      00:57:50.147  WRITE FPDMA QUEUED
   61 80 18 00 cc b7 19 08      00:57:50.147  WRITE FPDMA QUEUED
   61 80 e8 80 cb b7 19 08      00:57:50.146  WRITE FPDMA QUEUED


The card has the latest 3ware BIOS/Firmware etc, the diag output from the 
card itself:

DcbMgr::WriteSegment(map=0x4B7E38, segID=0x32, events=20, error=0x0)
DcbMgr::WriteSegment(map=0x4B7E38, segID=0x32, events=20, error=0x0)
DcbMgr::WriteSegment(map=0x4B7E38, segID=0x32, events=20, error=0x0)
DcbMgr::WriteSegment(map=0x4B7E38, segID=0x32, events=20, error=0x0)

E=1019 T=19:57:26     : Drive removed
task file written out : cd dh ch cl sn sc ft
                       : 61 59 B8 8E 00 80 80
E=1019 T=19:57:26 P=Bh: Hard reset drive
P=Bh: HardResetDriveWait
   task file read back : st dh ch cl sn sc er
                       : 50 00 00 00 01 01 01
E=1019 T=19:57:26 P=B : Soft reset drive
E=0207 T=19:57:26 P=B : ResetDriveWait
E=1019 T=19:57:26 P=B : Inserting Set UDMA command
E=1019 T=19:57:26 P=B : Check power mode, active
E=1019 T=19:57:26 P=B : Check drive swap, same drive
E=1019 T=19:57:26 P=B : Check power cycles, initial=57, current=57
E=1019 T=19:57:26 P=Bh: exitCode = 0
Retrying chain
DcbMgr::WriteSegment(map=0x4B7E38, segID=0x32, events=20, error=0x0)
DcbMgr::WriteSegment(map=0x4B7E38, segID=0x32, events=20, error=0x0)

Hm the last thing I will try I suppose is disabling NCQ and see if the problem
recurs.  So I did this, after 3-4 times of running the following with 
NCQ enabled, I would try it once more, the final time with NCQ disabled.

dd if=/dev/zero of=bigfile bs=1M on the raid10 and having it crash everytime
when NCQ was enabled.

--

I don't want to get too excited yet but after disabling NCQ I was able to
write to the RAID10 - over the entire array without it crashing!

Where before it would get to 700-985GiB/1.4TiB and then all processes 
would go into D-state and I could not even echo b > sysrq-trigger to bring
the host back up, it required a manual reboot.

--

I will let it run a few more times before making any further comments though.

echo "writing to raid10"
writing to raid10
dd if=/dev/zero of=file2 bs=1M
dd: writing `file2': No space left on device
1430328+0 records in
1430327+0 records out
1499806973952 bytes (1.5 TB) copied, 3914.51 s, 383 MB/s

Just as with Linux-- when using NCQ Western Digital Raptor Drives (150) or
Velociraptor Drives (300s) the drives in RAID; whether in Linux SW RAID or
3ware HW RAID, the result is the same, unstable drives, they appear to 
'reset' or timeout and this obviously will cause problems with any RAID 
implementation.

NCQ+Velociraptor => Bad in raid configuration, in non-raid it may be OK, I
have not tested.

I also have another host here that uses the P35 chipset and uses raptors in sw
raid 1-- when NCQ is enabled (and with the 750s as well) it gets nasty NCQ
errors and drive timeouts etc.

With this data, essentially the NCQ implementation on raptors or WD 750s
in a RAID configuration has problems.  I also have a 750 which I have used for
1-2 years now (using NCQ) in a single-disk configuration with NO issues, so
whatever the problem is-- only relates to when the disk is in a RAID
configuration and in my case in Linux SW RAID or 3ware HW RAID.

Justin.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
