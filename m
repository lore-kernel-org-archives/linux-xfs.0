Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4OMYaFr131415 for <xfs@oss.sgi.com>; Thu, 24 May 2012 17:34:36 -0500
Date: Thu, 24 May 2012 17:39:52 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: use s_umount sema in xfs_sync_worker
Message-ID: <20120524223952.GU16099@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hey Dave,

On Thu, May 17, 2012 at 05:16:58PM +1000, Dave Chinner wrote:
> On Wed, May 16, 2012 at 12:04:03PM -0500, Ben Myers wrote:
> > I think you have a good point here, but this isn't limited to transactions.
> 
> I'm pretty sure that the other async threads/wqs are safe w.r.t.
> startup and shutdown. Indeed, some of them have to run while
> mount/unmount are running so must have their own startup/shutdown
> synchronisation. Hence we need to treat each different async work on
> a case by case basis...

I'd still like to understand them all... and there are plenty of them.

> > We shouldn't even call xfs_log_need_covered without some
> > protection from xfs_fs_put_super; xfs_fs_writable doesn't cut the
> > mustard.
> 
> Sure, but that check is for a different purpose so it's no surprise
> at all that it doesn't help this case.

Yep.

> AFAICT, we simply don't care if xfs_fs_put_super() has been called -
> what matters is the state of the log at the time
> xfs_log_need_covered() is called.  i.e. xfs_log_need_covered()
> should error out if the log is being recovered or being torn down.
> Same for xfs_log_force(), xfs_log_reserve(), etc. Right now we don't
> even check if we can do the operation safely or not.

Erroring out is one option, but I suggest that we shouldn't necessarily
characterize a torn down log as an error, unless we plan to have some other
means of synchronization.  If we have some other means of synch, then it's fine
to warn or assert or error on these when the log is already torn down.

> Right now we assume that new transactions or log operations cannot
> occur (i.e they are stopped) before we tear down the log.  That
> means we either need to prevent transactions from starting once we
> start tearing down the log, or we need to stop the xfs_sync_worker
> before we tear down the log. The second is how we currently avoid
> this problem, so adding a cancel_delayed_work_sync(&mp->m_sync_work)
> to xfs_log_unmount() would probably solve the problem....

cancel_delayed_work_sync waits for all workers to finish before returning, so
that should work fine.  Is there any point in covering the log after the
unmount record has been written?  We should cancel the work before writing that
record.  Hrm.  Maybe xfs_log_need_covered handles that already..  Anyway, I'll
make some time to work on this tomorrow so I can test it over the weekend.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
