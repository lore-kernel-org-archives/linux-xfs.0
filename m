Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8221C8300B
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A46D42078D
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 11:03:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="clMwkxu3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgD3LDW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 07:03:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25193 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726520AbgD3LDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 07:03:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588244600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ExqUkgVpU1QR954nXiKwP/1kGauyCeNISJJnkjrlOxE=;
        b=clMwkxu35H+bTOckJIhJjHLg3KlfdoCRHsrQeITfpO2qoVno1MeEtniEgtha+2+SPGKL00
        IPU3C7yllD9qSHipmI8bT8rHhRLBUWZa8xRH8IeDQCdqFQsXsCANwXWdCngkWq+AAZ5YaY
        pn9fj5FXCiK6rKOOEIH1WynhIjVtNZU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-swZLM2uEN7qtNZagcT5SiQ-1; Thu, 30 Apr 2020 07:03:18 -0400
X-MC-Unique: swZLM2uEN7qtNZagcT5SiQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E402C18764D7;
        Thu, 30 Apr 2020 11:03:17 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97C895D9C5;
        Thu, 30 Apr 2020 11:03:17 +0000 (UTC)
Date:   Thu, 30 Apr 2020 07:03:16 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: factor out a xfs_defer_create_intent helper
Message-ID: <20200430110316.GD5349@bfoster>
References: <20200429150511.2191150-1-hch@lst.de>
 <20200429150511.2191150-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429150511.2191150-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 05:05:04PM +0200, Christoph Hellwig wrote:
> Create a helper that encapsulates the whole logic to create a defer
> intent.  This reorders some of the work that was done, but none of
> that has an affect on the operation as only fields that don't directly
> interact are affected.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_defer.c | 39 +++++++++++++++++++++++----------------
>  1 file changed, 23 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 22557527cfdb6..8a38da602b7d9 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -178,6 +178,23 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>  };
>  
> +static void
> +xfs_defer_create_intent(
> +	struct xfs_trans		*tp,
> +	struct xfs_defer_pending	*dfp,
> +	bool				sort)
> +{
> +	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
> +	struct list_head		*li;
> +
> +	if (sort)
> +		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
> +
> +	dfp->dfp_intent = ops->create_intent(tp, dfp->dfp_count);
> +	list_for_each(li, &dfp->dfp_work)
> +		ops->log_item(tp, dfp->dfp_intent, li);
> +}
> +
>  /*
>   * For each pending item in the intake list, log its intent item and the
>   * associated extents, then add the entire intake list to the end of
> @@ -187,17 +204,11 @@ STATIC void
>  xfs_defer_create_intents(
>  	struct xfs_trans		*tp)
>  {
> -	struct list_head		*li;
>  	struct xfs_defer_pending	*dfp;
> -	const struct xfs_defer_op_type	*ops;
>  
>  	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
> -		ops = defer_op_types[dfp->dfp_type];
> -		dfp->dfp_intent = ops->create_intent(tp, dfp->dfp_count);
>  		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
> -		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
> -		list_for_each(li, &dfp->dfp_work)
> -			ops->log_item(tp, dfp->dfp_intent, li);
> +		xfs_defer_create_intent(tp, dfp, true);
>  	}
>  }
>  
> @@ -419,17 +430,13 @@ xfs_defer_finish_noroll(
>  		}
>  		if (error == -EAGAIN) {
>  			/*
> -			 * Caller wants a fresh transaction, so log a
> -			 * new log intent item to replace the old one
> -			 * and roll the transaction.  See "Requesting
> -			 * a Fresh Transaction while Finishing
> -			 * Deferred Work" above.
> +			 * Caller wants a fresh transaction, so log a new log
> +			 * intent item to replace the old one and roll the
> +			 * transaction.  See "Requesting a Fresh Transaction
> +			 * while Finishing Deferred Work" above.
>  			 */
> -			dfp->dfp_intent = ops->create_intent(*tp,
> -					dfp->dfp_count);
>  			dfp->dfp_done = NULL;
> -			list_for_each(li, &dfp->dfp_work)
> -				ops->log_item(*tp, dfp->dfp_intent, li);
> +			xfs_defer_create_intent(*tp, dfp, false);
>  		} else {
>  			/* Done with the dfp, free it. */
>  			list_del(&dfp->dfp_list);
> -- 
> 2.26.2
> 

