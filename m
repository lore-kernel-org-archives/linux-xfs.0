Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E65C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 14:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C2C465087
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 14:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhCPOvq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 10:51:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27549 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237548AbhCPOvc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 10:51:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615906291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A/OvfOiv8anqzAakYkjqAREBgSQq2TT0wLzhSPK3rQ0=;
        b=FoUq+pd1jw/5n+8nh/kjiYSW71mzh7VQGy1cSUbCMjPsS3SJXEVy7NipDUZfaiZtoCGOup
        nyjTemxwW9yAliTl67Du6KpbudCpsBUuXl3tGm1brmELA2Lf0F6AyKAv4GjiobbSjPkCn7
        7UXH/zCYW72DjuzYqMgW7NYbj3qaYIo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-qA-YXk_BNY-Tfkkh66unvg-1; Tue, 16 Mar 2021 10:51:29 -0400
X-MC-Unique: qA-YXk_BNY-Tfkkh66unvg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCDBC1858F13;
        Tue, 16 Mar 2021 14:51:28 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7324F60C13;
        Tue, 16 Mar 2021 14:51:28 +0000 (UTC)
Date:   Tue, 16 Mar 2021 10:51:26 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/45] xfs: move log iovec alignment to preparation
 function
Message-ID: <YFDF7vZIY8YiCzps@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-25-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-25-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:22PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To include log op headers directly into the log iovec regions that
> the ophdrs wrap, we need to move the buffer alignment code from
> xlog_finish_iovec() to xlog_prepare_iovec(). This is because the
> xlog_op_header is only 12 bytes long, and we need the buffer that
> the caller formats their data into to be 8 byte aligned.
> 
> Hence once we start prepending the ophdr in xlog_prepare_iovec(), we
> are going to need to manage the padding directly to ensure that the
> buffer pointer returned is correctly aligned.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.h | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index c0c3141944ea..1ca4f2edbdaf 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -21,6 +21,16 @@ struct xfs_log_vec {
>  
>  #define XFS_LOG_VEC_ORDERED	(-1)
>  
> +/*
> + * We need to make sure the buffer pointer returned is naturally aligned for the
> + * biggest basic data type we put into it. We have already accounted for this
> + * padding when sizing the buffer.
> + *
> + * However, this padding does not get written into the log, and hence we have to
> + * track the space used by the log vectors separately to prevent log space hangs
> + * due to inaccurate accounting (i.e. a leak) of the used log space through the
> + * CIL context ticket.
> + */
>  static inline void *
>  xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>  		uint type)
> @@ -34,6 +44,9 @@ xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>  		vec = &lv->lv_iovecp[0];
>  	}
>  
> +	if (!IS_ALIGNED(lv->lv_buf_len, sizeof(uint64_t)))
> +		lv->lv_buf_len = round_up(lv->lv_buf_len, sizeof(uint64_t));
> +
>  	vec->i_type = type;
>  	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
>  
> @@ -43,20 +56,10 @@ xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>  	return vec->i_addr;
>  }
>  
> -/*
> - * We need to make sure the next buffer is naturally aligned for the biggest
> - * basic data type we put into it.  We already accounted for this padding when
> - * sizing the buffer.
> - *
> - * However, this padding does not get written into the log, and hence we have to
> - * track the space used by the log vectors separately to prevent log space hangs
> - * due to inaccurate accounting (i.e. a leak) of the used log space through the
> - * CIL context ticket.
> - */
>  static inline void
>  xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec, int len)
>  {
> -	lv->lv_buf_len += round_up(len, sizeof(uint64_t));
> +	lv->lv_buf_len += len;
>  	lv->lv_bytes += len;
>  	vec->i_len = len;
>  }
> -- 
> 2.28.0
> 

