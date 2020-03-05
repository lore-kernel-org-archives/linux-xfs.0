Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE904C3F2D8
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8969620716
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:07:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="In2leafa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgCESHX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 13:07:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36201 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726083AbgCESHV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 13:07:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583431641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fWdPj96f/Zy2FxXraQNm/rbGObBxSdC5MV3h2bpKlaI=;
        b=In2leafaZ8GciqVAEi73+IIL3ZyFRI3au4GnTZLjOiLbWZaV3XQKoysBUv12hGnTfYUHHi
        00kBx3xQcRal7iAXvyMDT8/R1HG7YHNHLo+VWKsFGc/BvU7X+DGVnyW46ViEUyw8QZ1md7
        SLc/6kodp+Xk0/uKqLOOYjlu/4si15E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-jcRc5ALeOhyhRfKzrIbqKA-1; Thu, 05 Mar 2020 13:07:16 -0500
X-MC-Unique: jcRc5ALeOhyhRfKzrIbqKA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F12A6189F76A;
        Thu,  5 Mar 2020 18:07:15 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A6AB55D9C9;
        Thu,  5 Mar 2020 18:07:15 +0000 (UTC)
Date:   Thu, 5 Mar 2020 13:07:14 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: move xlog_state_ioerror()
Message-ID: <20200305180714.GF28340@bfoster>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-7-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:53:56PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To clean up unmount record writing error handling, we need to move
> xlog_state_ioerror() higher up in the file. Also move the setting of
> the XLOG_IO_ERROR state to inside the function.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 59 ++++++++++++++++++++++++------------------------
>  1 file changed, 30 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 2e9f3baa7cc8..0de3c32d42b6 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -874,6 +874,36 @@ xfs_log_mount_cancel(
>  	xfs_log_unmount(mp);
>  }
>  
> +/*
> + * Mark all iclogs IOERROR. l_icloglock is held by the caller.
> + */
> +STATIC int
> +xlog_state_ioerror(
> +	struct xlog	*log)
> +{
> +	xlog_in_core_t	*iclog, *ic;

Might as well kill off the typedef usage, though it sounds like
Christoph has code to remove this. Eh, that discussion aside this looks
fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +
> +	log->l_flags |= XLOG_IO_ERROR;
> +
> +	iclog = log->l_iclog;
> +	if (iclog->ic_state != XLOG_STATE_IOERROR) {
> +		/*
> +		 * Mark all the incore logs IOERROR.
> +		 * From now on, no log flushes will result.
> +		 */
> +		ic = iclog;
> +		do {
> +			ic->ic_state = XLOG_STATE_IOERROR;
> +			ic = ic->ic_next;
> +		} while (ic != iclog);
> +		return 0;
> +	}
> +	/*
> +	 * Return non-zero, if state transition has already happened.
> +	 */
> +	return 1;
> +}
> +
>  /*
>   * Mark the filesystem clean by writing an unmount record to the head of the
>   * log.
> @@ -3770,34 +3800,6 @@ xlog_verify_iclog(
>  }	/* xlog_verify_iclog */
>  #endif
>  
> -/*
> - * Mark all iclogs IOERROR. l_icloglock is held by the caller.
> - */
> -STATIC int
> -xlog_state_ioerror(
> -	struct xlog	*log)
> -{
> -	xlog_in_core_t	*iclog, *ic;
> -
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
> -}
> -
>  /*
>   * This is called from xfs_force_shutdown, when we're forcibly
>   * shutting down the filesystem, typically because of an IO error.
> @@ -3868,7 +3870,6 @@ xfs_log_force_umount(
>  	 * Mark the log and the iclogs with IO error flags to prevent any
>  	 * further log IO from being issued or completed.
>  	 */
> -	log->l_flags |= XLOG_IO_ERROR;
>  	retval = xlog_state_ioerror(log);
>  	spin_unlock(&log->l_icloglock);
>  
> -- 
> 2.24.0.rc0
> 

