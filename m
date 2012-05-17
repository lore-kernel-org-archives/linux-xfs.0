Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4H7H5tB125840 for <xfs@oss.sgi.com>; Thu, 17 May 2012 02:17:10 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	1UWVf0qYSxFw9Rrl for <xfs@oss.sgi.com>;
	Thu, 17 May 2012 00:17:02 -0700 (PDT)
Date: Thu, 17 May 2012 17:16:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: use s_umount sema in xfs_sync_worker
Message-ID: <20120517071658.GP25351@dastard>
References: <20120323174327.GU7762@sgi.com> <20120514203449.GE16099@sgi.com>
	<20120516015626.GN25351@dastard> <20120516170402.GD3963@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120516170402.GD3963@sgi.com>
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

On Wed, May 16, 2012 at 12:04:03PM -0500, Ben Myers wrote:
> On Wed, May 16, 2012 at 11:56:26AM +1000, Dave Chinner wrote:
> > On Mon, May 14, 2012 at 03:34:49PM -0500, Ben Myers wrote:
> > > I'm still hitting this on a regular basis.  Here is some analysis from a recent
> > > crash dump which you may want to skip.  The fix is at the end.
> > ....
> > > ===================================================================
> > > 
> > > xfs: use s_umount sema in xfs_sync_worker
> > > 
> > > xfs_sync_worker checks the MS_ACTIVE flag in sb->s_flags to avoid doing work
> > > during mount and unmount.  This flag can be cleared by unmount after the
> > > xfs_sync_worker checks it but before the work is completed.
> > 
> > Then there are problems all over the place in different filesystems
> > if the straight MS_ACTIVE check is not sufficient.
> 
> Eh, I won't speak to the problems in other filesystems.  ;)
> 
> MS_ACTIVE certainly isn't adequate in the case before us.

Only because the XFS code isn't internally safe...

> > > Protect xfs_sync_worker by using the s_umount semaphore at the read level to
> > > provide exclusion with unmount while work is progressing.
> > 
> > I don't think that is the right fix for the given problem.
> > 
> > The problem is, as you've stated:
> > 
> > "Looks like the problem is that the sync worker is still running
> > after the log has been torn down, and it calls xfs_fs_log_dummy
> > which generates log traffic."
> 
> That's one problem, but we also want to protect against running this code at
> mount time.  s_umount sema is the tool that can do both.  Maybe there are some
> other options.

The mount case isn't a problem - MS_ACTIVE is only set once the
mount process is complete and so the check is just fine for that
case.

> > Why did we allow a new transaction to start while/after the log was
> > torn down?
> 
> > Isn't that the problem we need to fix because it leads to
> > invalid entries in the physical log that might cause recovery
> > failures?
> 
> > Further, any asynchronous worker thread that does
> > transactions could have this same problem regardless of whether we
> > are umounting or cleaning up after a failed mount, so it is not
> > unique to the xfs_sync_worker....
> 
> > That is, if we've already started to tear down or torn down the log,
> > we must not allow new transactions to start. Likewise, we can't
> > finalise tear down the log until transactions in progress have
> > completed. Using the s_umount lock here avoids then race, but it
> > really is a VFS level lock not an filesystem level lock) and is,
> > IMO, just papering over the real problem....
> 
> I think you have a good point here, but this isn't limited to transactions.

I'm pretty sure that the other async threads/wqs are safe w.r.t.
startup and shutdown. Indeed, some of them have to run while
mount/unmount are running so must have their own startup/shutdown
synchronisation. Hence we need to treat each different async work on
a case by case basis...

> We shouldn't even call xfs_log_need_covered without some
> protection from xfs_fs_put_super; xfs_fs_writable doesn't cut the
> mustard.

Sure, but that check is for a different purpose so it's no surprise
at all that it doesn't help this case.

AFAICT, we simply don't care if xfs_fs_put_super() has been called -
what matters is the state of the log at the time
xfs_log_need_covered() is called.  i.e. xfs_log_need_covered()
should error out if the log is being recovered or being torn down.
Same for xfs_log_force(), xfs_log_reserve(), etc. Right now we don't
even check if we can do the operation safely or not.

Right now we assume that new transactions or log operations cannot
occur (i.e they are stopped) before we tear down the log.  That
means we either need to prevent transactions from starting once we
start tearing down the log, or we need to stop the xfs_sync_worker
before we tear down the log. The second is how we currently avoid
this problem, so adding a cancel_delayed_work_sync(&mp->m_sync_work)
to xfs_log_unmount() would probably solve the problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
