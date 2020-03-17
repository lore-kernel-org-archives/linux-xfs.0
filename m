Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C53C10F29
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 13:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DB7D20738
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 13:24:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ikNshbsJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgCQNYM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 09:24:12 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:59237 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgCQNYM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 09:24:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584451452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0nWTs3Zuh1CrbmcpgzWNgcjdzvSVypV9d5Z+EdpSZT8=;
        b=ikNshbsJnUroP31bqo45/4jKDHTlsxvwpCdhH2KU9Kh5Tykw79kLD8sJsBydBhPYteYZa7
        2JZLkn4UacasoiJ/FKxqKYCz+McRUA5GFVd+nzrWJ+y8OY0SFNuc/TS26pf8maZIZKSDIW
        LSMft+Qh0qqnbUqEi92Mkjh9VjLSrc4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-bOgJ1zpwMtueL6jRCouL-A-1; Tue, 17 Mar 2020 09:24:10 -0400
X-MC-Unique: bOgJ1zpwMtueL6jRCouL-A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B9FD477;
        Tue, 17 Mar 2020 13:24:09 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B939460BE0;
        Tue, 17 Mar 2020 13:24:08 +0000 (UTC)
Date:   Tue, 17 Mar 2020 09:24:06 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/14] xfs: simplify log shutdown checking in
 xfs_log_release_iclog
Message-ID: <20200317132406.GE24078@bfoster>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:23PM +0100, Christoph Hellwig wrote:
> There is no need to check for the ioerror state before the lock, as
> the shutdown case is not a fast path.  Also remove the call to force
> shutdown the file system, as it must have been shut down already
> for an iclog to be in the ioerror state.  Also clean up the flow of
> the function a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 17ba92b115ea..7af9c292540b 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -602,24 +602,16 @@ xfs_log_release_iclog(
>  	struct xlog_in_core	*iclog)
>  {
>  	struct xlog		*log = iclog->ic_log;
> -	bool			sync;
> -
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> -		goto error;
> +	bool			sync = false;
>  
>  	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> -		if (iclog->ic_state == XLOG_STATE_IOERROR) {
> -			spin_unlock(&log->l_icloglock);
> -			goto error;
> -		}
> -		sync = __xlog_state_release_iclog(log, iclog);
> +		if (iclog->ic_state != XLOG_STATE_IOERROR)
> +			sync = __xlog_state_release_iclog(log, iclog);
>  		spin_unlock(&log->l_icloglock);
> -		if (sync)
> -			xlog_sync(log, iclog);
>  	}
> -	return;
> -error:
> -	xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> +
> +	if (sync)
> +		xlog_sync(log, iclog);
>  }
>  
>  /*
> -- 
> 2.24.1
> 

