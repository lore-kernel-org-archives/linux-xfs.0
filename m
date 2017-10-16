Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27301 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754722AbdJPStp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 14:49:45 -0400
Date: Mon, 16 Oct 2017 11:49:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: Properly retry failed dquot items in case of
 error during buffer writeback
Message-ID: <20171016184938.GB4703@magnolia>
References: <20170825120752.22553-1-cmaiolino@redhat.com>
 <20170825170400.GS4796@magnolia>
 <20170825215701.GT4796@magnolia>
 <20170828092030.l5z2hruccr7ctvl3@hades.localdomain>
 <e982d98b-973d-1679-9236-57cee47aff07@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e982d98b-973d-1679-9236-57cee47aff07@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Oct 16, 2017 at 11:05:42AM +0800, Hou Tao wrote:
> Hi Carlos,
> 
> On 2017/8/28 17:20, Carlos Maiolino wrote:
> > Hi Darrick.
> > 
> > 
> >>>> BTW, This patch should be applied only over branch xfs-4.14-merge, it requires
> >>>> my previous patches, which are not in the master branch yet.
> >>>
> >>> Looks ok, but is there an xfstests case to cover this?
> >>
> > 
> > No,
> > 
> > I still don't have a xfstests to cover it, I couldn't reproduce the problem with
> > dquots yet, I'll focus more on this soon.
> I had written an xfstest case for the umount hang problem which is caused by the
> writeback of the dquota update, and it can be reproduced reliably. If you don't mind,
> i will clean it up and post to xfstest maillist this week.

I look forward to reviewing it.

--D

> 
> Regards,
> 
> Tao
> > 
> >>>>  	if ((lip->li_flags & XFS_LI_IN_AIL) &&
> >>>> -	    lip->li_lsn == qip->qli_flush_lsn) {
> >>>> +	   (lip->li_lsn == qip->qli_flush_lsn) ||
> >>>> +	    lip->li_flags & XFS_LI_FAILED) {
> >>
> > 
> >> ...come to think of it, shouldn't there be a couple extra pairs of parentheses
> >> in this somewhere?...
> >>
> > IIRC there is no need, && has a higher precedenc over ||, but I really don't
> > mind to add an extra pair of () here.
> > 
> >>>>  
> >>>>  		/* xfs_trans_ail_delete() drops the AIL lock. */
> >>>>  		spin_lock(&ailp->xa_lock);
> >>>> -		if (lip->li_lsn == qip->qli_flush_lsn)
> >>>> +		if (lip->li_lsn == qip->qli_flush_lsn) {
> >>>>  			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
> >>>> -		else
> >>>> +		} else if (lip->li_flags & XFS_LI_FAILED) {
> >>>> +			xfs_clear_li_failed(lip);
> >>>>  			spin_unlock(&ailp->xa_lock);
> >>>> +		} else {
> >>>> +			spin_unlock(&ailp->xa_lock);
> >>>> +		}
> >>>>  	}
> >>>>  
> >>>>  	/*
> >>>> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> >>>> index 2c7a1629e064..35fd6d71bc42 100644
> >>>> --- a/fs/xfs/xfs_dquot_item.c
> >>>> +++ b/fs/xfs/xfs_dquot_item.c
> >>>> @@ -137,6 +137,23 @@ xfs_qm_dqunpin_wait(
> >>>>  	wait_event(dqp->q_pinwait, (atomic_read(&dqp->q_pincount) == 0));
> >>>>  }
> >>>>  
> >>>> +/*
> >>>> + * Callback used to mark a buffer with XFS_LI_FAILED when items in the buffer
> >>>> + * have been failed during writeback
> >>>> + *
> >>>> + * this informs the AIL that the dquot is already flush locked on the next push,
> >>>> + * and acquires a hold on the buffer to ensure that it isn't reclaimed before
> >>>> + * dirty data makes it to disk.
> >>>> + */
> >>>> +STATIC void
> >>>> +xfs_dquot_item_error(
> >>>> +	struct xfs_log_item	*lip,
> >>>> +	struct xfs_buf		*bp)
> >>>> +{
> >>>> +	ASSERT(XFS_DQ_IS_LOCKED(DQUOT_ITEM(lip)->qli_item));
> >>
> >> ...and isn't this qli_dquot, not qli_item?
> >>
> > 
> > Yup, you are right.
> > 
> >> (Does this compile at all?)
> >>
> > 
> > Yes, it compiled the way it was :P
> > 
> > I'll wait for some extra comments here, before submitting a non-RFC patch, and
> > will think about how can I reproduce it on xfstests, maybe filling the
> > filesystem and then playing with quotas.
> > 
> > Thanks for the review Darrick.
> > 
> > Cheers.
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
