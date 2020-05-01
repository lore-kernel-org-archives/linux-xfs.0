Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17DACC47253
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 11:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E145E20787
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 11:25:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BkOnViJ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgEALZ3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 07:25:29 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42476 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728575AbgEALZ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 07:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588332326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FjqUCscIdGNCCMgEmIF4lZXyN9SeSNmgsnHMgrWS6mQ=;
        b=BkOnViJ84iAcK4gb/E0zEgGIv2cj5VNCEPfxVrhuryIcHKs1lAuYg3xHMvcomBy+P9UrD/
        w1WMhJu0tYnV9k85lcX0LmS+A1bJBApZZ/AGlPuPjgw3H86GHNHAgxPPm84FCZ6ji9FChg
        VAvyCIjmuN9o6+Tr0BObsgebmG4C39g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-rIH4sE1BOMmE2PcB7Zj9mA-1; Fri, 01 May 2020 07:25:24 -0400
X-MC-Unique: rIH4sE1BOMmE2PcB7Zj9mA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88F59835B40;
        Fri,  1 May 2020 11:25:23 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 173226A94A;
        Fri,  1 May 2020 11:25:22 +0000 (UTC)
Date:   Fri, 1 May 2020 07:25:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 10/17] xfs: acquire ->ail_lock from
 xfs_trans_ail_delete()
Message-ID: <20200501112521.GD40250@bfoster>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-11-bfoster@redhat.com>
 <20200430185250.GK6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430185250.GK6742@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 11:52:50AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 29, 2020 at 01:21:46PM -0400, Brian Foster wrote:
> > Several callers acquire the lock just prior to the call. Callers
> > that require ->ail_lock for other purposes already check IN_AIL
> > state and thus don't require the additional shutdown check in the
> > helper. Push the lock down into xfs_trans_ail_delete(), open code
> > the instances that still acquire it, and remove the unnecessary ailp
> > parameter.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Ahh, this and the next few patches are a split of a larger patch from
> the last posting.  So I guess the point of this is to reduce parameter
> passing and get rid of the SHUTDOWN_* flags?
> 

Yeah, the point is just to simplify and ultimately combine these two odd
helpers into one. It was originally easier for me to work it all out in
one change/patch, but Christoph preferred to see it split up. Ultimately
it's easier for a reviewer to squash multiple simple patches than take a
potentially confusing one apart, so I broke it back out into these 3 or
4...

Brian

