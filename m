Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E8A4C433E2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 11:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DE01206B7
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 11:30:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X9YMFutO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgIDLaT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 07:30:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33222 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730176AbgIDLZ7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 07:25:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599218737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xqh10yFr/VvS952VcxbxSRvr/Ou7HYLqYUldy9PuKJM=;
        b=X9YMFutOAYlp56jvU36TyhV466MCtpuZlnErr1QCsrUK5gM60Qc6sBBl43/++2nCYFWYua
        B9EannAWpkhj6c7l0Rivpr7WIwyL8DMd6B/TI0pBO9CIl30evoRbKtCIKD5O7y1DW+6MRl
        yPsuKYAhHyQv2QdP0CtbyTRGszDm6z8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-7wer37hGMHmfo_j6-WzjHw-1; Fri, 04 Sep 2020 07:25:35 -0400
X-MC-Unique: 7wer37hGMHmfo_j6-WzjHw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D121985B683;
        Fri,  4 Sep 2020 11:25:34 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 603D45D9CC;
        Fri,  4 Sep 2020 11:25:31 +0000 (UTC)
Date:   Fri, 4 Sep 2020 07:25:29 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 1/2] xfs: avoid LR buffer overrun due to crafted
 h_{len,size}
Message-ID: <20200904112529.GB529978@bfoster>
References: <20200904082516.31205-1-hsiangkao@redhat.com>
 <20200904082516.31205-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904082516.31205-2-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 04, 2020 at 04:25:15PM +0800, Gao Xiang wrote:
> Currently, crafted h_len has been blocked for the log
> header of the tail block in commit a70f9fe52daa ("xfs:
> detect and handle invalid iclog size set by mkfs").
> 
> However, each log record could still have crafted h_len,
> h_size and cause log record buffer overrun. So let's
> check (h_len vs h_size) and (h_size vs buffer size)
> for each log record as well instead.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> v2: https://lore.kernel.org/r/20200902141923.26422-1-hsiangkao@redhat.com
> 
> changes since v2:
>  - rename argument h_size to bufsize to make it clear (Brian);
>  - leave the mkfs workaround logic in xlog_do_recovery_pass() (Brian);
>  - add XLOG_VERSION_2 checking logic since old logrecv1 doesn't have
>    h_size field just to be safe.
> 
>  fs/xfs/xfs_log_recover.c | 50 +++++++++++++++++++++++-----------------
>  1 file changed, 29 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e2ec91b2d0f4..28d952794bfa 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2904,9 +2904,10 @@ STATIC int
>  xlog_valid_rec_header(
>  	struct xlog		*log,
>  	struct xlog_rec_header	*rhead,
> -	xfs_daddr_t		blkno)
> +	xfs_daddr_t		blkno,
> +	int			bufsize)
>  {
> -	int			hlen;
> +	int			hlen, hsize = XLOG_BIG_RECORD_BSIZE;
>  
>  	if (XFS_IS_CORRUPT(log->l_mp,
>  			   rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM)))
> @@ -2920,10 +2921,22 @@ xlog_valid_rec_header(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	/* LR body must have data or it wouldn't have been written */
> +	/*
> +	 * LR body must have data (or it wouldn't have been written) and
> +	 * h_len must not be greater than h_size with one exception (see
> +	 * comments in xlog_do_recovery_pass()).
> +	 */

I wouldn't mention the exceptional case at all here since I think it
just adds confusion. It's an unfortunate wart with mkfs that requires a
kernel workaround, and I think it's better to keep it one place. I.e.,
should it ever be removed, I find it unlikely somebody will notice this
comment and fix it up accordingly.

>  	hlen = be32_to_cpu(rhead->h_len);
> -	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > INT_MAX))
> +	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
> +	    (be32_to_cpu(rhead->h_version) & XLOG_VERSION_2))
> +		hsize = be32_to_cpu(rhead->h_size);
> +
> +	if (XFS_IS_CORRUPT(log->l_mp, hlen <= 0 || hlen > hsize))
>  		return -EFSCORRUPTED;
> +
> +	if (bufsize && XFS_IS_CORRUPT(log->l_mp, bufsize < hsize))
> +		return -EFSCORRUPTED;

