Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 145CEC54FCB
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 14:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7209214AF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 14:03:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iPKFS+RP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgDTODq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 10:03:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20108 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729177AbgDTODq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 10:03:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587391424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pso8eVTmlbOXlw/KvAsGlADZGj1yNjX+IlNke+aOVCM=;
        b=iPKFS+RPdq3WLtaPbO1vHLKGkWdKg8lCIuJKe7TwzeeToD/tzH9UZp43z8j11flQO9QDTA
        KkWG8LlU7G1z/jEf9FUalUqjK8C2dFWhGi/lsBpDtpFcUbZhSzOPvmXmbWjF5O8LENWxzX
        t8HRjIRKFKwQqK5tHyAH5OudOfzjpBg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-40g9UFn9P1CNiMQjmSWL1w-1; Mon, 20 Apr 2020 10:03:42 -0400
X-MC-Unique: 40g9UFn9P1CNiMQjmSWL1w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC238107ACCD;
        Mon, 20 Apr 2020 14:03:41 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D4455C1B2;
        Mon, 20 Apr 2020 14:03:41 +0000 (UTC)
Date:   Mon, 20 Apr 2020 10:03:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: clean up AIL log item removal functions
Message-ID: <20200420140339.GH27516@bfoster>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-11-bfoster@redhat.com>
 <20200420043233.GL9800@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420043233.GL9800@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 20, 2020 at 02:32:33PM +1000, Dave Chinner wrote:
> On Fri, Apr 17, 2020 at 11:08:57AM -0400, Brian Foster wrote:
> > We have two AIL removal functions with slightly different semantics.
> > xfs_trans_ail_delete() expects the caller to have the AIL lock and
> > for the associated item to be AIL resident. If not, the filesystem
> > is shut down. xfs_trans_ail_remove() acquires the AIL lock, checks
> > that the item is AIL resident and calls the former if so.
> > 
> > These semantics lead to confused usage between the two. For example,
> > the _remove() variant takes a shutdown parameter to pass to the
> > _delete() variant, but immediately returns if the AIL bit is not
> > set. This means that _remove() would never shut down if an item is
> > not AIL resident, even though it appears that many callers would
> > expect it to.
> > 
> > Make the following changes to clean up both of these functions:
> > 
> > - Most callers of xfs_trans_ail_delete() acquire the AIL lock just
> >   before the call. Update _delete() to acquire the lock and open
> >   code the couple of callers that make additional checks under AIL
> >   lock.
> > - Drop the unnecessary ailp parameter from _delete().
> > - Drop the unused shutdown parameter from _remove() and open code
> >   the implementation.
> > 
> > In summary, this leaves a _delete() variant that expects an AIL
> > resident item and a _remove() helper that checks the AIL bit. Audit
> > the existing callsites for use of the appropriate function and
> > update as necessary.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> ....
> 
> Good start, but...
> 
> > @@ -1032,10 +1033,11 @@ xfs_qm_dqflush_done(
> >  		goto out;
> >  
> >  	spin_lock(&ailp->ail_lock);
> > -	if (lip->li_lsn == qip->qli_flush_lsn)
> > -		/* xfs_trans_ail_delete() drops the AIL lock */
> > -		xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
> > -	else
> > +	if (lip->li_lsn == qip->qli_flush_lsn) {
> > +		/* xfs_ail_update_finish() drops the AIL lock */
> > +		tail_lsn = xfs_ail_delete_one(ailp, lip);
> > +		xfs_ail_update_finish(ailp, tail_lsn);
> > +	} else
> >  		spin_unlock(&ailp->ail_lock);
> 
> This drops the shutdown if the dquot is not in the AIL. It should be
> in the AIL, so if it isn't we should be shutting down...
> 

It might not be in the AIL if we're in quotacheck because it does
everything in-core.

> > @@ -872,13 +872,14 @@ xfs_ail_delete_one(
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
> > index 9135afdcee9d..7563c78e2997 100644
> > --- a/fs/xfs/xfs_trans_priv.h
> > +++ b/fs/xfs/xfs_trans_priv.h
> > @@ -94,22 +94,23 @@ xfs_trans_ail_update(
> >  xfs_lsn_t xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
> >  void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
> >  			__releases(ailp->ail_lock);
> > -void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip,
> > -		int shutdown_type);
> > +void xfs_trans_ail_delete(struct xfs_log_item *lip, int shutdown_type);
> >  
> >  static inline void
> >  xfs_trans_ail_remove(
> > -	struct xfs_log_item	*lip,
> > -	int			shutdown_type)
> > +	struct xfs_log_item	*lip)
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
> 
> This makes xfs_trans_ail_delete() and xfs_trans_ail_remove() almost
> identical, except one will shutdown if the item is not in the AIL
> and the other won't. Wouldn't it be better to get it down to just
> one function that does everything, and remove the confusion of which
> to use altogether?
> 

Yes, I was thinking about doing this when working on this patch but
determined it was easier to fix up both functions first and then
consider combining them in a separate step, but then never got back to
it. That might have been before I ended up open-coding some of the other
sites too so the end result wasn't really clear to me.

Regardless, I'll take another look and fold that change in if it makes
sense..

Brian

> void
> xfs_trans_ail_delete(
> 	struct xfs_log_item     *lip,
> 	int                     shutdown)
> {
> 	struct xfs_ail		*ailp = lip->li_ailp;
> 
> 	spin_lock(&ailp->ail_lock);
> 	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
> 		xfs_lsn_t tail_lsn = xfs_ail_delete_one(ailp, lip);
> 		xfs_ail_update_finish(ailp, tail_lsn);
> 		return;
> 	}
> 	spin_unlock(&ailp->ail_lock);
> 	if (!shutdown)
> 		return;
> 
> 	/* do shutdown stuff */
> }
> 
> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 

