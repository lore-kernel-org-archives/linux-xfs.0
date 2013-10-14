Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 464337F37
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 15:04:26 -0500 (CDT)
Date: Mon, 14 Oct 2013 15:04:22 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: prevent deadlock trying to cover an active log
Message-ID: <20131014200422.GA1935@sgi.com>
References: <1381278703-23439-1-git-send-email-david@fromorbit.com>
	<52577337.2090901@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52577337.2090901@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hey Fellas,

On Thu, Oct 10, 2013 at 10:40:39PM -0500, Eric Sandeen wrote:
> On 10/8/13 7:31 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Recent analysis of a deadlocked XFS filesystem from a kernel
> > crash dump indicated that the filesystem was stuck waiting for log
> > space. The short story of the hang on the RHEL6 kernel is this:
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Thanks,
> -Eric
> 
> > 	- the tail of the log is pinned by an inode
> > 	- the inode has been pushed by the xfsaild
> > 	- the inode has been flushed to it's backing buffer and is
> > 	  currently flush locked and hence waiting for backing
> > 	  buffer IO to complete and remove it from the AIL
> > 	- the backing buffer is marked for write - it is on the
> > 	  delayed write queue
> > 	- the inode buffer has been modified directly and logged
> > 	  recently due to unlinked inode list modification
> > 	- the backing buffer is pinned in memory as it is in the
> > 	  active CIL context.
> > 	- the xfsbufd won't start buffer writeback because it is
> > 	  pinned
> > 	- xfssyncd won't force the log because it sees the log as
> > 	  needing to be covered and hence wants to issue a dummy
> > 	  transaction to move the log covering state machine along.
> > 
> > Hence there is no trigger to force the CIL to the log and hence
> > unpin the inode buffer and therefore complete the inode IO, remove
> > it from the AIL and hence move the tail of the log along, allowing
> > transactions to start again.
> > 
> > Mainline kernels also have the same deadlock, though the signature
> > is slightly different - the inode buffer never reaches the delayed
> > write lists because xfs_buf_item_push() sees that it is pinned and
> > hence never adds it to the delayed write list that the xfsaild
> > flushes.
> > 
> > There are two possible solutions here. The first is to simply force
> > the log before trying to cover the log and so ensure that the CIL is
> > emptied before we try to reserve space for the dummy transaction in
> > the xfs_log_worker(). While this might work most of the time, it is
> > still racy and is no guarantee that we don't get stuck in
> > xfs_trans_reserve waiting for log space to come free. Hence it's not
> > the best way to solve the problem.
> > 
> > The second solution is to modify xfs_log_need_covered() to be aware
> > of the CIL. We only should be attempting to cover the log if there
> > is no current activity in the log - covering the log is the process
> > of ensuring that the head and tail in the log on disk are identical
> > (i.e. the log is clean and at idle). Hence, by definition, if there
> > are items in the CIL then the log is not at idle and so we don't
> > need to attempt to cover it.
> > 
> > When we don't need to cover the log because it is active or idle, we
> > issue a log force from xfs_log_worker() - if the log is idle, then
> > this does nothing.  However, if the log is active due to there being
> > items in the CIL, it will force the items in the CIL to the log and
> > unpin them.
> > 
> > In the case of the above deadlock scenario, instead of
> > xfs_log_worker() getting stuck in xfs_trans_reserve() attempting to
> > cover the log, it will instead force the log, thereby unpinning the
> > inode buffer, allowing IO to be issued and complete and hence
> > removing the inode that was pinning the tail of the log from the
> > AIL. At that point, everything will start moving along again. i.e.
> > the xfs_log_worker turns back into a watchdog that can alleviate
> > deadlocks based around pinned items that prevent the tail of the log
> > from being moved...
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c      | 48 +++++++++++++++++++++++++++++-------------------
> >  fs/xfs/xfs_log_cil.c  | 14 ++++++++++++++
> >  fs/xfs/xfs_log_priv.h | 10 ++++------
> >  3 files changed, 47 insertions(+), 25 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index a2dea108..613ed94 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1000,27 +1000,34 @@ xfs_log_space_wake(
> >  }
> >  
> >  /*
> > - * Determine if we have a transaction that has gone to disk
> > - * that needs to be covered. To begin the transition to the idle state
> > - * firstly the log needs to be idle (no AIL and nothing in the iclogs).
> > - * If we are then in a state where covering is needed, the caller is informed
> > - * that dummy transactions are required to move the log into the idle state.
> > + * Determine if we have a transaction that has gone to disk that needs to be
> > + * covered. To begin the transition to the idle state firstly the log needs to
> > + * be idle. That means the CIL, the AIL and the iclogs needs to be empty before
> > + * we start attempting to cover the log.
> >   *
> > - * Because this is called as part of the sync process, we should also indicate
> > - * that dummy transactions should be issued in anything but the covered or
> > - * idle states. This ensures that the log tail is accurately reflected in
> > - * the log at the end of the sync, hence if a crash occurrs avoids replay
> > - * of transactions where the metadata is already on disk.
> > + * Only if we are then in a state where covering is needed, the caller is
> > + * informed that dummy transactions are required to move the log into the idle
> > + * state.
> > + *
> > + * If there are any items in the AIl or CIL, then we do not want to attempt to
> > + * cover the log as we may be in a situation where there isn't log space
> > + * available to run a dummy transaction and this can lead to deadlocks when the
> > + * tail of the log is pinned by an item that is modified in the CIL.  Hence
> > + * there's no point in running a dummy transaction at this point because we
> > + * can't start trying to idle the log until both the CIL and AIL are empty.
> >   */
> >  int
> >  xfs_log_need_covered(xfs_mount_t *mp)
> >  {
> > -	int		needed = 0;
> >  	struct xlog	*log = mp->m_log;
> > +	int		needed = 0;
> >  
> >  	if (!xfs_fs_writable(mp))
> >  		return 0;
> >  
> > +	if (!xlog_cil_empty(log))
> > +		return 0;
> > +
> >  	spin_lock(&log->l_icloglock);
> >  	switch (log->l_covered_state) {
> >  	case XLOG_STATE_COVER_DONE:
> > @@ -1029,14 +1036,17 @@ xfs_log_need_covered(xfs_mount_t *mp)
> >  		break;
> >  	case XLOG_STATE_COVER_NEED:
> >  	case XLOG_STATE_COVER_NEED2:
> > -		if (!xfs_ail_min_lsn(log->l_ailp) &&
> > -		    xlog_iclogs_empty(log)) {
> > -			if (log->l_covered_state == XLOG_STATE_COVER_NEED)
> > -				log->l_covered_state = XLOG_STATE_COVER_DONE;
> > -			else
> > -				log->l_covered_state = XLOG_STATE_COVER_DONE2;
> > -		}
> > -		/* FALLTHRU */
> > +		if (xfs_ail_min_lsn(log->l_ailp))
> > +			break;
> > +		if (!xlog_iclogs_empty(log))
> > +			break;
> > +
> > +		needed = 1;
> > +		if (log->l_covered_state == XLOG_STATE_COVER_NEED)
> > +			log->l_covered_state = XLOG_STATE_COVER_DONE;
> > +		else
> > +			log->l_covered_state = XLOG_STATE_COVER_DONE2;
> > +		break;
> >  	default:
> >  		needed = 1;
> >  		break;
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index cfe9797..da8524e77 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -711,6 +711,20 @@ xlog_cil_push_foreground(
> >  	xlog_cil_push(log);
> >  }
> >  
> > +bool
> > +xlog_cil_empty(
> > +	struct xlog	*log)
> > +{
> > +	struct xfs_cil	*cil = log->l_cilp;
> > +	bool		empty = false;
> > +
> > +	spin_lock(&cil->xc_push_lock);
> > +	if (list_empty(&cil->xc_cil))
> > +		empty = true;
> > +	spin_unlock(&cil->xc_push_lock);
> > +	return empty;
> > +}
> > +
> >  /*
> >   * Commit a transaction with the given vector to the Committed Item List.
> >   *
> > diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> > index 136654b..de24ffb 100644
> > --- a/fs/xfs/xfs_log_priv.h
> > +++ b/fs/xfs/xfs_log_priv.h
> > @@ -514,12 +514,10 @@ xlog_assign_grant_head(atomic64_t *head, int cycle, int space)
> >  /*
> >   * Committed Item List interfaces
> >   */
> > -int
> > -xlog_cil_init(struct xlog *log);
> > -void
> > -xlog_cil_init_post_recovery(struct xlog *log);
> > -void
> > -xlog_cil_destroy(struct xlog *log);
> > +int	xlog_cil_init(struct xlog *log);
> > +void	xlog_cil_init_post_recovery(struct xlog *log);
> > +void	xlog_cil_destroy(struct xlog *log);
> > +bool	xlog_cil_empty(struct xlog *log)

Huh.  Looks like we're short a semicolon here.  I can add one, unless you
prefer to repost?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
