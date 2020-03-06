Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC51C10DCE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 17:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EEDE20658
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 17:12:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UFaq2y01"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCFRMb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 12:12:31 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52280 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726231AbgCFRMb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 12:12:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583514750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A2HNAmn4vJ1tx6PA2xXB2DUzVEimjFRKqjtFJL+sWrA=;
        b=UFaq2y01Awg7m5IdFB3Fg4aEswX0ZfW2ylSkrHUeDsdwqi7MKOH28X3Fbhy3mkt+avCm13
        lnCZdWecnckq0CJnS5DmjKLJHZ+s9CcLi6tH/SPXnKgyYPkBF05B0xAs7EcWh36mY9MZxx
        rFvwhf5Lisk1FKk1448pe5TjCjbncaA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-p7j9mKYMMwus36hbspXFwQ-1; Fri, 06 Mar 2020 12:12:28 -0500
X-MC-Unique: p7j9mKYMMwus36hbspXFwQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E063100550D;
        Fri,  6 Mar 2020 17:12:27 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A130C19C69;
        Fri,  6 Mar 2020 17:12:26 +0000 (UTC)
Date:   Fri, 6 Mar 2020 12:12:24 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/7] xfs: cleanup xlog_state_clean_iclog
Message-ID: <20200306171224.GI2773@bfoster>
References: <20200306143137.236478-1-hch@lst.de>
 <20200306143137.236478-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306143137.236478-7-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 07:31:36AM -0700, Christoph Hellwig wrote:
> Use the shutdown flag in the log to bypass the iclog processing
> instead of looking at the ioerror flag, and slightly simplify the
> while loop processing.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index d1accad13af4..fae5107099b1 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2582,30 +2582,29 @@ xlog_state_activate_iclog(
>   *
>   * Caller must hold the icloglock before calling us.
>   *
> - * State Change: !IOERROR -> DIRTY -> ACTIVE
> + * State Change: CALLBACK -> DIRTY -> ACTIVE
>   */
>  STATIC void
>  xlog_state_clean_iclog(
>  	struct xlog		*log,
>  	struct xlog_in_core	*dirty_iclog)
>  {
> -	struct xlog_in_core	*iclog;
>  	int			changed = 0;
>  
> -	/* Prepare the completed iclog. */
> -	if (dirty_iclog->ic_state != XLOG_STATE_IOERROR)
> -		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
> +	if (!XLOG_FORCED_SHUTDOWN(log)) {
> +		struct xlog_in_core	*iclog = log->l_iclog;
>  
> -	/* Walk all the iclogs to update the ordered active state. */
> -	iclog = log->l_iclog;
> -	do {
> -		if (iclog->ic_state == XLOG_STATE_DIRTY)
> -			xlog_state_activate_iclog(iclog, &changed);
> -		else if (iclog->ic_state != XLOG_STATE_ACTIVE)
> -			break;
> -		iclog = iclog->ic_next;
> -	} while (iclog != log->l_iclog);
> +		/* Prepare the completed iclog. */
> +		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
>  
> +		/* Walk all the iclogs to update the ordered active state. */
> +		do {
> +			if (iclog->ic_state == XLOG_STATE_DIRTY)
> +				xlog_state_activate_iclog(iclog, &changed);
> +			else if (iclog->ic_state != XLOG_STATE_ACTIVE)
> +				break;
> +		} while ((iclog = iclog->ic_next) != log->l_iclog);
> +	}
>  
>  	/*
>  	 * Wake up threads waiting in xfs_log_force() for the dirty iclog
> -- 
> 2.24.1
> 

