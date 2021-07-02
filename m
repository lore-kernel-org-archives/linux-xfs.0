Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D29C11F68
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 09:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BFEA6141E
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 09:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhGBJDD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 05:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbhGBJDB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 05:03:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64ADCC061762
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jul 2021 02:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/mqxgY6nYEO25caxEP/i6muZ0qhnkEhnDUFvBxIGk6g=; b=XQOVfw8tvqd6n1dHdX2v0adax3
        xImNLSTpFa1Wj/sdHsfyXGp+xjGvh2a43k/k6DPuBjTTJaoHHY5jJuhmE1xuruRS7DF9B85djnbk3
        ckei8l3I3Q6EtXrQX9CDas0lGWrmvpxhHwV9riNenLpe1JCbTQK+E6+FjmwYMF3nVgy18hyXBA6O/
        KrcaXDeynzGjlNg//lGgcCTnf2CCIQ6MFu/1c+3/THjLtxvbytOPsrXHjisMmt/Qys6brpWF1/H0L
        WvOQ9CnpmBjxNdRyUihs3hae3+uRt4Ew52XepJGYJpgqgwfLpX11sAm76Sf0WmV8UE+RyJdy5tTOC
        gpik6xKQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzF1n-007XbL-Rj; Fri, 02 Jul 2021 09:00:10 +0000
Date:   Fri, 2 Jul 2021 10:00:03 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: factor out log write ordering from
 xlog_cil_push_work()
Message-ID: <YN7Vk7vY1qQ8Lehe@infradead.org>
References: <20210630072108.1752073-1-david@fromorbit.com>
 <20210630072108.1752073-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630072108.1752073-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 30, 2021 at 05:21:06PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> So we can use it for start record ordering as well as commit record
> ordering in future.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
