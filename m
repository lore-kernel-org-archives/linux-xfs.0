Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p31AAk1x221644 for <xfs@oss.sgi.com>; Fri, 1 Apr 2011 05:10:47 -0500
Received: from mxs1.siemens.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E75A1398A14
	for <xfs@oss.sgi.com>; Fri,  1 Apr 2011 03:13:58 -0700 (PDT)
Received: from mxs1.siemens.at (mxs1.siemens.at [194.138.12.131]) by
	cuda.sgi.com with ESMTP id EaVH8lAK300fHSBB for
	<xfs@oss.sgi.com>; Fri, 01 Apr 2011 03:13:58 -0700 (PDT)
Message-ID: <4D95A563.3050804@siemens.com>
Date: Fri, 01 Apr 2011 12:13:55 +0200
From: Pavol Gono <Pavol.Gono@siemens.com>
MIME-Version: 1.0
Subject: "Invalid block length" warning with small blocksize
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi

I am getting this warning in kernel log:
XFS: Invalid block length (0x2000) given for buffer
during mount, and I don't know if this can be safely ignored or not.

It happens only if I formatted XFS with block size smaller than 4k.
And I experienced it only in my virtual machine (using VirtualBox). I 
have tested it on two physical servers and it didn't happen.

OS is SLES11 SP1 64-bit.

partbox:~ # uname -a
Linux partbox 2.6.32.12-0.7-default #1 SMP 2010-05-20 11:14:20 +0200 
x86_64 x86_64 x86_64 GNU/Linux
partbox:~ # fdisk -l

Disk /dev/sda: 34.4 GB, 34359738368 bytes
255 heads, 63 sectors/track, 4177 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x00074280

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1        1305    10482381   83  Linux
/dev/sda2            1306        1435     1044225   83  Linux
/dev/sda3            1436        4177    22025115    f  W95 Ext'd (LBA)
/dev/sda5            1436        1467      257008+  82  Linux swap / Solaris
/dev/sda6            1468        1728     2096451   83  Linux
/dev/sda7            1729        1793      522081   83  Linux
/dev/sda8            1794        4177    19149448+  83  Linux
partbox:~ # mkfs.xfs -f -b size=4k /dev/sda2
meta-data=/dev/sda2              isize=256    agcount=4, agsize=65264 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=261056, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=1200, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
partbox:~ # mount /dev/sda2 /opt
partbox:~ # dmesg | tail -2
[  484.331102] XFS mounting filesystem sda2
[  484.334071] Ending clean XFS mount for filesystem: sda2
partbox:~ # umount /dev/sda2
partbox:~ # mkfs.xfs -f -b size=2k /dev/sda2
meta-data=/dev/sda2              isize=256    agcount=4, agsize=130528 blks
          =                       sectsz=512   attr=2
data     =                       bsize=2048   blocks=522112, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=2048   blocks=1728, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
partbox:~ # mount /dev/sda2 /opt
partbox:~ # dmesg | tail -3
[  560.534120] XFS mounting filesystem sda2
[  560.537462] XFS: Invalid block length (0x2000) given for buffer
[  560.542101] Ending clean XFS mount for filesystem: sda2
partbox:~ #


Pavol Gono

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
