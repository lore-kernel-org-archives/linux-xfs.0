Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBPDVLmZ031603 for <xfs@oss.sgi.com>; Thu, 25 Dec 2008 07:31:21 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C42FE47A59
	for <xfs@oss.sgi.com>; Thu, 25 Dec 2008 05:31:19 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id 2D74gQ1uNrDpfGwC for
	<xfs@oss.sgi.com>; Thu, 25 Dec 2008 05:31:19 -0800 (PST)
Date: Thu, 25 Dec 2008 08:31:18 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: How do I tell if my partition is aligned for a 64k/RAID-6?
Message-ID: <alpine.DEB.1.10.0812250821360.31386@p34.internal.lan>
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
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, ataraid-list@redhat.com, bug-parted@gnu.org, xfs@oss.sgi.com

Output:

===============================================================================

p34:~# parted /dev/sda print unit s print unit chs print
Model: AMCC 9650SE-16M DISK (scsi)
Disk /dev/sda: 13.0TB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
  1      17.4kB  13.0TB  13.0TB  xfs

Model: AMCC 9650SE-16M DISK (scsi)
Disk /dev/sda: 25390350336s
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start  End           Size          File system  Name  Flags
  1      34s    25390350302s  25390350269s  xfs

Model: AMCC 9650SE-16M DISK (scsi)
Disk /dev/sda: 1580476,53,56
Sector size (logical/physical): 512B/512B
BIOS cylinder,head,sector geometry: 1580476,255,63.  Each cylinder is 8225kB.
Partition Table: gpt

Number  Start   End            File system  Name  Flags
  1      0,0,34  1580476,53,23  xfs

p34:~#

===============================================================================

I created a partition from 0Gb to 13T on the following LUN, but how do I 
verify this is aligned to the (hardware) 64KiB raid-6 array?

Unit  UnitType  Status         %RCmpl  %V/I/M  Stripe  Size(GB)  Cache  AVrfy
------------------------------------------------------------------------------
u0    RAID-6    OK             -       -       64K     12107.1   ON     ON

===============================================================================

p34:~# xfs_info /dev/sda1
meta-data=/dev/sda1              isize=256    agcount=12, agsize=268435455 
blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=3173793783, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

===============================================================================

I am not worried about the filesystem as the defaults usually get it right 
but with parted, this is the first time I had to use it for home use and 
with RAID-6 I am noticing slower performance with 15 disks (1 is a spare) 
in RAID-6 (albeit slower 7200 ones, RE3s) than I was getting with 10 
raptor150s in RAID-6 (but I had used fdisk there).

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