Please do something like the following so the full corruption check
logic is readable:

	if (XFS_IS_CORRUPT(..., bufsize && hsize > bufsize))
		return -EFSCORRUPTED;

> +
>  	if (XFS_IS_CORRUPT(log->l_mp,
>  			   blkno > log->l_logBBsize || blkno > INT_MAX))
>  		return -EFSCORRUPTED;
> @@ -2984,9 +2997,6 @@ xlog_do_recovery_pass(
>  			goto bread_err1;
>  
>  		rhead = (xlog_rec_header_t *)offset;
> -		error = xlog_valid_rec_header(log, rhead, tail_blk);
> -		if (error)
> -			goto bread_err1;

This technically defers broader corruption checks (i.e., magic number,
etc.) until after functional code starts using other fields below. I
don't think we should remove this.

>  
>  		/*
>  		 * xfsprogs has a bug where record length is based on lsunit but
> @@ -3001,21 +3011,19 @@ xlog_do_recovery_pass(
>  		 */
>  		h_size = be32_to_cpu(rhead->h_size);
>  		h_len = be32_to_cpu(rhead->h_len);
> -		if (h_len > h_size) {
> -			if (h_len <= log->l_mp->m_logbsize &&
> -			    be32_to_cpu(rhead->h_num_logops) == 1) {
> -				xfs_warn(log->l_mp,
> +		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
> +		    rhead->h_num_logops == cpu_to_be32(1)) {
> +			xfs_warn(log->l_mp,
>  		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
> -					 h_size, log->l_mp->m_logbsize);
> -				h_size = log->l_mp->m_logbsize;
> -			} else {
> -				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> -						log->l_mp);
> -				error = -EFSCORRUPTED;
> -				goto bread_err1;
> -			}
> +				 h_size, log->l_mp->m_logbsize);
> +			h_size = log->l_mp->m_logbsize;
> +			rhead->h_size = cpu_to_be32(h_size);

I don't think we should update rhead like this, particularly in a rare
and exclusive case. This structure should reflect what is on disk.

All in all, I think this patch should be much more focused:

1.) Add the bufsize parameter and associated corruption check to
xlog_valid_rec_header().
2.) Pass the related value from the existing calls.
3.) (Optional) If there's reason to revalidate after executing the mkfs
workaround, add a second call within the branch that implements the
h_size workaround.

Also, please test the workaround case to make sure it still works as
expected (if you haven't already).

Brian

>  		}
>  
> +		error = xlog_valid_rec_header(log, rhead, tail_blk, 0);
> +		if (error)
> +			goto bread_err1;
> +
>  		if ((be32_to_cpu(rhead->h_version) & XLOG_VERSION_2) &&
>  		    (h_size > XLOG_HEADER_CYCLE_SIZE)) {
>  			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
> @@ -3096,7 +3104,7 @@ xlog_do_recovery_pass(
>  			}
>  			rhead = (xlog_rec_header_t *)offset;
>  			error = xlog_valid_rec_header(log, rhead,
> -						split_hblks ? blk_no : 0);
> +					split_hblks ? blk_no : 0, h_size);
>  			if (error)
>  				goto bread_err2;
>  
> @@ -3177,7 +3185,7 @@ xlog_do_recovery_pass(
>  			goto bread_err2;
>  
>  		rhead = (xlog_rec_header_t *)offset;
> -		error = xlog_valid_rec_header(log, rhead, blk_no);
> +		error = xlog_valid_rec_header(log, rhead, blk_no, h_size);
>  		if (error)
>  			goto bread_err2;
>  
> -- 
> 2.18.1
> 

