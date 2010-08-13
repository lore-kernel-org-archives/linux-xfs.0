Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7DN54al103019 for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 18:05:04 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 12B11CA6263
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 16:14:23 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	1ZBEsBng4Yb67oLU for <xfs@oss.sgi.com>;
	Fri, 13 Aug 2010 16:14:23 -0700 (PDT)
Date: Sat, 14 Aug 2010 09:05:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fs corruption not detected by xfs_check or _repair
Message-ID: <20100813230525.GF10429@dastard>
References: <4C656149.6050604@nethype.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C656149.6050604@nethype.de>
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
To: Marco Maisenhelder <marco@nethype.de>
Cc: xfs@oss.sgi.com

On Fri, Aug 13, 2010 at 05:14:17PM +0200, Marco Maisenhelder wrote:
> Hi list,
> 
> I have a little bit of a problem after a catastrophic hardware
> failure (power supply went up in smoke and took half of my server
> with it - luckily only one of my raid5 disks though). My xfs data
> partition on my raid has some severe corruption that prevents me
> from accessing some files and directories on the partition. This is
> how the problem manifests itself:
> 
> *marco:/etc# ls -lrt /store/xfs_corruption/x/
> ls: cannot access /store/xfs_corruption/x/db.backup2: Invalid argument
> ls: cannot access /store/xfs_corruption/x/db.backup1: Invalid argument
> total 0
> ?????????? ? ? ? ?                ? db.backup2
> ?????????? ? ? ? ?                ? db.backup1

What operation is returning EINVAL? strace should tell you that.

> *marco:/etc# xfs_info /store/
> meta-data=/dev/mapper/vgraid-rstore isize=256    agcount=48,
> agsize=11443904 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=549307392, imaxpct=25
>          =                       sunit=64     swidth=192 blks
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=64 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> There's nothing in any of the system logs that would hint to the
> filesystem being corrupt.

>From the xfs_db output, all the directories look valid, so I'm not
sure what is causing the problem, yet.  What kernel version and
xfs_repair version are you running?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
