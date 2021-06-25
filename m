Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D13C2B9F4
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 03:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 115F561400
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 03:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhFYD4h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Jun 2021 23:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233023AbhFYD4g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Jun 2021 23:56:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E509FC061574
        for <linux-xfs@vger.kernel.org>; Thu, 24 Jun 2021 20:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xFO4N6E60UVpWuHg8zReKw2PcZ4PO8kIPmHEGAImtWo=; b=COW866MbeTbLRzrFm2FIRz903n
        9zoOeOuh9QurapHW+rP3H9pizslgs4wp8S9lL4OTGCD2/UbjvZI0Ub47n5PE1i1nIShnTq4zKl5zg
        C5LgZ29esYqmd50TpQjiWlxUAlXHmOUbecsDDRzkEbIKIDvNg8204/WceFxSTIjgZ1nPYFc8jD8p8
        a//TZTrIJ5fO2pU1pwkYMl5yfLlQRvG1GaW+Pp4QZ88bH11eFfqu8ABsLXju3bezuxmNN90WUPO3x
        ofqNbVr2OS50dqbOwR2RNSB/1OCIAfPS8/rA7P88R8rhyAdzN9al3sqrUwhty836upbjm2qYOepNt
        lUW89wnw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwcux-00HHKC-2a; Fri, 25 Jun 2021 03:54:13 +0000
Date:   Fri, 25 Jun 2021 04:54:11 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: Add kvrealloc()
Message-ID: <YNVTY0uNdYz8xYp5@casper.infradead.org>
References: <20210625023029.1472466-1-david@fromorbit.com>
 <20210625023029.1472466-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625023029.1472466-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 25, 2021 at 12:30:27PM +1000, Dave Chinner wrote:
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 8ae31622deef..34d88ff00f31 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -830,6 +830,20 @@ static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
>  extern void kvfree(const void *addr);
>  extern void kvfree_sensitive(const void *addr, size_t len);
>  
> +static inline void *kvrealloc(void *p, size_t oldsize, size_t newsize,
> +		gfp_t flags)
> +{
> +	void *newp;
> +
> +	if (oldsize >= newsize)
> +		return p;
> +	newp = kvmalloc(newsize, flags);
> +	memcpy(newp, p, oldsize);
> +	kvfree(p);
> +	return newp;
> +}

Why make this an inline function instead of putting it in mm/util.c?
