Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D8C8D7F61
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 11:07:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B76048F8073
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 09:07:31 -0700 (PDT)
Date: Fri, 28 Mar 2014 12:07:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: remove efi from AIL in log recovery error
Message-ID: <20140328160719.GA15537@bfoster.bfoster>
References: <20140325195733.510384972@sgi.com>
	<20140325195819.638326569@sgi.com>
	<20140328152434.GB21961@bfoster.bfoster> <53359812.3090806@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53359812.3090806@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 28, 2014 at 10:41:06AM -0500, Mark Tinguely wrote:
> On 03/28/14 10:24, Brian Foster wrote:
> >On Tue, Mar 25, 2014 at 03:06:34PM -0500, Mark Tinguely wrote:
> >>xlog_recover_process_efi{s}() functions are completing the
> >>second half of xfs_bmap_finish() which frees extents. If this
> >>operation fails, the EFI will stay on the AIL and prevents
> >>the xfs_ail_push all_sync() from completing and the mount will
> >>fail to unmount.
> >>
> >>Rather than have a special log recovery flag XFS_EFI_RECOVERED
> >>to decrement the EFI/EFD counter, call the same decrement function
> >>from the log recovery routine that is called then the EFI is added
> >>to the AIL from a log write.
> >>
> >>Remove all other unprocessed EFIs from the log recovery AIL
> >>when one is discovered in error.
> >>
> >>Signed-off-by: Mark Tinguely<tinguely@sgi.com>
> >>---
> >>Rewritten with suggestions from Dave.
> >>Note: calling xfs_efi_item_unpin() seemed more explainatory than calling
> >>       the helper __xfs_efi_release().
> >>
> >>  fs/xfs/xfs_extfree_item.c |    9 +++------
> >>  fs/xfs/xfs_log_recover.c  |   28 +++++++++++++++-------------
> >>  fs/xfs/xfs_trans.h        |    1 +
> >>  3 files changed, 19 insertions(+), 19 deletions(-)
> >>
> >>Index: b/fs/xfs/xfs_extfree_item.c
> >>===================================================================
> >>--- a/fs/xfs/xfs_extfree_item.c
> >>+++ b/fs/xfs/xfs_extfree_item.c
> >>@@ -134,9 +134,10 @@ xfs_efi_item_pin(
> >>   * remove the EFI it's because the transaction has been canceled and by
> >>   * definition that means the EFI cannot be in the AIL so remove it from the
> >>   * transaction and free it.  Otherwise coordinate with xfs_efi_release()
> >>- * to determine who gets to free the EFI.
> >>+ * to determine who gets to free the EFI. Call from log recovery of EFI
> >>+ * entries so the EFD or error handling will remove the entry.
> >>   */
> >>-STATIC void
> >>+void
> >>  xfs_efi_item_unpin(
> >>  	struct xfs_log_item	*lip,
> >>  	int			remove)
> >>@@ -313,10 +314,6 @@ xfs_efi_release(xfs_efi_log_item_t	*efip
> >>  {
> >>  	ASSERT(atomic_read(&efip->efi_next_extent)>= nextents);
> >>  	if (atomic_sub_and_test(nextents,&efip->efi_next_extent)) {
> >>-		/* recovery needs us to drop the EFI reference, too */
> >>-		if (test_bit(XFS_EFI_RECOVERED,&efip->efi_flags))
> >>-			__xfs_efi_release(efip);
> >>-
> >>  		__xfs_efi_release(efip);
> >>  		/* efip may now have been freed, do not reference it again. */
> >>  	}
> >>Index: b/fs/xfs/xfs_log_recover.c
> >>===================================================================
> >>--- a/fs/xfs/xfs_log_recover.c
> >>+++ b/fs/xfs/xfs_log_recover.c
> >>@@ -3634,6 +3634,7 @@ xlog_recover_process_data(
> >>  /*
> >>   * Process an extent free intent item that was recovered from
> >>   * the log.  We need to free the extents that it describes.
> >>+ * The caller will release this and any following EFIs upon error.
> >>   */
> >>  STATIC int
> >>  xlog_recover_process_efi(
> >>@@ -3648,6 +3649,13 @@ xlog_recover_process_efi(
> >>  	xfs_fsblock_t		startblock_fsb;
> >>
> >>  	ASSERT(!test_bit(XFS_EFI_RECOVERED,&efip->efi_flags));
> >>+	set_bit(XFS_EFI_RECOVERED,&efip->efi_flags);
> >>+
> >>+	/*
> >>+	 * Decrement the EFI/EFD counter so the EFI is removed after
> >>+	 * processing the EFD or error handling in the caller.
> >>+	 */
> >>+	xfs_efi_item_unpin(&efip->efi_item, 0);
> >>
> >>  	/*
> >>  	 * First check the validity of the extents described by the
> >>@@ -3662,12 +3670,6 @@ xlog_recover_process_efi(
> >>  		    (extp->ext_len == 0) ||
> >>  		    (startblock_fsb>= mp->m_sb.sb_dblocks) ||
> >>  		    (extp->ext_len>= mp->m_sb.sb_agblocks)) {
> >>-			/*
> >>-			 * This will pull the EFI from the AIL and
> >>-			 * free the memory associated with it.
> >>-			 */
> >>-			set_bit(XFS_EFI_RECOVERED,&efip->efi_flags);
> >>-			xfs_efi_release(efip, efip->efi_format.efi_nextents);
> >>  			return XFS_ERROR(EIO);
> >>  		}
> >>  	}
> >>@@ -3687,7 +3689,6 @@ xlog_recover_process_efi(
> >>  					 extp->ext_len);
> >>  	}
> >>
> >>-	set_bit(XFS_EFI_RECOVERED,&efip->efi_flags);
> >>  	error = xfs_trans_commit(tp, 0);
> >>  	return error;
> >>
> >>@@ -3718,8 +3719,8 @@ STATIC int
> >>  xlog_recover_process_efis(
> >>  	struct xlog	*log)
> >>  {
> >>-	xfs_log_item_t		*lip;
> >>-	xfs_efi_log_item_t	*efip;
> >>+	struct xfs_log_item	*lip;
> >>+	struct xfs_efi_log_item	*efip;
> >>  	int			error = 0;
> >>  	struct xfs_ail_cursor	cur;
> >>  	struct xfs_ail		*ailp;
> >>@@ -3750,13 +3751,14 @@ xlog_recover_process_efis(
> >>  		}
> >>
> >>  		spin_unlock(&ailp->xa_lock);
> >>-		error = xlog_recover_process_efi(log->l_mp, efip);
> >>-		spin_lock(&ailp->xa_lock);
> >>+		/* Skip all EFIs after first EFI in error. */
> >>+		if (!error)
> >>+			error = xlog_recover_process_efi(log->l_mp, efip);
> >>  		if (error)
> >>-			goto out;
> >>+			xfs_efi_release(efip, efip->efi_format.efi_nextents);
> >
> >Hi Mark,
> >
> >If we hit the scenario where we start skipping EFIs after an error, is
> >the equivalent unpin() call from process_efi() not necessary on the
> >subsequent EFIs?
> >
> >Brian
> 
> yes, good catch. They will have to be decremented twice. something like:
> +		if (!error)
> +			error = xlog_recover_process_efi(log->l_mp, efip);
> +		else
> +			xfs_efi_item_unpin(&efip->efi_item, 0);
> +		if (error)
> ...
> 

Ok, looks reasonable to me. An extra sentence or two in the previous
comment to explain what's going on there would be nice as well. ;)

Brian

> --Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
