Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD745C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiF2HoN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiF2HoI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:44:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B8F37AAF
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 00:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UftAn8aJXKBijghpIEpml983/O
        RWR6vqzSpFzHgf+I4w4VLUoN5NPA/nInjWkdL2SF+svNcEILkEHJS9UGGn1IvHKGPDC+Boe/7kpH+
        nBsmqUJWi/oQn5AZ209+wsDwfK0qlROFZVKmiAjaMYzuARWS55KdVvPmS83pCj6mJbu0wzYfpIyn7
        s7z5/yRekUGxwodizhBaXMbHJp++KRxta6sGr4tKfqkDHXYgj/Xa725SjBH6PeUl1Q5DjBVUH4SWr
        ItM+/hewuy1uQkpS1wmClMUU2+TpvwR4UC1aLrsg29CQr2M+T3/+06xhJzR0rks0G/HuDpeOqv/z9
        uvW7T2rg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6SMo-00AAvT-U4; Wed, 29 Jun 2022 07:44:06 +0000
Date:   Wed, 29 Jun 2022 00:44:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs_copy: don't use cached buffer reads until after
 libxfs_mount
Message-ID: <YrwCxrZRYF3eTyku@infradead.org>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
 <165644936019.1089996.1994101193208059510.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644936019.1089996.1994101193208059510.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
