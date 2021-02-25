Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2429CC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 18:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAA3364F3A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 18:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhBYS5R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbhBYS5N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 13:57:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987DBC061574
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 10:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DkFn6thfOplUPtHuV7R2a4wY3U86+8RNsWtrOzaI27M=; b=Pw7aNNTfmKwxYyJlRo226NTCzn
        z8DaL3u5heMeYB2ihaib6netRVECF9MyxP08S6VHL1B4wofSn42yhw8km+5XHpSkRbAjStTUGjUuS
        PHRn/NiGiPAUYBY2y31OvrWQRs50CvRX6IISmewfsReuQ0OjZb8mS0nUK0ZW/FbQ7UQrwvoBm6xpP
        osX1kxj0iSjQPqQqVHM4XQNmWpb0+n/xxOFh99ynDErAV92sLeNTNy1KSETvw0CxU5ALZC76MURA1
        +Z/4bAC96nBZpMxKEo+VeA7Ffo0TadMoQr0io03sjJF7LIy/Z0z0ZtBRlSHfPgPjx8gB9HgPhpoNC
        8bb0cHKg==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFLo4-00B37J-1o; Thu, 25 Feb 2021 18:56:15 +0000
Date:   Thu, 25 Feb 2021 19:54:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/13] xfs:_introduce xlog_write_partial()
Message-ID: <YDfySTvqwmvK7AOe@infradead.org>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224063459.3436852-12-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 24, 2021 at 05:34:57PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Handle writing of a logvec chain into an iclog that doesn't have
> enough space to fit it all. The iclog has already been changed to
> WANT_SYNC by xlog_get_iclog_space(), so the entire remaining space
> in the iclog is exclusively owned by this logvec chain.
> 
> The difference between the single and partial cases is that
> we end up with partial iovec writes in the iclog and have to split
> a log vec regions across two iclogs. The state handling for this is
> currently awful and so we're building up the pieces needed to
> handle this more cleanly one at a time.

I did not fully grasp the refactoring yet, so just some superficial
ramblings for now:

> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 456ab3294621..74a1dddf1c15 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2060,6 +2060,7 @@ xlog_state_finish_copy(
>  
>  	be32_add_cpu(&iclog->ic_header.h_num_logops, record_cnt);
>  	iclog->ic_offset += copy_bytes;
> +	ASSERT(iclog->ic_offset <= iclog->ic_size);

How is this related to the rest of the patch?  Maybe just add it
in a prep patch?

> +	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
> +					   &contwr, &log_offset);
> +	if (error)
> +		return error;
>  
> +	/* start_lsn is the LSN of the first iclog written to. */
> +	if (start_lsn)
> +		*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  
> +	/*
> +	 * iclogs containing commit records or unmount records need
> +	 * to issue ordering cache flushes and commit immediately
> +	 * to stable storage to guarantee journal vs metadata ordering
> +	 * is correctly maintained in the storage media. This will always
> +	 * fit in the iclog we have been already been passed.
> +	 */
> +	if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
> +		iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
> +		ASSERT(!contwr);
> +	}
>  
> +	while (lv) {
> +		lv = xlog_write_single(lv, ticket, iclog, &log_offset,
> +					&len, &record_cnt, &data_cnt);
> +		if (!lv)
>  			break;
>  
> +		ASSERT(!(optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)));
> +		lv = xlog_write_partial(log, lv, ticket, &iclog, &log_offset,
> +					&len, &record_cnt, &data_cnt, &contwr);
> +		if (IS_ERR(lv)) {
> +			error = PTR_ERR(lv);
> +			break;
>  		}
>  	}

Maybe user IS_ERR_OR_NULL and PTR_ERR_OR_ZERO here to catch the NULL
case as well?  e.g.

	for (;;) {
		....
		lv = xlog_write_partial();
		if (IS_ERR_OR_NULL(lv)) {
			error = PTR_ERR_OR_ZERO(lv);
			break;
		}
	}

> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index acf20c2e5018..c978c52e7ba8 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -896,7 +896,6 @@ xlog_cil_push_work(
>  	num_iovecs += lvhdr.lv_niovecs;
>  	num_bytes += lvhdr.lv_bytes;
>  
> -
>  	/*

This seems misplaced.
