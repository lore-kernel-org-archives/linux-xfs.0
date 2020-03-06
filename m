Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E991C10DCE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 17:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D812020658
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 17:12:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E7On54Vi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgCFRMW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 12:12:22 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30752 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725873AbgCFRMW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 12:12:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583514740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kiJUKq0q+W1F7oNPoDN5F38Jxb9XPyEHFkwtVp2slfI=;
        b=E7On54VizZTrpQj+Kx7I76FEFKRyYYPrfq7+QVaGrh9mvWmkEzuvQotz21uexmrH+FZoyP
        0XnSiWFc5G1hMWM99yC7XuyY9+cuvYpbNvvlgByt6AVMIcP9gwxovVbBKVXbMDIs/vZrMf
        C1vgwUwjHxEWtFBodiMxI6V9tupHhQY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-oZigdksUOFi21IQAacrrTA-1; Fri, 06 Mar 2020 12:12:17 -0500
X-MC-Unique: oZigdksUOFi21IQAacrrTA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC44E13F5;
        Fri,  6 Mar 2020 17:12:15 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 66EB060BE0;
        Fri,  6 Mar 2020 17:12:15 +0000 (UTC)
Date:   Fri, 6 Mar 2020 12:12:13 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] xfs: factor out a xlog_state_activate_iclog helper
Message-ID: <20200306171213.GH2773@bfoster>
References: <20200306143137.236478-1-hch@lst.de>
 <20200306143137.236478-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306143137.236478-6-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 07:31:35AM -0700, Christoph Hellwig wrote:
> Factor out the code to mark an iclog a active into a new helper.

"mark as active" or just "mark active"

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Otherwise looks fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 68 +++++++++++++++++++++++++-----------------------
>  1 file changed, 36 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 45f7a6eaddea..d1accad13af4 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2536,6 +2536,38 @@ xlog_write(
>   *****************************************************************************
>   */
>  
> +static void
> +xlog_state_activate_iclog(
> +	struct xlog_in_core	*iclog,
> +	int			*changed)
> +{
> +	ASSERT(list_empty_careful(&iclog->ic_callbacks));
> +
> +	/*
> +	 * If the number of ops in this iclog indicate it just contains the
> +	 * dummy transaction, we can change state into IDLE (the second time
> +	 * around). Otherwise we should change the state into NEED a dummy.
> +	 * We don't need to cover the dummy.
> +	 */
> +	if (!*changed &&
> +	    iclog->ic_header.h_num_logops == cpu_to_be32(XLOG_COVER_OPS)) {
> +		*changed = 1;
> +	} else {
> +		/*
> +		 * We have two dirty iclogs so start over.  This could also be
> +		 * num of ops indicating this is not the dummy going out.
> +		 */
> +		*changed = 2;
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
>   * An iclog has just finished IO completion processing, so we need to update
>   * the iclog state and propagate that up into the overall log state. Hence we
> @@ -2567,38 +2599,10 @@ xlog_state_clean_iclog(
>  	/* Walk all the iclogs to update the ordered active state. */
>  	iclog = log->l_iclog;
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
> +		if (iclog->ic_state == XLOG_STATE_DIRTY)
> +			xlog_state_activate_iclog(iclog, &changed);
> +		else if (iclog->ic_state != XLOG_STATE_ACTIVE)
> +			break;
>  		iclog = iclog->ic_next;
>  	} while (iclog != log->l_iclog);
>  
> -- 
> 2.24.1
> 

