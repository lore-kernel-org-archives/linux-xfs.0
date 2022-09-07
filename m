Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087E5C6FA89
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Sep 2022 14:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiIGOBN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Sep 2022 10:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiIGOBM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Sep 2022 10:01:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74958B1CF
        for <linux-xfs@vger.kernel.org>; Wed,  7 Sep 2022 07:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qUHCmSEQ/OxxvMN5VAXM/SqIQYYB6uDrsIH91iso8r4=; b=OVPw/idbA/1M9Zz45yEYMPPhWe
        b4ewhuBCUzuP/l48P7fFWZ1GgA1LyVFhm+7zm68W59jDoqRrXWu7vs5HQ6Ue5/bABuC+7HNjX5jgL
        L4r8OLiro6OEL4jkMAN+R6WKd2Dnb06LRKfP5G1Fp62zLzRvOlm4kWZPBBVs/Yi5ZtWloHlqW3Q9J
        M4mp/GWiO5dHMaUJvtfyJ6JqyI2ZHibE5Gv6KOl8MHq5aLObizUFqWG+tGbdtfY6pdOQ95G1XnzWh
        J8kEEFHlAbuESvj+nWb3fEQr9QIf42T8k/KLOzqMD2dAeKgc94d7uxYN3qnsVYjc3a4T+hGOtPYwK
        YQmACIlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVvc7-006glH-3o; Wed, 07 Sep 2022 14:01:11 +0000
Date:   Wed, 7 Sep 2022 07:01:11 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: AIL doesn't need manual pushing
Message-ID: <YxikJ9D5SY/eSZlz@infradead.org>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809230353.3353059-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

First a note: the explanations in this email thread were really
helpful understanding the patch.  Can you make sure they are
recorded in the next version of the commit message?

Otherwise just some nitpicks:

> -xfs_lsn_t
> -xlog_grant_push_threshold(
> -	struct xlog	*log,
> -	int		need_bytes)

This is moved around and reappears as xfs_ail_push_target.  Maybe
split the move, rename and drop of the need_bytes into a separate
cleanup patch after this main one.

> +int xlog_space_left(struct xlog	 *log, atomic64_t *head);

Odd indentation with the tab before *log here.

> +xfs_lsn_t		__xfs_ail_push_target(struct xfs_ail *ailp);
> +static inline xfs_lsn_t xfs_ail_push_target(struct xfs_ail *ailp)
> +{
> +	xfs_lsn_t	lsn;
> +
> +	spin_lock(&ailp->ail_lock);
> +	lsn = __xfs_ail_push_target(ailp);
> +	spin_unlock(&ailp->ail_lock);
> +	return lsn;
> +}

Before this patch xfs_defer_relog called xlog_grant_push_threshold
without the ail_lock, why is ail_lock needed now?
