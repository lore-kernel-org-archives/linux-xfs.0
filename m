Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C753C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 14:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4095020774
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 14:44:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XESkSHHp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgCROoe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 10:44:34 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:58810 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726647AbgCROoe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 10:44:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584542672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vmV+nI693K9ujkzMUxgPcuT9qenDfHobWXCV0BGftaQ=;
        b=XESkSHHp5giHp+v6qsm7BmLlV6XR/4tZPc6/9lNZnPzf2ATzjTtUGCqmmyCi6wUSBc0BHL
        nylUg/MSWDe72CouElBTt+JqPlOztWf/Ji9F6qkYuuaCeA0F9GfHHkoFzaHCHb6cOewKZ8
        zvwAhlfpUKHPiPkUVhqs837uIQjm8J0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-aaTX4D5wM_G0j8Q8j6CjAg-1; Wed, 18 Mar 2020 10:44:29 -0400
X-MC-Unique: aaTX4D5wM_G0j8Q8j6CjAg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A260192D78A;
        Wed, 18 Mar 2020 14:44:28 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CC8262937;
        Wed, 18 Mar 2020 14:44:27 +0000 (UTC)
Date:   Wed, 18 Mar 2020 10:44:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/14] xfs: move xlog_state_do_iclog_callbacks up
Message-ID: <20200318144425.GA32848@bfoster>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-9-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:27PM +0100, Christoph Hellwig wrote:
> Move xlog_state_do_iclog_callbacks a little up, to avoid the need for a
> forward declaration with upcoming changes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 74 ++++++++++++++++++++++++------------------------
>  1 file changed, 37 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c490c5b0d8b7..c534d7007aa3 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2701,6 +2701,43 @@ xlog_state_set_callback(
>  	xlog_grant_push_ail(log, 0);
>  }
>  
> +/*
> + * Keep processing entries in the iclog callback list until we come around and
> + * it is empty.  We need to atomically see that the list is empty and change the
> + * state to DIRTY so that we don't miss any more callbacks being added.
> + *
> + * This function is called with the icloglock held and returns with it held. We
> + * drop it while running callbacks, however, as holding it over thousands of
> + * callbacks is unnecessary and causes excessive contention if we do.
> + */
> +static void
> +xlog_state_do_iclog_callbacks(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog)
> +		__releases(&log->l_icloglock)
> +		__acquires(&log->l_icloglock)
> +{
> +	spin_unlock(&log->l_icloglock);
> +	spin_lock(&iclog->ic_callback_lock);
> +	while (!list_empty(&iclog->ic_callbacks)) {
> +		LIST_HEAD(tmp);
> +
> +		list_splice_init(&iclog->ic_callbacks, &tmp);
> +
> +		spin_unlock(&iclog->ic_callback_lock);
> +		xlog_cil_process_committed(&tmp);
> +		spin_lock(&iclog->ic_callback_lock);
> +	}
> +
> +	/*
> +	 * Pick up the icloglock while still holding the callback lock so we
> +	 * serialise against anyone trying to add more callbacks to this iclog
> +	 * now we've finished processing.
> +	 */
> +	spin_lock(&log->l_icloglock);
> +	spin_unlock(&iclog->ic_callback_lock);
> +}
> +
>  /*
>   * Return true if we need to stop processing, false to continue to the next
>   * iclog. The caller will need to run callbacks if the iclog is returned in the
> @@ -2754,43 +2791,6 @@ xlog_state_iodone_process_iclog(
>  	}
>  }
>  
> -/*
> - * Keep processing entries in the iclog callback list until we come around and
> - * it is empty.  We need to atomically see that the list is empty and change the
> - * state to DIRTY so that we don't miss any more callbacks being added.
> - *
> - * This function is called with the icloglock held and returns with it held. We
> - * drop it while running callbacks, however, as holding it over thousands of
> - * callbacks is unnecessary and causes excessive contention if we do.
> - */
> -static void
> -xlog_state_do_iclog_callbacks(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog)
> -		__releases(&log->l_icloglock)
> -		__acquires(&log->l_icloglock)
> -{
> -	spin_unlock(&log->l_icloglock);
> -	spin_lock(&iclog->ic_callback_lock);
> -	while (!list_empty(&iclog->ic_callbacks)) {
> -		LIST_HEAD(tmp);
> -
> -		list_splice_init(&iclog->ic_callbacks, &tmp);
> -
> -		spin_unlock(&iclog->ic_callback_lock);
> -		xlog_cil_process_committed(&tmp);
> -		spin_lock(&iclog->ic_callback_lock);
> -	}
> -
> -	/*
> -	 * Pick up the icloglock while still holding the callback lock so we
> -	 * serialise against anyone trying to add more callbacks to this iclog
> -	 * now we've finished processing.
> -	 */
> -	spin_lock(&log->l_icloglock);
> -	spin_unlock(&iclog->ic_callback_lock);
> -}
> -
>  STATIC void
>  xlog_state_do_callback(
>  	struct xlog		*log)
> -- 
> 2.24.1
> 

