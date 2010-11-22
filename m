Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAMNgkSs126742 for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 17:42:47 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C81A31C67C93
	for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 15:44:22 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	FmeWn9NjcgK8OZlJ for <xfs@oss.sgi.com>;
	Mon, 22 Nov 2010 15:44:22 -0800 (PST)
Date: Tue, 23 Nov 2010 10:44:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Improving XFS file system inode performance
Message-ID: <20101122234419.GK13830@dastard>
References: <4CEAE7D7.6050401@ssec.wisc.edu>
	<20101122232528.21b78a9e@galadriel.home>
	<4CEAEF66.7030708@ssec.wisc.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CEAEF66.7030708@ssec.wisc.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jesse Stroik <jstroik@ssec.wisc.edu>
Cc: Linux XFS <xfs@oss.sgi.com>

On Mon, Nov 22, 2010 at 04:32:06PM -0600, Jesse Stroik wrote:
> On 11/22/2010 04:25 PM, Emmanuel Florac wrote:
> >Le Mon, 22 Nov 2010 15:59:51 -0600 vous =E9criviez:
> >
> >>Performance was fine before the file system was filled -- last week
> >>~8TB showed up and filled the 20TB file system.  Since, it has been
> >>performing poorly.
> >
> >Maybe it got fragmented? How does fragmentation look like?
> =

> =

> I wasn't able to resolve this in reasonable time.  Part of the issue
> is that we're dealing with files within about 100k directories.
> I'll attempt to get the fragmentation numbers overnight.
> =

> I suspect the regularly listed set of files on this fs exceeds the
> inode cache.  Where can I determine the cache misses and tune the
> file system?

Yup, that would be my guess, too.

You can use slabtop to find out how many inodes are cached and the
memory they use, and /proc/meminfo to determine the amount of memory
used by the page cache.

For cache hits and misses, there's a statistics file in
/proc/fs/xfs/stats that contains inode cache hits and misses
amongst other things. Those stats are somewhat documented here:

http://xfs.org/index.php/Runtime_Stats

and you want to look at the inode operation stats. This script:

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsmisc/xfs_stats.pl?rev=3D1=
.7;content-type=3Dtext%2Fplain

makes it easy to view them, even though it doesn't handle many of
the more recent additions.

As to tuning the size of the cache - it's pretty much a crap-shoot.
Firstly, you've got to have enough memory - XFS needs approximately
1-1.5GB RAM per million cached inodes (double that if you've got
lock debugging turned on).

The amount of RAM then used by the inode cache is then dependent on
memory pressure.  There's one knob that sometimes makes a difference
- it changes the balance between page cache vs inode cache
reclaimation: /proc/sys/vm/vfs_cache_pressure. From
Documentation/sysctl/vm.txt:

	At the default value of vfs_cache_pressure=3D100 the kernel
	will attempt to reclaim dentries and inodes at a "fair" rate
	with respect to pagecache and swapcache reclaim.  Decreasing
	vfs_cache_pressure causes the kernel to prefer to retain
	dentry and inode caches. When vfs_cache_pressure=3D0, the
	kernel will never reclaim dentries and inodes due to memory
	pressure and this can easily lead to out-of-memory
	conditions. Increasing vfs_cache_pressure beyond 100 causes
	the kernel to prefer to reclaim dentries and inodes.

So you want to decrease vfs_cache_pressure to try to preserve the
inode cache rather than the page cache.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
