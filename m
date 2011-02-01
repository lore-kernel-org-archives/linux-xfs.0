Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1181fmM167078 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 02:01:41 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2F06154EC4A
	for <xfs@oss.sgi.com>; Tue,  1 Feb 2011 00:04:07 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	bWaA5Yy1oQCJjG2W for <xfs@oss.sgi.com>;
	Tue, 01 Feb 2011 00:04:07 -0800 (PST)
Date: Tue, 1 Feb 2011 19:03:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Preallocation
Message-ID: <20110201080354.GM11040@dastard>
References: <155CAEA5D902E7429569DD197567724A01534D42@mail1.ad.kinetx.com>
	<20110128045205.GR21311@dastard>
	<155CAEA5D902E7429569DD197567724A01534D60@mail1.ad.kinetx.com>
	<20110129001700.GZ21311@dastard>
	<3F5ACD12257C714E9C0535D0A839171802A9B4@SC-MBX02-2.TheFacebook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3F5ACD12257C714E9C0535D0A839171802A9B4@SC-MBX02-2.TheFacebook.com>
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
To: Peter Vajgel <pv@fb.com>
Cc: Jef Fox <jef.fox@kinetx.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Feb 01, 2011 at 04:45:09AM +0000, Peter Vajgel wrote:
> > Preallocation is the only option. Allowing preallocation without
> > marking extents as unwritten opens a massive security hole (i.e.
> > exposes stale data) so I say no to any request for addition of
> > such functionality (and have for years).
> 
> How about opening this option to at least root (root can already
> read the device anyway)?.

# ls -l foo
-rw-r--r-- 1 dave dave        0 Aug 16 10:44 foo
#
# prealloc_without_unwritten 0 1048576 foo
# ls -l foo
-rw-r--r-- 1 dave dave  1048576 Aug 16 10:44 foo
#

Now user dave can read the stale data exposed by the root only
operation. Any combination of making the file available to a
non-root user after a preallocation-without-unwritten-extents
operation has this problem.  IOWs, just making such a syscall "root
only" doesn't solve the security problem.

To fix it, we have to require inodes have 0600 perms, owned by root,
and cannot be chmod/chowned to anyone else, ever. At that point,
we're requiring applications to run as root to to use this
functionality. Same requirement as fiemap + reading from the block
device, which you can do right without any kernel mods or filesystem
hacks...

> There are cases when creating large
> files without writing to them is important. A good example is
> testing xfs overhead when doing a specific workload (like random
> reads) to large files.

For testing it doesn't matter how long it takes you to write
the file in the first place.

> In this case we want to hit the disk on
> every request. Currently we have a workaround (below) but official
> support would be preferable.

Officially, we _removed_ the unwritten=0 option from mkfs because of
the security problems. Not to mention that it was never, ever
tested...

> 
> --pv
> 
> 
> # create_xfs_files
> 
> dev=$1
> mntpt=$2
> dircount=$3
> filecount=$4
> size=$5
> 
> # Umount.
> umount $2
> 
> # Create the fs.
> mkfs -t xfs -f -d unwritten=0,su=256k,sw=10 -l su=256k -L "/hay" $dev

Which fails due to:

unknown option -d unwritten=0
/* blocksize */         [-b log=n|size=num]
/* data subvol */       [-d agcount=n,agsize=n,file,name=xxx,size=num,
                            (sunit=value,swidth=value|su=num,sw=num),
                            sectlog=n|sectsize=num
.....

> # Clear unwritten flag - current xfs ignores this flag
> typeset -i agcount=$(xfs_db -c "sb" -c "print" $dev | grep agcount)
> typeset -i i=0
> while [[ $i != $agcount ]]
> do
>   xfs_db -x -c "sb $i" -c "write versionnum 0xa4a4" $dev
>   i=i+1
> done
> 
> # Mount the filesystem.
> mount -t xfs -o nobarrier,noatime,nodiratime,inode64,allocsize=1g $dev $mntpt
> 
> i=0
> while [[ $i != $dircount ]]
> do
>   mkdir $mntpt/dir$i
>   typeset -i j=0
>   while [[ $j != $filecount ]]
>   do
>     file=$mntpt/dir$i/file$j
>     xfs_io -f -c "resvsp 0 $size" $file
>     inum=$(ls -i $file | awk '{print $1}')
>     umount $mntpt
>     xfs_db -x -c "inode $inum" -c "write core.size $size" $dev
>     mount -t xfs -o nobarrier,noatime,nodiratime,inode64,allocsize=1g $dev $mntpt

That's quite a hack to work around the EOF zeroing that extending the
file size after allocating would do because the preallocated extents
beyond EOF are not marked unwritten. Perhaps truncating the file
first, then preallocating is what you want:

	xfs_io -f -c "truncate $size" -c "resvsp 0 $size" $file

>     j=j+1
>   done
>   i=i+1
> done

Regardless of all this, perhaps themost important point is that your
proposed use of XFS is fundamentally unsupportable by the linux XFS
community: you've got proprietary software on some external hardware
writing to the disk without going through the linux XFS kernel code.
You're basically in the same boat as people running proprietary
kernel modules - unless you can prove the problem is not caused by
your hw/sw or manual filesystem modifications, then it's a waste of
our (limited) resources to even look at the problem.  That generally
comes down to being able to reproduce the problem on a vanilla kernel
on a filesystem created with a supported mkfs....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
