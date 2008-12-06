Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB69pbCV001814 for <xfs@oss.sgi.com>; Sat, 6 Dec 2008 03:51:38 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89DD216C9CA4
	for <xfs@oss.sgi.com>; Sat,  6 Dec 2008 01:51:35 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id Y7G8wk5mivvGrZ3h for
	<xfs@oss.sgi.com>; Sat, 06 Dec 2008 01:51:35 -0800 (PST)
Date: Sat, 6 Dec 2008 04:51:03 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Have the velociraptors in a test system now, checkout the errors.
Message-ID: <alpine.DEB.1.10.0812060426280.3494@p34.internal.lan>
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

Point of thread: Two problems, mentioned in detail below, NCQ in Linux 
when used in a RAID configuration and two, something with how Linux 
interacts with the drives causes lots of problems as when I run the WD 
tools on the disks, they do not show any errors.

If anyone has/would like me to run any debugging/patches/etc on this 
system feel free to suggest/send me things to try out.  After I put the 
VR's in a test system, I left NCQ enabled and I made a 10 disk raid5 to 
see how fast I could get it to fail, I ran bonnie++ shown below as a disk 
benchmark/stress test:

For the next test I will repeat this one but with NCQ disabled, having NCQ 
enabled makes it fail very easily.  Then I want to re-run the test with 
RAID6.

bonnie++ -d /r1/test -s 1000G -m p63 -n 16:100000:16:64

$ df -h
/dev/md3              2.5T  5.5M  2.5T   1% /r1

And the results?  Two disk "failures" according to md/Linux within a few 
hours as shown below:

Note, the NCQ-related errors are what I talk about all of the time, if you use
NCQ and Linux in a RAID environment with WD drives, well-- good luck.

Two-disks failed out of the RAID5 and I currentlty cannot even 'see' one 
of the drives with smartctl, will reboot the host and check sde again.

After a reboot, it comes up and has no errors, really makes one wonder 
where/what the bugs is/are, there are two I can see:
1. NCQ issue on at least WD drives in Linux in SW md/RAID
2. Velociraptor/other disks reporting all kinds of sector errors etc, but 
when you use the WD 11.x disk tools program and run all of their tests it 
says the disks have no problems whatsoever!  The smart statistics do 
confirm this.  Currently, TLER is on for all disks, for the duration of 
these tests.

The other drive that blew out:
p63:~# mdadm --assemble /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 
/dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1
mdadm: cannot open device /dev/sdl1: No such file or directory
mdadm: /dev/sdl1 has no superblock - assembly aborted

p63:~# smartctl -a /dev/sdl
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 Bruce Alle
n
Home page is http://smartmontools.sourceforge.net/

Smartctl open device: /dev/sdl failed: No such file or directory

It is not even coming up, power cycling the host is required to 'fix' the 
drive:
p63:~# init 0

A few minutes later after a power cycle now its back:

p63:~# smartctl -a /dev/sdl
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD3000GLFS-01F8U0
Serial Number:    [ .. snip .. ]
Firmware Version: 03.03V01
User Capacity:    300,069,052,416 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Sat Dec  6 04:44:14 2008 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

The use of NCQ is VERY dangerous in WD drives in Linux IMO if it requires a
power cycle to get the drive working again, and of course, all of the SMART
statistics show no problems.

p63:~# mdadm --assemble /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1
mdadm: /dev/sdc1 assembled from 7 drives and 1 spare - not enough to start the array.

Glad this was only a test array.

I was able to reboot to get this disk working again (below,sde) but had to 
power cycle to get /dev/sdl working:

# smartctl -a /dev/sde
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Short INQUIRY response, skip product id
A mandatory SMART command failed: exiting. To continue, add one or more '-T permissive' options.

What did the RAID5 look like after it failed everywhere?

