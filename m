Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1206Ys5253166 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 18:06:34 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 139721A63CC9
	for <xfs@oss.sgi.com>; Tue,  1 Feb 2011 16:09:00 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0PWr7HFk9kszH5aK for <xfs@oss.sgi.com>;
	Tue, 01 Feb 2011 16:09:00 -0800 (PST)
Date: Wed, 2 Feb 2011 11:07:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Preallocation
Message-ID: <20110202000700.GO11040@dastard>
References: <155CAEA5D902E7429569DD197567724A01534D42@mail1.ad.kinetx.com>
	<20110128045205.GR21311@dastard>
	<155CAEA5D902E7429569DD197567724A01534D60@mail1.ad.kinetx.com>
	<20110129001700.GZ21311@dastard>
	<3F5ACD12257C714E9C0535D0A839171802A9B4@SC-MBX02-2.TheFacebook.com>
	<20110201080354.GM11040@dastard>
	<3F5ACD12257C714E9C0535D0A839171802AB01@SC-MBX02-2.TheFacebook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3F5ACD12257C714E9C0535D0A839171802AB01@SC-MBX02-2.TheFacebook.com>
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

On Tue, Feb 01, 2011 at 07:20:18PM +0000, Peter Vajgel wrote:
> 
> > -----Original Message-----
> > From: Dave Chinner [mailto:david@fromorbit.com]
> > Sent: Tuesday, February 01, 2011 12:04 AM
> > To: Peter Vajgel
> > Cc: Jef Fox; xfs@oss.sgi.com
> > Subject: Re: XFS Preallocation
> > 
> > On Tue, Feb 01, 2011 at 04:45:09AM +0000, Peter Vajgel wrote:
> > > > Preallocation is the only option. Allowing preallocation without
> > > > marking extents as unwritten opens a massive security hole (i.e.
> > > > exposes stale data) so I say no to any request for addition of such
> > > > functionality (and have for years).
> > >
> > > How about opening this option to at least root (root can already read
> > > the device anyway)?.
> > 
> > # ls -l foo
> > -rw-r--r-- 1 dave dave        0 Aug 16 10:44 foo
> > # prealloc_without_unwritten 0 1048576 foo
> > # ls -l foo
> > -rw-r--r-- 1 dave dave  1048576 Aug 16 10:44 foo
> > #
> > 
> > Now user dave can read the stale data exposed by the root only operation. Any
> > combination of making the file available to a non-root user after a preallocation-
> > without-unwritten-extents
> > operation has this problem.  IOWs, just making such a syscall "root only" doesn't
> > solve the security problem.

> Correct - if an admin made prealloc_without_unwritten runnable by
> any user then yes - but I would argue that such an admin should
> not even have root privileges.

Not exactly what I was trying to demonstrate -
the above example uses the convention f "#" as indicating a root
shell (like "$" indicates a user shell). IOWs, it is root
preallocating on a file that is already owned and readable by
another user.

As it is, I think this is a likely use case, because not many people
are going to want to run their applications that would use such
functionality (e.g. database servers) as root. My main point is,
though, that if you can do it, people will do it whether they
understand the ramifications or not.

> Vxfs had this ability since version
> 1 and I don't' remember a single customer complaint about this
> feature.

And XFS used to do it, too. Unwritten extents were only implemented
in XFS (in 1997) once customers complained about the security
problems involved with preallocation without zeroing....

Further, with the rise of ricer filesystem tuning blogs, an emerging
meme was that you should turn off unwritten extents to make your
bonnie++ benchmark run go faster (without even understanding that
bonnie++ doesn't use preallocation). Search engines then started
throwing these up as good infoxpmration. 

Worse is the fact that they still do.  e.g. the first hit on google
for "XFS performance tweaking" makes this suggestion - it's a blog
entry from 2003 and google still considers it the most relevant hit,
even though it is full of misleading and plain wrong information.
IOWs, we're dealing with mis-information as much as a security
problem here...

> Most of the times the feature was used by db to
> preallocate large amounts of space knowing that they won't incur
> any overhead (even transactional) when doing direct io to the
> pre-allocated range. It could be that at those times even a
> transactional overhead was significant enough that we wanted to
> eliminate it.

You're talking historically about on VXFS, right?

BTW, have you recently measured the overhead of unwritten extent
conversion on XFS recently? Is it actually a performance problem for
you in production?

> > To fix it, we have to require inodes have 0600 perms, owned by root, and cannot be
> > chmod/chowned to anyone else, ever. At that point, we're requiring applications to run
> > as root to to use this functionality. Same requirement as fiemap + reading from the
> > block device, which you can do right without any kernel mods or filesystem hacks...
> > 
> > > There are cases when creating large
> > > files without writing to them is important. A good example is testing
> > > xfs overhead when doing a specific workload (like random
> > > reads) to large files.
> > 
> > For testing it doesn't matter how long it takes you to write the
> > file in the first place.
> 
> At the scale we operate it does. We have multiple variables so the
> number of combinations is large. We have hit every single possible
> hardware and software problem and problem resolution can take
> months if it takes days to reproduce the problem. Hardware vendors
> (disk, controller, motherboard manufacturers) are much more
> responsive when you can reproduce a problem on the fly in seconds
> (especially in comparative benchmarking). The tests usually run
> only couple of minutes. With 12x3TB (possibly multiplied by a
> factor of X with our new platform) it would be unacceptable to
> wait for writes to finish.

It's still a test environment, and I think you'd agree that you can
do things in test environments that you'd never, ever do in a
production setting.

> > >   while [[ $j != $filecount ]]
> > >   do
> > >     file=$mntpt/dir$i/file$j
> > >     xfs_io -f -c "resvsp 0 $size" $file
> > >     inum=$(ls -i $file | awk '{print $1}')
> > >     umount $mntpt
> > >     xfs_db -x -c "inode $inum" -c "write core.size $size" $dev
> > >     mount -t xfs -o nobarrier,noatime,nodiratime,inode64,allocsize=1g
> > > $dev $mntpt
> > 
> > That's quite a hack to work around the EOF zeroing that extending the file size after
> > allocating would do because the preallocated extents beyond EOF are not marked
> > unwritten. Perhaps truncating the file first, then preallocating is what you want:
> > 
> > 	xfs_io -f -c "truncate $size" -c "resvsp 0 $size" $file
> 
> 
> I think I had it in reverse before - allocate and truncate but the
> truncate got stuck in a loop (probably zeroing out the extents?)

*nod*

> making the node unresponsive to the point that it was impossible
> to ssh to it. It eventually returned but it took a while. But that
> was like 3 years ago. If I get to it I'll try the other order.

Yes, that would probably be how a 3yo kernel would react to such
a buffered IO writeback storm....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
