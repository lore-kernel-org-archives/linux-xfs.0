Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BL6Dpx239088 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 16:06:13 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0G8zCXLXotGDgSws for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 14:07:45 -0700 (PDT)
Date: Fri, 12 Oct 2012 08:07:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: File system corruption
Message-ID: <20121011210741.GC2739@dastard>
References: <5077077A.3040608@crossroads.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5077077A.3040608@crossroads.com>
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
To: Wayne Walker <wwalker@crossroads.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 11, 2012 at 12:52:58PM -0500, Wayne Walker wrote:
> In short, I am able to:  mkfs...; mount...; cp 1gbfile...; sync; cp
> 1gbfile...; sync  # and now the xfs is corrupt
> 
> I see multiple bugs
> 
> 1. very simple, non-corner-case actions create a corrupted file system
> 2. corrupt data is knowingly written to the file system.
> 3. the file system stays online and writable
> 4. future write operations to the file system return success.
> 
> Details:
.....

Nothing unusual there in the hardware. Seems sane to me.

> The exact commands to create the failure:
> 
> /sbin/mkfs.xfs -f -l logdev=/dev/sda5 -b size=4096 -d su=1024k,sw=4
> /dev/sde1
> cat /etc/fstab
> mount -t xfs -o defaults,noatime,logdev=/dev/sda5 /dev/sde1 /dtfs_data/data1
> cp random_data.1G /dtfs_data/data1
> # returns 0
> sync
> # file system reported no failure yet
> cp random_data.1G /dtfs_data/data1
> # returns 0
> sync
> # file system reports stack trace, bad agf, and page discard

Ok, so having looked at the stack trace, the AGF block taht was read
contained zeros, not valid metadata, which is why the allocation
failed.

Can you remake the filesystem at will? If so, can you run mkfs.xfs
as per above, then run the following command?

# echo 3 > /proc/sys/vm/drop_caches
# for i in `seq 0 4`; do
> xfs_db -l /dev/sda5 -c "sb $i" -c p -c "agf $i" -c p /dev/sde1
> done

So that we can see what mkfs put on disk? Can you then mount the
filesystem, unmount it again, and run the same commands? Then mount
the filesystem, run the copy/sync to trigger the error, then unmount
and run the commands again?

What I'm interested in if whether xfs_db sees the AGF (which ever
one it is) as zero, or whether only the kernel is seeing that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
