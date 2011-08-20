Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7K0R3SN052482 for <xfs@oss.sgi.com>; Fri, 19 Aug 2011 19:27:03 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 284A7F7A1C
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2011 17:27:01 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RVQBmMeHbmDl7tfn for <xfs@oss.sgi.com>;
	Fri, 19 Aug 2011 17:27:01 -0700 (PDT)
Date: Sat, 20 Aug 2011 10:26:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: bug: xfs_repair becomes very slow when file system has a large
	sparse file
Message-ID: <20110820002657.GF32358@dastard>
References: <4E4E9131.2050807@scalableinformatics.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E4E9131.2050807@scalableinformatics.com>
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
To: Joe Landman <landman@scalableinformatics.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 19, 2011 at 12:37:05PM -0400, Joe Landman wrote:
> (If you prefer we file this on a bug reporting system, please let me
> know where and I'll do this).
> 
> Scenario:  xfs_repair being run against an about 17TB volume,
> containing 1 large sparse file.  Logical size of 7 PB, actual size,
> a few hundred GB.
> 
> Metadata:  Kernel = 2.6.32.41, 2.6.39.4, and others. Xfstools 3.1.5.
> Hardware RAID ~17TB LUN.  Base OS: Centos 5.6 + updates + updated
> xfs tools + our kernels.  Using external journal on a different
> device
> 
> What we observe:
> 
> Running xfs_repair
> 
> 	xfs_repair -l /dev/md2 -vv /dev/sdd2

can you post the actual output of xfs_repair?

> 
> the system gets to stage 3 and the first ag.  Then it appears to
> stop. After an hour or so, we strace it, and we see
>
> 	pread(...) = 4096

and the same for the strace, along with syscall completion time?
(i.e. strace -ttt -T .....) That will tell us if the time is spend
doing IO or in the repair binary.

What is the CPU usage when this happens? How much memory do you
have? Is the machine swapping while it is slowing down? A couple of
minutes output of 'vmstat 5' when it is in this state would be handy.

> occurring about 2-3 per second.  An hour later, its down to 1 per
> second.   An hour after that, its once every 2 seconds.
> 
> Also, somewhere on this disk, someone has created an unfortunately
> large file
> 
> [root@jr4-2 ~]# ls -alF /data/brick-sdd2/dht/scratch/xyzpdq
> total 4652823496
> d---------   2 1232 1000               86 Jun 27 20:31 ./
> drwx------ 104 1232 1000            65536 Aug 17 23:53 ../
> -rw-------   1 1232 1000               21 Jun 27 09:57 Default.Route
> -rw-------   1 1232 1000              250 Jun 27 09:57 Gau-00000.inp
> -rw-------   1 1232 1000                0 Jun 27 09:57 Gau-00000.d2e
> -rw-------   1 1232 1000 7800416534233088 Jun 27 20:18 Gau-00000.rwf
> 
> [root@jr4-2 ~]# ls -ahlF /data/brick-sdd2/dht/scratch/xyzpdq
> total 4.4T
> d---------   2 1232 1000   86 Jun 27 20:31 ./
> drwx------ 104 1232 1000  64K Aug 17 23:53 ../
> -rw-------   1 1232 1000   21 Jun 27 09:57 Default.Route
> -rw-------   1 1232 1000  250 Jun 27 09:57 Gau-00000.inp
> -rw-------   1 1232 1000    0 Jun 27 09:57 Gau-00000.d2e
> -rw-------   1 1232 1000 7.0P Jun 27 20:18 Gau-00000.rwf
> 
> This isn't a 7PB file system, its a 100TB file system across 3
> machines, roughly 17TB per brick or OSS.  The Gau-00000.rwf is
> obviously a sparse file, as could be seen with an ls -alsF

What does du tell you about it?  xfs_io -f -c "stat" <large file>?
xfs_bmap -vp <large file>?

> Upon removing that file, the xfs_repair completes within ~10
> minutes. Leaving that file on there, the xfs_repair does not
> terminate, it just gets asymptotically slower.

That could simply be the memory footprint causing more swapping per
operation to occur. Or it could be that something is simply getting
too large for the index type being used. If the machine is not
swapping, can you point 'perf top -p <pid of xfs_repair>' at it so
we might see where that CPU time is being spent?  (you might need to
use a non-stripped version of the binary to get any useful
information)

> Please let me know if you need more information, or if you would
> like me to file this somewhere else for official reportage.

This is the right place to let us know about problems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
