Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F9BC8300A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E1FE2078D
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:04:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cz9gKqef"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgD3LEd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 07:04:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38712 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726636AbgD3LEc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 07:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588244670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hxoFwZIWcFlHMiDI1CR+6za1YRLz8EPmA7T+XyjbyUk=;
        b=Cz9gKqef/P3MSr3qU0KtoSkKdrR1lRZzJ7i1v3CkZNik1bJmYScuMGhISXlpVHQcZ/75S8
        gy+sin/78id1J182geATKcF7BI1CHSIp62hcYW8XmjJhrG8LCKaza3O+qprzQCO9Wjn/iE
        F+H2bsMnSBhqougtnEM+LhjXJFChpuc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-DD3jK1WhMH-ZDIPY9kcOsA-1; Thu, 30 Apr 2020 07:04:27 -0400
X-MC-Unique: DD3jK1WhMH-ZDIPY9kcOsA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9CC1801503;
        Thu, 30 Apr 2020 11:04:26 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FAA85C1B0;
        Thu, 30 Apr 2020 11:04:26 +0000 (UTC)
Date:   Thu, 30 Apr 2020 07:04:24 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: refactor xfs_defer_finish_noroll
Message-ID: <20200430110424.GH5349@bfoster>
References: <20200429150511.2191150-1-hch@lst.de>
 <20200429150511.2191150-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429150511.2191150-9-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 05:05:08PM +0200, Christoph Hellwig wrote:
> Split out a helper that operates on a single xfs_defer_pending structure
> to untangle the code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_defer.c | 128 ++++++++++++++++++--------------------
>  1 file changed, 59 insertions(+), 69 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 5402a7bf31108..20950b56cdd07 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -351,6 +351,53 @@ xfs_defer_cancel_list(
>  	}
>  }
>  
> +/*
> + * Log an intent-done item for the first pending intent, and finish the work
> + * items.
> + */
> +static int
> +xfs_defer_finish_one(
> +	struct xfs_trans		*tp,
> +	struct xfs_defer_pending	*dfp)
> +{
> +	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
> +	void				*state = NULL;
> +	struct list_head		*li, *n;
> +	int				error;
> +
> +	trace_xfs_defer_pending_finish(tp->t_mountp, dfp);
> +
> +	dfp->dfp_done = ops->create_done(tp, dfp->dfp_intent, dfp->dfp_count);
> +	list_for_each_safe(li, n, &dfp->dfp_work) {
> +		list_del(li);
> +		dfp->dfp_count--;
> +		error = ops->finish_item(tp, li, dfp->dfp_done, &state);
> +		if (error == -EAGAIN) {
> +			/*
> +			 * Caller wants a fresh transaction; put the work item
> +			 * back on the list and log a new log intent item to
> +			 * replace the old one.  See "Requesting a Fresh
> +			 * Transaction while Finishing Deferred Work" above.
> +			 */
> +			list_add(li, &dfp->dfp_work);
> +			dfp->dfp_count++;
> +			dfp->dfp_done = NULL;
> +			xfs_defer_create_intent(tp, dfp, false);
> +		}
> +
> +		if (error)
> +			goto out;
> +	}
> +
> +	/* Done with the dfp, free it. */
> +	list_del(&dfp->dfp_list);
> +	kmem_free(dfp);
> +out:
> +	if (ops->finish_cleanup)
> +		ops->finish_cleanup(tp, state, error);
> +	return error;
> +}
> +
>  /*
>   * Finish all the pending work.  This involves logging intent items for
>   * any work items that wandered in since the last transaction roll (if
> @@ -364,11 +411,7 @@ xfs_defer_finish_noroll(
>  	struct xfs_trans		**tp)
>  {
>  	struct xfs_defer_pending	*dfp;
> -	struct list_head		*li;
> -	struct list_head		*n;
> -	void				*state;
>  	int				error = 0;
> -	const struct xfs_defer_op_type	*ops;
>  	LIST_HEAD(dop_pending);
>  
>  	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> @@ -377,83 +420,30 @@ xfs_defer_finish_noroll(
>  
>  	/* Until we run out of pending work to finish... */
>  	while (!list_empty(&dop_pending) || !list_empty(&(*tp)->t_dfops)) {
> -		/* log intents and pull in intake items */
>  		xfs_defer_create_intents(*tp);
>  		list_splice_tail_init(&(*tp)->t_dfops, &dop_pending);
>  
> -		/*
> -		 * Roll the transaction.
> -		 */
>  		error = xfs_defer_trans_roll(tp);
>  		if (error)
> -			goto out;
> +			goto out_shutdown;
>  
> -		/* Log an intent-done item for the first pending item. */
>  		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
>  				       dfp_list);
> -		ops = defer_op_types[dfp->dfp_type];
> -		trace_xfs_defer_pending_finish((*tp)->t_mountp, dfp);
> -		dfp->dfp_done = ops->create_done(*tp, dfp->dfp_intent,
> -				dfp->dfp_count);
> -
> -		/* Finish the work items. */
> -		state = NULL;
> -		list_for_each_safe(li, n, &dfp->dfp_work) {
> -			list_del(li);
> -			dfp->dfp_count--;
> -			error = ops->finish_item(*tp, li, dfp->dfp_done,
> -					&state);
> -			if (error == -EAGAIN) {
> -				/*
> -				 * Caller wants a fresh transaction;
> -				 * put the work item back on the list
> -				 * and jump out.
> -				 */
> -				list_add(li, &dfp->dfp_work);
> -				dfp->dfp_count++;
> -				break;
> -			} else if (error) {
> -				/*
> -				 * Clean up after ourselves and jump out.
> -				 * xfs_defer_cancel will take care of freeing
> -				 * all these lists and stuff.
> -				 */
> -				if (ops->finish_cleanup)
> -					ops->finish_cleanup(*tp, state, error);
> -				goto out;
> -			}
> -		}
> -		if (error == -EAGAIN) {
> -			/*
> -			 * Caller wants a fresh transaction, so log a new log
> -			 * intent item to replace the old one and roll the
> -			 * transaction.  See "Requesting a Fresh Transaction
> -			 * while Finishing Deferred Work" above.
> -			 */
> -			dfp->dfp_done = NULL;
> -			xfs_defer_create_intent(*tp, dfp, false);
> -		} else {
> -			/* Done with the dfp, free it. */
> -			list_del(&dfp->dfp_list);
> -			kmem_free(dfp);
> -		}
> -
> -		if (ops->finish_cleanup)
> -			ops->finish_cleanup(*tp, state, error);
> -	}
> -
> -out:
> -	if (error) {
> -		xfs_defer_trans_abort(*tp, &dop_pending);
> -		xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
> -		trace_xfs_defer_finish_error(*tp, error);
> -		xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
> -		xfs_defer_cancel(*tp);
> -		return error;
> +		error = xfs_defer_finish_one(*tp, dfp);
> +		if (error && error != -EAGAIN)
> +			goto out_shutdown;
>  	}
>  
>  	trace_xfs_defer_finish_done(*tp, _RET_IP_);
>  	return 0;
> +
> +out_shutdown:
> +	xfs_defer_trans_abort(*tp, &dop_pending);
> +	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
> +	trace_xfs_defer_finish_error(*tp, error);
> +	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
> +	xfs_defer_cancel(*tp);
> +	return error;
>  }
>  
>  int
> -- 
> 2.26.2
> 

