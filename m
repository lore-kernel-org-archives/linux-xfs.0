Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A69EC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 422B663212
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhKQE7X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:59:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231344AbhKQE7W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Nov 2021 23:59:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C049F61BFE;
        Wed, 17 Nov 2021 04:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637124984;
        bh=7PaqW7/Oi1Ro7hQT21Ik/dNGQyscIaFWPm1T9KsZck8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hILXVi5c++u5GHvEYZQ1nljoO/44RN05YrSgO3vYDsnLKQjy8QFXLKYyR8iPSHcuB
         5VfH8BvP3hloszUsjRBG8vnZ7lyW3+3nBt8PMk6XVXVSzoVTpw8m2D93j86/Mvkg97
         mShTHrRPe1SLw6HLD2R7+RklDVplMQepf4pYkdRLSdBmTBeTVI4Xr0GQQCAl/4NeRJ
         e0lk6Q+scqFkqRW7VyN6Fgd/dVPDnOSYy6mZw5VDsZ/JS0jP7OfoDGAp+97eeD9pSu
         Nk7zAtmWGT6uicHa0f7mDZKzXwzqYk16AyH7X9MW3Mx3nPjxBqIocvdnZX/Fx1LE9d
         eauUoOA/2XLRw==
Date:   Tue, 16 Nov 2021 20:56:24 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/16] xfs: introduce xlog_write_full()
Message-ID: <20211117045624.GS24307@magnolia>
References: <20211109015055.1547604-1-david@fromorbit.com>
 <20211109015055.1547604-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109015055.1547604-12-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 09, 2021 at 12:50:50PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Introduce an optimised version of xlog_write() that is used when the
> entire write will fit in a single iclog. This greatly simplifies the
> implementation of writing a log vector chain into an iclog, and sets
> the ground work for a much more understandable xlog_write()
> implementation.
> 
> This incorporates some factoring and simplifications proposed by
> Christoph Hellwig.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks cleaner than last time... :)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 68 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f26c85dbc765..44134f8e699c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2224,6 +2224,60 @@ xlog_print_trans(
>  	}
>  }
>  
> +static inline void
> +xlog_write_iovec(
> +	struct xlog_in_core	*iclog,
> +	uint32_t		*log_offset,
> +	void			*data,
> +	uint32_t		write_len,
> +	int			*bytes_left,
> +	uint32_t		*record_cnt,
> +	uint32_t		*data_cnt)
> +{
> +	ASSERT(*log_offset % sizeof(int32_t) == 0);
> +	ASSERT(write_len % sizeof(int32_t) == 0);
> +
> +	memcpy(iclog->ic_datap + *log_offset, data, write_len);
> +	*log_offset += write_len;
> +	*bytes_left -= write_len;
> +	(*record_cnt)++;
> +	*data_cnt += write_len;
> +}
> +
> +/*
> + * Write log vectors into a single iclog which is guaranteed by the caller
> + * to have enough space to write the entire log vector into.
> + */
> +static void
> +xlog_write_full(
> +	struct xfs_log_vec	*lv,
> +	struct xlog_ticket	*ticket,
> +	struct xlog_in_core	*iclog,
> +	uint32_t		*log_offset,
> +	uint32_t		*len,
> +	uint32_t		*record_cnt,
> +	uint32_t		*data_cnt)
> +{
> +	int			index;
> +
> +	ASSERT(*log_offset + *len <= iclog->ic_size);
> +
> +	/*
> +	 * Ordered log vectors have no regions to write so this
> +	 * loop will naturally skip them.
> +	 */
> +	for (index = 0; index < lv->lv_niovecs; index++) {
> +		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
> +		struct xlog_op_header	*ophdr = reg->i_addr;
> +
> +		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> +		ophdr->oh_len = cpu_to_be32(reg->i_len -
> +					sizeof(struct xlog_op_header));
> +		xlog_write_iovec(iclog, log_offset, reg->i_addr,
> +				reg->i_len, len, record_cnt, data_cnt);
> +	}
> +}
> +
>  static xlog_op_header_t *
>  xlog_write_setup_ophdr(
>  	struct xlog_op_header	*ophdr,
> @@ -2388,8 +2442,8 @@ xlog_write(
>  	int			partial_copy = 0;
>  	int			partial_copy_len = 0;
>  	int			contwr = 0;
> -	int			record_cnt = 0;
> -	int			data_cnt = 0;
> +	uint32_t		record_cnt = 0;
> +	uint32_t		data_cnt = 0;
>  	int			error = 0;
>  
>  	if (ticket->t_curr_res < 0) {
> @@ -2409,7 +2463,6 @@ xlog_write(
>  			return error;
>  
>  		ASSERT(log_offset <= iclog->ic_size - 1);
> -		ptr = iclog->ic_datap + log_offset;
>  
>  		/*
>  		 * If we have a context pointer, pass it the first iclog we are
> @@ -2421,10 +2474,22 @@ xlog_write(
>  			ctx = NULL;
>  		}
>  
> +		/* If this is a single iclog write, go fast... */
> +		if (!contwr && lv == log_vector) {
> +			while (lv) {
> +				xlog_write_full(lv, ticket, iclog, &log_offset,
> +						 &len, &record_cnt, &data_cnt);
> +				lv = lv->lv_next;
> +			}
> +			data_cnt = 0;
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
> 2.33.0
> 
