Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A95DC4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 07:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49790208C3
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 07:44:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FBHQ0wYM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgEAHoz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 03:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgEAHoz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 03:44:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACFBC035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 00:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=byRLxjpdeK5tHdign1IKl/4ndyBCBlTpMh2OE6gzQE8=; b=FBHQ0wYMMKjw79WxnBlAAhuTYo
        RUy8Uqkrg7VMH2aEuBIv8RkZjhvGED/mXmoM8ynMYba+YqNEZD0x5L5lKojz5Zc2lnzoYjYtJDYfH
        nsXcChiQ+ZX90kxyX5d7DEoF25kawGMYKsBghOoko6HMLTItuSh08VafuDCx5/A8ivMuHiwPW1xe3
        vpvzWiPBBjevFS8CSEfIRSXkWHSjjLvgidUsqwlSG5VAI0EKofT0fuILkjbANa1T5DCjcouD3qBl6
        IyLtdPtvkc/epX0sqHE1h2J3lJQ/Y0BKQLo7307OmOCQqvyjE5RZbv7LLOBHL7+l0zGc/SXByYQc+
        IVcy0v7Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQLv-0008HD-It; Fri, 01 May 2020 07:44:55 +0000
Date:   Fri, 1 May 2020 00:44:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 06/17] xfs: refactor ratelimited buffer error messages
 into helper
Message-ID: <20200501074455.GC29479@infradead.org>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-7-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:42PM -0400, Brian Foster wrote:
> XFS has some inconsistent log message rate limiting with respect to
> buffer alerts. The metadata I/O error notification uses the generic
> ratelimited alert, the buffer push code uses a custom rate limit and
> the similar quiesce time failure checks are not rate limited at all
> (when they should be).
> 
> The custom rate limit defined in the buf item code is specifically
> crafted for buffer alerts. It is more aggressive than generic rate
> limiting code because it must accommodate a high frequency of I/O
> error events in a relative short timeframe.
> 
> Factor out the custom rate limit state from the buf item code into a
> per-buftarg rate limit so various alerts are limited based on the
> target. Define a buffer alert helper function and use it for the
> buffer alerts that are already ratelimited.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
