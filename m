Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D876BC3F2D2
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89FB320716
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:08:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ME5GYfau"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgCESI2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 13:08:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42095 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726368AbgCESI2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 13:08:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583431707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9mcXuWNRwm10NIazLYzp7I2nYxhOGvQiJPslGHl+uEo=;
        b=ME5GYfautWZ6TxOBUsdp/rjfA473lgCO8SCUTGJ5NJLN8JVrlpETlYYsfqG3JRpZdJD1Ua
        me9FIyFFyaU7p+jVh9e5vMU5+thdS9q6iW0P4u0jrMlJj2ubx6Nd3Ro1Kra90rKJdQwjNH
        cjIchEG7bWlczQM7jX4wxkNuluiC4Lo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-w0L144K1Ojm4ppqM7iOPBg-1; Thu, 05 Mar 2020 13:08:25 -0500
X-MC-Unique: w0L144K1Ojm4ppqM7iOPBg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54C9BA0CBF;
        Thu,  5 Mar 2020 18:08:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E21148;
        Thu,  5 Mar 2020 18:08:23 +0000 (UTC)
Date:   Thu, 5 Mar 2020 13:08:22 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: kill XLOG_TIC_INITED
Message-ID: <20200305180822.GK28340@bfoster>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-12-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:54:01PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It is not longer used or checked by anything, so remove the last
> traces from the log ticket code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c      | 1 -
>  fs/xfs/xfs_log_priv.h | 6 ++----
>  2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 89956484848f..b91efc5829e1 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3529,7 +3529,6 @@ xlog_ticket_alloc(
>  	tic->t_ocnt		= cnt;
>  	tic->t_tid		= prandom_u32();
>  	tic->t_clientid		= client;
> -	tic->t_flags		= XLOG_TIC_INITED;
>  	if (permanent)
>  		tic->t_flags |= XLOG_TIC_PERM_RESERV;
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 081d4c6de2c8..e989cf024ffe 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -51,13 +51,11 @@ enum xlog_iclog_state {
>  };
>  
>  /*
> - * Flags to log ticket
> + * Log ticket flags
>   */
> -#define XLOG_TIC_INITED		0x1	/* has been initialized */
> -#define XLOG_TIC_PERM_RESERV	0x2	/* permanent reservation */
> +#define XLOG_TIC_PERM_RESERV	0x1	/* permanent reservation */
>  
>  #define XLOG_TIC_FLAGS \
> -	{ XLOG_TIC_INITED,	"XLOG_TIC_INITED" }, \
>  	{ XLOG_TIC_PERM_RESERV,	"XLOG_TIC_PERM_RESERV" }
>  
>  /*
> -- 
> 2.24.0.rc0
> 

