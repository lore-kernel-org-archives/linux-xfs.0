Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C50477F73
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2014 18:14:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57859AC005
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2014 16:14:00 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qZ75vlujP3CEEoSo for <xfs@oss.sgi.com>;
	Thu, 20 Mar 2014 16:13:57 -0700 (PDT)
Date: Fri, 21 Mar 2014 10:11:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: free the EFI entries from AIL on forced shutdown
Message-ID: <20140320231101.GN7072@dastard>
References: <20140314163723.916178776@sgi.com> <20140317052951.GE7072@dastard>
	<532B45E1.3060309@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <532B45E1.3060309@sgi.com>
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

On Thu, Mar 20, 2014 at 02:47:45PM -0500, Mark Tinguely wrote:
> On 03/17/14 00:29, Dave Chinner wrote:
> >On Fri, Mar 14, 2014 at 11:37:01AM -0500, Mark Tinguely wrote:
> >>@@ -439,10 +446,15 @@ xfs_efd_item_committed(
> >>  	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
> >>
> >>  	/*
> >>-	 * If we got a log I/O error, it's always the case that the LR with the
> >>-	 * EFI got unpinned and freed before the EFD got aborted.
> >>+	 * If we got a log I/O error and the EFI is also in this buffer, it
> >>+	 * will be unpinned and freed before the EFD got aborted. But the EFI
> >>+	 * is in an earlier transaction and could be on the AIL when the log
> >>+	 * I/O error happened for this EFD. In that case, manually remove the
> >>+	 * remaining EFIs from the AIL.
> >>  	 */
> >>-	if (!(lip->li_flags&  XFS_LI_ABORTED))
> >>+	if (lip->li_flags&  XFS_LI_ABORTED)
> >>+		xfs_efi_clear_ail(lip->li_ailp);
> >>+	else
> >>  		xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
> >
> >Same here - we can simply always call xfs_efi_release() and we'll
> >end up doing the right thing w.r.t. the EFi reference count.
> >
> >And if we do the right thing with the EFI reference count when
> >aborting the EFI (i.e. call __xfs_efi_release() rather than freeing
> >it) the aborting of transactions will correctly free all the
> >references to the EFI and remove them from the AIL.
> 
> This is fine if the EFI made it to the AIL before the log abort -
> which it may or may not have done.
> 
> Log errors will not force the log. The call to
> xfs_trans_committed_bulk() with the abort flag set will not place
> the EFI on the AIL (takes the iop_unpin/continue path).

Sure - we don't want it added to the AIL on abort. Instead, we want
the reference count that was intended for the AIL to be dropped when
we abort the object so that we can free the object when the last
reference count goes away.

> Your proposal of changing xfs_efi_committed() from freeing the EFI
> to a call to __xfs_efi_release() and changing xfs_efd_committed() to
> xfs_efi_release() will do the right thing for the counters and
> removing both the EFI/EFD entries, but it will also want to remove
> the non-existent EFI entry from the AIL. I do not like adding the
> EFI to the AIL in the abort path.

If the EFI is not in the AIL, then don't try to remove it from the
AIL.  We do this for all sorts of objects on abort/shutdown. e.g.
the abort path in xfs_buf_item_unlock() checks if the item is in the
AIL before removing it. We do the same when flushing a dquot and a
shutdown is encountered. Same for aborting an inode flush, or
completing an inode cluster freeing.

> >The only case we
> >then have to handle specially is the xfs_trans_reserve failure in
> >xfs_bmap_finish(), where we need to release the EFI directly in the
> >error path.
> 
> any reason to not move the efd creation earlier to not special case it?

You can't join objects to a transaction before you've reserved space
for the transaction.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
