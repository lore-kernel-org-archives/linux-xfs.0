Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88036C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 02:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B13C65290
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 02:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhCICO5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 21:14:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhCICOu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 21:14:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B14C5652A4;
        Tue,  9 Mar 2021 02:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615256089;
        bh=ywub+lOfD2UEjHE1HnuVmm/xAsMx6k3NGkUGa6HPj9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iCrCx+Y2JXXlPaKl3jy6/mArbK1OF2lAvOEvQPrQZMTZSqxOW7DBmt/2Q3tSciqY/
         Hb48gU8i9K8yYODVsoqKOJkn5C1s546kkvK30bWwyLajgWzMGsn4sLaJZeg32YkxrE
         FGZJNV+mCAWiOcp7Ng+x1mVyhwk5VDgOuVoPBwiInm/q+JuJ4Iad1pEyqEYFhvOUhe
         FLsBnx6ASqQhOpxLiOA2OuLedhfZwv+MAPKqojxxDAQ6/+SpsxKx9PDZzjCmY4q19O
         aqTLX8UdhpjxPOlUKZlWTYoDgRE954r1f3Ii5iagUek6VHOjIAxZELlORVg2zP3oCv
         bfpZnMZVVu2CQ==
Date:   Mon, 8 Mar 2021 18:14:48 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/45] xfs: move log iovec alignment to preparation
 function
Message-ID: <20210309021448.GL3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-25-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-25-david@fromorbit.com>
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

Ok, now that I grok what's going on in the /next/ patch, this makes
sense to me as the way into the next patch.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
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
