Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 357497F59
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 07:10:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A933CAC002
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 05:10:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 735WDGbw4NYUw2o7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 05:10:26 -0700 (PDT)
Date: Fri, 7 Aug 2015 08:10:24 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 06/11] xfs: don't leave EFIs on AIL on mount failure
Message-ID: <20150807121024.GE8322@bfoster.bfoster>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-7-git-send-email-bfoster@redhat.com>
	<20150807022336.GF16638@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150807022336.GF16638@dastard>
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

On Fri, Aug 07, 2015 at 12:23:36PM +1000, Dave Chinner wrote:
> On Thu, Aug 06, 2015 at 01:44:27PM -0400, Brian Foster wrote:
> > Log recovery occurs in two phases at mount time. In the first phase,
> > EFIs and EFDs are processed and potentially cancelled out. EFIs without
> > EFD objects are inserted into the AIL for processing and recovery in the
> > second phase. xfs_mountfs() runs various other operations between the
> > phases and is thus subject to failure. If failure occurs after the first
> > phase but before the second, pending EFIs sit on the AIL, pin it and
> > cause the mount to hang.
> > 
> > Update the mount sequence to ensure that pending EFIs are cancelled in
> > the event of failure. Add a recovery cancellation mechanism to iterate
> > the AIL and cancel all EFI items when requested. Plumb cancellation
> > support through the log mount finish helper and update xfs_mountfs() to
> > invoke cancellation in the event of failure after recovery has started.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c         | 16 +++++++++++-----
> >  fs/xfs/xfs_log.h         |  2 +-
> >  fs/xfs/xfs_log_priv.h    |  2 ++
> >  fs/xfs/xfs_log_recover.c | 41 ++++++++++++++++++++++++++++++++++++-----
> >  fs/xfs/xfs_mount.c       | 35 +++++++++++++++++++++++------------
> >  5 files changed, 73 insertions(+), 23 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 6b5a84a..522286c 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -740,19 +740,25 @@ out:
> >   * it.
> >   */
> >  int
> > -xfs_log_mount_finish(xfs_mount_t *mp)
> > +xfs_log_mount_finish(
> > +	struct xfs_mount	*mp,
> > +	bool			cancel)
> >  {
> >  	int	error = 0;
> >  
> > -	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
> > +	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> > +		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> > +		return 0;
> > +	}
> > +
> > +	if (cancel) {
> > +		error = xlog_recover_cancel(mp->m_log);
> > +	} else {
> >  		error = xlog_recover_finish(mp->m_log);
> >  		if (!error)
> >  			xfs_log_work_queue(mp);
> > -	} else {
> > -		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> >  	}
> >  
> > -
> >  	return error;
> >  }
> 
> As I mentioned on #xfs, I don't think the error/cancel path needs to
> go through this function. Add a new function xfs_log_mount_cancel(),
> and put the contents of xlog_recover_cancel() inside it, along with
> the log unmount function...
> 

Ok.

> (General rule: prefix "xfs_log_....()" is for functions that call
> into the log from outside, passing a struct xfs_mount. prefix
> "xlog_...()" is for internal calls, passing a struct xlog.)
> 

Sure, xlog_recover_cancel() was just intended to be consistent with
xlog_recover_finish().

> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index a74ff68..a7ba078 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -3823,10 +3823,11 @@ abort_error:
> >   */
> >  STATIC int
> >  xlog_recover_process_efis(
> > -	struct xlog	*log)
> > +	struct xlog		*log,
> > +	bool			cancel)
> >  {
> > -	xfs_log_item_t		*lip;
> > -	xfs_efi_log_item_t	*efip;
> > +	struct xfs_log_item	*lip;
> > +	struct xfs_efi_log_item	*efip;
> >  	int			error = 0;
> >  	struct xfs_ail_cursor	cur;
> >  	struct xfs_ail		*ailp;
> > @@ -3847,10 +3848,24 @@ xlog_recover_process_efis(
> >  			break;
> >  		}
> >  
> > +		efip = (struct xfs_efi_log_item *) lip;
> > +
> > +		/*
> > +		 * A cancel occurs when the mount has failed and we're bailing
> > +		 * out. Release all pending EFIs so they don't pin the AIL.
> > +		 */
> > +		if (cancel) {
> > +			spin_unlock(&ailp->xa_lock);
> > +			xfs_efi_release(efip);
> > +			spin_lock(&ailp->xa_lock);
> > +
> > +			lip = xfs_trans_ail_cursor_next(ailp, &cur);
> > +			continue;
> > +		}
> 
> This might be better to separate into a xlog_recover_cancel_efis()
> function because this is much simpler than the rest of the loop.
> It may be more code, but its simpler to read and understand.
> 

That was my first instinct, I just didn't want to duplicate the list
processing and whatnot once I looked at it. I'll see how it looks.

> > +
> >  		/*
> >  		 * Skip EFIs that we've already processed.
> >  		 */
> > -		efip = (xfs_efi_log_item_t *)lip;
> >  		if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags)) {
> >  			lip = xfs_trans_ail_cursor_next(ailp, &cur);
> >  			continue;
> > @@ -4617,8 +4632,13 @@ xlog_recover_finish(
> >  	 */
> >  	if (log->l_flags & XLOG_RECOVERY_NEEDED) {
> >  		int	error;
> > -		error = xlog_recover_process_efis(log);
> > +		error = xlog_recover_process_efis(log, false);
> >  		if (error) {
> > +			/*
> > +			 * We could still have pending EFIs. Cancel them so we
> > +			 * don't hang...
> > +			 */
> > +			xlog_recover_process_efis(log, true);
> 
> Not actually necessary. We don't clear the XLOG_RECOVERY_NEEDED
> flag, so when the error stack is run in xfs_mountfs(), we will
> call xfs_log_mount_cancel(), it will see the XLOG_RECOVERY_NEEDED
> and run xlog_recover_cancel_efis()....
> 

Ok.

> >  			xfs_alert(log->l_mp, "Failed to recover EFIs");
> >  			return error;
> >  		}
> > @@ -4644,6 +4664,17 @@ xlog_recover_finish(
> >  	return 0;
> >  }
> >  
> > +int
> > +xlog_recover_cancel(
> > +	struct xlog	*log)
> > +{
> > +	int		error = 0;
> > +
> > +	if (log->l_flags & XLOG_RECOVERY_NEEDED)
> > +		error = xlog_recover_process_efis(log, true);
> > +
> > +	return error;
> > +}
> 
> void
> xfs_log_mount_cancel(
> 	struct xfs_mount	*mp)
> {
> 	int		error = 0;
> 
> 	if (log->l_flags & XLOG_RECOVERY_NEEDED)
> 		xlog_recover_cancel_efis(log);
> 
> 	xfs_log_unmount(mp);
> 	return error;
> }
> 
> > @@ -799,7 +800,10 @@ xfs_mountfs(
> >  	}
> >  
> >  	/*
> > -	 * log's mount-time initialization. Perform 1st part recovery if needed
> > +	 * Log's mount-time initialization. The first part of recovery can place
> > +	 * some items on the AIL, to be handled when recovery is finished. Set
> > +	 * the cancel flag to ensure that the recovery is cancelled should we
> > +	 * fail before then.
> >  	 */
> >  	error = xfs_log_mount(mp, mp->m_logdev_targp,
> >  			      XFS_FSB_TO_DADDR(mp, sbp->sb_logstart),
> > @@ -808,6 +812,7 @@ xfs_mountfs(
> >  		xfs_warn(mp, "log mount failed");
> >  		goto out_fail_wait;
> >  	}
> > +	log_mount_cancel = true;
> 
> At this point, XLOG_RECOVERY_NEEDED will be set if EFI processing is
> required, so a variable to track this here is not needed.
> 

Indeed, I didn't notice how XLOG_RECOVERY_NEEDED was used here. This
seems much cleaner.

> > @@ -910,11 +915,15 @@ xfs_mountfs(
> >  	}
> >  
> >  	/*
> > -	 * Finish recovering the file system.  This part needed to be
> > -	 * delayed until after the root and real-time bitmap inodes
> > -	 * were consistently read in.
> > +	 * Finish recovering the file system.  This part needed to be delayed
> > +	 * until after the root and real-time bitmap inodes were consistently
> > +	 * read in.
> > +	 *
> > +	 * Reset the cancel flag as the finish cleans up after itself on
> > +	 * failure.
> >  	 */
> > -	error = xfs_log_mount_finish(mp);
> > +	log_mount_cancel = false;
> > +	error = xfs_log_mount_finish(mp, false);
> >  	if (error) {
> >  		xfs_warn(mp, "log mount finish failed");
> >  		goto out_rtunmount;
> 
> xfs_log_mount_finish() will clear the XLOG_RECOVERY_NEEDED. On
> error, we jump into the error stack above the call to
> xfs_log_mount_cancel(), so it will handle the cleanup....
> 
> > @@ -956,6 +965,8 @@ xfs_mountfs(
> >   out_rele_rip:
> >  	IRELE(rip);
> >   out_log_dealloc:
> > +	if (log_mount_cancel)
> > +		xfs_log_mount_finish(mp, true);
> >  	xfs_log_unmount(mp);
> 
> And this just becomes a call to xfs_log_mount_cancel().
> 
> I hope this is a bit clearer that mud ;)
> 

I think I follow.. thanks.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
