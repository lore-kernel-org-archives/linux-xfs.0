Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA7AC3F2D2
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9743F20870
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:05:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fNXAC6Jz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgCESF7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 13:05:59 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58863 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726049AbgCESF7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 13:05:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583431557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7H9v1FUXySTEnC7icBBKUiYWp4nTLFhZY2HhVxhqK5M=;
        b=fNXAC6JzVva22xqUhRr//6pbMgfZFJFoq9O7eRoXxRnmpPBDSkF9ZTfjWTjj4JeQJCifGs
        dPRyjCva1clP8OOTPLknZzLRrNDPcTi0Kn/DF8GPXmysZJhy8SZ+8S/3ZoaCcQLi8PAmfJ
        s7yej9U9A/XKIhpSob5BSOXdFnV3NJc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-vMCOzIzdN7WUOEqOipTzGA-1; Thu, 05 Mar 2020 13:05:55 -0500
X-MC-Unique: vMCOzIzdN7WUOEqOipTzGA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7B6C100550D;
        Thu,  5 Mar 2020 18:05:54 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 84EF727BD7;
        Thu,  5 Mar 2020 18:05:54 +0000 (UTC)
Date:   Thu, 5 Mar 2020 13:05:52 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] xfs: re-order initial space accounting checks in
 xlog_write
Message-ID: <20200305180552.GB28340@bfoster>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-3-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:53:52PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit and unmount records records do not need start records to be
> written, so rearrange the logic in xlog_write() to remove the need
> to check for XLOG_TIC_INITED to determine if we should account for
> the space used by a start record.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 35 +++++++++++------------------------
>  1 file changed, 11 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 5b0568a86c07..d6c42954b70c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
...
> @@ -2393,27 +2393,17 @@ xlog_write(
>  	int			error = 0;
>  	int			start_rec_size = sizeof(struct xlog_op_header);
>  
> -	*start_lsn = 0;
> -
> -
>  	/*
> -	 * Region headers and bytes are already accounted for.
> -	 * We only need to take into account start records and
> -	 * split regions in this function.
> +	 * If this is a commit or unmount transaction, we don't need a start
> +	 * record to be written. We do, however, have to account for the
> +	 * commit or unmount header that gets written. Hence we always have
> +	 * to account for an extra xlog_op_header here.
>  	 */

This addresses my comment on the previous patch, thanks. ;)

> -	if (ticket->t_flags & XLOG_TIC_INITED) {
> -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> +	ticket->t_curr_res -= sizeof(xlog_op_header_t);

Ok, so we're combining the fact that either the ticket is inited (we
have a start rec) or otherwise this is an unmount or commit_trans write
with an associated header.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	if (ticket->t_flags & XLOG_TIC_INITED)
>  		ticket->t_flags &= ~XLOG_TIC_INITED;
> -	}
> -
> -	/*
> -	 * Commit record headers need to be accounted for. These
> -	 * come in as separate writes so are easy to detect.
> -	 */
> -	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
> -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> +	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
>  		start_rec_size = 0;
> -	}
>  
>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
> @@ -2423,10 +2413,7 @@ xlog_write(
>  	}
>  
>  	len = xlog_write_calc_vec_length(ticket, log_vector, start_rec_size);
> -
> -	index = 0;
> -	lv = log_vector;
> -	vecp = lv->lv_iovecp;
> +	*start_lsn = 0;
>  	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
>  		void		*ptr;
>  		int		log_offset;
> -- 
> 2.24.0.rc0
> 

