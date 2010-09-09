Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o89Mvgj8120673 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 17:57:43 -0500
Received: from smtp.sauce.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA1EA5F14B
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 15:58:24 -0700 (PDT)
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by
	cuda.sgi.com with ESMTP id DefN2iGWvoeaJNMj for
	<xfs@oss.sgi.com>; Thu, 09 Sep 2010 15:58:24 -0700 (PDT)
Message-ID: <4C89668E.6010800@sauce.co.nz>
Date: Fri, 10 Sep 2010 10:58:22 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: XFS over LVM over md RAID
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

Using the latest, stable versions of LVM2 and xfsprogs and the 2.6.35.4 
kernel, I am setting up lvm on a 16 drive, 256k chunk md RAID6, which 
has been used to date with XFS directly on the RAID.

mkfs.xfs directly on the RAID gives:

meta-data=/dev/md8               isize=256    agcount=32, 
agsize=106814656 blks
          =                       sectsz=4096  attr=2
data     =                       bsize=4096   blocks=3418068864, imaxpct=5
          =                       sunit=64     swidth=896 blks
naming   =version 2              bsize=4096   ascii-ci=0

which gives the correct sunit and swidth values for the array.

Creating an lv which uses the entire array and mkfs.xfs on that, gives:

meta-data=/dev/vg_local/Storage  isize=256    agcount=13, 
agsize=268435455 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=3418067968, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0

Limited testing using dd and bonnie++ shows no difference in write 
performance whether I use sunit=64/swidth=896 or sunit=0/swidth=0 on the lv.

My gut reaction is that I should be using 64/896 but maybe mkfs.xfs 
knows better?

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
