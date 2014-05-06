Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F15C97F37
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 16:05:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C19D58F8033
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 14:05:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sP5S8pExeMi8RzBQ for
	<xfs@oss.sgi.com>; Tue, 06 May 2014 14:04:59 -0700 (PDT)
Date: Tue, 6 May 2014 17:04:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: don't sleep in xlog_cil_force_lsn on shutdown
Message-ID: <20140506210455.GA16388@laptop.bfoster>
References: <1399338280-10013-1-git-send-email-david@fromorbit.com>
	<20140506132745.GA14154@bfoster.bfoster>
	<20140506203545.GN5421@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140506203545.GN5421@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, May 07, 2014 at 06:35:45AM +1000, Dave Chinner wrote:
> On Tue, May 06, 2014 at 09:27:46AM -0400, Brian Foster wrote:
> > On Tue, May 06, 2014 at 11:04:40AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Reports of a shutdown hang when fsyncing a directory have surfaced,
> > > such as this:
> > > 
> > > [ 3663.394472] Call Trace:
> > > [ 3663.397199]  [<ffffffff815f1889>] schedule+0x29/0x70
> > > [ 3663.402743]  [<ffffffffa01feda5>] xlog_cil_force_lsn+0x185/0x1a0 [xfs]
> > > [ 3663.416249]  [<ffffffffa01fd3af>] _xfs_log_force_lsn+0x6f/0x2f0 [xfs]
> > > [ 3663.429271]  [<ffffffffa01a339d>] xfs_dir_fsync+0x7d/0xe0 [xfs]
> > > [ 3663.435873]  [<ffffffff811df8c5>] do_fsync+0x65/0xa0
> > > [ 3663.441408]  [<ffffffff811dfbc0>] SyS_fsync+0x10/0x20
> > > [ 3663.447043]  [<ffffffff815fc7d9>] system_call_fastpath+0x16/0x1b
> > > 
> > > If we trigger a shutdown in xlog_cil_push() from xlog_write(), we
> > > will never wake waiters on the current push sequence number, so
> > > anything waiting in xlog_cil_force_lsn() for that push sequence
> > > number to come up will not get woken and hence stall the shutdown.
> > > 
> > > Fix this by ensuring we call wake_up_all(&cil->xc_commit_wait) in
> > > the push abort handling, in the log shutdown code when waking all
> > > waiters, and adding a shutdown check in the sequence completion wait
> > > loops to ensure they abort when a wakeup due to a shutdown occurs.
> > > 
> > > Reported-by: Boris Ranto <branto@redhat.com>
> > > Reported-by: Eric Sandeen <esandeen@redhat.com>
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > 
> > Previously posted here, for reference:
> > 
> > http://oss.sgi.com/archives/xfs/2014-04/msg00801.html
> > 
> > >  fs/xfs/xfs_log.c     |  7 +++++--
> > >  fs/xfs/xfs_log_cil.c | 50 ++++++++++++++++++++++++++++++++++++++++++--------
> > >  2 files changed, 47 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index a5f8bd9..dbba2d7 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -3952,11 +3952,14 @@ xfs_log_force_umount(
> > >  		retval = xlog_state_ioerror(log);
> > >  		spin_unlock(&log->l_icloglock);
> > >  	}
> > > +
> > >  	/*
> > > -	 * Wake up everybody waiting on xfs_log_force.
> > > -	 * Callback all log item committed functions as if the
> > > +	 * Wake up everybody waiting on xfs_log_force. This needs to wake anyone
> > > +	 * waiting on a CIL push that is issued as part of a log force first
> > > +	 * before running the log item committed callback functions as if the
> > >  	 * log writes were completed.
> > >  	 */
> > > +	wake_up_all(&log->l_cilp->xc_commit_wait);
> > >  	xlog_state_do_callback(log, XFS_LI_ABORTED, NULL);
> > >  
> > 
> > This looks fine to me with the defensive reasoning described in the
> > aforementioned link, but it also looks like it could race with a force
> > and sleep because we don't take xc_push_lock. We take the lock for the
> > same wake up down in xlog_cil_committed(), so a hang seems unlikely at
> > this point.
> 
> We can't really race in any meaningful way- the filesystem and log
> are already marked as shut down. Hence any new sleeper at this point
> will detect a shutdown before trying to sleep. Even if we do race,
> the xlog_cil_committed() will catch any stragglers...
> 
> > Given that the comment is kind of wordy (and unless we want to do the
> > locking here as well), could we update the comment to reflect this?
> > E.g., something like:
> > 
> > 	/*
> > 	 * Wake up everybody waiting on a CIL push and/or log force. Wake the
> > 	 * CIL push first as if the log writes were completed. The abort
> > 	 * handling in the log item committed callback functions will do this
> > 	 * again under lock to avoid races.
> > 	 */
> > 
> > Thoughts?
> 
> Makes sense. I'll change it.
> 

Ok, the code looks good to me so with that minor change:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
