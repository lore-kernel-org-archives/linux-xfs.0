Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57936C07E99
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 363D5610CD
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhGLLZ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jul 2021 07:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhGLLZ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jul 2021 07:25:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB961C0613DD
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jul 2021 04:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eQGDl7RSpZfQlpEFCko5RPDDr2869BAevlSFQKfTqT0=; b=c11FBbKmnm7v8yxnvuBTwcY2Fe
        DSIxmmKjFf5XFB6jNkawYx9Y86PCn4nH7BhORIf+q8QYlZJ3MBph7r5PwDTbyN0IbWjdUZf3PLetx
        3RUStMGJiyAQsCgNd20xVVM2Vvo+UFTURljY2ba19VyxngczIohcZPH3DlPmdEh4Bej6XKfi1lUYW
        FvlmOWOtrsFL0KU/BIEpWi9BGM0qlW3NaURgnFDtH9t6BMB7z+3D8ycPvSmBMRjAaVNUlscwF9pqx
        w/QK+vc71LArpv5gjVTPq62j1HFoOGXisYgYdBtUcBjjiy8Jc3w/vuBh/Djz/P5oZ0gxpvIPsGpKV
        kZrM/RZA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2u1W-00HXtO-6q; Mon, 12 Jul 2021 11:22:57 +0000
Date:   Mon, 12 Jul 2021 12:22:54 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't expose misaligned extszinherit hints to
 userspace
Message-ID: <YOwmDlUyhHkkC05N@infradead.org>
References: <20210709041209.GO11588@locust>
 <YOfrxV9p1Bhrs1jD@infradead.org>
 <20210710035831.GB11588@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710035831.GB11588@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 09, 2021 at 08:58:31PM -0700, Darrick J. Wong wrote:
> > Looks sensible, but maybe we need a pr_info_ratelimited to inform
> > the user of this case?
> 
> Why?  Now that I've established that the system administrator is and
> always has been allowed to invalidate the extent size hints when
> realtime volumes are in play, I don't think we need to spam the kernel
> log about the admin's strange choices.
> 
> The only reason I put that xfs_info_once thing in 603f00 is because I
> mistakenly thought that the only way we could end up with a fs like that
> was due to gaps in user input sanitization, i.e. fs isn't supposed to be
> weird, but it is anyway.

Ok:

Reviewed-by: Christoph Hellwig <hch@lst.de>
