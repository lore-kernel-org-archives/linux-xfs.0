Return-Path: <SRS0=FhJw=5Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FFEC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Mar 2020 00:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC27420786
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Mar 2020 00:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbgCaAEP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Mar 2020 20:04:15 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42820 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728876AbgCaAEP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Mar 2020 20:04:15 -0400
Received: from dread.disaster.area (pa49-179-23-206.pa.nsw.optusnet.com.au [49.179.23.206])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 66ACB3A360D;
        Tue, 31 Mar 2020 11:04:11 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jJ4O1-0005tr-Kx; Tue, 31 Mar 2020 11:04:09 +1100
Date:   Tue, 31 Mar 2020 11:04:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: trylock underlying buffer on dquot flush
Message-ID: <20200331000409.GY10776@dread.disaster.area>
References: <20200326131703.23246-1-bfoster@redhat.com>
 <20200326131703.23246-2-bfoster@redhat.com>
 <20200329224602.GT10776@dread.disaster.area>
 <20200330121544.GA45961@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330121544.GA45961@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=n/Z79dAqQwRlp4tcgfhWYA==:117 a=n/Z79dAqQwRlp4tcgfhWYA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=q1PIFzU4UbI7DRarK_cA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 30, 2020 at 08:15:44AM -0400, Brian Foster wrote:
> On Mon, Mar 30, 2020 at 09:46:02AM +1100, Dave Chinner wrote:
> > On Thu, Mar 26, 2020 at 09:17:02AM -0400, Brian Foster wrote:
> > > A dquot flush currently blocks on the buffer lock for the underlying
> > > dquot buffer. In turn, this causes xfsaild to block rather than
> > > continue processing other items in the meantime. Update
> > > xfs_qm_dqflush() to trylock the buffer, similar to how inode buffers
> > > are handled, and return -EAGAIN if the lock fails. Fix up any
> > > callers that don't currently handle the error properly.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_dquot.c      |  6 +++---
> > >  fs/xfs/xfs_dquot_item.c |  3 ++-
> > >  fs/xfs/xfs_qm.c         | 14 +++++++++-----
> > >  3 files changed, 14 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > > index 711376ca269f..af2c8e5ceea0 100644
> > > --- a/fs/xfs/xfs_dquot.c
> > > +++ b/fs/xfs/xfs_dquot.c
> > > @@ -1105,8 +1105,8 @@ xfs_qm_dqflush(
> > >  	 * Get the buffer containing the on-disk dquot
> > >  	 */
> > >  	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
> > > -				   mp->m_quotainfo->qi_dqchunklen, 0, &bp,
> > > -				   &xfs_dquot_buf_ops);
> > > +				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
> > > +				   &bp, &xfs_dquot_buf_ops);
> > >  	if (error)
> > >  		goto out_unlock;
> > >  
> > > @@ -1177,7 +1177,7 @@ xfs_qm_dqflush(
> > >  
> > >  out_unlock:
> > >  	xfs_dqfunlock(dqp);
> > > -	return -EIO;
> > > +	return error;
> > >  }
> > >  
> > >  /*
> > > diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> > > index cf65e2e43c6e..baad1748d0d1 100644
> > > --- a/fs/xfs/xfs_dquot_item.c
> > > +++ b/fs/xfs/xfs_dquot_item.c
> > > @@ -189,7 +189,8 @@ xfs_qm_dquot_logitem_push(
> > >  		if (!xfs_buf_delwri_queue(bp, buffer_list))
> > >  			rval = XFS_ITEM_FLUSHING;
> > >  		xfs_buf_relse(bp);
> > > -	}
> > > +	} else if (error == -EAGAIN)
> > > +		rval = XFS_ITEM_LOCKED;
> > 
> > Doesn't xfs_inode_item_push() also have this problem in that it
> > doesn't handle -EAGAIN properly?
> > 
> > Also, we can get -EIO, -EFSCORRUPTED, etc here. They probably
> > shouldn't return XFS_ITEM_SUCCESS, either....
> > 
> 
> Good point. I'm actually not sure what we should return in that case
> given the item return codes all seem to assume a valid state. We could
> define an XFS_ITEM_ERROR return, but I'm not sure it's worth it for what
> is currently stat/tracepoint logic in the caller.  Perhaps a broader
> rework of error handling in this context is in order that would lift
> generic (fatal) error handling into xfsaild.

Yeah, that's where my thoughts were heading as well.

> E.g., I see that
> xfs_qm_dqflush() is inconsistent by itself in that the item is removed
> from the AIL if we're already shut down, but not if that function
> invokes the shutdown; we shutdown if the direct xfs_dqblk_verify() call
> fails but not if the read verifier (which also looks like it calls
> xfs_dqblk_verify() on every on-disk dquot) returns -EFSCORRUPTED, etc.
> It might make some sense to let iop_push() return negative error codes
> if that facilitates consistent error handling...

Yes, it's a bit of a mess. I suspect that what we should be doing
here is pulling the failed buffer write retry code up into the main
push loop. That is, we can set LI_FAILED on log items that fail to
flush, either directly at submit time, or at IO completion for write
errors.

Then we can have the main AIL loop set LI_FAILED on push failures,
and also the main loop detect LI_FAILED directly and call a new
->iop_resubmit() function rather than having to handle that the
resubmit cases as special cases in every ->iop_push() path.

That seems like a much cleaner way of handling submission failure
and retries for all log item types that need it compared to the way
we currently handle it for buffers...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
