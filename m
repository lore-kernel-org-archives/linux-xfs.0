Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o18EdcZO138762 for <xfs@oss.sgi.com>; Mon, 8 Feb 2010 08:39:38 -0600
Received: from cdptpa-omtalb.mail.rr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC9611B92BA
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2010 06:40:50 -0800 (PST)
Received: from cdptpa-omtalb.mail.rr.com (cdptpa-omtalb.mail.rr.com
	[75.180.132.121]) by cuda.sgi.com with ESMTP id
	purgZyHZ1iOKCD2g for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2010 06:40:50 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by erebus.underworld.local (Postfix) with ESMTP id 522AD1FD58
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2010 09:40:48 -0500 (EST)
Received: from erebus.underworld.local ([127.0.0.1])
	by localhost (erebus.underworld.local [127.0.0.1]) (amavisd-maia,
	port 10024) with ESMTP id 12634-04 for <xfs@oss.sgi.com>;
	Mon,  8 Feb 2010 09:40:38 -0500 (EST)
Received: from erebus.underworld.local (erebus.underworld.local [192.168.0.4])
	by erebus.underworld.local (Postfix) with ESMTPS id B161D1FD43
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2010 09:40:37 -0500 (EST)
Date: Mon, 8 Feb 2010 09:40:35 -0500
From: Cory Coager <ccoager@gmail.com>
Subject: format and xfs_info don't match
Message-ID: <20100208144035.GA12922@erebus.underworld.local>
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

For some reason the format attributes don't match the mounted 
attributes.  If you look below, lazy-count and attr aren't getting set.  
Why is this happening?

# mkfs.xfs -f -i size=1024,attr=2 -l version=2,size=128m,lazy-count=1 /dev/mapper/360a9800050334c59543455596d625a77
meta-data=/dev/mapper/360a9800050334c59543455596d625a77 isize=1024   
agcount=32, agsize=8388744 blks
        =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=268439808, imaxpct=25
        =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=32768, version=2
        =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# mount -t xfs -o noatime,nodiratime,nobarrier 
/dev/mapper/360a9800050334c59543455596d625a77 /mnt/new-homes/

# xfs_info /mnt/new-homes/
meta-data=/dev/mapper/360a9800050334c59543455596d625a77 isize=1024   
agcount=32, agsize=8388744 blks
        =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=268439808, imaxpct=25
        =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=2
        =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
