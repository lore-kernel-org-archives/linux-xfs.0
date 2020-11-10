Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D44EAC55ABD
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FFE020809
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:35:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="idrUZt1Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbgKJSf1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgKJSf0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:35:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2A4C0613D1
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 10:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wVn991WtZ3w2A/8QNJOg9YD6hFOPtbYYyCDek7l13x4=; b=idrUZt1QfDj0GltsFcaTkIHrnj
        lC3ZBqzOJcKnWZjBTnb0f3FcaZtQHro+PmJfuOg8Yh+uJEN3s+2TlZHz2kz6KTOm2OuiSn7o3tl8j
        nOsFD7mMeReQTVrBIZo9TVKLn3WWJUGXeUjeBdjqhFBBWeePn7ZpzrlyaJr112d5BfaVmWtddM5Ck
        gKe96r5Smne4KFugLMlzjcBIqrwFTvOXD/uLFREb6AFbc9idXyGWAjHHyPUEvOGKTHLHn39Q05uRe
        xcxEAqcdqXVY37EWXZkyHR8ma7UVJHTpc0gDRw9d/d6v/0gRepAQC/k7ENNc113PbIAKqwtFxuWw1
        t5rQFI3g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcYUH-0002b2-AF; Tue, 10 Nov 2020 18:35:25 +0000
Date:   Tue, 10 Nov 2020 18:35:25 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/4] xfs: fix brainos in the refcount scrubber's rmap
 fragment processor
Message-ID: <20201110183525.GD9418@infradead.org>
References: <160494585293.772802.13326482733013279072.stgit@magnolia>
 <160494585913.772802.17231950418756379430.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160494585913.772802.17231950418756379430.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 09, 2020 at 10:17:39AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix some serious WTF in the reference count scrubber's rmap fragment
> processing.  The code comment says that this loop is supposed to move
> all fragment records starting at or before bno onto the worklist, but
> there's no obvious reason why nr (the number of items added) should
> increment starting from 1, and breaking the loop when we've added the
> target number seems dubious since we could have more rmap fragments that
> should have been added to the worklist.
> 
> This seems to manifest in xfs/411 when adding one to the refcount field.
> 
> Fixes: dbde19da9637 ("xfs: cross-reference the rmapbt data with the refcountbt")

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
