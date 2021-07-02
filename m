Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C115C11F68
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70CE761413
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhGBI4L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 04:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbhGBI4L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 04:56:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3844AC061762
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jul 2021 01:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RFjkTvA5gXFhmCnO8WNxfKGNITXhpnTTDEp66cGtpnU=; b=QcWgMP/rT5JrsiDnQ6m5tB+wuf
        oGJbbw6JKetIC1lBxf1MhYikdQIHlnmnJTNYFmk6FXTSkzYyQIle4TMGTsCvbTwfd4KKx5Y8xU4Xj
        rIhLWW/TlKmA6UlFHS8j84TAO13aqDhDGAf0F5Ilf6OE0P+a65cBG/o4AzjMybtmyK5Bn0Jrroop8
        eltAPsz3Kk71kg9Od62IgBMvWTMeeRnafVFcT8v4RI3O9YMh3xcqmPrC+/e2Tw52FwDLzxW+L5b24
        LJRQFZtt9MqXeMKNxJEQt3Ya0kQBaTwjVw+jysyljCsziFIKtndINvW1+67G1ZucIaJqZfO/8jow+
        phbWje3Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzEvD-007XDM-Ba; Fri, 02 Jul 2021 08:53:21 +0000
Date:   Fri, 2 Jul 2021 09:53:15 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: log head and tail aren't reliable during
 shutdown
Message-ID: <YN7T+6ozxZxAvfjZ@infradead.org>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630063813.1751007-10-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	if (tail_cycle == head_cycle && head_bytes >= tail_bytes) {
> +		return log->l_logsize - (head_bytes - tail_bytes);
> +	} else if (tail_cycle + 1 < head_cycle) {
>  		return 0;
> +	} else if (xlog_is_shutdown(log)) {
> +		/* Ignore potential inconsistency when shutdown. */
> +		return log->l_logsize;
> +	} else if (tail_cycle < head_cycle) {
>  		ASSERT(tail_cycle == (head_cycle - 1));
> +		return tail_bytes - head_bytes;
>  	}

Drop the else after the returns to make this a little easier to follow:

	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
		return log->l_logsize - (head_bytes - tail_bytes);
	if (tail_cycle + 1 < head_cycle)
		return 0;

	/* Ignore potential inconsistency when shutdown. */
	if (xlog_is_shutdown(log)) {
		return log->l_logsize;

	if (tail_cycle < head_cycle) {
		ASSERT(tail_cycle == (head_cycle - 1));
		return tail_bytes - head_bytes;
	}

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
