Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CB2C3F2D2
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9AFA20716
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:07:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZhN3fUlI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgCESHs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 13:07:48 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53596 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgCESHs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 13:07:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583431667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qQ5lEFb69HxWlgZ9lRegc+wWGwu4bzQCVsEEc7/yNsU=;
        b=ZhN3fUlI/6cUFIXHDvAZc0M45sXM2ReLxyp/mVIaF/Fy+p+yg1AGhipcZiLQrzW+vG1lJc
        a7cdbFUxRtJs4dYTjJyzAx6fPUI/YRiQ2mZ24pn5zmZcMEb3/rrmjsMWrJInvMPwprLgy1
        kxjmcWjspqFLVi1ANI2KakqjwFYp8aU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-mu85fkpUOMWsnPve25aBtA-1; Thu, 05 Mar 2020 13:07:45 -0500
X-MC-Unique: mu85fkpUOMWsnPve25aBtA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A43BA6125E;
        Thu,  5 Mar 2020 18:07:44 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5131F272A7;
        Thu,  5 Mar 2020 18:07:44 +0000 (UTC)
Date:   Thu, 5 Mar 2020 13:07:42 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: rename the log unmount writing functions.
Message-ID: <20200305180742.GH28340@bfoster>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-9-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:53:58PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The naming and calling conventions are a bit of a mess. Clean it up
> so the call chain looks like:
> 
> 	xfs_log_unmount_write(mp)
> 	  xlog_unmount_write(log)
> 	    xlog_write_unmount_record(log, ticket)
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a310ca9e7615..bdf604d31d8c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -491,7 +491,7 @@ xfs_log_reserve(
>   * transaction context that has already done the accounting for us.
>   */
>  static int
> -xlog_write_unmount(
> +xlog_write_unmount_record(
>  	struct xlog		*log,
>  	struct xlog_ticket	*ticket,
>  	xfs_lsn_t		*lsn,
> @@ -903,10 +903,10 @@ xlog_state_ioerror(
>   * log.
>   */
>  static void
> -xfs_log_write_unmount_record(
> -	struct xfs_mount	*mp)
> +xlog_unmount_write(
> +	struct xlog		*log)
>  {
> -	struct xlog		*log = mp->m_log;
> +	struct xfs_mount	*mp = log->l_mp;
>  	struct xlog_in_core	*iclog;
>  	struct xlog_ticket	*tic = NULL;
>  	xfs_lsn_t		lsn;
> @@ -930,7 +930,7 @@ xfs_log_write_unmount_record(
>  		flags &= ~XLOG_UNMOUNT_TRANS;
>  	}
>  
> -	error = xlog_write_unmount(log, tic, &lsn, flags);
> +	error = xlog_write_unmount_record(log, tic, &lsn, flags);
>  	/*
>  	 * At this point, we're umounting anyway, so there's no point in
>  	 * transitioning log state to IOERROR. Just continue...
> @@ -1006,7 +1006,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  	} while (iclog != first_iclog);
>  #endif
>  	if (! (XLOG_FORCED_SHUTDOWN(log))) {
> -		xfs_log_write_unmount_record(mp);
> +		xlog_unmount_write(log);
>  	} else {
>  		/*
>  		 * We're already in forced_shutdown mode, couldn't
> -- 
> 2.24.0.rc0
> 

