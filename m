Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2AEBu7L105814 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 08:12:01 -0600
Received: from borg.medozas.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EFA5158BA41
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 06:14:35 -0800 (PST)
Received: from borg.medozas.de (borg.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id kQ2oI5L4rTLxGeBY for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2011 06:14:35 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by borg.medozas.de (Postfix) with ESMTP id 315475FA0
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 15:14:34 +0100 (CET)
Date: Thu, 10 Mar 2011 15:14:34 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: Many-metadata performance still at a loss
Message-ID: <alpine.LNX.2.01.1103101507120.5379@obet.zrqbmnf.qr>
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


Between 2.6.33 and 2.6.37 there was a lot of interesting announcements 
with regards to XFS performance. However, now that I booted into 
2.6.37.2, I still see the metadata slowness from earlier.
(Basically `time (tar -xf linux-2.6.37.tar.gz; sync)` - ext4 gets the 
job done in like 15-20 seconds, xfs is still syncing after 11 minutes.)

Was there something I missed?

# xfs_info /
meta-data=/dev/md3               isize=256    agcount=32, 
agsize=11429117 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=365731739, 
imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
