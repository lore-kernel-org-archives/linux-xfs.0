Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CFDC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B23C060C3E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhHLIoV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbhHLIoV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 04:44:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C842C061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 01:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jz2ZlH52VlzYKKVoUl/3teVcGn0IjenbVnptoz6LoPg=; b=SGyGbWiJHTBvE834RlWx0P/9EU
        V9SKiKd5ZE8PHSjxEt9sJXyz8U9wQeUzOvv3Jc6+5hyeAJhdbRldxYMzIlV6xv6BZCp2Fg40niEkK
        XWDSdB1427Dgtg/l6fJLoVkA4C5/IE041BAovfk7eXlLCFjpE0iChqi+e7C3hn24IGjfF3tMTSMMI
        8iPlH3ZHY1dvGR91YTBieIHtPbnvh9tklZWRN1jVUiTBz0BFTWmfXImJAHldZk4l4dVT705kXphmR
        n9nA5RDHpE13cbcr8BHqHfkQpT0kirpXGlxOPzVpDJ5ZbXm9GmXauu2+zZ78anQgndnAKONTlCMJb
        3gEPfnBw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE6In-00EM1B-2n; Thu, 12 Aug 2021 08:43:26 +0000
Date:   Thu, 12 Aug 2021 09:43:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove unnecessary agno variable from struct
 xchk_ag
Message-ID: <YRTfFQrjxLUUX8Bl@infradead.org>
References: <162872993519.1220748.15526308019664551101.stgit@magnolia>
 <162872994071.1220748.13299032445442241616.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162872994071.1220748.13299032445442241616.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 11, 2021 at 05:59:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we always grab an active reference to a perag structure when
> dealing with perag metadata, we can remove this unnecessary variable.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
