Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F99DC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 18:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27FD564EFA
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 18:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbhBYSqr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbhBYSqk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 13:46:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC338C061574
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 10:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Nhug8Z/H8y1/6p9twrlzVIl+Fv+yhRueLqmxccck7so=; b=lSqx0D9cAm+FODU4OcUnCP4hqT
        KMogddnq0EshpN8GRPAfp90fLn1w8u5ZBmuqbqCKrgfD4JJZzqKA81389lBzpvdYWEBeEZSZMHqFk
        Nj4/CFklihD3nH8cAKBeLtM2vMQ0Q40enbWERXa754oqg9QYe/OTv+GnxS+hHTujE0WApdGpQSKu+
        RYSduvl3xyPxw3KKInXCtATni25osf4duYfJ/qrebe6hO7vVbhApxmVH2fVXCaSoetXwb0NMqnGsY
        aw+VIGBFqIdlTebAMxWB6WV/WSgOQJHeq5CGDbWUPMbQkeq6XspNHq/i3JNLsxl4FejMlXYBznw75
        89XjNB3A==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFLe1-00B2XW-Fb; Thu, 25 Feb 2021 18:45:51 +0000
Date:   Thu, 25 Feb 2021 19:43:38 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/13] xfs: introduce xlog_write_single()
Message-ID: <YDfv2urK2p8peO5R@infradead.org>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-11-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224063459.3436852-11-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 24, 2021 at 05:34:56PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Vector out to an optimised version of xlog_write() if the entire

s/Vector/Factor/ ?

> +	ptr = iclog->ic_datap + log_offset;
> +	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
> +
> +
> +		/* ordered log vectors have no regions to write */

The two empty lines above look a little strange.

> +		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
> +			ASSERT(lv->lv_niovecs == 0);
> +			goto next_lv;
> +		}
> +
> +		reg = &lv->lv_iovecp[index];
> +		ASSERT(reg->i_len % sizeof(int32_t) == 0);
> +		ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
> +
> +		ophdr = reg->i_addr;
> +		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> +		ophdr->oh_len = cpu_to_be32(reg->i_len -
> +					sizeof(struct xlog_op_header));
> +
> +		memcpy(ptr, reg->i_addr, reg->i_len);
> +		xlog_write_adv_cnt(&ptr, &len, &log_offset, reg->i_len);
> +		record_cnt++;
> +
> +		/* move to the next iovec */
> +		if (++index < lv->lv_niovecs)
> +			continue;
> +next_lv:
> +		/* move to the next logvec */
> +		lv = lv->lv_next;
> +		index = 0;
> +	}

I always hated this (pre-existing) loop style.  What do you think of
something like this (just whiteboard coding, might be completely broken),
which also handles the ordered case with lv_niovecs == 0 as part of
the natural loop:

	for (lv = log_vector; lv; lv->lv_next) {
		for (index = 0; index < lv->lv_niovecs; index++) {
			struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
			struct xlog_op_header	*ophdr = reg->i_addr;

			ASSERT(reg->i_len % sizeof(int32_t) == 0);
			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);

			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
			ophdr->oh_len = cpu_to_be32(reg->i_len -
				sizeof(struct xlog_op_header));
			memcpy(ptr, reg->i_addr, reg->i_len);
			xlog_write_adv_cnt(&ptr, &len, &log_offset, reg->i_len);
			record_cnt++;
		}
	}
