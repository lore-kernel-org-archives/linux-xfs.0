Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C21C433E7
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EC5D207EA
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:39:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hwSxC9hY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgIBRjL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 13:39:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30945 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbgIBRjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 13:39:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599068349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hOhILvKjQasrWvOiRF7h3Hc4ppnb5kYk+dM6aaQW8T4=;
        b=hwSxC9hYZApuL3bfm0xbwMp2gaXj+Ou3k3LZHZ/2n9NyFB129aJslcdrfAMeHb5xDlk/MW
        9CJ3XMCxh3TexeL4x0iqeGZVYMwGu5HruG75XcSUFtjIO5YEbN5Pf6v9S6bGOgY5CFNMy+
        Fc8fRtDe6XjsyYHaYilVl8j5gimBacM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-SNb0Z4QcNESAKyU7I-6lcA-1; Wed, 02 Sep 2020 13:39:07 -0400
X-MC-Unique: SNb0Z4QcNESAKyU7I-6lcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3BC98018A7
        for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2020 17:39:06 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 766F37DA5E;
        Wed,  2 Sep 2020 17:39:00 +0000 (UTC)
Date:   Wed, 2 Sep 2020 13:38:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: avoid LR buffer overrun due to crafted h_len
Message-ID: <20200902173859.GD289426@bfoster>
References: <20200902141012.24605-1-hsiangkao@redhat.com>
 <20200902141923.26422-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902141923.26422-1-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 02, 2020 at 10:19:23PM +0800, Gao Xiang wrote:
> Currently, crafted h_len has been blocked for the log
> header of the tail block in commit a70f9fe52daa ("xfs:
> detect and handle invalid iclog size set by mkfs").
> 

Ok, so according to that commit log the original purpose of this code
was to work around a quirky mkfs condition where record length of an
unmount record was enlarged but the iclog buffer size remained at 32k.
The fix is to simply increase the size of iclog buf.

> However, each log record could still have crafted
> h_len and cause log record buffer overrun. So let's
> check h_len for each log record as well instead.
> 

Is this something you've observed or attempted to reproduce, or is this
based on code inspection?

> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> v2: fix a misjudgement "unlikely(hlen >= hsize)"
> 
>  fs/xfs/xfs_log_recover.c | 70 +++++++++++++++++++++-------------------
>  1 file changed, 37 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e2ec91b2d0f4..2d9195fb9367 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2904,7 +2904,8 @@ STATIC int
>  xlog_valid_rec_header(
>  	struct xlog		*log,
>  	struct xlog_rec_header	*rhead,
> -	xfs_daddr_t		blkno)
> +	xfs_daddr_t		blkno,
> +	int			hsize)
>  {
>  	int			hlen;
>  
> @@ -2920,10 +2921,39 @@ xlog_valid_rec_header(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	/* LR body must have data or it wouldn't have been written */
> +	/*
> +	 * LR body must have data (or it wouldn't have been written) and
> +	 * h_len must not be greater than h_size with one exception.
> +	 *
> +	 * That is that xfsprogs has a bug where record length is based on
> +	 * lsunit but h_size (iclog size) is hardcoded to 32k. This means
> +	 * the log buffer allocated can be too small for the record to
> +	 * cause an overrun.
> +	 *
> +	 * Detect this condition here. Use lsunit for the buffer size as
> +	 * long as this looks like the mkfs case. Otherwise, return an
> +	 * error to avoid a buffer overrun.
> +	 */
>  	hlen = be32_to_cpu(rhead->h_len);
> -	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > INT_MAX))
> +	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0))

Why is the second part of the check removed?

>  		return -EFSCORRUPTED;
> +
> +	if (hsize && XFS_IS_CORRUPT(log->l_mp,
> +				    hsize < be32_to_cpu(rhead->h_size)))
> +		return -EFSCORRUPTED;
> +	hsize = be32_to_cpu(rhead->h_size);

I'm a little confused why we take hsize as a parameter as well as read
it from the record header. If we're validating a particular record,
shouldn't we use the size as specified by that record?

Also FWIW I think pulling bits of logic out of the XFS_IS_CORRUPT()
check makes this a little harder to read than just putting the entire
logic statement within the macro.

> +
> +	if (unlikely(hlen > hsize)) {

I think we've made a point to avoid the [un]likely() modifiers in XFS as
they don't usually have a noticeable impact. I certainly wouldn't expect
it to in log recovery.

> +		if (XFS_IS_CORRUPT(log->l_mp, hlen > log->l_mp->m_logbsize ||
> +				   rhead->h_num_logops != cpu_to_be32(1)))
> +			return -EFSCORRUPTED;
> +
> +		xfs_warn(log->l_mp,
> +		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
> +			 hsize, log->l_mp->m_logbsize);
> +		rhead->h_size = cpu_to_be32(log->l_mp->m_logbsize);

I also find updating the header structure as such down in a "validation
helper" a bit obscured.

> +	}
> +
>  	if (XFS_IS_CORRUPT(log->l_mp,
>  			   blkno > log->l_logBBsize || blkno > INT_MAX))
>  		return -EFSCORRUPTED;
...
> @@ -3096,7 +3100,7 @@ xlog_do_recovery_pass(
>  			}
>  			rhead = (xlog_rec_header_t *)offset;
>  			error = xlog_valid_rec_header(log, rhead,
> -						split_hblks ? blk_no : 0);
> +					split_hblks ? blk_no : 0, h_size);
>  			if (error)
>  				goto bread_err2;
>  
> @@ -3177,7 +3181,7 @@ xlog_do_recovery_pass(
>  			goto bread_err2;
>  
>  		rhead = (xlog_rec_header_t *)offset;
> -		error = xlog_valid_rec_header(log, rhead, blk_no);
> +		error = xlog_valid_rec_header(log, rhead, blk_no, h_size);
>  		if (error)
>  			goto bread_err2;

In these two cases we've already allocated the record header and data
buffers and we're walking through the log records doing recovery. Given
that, it seems like the purpose of the parameter is more to check the
subsequent records against the size of the current record buffer. That
seems like a reasonable check to incorporate, but I think the mkfs
workaround logic is misplaced in a generic record validation helper.
IIUC that is a very special case that should only apply to the first
record in the log and only impacts the size of the buffer we allocate to
read in the remaining records.

Can we rework this to leave the mkfs workaround logic as is and update
the validation helper to check that each record length fits in the size
of the buffer we've decided to allocate? I'd also suggest to rename the
new parameter to something like 'bufsize' instead of 'h_size' to clarify
what it actually means in the context of xlog_valid_rec_header().

Brian

>  
> -- 
> 2.18.1
> 

