Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBK0wIKs031736 for <xfs@oss.sgi.com>; Sun, 19 Dec 2010 18:58:18 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2152A208953
	for <xfs@oss.sgi.com>; Sun, 19 Dec 2010 17:00:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	OKF2BwDNQ8HD2aCl for <xfs@oss.sgi.com>;
	Sun, 19 Dec 2010 17:00:13 -0800 (PST)
Date: Mon, 20 Dec 2010 12:00:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/9] xfs: Pull EFI/EFD handling out from under the AIL lock
Message-ID: <20101220010010.GI5193@dastard>
References: <1292214743-18073-1-git-send-email-david@fromorbit.com>
	<1292214743-18073-3-git-send-email-david@fromorbit.com>
	<20101217112254.GB12965@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101217112254.GB12965@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Dec 17, 2010 at 06:22:54AM -0500, Christoph Hellwig wrote:
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Some minor comments below:
> 
> > +STATIC void
> > +__xfs_efi_release(
> > +	struct xfs_efi_log_item	*efip)
> > +{
> > +	struct xfs_ail		*ailp = efip->efi_item.li_ailp;
> > +
> > +	if (!test_and_clear_bit(XFS_EFI_COMMITTED, &efip->efi_flags)) {
> > +		spin_lock(&ailp->xa_lock);
> > +		/* xfs_trans_ail_delete() drops the AIL lock. */
> > +		xfs_trans_ail_delete(ailp, (xfs_log_item_t *)efip);
> 
> The second argument should be &efip->efi_item to preserve ty;e safety.
> 
> >  void
> >  xfs_efi_release(xfs_efi_log_item_t	*efip,
> >  		uint			nextents)
> >  {
> > +	ASSERT(atomic_read(&efip->efi_next_extent) >= nextents);
> > +	if (!atomic_sub_and_test(nextents, &efip->efi_next_extent))
> > +		return;
> >  
> > +	__xfs_efi_release(efip);
> 
> Why not just:
> 
> 	if (atomic_sub_and_test(nextents, &efip->efi_next_extent))
> 		__xfs_efi_release(efip);
> 
> ?

Good idea. Fixed up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
