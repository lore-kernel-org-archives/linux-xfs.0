Return-Path: <SRS0=eBbo=5M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5364BC43331
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 16:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AF8420857
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Mar 2020 16:46:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YXTM5DuB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgC0Qqu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 12:46:50 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:59695 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727287AbgC0Qqu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Mar 2020 12:46:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585327609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/FsKA/JbkUr4S25CqfVQlbXbJACon39WTLHQ7OeI8r8=;
        b=YXTM5DuBj42D45b/WMq3IupXokiWm0L/eTwVNdNMsRvZXHtRq/l9QMA00GAecweKF/CEG6
        lMEsoSt5VC8YqubjGfZCwrzhRfLbzc8oAu3zPho2LLfEOT4E3qmwF6xf6pwU40v8pr0Ill
        IlEEBXVdpWeiKiO2RTcN6e1FM0S2zOM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-TzgLqo2rObK0g48IAmOLBA-1; Fri, 27 Mar 2020 12:46:47 -0400
X-MC-Unique: TzgLqo2rObK0g48IAmOLBA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 945E7800D4E;
        Fri, 27 Mar 2020 16:46:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DE495DA75;
        Fri, 27 Mar 2020 16:46:46 +0000 (UTC)
Date:   Fri, 27 Mar 2020 12:46:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: trylock underlying buffer on dquot flush
Message-ID: <20200327164644.GC29156@bfoster>
References: <20200326131703.23246-1-bfoster@redhat.com>
 <20200326131703.23246-2-bfoster@redhat.com>
 <20200327154527.GJ29339@magnolia>
 <20200327164440.GB29156@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327164440.GB29156@bfoster>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 27, 2020 at 12:44:40PM -0400, Brian Foster wrote:
> On Fri, Mar 27, 2020 at 08:45:28AM -0700, Darrick J. Wong wrote:
> > On Thu, Mar 26, 2020 at 09:17:02AM -0400, Brian Foster wrote:
> > > A dquot flush currently blocks on the buffer lock for the underlying
> > > dquot buffer. In turn, this causes xfsaild to block rather than
> > > continue processing other items in the meantime. Update
> > > xfs_qm_dqflush() to trylock the buffer, similar to how inode buffers
> > > are handled, and return -EAGAIN if the lock fails. Fix up any
> > > callers that don't currently handle the error properly.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > 
> > Is xfs_qm_dquot_isolate returning LRU_RETRY an acceptable resolution (as
> > opposed to, say, LRU_SKIP) for xfs_qm_dqflush returning -EAGAIN?
> > 
> 
> Hmm.. this is reclaim so I suppose LRU_SKIP would be more appropriate
> than retry (along with more consistent with the other trylock failures
> in that function). Ok with something like the following?
> 
> @@ -461,7 +461,11 @@ xfs_qm_dquot_isolate(
>  		spin_unlock(lru_lock);
>  
>  		error = xfs_qm_dqflush(dqp, &bp);
> -		if (error)
> +		if (error == -EAGAIN) {
> +			xfs_dqunlock(dqp);
> +			spin_lock(lru_lock);
> +			goto out_miss_busy;
> +		} else if (error)
>  			goto out_unlock_dirty;

Then again, is it safe to skip from here once we've cycled the lru_lock?

Brian

>  
>  		xfs_buf_delwri_queue(bp, &isol->buffers);
> 
> Brian
> 
> > --D
> > 
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
> > >  
> > >  	spin_lock(&lip->li_ailp->ail_lock);
> > >  out_unlock:
> > > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > > index de1d2c606c14..68c778d25c48 100644
> > > --- a/fs/xfs/xfs_qm.c
> > > +++ b/fs/xfs/xfs_qm.c
> > > @@ -121,12 +121,11 @@ xfs_qm_dqpurge(
> > >  {
> > >  	struct xfs_mount	*mp = dqp->q_mount;
> > >  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> > > +	int			error = -EAGAIN;
> > >  
> > >  	xfs_dqlock(dqp);
> > > -	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
> > > -		xfs_dqunlock(dqp);
> > > -		return -EAGAIN;
> > > -	}
> > > +	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0)
> > > +		goto out_unlock;
> > >  
> > >  	dqp->dq_flags |= XFS_DQ_FREEING;
> > >  
> > > @@ -139,7 +138,6 @@ xfs_qm_dqpurge(
> > >  	 */
> > >  	if (XFS_DQ_IS_DIRTY(dqp)) {
> > >  		struct xfs_buf	*bp = NULL;
> > > -		int		error;
> > >  
> > >  		/*
> > >  		 * We don't care about getting disk errors here. We need
> > > @@ -149,6 +147,8 @@ xfs_qm_dqpurge(
> > >  		if (!error) {
> > >  			error = xfs_bwrite(bp);
> > >  			xfs_buf_relse(bp);
> > > +		} else if (error == -EAGAIN) {
> > > +			goto out_unlock;
> > >  		}
> > >  		xfs_dqflock(dqp);
> > >  	}
> > > @@ -174,6 +174,10 @@ xfs_qm_dqpurge(
> > >  
> > >  	xfs_qm_dqdestroy(dqp);
> > >  	return 0;
> > > +
> > > +out_unlock:
> > > +	xfs_dqunlock(dqp);
> > > +	return error;
> > >  }
> > >  
> > >  /*
> > > -- 
> > > 2.21.1
> > > 
> > 
> 

