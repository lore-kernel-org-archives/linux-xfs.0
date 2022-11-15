Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2686C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 08:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbiKOIpv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Nov 2022 03:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbiKOIpv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2022 03:45:51 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BFBF27;
        Tue, 15 Nov 2022 00:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=di2oz6J29xTeHlflxen9qce/dzhTvWoL/MoEb+gWYw4=; b=ChQOdSsUkN2/Dp81SA7RNbRiaY
        IIDROI/HA8LbAHWTe52PC+poLkwC29GlG2z7HTNfUeh82kTfEh0wsQRlxZpvgbOFF/4/w2avLCRmC
        gpPHIhy0gwxfSVomjF/8FA7KKe+vVqT1dpBXqXIGQHwg14fY/CjAdB5XP+ywp2o2XjsqLscq1Hqia
        Ril7qGW4rOc3r7kVPTQe2DZMZgzCInxy+rvxr2EJ8C8l/zeIBW64Qk6tWoAzCRnmhFEEy/WIBdNvs
        QMjLMadd17pjhzkwjFMkz8PDRQSWdtdJ/nbtnQo27Th5rnti/uRRRHRkGYFy1jpCif1ZU9gmVjaFO
        62cKAxIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ourZm-0090zA-8b; Tue, 15 Nov 2022 08:45:50 +0000
Date:   Tue, 15 Nov 2022 00:45:50 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 7/9] iomap: write iomap validity checks
Message-ID: <Y3NRvhVq+yS75s5B@infradead.org>
References: <20221115013043.360610-1-david@fromorbit.com>
 <20221115013043.360610-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115013043.360610-8-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I'm still not a an of the indirect call, but we can revisit
this later if needed:

Reviewed-by: Christoph Hellwig <hch@lst.de>
