Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32C0C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 07:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358783AbiFPHkA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 03:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359569AbiFPHjs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 03:39:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF81E5D5CC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 00:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vP295ZuB1T7HbS8BSTxvskDmXj
        a7YmYTjp88bVDiOxghDeVNHhTON11UXfDuDdWKZadcRd1EVWuNkqzK7blkrns8Nj6zIj86caGQEGQ
        cCrmfBmnkqpSdmOwLyQAJpqG6pXElinsMXHGNL+yQhlmH/Uc96eM7gA6Moc5o94Y86/HKpzmZYpJP
        ObIQan9sq89SpH/QBmx2nDjfxhmzbNsnuGJOfQmp3pYgyIUMvuovLvGpqWyi7g+MtlnuSWC8COdV6
        NKVeQJne3NwZhW2i418NP2irysLmmyUORJUWzFAti2kmUJKLbrTfzbCo76vXuTaNfgg/PPhFDzInJ
        4rZuumbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1k6M-0016Ru-Ap; Thu, 16 Jun 2022 07:39:38 +0000
Date:   Thu, 16 Jun 2022 00:39:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/50] xfs: pass perag to xfs_read_agi
Message-ID: <YqreOrDbkmNyf/27@infradead.org>
References: <20220611012659.3418072-1-david@fromorbit.com>
 <20220611012659.3418072-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611012659.3418072-7-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
