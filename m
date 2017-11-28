Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751144AbdK1JtI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Nov 2017 04:49:08 -0500
Date: Tue, 28 Nov 2017 17:49:04 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs: Properly retry failed dquot items in case of error
 during buffer writeback
Message-ID: <20171128094904.GI2749@eguan.usersys.redhat.com>
References: <20171124120353.30997-1-cmaiolino@redhat.com>
 <20171127184323.GE19379@magnolia>
 <20171128094319.bghcrpheht7fgyeo@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128094319.bghcrpheht7fgyeo@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Hou Tao <houtao1@huawei.com>

On Tue, Nov 28, 2017 at 10:43:19AM +0100, Carlos Maiolino wrote:
> > >  	if ((lip->li_flags & XFS_LI_IN_AIL) &&
> > > -	    lip->li_lsn == qip->qli_flush_lsn) {
> > > +	   ((lip->li_lsn == qip->qli_flush_lsn) ||
> > > +	    lip->li_flags & XFS_LI_FAILED)) {
> > 
> > /me continues to grouse about the lack of parentheses around the LI_FAILED
> > test...
> 
> D'oh, I understood you meant parenthesis in another place, I've got it now :)
> 
> 
> > 
> > >  
> > >  		/* xfs_trans_ail_delete() drops the AIL lock. */
> > >  		spin_lock(&ailp->xa_lock);
> > > -		if (lip->li_lsn == qip->qli_flush_lsn)
> > > +		if (lip->li_lsn == qip->qli_flush_lsn) {
> > >  			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
> > > -		else
> > > +		} else if (lip->li_flags & XFS_LI_FAILED) {
> > > +			xfs_clear_li_failed(lip);
> > >  			spin_unlock(&ailp->xa_lock);
> > > +		} else {
> > > +			spin_unlock(&ailp->xa_lock);
> > > +		}
> > >  	}
> > >  
> > >  	/*
> > > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > > index 2c7a1629e064..3d73a0124988 100644
> > > --- a/fs/xfs/xfs_dquot_item.c
> > > +++ b/fs/xfs/xfs_dquot_item.c
> > > @@ -137,6 +137,24 @@ xfs_qm_dqunpin_wait(
> > >  	wait_event(dqp->q_pinwait, (atomic_read(&dqp->q_pincount) == 0));
> > >  }
> > >  
> > > +/*
> > > + * Callback used to mark a buffer with XFS_LI_FAILED when items in the buffer
> > > + * have been failed during writeback
> > > + *
> > > + * this informs the AIL that the dquot is already flush locked on the next push,
> > > + * and acquires a hold on the buffer to ensure that it isn't reclaimed before
> > > + * dirty data makes it to disk.
> > > + */
> > > +STATIC void
> > > +xfs_dquot_item_error(
> > > +	struct xfs_log_item	*lip,
> > > +	struct xfs_buf		*bp)
> > > +{
> > > +	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
> > 
> > Need blank line between variable definition and other code.
> > 
> 
> ok
> 
> > > +	ASSERT(!completion_done(&dqp->q_flush));
> > > +	xfs_set_li_failed(lip, bp);
> > > +}
> > > +
> > >  STATIC uint
> > >  xfs_qm_dquot_logitem_push(
> > >  	struct xfs_log_item	*lip,
> > > @@ -144,13 +162,28 @@ xfs_qm_dquot_logitem_push(
> > >  					      __acquires(&lip->li_ailp->xa_lock)
> > >  {
> > >  	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
> > > -	struct xfs_buf		*bp = NULL;
> > > +	struct xfs_buf		*bp = lip->li_buf;
> > >  	uint			rval = XFS_ITEM_SUCCESS;
> > >  	int			error;
> > >  
> > >  	if (atomic_read(&dqp->q_pincount) > 0)
> > >  		return XFS_ITEM_PINNED;
> > >  
> > > +	/*
> > > +	 * The buffer containing this item failed to be written back
> > > +	 * previously. Resubmit the buffer for IO
> > > +	 */
> > > +	if (lip->li_flags & XFS_LI_FAILED) {
> > > +		if (!xfs_buf_trylock(bp))
> > > +			return XFS_ITEM_LOCKED;
> > > +
> > > +		if (!xfs_buf_resubmit_failed_buffers(bp, lip, buffer_list))
> > > +			rval = XFS_ITEM_FLUSHING;
> > > +
> > > +		xfs_buf_unlock(bp);
> > > +		return rval;
> > > +	}
> > > +
> > >  	if (!xfs_dqlock_nowait(dqp))
> > >  		return XFS_ITEM_LOCKED;
> > >  
> > > @@ -242,7 +275,8 @@ static const struct xfs_item_ops xfs_dquot_item_ops = {
> > >  	.iop_unlock	= xfs_qm_dquot_logitem_unlock,
> > >  	.iop_committed	= xfs_qm_dquot_logitem_committed,
> > >  	.iop_push	= xfs_qm_dquot_logitem_push,
> > > -	.iop_committing = xfs_qm_dquot_logitem_committing
> > > +	.iop_committing = xfs_qm_dquot_logitem_committing,
> > > +	.iop_error	= xfs_dquot_item_error
> > >  };
> > 
> > Otherwise looks ok; what was the xfstest for this patch?
> > 
> 
> Eryu didn't push the test yet, and I think they didn't end up on a final version
> yet, the test is here:

Correct, because this is a test results in hang/crash, we need the fix
goes to upstream first, and there was no fix available when reviewing
the test.

> 
> https://patchwork.kernel.org/patch/10050313/
> 
> It's part of a 4patches patchset series btw.

The v3 patchset needs a few minor updates, then I'm glad to push it once
the fix is upstream :)

Thanks,
Eryu

> 
> I'll submit the fixes you mentioned soon
> 
> > --D
> > 
> > >  
> > >  /*
> > > -- 
> > > 2.14.3
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
