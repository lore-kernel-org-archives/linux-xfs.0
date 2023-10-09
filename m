Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAEBAE95A96
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 10:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345716AbjJIKf1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 06:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345759AbjJIKf1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 06:35:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B024499
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 03:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Q5b7T4iP2by/NY3CNoy+6XAPoe
        IHwBiixEwC5hsBReT88YNbmqz3cgZPtUoLmcnTLKIWkI49zgexr0jKPel6vLoaY75ncX5e+my4Kje
        n30QPZ/smkRNDR6nDRR2zUhvNr8/cLbk/BSNYj1ikTmxFX2S29rVa2xjDvGlrjxM6SesXPcWa5IqI
        IPscoo9iIg124BCK7jQ+b7lw40R7uLkIrN6QaJX+y6oePyphdGd4OT7CsxopmCB6LRLd3sQBwLs8y
        GnZ+dvQ3XS+Y8GAAwk0FyHyscgz9C+H+mlQscDbhulC1915Xv2NTW001lEruQEX1uu8dnIdEhz7eO
        sLHdQh2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qpnbh-00AEwx-1p;
        Mon, 09 Oct 2023 10:35:25 +0000
Date:   Mon, 9 Oct 2023 03:35:25 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        kernel-team@fb.com, Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH v2 3/6] xfs: return maximum free size from
 xfs_rtany_summary()
Message-ID: <ZSPXbS7e4plHUY1X@infradead.org>
References: <cover.1693950248.git.osandov@osandov.com>
 <2ccd484a974c2cb1f310555c588029462fee769d.1693950248.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ccd484a974c2cb1f310555c588029462fee769d.1693950248.git.osandov@osandov.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
