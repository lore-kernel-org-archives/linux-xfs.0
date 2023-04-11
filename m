Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6DDC7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 04:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjDKE7E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 00:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjDKE7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 00:59:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7711BF0
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 21:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qUFeBXANl1FjL6NZNB3KCiRX8J
        razlxeYwnHA8NwZlkfzDzzdq22WRupIM5ar4fFPrUUm4Cna80x0ggG053sG7+llrB4kxnCeWPMe3k
        Qlrt4XfxHsuzpcrDHTw9SqpbxrOGky3DTEqm4iwFzb3HoQwK8Z6Tz6xdrbYDnVOWnjEZ1yEl0Ks1h
        D6EGco3jA8hYrim9zBXP1Iq1lUM0tg1Sb4vchuoBNd8WfiumiD/vB8WVppSm5YxB367u5+RpW3P1S
        zHRmFEzWxD3sBmV9LBdVvfNCB9V5+bGuCS8H/dEbOWN0R5y2NSI+YBEndE0RRRdeodZEAIjk0zvhb
        gUYVXnFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pm65s-00GQNM-1q;
        Tue, 11 Apr 2023 04:59:00 +0000
Date:   Mon, 10 Apr 2023 21:59:00 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 5/6] mkfs.xfs.8: warn about the version=ci feature
Message-ID: <ZDTpFNZoSV7pF4vH@infradead.org>
References: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
 <168073980144.1656666.8831148327830741767.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168073980144.1656666.8831148327830741767.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
