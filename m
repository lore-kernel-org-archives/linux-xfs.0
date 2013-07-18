Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DBFEF7F3F
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 21:25:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C95368F8039
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 19:25:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Ysyd5ESAIHtBy6YS for <xfs@oss.sgi.com>;
	Wed, 17 Jul 2013 19:24:56 -0700 (PDT)
Date: Thu, 18 Jul 2013 12:24:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix a deadlock in xfs_log_commit_cil() code path
Message-ID: <20130718022451.GM11674@dastard>
References: <1373928754.20769.41.camel@chandra-dt.ibm.com>
	<20130716005455.GC3920@dastard>
	<1374096775.8941.3.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374096775.8941.3.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Wed, Jul 17, 2013 at 04:32:55PM -0500, Chandra Seetharaman wrote:
> On Tue, 2013-07-16 at 10:54 +1000, Dave Chinner wrote:
> > On Mon, Jul 15, 2013 at 05:52:34PM -0500, Chandra Seetharaman wrote:
> > > While testing and rearranging my pquota/gquota code, I stumbled
> > > on a xfs_shutdown() during a mount. But the mount just hung.
> > > 
> > > I debugged and found that there is a deadlock involving
> > > &log->l_cilp->xc_ctx_lock.
> > > 
> > > It is in a code path where &log->l_cilp->xc_ctx_lock is first
> > > acquired in read mode and some levels down the same semaphore
> > > is being acquired in write mode causing a deadlock.
> > > 
> > > This is the stack:
> > > xfs_log_commit_cil -> acquires &log->l_cilp->xc_ctx_lock in read mode
> > >   xlog_print_tic_res
> > >     xfs_force_shutdown
> > >       xfs_log_force_umount
> > >         xlog_cil_force
> > >           xlog_cil_force_lsn
> > >             xlog_cil_push_foreground
> > >               xlog_cil_push - tries to acquire same semaphore in write mode
> > > 
> > > This patch fixes the deadlock by not calling xfs_force_shutdown() while
> > > holding the semaphore, instead calling it after dropping teh semaphore.
> > > 
> > > Thanks to Dave for suggesting this solution.
> > > 
> > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > > 
> > > ---
> > >  fs/xfs/xfs_log.c      |    6 +++---
> > >  fs/xfs/xfs_log_cil.c  |   10 ++++++----
> > >  fs/xfs/xfs_log_priv.h |    2 +-
> > >  fs/xfs/xfs_trans.c    |    2 +-
> > >  4 files changed, 11 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index d852a2b..b9fa2da 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -1837,7 +1837,7 @@ xlog_state_finish_copy(
> > >   * print out info relating to regions written which consume
> > >   * the reservation
> > >   */
> > > -void
> > > +int
> > >  xlog_print_tic_res(
> > >  	struct xfs_mount	*mp,
> > >  	struct xlog_ticket	*ticket)
> > > @@ -1941,7 +1941,7 @@ xlog_print_tic_res(
> > >  
> > >  	xfs_alert_tag(mp, XFS_PTAG_LOGRES,
> > >  		"xlog_write: reservation ran out. Need to up reservation");
> > > -	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > +	return EFSCORRUPTED;
> > 
> > Note the "SHUTDOWN_CORRUPT_INCORE" reason given here....
> > 
> > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > index 35a2299..d96022f 100644
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
> > > @@ -1547,7 +1547,7 @@ xfs_trans_commit(
> > >  	xfs_trans_apply_dquot_deltas(tp);
> > >  
> > >  	error = xfs_log_commit_cil(mp, tp, &commit_lsn, flags);
> > > -	if (error == ENOMEM) {
> > > +	if (error) {
> > >  		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> > 
> > Which is different to the reason given here. The shutdown reason
> > should be maintained for this particular error....
> 
> I see.

What I mean is that the code in xfs_trans_commit() should do
something like:

	if (error) {
		int reason = SHUTDOWN_LOG_IO_ERROR;
		if (error == EFSCORRUPTED)
			reason = SHUTDOWN_CORRUPT_INCORE;
		xfs_force_shutdown(mp, reason);
		....
	}

> 
> Is it ok if the error reason is not propagated to the xlog_write() code
> path ?

No - if we get a transaction overflow, we need to trigger a
shutdown. That means the error needs to be caught by the
xlog_write() path an the filesystem shut down.

Looking at it more deeply, you could probably just change the
shutdown in xlog_print_tic_res() to use SHUTDOWN_LOG_IO_ERROR and
the problem is solved as the shutdown won't try to force the
log. i.e. this whole problem will go away with that one line fix...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
