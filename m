Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A96D29DF8
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2014 15:12:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EDA79304064
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2014 13:12:24 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	X3OqVTHhkg4pU2aI for <xfs@oss.sgi.com>;
	Tue, 29 Apr 2014 13:12:22 -0700 (PDT)
Date: Wed, 30 Apr 2014 06:12:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: test for shut down fs in xfs_dir_fsync()
Message-ID: <20140429201220.GC22497@dastard>
References: <535E8344.2070209@redhat.com> <20140428205420.GB18672@dastard>
	<535ECAA6.3050200@sgi.com> <20140428221849.GC18672@dastard>
	<20140429125648.GA59046@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140429125648.GA59046@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Mark Tinguely <tinguely@sgi.com>, Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 29, 2014 at 08:56:49AM -0400, Brian Foster wrote:
> On Tue, Apr 29, 2014 at 08:18:49AM +1000, Dave Chinner wrote:
> > On Mon, Apr 28, 2014 at 04:39:50PM -0500, Mark Tinguely wrote:
> > > On 04/28/14 15:54, Dave Chinner wrote:
> > > >On Mon, Apr 28, 2014 at 11:35:16AM -0500, Eric Sandeen wrote:
> ...
> > 
> > xfs: don't sleep in xlog_cil_force_lsn on shutdown
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Reports of a shutdown hang when fsyncing a directory have surfaced,
> > such as this:
> > 
> > [ 3663.394472] Call Trace:
> > [ 3663.397199]  [<ffffffff815f1889>] schedule+0x29/0x70
> > [ 3663.402743]  [<ffffffffa01feda5>] xlog_cil_force_lsn+0x185/0x1a0 [xfs]
> > [ 3663.416249]  [<ffffffffa01fd3af>] _xfs_log_force_lsn+0x6f/0x2f0 [xfs]
> > [ 3663.429271]  [<ffffffffa01a339d>] xfs_dir_fsync+0x7d/0xe0 [xfs]
> > [ 3663.435873]  [<ffffffff811df8c5>] do_fsync+0x65/0xa0
> > [ 3663.441408]  [<ffffffff811dfbc0>] SyS_fsync+0x10/0x20
> > [ 3663.447043]  [<ffffffff815fc7d9>] system_call_fastpath+0x16/0x1b
> > 
> > If we trigger a shutdown in xlog_cil_push() from xlog_write(), we
> > will never wake waiters on the current push sequence number, so
> > anything waiting in xlog_cil_force_lsn() for that push sequence
> > number to come up will not get woken and hence stall the shutdown.
> > 
> > Fix this by ensuring we call wake_up_all(&cil->xc_commit_wait) in
> > the push abort handling, in the log shutdown code when waking all
> > waiters, and adding a shutdown check in the sequence completion wait
> > loops to ensure they abort when a wakeup due to a shutdown occurs.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c     |  7 +++++--
> >  fs/xfs/xfs_log_cil.c | 50 ++++++++++++++++++++++++++++++++++++++++++--------
> >  2 files changed, 47 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index a5f8bd9..dbba2d7 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -3952,11 +3952,14 @@ xfs_log_force_umount(
> >  		retval = xlog_state_ioerror(log);
> >  		spin_unlock(&log->l_icloglock);
> >  	}
> > +
> >  	/*
> > -	 * Wake up everybody waiting on xfs_log_force.
> > -	 * Callback all log item committed functions as if the
> > +	 * Wake up everybody waiting on xfs_log_force. This needs to wake anyone
> > +	 * waiting on a CIL push that is issued as part of a log force first
> > +	 * before running the log item committed callback functions as if the
> >  	 * log writes were completed.
> >  	 */
> > +	wake_up_all(&log->l_cilp->xc_commit_wait);
> >  	xlog_state_do_callback(log, XFS_LI_ABORTED, NULL);
> >  
> 
> Why is this necessary? It looks like xlog_state_do_callback() will hit
> the xlog_cil_committed() callback with the aborted flag...

I added it before adding the code into xlog_cil_committed().
Regardless, I think it's a good idea to have a specific wakeup to
for waiters catch the shutdown purely from a defensive POV - if we
screw up something else, we will still get a wakeup after the log is
marked shutdown and not hang...

> >  #ifdef XFSERRORDEBUG
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 7e54553..3a68ddf 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -385,7 +385,15 @@ xlog_cil_committed(
> >  	xfs_extent_busy_clear(mp, &ctx->busy_extents,
> >  			     (mp->m_flags & XFS_MOUNT_DISCARD) && !abort);
> >  
> > +	/*
> > +	 * If we are aborting the commit, wake up anyone waiting on the
> > +	 * committing list.  If we don't, then a shutdown we can leave processes
> > +	 * waiting in xlog_cil_force_lsn() waiting on a sequence commit that
> > +	 * will never happen because we aborted it.
> > +	 */
> >  	spin_lock(&ctx->cil->xc_push_lock);
> > +	if (abort)
> > +		wake_up_all(&cil->xc_commit_wait);
> 
> There's a compile error here. The parameter should be '&ctx->cil->...'

Forgot to refresh the patch - the tested version has this fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
