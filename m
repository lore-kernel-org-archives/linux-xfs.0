Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6210C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 07:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358796AbiFPHkp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 03:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiFPHkp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 03:40:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEA55675E
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 00:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XnTQzAq4urk/oViZEaJ3v3y/Ku
        qubZqCH3pa2RK2LBmwYCwUmxfp15hbXxuym0fNvZiKsCBGlQ1flRkGeTD5btDUOzk1DIqJCqCEpt2
        okwHe5TMxwIUYBZ06UK/LNMZFDFbDxkTUhrmPAISsd16fMQIDQ8/9MSPQvqiTH4Vs1piJF6mhIdgz
        KGd6V0BrSSOAqLI3wKIX1tG517kXPe9AcElO3Gwv8o1aWVozY4ToRy/9fuJePfYRbKZv82LwUr7BR
        lNTMxd+YaWpAIJ31RUSoEewYSVX9yV5bYrUveITfJmOg1ING40VnfYBe+9Dmqx4Z2sWTHXu7kki57
        s1w7qH9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1k7Q-0016pf-53; Thu, 16 Jun 2022 07:40:44 +0000
Date:   Thu, 16 Jun 2022 00:40:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/50] xfs: pass perag to xfs_alloc_put_freelist
Message-ID: <YqrefAja0q66lUD4@infradead.org>
References: <20220611012659.3418072-1-david@fromorbit.com>
 <20220611012659.3418072-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611012659.3418072-10-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
