Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A454DC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 02:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6827E614A7
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 02:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCICjm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 21:39:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhCICj2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 21:39:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BBED6527B;
        Tue,  9 Mar 2021 02:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615257568;
        bh=0bUyVV22GlM3d/cucTC6G5WHjXLZZcQ1v4yU2w2Tf7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y0aJswrqiUkf2Bt8JA2w6+lvaLK1rPm8WOHUHRdjedxxu8vrF2RBcg9cA6EziZBJt
         N89l8ZfMMM0H0W5STTbBBPy5IhzwkeNJHyXa8jXQQOmjWs9T8JO/22iyMPUfuXRiGd
         74axJ+XESdlm4oxhwtUXQY0YkRP7I4v9yYVK4wnWTA46M3uuTIGcJvMYE8HCur6ZHu
         QXUsbIvTWjw2rMAHQknYBj/BgaCqhLXoCTS9NKnx1oPk+mg0u31iwHZPH/LOuli2N0
         NKIOAQhbCqdVz1UiqhxP09mHG2wXi1XiprJHOqZAS4N9X9i4KoeG1Z/bOmtIp9UVJW
         cQrgHusP8ElPg==
Date:   Mon, 8 Mar 2021 18:39:27 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/45] xfs: introduce xlog_write_single()
Message-ID: <20210309023927.GP3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-29-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-29-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:26PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Introduce an optimised version of xlog_write() that is used when the
> entire write will fit in a single iclog. This greatly simplifies the
> implementation of writing a log vector chain into an iclog, and sets
> the ground work for a much more understandable xlog_write()
> implementation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 22f97914ab99..590c1e6db475 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2214,6 +2214,52 @@ xlog_write_copy_finish(
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
> +	struct xfs_log_vec	*lv = log_vector;
> +	void			*ptr;
> +	int			index = 0;
> +	int			record_cnt = 0;

Any reason these (and the return type) can't be unsigned?  I don't think
negative indices or record counts have any meaning, right?

Otherwise this looks ok to me.

--D

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
> @@ -2294,7 +2340,6 @@ xlog_write(
>  			return error;
>  
>  		ASSERT(log_offset <= iclog->ic_size - 1);
> -		ptr = iclog->ic_datap + log_offset;
>  
>  		/* Start_lsn is the first lsn written to. */
>  		if (start_lsn && !*start_lsn)
> @@ -2311,10 +2356,20 @@ xlog_write(
>  						XLOG_ICL_NEED_FUA);
>  		}
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
> 2.28.0
> 