> Looks decent to me, regardless...
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> > ---
> >  fs/xfs/xfs_buf_item.c   | 27 +++++++++++----------------
> >  fs/xfs/xfs_dquot.c      |  6 ++++--
> >  fs/xfs/xfs_trans_ail.c  |  3 ++-
> >  fs/xfs/xfs_trans_priv.h | 14 ++++++++------
> >  4 files changed, 25 insertions(+), 25 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 1f7acffc99ba..06e306b49283 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -410,7 +410,6 @@ xfs_buf_item_unpin(
> >  {
> >  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
> >  	xfs_buf_t		*bp = bip->bli_buf;
> > -	struct xfs_ail		*ailp = lip->li_ailp;
> >  	int			stale = bip->bli_flags & XFS_BLI_STALE;
> >  	int			freed;
> >  
> > @@ -452,10 +451,10 @@ xfs_buf_item_unpin(
> >  		}
> >  
> >  		/*
> > -		 * If we get called here because of an IO error, we may
> > -		 * or may not have the item on the AIL. xfs_trans_ail_delete()
> > -		 * will take care of that situation.
> > -		 * xfs_trans_ail_delete() drops the AIL lock.
> > +		 * If we get called here because of an IO error, we may or may
> > +		 * not have the item on the AIL. xfs_trans_ail_delete() will
> > +		 * take care of that situation. xfs_trans_ail_delete() drops
> > +		 * the AIL lock.
> >  		 */
> >  		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
> >  			xfs_buf_do_callbacks(bp);
> > @@ -463,8 +462,7 @@ xfs_buf_item_unpin(
> >  			list_del_init(&bp->b_li_list);
> >  			bp->b_iodone = NULL;
> >  		} else {
> > -			spin_lock(&ailp->ail_lock);
> > -			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_LOG_IO_ERROR);
> > +			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
> >  			xfs_buf_item_relse(bp);
> >  			ASSERT(bp->b_log_item == NULL);
> >  		}
> > @@ -1205,22 +1203,19 @@ xfs_buf_iodone(
> >  	struct xfs_buf		*bp,
> >  	struct xfs_log_item	*lip)
> >  {
> > -	struct xfs_ail		*ailp = lip->li_ailp;
> > -
> >  	ASSERT(BUF_ITEM(lip)->bli_buf == bp);
> >  
> >  	xfs_buf_rele(bp);
> >  
> >  	/*
> > -	 * If we are forcibly shutting down, this may well be
> > -	 * off the AIL already. That's because we simulate the
> > -	 * log-committed callbacks to unpin these buffers. Or we may never
> > -	 * have put this item on AIL because of the transaction was
> > -	 * aborted forcibly. xfs_trans_ail_delete() takes care of these.
> > +	 * If we are forcibly shutting down, this may well be off the AIL
> > +	 * already. That's because we simulate the log-committed callbacks to
> > +	 * unpin these buffers. Or we may never have put this item on AIL
> > +	 * because of the transaction was aborted forcibly.
> > +	 * xfs_trans_ail_delete() takes care of these.
> >  	 *
> >  	 * Either way, AIL is useless if we're forcing a shutdown.
> >  	 */
> > -	spin_lock(&ailp->ail_lock);
> > -	xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
> > +	xfs_trans_ail_delete(lip, SHUTDOWN_CORRUPT_INCORE);
> >  	xfs_buf_item_free(BUF_ITEM(lip));
> >  }
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index ffe607733c50..5fb65f43b980 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -1021,6 +1021,7 @@ xfs_qm_dqflush_done(
> >  	struct xfs_dq_logitem	*qip = (struct xfs_dq_logitem *)lip;
> >  	struct xfs_dquot	*dqp = qip->qli_dquot;
> >  	struct xfs_ail		*ailp = lip->li_ailp;
> > +	xfs_lsn_t		tail_lsn;
> >  
> >  	/*
> >  	 * We only want to pull the item from the AIL if its
> > @@ -1034,10 +1035,11 @@ xfs_qm_dqflush_done(
> >  	    ((lip->li_lsn == qip->qli_flush_lsn) ||
> >  	     test_bit(XFS_LI_FAILED, &lip->li_flags))) {
> >  
> > -		/* xfs_trans_ail_delete() drops the AIL lock. */
> >  		spin_lock(&ailp->ail_lock);
> >  		if (lip->li_lsn == qip->qli_flush_lsn) {
> > -			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
> > +			/* xfs_ail_update_finish() drops the AIL lock */
> > +			tail_lsn = xfs_ail_delete_one(ailp, lip);
> > +			xfs_ail_update_finish(ailp, tail_lsn);
> >  		} else {
> >  			/*
> >  			 * Clear the failed state since we are about to drop the
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index 2574d01e4a83..cfba691664c7 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -864,13 +864,14 @@ xfs_ail_delete_one(
> >   */
> >  void
> >  xfs_trans_ail_delete(
> > -	struct xfs_ail		*ailp,
> >  	struct xfs_log_item	*lip,
> >  	int			shutdown_type)
> >  {
> > +	struct xfs_ail		*ailp = lip->li_ailp;
> >  	struct xfs_mount	*mp = ailp->ail_mount;
> >  	xfs_lsn_t		tail_lsn;
> >  
> > +	spin_lock(&ailp->ail_lock);
> >  	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
> >  		spin_unlock(&ailp->ail_lock);
> >  		if (!XFS_FORCED_SHUTDOWN(mp)) {
> > diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> > index 35655eac01a6..e4362fb8d483 100644
> > --- a/fs/xfs/xfs_trans_priv.h
> > +++ b/fs/xfs/xfs_trans_priv.h
> > @@ -94,8 +94,7 @@ xfs_trans_ail_update(
> >  xfs_lsn_t xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
> >  void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
> >  			__releases(ailp->ail_lock);
> > -void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip,
> > -		int shutdown_type);
> > +void xfs_trans_ail_delete(struct xfs_log_item *lip, int shutdown_type);
> >  
> >  static inline void
> >  xfs_trans_ail_remove(
> > @@ -103,13 +102,16 @@ xfs_trans_ail_remove(
> >  	int			shutdown_type)
> >  {
> >  	struct xfs_ail		*ailp = lip->li_ailp;
> > +	xfs_lsn_t		tail_lsn;
> >  
> >  	spin_lock(&ailp->ail_lock);
> > -	/* xfs_trans_ail_delete() drops the AIL lock */
> > -	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags))
> > -		xfs_trans_ail_delete(ailp, lip, shutdown_type);
> > -	else
> > +	/* xfs_ail_update_finish() drops the AIL lock */
> > +	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
> > +		tail_lsn = xfs_ail_delete_one(ailp, lip);
> > +		xfs_ail_update_finish(ailp, tail_lsn);
> > +	} else {
> >  		spin_unlock(&ailp->ail_lock);
> > +	}
> >  }
> >  
> >  void			xfs_ail_push(struct xfs_ail *, xfs_lsn_t);
> > -- 
> > 2.21.1
> > 
> 

