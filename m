Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p236AJ2h072359
	for <linux-xfs@oss.sgi.com>; Thu, 3 Mar 2011 00:10:20 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1705E1DDE355
	for <linux-xfs@oss.sgi.com>; Wed,  2 Mar 2011 22:13:07 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	MaCydzOzhXFnnjpg for <linux-xfs@oss.sgi.com>;
	Wed, 02 Mar 2011 22:13:07 -0800 (PST)
Date: Thu, 3 Mar 2011 17:13:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs 14TB - check
Message-ID: <20110303061305.GK15097@dastard>
References: <31051172.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <31051172.post@talk.nabble.com>
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
To: tramper <michael.weingartner@tuwien.ac.at>
Cc: linux-xfs@oss.sgi.com

On Wed, Mar 02, 2011 at 08:57:40AM -0800, tramper wrote:
> 
> Hallo Forum,
> 
> i formated a storage with 16 disks (Raid5  and sparedrive) with xfs. The
> volume is 14TB big. There where circuit Problems and we had several server
> shutdowns and Problems.
> The Server is a ubuntu 8.04 32bit.
                              ^^^^^ There's your problem.

> 
> Now I want to check my xfs Partition.
> 
> i used xfs_repair /dev/cciss/c0...p1 and got the following error message:
> 
> fatal error -- couldn't allocate block map, size XXXXXXX
> 
> I have 2 GB of Ram in the machine.

Even if you put more in it, the 32-bit address space limit will be
the limiting factor.

> What should I do and how to check my volume?

You almost certainly need a 64-bit machine. Even with the latest
xfs_repair, you need about 2GB of RAM for the free space checking on
a 14TB filesystem.

Try running:

# xfs_repair -m 1 -vv <device>

And it will tell you how much memory you need to repair the
filesystem. Note that this is only a rough estimate - it may be
quite a bit more than the amount specified depending on the state
and contents of the filesystem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
