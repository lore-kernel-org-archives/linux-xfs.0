Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757294AbdELLh3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 May 2017 07:37:29 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F4DE68A7
        for <linux-xfs@vger.kernel.org>; Fri, 12 May 2017 11:37:29 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D1987E491
        for <linux-xfs@vger.kernel.org>; Fri, 12 May 2017 11:37:29 +0000 (UTC)
Date: Fri, 12 May 2017 07:37:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170512113727.GB15623@bfoster.bfoster>
References: <20170511135733.21765-1-cmaiolino@redhat.com>
 <20170511135733.21765-3-cmaiolino@redhat.com>
 <20170511170805.GB14148@localhost.localdomain>
 <20170512082135.g6vd4vvxlctmtptq@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170512082135.g6vd4vvxlctmtptq@eorzea.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Fri, May 12, 2017 at 10:21:35AM +0200, Carlos Maiolino wrote:
> On Thu, May 11, 2017 at 01:08:05PM -0400, Brian Foster wrote:
> > On Thu, May 11, 2017 at 03:57:33PM +0200, Carlos Maiolino wrote:
> > > When a buffer has been failed during writeback, the inode items into it
> > > are kept flush locked, and are never resubmitted due the flush lock, so,
> > > if any buffer fails to be written, the items in AIL are never written to
> > > disk and never unlocked.
> > > 
> > > This causes a filesystem to be unmountable due these items flush locked
> > > in AIL, but this also causes the items in AIL to never be written back,
> > > even when the IO device comes back to normal.
> > > 
> > > I've been testing this patch with a DM-thin device, creating a
> > > filesystem larger than the real device.
> > > 
> > > When writing enough data to fill the DM-thin device, XFS receives ENOSPC
> > > errors from the device, and keep spinning on xfsaild (when 'retry
> > > forever' configuration is set).
> > > 
> > > At this point, the filesystem is unmountable because of the flush locked
> > > items in AIL, but worse, the items in AIL are never retried at all
> > > (once xfs_inode_item_push() will skip the items that are flush locked),
> > > even if the underlying DM-thin device is expanded to the proper size.
> > > 
> > > This patch fixes both cases, retrying any item that has been failed
> > > previously, using the infra-structure provided by the previous patch.
> > > 
> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > ---
> > > 
> > > This same problem is also possible in dquot code, but the fix is almost
> > > identical.
> > > 
> > > I am not submitting a fix for dquot yet to avoid the need to create VX for both
> > > patches, once we agree with the solution, I'll submit a fix to dquot.
> > > 
> > >  fs/xfs/xfs_inode_item.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 53 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > > index 08cb7d1..583fa9e 100644
> > > --- a/fs/xfs/xfs_inode_item.c
> > > +++ b/fs/xfs/xfs_inode_item.c
> > > @@ -475,6 +475,21 @@ xfs_inode_item_unpin(
> > >  		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
> > >  }
> > >  
> > > +STATIC void
> > > +xfs_inode_item_error(
> > > +	struct xfs_log_item	*lip,
> > > +	unsigned int		bflags)
> > > +{
> > > +
> > > +	/*
> > > +	 * The buffer writeback containing this inode has been failed
> > > +	 * mark it as failed and unlock the flush lock, so it can be retried
> > > +	 * again
> > > +	 */
> > > +	if (bflags & XBF_WRITE_FAIL)
> > > +		lip->li_flags |= XFS_LI_FAILED;
> > > +}
> > > +
> > >  STATIC uint
> > >  xfs_inode_item_push(
> > >  	struct xfs_log_item	*lip,
> > > @@ -517,8 +532,44 @@ xfs_inode_item_push(
> > >  	 * the AIL.
> > >  	 */
> > >  	if (!xfs_iflock_nowait(ip)) {
> > > +		if (lip->li_flags & XFS_LI_FAILED) {
> > > +
> > > +			struct xfs_dinode	*dip;
> > > +			struct xfs_log_item	*next;
> > > +			int			error;
> > > +
> > > +			error = xfs_imap_to_bp(ip->i_mount, NULL, &ip->i_imap,
> > > +					       &dip, &bp, XBF_TRYLOCK, 0);
> > > +
> > > +			if (error) {
> > > +				rval = XFS_ITEM_FLUSHING;
> > > +				goto out_unlock;
> > > +			}
> > > +
> > > +			if (!(bp->b_flags & XBF_WRITE_FAIL)) {
> > > +				rval = XFS_ITEM_FLUSHING;
> > > +				xfs_buf_relse(bp);
> > > +				goto out_unlock;
> > > +			}

I think I glossed over this on my first pass, but I don't think we need
to (or should) check XBF_WRITE_FAIL here or in the error handler. It's a
flag used to control the internal retry and that is kind of irrelevant
to this mechanism. Unless I'm missing something.. I don't think this
state can occur..?

Brian

> > > +
> > > +			while (lip != NULL) {
> > > +				next = lip->li_bio_list;
> > > +
> > > +				if (lip->li_flags & XFS_LI_FAILED)
> > > +					lip->li_flags &= XFS_LI_FAILED;
> > 
> > Eric already pointed out that you probably intend to clear the flag
> > here..?
> > 
> 
> Yup, my bad.
> 
> > > +				lip = next;
> > > +			}
> > 
> > This whole hunk might be better off in a helper function (with the
> > comment Eric suggested as well).
> >
> 
> Agreed, a helper function can be used here and in dquot code as well, so I agree
> that a helper function can be useful, I'll try to make it a common code for both
> dquot and inode items.
>  
> > Those points and the ->iop_error() thing aside, this otherwise seems Ok
> > to me.
> >
> 
>  
> > Brian
> > 
> > > +
> > > +			if (!xfs_buf_delwri_queue(bp, buffer_list))
> > > +				rval = XFS_ITEM_FLUSHING;
> > > +
> > > +			xfs_buf_relse(bp);
> > > +			goto out_unlock;
> > > +		}
> > > +
> > >  		rval = XFS_ITEM_FLUSHING;
> > >  		goto out_unlock;
> > > +
> > >  	}
> > >  
> > >  	ASSERT(iip->ili_fields != 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
> > > @@ -622,7 +673,8 @@ static const struct xfs_item_ops xfs_inode_item_ops = {
> > >  	.iop_unlock	= xfs_inode_item_unlock,
> > >  	.iop_committed	= xfs_inode_item_committed,
> > >  	.iop_push	= xfs_inode_item_push,
> > > -	.iop_committing = xfs_inode_item_committing
> > > +	.iop_committing = xfs_inode_item_committing,
> > > +	.iop_error	= xfs_inode_item_error
> > >  };
> > >  
> > >  
> > > -- 
> > > 2.9.3
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
