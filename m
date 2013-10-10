Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 27F007F3F
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 16:42:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C46718F807A
	for <xfs@oss.sgi.com>; Thu, 10 Oct 2013 14:42:31 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	TFVVjIMXsb21HphJ for <xfs@oss.sgi.com>;
	Thu, 10 Oct 2013 14:42:29 -0700 (PDT)
Date: Fri, 11 Oct 2013 08:42:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: prevent deadlock trying to cover an active log
Message-ID: <20131010214227.GA4446@dastard>
References: <1381278703-23439-1-git-send-email-david@fromorbit.com>
	<5256DE6A.1070502@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5256DE6A.1070502@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Oct 10, 2013 at 12:05:46PM -0500, Eric Sandeen wrote:
> On 10/8/13 7:31 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Recent analysis of a deadlocked XFS filesystem from a kernel
> > crash dump indicated that the filesystem was stuck waiting for log
> > space. The short story of the hang on the RHEL6 kernel is this:
> > 
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
....
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
> 
> This hunk is all cosmetic, right?  (nice cosmetic, but cosmetic).

No, it's a logic change.

> Kinda wish this were in a patch 2/2 just for clarity.
> 
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

There is different logic - the old code *always* fell through to set
needed = 1, regardless of whether the AIL or iclogs had anything in
them or not. Hence we'd try to cover the log when we clearly could
not make any progress covering it and so we make a transaction
reservation when in a state that could potentially deadlock.

The new code only sets needed = 1 if the AIL and iclogs are empty
and so we know that covering can make progress, and hence we don't
take a transaction reservation in the situation where the AIL is
full and we have to block waiting for the AIL to make progress.
Instead, the caller (xfs_log_worker) will issue a log force that
will resolve the deadlock described above.

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
> 
> maybe just:
> 
> xlog_cil_empty(
> 	struct xlog	*log)
> {
> 	struct xfs_cil	*cil = log->l_cilp;
> 	bool		empty;
> 
> 	spin_lock(&cil->xc_push_lock);
> 	empty = list_empty(&cil->xc_cil);
> 	spin_unlock(&cil->xc_push_lock);
> 	return empty;
> }
> 
> but *shrug*  (That was Zach's idea) ;)

Sure, it's a bit cleaner. If I have to respin, I'll change it. :)

FWIW, there is one interesting side effect of this change - on an
idle filesystem, the log force counter goes up by 1 count every 30s,
but we don't do any IO because the log is - by definition - clean at
idle. Hence there's a slight change of behaviour of the counter but
we do not wake up the disk to do IO at all when in this state.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
