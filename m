Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 741CEC433DB
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 09:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3974022CB2
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jan 2021 09:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbhAXJkp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Jan 2021 04:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbhAXJkl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jan 2021 04:40:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE2EC061573
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jan 2021 01:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=R3F6jbIaqi4Pqq8QZV0xWjBJ7WGzyivlJ9PfqGQcrhA=; b=mmIEcUqV8yGGeAp3cYkGZei2ZX
        BIBBatvzzl6mllWPsxIuegNEyCcL0Du+movvfxbDLCx7iTZ9ZV/HQunT9YUvI4C4OqRibTbKLsltl
        +LQ84nt2NMpKi4aUNkCpIrV/h+S/+PZmrQCMQTMv8+V5/2my67ODgOa/BCgsImYNAalxPUqsXPuSN
        UUY31EDcINHIH56hcuoX8LQHCWVnDRO56dAhK2p04n27WLuTda/6nog0wq5v0W+6RJw+J8SQVPEDD
        46IBgvcRKEuPlqR3TKVUp6FnfMyFzQxoqrZPUD4CqMqny8C2BN8IppoNKebodZnG7FNratwkpGOH4
        O2gUFPxg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l3bs9-002oqC-9z; Sun, 24 Jan 2021 09:39:55 +0000
Date:   Sun, 24 Jan 2021 09:39:53 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 06/11] xfs: flush eof/cowblocks if we can't reserve quota
 for file blocks
Message-ID: <20210124093953.GC670331@infradead.org>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142795294.2171939.2305516748220731694.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142795294.2171939.2305516748220731694.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	/* We only allow one retry for EDQUOT/ENOSPC. */
> +	if (*retry || (error != -EDQUOT && error != -ENOSPC)) {
> +		*retry = false;
> +		return error;
> +	}

> +	/* Release resources, prepare for scan. */
> +	xfs_trans_cancel(*tpp);
> +	*tpp = NULL;
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +
> +	/* Try to free some quota for this file's dquots. */
> +	*retry = true;
> +	xfs_blockgc_free_quota(ip, 0);
> +	return 0;

I till have grave reservations about this calling conventions.  And if
you just remove the unlock and th call to xfs_blockgc_free_quota here
we don't equire a whole lot of boilerplate code in the callers while
making the code possible to reason about for a mere human.
