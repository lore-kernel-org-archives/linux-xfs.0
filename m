Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4G2lbS0244748 for <xfs@oss.sgi.com>; Tue, 15 May 2012 21:47:42 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Yp4ipCcvdCEjXn9W for <xfs@oss.sgi.com>;
	Tue, 15 May 2012 19:47:32 -0700 (PDT)
Date: Wed, 16 May 2012 11:56:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: use s_umount sema in xfs_sync_worker
Message-ID: <20120516015626.GN25351@dastard>
References: <20120323174327.GU7762@sgi.com>
 <20120514203449.GE16099@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120514203449.GE16099@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, May 14, 2012 at 03:34:49PM -0500, Ben Myers wrote:
> I'm still hitting this on a regular basis.  Here is some analysis from a recent
> crash dump which you may want to skip.  The fix is at the end.
....
> ===================================================================
> 
> xfs: use s_umount sema in xfs_sync_worker
> 
> xfs_sync_worker checks the MS_ACTIVE flag in sb->s_flags to avoid doing work
> during mount and unmount.  This flag can be cleared by unmount after the
> xfs_sync_worker checks it but before the work is completed.

Then there are problems all over the place in different filesystems
if the straight MS_ACTIVE check is not sufficient.

> Protect xfs_sync_worker by using the s_umount semaphore at the read level to
> provide exclusion with unmount while work is progressing.

I don't think that is the right fix for the given problem.

The problem is, as you've stated:

"Looks like the problem is that the sync worker is still running
after the log has been torn down, and it calls xfs_fs_log_dummy
which generates log traffic."

Why did we allow a new transaction to start while/after the log was
torn down? Isn't that the problem we need to fix because it leads to
invalid entries in the physical log that might cause recovery
failures? Further, any asynchronous worker thread that does
transactions could have this same problem regardless of whether we
are umounting or cleaning up after a failed mount, so it is not
unique to the xfs_sync_worker....

That is, if we've already started to tear down or torn down the log,
we must not allow new transactions to start. Likewise, we can't
finalise tear down the log until transactions in progress have
completed. Using the s_umount lock here avoids then race, but it
really is a VFS level lock not an filesystem level lock) and is,
IMO, just papering over the real problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
