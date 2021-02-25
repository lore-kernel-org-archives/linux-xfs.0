Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA512C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 950C064EDC
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhBYJBl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 04:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234499AbhBYJBl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 04:01:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1F9C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 01:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eap3plADSnmwqdojGL7lTERk3c/93KPO4zkxUdwK/DM=; b=j2NLPViHByxYcA5uW2St6xO3Os
        ne+oW3G/ilg4nPcaD3Hy+4NfyJxyHCJbh01bsri8s78xC7F9k+UZ4zk/g3hj34OQC80OOup3JMQ6G
        0nxAS5sj8S6SVHTqYqWTZsuYrFHk/oJuW7Exzq8u+Em8u+r7tdYVkxBYNUKsmL85mnQz8RJ3esAKj
        MjGUkLdm3MtTrpxrmGgq5PHgTPzh4H+cIa29DB1rOL8E3Ksgv3/CeJCxDDi5SRhTCjoFhLKyUb4NA
        B3oeQOmaFIwvGAXqkB8FUDmnmSzkySV6YdRbEoqbIJj2okEzuDk5AXH+64lz84HFVp7ZpsFE+dvjW
        56N6vkbQ==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFCVw-00AUko-Kb; Thu, 25 Feb 2021 09:00:55 +0000
Date:   Thu, 25 Feb 2021 09:58:42 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8 v2] xfs: journal IO cache flush reductions
Message-ID: <YDdmwiLsEwrazwBH@infradead.org>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-8-david@fromorbit.com>
 <20210223080503.GW4662@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223080503.GW4662@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> As a result:
> 
> 	logbsize	fsmark create rate	rm -rf
> before	32kb		152851+/-5.3e+04	5m28s
> patched	32kb		221533+/-1.1e+04	5m24s
> 
> before	256kb		220239+/-6.2e+03	4m58s
> patched	256kb		228286+/-9.2e+03	5m06s
> 
> The rm -rf times are included because I ran them, but the
> differences are largely noise. This workload is largely metadata
> read IO latency bound and the changes to the journal cache flushing
> doesn't really make any noticable difference to behaviour apart from
> a reduction in noiclog events from background CIL pushing.

The 256b rm -rf case actually seems like a regression not in the noise
here.  Does this reproduce over multiple runs?

> @@ -2009,13 +2010,14 @@ xlog_sync(
>  	 * synchronously here; for an internal log we can simply use the block
>  	 * layer state machine for preflushes.
>  	 */
> -	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
> +	if (log->l_targ != log->l_mp->m_ddev_targp ||
> +	    (split && (iclog->ic_flags & XLOG_ICL_NEED_FLUSH))) {
>  		xfs_flush_bdev(log->l_mp->m_ddev_targp->bt_bdev);
> -		need_flush = false;
> +		iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;

Once you touch all the buffer flags anyway we should optimize the
log wraparound case here - insteaad of th synchronous flush we just
need to set REQ_PREFLUSH on the first log bio, which should be nicely
doable with your infrastruture.

> +		/*
> +		 * iclogs containing commit records or unmount records need
> +		 * to issue ordering cache flushes and commit immediately
> +		 * to stable storage to guarantee journal vs metadata ordering
> +		 * is correctly maintained in the storage media.
> +		 */
> +		if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
> +			iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH |
> +						XLOG_ICL_NEED_FUA);
> +		}
> +
>  		/*
>  		 * This loop writes out as many regions as can fit in the amount
>  		 * of space which was allocated by xlog_state_get_iclog_space().
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 4093d2d0db7c..370da7c2bfc8 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -894,10 +894,15 @@ xlog_cil_push_work(
>  
>  	/*
>  	 * If the checkpoint spans multiple iclogs, wait for all previous
> -	 * iclogs to complete before we submit the commit_iclog.
> +	 * iclogs to complete before we submit the commit_iclog. If it is in the
> +	 * same iclog as the start of the checkpoint, then we can skip the iclog
> +	 * cache flush because there are no other iclogs we need to order
> +	 * against.

Nit: the iclogs in the first changed line would easily fit onto the previous
line.
