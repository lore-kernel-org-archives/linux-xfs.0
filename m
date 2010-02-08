Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o18JHLlp154663 for <xfs@oss.sgi.com>; Mon, 8 Feb 2010 13:17:21 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08EAF138886F
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2010 11:18:33 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id H0MyYQpQGDHOJQKB for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2010 11:18:33 -0800 (PST)
Message-ID: <4B706388.7080309@sandeen.net>
Date: Mon, 08 Feb 2010 13:18:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: format and xfs_info don't match
References: <20100208144035.GA12922@erebus.underworld.local>
In-Reply-To: <20100208144035.GA12922@erebus.underworld.local>
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
To: Cory Coager <ccoager@gmail.com>
Cc: xfs@oss.sgi.com

Cory Coager wrote:
> For some reason the format attributes don't match the mounted 
> attributes.  If you look below, lazy-count and attr aren't getting set.  
> Why is this happening?

which xfsprogs version?

# /sbin/mkfs.xfs -f -i size=1024,attr=2 -l version=2,size=128m,lazy-count=1 -bsize=4096 -dsize=268439808b,file,name=testfile
meta-data=testfile               isize=1024   agcount=4, agsize=67109952 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=268439808, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# mount -o loop testfile mnt/

# xfs_info mnt/
meta-data=/dev/loop0             isize=1024   agcount=4, agsize=67109952 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=268439808, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# mkfs.xfs -V
mkfs.xfs version 3.0.1

-Eric

> # mkfs.xfs -f -i size=1024,attr=2 -l version=2,size=128m,lazy-count=1 /dev/mapper/360a9800050334c59543455596d625a77
> meta-data=/dev/mapper/360a9800050334c59543455596d625a77 isize=1024   
> agcount=32, agsize=8388744 blks
>         =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=268439808, imaxpct=25
>         =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096  
> log      =internal log           bsize=4096   blocks=32768, version=2
>         =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> # mount -t xfs -o noatime,nodiratime,nobarrier 
> /dev/mapper/360a9800050334c59543455596d625a77 /mnt/new-homes/
> 
> # xfs_info /mnt/new-homes/
> meta-data=/dev/mapper/360a9800050334c59543455596d625a77 isize=1024   
> agcount=32, agsize=8388744 blks
>         =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=268439808, imaxpct=25
>         =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096  
> log      =internal               bsize=4096   blocks=32768, version=2
>         =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
