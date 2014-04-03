Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2FBFF7FAA
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 16:53:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1D4DE304064
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 14:53:35 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	4TvHzdxoo6bfhu7z for <xfs@oss.sgi.com>;
	Thu, 03 Apr 2014 14:53:33 -0700 (PDT)
Date: Fri, 4 Apr 2014 08:53:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: free the EFI entries from AIL on forced shutdown
Message-ID: <20140403215329.GR17603@dastard>
References: <20140325195733.510384972@sgi.com>
	<20140325195819.740387237@sgi.com> <20140403193414.GN16336@dastard>
	<533DC928.7080306@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <533DC928.7080306@sgi.com>
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

On Thu, Apr 03, 2014 at 03:48:40PM -0500, Mark Tinguely wrote:
> On 04/03/14 14:34, Dave Chinner wrote:
> >On Tue, Mar 25, 2014 at 03:06:35PM -0500, Mark Tinguely wrote:
> >>The extent free intention (EFI) and extent free done (EFD)
> >>log items are in separate transactions. It is possible that
> >>the EFI can be pushed to the AIL before a forced shutdown
> >>where it gets stuck for following reasons:
> >>
> >>  No complete EFD in the transaction. This can happen if the
> >>  transaction fails to reserve space or the freeing the extent
> >>  fails in xfs_bmap_finish().
> >>
> >>  EFD IOP Abort processing. If xfs_trans_cancel() is called with
> >>  an abort flag, or if the xfs_trans_commit() is called when the
> >>  file system is in forced shutdown or if the log buffer write fails,
> >>  then the EFD iop commands will not remove the EFI from the AIL.
> >>
> >>If the EFI entry is left on the AIL, xfs_ail_push all_sync() will
> >>fail to complete, the unmount will hang, and a reboot is required
> >>to get the complete the unmount.
> >>
> >>Do not free the EFI structure immediately on forced shutdowns, but
> >>instead use the IOP calls to match the EFI/EFD entries. A small
> >>wrinkle in the mix is the EFI is not automatically placed on the
> >>AIL by the IOP routines in the cases but may have made it to the
> >>AIL before the abort. We now have to check if the EFI is on the AIL
> >>in the abort IOP cases.
> >>
> >>Signed-off-by: Mark Tinguely<tinguely@sgi.com>
> >>---
> >>Dave, as I tried to explain, if the error in extent free happen early
> >>enough, the EFD is not usable and is not in the transaction to cause
> >>IOP commands to clean up the EFI. It too must be done manually.
> >>
> >>The "in the AIL" test must be done in the abort IOP commands.
> >
> >I still don't see the reason behind these assertions. It just
> >doesn't make any sense to me that it can't be handled once the EFI
> >has been attached to the EFD, nor why checking AIL status in
> >__xfs_efi_release() does not work correctly...
> >
> >>  fs/xfs/xfs_bmap_util.c    |   21 +++++++++++++++----
> >>  fs/xfs/xfs_extfree_item.c |   49 +++++++++++++++++++++++++++++++++-------------
> >>  fs/xfs/xfs_log_recover.c  |    3 +-
> >>  fs/xfs/xfs_trans.h        |    2 -
> >>  4 files changed, 56 insertions(+), 19 deletions(-)
> >>
> >>Index: b/fs/xfs/xfs_bmap_util.c
> >>===================================================================
> >>--- a/fs/xfs/xfs_bmap_util.c
> >>+++ b/fs/xfs/xfs_bmap_util.c
> >>@@ -116,12 +116,14 @@ xfs_bmap_finish(
> >>
> >>  	error = xfs_trans_reserve(ntp,&tres, 0, 0);
> >>  	if (error)
> >>-		return error;
> >>+		goto error_return;
> >>+
> >>  	efd = xfs_trans_get_efd(ntp, efi, flist->xbf_count);
> >>  	for (free = flist->xbf_first; free != NULL; free = next) {
> >>  		next = free->xbfi_next;
> >>-		if ((error = xfs_free_extent(ntp, free->xbfi_startblock,
> >>-				free->xbfi_blockcount))) {
> >>+		error = xfs_free_extent(ntp, free->xbfi_startblock,
> >>+				free->xbfi_blockcount);
> >>+		if (error) {
> >>  			/*
> >>  			 * The bmap free list will be cleaned up at a
> >>  			 * higher level.  The EFI will be canceled when
> >>@@ -136,13 +138,24 @@ xfs_bmap_finish(
> >>  						   (error == EFSCORRUPTED) ?
> >>  						   SHUTDOWN_CORRUPT_INCORE :
> >>  						   SHUTDOWN_META_IO_ERROR);
> >>-			return error;
> >>+			goto error_return;
> >>  		}
> >>  		xfs_trans_log_efd_extent(ntp, efd, free->xbfi_startblock,
> >>  			free->xbfi_blockcount);
> 
> ^^^^^^
>  here is where the EFD is placed in the transaction. It cannot be placed
>  in the transaction earlier because it is not complete.

No, that's wrong. The EFD is linked to the transaction in
xfs_trans_get_efd() where it calls xfs_trans_add_item(). The above
call is where it is logged (i.e. marked dirty), not where it is
added to the transaction.

> >This is inconsistent from a high level logic point of view. The EFI
> >is attached to the EFD after a call to xfs_trans_get_efd() and so
> >cleanup on failure should always occur through the IOP* interfaces
> >(specifically xfs_efd_item_unlock() with an aborted log item).
> >
> >The only case where a xfs_efi_release() call is required is the
> >xfs_trans_reserve() failure case, where nothing in the current
> >transaction context owns the reference on the EFI we are going to
> >pass to the EFD.
> 
> The EFD is not in the transaction in the failed xfs_extent_free
> failure case and there is not efd IOP call.

Yes it is. It may no be dirty, though.

> >>--- a/fs/xfs/xfs_extfree_item.c
> >>+++ b/fs/xfs/xfs_extfree_item.c
> >>@@ -56,15 +56,22 @@ xfs_efi_item_free(
> >>   */
> >>  STATIC void
> >>  __xfs_efi_release(
> >>-	struct xfs_efi_log_item	*efip)
> >>+	struct xfs_efi_log_item	*efip,
> >>+	int			abort)
> >>  {
> >>  	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
> >>
> >>  	if (atomic_dec_and_test(&efip->efi_refcount)) {
> >>  		spin_lock(&ailp->xa_lock);
> >>-		/* xfs_trans_ail_delete() drops the AIL lock. */
> >>-		xfs_trans_ail_delete(ailp,&efip->efi_item,
> >>-				     SHUTDOWN_LOG_IO_ERROR);
> >>+		/*
> >>+		 * The EFI may not be on the AIL on abort.
> >>+		 * xfs_trans_ail_delete() drops the AIL lock.
> >>+		 */
> >>+		if (abort)
> >>+			spin_unlock(&ailp->xa_lock);
> >>+		else
> >>+			xfs_trans_ail_delete(ailp,&efip->efi_item,
> >>+					     SHUTDOWN_LOG_IO_ERROR);
> >>  		xfs_efi_item_free(efip);
> >>  	}
> >>  }
> >
> >"Abort" is not necessary. If it's the last reference, and the EFI is
> >in the AIL, then it needs to be removed. i.e. the check shoul dbe
> >against XFS_LI_IN_AIL, not against a flag passed in by the caller.
> 
> You are mistaken. It may or may not be in the AIL.

No, I'm not mistaken - I'm talking about using a different
techinique to determine whether we need to remove the EFI from the
AIL or not.

That is, we have a flag on *every log item* that tells us whether
the item is in the AIL. It is guaranteed to be correct, and we use
it in many places to determine if the object we are about to free is
in the AIL and hence needs to be removed first. IOWs, we can use
introspection to remove the EFI from the AIL when the last reference
goes away.  The code is simply:

	if (atomic_dec_and_test(&efip->efi_refcount)) {
		spin_lock(&ailp->xa_lock);
		if (efip->efi_item.li_flags & XFS_LI_IN_AIL) {
			xfs_trans_ail_delete(ailp,&efip->efi_item,
					     SHUTDOWN_LOG_IO_ERROR);
		}
		spin_unlock(&ailp->xa_lock);
		xfs_efi_item_free(efip);
	}

No abort flag is needed.

Other examples of this exact same check being done in error handling
paths for various log item are xfs_iflush_abort(),
xfs_buf_item_unlock() and xfs_qm_dqflush().

> >>  	if (atomic_sub_and_test(nextents,&efip->efi_next_extent)) {
> >>-		__xfs_efi_release(efip);
> >>+		__xfs_efi_release(efip, abort);
> >>  		/* efip may now have been freed, do not reference it again. */
> >>  	}
> >>  }
> >>@@ -417,8 +426,19 @@ STATIC void
> >>  xfs_efd_item_unlock(
> >>  	struct xfs_log_item	*lip)
> >>  {
> >>-	if (lip->li_flags&  XFS_LI_ABORTED)
> >>-		xfs_efd_item_free(EFD_ITEM(lip));
> >>+	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
> >>+
> >>+	if (!(lip->li_flags&  XFS_LI_ABORTED))
> >>+		return;

BTW, your email program is still mangling quoted whitespace in the
code. Can you please fix it?

> >>+
> >>+	/* Free the EFI when aborting a commit. The EFI will be either
> >>+	 * added to the AIL in a CIL push before this abort or unlocked
> >>+	 * before the EFD unlock. In either case we can check the AIL
> >>+	 * status now.
> >>+	 */
> >
> >We are not freeing the EFI here - we are simply releasing the
> >reference the EFD holds on it because we are about to free the EFD.
> >Nothing else actually matters here - we don't care whether the EFI
> >is in the AIL or not, because that can be handled internally to
> >the xfs_efi_release() code....
> 
> Again. The EFI is in the previous commit. It could have made it to
> the AIL or is in the same abort.

You're still missing the point. It doesn't matter where the EFI is -
what matters is that we are freeing the object that holds a
reference to the EFI and so we have to drop it.

The point of using reference counting and introspection that no
caller needs to care about the internal state of the EFI, just that
they hold a reference that needs to be dropped. And that means
simpler code and that future modifications are much less likely to
screw up the EFI error handling.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
