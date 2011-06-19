Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5JLnnaT075545 for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 16:49:49 -0500
Received: from straum.hexapodia.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C02A51E99B
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 14:49:48 -0700 (PDT)
Received: from straum.hexapodia.org (straum.hexapodia.org [207.7.131.186]) by
	cuda.sgi.com with ESMTP id rfqGvnL5Nti99i8a for
	<xfs@oss.sgi.com>; Sun, 19 Jun 2011 14:49:48 -0700 (PDT)
Date: Sun, 19 Jun 2011 14:50:39 -0700
From: Andy Isaacson <adi@hexapodia.org>
Subject: ENOSPC but df and df -i show free space
Message-ID: <20110619215039.GA17820@hexapodia.org>
MIME-Version: 1.0
Content-Disposition: inline
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

% touch /d1/tmp/foo
touch: cannot touch `/d1/tmp/foo': No space left on device
% df /d1
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/vg0-d1   943616000 904690332  38925668  96% /d1
% df -i /d1
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/mapper/vg0-d1   167509008 11806336 155702672    8% /d1
% sudo xfs_growfs -n /d1
meta-data=/dev/mapper/vg0-d1     isize=256    agcount=18, agsize=13107200 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=235929600, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=25600, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
% grep d1 /proc/mounts
/dev/mapper/vg0-d1 /d1 xfs rw,relatime,attr2,noquota 0 0

Obviously I'm missing something, but what?

Nothing relevant in dmesg that I can see.  The filesystem started out at
200 GB and has been xfs_growfs'd in 100GB increments up to its current
size of 900 GB.

x86_64 2.6.38-rc3-00019-gafe8a88 on a quad-core i7 with 12GB RAM, on DM
on AHCI SATA.

-andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
