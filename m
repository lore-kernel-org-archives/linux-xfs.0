Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 595207F61
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 01:16:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4294C304039
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 23:16:35 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rIbCBgjnWRmoBsJs for <xfs@oss.sgi.com>;
	Thu, 14 Feb 2013 23:16:33 -0800 (PST)
Date: Fri, 15 Feb 2013 18:16:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS slow when project quota exceeded (again)
Message-ID: <20130215071607.GT26694@dastard>
References: <20130214131452.GB605@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130214131452.GB605@quack.suse.cz>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: dchinner@redhat.com, xfs@oss.sgi.com

On Thu, Feb 14, 2013 at 02:14:52PM +0100, Jan Kara wrote:
>   Hi,
> 
>   this is a follow up on a discussion started here:
> http://www.spinics.net/lists/xfs/msg14999.html
> 
> To just quickly sum up the issue: 
> When project quota gets exceeded XFS ends up flushing inodes using
> sync_inodes_sb(). I've tested (in 3.8-rc4) that if one writes 200 MB to a
> directory with 100 MB project quota like:
> 	fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
> 	for (i = 0; i < 50000; i++)
> 		pwrite(fd, buf, 4096, i*4096);
> it takes about 3 s to finish, which is OK. But when there are lots of
> inodes cached (I've tried with 10000 inodes cached on the fs), the same
> test program runs ~140 s.

So, you're testing the overhead of ~25,000 ENOSPC flushes. I could
brush this off and say "stupid application" but I won't....

> This is because sync_inodes_sb() iterates over
> all inodes in superblock and waits for IO and this iteration eats CPU
> cycles.

Yup, exactly what I said here:

http://www.spinics.net/lists/xfs/msg15198.html

Iterating inodes takes a lot of CPU.

I think the difference in the old method and the current one is that
we only do one inode cache iteration per write(), not one per
get_blocks() call. Hence we've removed the per-page overhead of
flushing, and now we just have the inode cache iteration overhead.

The fix to that problem is mentioned here:

http://www.spinics.net/lists/xfs/msg15186.html

Which is to:

	a) throttle speculative allocation as EDQUOT approaches; and
	b) efficiently track speculative preallocation
	   for all the inodes in the given project, and write back
	   and trim those inodes on ENOSPC.

both of those are still a work in progress. I was hoping that we'd
have a) in 3.9, but that doesn't seem likely now the merge window is
just about upon us....

Essnetially, the fix for your problem is b). it will turn a
whole superblock inode iteration into a "inodes with specualtive
preallocation iteration" that is project quota aware. it will have
lower per-flush overhead than a superblock scan, but it will still
have measurable overhead.

> One can argue that sync_inodes_sb() should be optimized but it isn't that
> easy because it is a data integrity operation and we have to be sure that
> even IO which has been submitted before sync_inodes_sb() is called is
> finished by the time it returns.

Right, but the IO wait is exactly why I chose it....

> So another POV is that it is an overkill to call data integrity operation
> in a place which just needs to make sure IO is submitted so that delalloc
> uncertainty is reduced.

... and not because of anything to do with how we handle delalloc
metadata reservations.

> The comment before xfs_flush_inodes() says that
> sync_inodes_sb() is used to throttle multiple callers to the rate at which
> IO is completing. I wonder - why is that needed?

It's trying to prevent the filesystem for falling into worst case IO
patterns at ENOSPC when there are hundreds of threads banging on the
filesystem and essentially locking up the system. i.e. we have to
throttle the IO submission rate from ENOSPC flushing artificially -
we really only need one thread doing the submission work, so we need
to throttle all concurrent callers while we are doing that work.
sync_inodes_sb() does that. And then we need to prevent individual
callers from trying to allocate space too frequently, which we do by
waiting for IO that was submitted in the flush. sync_inodes_sb()
does that, too.

> Delalloc blocks are
> allocated already at IO submission time so it should be enough to wait for
> IO submission to happen? And writeback_inodes_sb() does that. Changelog of
> the commit changing xfs_flush_inodes() to use sync_inodes_sb() claims that
> if writeback_inodes_sb() is used, premature ENOSPC can happen. But I wonder
> why is that the case when writeback_inodes_sb() waits for IO submission to
> happen and thus for extent conversion? Isn't sync_inodes_sb() just papering
> over some other problem?

It was never intended to create or solve EDQUOT issues related to
project quota.  What you are seeing is an unfortunate side effect of
fixing other, more serious architectural problems. We know it's a
problem and we have a fix in the works. Just be patient....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
