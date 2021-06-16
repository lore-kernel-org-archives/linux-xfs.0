Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 103BDC48BE6
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 08:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E15026115C
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 08:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhFPIXq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 04:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbhFPIXq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 04:23:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA36C061574
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 01:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=T7EG7FM+omHC3S+Od+SLNUVOF5qwUsnu4gzIsedtwTM=; b=PpZ73jGfNLdQ7al4JAxT8JXe0D
        7SigfG8QXww4uR5w+4774t/Y2aiBH117P2HYgMpHxVG73Z9gixBcTsdVWQtSzeW8JvEHQqN7i/YlV
        NG0jgJ0UZTAmYLS+bSwTsSfdx9p0EI3RAJRn7ADRIy3l5Y80EfAD1z2gWzwSkLLEpvk9IXU3RzG84
        orEpxRfq4mKj2PvMbsBtEtAouSHP2JZq5/p41rkA/gHacC+EKJl+1bXd7DOD/aoOYd6OauuX77JWy
        IPCZOoNL0VfLZ3pFuFYRv9udhJmwNIbhbsDKlWig8/7qoZRb5t8y6G+RVRe0+U1S7qwJFFKhcmEc1
        Zwn9tQng==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltQnh-007ncn-MQ; Wed, 16 Jun 2021 08:21:31 +0000
Date:   Wed, 16 Jun 2021 09:21:29 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Subject: Re: [PATCH 03/16] xfs: detach dquots from inode if we don't need to
 inactivate it
Message-ID: <YMm0iY0WiMHa2B7s@infradead.org>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
 <162360481340.1530792.16718628800672012784.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162360481340.1530792.16718628800672012784.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 13, 2021 at 10:20:13AM -0700, Darrick J. Wong wrote:
> -	xfs_inactive(ip);
> +	if (!need_inactive) {
> +		/* Going straight to reclaim, so drop the dquots. */
> +		xfs_qm_dqdetach(ip);
> +	} else {
> +		xfs_inactive(ip);
> +	}

It seems like most of the checks contained in xfs_inode_needs_inactive
could be dropped from xfs_inactive now.

But given that I feel the heat already I'm not going to suggest that
now and just going to look into cleaning that up after the series
goes in..

Reviewed-by: Christoph Hellwig <hch@lst.de>
