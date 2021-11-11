Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42833C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 08:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16BBA61077
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 08:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhKKIPA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Nov 2021 03:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhKKIO7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Nov 2021 03:14:59 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020D7C061766
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=J/ME/lTLazCw3Gry7BWZeP8Vqz
        oCIMKcmN1cpAPbxs9ZN6MZvvRYge6JjQ5YysH8Yc+2iVERzFONSAKbVnkqtgFoLw1edh6S1jWzefS
        8x6XN7QK9mEqHr8NPB3EiQT4UGixwzrEd/EFgvG2EveLr+UH8FvpGNTD6w+8trMvN1yrldq4vTvWI
        zHLcPrvoxlNrsWHsC8yyiABERTMw2VbdkBIhKDebHmrFDONhXmUBjtJb3dBPuNXaXz3YPNbm5bCkc
        N2WyvkEYO3lewlL6HC2XU5oKjz+iWvbIu/ZHiPJW8Sd57VDXtJ8imU3iklqY6LghdeY8pZ9UKDnMI
        RnkLsCHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ml5Bq-007Tfu-Js; Thu, 11 Nov 2021 08:12:10 +0000
Date:   Thu, 11 Nov 2021 00:12:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/16] xfs: introduce xlog_write_full()
Message-ID: <YYzQWmHuvF8k4TN8@infradead.org>
References: <20211109015055.1547604-1-david@fromorbit.com>
 <20211109015055.1547604-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109015055.1547604-12-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
