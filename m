Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C93CCA47C
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbiF2HFy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbiF2HFm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:05:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1575736323
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SXwhG3W2HsBXSWuAKq2PR9zg1z
        aXktmv6UXWlRVfMPZO8xSG/nqPzoRjneEMn4LP+Js0Odvnw7CUsvhK1EHLi2x9849dBdCQoLBgdix
        yvWHj8RiLNw8oUFn9SARDkK50tjLUy1rqJCT/H+hIB8D2tGEQpgcZjaVFOcQLB5cMjz1Wh04WpSKU
        fZ0AKJLltWrOHYs5hIDmh/En2oyf9/tz8wBzBvvfehmZby+J936N7j/DcBCzDQspvowT87faffZEc
        Ci902XoCJncsrky338AHl9r4GAQc0tLhCGwRASSsjMCMjtJUIxxrR+HJD/nTsKvfqTCesRqE19+2I
        ZTQLBIbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6Rjj-009z7c-Eo; Wed, 29 Jun 2022 07:03:43 +0000
Date:   Wed, 29 Jun 2022 00:03:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/14] xfs: make is_log_ag() a first class helper
Message-ID: <Yrv5Tx5e6pfaIoE/@infradead.org>
References: <20220627001832.215779-1-david@fromorbit.com>
 <20220627001832.215779-15-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627001832.215779-15-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
