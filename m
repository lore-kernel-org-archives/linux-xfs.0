Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 03:31:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m66AUdRx012717
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 03:30:40 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 250AD29963
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 03:31:42 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id 1RY0vbYlNKuWGKDJ for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 03:31:42 -0700 (PDT)
Date: Sun, 6 Jul 2008 06:31:41 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <alpine.DEB.1.10.0807051923380.23222@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0807060447180.5005@p34.internal.lan>
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no> <486FBFAB.5050303@shaw.ca> <alpine.DEB.1.10.0807051527210.8002@p34.internal.lan> <48700228.7060904@shaw.ca> <alpine.DEB.1.10.0807051923380.23222@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>



On Sat, 5 Jul 2008, Justin Piszcz wrote:

>
>
> On Sat, 5 Jul 2008, Robert Hancock wrote:
>
>> Justin Piszcz wrote:
>>>> Can you post your dmesg from bootup with the controller/drive detection?
>> 
>> So you've got 6 drives in the machine. Intel chipsets normally seem pretty 
>> robust with AHCI.
>> 
>> Are you certain that your machine has enough power to run all those drives 
>> properly? We've seen in a number of cases that power fluctuations or noise 
>> can cause these kinds of errors.
>
> I have a 650watt PSU (nice antec one) and the power draw of the box is 
> ~148watts w/ veliciraptors, ~250 when fully load all 4 cores + all 12 disks 
> writing.  I have turned off the irqbalance daemon and I am going to see if 
> the problem re-occurs.
>
> Justin.
>

With IRQ balance turned off, it did not make any difference.

This time I also left NCQ on (bad idea):

And infact this time (w/NCQ enabled), it was so bad it dropped a disk from 
my RAID: (and later it dropped another disk when it was rebuilding (again, 
w/NCQ on), words of wisdom? do NOT use NCQ w/raptor disks))

md3 : active raid5 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdh1[5] sdg1[4] sdf1[10](F) sde1[2] sdd1[1] sdc1[0]
       2637296640 blocks level 5, 1024k chunk, algorithm 2 [10/9] [UUU_UUUUUU]

p34:~# fdisk -l /dev/sdf
p34:~#

