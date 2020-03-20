Return-Path: <SRS0=ynSb=5F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF949C4332B
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 11:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9482920732
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 11:52:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DIhlZWHl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCTLwB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 07:52:01 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:49833 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726814AbgCTLwA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Mar 2020 07:52:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584705119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vay2uE4/QB4envo/zu0nnrwnCqE2yYBaEybF3nmpyuI=;
        b=DIhlZWHlE5de8jzNNqkuAQUt6w4C6ULIa0bhe+BHzeoqE9BJyjKPkaWRXuiVJW21mVbZH9
        0UidhADPR+Bj8uWiVSJVmcgMYDXx2Xx/LJMnsKtYhJMKZV4JvTt18PyqKgB3DPCQRNLTIv
        njd5cHUJKvbXGueF8RH3qHpOQ3pvy0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-5_dik0JbM1SlJ5C6SCWWSg-1; Fri, 20 Mar 2020 07:51:55 -0400
X-MC-Unique: 5_dik0JbM1SlJ5C6SCWWSg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F5F68014D4;
        Fri, 20 Mar 2020 11:51:54 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A75CD19C58;
        Fri, 20 Mar 2020 11:51:53 +0000 (UTC)
Date:   Fri, 20 Mar 2020 07:51:51 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/8] xfs: refactor xlog_state_clean_iclog
Message-ID: <20200320115151.GA42814@bfoster>
References: <20200320065311.28134-1-hch@lst.de>
 <20200320065311.28134-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320065311.28134-7-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 20, 2020 at 07:53:09AM +0100, Christoph Hellwig wrote:
