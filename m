Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 394CDC10F29
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 13:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0479820738
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 13:25:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z8x8NK6n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgCQNZU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 09:25:20 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:59055 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725872AbgCQNZU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 09:25:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584451519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nwV0HEu+aysn9w447n1K7VW4CxBaJXtR53YpZm1g6oI=;
        b=Z8x8NK6n1XbJTcd+MAAHOZKZeGNUCYUt64aBIuuJVhToWkjoT7uX5Uy3IhJko44Fw3kRJ1
        xwAbn+AeesvuO0WceI8a08J7CLLgAvCwYBypjtzKqxLghpE6+2CE58nhhMqvmcRNzyM5Pr
        W2nM0SscLmxPlzAPrdN+U2yB+kOwR8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-x0tpD4dmN_WxrP_JmGdEaQ-1; Tue, 17 Mar 2020 09:25:15 -0400
X-MC-Unique: x0tpD4dmN_WxrP_JmGdEaQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E29AB800D5A;
        Tue, 17 Mar 2020 13:25:14 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8ABE27E319;
        Tue, 17 Mar 2020 13:25:14 +0000 (UTC)
Date:   Tue, 17 Mar 2020 09:25:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/14] xfs: move the ioerror check out of
 xlog_state_clean_iclog
Message-ID: <20200317132512.GH24078@bfoster>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-8-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:26PM +0100, Christoph Hellwig wrote:
> Use the shutdown flag in the log to bypass xlog_state_clean_iclog
> entirely in case of a shut down log.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 23979d08a2a3..c490c5b0d8b7 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2632,8 +2632,7 @@ xlog_state_clean_iclog(
>  {
>  	int			iclogs_changed = 0;
>  
> -	if (dirty_iclog->ic_state != XLOG_STATE_IOERROR)
> -		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
> +	dirty_iclog->ic_state = XLOG_STATE_DIRTY;
>  
>  	xlog_state_activate_iclogs(log, &iclogs_changed);
>  	wake_up_all(&dirty_iclog->ic_force_wait);
> @@ -2836,8 +2835,10 @@ xlog_state_do_callback(
>  			 */
>  			cycled_icloglock = true;
>  			xlog_state_do_iclog_callbacks(log, iclog);
> -
> -			xlog_state_clean_iclog(log, iclog);
> +			if (XLOG_FORCED_SHUTDOWN(log))
> +				wake_up_all(&iclog->ic_force_wait);
> +			else
> +				xlog_state_clean_iclog(log, iclog);
>  			iclog = iclog->ic_next;
>  		} while (first_iclog != iclog);
>  
> -- 
> 2.24.1
> 

