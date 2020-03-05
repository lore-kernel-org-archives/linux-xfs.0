Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0782EC3F2D1
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D37B320716
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z3msTGxE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgCESHH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 13:07:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51051 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726083AbgCESHH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 13:07:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583431626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=baP0c7MWa0UW9whAlzViJWbGWxdGhFgxb20rvEFIMwU=;
        b=Z3msTGxEF8xK3Mib5aJUQlTaLN54T2S3rz+rArOaR9KbeACW0nIE99w+/4m0HsFC44uqfL
        WY0gfJDNh6HSQjwRhAnZ0h6UR4amVOYwWpweNkxOX/rSKTmiuq1tP3kj47j011z8AxwmE0
        ew8sA2k6NDfWObwHeiY0J3XJR7v3K5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-f1Jg-C0OPrKz--HiqFLKbg-1; Thu, 05 Mar 2020 13:07:05 -0500
X-MC-Unique: f1Jg-C0OPrKz--HiqFLKbg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A8F2107ACC4;
        Thu,  5 Mar 2020 18:07:04 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ACFC38FBE0;
        Thu,  5 Mar 2020 18:07:03 +0000 (UTC)
Date:   Thu, 5 Mar 2020 13:07:01 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/11] xfs: factor out unmount record writing
Message-ID: <20200305180701.GE28340@bfoster>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-6-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:53:55PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Separate out the unmount record writing from the rest of the
> ticket and log state futzing necessary to make it work. This is
> a no-op, just makes the code cleaner and places the unmount record
> formatting and writing alongside the commit record formatting and
> writing code.
> 
> We can also get rid of the ticket flag clearing before the
> xlog_write() call because it no longer cares about the state of
> XLOG_TIC_INITED.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 59 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 35 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 100eeaed4a7d..2e9f3baa7cc8 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -485,6 +485,38 @@ xfs_log_reserve(
>   *		marked as with WANT_SYNC.
>   */
>  
> +/*
> + * Write out an unmount record using the ticket provided. We have to account for
> + * the data space used in the unmount ticket as this write is not done from a
> + * transaction context that has already done the accounting for us.
> + */
> +static int
> +xlog_write_unmount(
> +	struct xlog		*log,
> +	struct xlog_ticket	*ticket,
> +	xfs_lsn_t		*lsn,
> +	uint			flags)
> +{
> +	/* the data section must be 32 bit size aligned */
> +	struct xfs_unmount_log_format magic = {
> +		.magic = XLOG_UNMOUNT_TYPE,
> +	};
> +	struct xfs_log_iovec reg = {
> +		.i_addr = &magic,
> +		.i_len = sizeof(magic),
> +		.i_type = XLOG_REG_TYPE_UNMOUNT,
> +	};
> +	struct xfs_log_vec vec = {
> +		.lv_niovecs = 1,
> +		.lv_iovecp = &reg,
> +	};
> +
> +	/* account for space used by record data */
> +	ticket->t_curr_res -= sizeof(magic);
> +
> +	return xlog_write(log, &vec, ticket, lsn, NULL, flags);
> +}
> +
>  /*
>   * Write out the commit record of a transaction associated with the given
>   * ticket to close off a running log write. Return the lsn of the commit record.
> @@ -843,31 +875,13 @@ xfs_log_mount_cancel(
>  }
>  
>  /*
> - * Final log writes as part of unmount.
> - *
> - * Mark the filesystem clean as unmount happens.  Note that during relocation
> - * this routine needs to be executed as part of source-bag while the
> - * deallocation must not be done until source-end.
> + * Mark the filesystem clean by writing an unmount record to the head of the
> + * log.
>   */
> -
> -/* Actually write the unmount record to disk. */
>  static void
>  xfs_log_write_unmount_record(
>  	struct xfs_mount	*mp)
>  {
> -	/* the data section must be 32 bit size aligned */
> -	struct xfs_unmount_log_format magic = {
> -		.magic = XLOG_UNMOUNT_TYPE,
> -	};
> -	struct xfs_log_iovec reg = {
> -		.i_addr = &magic,
> -		.i_len = sizeof(magic),
> -		.i_type = XLOG_REG_TYPE_UNMOUNT,
> -	};
> -	struct xfs_log_vec vec = {
> -		.lv_niovecs = 1,
> -		.lv_iovecp = &reg,
> -	};
>  	struct xlog		*log = mp->m_log;
>  	struct xlog_in_core	*iclog;
>  	struct xlog_ticket	*tic = NULL;
> @@ -892,10 +906,7 @@ xfs_log_write_unmount_record(
>  		flags &= ~XLOG_UNMOUNT_TRANS;
>  	}
>  
> -	/* remove inited flag, and account for space used */
> -	tic->t_flags = 0;
> -	tic->t_curr_res -= sizeof(magic);
> -	error = xlog_write(log, &vec, tic, &lsn, NULL, flags);
> +	error = xlog_write_unmount(log, tic, &lsn, flags);
>  	/*
>  	 * At this point, we're umounting anyway, so there's no point in
>  	 * transitioning log state to IOERROR. Just continue...
> -- 
> 2.24.0.rc0
> 

