Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Sep 2006 04:24:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8JBOHaG004608
	for <linux-xfs@oss.sgi.com>; Tue, 19 Sep 2006 04:24:18 -0700
Received: from garda.mci.edu (lxoffice.mci.edu [193.171.232.20])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCEF1D1783CD
	for <linux-xfs@oss.sgi.com>; Tue, 19 Sep 2006 03:16:01 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by garda.mci.edu (Postfix) with ESMTP id 56053104711
	for <linux-xfs@oss.sgi.com>; Tue, 19 Sep 2006 12:29:06 +0200 (CEST)
Received: from garda.mci.edu ([127.0.0.1])
	by localhost (rekim [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 18164-03 for <linux-xfs@oss.sgi.com>;
	Tue, 19 Sep 2006 10:28:57 +0000 (UTC)
Received: from crados (pc61vw.mci.edu [193.171.235.61])
	by garda.mci.edu (Postfix) with ESMTP id 3FB621143D3
	for <linux-xfs@oss.sgi.com>; Tue, 19 Sep 2006 12:16:36 +0200 (CEST)
From: christian gattermair <christian.gattermair@mci.edu>
Subject: Re: xfs_check - out of memory | xfs_repair - superblock error reading
Date: Tue, 19 Sep 2006 12:03:21 +0200
References: <200609181519.18448.christian.gattermair@mci.edu> <450EB025.5020007@oss.sgi.com>
In-Reply-To: <450EB025.5020007@oss.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200609191203.22083.christian.gattermair@mci.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

hi!

thanks for all your answers


parted:

Disk geometry for /dev/sda: 0.000-3147012,000 megabytes
Disk label type: msdos
Minor    Start       End     Type      Filesystem  Flags
1          0,031 1049854,423  primary   xfs

cat /proc/partitions

  8     0 3222540288 sda
   8     1 1075050898 sda1


tw_cli (3ware raid tool)

Unit  UnitType  Status         %Cmpl  Stripe  Size(GB)  Cache  AVerify  IgnECC
------------------------------------------------------------------------------
u0    RAID-5    OK             -      64K     3073.25   ON     OFF      OFF

Port   Status           Unit   Size        Blocks        Serial
---------------------------------------------------------------
p0     OK               u0     279.46 GB   586072368     3NF04F4D
p1     OK               u0     279.46 GB   586072368     3NF09YMR
p2     OK               u0     279.46 GB   586072368     3NF0AGN2
p3     OK               u0     279.46 GB   586072368     3NF0D6ZM
p4     OK               u0     279.46 GB   586072368     3NF0BG47
p5     OK               u0     279.46 GB   586072368     3NF09YQT
p6     OK               u0     279.46 GB   586072368     3NF02SMD
p7     OK               u0     279.46 GB   586072368     3NF01YL5
p8     OK               u0     279.46 GB   586072368     3NF02J46
p9     OK               u0     279.46 GB   586072368     3NF04EYE
p10    OK               u0     279.46 GB   586072368     3NF0ECRG
p11    OK               u0     279.46 GB   586072368     3NF071X5

Name  OnlineState  BBUReady  Status    Volt     Temp     Hours  LastCapTest
---------------------------------------------------------------------------
bbu   On           Yes       OK        OK       OK       255    23-Aug-2005


dmesg:

3ware 9000 Storage Controller device driver for Linux v2.26.02.001.
ACPI: PCI interrupt 0000:04:02.0[A] -> GSI 52 (level, low) -> IRQ 185
scsi_proc_hostdir_add: proc_mkdir failed for <NULL>
3w-9xxx: scsi0: AEN: INFO (0x04:0x0055): <NULL>:.
3w-9xxx: scsi0: AEN: INFO (0x04:0x0053): <NULL>:.
scsi0 : 3ware 9000 Storage Controller
3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xfeaf0000, IRQ: 185.
3w-9xxx: scsi0: Firmware FE9X 2.06.00.009, BIOS BE9X 2.03.01.051, Ports: 12.
  Vendor: AMCC      Model: 9500S-12   DISK   Rev: 2.06
  Type:   Direct-Access                      ANSI SCSI revision: 03
sda : very big device. try to use READ CAPACITY(16).
SCSI device sda: 6445080576 512-byte hdwr sectors (3299881 MB)
SCSI device sda: drive cache: write back, no read (daft)
 /dev/scsi/host0/bus0/target0/lun0: p1
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0


what is a usv? sorry a german shurtcut. i mean ups.
no i have nothing changed on the system. normal shutdown for changing the ups 
and then boot. and know i can not mount the drive ....

yes it is the same kernel (debian 2.6.8-2-686-smp)

i have know updated xfsprogs to 2.8.11 and i get a new error message with 
xfs_check:

xfs_check /dev/sda1
XFS: Log inconsistent (didn't find previous header)
XFS: failed to find log head
ERROR: cannot find log head/tail, run xfs_repair

i will try ... and hope

with friendly greetings,

christian gattermair
