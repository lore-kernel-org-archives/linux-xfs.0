Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDFBC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 14:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BE6320772
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 14:58:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FkM5/lzy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgFCO6m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 10:58:42 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44670 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725930AbgFCO6m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 10:58:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591196321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sTHZNJBOsI704es4342IOo2RSkF+XHBXCWuJopzsl24=;
        b=FkM5/lzyNYejkDtuQb9fEVbwa43zAeKOjHTCElHsLwKmHv++YSKp+uG0mh4VKhca39Av2D
        BNQgmGgkAehMd10/M2tomI1SLUYf78ecQuy0y31oya9cNUWzWNbBkv/Yg492bItqMuAhhl
        clG+jVlVl23vQVsTzqvGYAtTQ6kl5Ac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-6bdEbUGTNe6k21pCYm0pFw-1; Wed, 03 Jun 2020 10:58:37 -0400
X-MC-Unique: 6bdEbUGTNe6k21pCYm0pFw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D48E1801503;
        Wed,  3 Jun 2020 14:58:36 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B0C760C47;
        Wed,  3 Jun 2020 14:58:36 +0000 (UTC)
Date:   Wed, 3 Jun 2020 10:58:34 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/30] xfs: use direct calls for dquot IO completion
Message-ID: <20200603145834.GD12332@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-11-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-11-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:31AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Similar to inodes, we can call the dquot IO completion functions
> directly from the buffer completion code, removing another user of
> log item callbacks for IO completion processing.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf_item.c | 18 +++++++++++++++++-
>  fs/xfs/xfs_dquot.c    | 18 ++++++++++++++----
>  fs/xfs/xfs_dquot.h    |  1 +
>  3 files changed, 32 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index a4e416af5c614..f46e5ec28111c 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -15,6 +15,9 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_inode.h"
>  #include "xfs_inode_item.h"
> +#include "xfs_quota.h"
> +#include "xfs_dquot_item.h"
> +#include "xfs_dquot.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> @@ -1209,7 +1212,20 @@ void
>  xfs_buf_dquot_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	xfs_buf_run_callbacks(bp);
> +	struct xfs_buf_log_item *blip = bp->b_log_item;
> +	struct xfs_log_item	*lip;
> +
> +	if (xfs_buf_had_callback_errors(bp))
> +		return;
> +
> +	/* a newly allocated dquot buffer might have a log item attached */
> +	if (blip) {
> +		lip = &blip->bli_item;
> +		lip->li_cb(bp, lip);
> +		bp->b_log_item = NULL;
> +	}
> +
> +	xfs_dquot_done(bp);
>  	xfs_buf_ioend_finish(bp);
>  }
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 2e2146fa0914c..403bc4e9f21ff 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1048,9 +1048,8 @@ xfs_qm_dqrele(
>   * from the AIL if it has not been re-logged, and unlocking the dquot's
>   * flush lock. This behavior is very similar to that of inodes..
>   */
> -STATIC void
> +static void
>  xfs_qm_dqflush_done(
> -	struct xfs_buf		*bp,
>  	struct xfs_log_item	*lip)
>  {
>  	struct xfs_dq_logitem	*qip = (struct xfs_dq_logitem *)lip;
> @@ -1091,6 +1090,18 @@ xfs_qm_dqflush_done(
>  	xfs_dqfunlock(dqp);
>  }
>  
> +void
> +xfs_dquot_done(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_log_item	*lip, *n;
> +
> +	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
> +		list_del_init(&lip->li_bio_list);
> +		xfs_qm_dqflush_done(lip);
> +	}
> +}
> +
>  /*
>   * Write a modified dquot to disk.
>   * The dquot must be locked and the flush lock too taken by caller.
> @@ -1180,8 +1191,7 @@ xfs_qm_dqflush(
>  	 * AIL and release the flush lock once the dquot is synced to disk.
>  	 */
>  	bp->b_flags |= _XBF_DQUOTS;
> -	xfs_buf_attach_iodone(bp, xfs_qm_dqflush_done,
> -				  &dqp->q_logitem.qli_item);
> +	xfs_buf_attach_iodone(bp, NULL, &dqp->q_logitem.qli_item);
>  
>  	/*
>  	 * If the buffer is pinned then push on the log so we won't
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 71e36c85e20b6..fe9cc3e08ed6d 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -174,6 +174,7 @@ void		xfs_qm_dqput(struct xfs_dquot *dqp);
>  void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
>  
>  void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
> +void		xfs_dquot_done(struct xfs_buf *);
>  
>  static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
>  {
> -- 
> 2.26.2.761.g0e0b3e54be
> 

