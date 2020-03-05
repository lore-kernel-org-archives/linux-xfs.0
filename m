Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFD1C3F2D2
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10A1720870
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:07:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gc/GDHZv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgCESHk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 13:07:40 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36771 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726083AbgCESHk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 13:07:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583431659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=83r6JMxUgXzKaQbAnILdACphg6I6dCc0po6nc8p1UUE=;
        b=gc/GDHZvAyCQnmMd1JxNy/Q39U8gBVSnPemm86FLUpwv4967E+/if9xYdyhJj9qV88HFG7
        tV+7NgQ6c8RK1c4lPHnn+F9cYKMGUrMyfYLgxGiO8QXg4z/bvajSsNmGTLxFMigl9DXxCl
        Mcwb6QIR+ClUaxDnXNXHi5McJV3X7fk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-f_WPMdScOe-hVd2dEAXSvw-1; Thu, 05 Mar 2020 13:07:37 -0500
X-MC-Unique: f_WPMdScOe-hVd2dEAXSvw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E93561088385;
        Thu,  5 Mar 2020 18:07:36 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A36618F356;
        Thu,  5 Mar 2020 18:07:36 +0000 (UTC)
Date:   Thu, 5 Mar 2020 13:07:35 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/11] xfs: clean up xlog_state_ioerror()
Message-ID: <20200305180735.GG28340@bfoster>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-8-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:53:57PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 34 ++++++++++++++--------------------
>  1 file changed, 14 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 0de3c32d42b6..a310ca9e7615 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -875,33 +875,27 @@ xfs_log_mount_cancel(
>  }
>  
>  /*
> - * Mark all iclogs IOERROR. l_icloglock is held by the caller.
> + * Mark all iclogs IOERROR. l_icloglock is held by the caller. Returns 1 if the
> + * log was already in an IO state, 0 otherwise. From now one, no log flushes

							   s/one/on

Otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> + * will occur.
>   */
>  STATIC int
>  xlog_state_ioerror(
> -	struct xlog	*log)
> +	struct xlog		*log)
>  {
> -	xlog_in_core_t	*iclog, *ic;
> +	struct xlog_in_core	*iclog = log->l_iclog;
> +	struct xlog_in_core	*ic = iclog;
>  
>  	log->l_flags |= XLOG_IO_ERROR;
> +	if (iclog->ic_state == XLOG_STATE_IOERROR)
> +		return 1;
>  
> -	iclog = log->l_iclog;
> -	if (iclog->ic_state != XLOG_STATE_IOERROR) {
> -		/*
> -		 * Mark all the incore logs IOERROR.
> -		 * From now on, no log flushes will result.
> -		 */
> -		ic = iclog;
> -		do {
> -			ic->ic_state = XLOG_STATE_IOERROR;
> -			ic = ic->ic_next;
> -		} while (ic != iclog);
> -		return 0;
> -	}
> -	/*
> -	 * Return non-zero, if state transition has already happened.
> -	 */
> -	return 1;
> +	do {
> +		ic->ic_state = XLOG_STATE_IOERROR;
> +		ic = ic->ic_next;
> +	} while (ic != iclog);
> +
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.24.0.rc0
> 

