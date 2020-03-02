Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E87C3F2D7
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 18:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BC622467E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 18:08:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I/Jdj8E3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbgCBSIU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 13:08:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29510 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727381AbgCBSIU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 13:08:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583172499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nYf08zyhulxX9SjfLgwq59ydURYS7hJeDhEVd85+aWI=;
        b=I/Jdj8E3j9z4UJkrHGfFVEjjaiM7CzneZHxO/S92u8bm0ww6oThZmgsw8BF5REfpBPZmyr
        KevFxk8xdcrOYEkWZkgomJts5oX7oCKPBpVzpTNULf1/qurmiqLc8YXQY+CkjM+nOo6UKK
        wyzozovmU0lHUBsxOoSf2rsy25TxLIA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-6VvhUvnJN2KdbuzeBAwK5A-1; Mon, 02 Mar 2020 13:08:17 -0500
X-MC-Unique: 6VvhUvnJN2KdbuzeBAwK5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94E03107ACC9;
        Mon,  2 Mar 2020 18:08:16 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C85D5C1C3;
        Mon,  2 Mar 2020 18:08:16 +0000 (UTC)
Date:   Mon, 2 Mar 2020 13:08:14 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 4/9] xfs: automatic relogging item management
Message-ID: <20200302180814.GC10946@bfoster>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-5-bfoster@redhat.com>
 <20200302055837.GJ10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302055837.GJ10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 02, 2020 at 04:58:37PM +1100, Dave Chinner wrote:
> On Thu, Feb 27, 2020 at 08:43:16AM -0500, Brian Foster wrote:
> > As implemented by the previous patch, relogging can be enabled on
> > any item via a relog enabled transaction (which holds a reference to
> > an active relog ticket). Add a couple log item flags to track relog
> > state of an arbitrary log item. The item holds a reference to the
> > global relog ticket when relogging is enabled and releases the
> > reference when relogging is disabled.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_trace.h      |  2 ++
> >  fs/xfs/xfs_trans.c      | 36 ++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_trans.h      |  6 +++++-
> >  fs/xfs/xfs_trans_priv.h |  2 ++
> >  4 files changed, 45 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index a86be7f807ee..a066617ec54d 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -1063,6 +1063,8 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
> >  DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
> >  DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
> >  DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
> > +DEFINE_LOG_ITEM_EVENT(xfs_relog_item);
> > +DEFINE_LOG_ITEM_EVENT(xfs_relog_item_cancel);
> >  
> >  DECLARE_EVENT_CLASS(xfs_ail_class,
> >  	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn),
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 8ac05ed8deda..f7f2411ead4e 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -778,6 +778,41 @@ xfs_trans_del_item(
> >  	list_del_init(&lip->li_trans);
> >  }
> >  
> > +void
> > +xfs_trans_relog_item(
> > +	struct xfs_log_item	*lip)
> > +{
> > +	if (!test_and_set_bit(XFS_LI_RELOG, &lip->li_flags)) {
> > +		xfs_trans_ail_relog_get(lip->li_mountp);
> > +		trace_xfs_relog_item(lip);
> > +	}
> 
> What if xfs_trans_ail_relog_get() fails to get a reference here
> because there is no current ail relog ticket? Isn't the transaction
> it was reserved in required to be checked here for XFS_TRANS_RELOG
> being set?
> 

That shouldn't happen because XFS_TRANS_RELOG is required of the
transaction, as you noted. Ideally this would at least have an assert.
I'm guessing I didn't do that simply because there was no other reason
to pass the transaction into this function.

I could clean this up, but much of this might go away if the reservation
model changes such that XFS_TRANS_RELOG goes away.

> > +}
> > +
> > +void
> > +xfs_trans_relog_item_cancel(
> > +	struct xfs_log_item	*lip,
> > +	bool			drain) /* wait for relogging to cease */
> > +{
> > +	struct xfs_mount	*mp = lip->li_mountp;
> > +
> > +	if (!test_and_clear_bit(XFS_LI_RELOG, &lip->li_flags))
> > +		return;
> > +	xfs_trans_ail_relog_put(lip->li_mountp);
> > +	trace_xfs_relog_item_cancel(lip);
> > +
> > +	if (!drain)
> > +		return;
> > +
> > +	/*
> > +	 * Some operations might require relog activity to cease before they can
> > +	 * proceed. For example, an operation must wait before including a
> > +	 * non-lockable log item (i.e. intent) in another transaction.
> > +	 */
> > +	while (wait_on_bit_timeout(&lip->li_flags, XFS_LI_RELOGGED,
> > +				   TASK_UNINTERRUPTIBLE, HZ))
> > +		xfs_log_force(mp, XFS_LOG_SYNC);
> > +}
> 
> What is a "cancel" operation? Is it something you do when cancelling
> a transaction (i.e. on operation failure) or is is something the
> final transaction does to remove the relog item from the AIL (i.e.
> part of the normal successful finish to a long running transaction)?
> 

This just means to cancel relogging on a log item. To cancel relogging
only requires to clear the flag, so it doesn't require a transaction at
all at the moment. The waiting bit is for callers (i.e. quotaoff) that
might want to remove the item from the AIL after relogging is disabled.
Without that, the item could still be in the CIL when the caller wants
to remove it.

> 
> >  /* Detach and unlock all of the items in a transaction */
> >  static void
> >  xfs_trans_free_items(
> > @@ -863,6 +898,7 @@ xfs_trans_committed_bulk(
> >  
> >  		if (aborted)
> >  			set_bit(XFS_LI_ABORTED, &lip->li_flags);
> > +		clear_and_wake_up_bit(XFS_LI_RELOGGED, &lip->li_flags);
> 
> I don't know what the XFS_LI_RELOGGED flag really means in this
> patch because I don't know what sets it. Perhaps this would be
> better moved into the patch that first sets the RELOGGED flag?
> 

Hmm, yeah that's a bit of wart. It basically means that an item is
queued for relog by the AIL (similar to an item added to the buffer
writeback list, but not yet submitted). Perhaps RELOG_QUEUED would be a
better name. It's included in this patch because it's used by
xfs_trans_relog_item_cancel(), but I suppose that whole functional hunk
could be added later once the flag is introduced properly.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

