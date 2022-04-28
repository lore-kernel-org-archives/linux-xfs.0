Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2671C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 13:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238974AbiD1NJd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 09:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346736AbiD1NJd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 09:09:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034FDB0D05
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 06:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=AdirbgLMph7QnVLPRyWrEJE0Sp
        YoBm7sdKw9++9y00CbuSaCendFVuJi6qAB8881O4NYAvoUlNI8SPgsHS0L+T8igco4hxdvSdCvZMA
        ExkWVN3jzEF2zXxgX7zkIi9ixpKhRSSbn7dxdnvvRZtR3iyCXWVoMXz5WMi6Ue0U8S/Wvt6I1QvIj
        yBEbRmPaGhzKmLjkIeXfbOnkgTTgx3GsG76p5zdw70swqc3QZWjARO+16CQUnuhCKuv8aZCEPegAt
        zvmsMvxdbrmsyCXPIYaCjQEuUkdVp+Ihgr4cdRZp81hui02AyV0LerLxdzO5jV4mVKPMV97U1pR+P
        Z4e/+1Sg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3qU-006vmU-Iw; Thu, 28 Apr 2022 13:06:10 +0000
Date:   Thu, 28 Apr 2022 06:06:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: factor and move some code in xfs_log_cil.c
Message-ID: <YmqRQri9X3fLObDz@infradead.org>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427022259.695399-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
