Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7PFnNuT211609 for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 10:49:34 -0500
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 355923F7F6D
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 08:50:12 -0700 (PDT)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de
	[85.214.69.204]) by cuda.sgi.com with ESMTP id ZSa4ekClF7Fprp09
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 08:50:12 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id D386C4040F1B
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 17:50:08 +0200 (CEST)
Date: Tue, 25 Aug 2009 17:50:08 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: Mounted xfs slows down block device
Message-ID: <alpine.LSU.2.00.0908251325410.9492@fbirervta.pbzchgretzou.qr>
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
To: xfs@oss.sgi.com

Hi,


I am seeing a really odd interaction between dm-crypt and xfs (not 
happening with other filesystems): when a crypto block device is 
mounted, reading from it slows by a significant amount.

# umount /home
# dd_rescue /dev/mapper/home /dev/null
dd_rescue: (info): ipos:     15360.0k, opos:     15360.0k, xferd:     15360.0k
                   errs:      0, errxfer:         0.0k, succxfer:     15360.0k
             +curr.rate:    19623kB/s, avg.rate:    19623kB/s, avg.load: 15.3%

# mount /home
# dd_rescue /dev/mapper/home /dev/null
dd_rescue: (info): ipos:      5120.0k, opos:      5120.0k, xferd:      5120.0k
                   errs:      0, errxfer:         0.0k, succxfer:      5120.0k
             +curr.rate:     4578kB/s, avg.rate:     4578kB/s, avg.load: 17.0%

/proc/mounts contains:
/dev/mapper/home /home xfs rw,relatime,nobarrier,usrquota,prjquota,grpquota 0 0

xfs_info:
meta-data=/dev/mapper/home       isize=256    agcount=16, agsize=3259186 blks
         =                       sectsz=512   attr=1
data     =                       bsize=4096   blocks=52146976, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=25462, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0


Values vary; on my home desktop it goes from 19->4MB/s, and even on
server it goes from 80->31MB/sec. It is independent of any mount options
or the age of the filesystem.

This happens for me on at least 2.6.31-rc6.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
