Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDACCC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 08:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiEXINz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 04:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiEXINx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 04:13:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E8977F02
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 01:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CZy3A3D5QLokuUfruzrx8Ua+/C
        NhHhypX8pJ77WFNc2gKwMcPENl+C/l1Ni/jL+edGYZI9bOIrfqpYD67HPlG1arZ8rg6lAuS6YJuY2
        stj1POhM3KN0RWODIkNARz44cmAVCDgk6YbBmGE/NgEHVHDQ+I/VdfcK97avLhgP8nVqgOp8M39Oh
        xp83bJJa356kfdB5E9E0kBcvJb159C7pBNZPvGh7oGQGnFL5Ny3btX8OeqKX4tCo3IrQ6A3qZzvbL
        MJIk14p08FpDXSZ2fhCNMKhAWxCLCTZ/LQ1MSRXbQ4MpuZCHMp/9Xt1AC0hPUt9Z4Vspb5UtIXkl+
        3OF29bwg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntPfr-007DNA-FM; Tue, 24 May 2022 08:13:51 +0000
Date:   Tue, 24 May 2022 01:13:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: avoid unnecessary runtime sibling pointer
 endian conversions
Message-ID: <YoyTv1e+lO+xd8vq@infradead.org>
References: <20220524022158.1849458-1-david@fromorbit.com>
 <20220524022158.1849458-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524022158.1849458-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
