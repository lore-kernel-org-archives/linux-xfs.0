Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39538C2D0A3
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 18:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD25E216C4
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 18:47:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YWYis0+S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgKCSrC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 13:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgKCSrC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 13:47:02 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF689C0613D1;
        Tue,  3 Nov 2020 10:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=v0j52AeZPKA0qxZUCmEvxGbhC3x2T1BGp6JqYpQxJkA=; b=YWYis0+ScGjSMbQRzeS6WhrTtc
        Emjjf0voPzOqSgMIah1zjMkapaSJ2o/huVAcCq5zl25zNSS8LihDqGFBF2K/qiVX2QsNprlL6VwRv
        2Pjz4zyOYL0B3hMCZWDV1ZzOV3LnG9qEgCOEv/IpJXE0xc13NTVbgqbJHw/I/+i/GU+Bmkc8jK/G+
        59RA74KSv1nOgevKWtd4lj8syPEuk+U/aiqOaO6gFGNbmBXlbyfA4EifUfO6LornKjMjogMdAEkt3
        d2mFtltNAaap2Ls2NkMWy+E0TYvtnHnMM0Lrpfll+xNID/zVtmaNosIb6nkUJqJ91GzIEcYO27F3/
        AsA4nD+g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ka1Kd-00058i-TF; Tue, 03 Nov 2020 18:47:00 +0000
Date:   Tue, 3 Nov 2020 18:46:59 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, fdmanana@kernel.org
Subject: Re: [RFC PATCH] vfs: remove lockdep bogosity in __sb_start_write
Message-ID: <20201103184659.GA19623@infradead.org>
References: <20201103173300.GF7123@magnolia>
 <20201103173921.GA32219@infradead.org>
 <20201103183444.GH7123@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103183444.GH7123@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 03, 2020 at 10:34:44AM -0800, Darrick J. Wong wrote:
> > Please split the function into __sb_start_write and
> > __sb_start_write_trylock while you're at it..
> 
> Any thoughts on this patch itself?  I don't feel like I have 100% of the
> context to know whether the removal is a good idea for non-xfs
> filesystems, though I'm fairly sure the current logic is broken.

The existing logic looks pretty bogus to me as well.  Did you try to find
the discussion that lead to it?
