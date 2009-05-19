Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4JFDVAA051152 for <xfs@oss.sgi.com>; Tue, 19 May 2009 10:13:31 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E28BCFCB2CC
	for <xfs@oss.sgi.com>; Tue, 19 May 2009 08:18:53 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id OeAFO81QT08tpYpE for <xfs@oss.sgi.com>;
	Tue, 19 May 2009 08:18:53 -0700 (PDT)
Message-ID: <4A12CCA2.3030003@sandeen.net>
Date: Tue, 19 May 2009 10:13:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: question on agcount and agsize
References: <4A12BE15.3080908@pha.jhu.edu>
In-Reply-To: <4A12BE15.3080908@pha.jhu.edu>
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
To: Josh Greenberg <josh@pha.jhu.edu>
Cc: xfs@oss.sgi.com

Josh Greenberg wrote:
> I've just installed xfs for the first time and I'm trying to put an xfs 
> file system on a large disk. When I just tried with no arguments, it 
> told me that the agsize was too large and the maximum is 268435455 
> blocks. 

Odd, mkfs.xfs w/ no args should always work.  Which version of
e2fsprogs?  How big is the block device (from /proc/partitions?)

> I wasn't familiar with allocation groups at all so I researched 
> this a little bit. I found out what an allocation group is but there 
> aren't many recommendations on agcount other than "don't make it too 
> big" because it slows the disk down as it gets full. However, after 
> playing with the numbers, I found that the lowest number it will accept 
> for agcount is 44. I now have a file system with the following structure:
> 
> meta-data=/dev/md0       isize=256    agcount=44, agsize=266361205 blks
>          =                       sectsz=512
> data     =                       bsize=4096   blocks=11719892992, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal log           bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=65536  blocks=0, rtextents=0
> 

43T, nice :)

> I have two questions:
> 1. Does the agcount have to be a power of 2? Almost every example of 
> agcount I've seen online has been a power of 2 (2, 4, 8, 16, and 32). 

nope

> I 
> originally tried an agcount of 64 which worked but then tried to size it 
> down so it wasn't too large. Will this cause problems later.

No, this is likely fine.  This should be the default; for filesystems >
32T it should max the AG size and give you 1 AG per Terabyte.

> 2. Is 44 too large? Will I experience a slow down as the disk fills? 
> I've seen people recommend that you not go over agcount=32 and even 
> someone who said not to exceed agcount=8. What are the long term 
> ramifications of this?

well, smaller agcount -> larger AG.  There's also a limit to the AG size
(1T IIRC), so there is no hard upper limit on ag count; bigger
filesystems will eventually require more AGs.

The upstream default is 4 AGs for smaller filesystems, but for 43T I
think the default is to go to 1T AGs.

Subdirectories spread out over AGs (each new subdir's files go to a new
AG, in general, all other things being equal) so for smaller
filesystems, 8 or 16 AGs was getting a little painful because stuff was
being flung all over the disk.

One thing you probably do want to do, however, is match the xfs geometry
to your raid geometry, and specify sunit/swidth or su/sw combinations at
mkfs time.  mkfs.xfs gets this geometry from lvm/md/evms/etc but can't
get it from a hardware raid; you'll need to input that yourself.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
