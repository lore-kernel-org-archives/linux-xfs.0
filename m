Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2D2FwIZ253310 for <xfs@oss.sgi.com>; Sat, 12 Mar 2011 20:16:04 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A25021380436
	for <xfs@oss.sgi.com>; Sat, 12 Mar 2011 18:18:39 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vLAsqJY5BvHDyW3L for <xfs@oss.sgi.com>;
	Sat, 12 Mar 2011 18:18:39 -0800 (PST)
Date: Sun, 13 Mar 2011 11:55:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.37: mount with quota eats all available memory
Message-ID: <20110313005506.GG15097@dastard>
References: <201103112258.48742.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201103112258.48742.arekm@maven.pl>
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
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Fri, Mar 11, 2011 at 10:58:48PM +0100, Arkadiusz Miskiewicz wrote:
> 
> I have a machine with 4GB, running 64bit 2.6.37, xfs on top of soft raid5.
> 
> Recently after using xfs_fsr (and getting a oops) had to do xfs_repair and now 
> I'm no longer able to mount this filesystem with usrquota and grpquota.
> 
> xfs eats all ram, from slabtop:
> 3756380 3756380 100%    1.00K 244655       16   3914480K xfs_inode
> 251712 251711  99%    0.06K   3933       64     15732K kmalloc-64
> 118482 114287  96%    0.55K   4233       28     67728K radix_tree_node
>  88768  88711  99%    0.12K   2774       32     11096K kmalloc-128
>  28713  28713 100%    0.08K    563       51      2252K sysfs_dir_cache
>  22974  22973  99%    0.09K    547       42      2188K kmalloc-96
>   9776   9776 100%    0.25K    611       16      2444K kmalloc-256
>   7791   7791 100%    0.19K    371       21      1484K kmalloc-192
>   7168   7097  99%    0.01K     14      512        56K kmalloc-8
> 
> machine is not responsible anymore, xfs ate all ram
> 
> If I don't use usr/grp quota then filesystem mounts without a problem.
> 
> What are my options now? I need this system running again with quota but 
> loosing all quota information is not a problem (I can set it again).

I can reproduce it. There's some difference between the way
userspace operates with bulkstat vs the way the kernel quotacheck
operates with it.

Essentially the problem appears to be related to the inodes not
being reclaimed and the kernel declaring OOM with about 50 pages in
the page cache but still having millions of reclaimable inodes.
Whether it is a result of the kernel not attempting to reclaim them
or something else, I don't know yet.

However, there's definitely something fishy going on because
quotacheck inodes aren't showing up as VFS inodes even though
they probably should because they are fully instantiated. I'll look
at it further tomorrow.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
