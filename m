Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8AEC3F2D2
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03BA320716
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:07:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hPKT7gjg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgCESHA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 13:07:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51055 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726083AbgCESHA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 13:07:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583431619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g8XEHwCwK+qSjmVK39y18NkIsOFdOjvPdxklAxrc/ds=;
        b=hPKT7gjg72iMgDQXglEwXw8G8ftkceNq1AG1zax9CWiEGY12W6zQcP64u8lSAmVyd73HMy
        wDhkM7/cLEU7yjfcH6diRUBUQKYz6bQAkm60mMqfMrBo+jD1iCixzfH5HQp+U4G9DpB7h/
        2oJtNIYZwJMwZQ1DbH5WH7NS61xWgLc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-pS4xeon9O1SJeHM1-YnwTA-1; Thu, 05 Mar 2020 13:06:57 -0500
X-MC-Unique: pS4xeon9O1SJeHM1-YnwTA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 683DF800D50;
        Thu,  5 Mar 2020 18:06:56 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FCA99A6A;
        Thu,  5 Mar 2020 18:06:56 +0000 (UTC)
Date:   Thu, 5 Mar 2020 13:06:54 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: merge xlog_commit_record with
 xlog_write_done()
Message-ID: <20200305180654.GD28340@bfoster>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-5-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:53:54PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xlog_write_done() is just a thin wrapper around
> xlog_commit_record(), so they can be merged together easily. Convert
> all the xlog_commit_record() callers to use xlog_write_done() and
> merge the implementations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

I think Christoph disagrees but I actually prefer to see the incremental
steps:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 60 +++++++++++++++---------------------------------
>  1 file changed, 19 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 702b38e4db6e..100eeaed4a7d 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -24,13 +24,6 @@
>  kmem_zone_t	*xfs_log_ticket_zone;
>  
>  /* Local miscellaneous function prototypes */
> -STATIC int
> -xlog_commit_record(
> -	struct xlog		*log,
> -	struct xlog_ticket	*ticket,
> -	struct xlog_in_core	**iclog,
> -	xfs_lsn_t		*commitlsnp);
> -
>  STATIC struct xlog *
>  xlog_alloc_log(
>  	struct xfs_mount	*mp,
> @@ -493,7 +486,8 @@ xfs_log_reserve(
>   */
>  
>  /*
> - * Write a commit record to the log to close off a running log write.
> + * Write out the commit record of a transaction associated with the given
> + * ticket to close off a running log write. Return the lsn of the commit record.
>   */
>  int
>  xlog_write_done(
> @@ -502,10 +496,26 @@ xlog_write_done(
>  	struct xlog_in_core	**iclog,
>  	xfs_lsn_t		*lsn)
>  {
> +	struct xfs_log_iovec reg = {
> +		.i_addr = NULL,
> +		.i_len = 0,
> +		.i_type = XLOG_REG_TYPE_COMMIT,
> +	};
> +	struct xfs_log_vec vec = {
> +		.lv_niovecs = 1,
> +		.lv_iovecp = &reg,
> +	};
> +	int	error;
> +
> +	ASSERT_ALWAYS(iclog);
> +
>  	if (XLOG_FORCED_SHUTDOWN(log))
>  		return -EIO;
>  
> -	return xlog_commit_record(log, ticket, iclog, lsn);
> +	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
> +	if (error)
> +		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> +	return error;
>  }
>  
>  /*
> @@ -1529,38 +1539,6 @@ xlog_alloc_log(
>  	return ERR_PTR(error);
>  }	/* xlog_alloc_log */
>  
> -
> -/*
> - * Write out the commit record of a transaction associated with the given
> - * ticket.  Return the lsn of the commit record.
> - */
> -STATIC int
> -xlog_commit_record(
> -	struct xlog		*log,
> -	struct xlog_ticket	*ticket,
> -	struct xlog_in_core	**iclog,
> -	xfs_lsn_t		*commitlsnp)
> -{
> -	struct xfs_mount *mp = log->l_mp;
> -	int	error;
> -	struct xfs_log_iovec reg = {
> -		.i_addr = NULL,
> -		.i_len = 0,
> -		.i_type = XLOG_REG_TYPE_COMMIT,
> -	};
> -	struct xfs_log_vec vec = {
> -		.lv_niovecs = 1,
> -		.lv_iovecp = &reg,
> -	};
> -
> -	ASSERT_ALWAYS(iclog);
> -	error = xlog_write(log, &vec, ticket, commitlsnp, iclog,
> -					XLOG_COMMIT_TRANS);
> -	if (error)
> -		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> -	return error;
> -}
> -
>  /*
>   * Push on the buffer cache code if we ever use more than 75% of the on-disk
>   * log space.  This code pushes on the lsn which would supposedly free up
> -- 
> 2.24.0.rc0
> 

