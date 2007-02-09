Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 09 Feb 2007 05:28:13 -0800 (PST)
Received: from tmailer.gwdg.de (tmailer.gwdg.de [134.76.10.23])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l19DS6m7010522
	for <xfs@oss.sgi.com>; Fri, 9 Feb 2007 05:28:07 -0800
Received: from linux01.gwdg.de ([134.76.13.21])
	by mailer.gwdg.de with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.63)
	(envelope-from <jengelh@linux01.gwdg.de>)
	id 1HFVBn-00087i-5M
	for xfs@oss.sgi.com; Fri, 09 Feb 2007 13:49:19 +0100
Received: from linux01.gwdg.de (localhost [127.0.0.1])
	by linux01.gwdg.de (8.13.3/8.13.3/SuSE Linux 0.7) with ESMTP id l19CnJsR007337
	for <xfs@oss.sgi.com>; Fri, 9 Feb 2007 13:49:21 +0100
Received: from localhost (jengelh@localhost)
	by linux01.gwdg.de (8.13.3/8.13.3/Submit) with ESMTP id l19CnIbG007330
	for <xfs@oss.sgi.com>; Fri, 9 Feb 2007 13:49:18 +0100
Date: Fri, 9 Feb 2007 13:49:18 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Inodes disappearing
Message-ID: <Pine.LNX.4.61.0702091345360.31955@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello list,


here's an interesting phenomena I am seeing:

# df -h
/dev/hda3             215G  152G   63G  71% /sam224
/dev/dm-0             233G  233G  350M 100% /sam250
# df -i
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/hda3            112254144   33076 112221068    1% /sam224
/dev/dm-0            1466272   35982 1430290    3% /sam250

How come that dm-0 has much less inodes despite the two volumes having 
about the same size? It can't be because of isize=512, can it? (If at 
all, I would expect an isize=512 volume to have less inodes than a 
isize=256 one for the same number of blocks.)


# xfs_info /dev/dm-0
meta-data=/dev/disk/by-label/sam250 isize=256    agcount=16, agsize=3813429 blks         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=61014864, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=29792, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

# xfs_info /dev/hda3
meta-data=/dev/disk/by-label/sam224 isize=512    agcount=16, agsize=3507943 blks         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=56127088, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=27405, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