[   27.080281] EXT3 FS on md1, internal journal
[   27.080285] EXT3-fs: mounted filesystem with ordered data mode.
[   27.080631] Filesystem "md3": Disabling barriers, not supported by the underlying device
[   27.080762] XFS mounting filesystem md3
[   27.231444] Ending clean XFS mount for filesystem: md3
[   30.003809] e1000: eth1: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
[   30.174956] e1000: eth2: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
[   31.619294] eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   35.112182] warning: `named' uses 32-bit capabilities (legacy support in use)
[ 1842.570355] ata12.00: exception Emask 0x2 SAct 0x7 SErr 0x0 action 0x2 frozen
[ 1842.570361] ata12.00: irq_stat 0x00060002, protocol mismatch
[ 1842.570367] ata12.00: cmd 60/e0:00:3f:c8:1c/03:00:15:00:00/40 tag 0 ncq 507904 in
[ 1842.570368]          res 50/00:01:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
[ 1842.570371] ata12.00: status: { DRDY }
[ 1842.570376] ata12.00: cmd 60/e0:08:1f:cc:1c/03:00:15:00:00/40 tag 1 ncq 507904 in
[ 1842.570377]          res 50/00:01:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
[ 1842.570380] ata12.00: status: { DRDY }
[ 1842.570384] ata12.00: cmd 60/40:10:ff:cf:1c/00:00:15:00:00/40 tag 2 ncq 32768 in
[ 1842.570385]          res 50/00:01:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
[ 1842.570387] ata12.00: status: { DRDY }
[ 1842.570396] ata12: hard resetting link
[ 1844.690631] ata12: softreset failed (SRST command error)
[ 1844.690638] ata12: reset failed (errno=-5), retrying in 8 secs
[ 1852.568418] ata12: hard resetting link
[ 1854.700112] ata12: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[ 1854.710188] ata12.00: configured for UDMA/100
[ 1854.710207] ata12: EH complete
[ 1855.138782] sd 11:0:0:0: [sdl] 586072368 512-byte hardware sectors (300069 MB)
[ 1855.138799] sd 11:0:0:0: [sdl] Write Protect is off
[ 1855.138804] sd 11:0:0:0: [sdl] Mode Sense: 00 3a 00 00
[ 1855.138842] sd 11:0:0:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1931.593377] ata6.00: exception Emask 0x2 SAct 0x7fff SErr 0x3000400 action 0x2 frozen
[ 1931.593386] ata6: SError: { Proto TrStaTrns UnrecFIS }
[ 1931.593392] ata6.00: cmd 60/e0:00:3f:08:c8/03:00:20:00:00/40 tag 0 ncq 507904 in
[ 1931.593393]          res 40/00:28:ff:0f:e0/00:00:15:00:00/40 Emask 0x6 (timeout)
[ 1931.593396] ata6.00: status: { DRDY }
[ 1931.593400] ata6.00: cmd 60/e0:08:1f:0c:c8/03:00:20:00:00/40 tag 1 ncq 507904 in
[ 1931.593402]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1931.593404] ata6.00: status: { DRDY }
[ 1931.593408] ata6.00: cmd 60/40:10:ff:0f:c8/00:00:20:00:00/40 tag 2 ncq 32768 in
[ 1931.593409]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1931.593412] ata6.00: status: { DRDY }
[ 1931.593416] ata6.00: cmd 60/f8:18:3f:18:c8/00:00:20:00:00/40 tag 3 ncq 126976 in
[ 1931.593417]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1931.593420] ata6.00: status: { DRDY }
[ 1931.593424] ata6.00: cmd 60/e0:20:37:19:c8/03:00:20:00:00/40 tag 4 ncq 507904 in
[ 1931.593425]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1931.593427] ata6.00: status: { DRDY }
[ 1931.593431] ata6.00: cmd 60/28:28:17:1d:c8/03:00:20:00:00/40 tag 5 ncq 413696 in
[ 1931.593433]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1931.593437] ata6.00: status: { DRDY }
[ 1931.593442] ata6.00: cmd 60/e0:30:3f:20:c8/03:00:20:00:00/40 tag 6 ncq 507904 in
[ 1931.593443]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1931.593447] ata6.00: status: { DRDY }
[ 1931.593452] ata6.00: cmd 60/e0:38:1f:24:c8/03:00:20:00:00/40 tag 7 ncq 507904 in
[ 1931.593453]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1931.593457] ata6.00: status: { DRDY }
[ 1931.593463] ata6.00: cmd 60/28:40:ff:27:c8/03:00:20:00:00/40 tag 8 ncq 413696 in
[ 1931.593464]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1931.593468] ata6.00: status: { DRDY }
[ 1931.593473] ata6.00: cmd 60/f8:48:27:2b:c8/00:00:20:00:00/40 tag 9 ncq 126976 in
[ 1931.593474]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1931.593478] ata6.00: status: { DRDY }
[ 1931.593483] ata6.00: cmd 60/e0:50:1f:2c:c8/03:00:20:00:00/40 tag 10 ncq 507904 in
[ 1931.593485]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1931.593489] ata6.00: status: { DRDY }
[ 1931.593494] ata6.00: cmd 60/28:58:ff:2f:c8/03:00:20:00:00/40 tag 11 ncq 413696 in
[ 1931.593495]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1931.593499] ata6.00: status: { DRDY }
[ 1931.593504] ata6.00: cmd 60/e0:60:27:33:c8/03:00:20:00:00/40 tag 12 ncq 507904 in
[ 1931.593505]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1931.593509] ata6.00: status: { DRDY }
[ 1931.593514] ata6.00: cmd 60/f8:68:07:37:c8/00:00:20:00:00/40 tag 13 ncq 126976 in
[ 1931.593516]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1931.593520] ata6.00: status: { DRDY }
[ 1931.593525] ata6.00: cmd 60/40:70:ff:37:c8/00:00:20:00:00/40 tag 14 ncq 32768 in
[ 1931.593526]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x6 (timeout)
[ 1931.593530] ata6.00: status: { DRDY }
[ 1931.896320] ata6: soft resetting link
[ 1937.097529] ata6: port is slow to respond, please be patient (Status 0xc0)
[ 1941.941795] ata6: softreset failed (device not ready)
[ 1941.941802] ata6: hard resetting link
[ 1947.445957] ata6: port is slow to respond, please be patient (Status 0x80)
[ 1951.984266] ata6: COMRESET failed (errno=-16)
[ 1951.984272] ata6: hard resetting link
[ 1957.488431] ata6: port is slow to respond, please be patient (Status 0x80)
[ 1987.012943] ata6: COMRESET failed (errno=-16)
[ 1987.012952] ata6: limiting SATA link speed to 1.5 Gbps
[ 1987.012955] ata6: hard resetting link
[ 1992.058175] ata6: COMRESET failed (errno=-16)
[ 1992.058182] ata6: reset failed, giving up
[ 1992.058187] ata6.00: disabled
[ 1992.058240] ata6: EH complete
[ 1992.058285] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058292] end_request: I/O error, dev sdf, sector 549992447
[ 1992.058303] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058305] end_request: I/O error, dev sdf, sector 549992199
[ 1992.058311] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058313] end_request: I/O error, dev sdf, sector 549991207
[ 1992.058319] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058321] end_request: I/O error, dev sdf, sector 549990399
[ 1992.058327] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058329] end_request: I/O error, dev sdf, sector 549989407
[ 1992.058333] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058335] end_request: I/O error, dev sdf, sector 549989159
[ 1992.058340] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058342] end_request: I/O error, dev sdf, sector 549988351
[ 1992.058348] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058350] end_request: I/O error, dev sdf, sector 549987359
[ 1992.058356] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058358] end_request: I/O error, dev sdf, sector 549986367
[ 1992.058364] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058366] end_request: I/O error, dev sdf, sector 549985559
[ 1992.058372] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058374] end_request: I/O error, dev sdf, sector 549984567
[ 1992.058379] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058383] end_request: I/O error, dev sdf, sector 549984319
[ 1992.058387] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058391] end_request: I/O error, dev sdf, sector 549982207
[ 1992.058397] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058402] end_request: I/O error, dev sdf, sector 549981215
[ 1992.058408] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058412] end_request: I/O error, dev sdf, sector 549980223
[ 1992.058421] sd 5:0:0:0: [sdf] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
[ 1992.058425] end_request: I/O error, dev sdf, sector 586067135
[ 1992.058430] end_request: I/O error, dev sdf, sector 586067135
[ 1992.058434] md: super_written gets error=-5, uptodate=0
[ 1992.058437] raid5: Disk failure on sdf1, disabling device. Operation continuing on 9 devices
[ 1991.645896] RAID5 conf printout:
[ 1991.645903]  --- rd:10 wd:9
[ 1991.645906]  disk 0, o:1, dev:sdc1
[ 1991.645908]  disk 1, o:1, dev:sdd1
[ 1991.645910]  disk 2, o:1, dev:sde1
[ 1991.645912]  disk 3, o:0, dev:sdf1
[ 1991.645914]  disk 4, o:1, dev:sdg1
[ 1991.645916]  disk 5, o:1, dev:sdh1
[ 1991.645918]  disk 6, o:1, dev:sdi1
[ 1991.645920]  disk 7, o:1, dev:sdj1
[ 1991.645922]  disk 8, o:1, dev:sdk1
[ 1991.645923]  disk 9, o:1, dev:sdl1
[ 1991.678270] RAID5 conf printout:
[ 1991.678275]  --- rd:10 wd:9
[ 1991.678278]  disk 0, o:1, dev:sdc1
[ 1991.678280]  disk 1, o:1, dev:sdd1
[ 1991.678282]  disk 2, o:1, dev:sde1
[ 1991.678284]  disk 4, o:1, dev:sdg1
[ 1991.678286]  disk 5, o:1, dev:sdh1
[ 1991.678288]  disk 6, o:1, dev:sdi1
[ 1991.678290]  disk 7, o:1, dev:sdj1
[ 1991.678292]  disk 8, o:1, dev:sdk1
[ 1991.678293]  disk 9, o:1, dev:sdl1
[ 2053.744827] program smartctl is using a deprecated SCSI ioctl, please convert it to SG_IO

Even after rebooting, the port was still 'hung' / having problems, I 
power cycled the host and it came up just fine, ran SMART tests too, no 
issues!

# smartctl -a /dev/sdf
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD3000GLFS-01F8U0
Serial Number:    **************
Firmware Version: 03.03V01
User Capacity:    300,069,052,416 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Sun Jul  6 04:58:37 2008 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

.. etc

No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%       705         -
# 2  Extended offline    Completed without error       00%       702         -
# 3  Short offline       Completed without error       00%       677         -
# 4  Short offline       Completed without error       00%       630         -
# 5  Short offline       Completed without error       00%       271         -

I will try booting with the various options disabling APIC/ACPI/nolapic to see 
if it is possible to not get these errors/problems under heavy I/O:

$ cat runtest.sh 
#!/bin/bash

for i in `seq 0 20`
do
   cd $i
   tar xf ../linux-2.6.25.10.tar &
   cd ..
done

--

In short, utilizing Raptors (especially veliciraptors)+NCQ on the ICH8 
w/AHCI & other cards in a RAID 5 configuration is a death trap (a good way 
to lose your data), it appears unsafe to use NCQ w/raptors in a RAID 5
configuration.  I've defaulted back to disabling it like I always do
and my RAID5 is rebuilding now.

After the rebuild is completed I will perform more testing.


Justin.
