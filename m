Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35120C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 05:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DC2463222
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 05:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbhKQFFk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Nov 2021 00:05:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:58308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhKQFFj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 Nov 2021 00:05:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F11C8619E3;
        Wed, 17 Nov 2021 05:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637125362;
        bh=FLGbxRdUZMrpmOxOvbde2vPKiWum8v3kWEJ3yalnvYs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CBPxUoNDyDPNZFLtfasJNtxBpJDN3cNhYHD8GOAm9qtcr9XrqAtr4G8yISW1n69dk
         l1NW7RRp+NNzy8pY4JcFqJaX7zQRd2yiS5xS7ycnsgumyZHuTFd/zlrUyhz0nfCsj6
         IgMo5OJYYO+rLyw6cQ/C4unainjED2LwitxP7Xbhr1JC9Tzz5zazyU5RDEKIBFsdc9
         7upUjB4a+0jar248pmcCdzLpMkDN2JuPE2z784E1tRA+dRFKmyAgDqOcU89WtyW2ok
         +Ld6If4Zx7h3a6hyNM9QILS/XsVq11X9CU579Bx6xWj5EV7s+I/e4Hv7BiMAVlFoWP
         BsNrzneJyRARQ==
Date:   Tue, 16 Nov 2021 21:02:41 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/16] xfs: remove xlog_verify_dest_ptr
Message-ID: <20211117050241.GT24307@magnolia>
References: <20211109015055.1547604-1-david@fromorbit.com>
 <20211109015055.1547604-14-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109015055.1547604-14-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 09, 2021 at 12:50:52PM +1100, Dave Chinner wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Just check that the offset in xlog_write_vec is smaller than the iclog
> size and remove the expensive cycling through all iclogs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Took a while to wrap my head around, but I got there.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c      | 35 +----------------------------------
>  fs/xfs/xfs_log_priv.h |  4 ----
>  2 files changed, 1 insertion(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 02db5a712e76..d6ef555b1310 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -61,10 +61,6 @@ xlog_sync(
>  	struct xlog_in_core	*iclog);
>  #if defined(DEBUG)
>  STATIC void
> -xlog_verify_dest_ptr(
> -	struct xlog		*log,
> -	void			*ptr);
> -STATIC void
>  xlog_verify_grant_tail(
>  	struct xlog *log);
>  STATIC void
> @@ -77,7 +73,6 @@ xlog_verify_tail_lsn(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog);
>  #else
> -#define xlog_verify_dest_ptr(a,b)
>  #define xlog_verify_grant_tail(a)
>  #define xlog_verify_iclog(a,b,c)
>  #define xlog_verify_tail_lsn(a,b)
> @@ -1640,9 +1635,6 @@ xlog_alloc_log(
>  				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  		if (!iclog->ic_data)
>  			goto out_free_iclog;
> -#ifdef DEBUG
> -		log->l_iclog_bak[i] = &iclog->ic_header;
> -#endif
>  		head = &iclog->ic_header;
>  		memset(head, 0, sizeof(xlog_rec_header_t));
>  		head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
> @@ -2234,6 +2226,7 @@ xlog_write_iovec(
>  	uint32_t		*record_cnt,
>  	uint32_t		*data_cnt)
>  {
> +	ASSERT(*log_offset < iclog->ic_log->l_iclog_size);
>  	ASSERT(*log_offset % sizeof(int32_t) == 0);
>  	ASSERT(write_len % sizeof(int32_t) == 0);
>  
> @@ -2329,7 +2322,6 @@ xlog_write_partial(
>  	int			*contwr)
>  {
>  	struct xlog_in_core	*iclog = *iclogp;
> -	struct xlog		*log = iclog->ic_log;
>  	struct xlog_op_header	*ophdr;
>  	int			index = 0;
>  	uint32_t		rlen;
> @@ -2368,7 +2360,6 @@ xlog_write_partial(
>  		if (rlen != reg->i_len)
>  			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
>  
> -		xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
>  		xlog_write_iovec(iclog, log_offset, reg->i_addr,
>  				rlen, len, record_cnt, data_cnt);
>  
> @@ -2436,7 +2427,6 @@ xlog_write_partial(
>  			rlen = min_t(uint32_t, rlen, iclog->ic_size - *log_offset);
>  			ophdr->oh_len = cpu_to_be32(rlen);
>  
> -			xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
>  			xlog_write_iovec(iclog, log_offset,
>  					reg->i_addr + reg_offset,
>  					rlen, len, record_cnt, data_cnt);
> @@ -3560,29 +3550,6 @@ xlog_ticket_alloc(
>  }
>  
>  #if defined(DEBUG)
> -/*
> - * Make sure that the destination ptr is within the valid data region of
> - * one of the iclogs.  This uses backup pointers stored in a different
> - * part of the log in case we trash the log structure.
> - */
> -STATIC void
> -xlog_verify_dest_ptr(
> -	struct xlog	*log,
> -	void		*ptr)
> -{
> -	int i;
> -	int good_ptr = 0;
> -
> -	for (i = 0; i < log->l_iclog_bufs; i++) {
> -		if (ptr >= log->l_iclog_bak[i] &&
> -		    ptr <= log->l_iclog_bak[i] + log->l_iclog_size)
> -			good_ptr++;
> -	}
> -
> -	if (!good_ptr)
> -		xfs_emerg(log->l_mp, "%s: invalid ptr", __func__);
> -}
> -
>  /*
>   * Check to make sure the grant write head didn't just over lap the tail.  If
>   * the cycles are the same, we can't be overlapping.  Otherwise, make sure that
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 6e9c7d924363..8c98b57e2a63 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -420,10 +420,6 @@ struct xlog {
>  
>  	struct xfs_kobj		l_kobj;
>  
> -	/* The following field are used for debugging; need to hold icloglock */
> -#ifdef DEBUG
> -	void			*l_iclog_bak[XLOG_MAX_ICLOGS];
> -#endif
>  	/* log recovery lsn tracking (for buffer submission */
>  	xfs_lsn_t		l_recovery_lsn;
>  
> -- 
> 2.33.0
> 
