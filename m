Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DFBC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  4 May 2022 14:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351124AbiEDOQy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 May 2022 10:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239972AbiEDOQy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 May 2022 10:16:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF6542490;
        Wed,  4 May 2022 07:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=aAL0yYyasD8fk5RN2kd7/lnVtW
        1kMTXgfCiVf1XXEhhkKMCQbLp1k4pZj7bNaJ5BZcmLKyQpNOxFzO3xETHITdzZrOz+dteSfrvMMFt
        FqZwLh6XKAVZ1NfLnDh2xGP1cByJLFWXL2yJUjzvPpku9tIzYyQgYMyTl70VgjxAyrP6OpTs9W+lt
        +OC+CFX7pc6CnUz3968IDwT43kZUHAZkur9Z5jCHkdW+5GuueZQfGPHswbp6boscI5hk4E28g972E
        m7T9I4tV3lDIVZE6Px35guehhQjC9AV9qxy+08QB1d8RTvMGpW7aDXLcHIxxVzIWYw+KgmEIgg/je
        CHHHJbQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nmFkg-00BEFK-Gf; Wed, 04 May 2022 14:13:14 +0000
Date:   Wed, 4 May 2022 07:13:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: iomap_write_end cleanup
Message-ID: <YnKJ+qcSrmqaB/Vp@infradead.org>
References: <20220503213727.3273873-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503213727.3273873-1-agruenba@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
