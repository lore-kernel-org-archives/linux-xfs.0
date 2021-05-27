Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DDFC4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 17:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 644B2613BE
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 17:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbhE0R2w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 13:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236968AbhE0R2w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 13:28:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13D8C613CA;
        Thu, 27 May 2021 17:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622136439;
        bh=g9wxsAZXARGXnnxzwuCsY/fND5C4N/n3nKTyJgwyIE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tVFZ/iH5hM0jfjMr7yRGA9tvYCeZN+ZMCB5MHUGH+KfhYZQZrn7jytZRZHi13xZ2w
         mlVekl2tBcKTqSVoFJ4SYK/ftY8cDXQtXJ+sqzQkMi2KFL2AsWCPzwxkQ67dWINQ3k
         wGNMaooGyDzCg8RNrTNeHjVxTL7CuoDDABUI0dCiItgN7RJE89qypHRZFTuPlYENpa
         HDaTM48bkkqNDEO2PgayM057vwVdF3n2hQHeTqop6heUzt+BUR4iu9FRqqKcAeuwGu
         OQ06pus1u3kw78cQ9apWZ8rBirW1h8R2xabB4OyGf22FXXhsqYXX19u9ccenS1ht7j
         IOzVL53I3iRew==
Date:   Thu, 27 May 2021 10:27:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/39] xfs: introduce xlog_write_single()
Message-ID: <20210527172718.GB2402049@locust>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-22-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519121317.585244-22-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 10:12:59PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Introduce an optimised version of xlog_write() that is used when the
> entire write will fit in a single iclog. This greatly simplifies the
> implementation of writing a log vector chain into an iclog, and sets
> the ground work for a much more understandable xlog_write()
> implementation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks like a fairly simple hoist.  I might have more comments once I
wade through the next patch.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 58f9aafce29e..3b74d21e3786 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2225,6 +2225,52 @@ xlog_write_copy_finish(
>  	return error;
>  }
>  
> +/*
> + * Write log vectors into a single iclog which is guaranteed by the caller
> + * to have enough space to write the entire log vector into. Return the number
> + * of log vectors written into the iclog.
> + */
> +static int
> +xlog_write_single(
> +	struct xfs_log_vec	*log_vector,
> +	struct xlog_ticket	*ticket,
> +	struct xlog_in_core	*iclog,
> +	uint32_t		log_offset,
> +	uint32_t		len)
> +{
> +	struct xfs_log_vec	*lv;
> +	void			*ptr;
> +	int			index = 0;
> +	int			record_cnt = 0;
> +
> +	ASSERT(log_offset + len <= iclog->ic_size);
> +
> +	ptr = iclog->ic_datap + log_offset;
> +	for (lv = log_vector; lv; lv = lv->lv_next) {
> +		/*
> +		 * Ordered log vectors have no regions to write so this
> +		 * loop will naturally skip them.
> +		 */
> +		for (index = 0; index < lv->lv_niovecs; index++) {
> +			struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
> +			struct xlog_op_header	*ophdr = reg->i_addr;
> +
> +			ASSERT(reg->i_len % sizeof(int32_t) == 0);
> +			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
> +
> +			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> +			ophdr->oh_len = cpu_to_be32(reg->i_len -
> +						sizeof(struct xlog_op_header));
> +			memcpy(ptr, reg->i_addr, reg->i_len);
> +			xlog_write_adv_cnt(&ptr, &len, &log_offset, reg->i_len);
> +			record_cnt++;
> +		}
> +	}
> +	ASSERT(len == 0);
> +	return record_cnt;
> +}
> +
> +
>  /*
>   * Write some region out to in-core log
>   *
> @@ -2305,16 +2351,25 @@ xlog_write(
>  			return error;
>  
>  		ASSERT(log_offset <= iclog->ic_size - 1);
> -		ptr = iclog->ic_datap + log_offset;
>  
>  		/* Start_lsn is the first lsn written to. */
>  		if (start_lsn && !*start_lsn)
>  			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  
> +		/* If this is a single iclog write, go fast... */
> +		if (!contwr && lv == log_vector) {
> +			record_cnt = xlog_write_single(lv, ticket, iclog,
> +						log_offset, len);
> +			len = 0;
> +			data_cnt = len;
> +			break;
> +		}
> +
>  		/*
>  		 * This loop writes out as many regions as can fit in the amount
>  		 * of space which was allocated by xlog_state_get_iclog_space().
>  		 */
> +		ptr = iclog->ic_datap + log_offset;
>  		while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
>  			struct xfs_log_iovec	*reg;
>  			struct xlog_op_header	*ophdr;
> -- 
> 2.31.1
> 
