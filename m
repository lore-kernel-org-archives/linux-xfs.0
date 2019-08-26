Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A2EC3A5A5
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 07:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E36E32173E
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 07:47:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iVT79kGY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbfHZHrg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 03:47:36 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33292 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfHZHrg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 03:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/WyE+Z2C+afTCaKDbRmezacU/fLPRlPuLxT6gEJJhSk=; b=iVT79kGYLuFsi6xgghHt6GmFZ
        Dw5awu6IlwOpqmaaD7mUxRnRoLmkztWynuLwq9tUK4GDJG/t73JhcxzFLBGDBjrVd0qQdmhNA1cTQ
        VynVw1xbYJ9ErN4nAXWxbRxgo6CiR3RLiPg9PEOrVEZY9lAtIL5T894Kx8z/RCxZZWIin5EZdqDPt
        KveeEVrETkVluOUcfFxevnpgadPprR+wHDGVMEO/RJO1cC8Y6W+2K6xePqkIYndsJ/QGodA3h3Ffe
        GD3QX3MDNUSmEV2MHtzJT3ETH0pBTRdZfMzfHpti0J/FBD4qxLcHoD+1W9M/R6Usc9BYsryS0ncky
        iolNj/m9g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i29ix-0002Wt-MU; Mon, 26 Aug 2019 07:47:35 +0000
Date:   Mon, 26 Aug 2019 00:47:35 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add kmem allocation trace points
Message-ID: <20190826074735.GA20346@infradead.org>
References: <20190826014007.10877-1-david@fromorbit.com>
 <20190826014007.10877-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826014007.10877-2-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 11:40:05AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When trying to correlate XFS kernel allocations to memory reclaim
> behaviour, it is useful to know what allocations XFS is actually
> attempting. This information is not directly available from
> tracepoints in the generic memory allocation and reclaim
> tracepoints, so these new trace points provide a high level
> indication of what the XFS memory demand actually is.
> 
> There is no per-filesystem context in this code, so we just trace
> the type of allocation, the size and the allocation constraints.
> The kmem code also doesn't include much of the common XFS headers,
> so there are a few definitions that need to be added to the trace
> headers and a couple of types that need to be made common to avoid
> needing to include the whole world in the kmem code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good, although I'd still prefer the AG enum move in a separate
prep patch:

Reviewed-by: Christoph Hellwig <hch@lst.de>
