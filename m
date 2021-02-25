Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5925C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 18:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9047D64F13
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 18:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhBYSb6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbhBYSa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 13:30:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25263C061574
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 10:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2WzTc+Vd2bEYkL5XuAKlEe979EjNxjd0wJyFOq2TVLQ=; b=VBTRVoj7J6fMYnROwkLxOia9yj
        NbKvFnhYvgkW5ccgUSRwFUE63cQW20hO26zcMFvnYsI6Phik/sblQxaX1nMfbuoHeZ4JqHxGSb7ff
        5iR4Ic4Sz9awL6lDsxsmXHV25GiJ/VbKRsOO31eYy5SFNKhhzalicluR1AgW7ymZdclby2Um5LBL9
        NeumdssAs/3ENcRPmghO2IDi9a7K+edCHLKKCL1JiVSv/x1ezo4JY+Wp1K13wUXhX7oSWOBUMrUQw
        GmeQG41i6H3Oykz9RwV6P7CUuUcIA3U5Q+mKGpPxGyLJJOSGv4tZRsWpV409EE/II0DB+jounz8Jw
        IqBYR7HA==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFLOE-00B1VQ-MD; Thu, 25 Feb 2021 18:29:36 +0000
Date:   Thu, 25 Feb 2021 19:27:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/13] xfs: reserve space and initialise xlog_op_header
 in item formatting
Message-ID: <YDfsCAlkD45J1BF6@infradead.org>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224063459.3436852-8-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +			if (optype && index) {
> +				optype &= ~XLOG_START_TRANS;
> +			} else if (partial_copy) {
>                                  ophdr = xlog_write_setup_ophdr(ptr, ticket);

This line uses whitespaces for indentation, we should probably fix that
up somewhere in the series.

>  static inline void *
>  xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>  		uint type)
>  {
> -	struct xfs_log_iovec *vec = *vecp;
> +	struct xfs_log_iovec	*vec = *vecp;
> +	struct xlog_op_header	*oph;
> +	uint32_t		len;
> +	void			*buf;
>  
>  	if (vec) {
>  		ASSERT(vec - lv->lv_iovecp < lv->lv_niovecs);
> @@ -44,21 +54,36 @@ xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>  		vec = &lv->lv_iovecp[0];
>  	}
>  
> -	if (!IS_ALIGNED(lv->lv_buf_len, sizeof(uint64_t)))
> -		lv->lv_buf_len = round_up(lv->lv_buf_len, sizeof(uint64_t));
> +	len = lv->lv_buf_len + sizeof(struct xlog_op_header);
> +	if (!IS_ALIGNED(len, sizeof(uint64_t))) {
> +		lv->lv_buf_len = round_up(len, sizeof(uint64_t)) -
> +					sizeof(struct xlog_op_header);
> +	}
>  
>  	vec->i_type = type;
>  	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
>  
> -	ASSERT(IS_ALIGNED((unsigned long)vec->i_addr, sizeof(uint64_t)));
> +	oph = vec->i_addr;
> +	oph->oh_clientid = XFS_TRANSACTION;
> +	oph->oh_res2 = 0;
> +	oph->oh_flags = 0;
> +
> +	buf = vec->i_addr + sizeof(struct xlog_op_header);
> +	ASSERT(IS_ALIGNED((unsigned long)buf, sizeof(uint64_t)));
>  
>  	*vecp = vec;
> -	return vec->i_addr;
> +	return buf;
>  }

I think this function is growing a little too larger to stay inlined.

> -		nbytes += niovecs * sizeof(uint64_t);
> +		nbytes += niovecs * (sizeof(uint64_t) +
> +					sizeof(struct xlog_op_header));;

Is it just me, or would

		nbytes += niovecs *
			(sizeof(uint64_t) + sizeof(struct xlog_op_header));

be a little easier to read?
