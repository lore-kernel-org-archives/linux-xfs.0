Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A91BC433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 07:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52E8860249
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 07:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhDBHIh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 03:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhDBHIe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 03:08:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2E1C0613E6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Apr 2021 00:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7vaUiHdTDVvR1iHb4MRpAaLgHrnP0UuhNgulgY8Sa/c=; b=n/t5qtnkObrl/9dopzH+SStZSm
        rhyDWKM6sGFac0cH0TcuD72DkHogjjTWbV8q3FU4W6iHo97pEmZSp79Q+TdnVwgpkEkOwfLg0x4sj
        rPVkI4uzrdYR0t6w4vGef2HYytrM6+w9xAJwNQ4jK5zSqGq3aWMfWXBz96bRPtnPHkm/mJNu/3ite
        QF/kmj4THuvHvIA28/OMmpNuAdQOQrScFxi1o0pk8sWSrjirbXWdG57dY+Hoo4AYruE9WFzCj+VYq
        pIAdjmxJNBPqAhil7GIpG+yNwYvcYow/4ps1sGIbKeyz4s65ICF7G1cDwgCdB32KPBUfsYISlVp//
        3EUoF/Hg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lSDuc-007Jz8-J0; Fri, 02 Apr 2021 07:08:24 +0000
Date:   Fri, 2 Apr 2021 08:08:10 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: default attr fork size does not handle device
 inodes
Message-ID: <20210402070810.GH1739516@infradead.org>
References: <20210330053059.1339949-1-david@fromorbit.com>
 <20210330053059.1339949-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330053059.1339949-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 04:30:58PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Device inodes have a non-default data fork size of 8 bytes
> as checked/enforced by xfs_repair. xfs_default_attroffset() doesn't
> handle this, so lets do a minor refactor so it does.
> 
> Fixes: e6a688c33238 ("xfs: initialise attr fork on inode create")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
