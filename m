Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A281C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 08:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17A2261264
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 08:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhKKICx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Nov 2021 03:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbhKKICx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Nov 2021 03:02:53 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA04C061766
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hhcs3cfnW8j1VYQRw6grjQnbUsVQLZUkM5ORsqen2VM=; b=1bSEeas/bx8UIIK1TiCotZ7U0k
        iaDnE7SJw7F+6CVok6k/jzLMb7wx2etE3rmZO9hFJr1EmqmxhVpboKGlO7HthSVdX8F64Ro2XIch3
        46n/lz5qs+u0bU2VAoMJuP16xyK5yK/0yjZCIRcvmpyLlT8IaiUItxr16brGFHNlHi98IHeqkSH1i
        hNvI2sOOI1ILQXxjHQS7/xQ38zM4G/D3ZuEzGa5mWvscUaHyYcrga5G+tkJ2M2QVJYrU4MhX0H59r
        cCUSTlkuA6sJVRxt/dWECQER5g9VAYTLxO+LNEJQEC7pLFaNw4o6TNKvuTc1pB2wXZs6uBIe/cxzH
        UTEID/HA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ml508-007RwI-Gk; Thu, 11 Nov 2021 08:00:04 +0000
Date:   Thu, 11 Nov 2021 00:00:04 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/16] xfs: embed the xlog_op_header in the commit record
Message-ID: <YYzNhAdj9xPGO5HX@infradead.org>
References: <20211109015055.1547604-1-david@fromorbit.com>
 <20211109015055.1547604-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109015055.1547604-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 09, 2021 at 12:50:43PM +1100, Dave Chinner wrote:
> -			if (optype & XLOG_START_TRANS) {
> +			if (optype) {

Shouldn't this explicitly check for XLOG_START_TRANS or
XLOG_UNMOUNT_TRANS?  The cont flags can't really happen here, so it
won't make a functional difference, but it would document the intent
much better.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
