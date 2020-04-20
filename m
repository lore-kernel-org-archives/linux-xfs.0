Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11836C3A5A0
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 13:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E24892070B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 13:58:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N6LdTN7R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgDTN6d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 09:58:33 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32198 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726608AbgDTN6d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 09:58:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587391111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vBX3eVNmbrPpy08k20PpSS9tNL3rbyFi8z8PQ2bJxUQ=;
        b=N6LdTN7R7TUP2Y1Y7ncIAosUXuLmJOTHNdEUCS9EJ/rvwjG6l0iNUsCr6nknRnfTlrq37a
        S4lC2sGj1hmoSjkLMPXTDfJ3LTJaEgnJ6ZvuIU+3xS0401OEKtZ0or4V6TQiNluQRF2HhF
        apFVc7KJZGXGFssocioyTw9Z3iCSRs0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326--1a3RdZVOpuhsEfezotDGg-1; Mon, 20 Apr 2020 09:58:29 -0400
X-MC-Unique: -1a3RdZVOpuhsEfezotDGg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11C848018A1;
        Mon, 20 Apr 2020 13:58:28 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A8E8B5C1B2;
        Mon, 20 Apr 2020 13:58:27 +0000 (UTC)
Date:   Mon, 20 Apr 2020 09:58:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: refactor failed buffer resubmission into
 xfsaild
Message-ID: <20200420135825.GA27516@bfoster>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-2-bfoster@redhat.com>
 <20200420024556.GD9800@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420024556.GD9800@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 20, 2020 at 12:45:56PM +1000, Dave Chinner wrote:
> On Fri, Apr 17, 2020 at 11:08:48AM -0400, Brian Foster wrote:
> > Flush locked log items whose underlying buffers fail metadata
> > writeback are tagged with a special flag to indicate that the flush
> > lock is already held. This is currently implemented in the type
> > specific ->iop_push() callback, but the processing required for such
> > items is not type specific because we're only doing basic state
> > management on the underlying buffer.
> > 
> > Factor the failed log item handling out of the inode and dquot
> > ->iop_push() callbacks and open code the buffer resubmit helper into
> > a single helper called from xfsaild_push_item(). This provides a
> > generic mechanism for handling failed metadata buffer writeback with
> > a bit less code.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> .....
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index 564253550b75..0c709651a2c6 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -345,6 +345,45 @@ xfs_ail_delete(
> >  	xfs_trans_ail_cursor_clear(ailp, lip);
> >  }
> >  
> > +/*
> > + * Requeue a failed buffer for writeback.
> > + *
> > + * We clear the log item failed state here as well, but we have to be careful
> > + * about reference counts because the only active reference counts on the buffer
> > + * may be the failed log items. Hence if we clear the log item failed state
> > + * before queuing the buffer for IO we can release all active references to
> > + * the buffer and free it, leading to use after free problems in
> > + * xfs_buf_delwri_queue. It makes no difference to the buffer or log items which
> > + * order we process them in - the buffer is locked, and we own the buffer list
> > + * so nothing on them is going to change while we are performing this action.
> > + *
> > + * Hence we can safely queue the buffer for IO before we clear the failed log
> > + * item state, therefore  always having an active reference to the buffer and
> > + * avoiding the transient zero-reference state that leads to use-after-free.
> > + */
> > +static inline int
> > +xfsaild_push_failed(
> 
> Bad name IMO. Makes me think it's an action that is taken when an
> item push failed, not an action that resubmits a buffer that had an
> IO failure.
> 
> i.e. "push" doesn't imply IO, and failure to push an item doesn't
> mean there was an IO error - it may be locked, already flushing,
> pinned, etc.
> 

Yeah..

> > +	struct xfs_log_item	*lip,
> > +	struct list_head	*buffer_list)
> > +{
> > +	struct xfs_buf		*bp = lip->li_buf;
> 
> This also assumes that the log item has a buffer associated with it.
> So perhaps "xfsaild_resubmit_failed_buffer()" would be more
> approriate here.
> 

The buffer pointer is an implementation detail of failed items. It would
be nice to find a way to avoid that. How about xfsaild_resubmit_item()
to be consistent with the parent function (xfsaild_push_item())?

Brian

> Other than that, the code is fine.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

