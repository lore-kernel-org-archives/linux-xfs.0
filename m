Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4162FC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbiF2HDU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbiF2HC6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:02:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EBD3BA49
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2SoAc89HWf/ZGM5BoqU6nH/jiY
        wjz55amwhYK3L2iJCpbJ7nraFPT82wtER+YNGNGuGNaT0FglqLLBWO067N+Wn7+HvDEngsTdadxrG
        9s0bRNH+YRWuFWBI5cah8LMbFRUiN28Fb6GhqI1J1tz+B0YZ7Bk1IkyqG1BSAQhCwKnykBpwZhNSz
        jUBCUzDqvgvZiDnIDZKL0rK5HhCzO8KKPGBhKE3M+G0VwymvBbuSOIk91SB5XnEMBNid3z7Q3tkTr
        z4oZZD8N1cp+7xIN9lhRWL2eJM5jToy3YQrohwQdpJV5CJwr6xM6cul0GXPIvWe5mOfEIgN3I9nsk
        nsHwMIVw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6RgC-009yMF-Pr; Wed, 29 Jun 2022 07:00:04 +0000
Date:   Wed, 29 Jun 2022 00:00:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/14] xfs: Pre-calculate per-AG agbno geometry
Message-ID: <Yrv4dG9keaksjrwM@infradead.org>
References: <20220627001832.215779-1-david@fromorbit.com>
 <20220627001832.215779-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627001832.215779-12-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