> Factor out a few self-contained helpers from xlog_state_clean_iclog, and
> update the documentation so it primarily documents why things happens
> instead of how.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 180 +++++++++++++++++++++++------------------------
>  1 file changed, 88 insertions(+), 92 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 4f9303524efb..6facbb91b8a8 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2540,111 +2540,107 @@ xlog_write(
>   *****************************************************************************
>   */
>  
> +static void
> +xlog_state_activate_iclog(
> +	struct xlog_in_core	*iclog,
> +	int			*iclogs_changed)
> +{
> +	ASSERT(list_empty_careful(&iclog->ic_callbacks));
> +
> +	/*
> +	 * If the number of ops in this iclog indicate it just contains the
> +	 * dummy transaction, we can change state into IDLE (the second time
> +	 * around). Otherwise we should change the state into NEED a dummy.
> +	 * We don't need to cover the dummy.
> +	 */
> +	if (*iclogs_changed == 0 &&
> +	    iclog->ic_header.h_num_logops == cpu_to_be32(XLOG_COVER_OPS)) {
> +		*iclogs_changed = 1;
> +	} else {
> +		/*
> +		 * We have two dirty iclogs so start over.  This could also be
> +		 * num of ops indicating this is not the dummy going out.
> +		 */
> +		*iclogs_changed = 2;
> +	}
> +
> +	iclog->ic_state	= XLOG_STATE_ACTIVE;
> +	iclog->ic_offset = 0;
> +	iclog->ic_header.h_num_logops = 0;
> +	memset(iclog->ic_header.h_cycle_data, 0,
> +		sizeof(iclog->ic_header.h_cycle_data));
> +	iclog->ic_header.h_lsn = 0;
> +}
> +
>  /*
> - * An iclog has just finished IO completion processing, so we need to update
> - * the iclog state and propagate that up into the overall log state. Hence we
> - * prepare the iclog for cleaning, and then clean all the pending dirty iclogs
> - * starting from the head, and then wake up any threads that are waiting for the
> - * iclog to be marked clean.
> - *
> - * The ordering of marking iclogs ACTIVE must be maintained, so an iclog
> - * doesn't become ACTIVE beyond one that is SYNCING.  This is also required to
> - * maintain the notion that we use a ordered wait queue to hold off would be
> - * writers to the log when every iclog is trying to sync to disk.
> - *
> - * Caller must hold the icloglock before calling us.
> - *
> - * State Change: !IOERROR -> DIRTY -> ACTIVE
> + * Loop through all iclogs and mark all iclogs currently marked DIRTY as
> + * ACTIVE after iclog I/O has completed.
>   */
> -STATIC void
> -xlog_state_clean_iclog(
> +static void
> +xlog_state_activate_iclogs(
>  	struct xlog		*log,
> -	struct xlog_in_core	*dirty_iclog)
> +	int			*iclogs_changed)
>  {
> -	struct xlog_in_core	*iclog;
> -	int			changed = 0;
> -
> -	/* Prepare the completed iclog. */
> -	if (dirty_iclog->ic_state != XLOG_STATE_IOERROR)
> -		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
> +	struct xlog_in_core	*iclog = log->l_iclog;
>  
> -	/* Walk all the iclogs to update the ordered active state. */
> -	iclog = log->l_iclog;
>  	do {
> -		if (iclog->ic_state == XLOG_STATE_DIRTY) {
> -			iclog->ic_state	= XLOG_STATE_ACTIVE;
> -			iclog->ic_offset       = 0;
> -			ASSERT(list_empty_careful(&iclog->ic_callbacks));
> -			/*
> -			 * If the number of ops in this iclog indicate it just
> -			 * contains the dummy transaction, we can
> -			 * change state into IDLE (the second time around).
> -			 * Otherwise we should change the state into
> -			 * NEED a dummy.
> -			 * We don't need to cover the dummy.
> -			 */
> -			if (!changed &&
> -			   (be32_to_cpu(iclog->ic_header.h_num_logops) ==
> -			   		XLOG_COVER_OPS)) {
> -				changed = 1;
> -			} else {
> -				/*
> -				 * We have two dirty iclogs so start over
> -				 * This could also be num of ops indicates
> -				 * this is not the dummy going out.
> -				 */
> -				changed = 2;
> -			}
> -			iclog->ic_header.h_num_logops = 0;
> -			memset(iclog->ic_header.h_cycle_data, 0,
> -			      sizeof(iclog->ic_header.h_cycle_data));
> -			iclog->ic_header.h_lsn = 0;
> -		} else if (iclog->ic_state == XLOG_STATE_ACTIVE)
> -			/* do nothing */;
> -		else
> -			break;	/* stop cleaning */
> -		iclog = iclog->ic_next;
> -	} while (iclog != log->l_iclog);
> -
> +		if (iclog->ic_state == XLOG_STATE_DIRTY)
> +			xlog_state_activate_iclog(iclog, iclogs_changed);
> +		/*
> +		 * The ordering of marking iclogs ACTIVE must be maintained, so
> +		 * an iclog doesn't become ACTIVE beyond one that is SYNCING.
> +		 */
> +		else if (iclog->ic_state != XLOG_STATE_ACTIVE)
> +			break;
> +	} while ((iclog = iclog->ic_next) != log->l_iclog);
> +}
>  
> +static int
> +xlog_covered_state(
> +	int			prev_state,
> +	int			iclogs_changed)
> +{
>  	/*
> -	 * Wake up threads waiting in xfs_log_force() for the dirty iclog
> -	 * to be cleaned.
> +	 * We usually go to NEED. But we go to NEED2 if the changed indicates we
> +	 * are done writing the dummy record.  If we are done with the second
> +	 * dummy recored (DONE2), then we go to IDLE.
>  	 */
> -	wake_up_all(&dirty_iclog->ic_force_wait);
> +	switch (prev_state) {
> +	case XLOG_STATE_COVER_IDLE:
> +	case XLOG_STATE_COVER_NEED:
> +	case XLOG_STATE_COVER_NEED2:
> +		break;
> +	case XLOG_STATE_COVER_DONE:
> +		if (iclogs_changed == 1)
> +			return XLOG_STATE_COVER_NEED2;
> +		break;
> +	case XLOG_STATE_COVER_DONE2:
> +		if (iclogs_changed == 1)
> +			return XLOG_STATE_COVER_IDLE;
> +		break;
> +	default:
> +		ASSERT(0);
> +	}
>  
> -	/*
> -	 * Change state for the dummy log recording.
> -	 * We usually go to NEED. But we go to NEED2 if the changed indicates
> -	 * we are done writing the dummy record.
> -	 * If we are done with the second dummy recored (DONE2), then
> -	 * we go to IDLE.
> -	 */
> -	if (changed) {
> -		switch (log->l_covered_state) {
> -		case XLOG_STATE_COVER_IDLE:
> -		case XLOG_STATE_COVER_NEED:
> -		case XLOG_STATE_COVER_NEED2:
> -			log->l_covered_state = XLOG_STATE_COVER_NEED;
> -			break;
> +	return XLOG_STATE_COVER_NEED;
> +}
>  
> -		case XLOG_STATE_COVER_DONE:
> -			if (changed == 1)
> -				log->l_covered_state = XLOG_STATE_COVER_NEED2;
> -			else
> -				log->l_covered_state = XLOG_STATE_COVER_NEED;
> -			break;
> +STATIC void
> +xlog_state_clean_iclog(
> +	struct xlog		*log,
> +	struct xlog_in_core	*dirty_iclog)
> +{
> +	int			iclogs_changed = 0;
>  
> -		case XLOG_STATE_COVER_DONE2:
> -			if (changed == 1)
> -				log->l_covered_state = XLOG_STATE_COVER_IDLE;
> -			else
> -				log->l_covered_state = XLOG_STATE_COVER_NEED;
> -			break;
> +	if (dirty_iclog->ic_state != XLOG_STATE_IOERROR)
> +		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
>  
> -		default:
> -			ASSERT(0);
> -		}
> +	xlog_state_activate_iclogs(log, &iclogs_changed);
> +	wake_up_all(&dirty_iclog->ic_force_wait);
> +
> +	if (iclogs_changed) {
> +		log->l_covered_state = xlog_covered_state(log->l_covered_state,
> +				iclogs_changed);
>  	}
>  }
>  
> -- 
> 2.25.1
> 

