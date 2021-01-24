Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8B5C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 09:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA82A22ADC
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 09:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbhAXJzu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Jan 2021 04:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbhAXJzr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jan 2021 04:55:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175B3C061573
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jan 2021 01:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0J1BfzxmC9FRxtYKPYpcbCeimtbPN9Zj1ANvFsMO2SI=; b=AVFuXny/TuDMvNwBIe9aWB/dUW
        am0MrwLP3REsN+A4cTs2bwkfeKxYr1hB8PYJJbUHxQAQ2waGwWtm4IjoUGgbwYTuE+qrHad7fng8Z
        gtwFhMLj4AdWBvk3URQ+sbh150PHmO1dU7nPCG53xnAse9yhBcln64HaLPgfKMqls+sDz9eiNLiS8
        2c3QMtHf/AF5+vEbzSvxrFHcWrMLGywM6CbBK1uVA74kynuepJ7YzI3/nT7xEYcg8ZPtzy27befWi
        VLfXv+FnTVjX5HbdEeHDtDNz0gybgDbkkK6T1tUE0j3GFoGzEQZzm14hLDgvoDwHe8DHN0ccc2MMU
        xomtxhuQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l3c6g-002pYJ-4r; Sun, 24 Jan 2021 09:54:59 +0000
Date:   Sun, 24 Jan 2021 09:54:54 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: set WQ_SYSFS on all workqueues
Message-ID: <20210124095454.GG670331@infradead.org>
References: <161142798284.2173328.11591192629841647898.stgit@magnolia>
 <161142799960.2173328.12558377173737512680.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142799960.2173328.12558377173737512680.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  	log->l_ioend_workqueue = alloc_workqueue("xfs-log/%s",
> -			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_HIGHPRI, 0,
> -			mp->m_super->s_id);
> +			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_HIGHPRI,
> +			0, mp->m_super->s_id);

This is just used for log I/O completions which are effectlively single
thread.  I don't see any reason to adjust the parameters here.

>  	if (!log->l_ioend_workqueue)
>  		goto out_free_iclog;
>  
> diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> index a06661dac5be..b6dab34e361d 100644
> --- a/fs/xfs/xfs_mru_cache.c
> +++ b/fs/xfs/xfs_mru_cache.c
> @@ -294,7 +294,7 @@ int
>  xfs_mru_cache_init(void)
>  {
>  	xfs_mru_reap_wq = alloc_workqueue("xfs_mru_cache",
> -				WQ_MEM_RECLAIM|WQ_FREEZABLE, 1);
> +				WQ_SYSFS | WQ_MEM_RECLAIM | WQ_FREEZABLE, 1);
>  	if (!xfs_mru_reap_wq)
>  		return -ENOMEM;

This one also hasn't ever been something we tune, so I don't think there
is a good case for enabling WQ_SYSFS.

I've stopped here.  I think we should have a good use case for making
workqueues show up in sysfs based on that we:

 a) have resons to adjust them ever
 b) actually having them easily discoverable and documented for adminds
    to tune
