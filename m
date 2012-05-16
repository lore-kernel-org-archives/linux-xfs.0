Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4GGxXvW029779 for <xfs@oss.sgi.com>; Wed, 16 May 2012 11:59:33 -0500
Date: Wed, 16 May 2012 12:04:03 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: use s_umount sema in xfs_sync_worker
Message-ID: <20120516170402.GD3963@sgi.com>
References: <20120323174327.GU7762@sgi.com> <20120514203449.GE16099@sgi.com>
	<20120516015626.GN25351@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120516015626.GN25351@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hey Dave,

On Wed, May 16, 2012 at 11:56:26AM +1000, Dave Chinner wrote:
> On Mon, May 14, 2012 at 03:34:49PM -0500, Ben Myers wrote:
> > I'm still hitting this on a regular basis.  Here is some analysis from a recent
> > crash dump which you may want to skip.  The fix is at the end.
> ....
> > ===================================================================
> > 
> > xfs: use s_umount sema in xfs_sync_worker
> > 
> > xfs_sync_worker checks the MS_ACTIVE flag in sb->s_flags to avoid doing work
> > during mount and unmount.  This flag can be cleared by unmount after the
> > xfs_sync_worker checks it but before the work is completed.
> 
> Then there are problems all over the place in different filesystems
> if the straight MS_ACTIVE check is not sufficient.

Eh, I won't speak to the problems in other filesystems.  ;)

MS_ACTIVE certainly isn't adequate in the case before us.

> > Protect xfs_sync_worker by using the s_umount semaphore at the read level to
> > provide exclusion with unmount while work is progressing.
> 
> I don't think that is the right fix for the given problem.
> 
> The problem is, as you've stated:
> 
> "Looks like the problem is that the sync worker is still running
> after the log has been torn down, and it calls xfs_fs_log_dummy
> which generates log traffic."

That's one problem, but we also want to protect against running this code at
mount time.  s_umount sema is the tool that can do both.  Maybe there are some
other options.

> Why did we allow a new transaction to start while/after the log was
> torn down?

> Isn't that the problem we need to fix because it leads to
> invalid entries in the physical log that might cause recovery
> failures?

> Further, any asynchronous worker thread that does
> transactions could have this same problem regardless of whether we
> are umounting or cleaning up after a failed mount, so it is not
> unique to the xfs_sync_worker....

> That is, if we've already started to tear down or torn down the log,
> we must not allow new transactions to start. Likewise, we can't
> finalise tear down the log until transactions in progress have
> completed. Using the s_umount lock here avoids then race, but it
> really is a VFS level lock not an filesystem level lock) and is,
> IMO, just papering over the real problem....

I think you have a good point here, but this isn't limited to transactions.  We
shouldn't even call xfs_log_need_covered without some protection from
xfs_fs_put_super; xfs_fs_writable doesn't cut the mustard.   I'd better have a
look at the other workqueues too.  Thanks for pointing this out.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
