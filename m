Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 96CCC7F4E
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 14:55:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 58A998F8040
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 12:55:13 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id drTtfcHKRKYhCv3c (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 12:55:12 -0700 (PDT)
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 18 Jul 2013 13:55:12 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 449EB19D806C
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 13:54:45 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6IJsmUV348564 for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 13:54:49 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6IJsknW007339
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 13:54:46 -0600
Subject: Re: [PATCH] xfs: Fix a deadlock in xfs_log_commit_cil() code path
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130718022451.GM11674@dastard>
References: <1373928754.20769.41.camel@chandra-dt.ibm.com>
	<20130716005455.GC3920@dastard>
	<1374096775.8941.3.camel@chandra-dt.ibm.com>
	<20130718022451.GM11674@dastard>
Date: Thu, 18 Jul 2013 14:54:45 -0500
Message-ID: <1374177285.8941.477.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Cc: XFS mailing list <xfs@oss.sgi.com>

On Thu, 2013-07-18 at 12:24 +1000, Dave Chinner wrote:
> On Wed, Jul 17, 2013 at 04:32:55PM -0500, Chandra Seetharaman wrote:
> > On Tue, 2013-07-16 at 10:54 +1000, Dave Chinner wrote:
> > > On Mon, Jul 15, 2013 at 05:52:34PM -0500, Chandra Seetharaman wrote:
> > > > While testing and rearranging my pquota/gquota code, I stumbled
> > > > on a xfs_shutdown() during a mount. But the mount just hung.
> > > > 
> > > > I debugged and found that there is a deadlock involving
> > > > &log->l_cilp->xc_ctx_lock.
> > > > 
> > > > It is in a code path where &log->l_cilp->xc_ctx_lock is first
> > > > acquired in read mode and some levels down the same semaphore
> > > > is being acquired in write mode causing a deadlock.
> > > > 
> > > > This is the stack:
> > > > xfs_log_commit_cil -> acquires &log->l_cilp->xc_ctx_lock in read mode
> > > >   xlog_print_tic_res
> > > >     xfs_force_shutdown
> > > >       xfs_log_force_umount
> > > >         xlog_cil_force
> > > >           xlog_cil_force_lsn
> > > >             xlog_cil_push_foreground
> > > >               xlog_cil_push - tries to acquire same semaphore in write mode
> > > > 
> > > > This patch fixes the deadlock by not calling xfs_force_shutdown() while
> > > > holding the semaphore, instead calling it after dropping teh semaphore.
> > > > 
> > > > Thanks to Dave for suggesting this solution.
> > > > 
> > > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > > > 
> > > > ---
> > > >  fs/xfs/xfs_log.c      |    6 +++---
> > > >  fs/xfs/xfs_log_cil.c  |   10 ++++++----
> > > >  fs/xfs/xfs_log_priv.h |    2 +-
> > > >  fs/xfs/xfs_trans.c    |    2 +-
> > > >  4 files changed, 11 insertions(+), 9 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > > index d852a2b..b9fa2da 100644
> > > > --- a/fs/xfs/xfs_log.c
> > > > +++ b/fs/xfs/xfs_log.c
> > > > @@ -1837,7 +1837,7 @@ xlog_state_finish_copy(
> > > >   * print out info relating to regions written which consume
> > > >   * the reservation
> > > >   */
> > > > -void
> > > > +int
> > > >  xlog_print_tic_res(
> > > >  	struct xfs_mount	*mp,
> > > >  	struct xlog_ticket	*ticket)
> > > > @@ -1941,7 +1941,7 @@ xlog_print_tic_res(
> > > >  
> > > >  	xfs_alert_tag(mp, XFS_PTAG_LOGRES,
> > > >  		"xlog_write: reservation ran out. Need to up reservation");
> > > > -	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > > +	return EFSCORRUPTED;
> > > 
> > > Note the "SHUTDOWN_CORRUPT_INCORE" reason given here....
> > > 
> > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > index 35a2299..d96022f 100644
> > > > --- a/fs/xfs/xfs_trans.c
> > > > +++ b/fs/xfs/xfs_trans.c
> > > > @@ -1547,7 +1547,7 @@ xfs_trans_commit(
> > > >  	xfs_trans_apply_dquot_deltas(tp);
> > > >  
> > > >  	error = xfs_log_commit_cil(mp, tp, &commit_lsn, flags);
> > > > -	if (error == ENOMEM) {
> > > > +	if (error) {
> > > >  		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> > > 
> > > Which is different to the reason given here. The shutdown reason
> > > should be maintained for this particular error....
> > 
> > I see.
> 
> What I mean is that the code in xfs_trans_commit() should do
> something like:
> 
> 	if (error) {
> 		int reason = SHUTDOWN_LOG_IO_ERROR;
> 		if (error == EFSCORRUPTED)
> 			reason = SHUTDOWN_CORRUPT_INCORE;
> 		xfs_force_shutdown(mp, reason);
> 		....
> 	}
> 
> > 
> > Is it ok if the error reason is not propagated to the xlog_write() code
> > path ?
> 
> No - if we get a transaction overflow, we need to trigger a
> shutdown. That means the error needs to be caught by the
> xlog_write() path an the filesystem shut down.
> 
> Looking at it more deeply, you could probably just change the
> shutdown in xlog_print_tic_res() to use SHUTDOWN_LOG_IO_ERROR and
> the problem is solved as the shutdown won't try to force the
> log. i.e. this whole problem will go away with that one line fix...

I am confused.

In the previous response you mentioned that we have to propagate the
reason as-is in xfs_trans_commit() path. But, the new suggestion you are
making will change the behavior of all paths and they will not enter
xfs_log_force_umount().

Besides, IIUC, XFS_MOUNT_FS_SHUTDOWN is set only in
xfs_log_force_umount(), so the very first time we enter
xlog_print_tic_res(), even with SHUTDOWN_LOG_IO_ERROR we will call
xfs_log_force_umount() when can lead to the deadlock we are trying to
avoid.

  
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
