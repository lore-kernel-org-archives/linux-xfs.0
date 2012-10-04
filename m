Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q94NaV7n238500 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 18:36:31 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wrahEAIt05FSznqH for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 16:37:56 -0700 (PDT)
Date: Fri, 5 Oct 2012 09:37:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: how to replay log of a fs that has no log: is this supposed to
	work? SW Defect?
Message-ID: <20121004233754.GC23644@dastard>
References: <506DAF66.2030507@tlinx.org>
 <506DB419.2030902@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <506DB419.2030902@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 04, 2012 at 09:06:49AM -0700, Linda Walsh wrote:
> 
> 
> Linda Walsh wrote:
> (blah blah blah)...
> 
> or more specifically:
> 
> xfs_freeze -f /home/.snapdir/\@GMT-2012.10.04-03.06.17
> Ishtar:/# xfs_ncheck /dev/Home+Space/Home-2012.10.04-03.06.17
> 
>    ERROR: The filesystem has valuable metadata changes in a log which needs to
>    be replayed.  Mount the filesystem to replay the log, and unmount it before
>    re-running xfs_ncheck.  If you are unable to mount the filesystem, then use
>    the xfs_repair -L option to destroy the log and attempt a repair.
>    Note that destroying the log may cause corruption -- please attempt a mount
>    of the filesystem before doing this.
>    must run blockget -n first
> 
> ok -- lets mount/umount it:
> Ishtar:/# mount -o ro,nouuid
> /dev/Home+Space/Home-2012.10.04-03.06.17
> /home/.snapdir/@GMT-2012.10.04-03.06.17

So, a read only snapshot? If so what makes you think that recovery
can run and modify the filesystem/log?

THe whole point of freeze creating a consistent disk image is so you
can mount it without needing recovery to run. i.e:

# mount -o ro,nouuid,norecovery ....

> ---
> Um... looking at the above it would appear that I froze a fs.
> ncheck claimed the freeze didn't result in the logfile being written being put
> into a consistent state, but said to remount the fs to allow it to play then
> umount...
> 
> So... did that.
> Log file is still in a corrupt state.

The log is not corrupt, just dirty.

> Am I wrong in assuming that doing xfs_repair -L to destroy the log on this
> dev, might be a bad thing to do and might screw up it's "Origin" file
> system (i.e. the current 'live' /home partition)?

It will try to write to the snapshot. If it is a read-only
snapshot...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
