Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E679C11F6B
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7961F61420
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhGBISX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 04:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbhGBISX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 04:18:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FEEC061762
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jul 2021 01:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uGwJYOsEog/WKXO5z/yLPpNkF8rtP/frWszWRtuJMPQ=; b=vWd50Vh5+Hej8OcCWjrU0psBrs
        PZVqSVlw0spr0xBNj41EbA9LeQQwQWhLvoxl/x7hWfouryv9pmeiZsXJSLGvE29F3ALRKl53XCoeE
        6O77QDKHUB/BW6Apu+v75SjOuSqnAW4fKiCKpZC74q0H4n4WUH7Yb140ZxUkZu48vxbmSMsUncetg
        DIBqpn7Lfmlcl5vl1hGAP7YBxrxDbYqqFZdAUjhR9QQK1IP44WjhwHYfx78hKKabsKWsM09p9AFDX
        3RgqthoqJhI3BGhzl5kZZ426+jEHfa6cUrQANwCP52j/EOt3YIMXaqGx+3NL2QVnEjedzAdZCPI0q
        bzeZVOmA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzEKl-007UMk-3D; Fri, 02 Jul 2021 08:15:40 +0000
Date:   Fri, 2 Jul 2021 09:15:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: convert log flags to an operational state field
Message-ID: <YN7LJ8jc4vjojrbs@infradead.org>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630063813.1751007-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> @@ -552,6 +552,7 @@ xfs_log_mount(
>  	xfs_daddr_t	blk_offset,

>  {
> +	struct xlog	*log;
>  	bool		fatal = xfs_sb_version_hascrc(&mp->m_sb);
>  	int		error = 0;
>  	int		min_logfsbs;
> @@ -566,11 +567,12 @@ xfs_log_mount(
>  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
>  	}
>  
> -	mp->m_log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
> -	if (IS_ERR(mp->m_log)) {
> -		error = PTR_ERR(mp->m_log);
> +	log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
> +	if (IS_ERR(log)) {
> +		error = PTR_ERR(log);
>  		goto out;
>  	}
> +	mp->m_log = log;

Additition of the local variable here looks rather unrelated, given
that the log is only touched twice in relation to the flags.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
