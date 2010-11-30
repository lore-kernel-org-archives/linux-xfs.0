Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAUKFtXX136300 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 14:15:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F1BB1B78D1
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 12:17:37 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id S61Ib3v6WwdbD1oF for
	<xfs@oss.sgi.com>; Tue, 30 Nov 2010 12:17:37 -0800 (PST)
Date: Tue, 30 Nov 2010 15:17:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] xfs: Pull EFI/EFD handling out from under the AIL lock
Message-ID: <20101130201734.GA16079@infradead.org>
References: <1290993152-20999-1-git-send-email-david@fromorbit.com>
	<1290993152-20999-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290993152-20999-2-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


 - xfs_efi_init needs to initialize efi_next_extent using ATOMIC_INIT
 - there is a behaviour change about the xfs_trans_del_item call
   in xfs_efi_item_unpin - before it was protected by the
   XFS_EFI_CANCELED which was never set, and now it's not.
 - what happened to XFS_EFI_RECOVERED?  You changed it to be indexed
   for the atomic bit-ops, but it's still used non-atomic in the log
   recovery code.
 - Why is XFS_EFI_COMMITTED cleared in xlog_recover_do_efi_trans,
   where it can't ever be set?
 - can you please add a shared helper for xfs_efi_item_unpin and
   xfs_efi_release, ala:

STATIC void
__xfs_efi_release(
	xfs_efi_log_item_t	*efip)
{
	if (!test_and_clear_bit(XFS_EFI_COMMITTED, &efip->efi_flags)) {
		struct xfs_ail          *ailp = efip->efi_item.li_ailp;

		spin_lock(&ailp->xa_lock);
		/* xfs_trans_ail_delete() drops the AIL lock. */
		xfs_trans_ail_delete(ailp, &efip->efi_item);
		xfs_efi_item_free(efip);
	}

   so that it's obvious they do the same release operation?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
