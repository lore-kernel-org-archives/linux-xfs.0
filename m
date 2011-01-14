Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0E0Ffc9195026 for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 18:15:42 -0600
Received: from zixvpm01.zixvpm.davisvision.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F196F24CA1B
	for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 16:17:55 -0800 (PST)
Received: from zixvpm01.zixvpm.davisvision.com
	(zixvpm01.zixvpm.davisvision.com [65.213.99.44]) by
	cuda.sgi.com with ESMTP id pve5dxWpkLtGLSXG for
	<xfs@oss.sgi.com>; Thu, 13 Jan 2011 16:17:55 -0800 (PST)
Received: from zixvpm01.zixvpm.davisvision.com (ZixVPM [127.0.0.1])
	by Outbound.davisvision.com (Proprietary) with ESMTP id 24F6F8CC023
	for <xfs@oss.sgi.com>; Thu, 13 Jan 2011 19:17:55 -0500 (EST)
From: Cory Coager <ccoager@davisvision.com>
Subject: RE: extremely slow write performance plaintext
Date: Fri, 14 Jan 2011 00:17:52 +0000
Message-ID: <18993_1294964274_4D2F9632_18993_1387_1_F79CF9ADB27B2646B59221B7355263830CC143B1@NYL-EXCH1.HVHCVision.com>
References: <3205_1294953756_4D2F6D1C_3205_1943_1_4D2F6D1C.2060409@davisvision.com>
	<20110113233527.6dca104d@galadriel.home>
In-Reply-To: <20110113233527.6dca104d@galadriel.home>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> What is the SAS controller? the RAID controller?
HP Smart Array P600

> Please provide more details about the enclosure/drives/cabling too.
Both enclosures are HP MSA70, 25 drives each, SAS 10k rpm drives, not sure about the cabling (server is at another location)

> What is the kernel/distro?
SLES 10 SP2, 2.6.16.60-0.21-bigsmp, x86

> Did you striped your LVs across multiple physical volumes except the last one?
None of the LV's are stripped

> What's the output for pvdisplay, vgdisplay, lvdisplay?
# pvdisplay
  --- Physical volume ---
  PV Name               /dev/cciss/c1d0p1
  VG Name               vg0
  PV Size               2.94 TB / not usable 1.51 MB
  Allocatable           yes
  PE Size (KByte)       4096
  Total PE              769902
  Free PE               150192
  Allocated PE          619710
  PV UUID               k52E36-n3Xw-10rw-hSXo-3col-TEvC-75iHZ2

  --- Physical volume ---
  PV Name               /dev/cciss/c1d1p1
  VG Name               vg0
  PV Size               2.94 TB / not usable 1.51 MB
  Allocatable           yes
  PE Size (KByte)       4096
  Total PE              769902
  Free PE               562351
  Allocated PE          207551
  PV UUID               IAZAbk-eMNZ-puMJ-DqW1-zsC7-C0ux-66vYTN

# vgdisplay
  --- Volume group ---
  VG Name               vg0
  System ID
  Format                lvm2
  Metadata Areas        4
  Metadata Sequence No  217
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                6
  Open LV               6
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               5.87 TB
  PE Size               4.00 MB
  Total PE              1539804
  Alloc PE / Size       827261 / 3.16 TB
  Free  PE / Size       712543 / 2.72 TB
  VG UUID               p1SANa-30vR-BymQ-cOls-XeVU-92nj-YP4wSU

# lvdisplay
  --- Logical volume ---
  LV Name                /dev/vg0/apps
  VG Name                vg0
  LV UUID                LLMOor-D0mP-k2kM-qvM3-Vjse-6fE0-7DdRjJ
  LV Write Access        read/write
  LV Status              available
  # open                 2
  LV Size                348.00 MB
  Current LE             87
  Segments               2
  Allocation             inherit
  Read ahead sectors     0
  Block device           253:0

  --- Logical volume ---
  LV Name                /dev/vg0/netlogon
  VG Name                vg0
  LV UUID                FxR324-yAH9-F6y3-Dz30-stqY-bYwc-4t6AZ7
  LV Write Access        read/write
  LV Status              available
  # open                 2
  LV Size                52.00 MB
  Current LE             13
  Segments               1
  Allocation             inherit
  Read ahead sectors     0
  Block device           253:1

  --- Logical volume ---
  LV Name                /dev/vg0/print
  VG Name                vg0
  LV UUID                EAISuT-a8zd-dJQa-0c6t-Zkus-I3ws-0IU9q3
  LV Write Access        read/write
  LV Status              available
  # open                 2
  LV Size                712.00 MB
  Current LE             178
  Segments               2
  Allocation             inherit
  Read ahead sectors     0
  Block device           253:2

  --- Logical volume ---
  LV Name                /dev/vg0/sqlbackup
  VG Name                vg0
  LV UUID                22NfsZ-iqdm-jWUz-9MOW-fAh1-qfB7-nWkSSG
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                270.00 GB
  Current LE             69120
  Segments               2
  Allocation             inherit
  Read ahead sectors     0
  Block device           253:3

  --- Logical volume ---
  LV Name                /dev/vg0/homes
  VG Name                vg0
  LV UUID                HMGhLH-0iA3-fp7n-A5Za-svJF-Tzxb-D291WR
  LV Write Access        read/write
  LV Status              available
  # open                 2
  LV Size                810.00 GB
  Current LE             207360
  Segments               1
  Allocation             inherit
  Read ahead sectors     0
  Block device           253:5

  --- Logical volume ---
  LV Name                /dev/vg0/shared
  VG Name                vg0
  LV UUID                Czj3gb-Adl9-FqRW-wPqH-JnW2-rDGT-toR8zL
  LV Write Access        read/write
  LV Status              available
  # open                 2
  LV Size                2.10 TB
  Current LE             550503
  Segments               1
  Allocation             inherit
  Read ahead sectors     0
  Block device           253:8

Keep in mind that I only have poor write performance on /dev/vg0/shared, the others are fine.



------------------------------------------------------------------------
The information contained in this communication is intended
only for the use of the recipient(s) named above. It may
contain information that is privileged or confidential, and
may be protected by State and/or Federal Regulations. If
the reader of this message is not the intended recipient,
you are hereby notified that any dissemination,
distribution, or copying of this communication, or any of
its contents, is strictly prohibited. If you have received
this communication in error, please return it to the sender
immediately and delete the original message and any copy
of it from your computer system. If you have any questions
concerning this message, please contact the sender.
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
