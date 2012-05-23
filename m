Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4N92ZbZ127336 for <xfs@oss.sgi.com>; Wed, 23 May 2012 04:02:35 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	nEbVuc8KCDw11wCZ for <xfs@oss.sgi.com>;
	Wed, 23 May 2012 02:02:30 -0700 (PDT)
Date: Wed, 23 May 2012 19:02:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: use s_umount sema in xfs_sync_worker
Message-ID: <20120523090225.GX5091@dastard>
References: <20120323174327.GU7762@sgi.com> <20120514203449.GE16099@sgi.com>
	<20120516015626.GN25351@dastard> <20120516170402.GD3963@sgi.com>
	<20120517071658.GP25351@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120517071658.GP25351@dastard>
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

On Thu, May 17, 2012 at 05:16:58PM +1000, Dave Chinner wrote:
> On Wed, May 16, 2012 at 12:04:03PM -0500, Ben Myers wrote:
> > On Wed, May 16, 2012 at 11:56:26AM +1000, Dave Chinner wrote:
> > > On Mon, May 14, 2012 at 03:34:49PM -0500, Ben Myers wrote:
> > > > I'm still hitting this on a regular basis.  Here is some analysis from a recent
> > > > crash dump which you may want to skip.  The fix is at the end.
> > > ....
> > > > ===================================================================
> > > > 
> > > > xfs: use s_umount sema in xfs_sync_worker
> > > > 
> > > > xfs_sync_worker checks the MS_ACTIVE flag in sb->s_flags to avoid doing work
> > > > during mount and unmount.  This flag can be cleared by unmount after the
> > > > xfs_sync_worker checks it but before the work is completed.
> > > 
> > > Then there are problems all over the place in different filesystems
> > > if the straight MS_ACTIVE check is not sufficient.
> > 
> > Eh, I won't speak to the problems in other filesystems.  ;)
> > 
> > MS_ACTIVE certainly isn't adequate in the case before us.
> 
> Only because the XFS code isn't internally safe...
> 
> > > > Protect xfs_sync_worker by using the s_umount semaphore at the read level to
> > > > provide exclusion with unmount while work is progressing.
> > > 
> > > I don't think that is the right fix for the given problem.
> > > 
> > > The problem is, as you've stated:
> > > 
> > > "Looks like the problem is that the sync worker is still running
> > > after the log has been torn down, and it calls xfs_fs_log_dummy
> > > which generates log traffic."
> > 
> > That's one problem, but we also want to protect against running this code at
> > mount time.  s_umount sema is the tool that can do both.  Maybe there are some
> > other options.
> 
> The mount case isn't a problem - MS_ACTIVE is only set once the
> mount process is complete and so the check is just fine for that
> case.
> 
> > > Why did we allow a new transaction to start while/after the log was
> > > torn down?
> > 
> > > Isn't that the problem we need to fix because it leads to
> > > invalid entries in the physical log that might cause recovery
> > > failures?
> > 
> > > Further, any asynchronous worker thread that does
> > > transactions could have this same problem regardless of whether we
> > > are umounting or cleaning up after a failed mount, so it is not
> > > unique to the xfs_sync_worker....
> > 
> > > That is, if we've already started to tear down or torn down the log,
> > > we must not allow new transactions to start. Likewise, we can't
> > > finalise tear down the log until transactions in progress have
> > > completed. Using the s_umount lock here avoids then race, but it
> > > really is a VFS level lock not an filesystem level lock) and is,
> > > IMO, just papering over the real problem....
> > 
> > I think you have a good point here, but this isn't limited to transactions.
> 
> I'm pretty sure that the other async threads/wqs are safe w.r.t.
> startup and shutdown. Indeed, some of them have to run while
> mount/unmount are running so must have their own startup/shutdown
> synchronisation. Hence we need to treat each different async work on
> a case by case basis...
> 
> > We shouldn't even call xfs_log_need_covered without some
> > protection from xfs_fs_put_super; xfs_fs_writable doesn't cut the
> > mustard.
> 
> Sure, but that check is for a different purpose so it's no surprise
> at all that it doesn't help this case.
> 
> AFAICT, we simply don't care if xfs_fs_put_super() has been called -
> what matters is the state of the log at the time
> xfs_log_need_covered() is called.  i.e. xfs_log_need_covered()
> should error out if the log is being recovered or being torn down.
> Same for xfs_log_force(), xfs_log_reserve(), etc. Right now we don't
> even check if we can do the operation safely or not.
> 
> Right now we assume that new transactions or log operations cannot
> occur (i.e they are stopped) before we tear down the log.  That
> means we either need to prevent transactions from starting once we
> start tearing down the log, or we need to stop the xfs_sync_worker
> before we tear down the log. The second is how we currently avoid
> this problem, so adding a cancel_delayed_work_sync(&mp->m_sync_work)
> to xfs_log_unmount() would probably solve the problem....

<sigh>

So, i just found that this fix was checked in. the date stamps are:

	March 23 - Ben reports problem

	(silence for almost 2 months)

	May 14, 15:30 CT - Ben presents RFC fix without sign-off
	May 15, 13:30 CT - Mark reviews
	May 15, 14:27 CT - Commit to oss-xfs master branch
	May 15, 14:30 CT - Ben adds sign-off

Effectively that gave everyone on the list less than 24 hours to
review and comment on a bug analysis and RFC patch before the fix
hit the master branch.

When I commented on it:

	May 16, 11:15 AEST - Dave says "doesn't look like the right
			     way to fix the problem"

I didn't realise that it had already been checked into the master
branch. I thought it was still an RFC waiting for review.

I think I've got good reason for not catching that - I'd only just
arrived back home with my dog after she had surgery to repair the
thigh bone she shattered into 15 pieces the previous week - and so
merge emails were way below my threshold of interest.  Hell, I think
that commenting on it in under 36 hours is pretty good considering
all the other shit I had to deal with when you posted the RFC.

So, fast forward to today when I'm trying to get my trees up to
date, I find that a patch in my stack doesn't apply because of a
conflict in xfs_sync_worker. That's when I discover this has already
been committed, and committed less than 24 hours after the RFC was
posted, and more than 12 hours before I actually commented on it.

Ben, you just can't do that. Well, you can, but it's certainly going
to annoy people. I'm grumpy enough as it is right now without having
to deal with additional crap like this.

Especially as this is about code that was posted as "I'm not sure
this is correct, so I haven't added a sign-off". Having it pass
xfstests for a day does not make the code more correct, and such a
statement means the codeneeds discussion before progressing.

You have to give everyone time to review RFC patches before
committing them. Just because you think they are OK or the survive
xfstests doesn't mean that they really are OK. indeed, my biggest
pet peeve is not being given the opportunity to review code before
it is committed, and this falls right into that territory...

As it is, I'm going to ask that you revert commit 1307bbd2a and fix
the problem without using the s_umount lock. I have mentioned a way
that it should be possible to do, so I'd like you to explore that
rather than ignoring/not responding to my comments because you've
already committed your fix.

Basically what I am saying is this: Ben, please don't abuse your
position as XFS maintainer to push fixes you think are OK without
giving everyone else a chance to review them first.  We have a
review process that works only as long as everyone plays by the same
rules....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
