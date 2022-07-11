Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FA4C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 05:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiGKFWi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 01:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGKFWh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 01:22:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE7C1903E
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 22:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QHo0FAEkII70amuT2sZbW2Madk
        HAAaZBK0rFckD+mfCDK+Oyz1V/UL+oKnJngpgsOLo1LoaXJ5Kf7eQszZsu3vYGqTQv09VE1kNiYiU
        Jg0IgmvxwD3EsZIF5bPYoshJVYgcmO6c2IvJ0F+XcIALAoUDncuFAK/BXLmChyUddnc2bbWRKBqk+
        kBG92UHOV6uY+OxSNRnxEBtEkCq/syYJ8e7eepDUcnkrIKXiKj2l9QR0IqPOprLT/Egu1f6yzUzGo
        B1m+an6/hEEiTtjzXrjCy+hYCLakYVunEDDL5mR7CE4bh8gZpObTs3xIcpoBpcrme0gzPlHfuDoT1
        Zg/h0PuQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAlsR-00G6HJ-Vx; Mon, 11 Jul 2022 05:22:35 +0000
Date:   Sun, 10 Jul 2022 22:22:35 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: add log item precommit operation
Message-ID: <Ysuzm5HPaPNMGfkG@infradead.org>
References: <20220707234345.1097095-1-david@fromorbit.com>
 <20220707234345.1097095-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707234345.1097095-9-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