# mdadm -D /dev/md3
/dev/md3:
         Version : 00.90
   Creation Time : Fri Dec  5 19:52:49 2008
      Raid Level : raid5
      Array Size : 2637296640 (2515.12 GiB 2700.59 GB)
   Used Dev Size : 293032960 (279.46 GiB 300.07 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 3
     Persistence : Superblock is persistent

     Update Time : Sat Dec  6 04:09:38 2008
           State : clean, degraded
  Active Devices : 8
Working Devices : 9
  Failed Devices : 1
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 1024K

            UUID : e22f491a:a183337a:4fbcf5fe:907318dc (local to host p63.internal.lan)
          Events : 0.84

     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        1       8       49        1      active sync   /dev/sdd1
        2       0        0        2      removed
        3       8       81        3      active sync   /dev/sdf1
        4       8       97        4      active sync   /dev/sdg1
        5       8      113        5      active sync   /dev/sdh1
        6       8      129        6      active sync   /dev/sdi1
        7       8      145        7      active sync   /dev/sdj1
        8       8      161        8      active sync   /dev/sdk1
        9       0        0        9      removed

       10       8      177        -      spare   /dev/sdl1
       11       8       65        -      faulty spare   /dev/sde1


[   25.813155] XFS mounting filesystem md3
[   27.112464] Ending clean XFS mount for filesystem: md3
[   30.879019] 0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   44.870767] warning: `pure-ftpd' uses 32-bit capabilities (legacy support in use)
[ 1155.475283] ata5.00: exception Emask 0x2 SAct 0x7ff7f SErr 0x3000400 action 0x6 frozen
[ 1155.475356] ata5: SError: { Proto TrStaTrns UnrecFIS }
[ 1155.475405] ata5.00: cmd 60/00:00:7f:14:b2/04:00:0c:00:00/40 tag 0 ncq 524288 in
[ 1155.475406]          res 40/00:c0:2f:65:b6/00:00:09:00:00/40 Emask 0x6 (timeout)
[ 1155.475535] ata5.00: status: { DRDY }
[ 1155.475580] ata5.00: cmd 60/00:08:7f:24:b2/04:00:0c:00:00/40 tag 1 ncq 524288 in
[ 1155.475581]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.475710] ata5.00: status: { DRDY }
[ 1155.475754] ata5.00: cmd 60/00:10:7f:04:b2/04:00:0c:00:00/40 tag 2 ncq 524288 in
[ 1155.475755]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.475884] ata5.00: status: { DRDY }
[ 1155.475928] ata5.00: cmd 60/00:18:7f:f4:b1/04:00:0c:00:00/40 tag 3 ncq 524288 in
[ 1155.475929]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.476058] ata5.00: status: { DRDY }
[ 1155.476103] ata5.00: cmd 60/00:20:7f:08:b2/04:00:0c:00:00/40 tag 4 ncq 524288 in
[ 1155.476104]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.476232] ata5.00: status: { DRDY }
[ 1155.476279] ata5.00: cmd 60/00:28:7f:18:b2/04:00:0c:00:00/40 tag 5 ncq 524288 in
[ 1155.476280]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.476409] ata5.00: status: { DRDY }
[ 1155.476453] ata5.00: cmd 60/00:30:7f:f8:b1/04:00:0c:00:00/40 tag 6 ncq 524288 in
[ 1155.476454]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.476583] ata5.00: status: { DRDY }
[ 1155.476627] ata5.00: cmd 60/00:40:7f:28:b2/04:00:0c:00:00/40 tag 8 ncq 524288 in
[ 1155.476628]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.476757] ata5.00: status: { DRDY }
[ 1155.476801] ata5.00: cmd 60/00:48:7f:1c:b2/04:00:0c:00:00/40 tag 9 ncq 524288 in
[ 1155.476802]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.476931] ata5.00: status: { DRDY }
[ 1155.476976] ata5.00: cmd 60/00:50:7f:fc:b1/04:00:0c:00:00/40 tag 10 ncq 524288 in
[ 1155.476977]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.477106] ata5.00: status: { DRDY }
[ 1155.477150] ata5.00: cmd 60/00:58:7f:00:b2/04:00:0c:00:00/40 tag 11 ncq 524288 in
[ 1155.477151]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.477283] ata5.00: status: { DRDY }
[ 1155.477327] ata5.00: cmd 60/00:60:7f:0c:b2/04:00:0c:00:00/40 tag 12 ncq 524288 in
[ 1155.477328]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.477457] ata5.00: status: { DRDY }
[ 1155.477501] ata5.00: cmd 60/00:68:7f:10:b2/04:00:0c:00:00/40 tag 13 ncq 524288 in
[ 1155.477502]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.477632] ata5.00: status: { DRDY }
[ 1155.477676] ata5.00: cmd 60/00:70:7f:2c:b2/04:00:0c:00:00/40 tag 14 ncq 524288 in
[ 1155.477677]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.477806] ata5.00: status: { DRDY }
[ 1155.477850] ata5.00: cmd 60/00:78:7f:ec:b1/04:00:0c:00:00/40 tag 15 ncq 524288 in
[ 1155.477851]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.477980] ata5.00: status: { DRDY }
[ 1155.478024] ata5.00: cmd 60/00:80:7f:f0:b1/04:00:0c:00:00/40 tag 16 ncq 524288 in
[ 1155.478025]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.478154] ata5.00: status: { DRDY }
[ 1155.478198] ata5.00: cmd 60/00:88:7f:30:b2/04:00:0c:00:00/40 tag 17 ncq 524288 in
[ 1155.478199]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.478331] ata5.00: status: { DRDY }
[ 1155.478375] ata5.00: cmd 60/00:90:7f:20:b2/04:00:0c:00:00/40 tag 18 ncq 524288 in
[ 1155.478376]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1155.478505] ata5.00: status: { DRDY }
[ 1155.478549] ata5: hard resetting link
[ 1160.832275] ata5: link is slow to respond, please be patient (ready=0)
[ 1165.524277] ata5: COMRESET failed (errno=-16)
[ 1165.524330] ata5: hard resetting link
[ 1170.878262] ata5: link is slow to respond, please be patient (ready=0)
[ 1175.570278] ata5: COMRESET failed (errno=-16)
[ 1175.570331] ata5: hard resetting link
[ 1180.924277] ata5: link is slow to respond, please be patient (ready=0)
[ 1210.606275] ata5: COMRESET failed (errno=-16)
[ 1210.606328] ata5: limiting SATA link speed to 1.5 Gbps
[ 1210.606388] ata5: hard resetting link
[ 1215.654275] ata5: COMRESET failed (errno=-16)
[ 1215.654326] ata5: reset failed, giving up
[ 1215.654380] ata5.00: disabled
[ 1215.654479] ata5: EH complete
[ 1215.654565] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.654658] end_request: I/O error, dev sde, sector 213000319
[ 1215.654712] raid5:md3: read error not correctable (sector 213000256 on sde1).
[ 1215.654765] raid5: Disk failure on sde1, disabling device.
[ 1215.654766] raid5: Operation continuing on 8 devices.
[ 1215.655412] raid5:md3: read error not correctable (sector 213000264 on sde1).
[ 1215.655473] raid5:md3: read error not correctable (sector 213000272 on sde1).
[ 1215.655533] raid5:md3: read error not correctable (sector 213000280 on sde1).
[ 1215.655592] raid5:md3: read error not correctable (sector 213000288 on sde1).
[ 1215.655644] raid5:md3: read error not correctable (sector 213000296 on sde1).
[ 1215.655694] raid5:md3: read error not correctable (sector 213000304 on sde1).
[ 1215.655746] raid5:md3: read error not correctable (sector 213000312 on sde1).
[ 1215.655800] raid5:md3: read error not correctable (sector 213000320 on sde1).
[ 1215.655852] raid5:md3: read error not correctable (sector 213000328 on sde1).
[ 1215.656021] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.656120] end_request: I/O error, dev sde, sector 213004415
[ 1215.656293] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.656421] end_request: I/O error, dev sde, sector 212988031
[ 1215.656476] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.656479] end_request: I/O error, dev sde, sector 213005439
[ 1215.656835] sd 4:0:0:0: [sde] <6>sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.656839] end_request: I/O error, dev sde, sector 212987007
[ 1215.657014] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.657087] end_request: I/O error, dev sde, sector 213006463
[ 1215.657099] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.657102] end_request: I/O error, dev sde, sector 213003391
[ 1215.657242] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.657244] end_request: I/O error, dev sde, sector 212996223
[ 1215.657387] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.657391] end_request: I/O error, dev sde, sector 212995199
[ 1215.657528] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.657530] end_request: I/O error, dev sde, sector 212992127
[ 1215.657668] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.657670] end_request: I/O error, dev sde, sector 212991103
[ 1215.657810] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.657812] end_request: I/O error, dev sde, sector 212999295
[ 1215.657951] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.657953] end_request: I/O error, dev sde, sector 213002367
[ 1215.658094] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.658097] end_request: I/O error, dev sde, sector 212990079
[ 1215.658236] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.658238] end_request: I/O error, dev sde, sector 212998271
[ 1215.658384] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.658485] end_request: I/O error, dev sde, sector 212994175
[ 1215.658544] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.658547] end_request: I/O error, dev sde, sector 213007487
[ 1215.658686] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.658688] end_request: I/O error, dev sde, sector 213008511
[ 1215.658839] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.658939] end_request: I/O error, dev sde, sector 213010559
[ 1215.658991] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.658993] end_request: I/O error, dev sde, sector 212989055
[ 1215.659133] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.659135] end_request: I/O error, dev sde, sector 212993151
[ 1215.659278] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.659280] end_request: I/O error, dev sde, sector 213001343
[ 1215.659419] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.659422] end_request: I/O error, dev sde, sector 212997247
[ 1215.659586] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.659689] end_request: I/O error, dev sde, sector 213019775
[ 1215.659732] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.659735] end_request: I/O error, dev sde, sector 213011583
[ 1215.659874] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.659876] end_request: I/O error, dev sde, sector 213012607
[ 1215.660017] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.660020] end_request: I/O error, dev sde, sector 213013631
[ 1215.660160] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.660163] end_request: I/O error, dev sde, sector 213014655
[ 1215.660302] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.660304] end_request: I/O error, dev sde, sector 213015679
[ 1215.660443] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.660446] end_request: I/O error, dev sde, sector 213016703
[ 1215.660586] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.660588] end_request: I/O error, dev sde, sector 213017727
[ 1215.660727] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.660729] end_request: I/O error, dev sde, sector 213018751
[ 1215.660867] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.660869] end_request: I/O error, dev sde, sector 213034111
[ 1215.661014] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.661016] end_request: I/O error, dev sde, sector 213035135
[ 1215.661158] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.661160] end_request: I/O error, dev sde, sector 213036159
[ 1215.661309] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.661417] end_request: I/O error, dev sde, sector 213042303
[ 1215.661492] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.661594] end_request: I/O error, dev sde, sector 213020799
[ 1215.661625] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.661627] end_request: I/O error, dev sde, sector 213043327
[ 1215.661765] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.661767] end_request: I/O error, dev sde, sector 213044351
[ 1215.661907] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.661909] end_request: I/O error, dev sde, sector 213045375
[ 1215.662050] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.662052] end_request: I/O error, dev sde, sector 213046399
[ 1215.662193] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.662195] end_request: I/O error, dev sde, sector 213047423
[ 1215.662333] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.662335] end_request: I/O error, dev sde, sector 213048447
[ 1215.662476] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.662478] end_request: I/O error, dev sde, sector 213049471
[ 1215.662618] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.662621] end_request: I/O error, dev sde, sector 213050495
[ 1215.662759] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.662762] end_request: I/O error, dev sde, sector 213051519
[ 1215.662902] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.663006] end_request: I/O error, dev sde, sector 213052543
[ 1215.663066] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.663069] end_request: I/O error, dev sde, sector 213021823
[ 1215.663209] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.663212] end_request: I/O error, dev sde, sector 213022847
[ 1215.663352] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.663449] end_request: I/O error, dev sde, sector 213023871
[ 1215.663496] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.663498] end_request: I/O error, dev sde, sector 213053567
[ 1215.663634] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.663636] end_request: I/O error, dev sde, sector 213055615
[ 1215.663771] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.663774] end_request: I/O error, dev sde, sector 213056639
[ 1215.663909] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.663911] end_request: I/O error, dev sde, sector 213057663
[ 1215.664051] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.664053] end_request: I/O error, dev sde, sector 213058687
[ 1215.664192] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.664290] end_request: I/O error, dev sde, sector 213059711
[ 1215.664351] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.664353] end_request: I/O error, dev sde, sector 213024895
[ 1215.664490] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.664492] end_request: I/O error, dev sde, sector 213025919
[ 1215.664629] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.664631] end_request: I/O error, dev sde, sector 213026943
[ 1215.664765] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.664767] end_request: I/O error, dev sde, sector 213027967
[ 1215.664905] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.664907] end_request: I/O error, dev sde, sector 213028991
[ 1215.665045] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.665047] end_request: I/O error, dev sde, sector 213030015
[ 1215.665186] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.665188] end_request: I/O error, dev sde, sector 213031039
[ 1215.665334] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.665336] end_request: I/O error, dev sde, sector 213032063
[ 1215.665477] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.665479] end_request: I/O error, dev sde, sector 213033087
[ 1215.665619] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.665622] end_request: I/O error, dev sde, sector 213037183
[ 1215.665762] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.665764] end_request: I/O error, dev sde, sector 213038207
[ 1215.665904] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.665906] end_request: I/O error, dev sde, sector 213039231
[ 1215.666046] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.666048] end_request: I/O error, dev sde, sector 213040255
[ 1215.666187] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.666190] end_request: I/O error, dev sde, sector 213041279
[ 1215.666359] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.666362] end_request: I/O error, dev sde, sector 213054591
[ 1215.666500] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.666503] end_request: I/O error, dev sde, sector 213065855
[ 1215.666642] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.666644] end_request: I/O error, dev sde, sector 213066879
[ 1215.666782] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.666785] end_request: I/O error, dev sde, sector 213067903
[ 1215.666925] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.666928] end_request: I/O error, dev sde, sector 213075071
[ 1215.667069] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.667071] end_request: I/O error, dev sde, sector 213076095
[ 1215.667211] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.667214] end_request: I/O error, dev sde, sector 213077119
[ 1215.667359] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.667361] end_request: I/O error, dev sde, sector 213078143
[ 1215.667501] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.667503] end_request: I/O error, dev sde, sector 213079167
[ 1215.667642] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.667644] end_request: I/O error, dev sde, sector 213080191
[ 1215.667784] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.667786] end_request: I/O error, dev sde, sector 213081215
[ 1215.667924] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.667926] end_request: I/O error, dev sde, sector 213082239
[ 1215.668065] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.668068] end_request: I/O error, dev sde, sector 213083263
[ 1215.668205] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.668208] end_request: I/O error, dev sde, sector 213084287
[ 1215.668352] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.668354] end_request: I/O error, dev sde, sector 213085311
[ 1215.668493] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.668496] end_request: I/O error, dev sde, sector 213086335
[ 1215.668642] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.668644] end_request: I/O error, dev sde, sector 213087359
[ 1215.668786] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.668788] end_request: I/O error, dev sde, sector 213088383
[ 1215.668927] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.668930] end_request: I/O error, dev sde, sector 213089407
[ 1215.669071] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.669073] end_request: I/O error, dev sde, sector 213090431
[ 1215.669215] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.669217] end_request: I/O error, dev sde, sector 213091455
[ 1215.669363] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.669365] end_request: I/O error, dev sde, sector 213092479
[ 1215.669505] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.669507] end_request: I/O error, dev sde, sector 213093503
[ 1215.669646] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.669649] end_request: I/O error, dev sde, sector 213094527
[ 1215.669790] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.669792] end_request: I/O error, dev sde, sector 213095551
[ 1215.669931] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.669933] end_request: I/O error, dev sde, sector 213096575
[ 1215.670074] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.670076] end_request: I/O error, dev sde, sector 213097599
[ 1215.670193] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.670196] end_request: I/O error, dev sde, sector 213098623
[ 1215.670317] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.670319] end_request: I/O error, dev sde, sector 213099647
[ 1215.670434] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.670436] end_request: I/O error, dev sde, sector 213100671
[ 1215.670551] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.670554] end_request: I/O error, dev sde, sector 213101695
[ 1215.670668] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.670670] end_request: I/O error, dev sde, sector 213102719
[ 1215.670787] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.670789] end_request: I/O error, dev sde, sector 213103743
[ 1215.670905] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.670907] end_request: I/O error, dev sde, sector 213104767
[ 1215.671027] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.671030] end_request: I/O error, dev sde, sector 213105791
[ 1215.671143] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.671146] end_request: I/O error, dev sde, sector 213106815
[ 1215.671266] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.671268] end_request: I/O error, dev sde, sector 213107839
[ 1215.671385] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.671388] end_request: I/O error, dev sde, sector 213108863
[ 1215.671505] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.671508] end_request: I/O error, dev sde, sector 213109887
[ 1215.671622] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.671624] end_request: I/O error, dev sde, sector 213110911
[ 1215.671739] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.671741] end_request: I/O error, dev sde, sector 213111935
[ 1215.671866] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.671868] end_request: I/O error, dev sde, sector 213112959
[ 1215.671986] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.671988] end_request: I/O error, dev sde, sector 213113983
[ 1215.672103] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.672105] end_request: I/O error, dev sde, sector 213115007
[ 1215.672220] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.672222] end_request: I/O error, dev sde, sector 213116031
[ 1215.672342] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.672344] end_request: I/O error, dev sde, sector 213117055
[ 1215.673218] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.673306] end_request: I/O error, dev sde, sector 213060735
[ 1215.673465] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.673552] end_request: I/O error, dev sde, sector 213061759
[ 1215.673711] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.674352] end_request: I/O error, dev sde, sector 213062783
[ 1215.674510] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.674597] end_request: I/O error, dev sde, sector 213063807
[ 1215.674754] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.674841] end_request: I/O error, dev sde, sector 213064831
[ 1215.675002] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.675089] end_request: I/O error, dev sde, sector 213068927
[ 1215.675246] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.675333] end_request: I/O error, dev sde, sector 213069951
[ 1215.675492] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.675579] end_request: I/O error, dev sde, sector 213070975
[ 1215.675738] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.675825] end_request: I/O error, dev sde, sector 213071999
[ 1215.675984] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.676073] end_request: I/O error, dev sde, sector 213073023
[ 1215.676232] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.676319] end_request: I/O error, dev sde, sector 213074047
[ 1215.676602] sd 4:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1215.676693] end_request: I/O error, dev sde, sector 213009535
[ 1215.759216] md: md3: recovery done.
[ 1216.049070] RAID5 conf printout:
[ 1216.049134]  --- rd:10 wd:8
[ 1216.049184]  disk 0, o:1, dev:sdc1
[ 1216.049228]  disk 1, o:1, dev:sdd1
[ 1216.049284]  disk 2, o:0, dev:sde1
[ 1216.049326]  disk 3, o:1, dev:sdf1
[ 1216.049367]  disk 4, o:1, dev:sdg1
[ 1216.049409]  disk 5, o:1, dev:sdh1
[ 1216.049451]  disk 6, o:1, dev:sdi1
[ 1216.049492]  disk 7, o:1, dev:sdj1
[ 1216.049534]  disk 8, o:1, dev:sdk1
[ 1216.049576]  disk 9, o:1, dev:sdl1
[ 1216.052264] RAID5 conf printout:
[ 1216.052307]  --- rd:10 wd:8
[ 1216.052347]  disk 0, o:1, dev:sdc1
[ 1216.052389]  disk 1, o:1, dev:sdd1
[ 1216.052431]  disk 2, o:0, dev:sde1
[ 1216.052472]  disk 3, o:1, dev:sdf1
[ 1216.052513]  disk 4, o:1, dev:sdg1
[ 1216.052555]  disk 5, o:1, dev:sdh1
[ 1216.052596]  disk 6, o:1, dev:sdi1
[ 1216.052638]  disk 7, o:1, dev:sdj1
[ 1216.052679]  disk 8, o:1, dev:sdk1
[ 1216.052729] RAID5 conf printout:
[ 1216.052770]  --- rd:10 wd:8
[ 1216.052811]  disk 0, o:1, dev:sdc1
[ 1216.052852]  disk 1, o:1, dev:sdd1
[ 1216.052894]  disk 2, o:0, dev:sde1
[ 1216.052935]  disk 3, o:1, dev:sdf1
[ 1216.052977]  disk 4, o:1, dev:sdg1
[ 1216.053019]  disk 5, o:1, dev:sdh1
[ 1216.053060]  disk 6, o:1, dev:sdi1
[ 1216.053102]  disk 7, o:1, dev:sdj1
[ 1216.053143]  disk 8, o:1, dev:sdk1
[ 1216.055296] RAID5 conf printout:
[ 1216.055340]  --- rd:10 wd:8
[ 1216.055383]  disk 0, o:1, dev:sdc1
[ 1216.055426]  disk 1, o:1, dev:sdd1
[ 1216.055470]  disk 3, o:1, dev:sdf1
[ 1216.055513]  disk 4, o:1, dev:sdg1
[ 1216.055556]  disk 5, o:1, dev:sdh1
[ 1216.055599]  disk 6, o:1, dev:sdi1
[ 1216.055642]  disk 7, o:1, dev:sdj1
[ 1216.055686]  disk 8, o:1, dev:sdk1
[ 1444.068916] md: data-check of RAID array md0
[ 1444.068978] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 1444.069026] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[ 1444.069120] md: using 128k window, over a total of 8393856 blocks.
[ 1445.073363] md: delaying data-check of md1 until md0 has finished (they share one or more physical units)
[ 1446.078880] md: delaying data-check of md2 until md1 has finished (they share one or more physical units)
[ 1446.079077] md: delaying data-check of md1 until md0 has finished (they share one or more physical units)
[ 1447.084159] md: data-check of RAID array md3
[ 1447.084214] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 1447.084276] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[ 1447.084361] md: using 128k window, over a total of 293032960 blocks.
[ 1447.084417] md: md3: data-check done.
[ 1447.084473] md: delaying data-check of md2 until md1 has finished (they share one or more physical units)
[ 1447.084560] md: delaying data-check of md1 until md0 has finished (they share one or more physical units)
[ 1449.713579] program smartctl is using a deprecated SCSI ioctl, please convert it to SG_IO
[ 1524.371489] md: md0: data-check done.
[ 1524.389361] md: delaying data-check of md2 until md1 has finished (they share one or more physical units)
[ 1524.389544] md: data-check of RAID array md1
[ 1524.389590] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 1524.389637] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[ 1524.389709] md: using 128k window, over a total of 136448 blocks.
[ 1525.567626] md: md1: data-check done.
[ 1525.583089] md: data-check of RAID array md2
[ 1525.583139] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 1525.583186] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[ 1525.583258] md: using 128k window, over a total of 284503040 blocks.
[ 1749.091552] program smartctl is using a deprecated SCSI ioctl, please convert it to SG_IO
[ 2049.286588] program smartctl is using a deprecated SCSI ioctl, please convert it to SG_IO
[ 2349.207522] program smartctl is using a deprecated SCSI ioctl, please convert it to SG_IO
[ 2649.915475] program smartctl is using a deprecated SCSI ioctl, please convert it to SG_IO
[ 2949.866608] program smartctl is using a deprecated SCSI ioctl, please convert it to SG_IO
[ 3249.335569] program smartctl is using a deprecated SCSI ioctl, please convert it to SG_IO
[ 3549.130226] program smartctl is using a deprecated SCSI ioctl, please convert it to SG_IO
[ 3849.445387] program smartctl is using a deprecated SCSI ioctl, please convert it to SG_IO
[ 4149.533569] program smartctl is using a deprecated SCSI ioctl, please convert it to SG_IO
[ 4320.011690] I/O error in filesystem ("md3") meta-data dev md3 block 0x9d34c100       ("xlog_iodone") error 5 buf count 262144
[ 4320.011781] xfs_force_shutdown(md3,0x2) called from line 1056 of file fs/xfs/xfs_log.c.  Return address = 0xffffffff803b6c33
[ 4320.011989] Filesystem "md3": Log I/O Error Detected.  Shutting down filesystem: md3
[ 4320.012072] Please umount the filesystem, and rectify the problem(s)
[ 4321.532013] Filesystem "md3": xfs_log_force: error 5 returned.
[ 4321.757263] Filesystem "md3": xfs_log_force: error 5 returned.
[ 4351.757280] Filesystem "md3": xfs_log_force: error 5 returned.
[ 4381.757280] Filesystem "md3": xfs_log_force: error 5 returned.
[ 4411.757282] Filesystem "md3": xfs_log_force: error 5 returned.
[ 4441.757295] Filesystem "md3": xfs_log_force: error 5 returned.
[ 4449.736735] program smartctl is using a deprecated SCSI ioctl, please convert it to SG_IO
[ 4471.757294] Filesystem "md3": xfs_log_force: error 5 returned.
[ 4501.757303] Filesystem "md3": xfs_log_force: error 5 returned.
[ 4531.757273] Filesystem "md3": xfs_log_force: error 5 returned.
[ 4561.757294] Filesystem "md3": xfs_log_force: error 5 returned.
[ 4591.757293] Filesystem "md3": xfs_log_force: error 5 returned.
[ 4621.757304] Filesystem "md3": xfs_log_force: error 5 returned.
[ 4651.757292] Filesystem "md3": xfs_log_force: error 5 returned.
[ 4681.757304] Filesystem "md3": xfs_log_force: error 5 returned.
[ 4711.757282] Filesystem "md3": xfs_log_force: error 5 returned.
[ 4741.757304] Filesystem "md3": xfs_log_force: error 5 returned.
[ 7450.064973] __ratelimit: 16374 callbacks suppressed
[ 7450.065026] Buffer I/O error on device md3, logical block 61811713
[ 7450.065231] Buffer I/O error on device md3, logical block 61811713
[ 7450.103854] Buffer I/O error on device md3, logical block 164831233
[ 7450.103964] Buffer I/O error on device md3, logical block 164831233
[ 7450.147422] Buffer I/O error on device md3, logical block 267850753
[ 7450.147588] Buffer I/O error on device md3, logical block 267850753
[ 7450.183152] Buffer I/O error on device md3, logical block 370870273
[ 7450.183319] Buffer I/O error on device md3, logical block 370870273
[ 7450.221272] Buffer I/O error on device md3, logical block 473889793
[ 7450.221425] Buffer I/O error on device md3, logical block 473889793
[ 7471.757279] Filesystem "md3": xfs_log_force: error 5 returned.
[ 7501.757279] Filesystem "md3": xfs_log_force: error 5 returned.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
