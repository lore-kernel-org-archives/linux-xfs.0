Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C37C4167D
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 08:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbjKGIkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 03:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbjKGIki (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 03:40:38 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C52EBD
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 00:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iN4CT6nTHtiernCmVFdJfbRF2g
        ZPbiIurc6XjFfMmwk6w4epwltgrSx/53woyVWNjwUHMOPugNAqTlRHF4S3ewagJRvA0z1CQB0YCgu
        SyQYxJvllzc/QSjaONbvcyQHc2Ph7aSjAqWwF1W0NoCviBqslfvnoEYI649fP4FLpmFOHLsiQ+d93
        w3AqBndhOYPaKQC1K2uLGPiJCbC2r0naWUkvZfR7CYzjr+kehAK+gd2iJvXc++7UCazqF83saXU8O
        751yf7vw2QL3tqzNuR3R5xZgS3BLCNFAd4KYEOk3QIu4abfC47RUzRxBr3oaqalk1pcGTcd0jwoTc
        AM9I4gDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0HdU-000qCg-13;
        Tue, 07 Nov 2023 08:40:36 +0000
Date:   Tue, 7 Nov 2023 00:40:36 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_scrub_all: survive systemd restarts when waiting
 for services
Message-ID: <ZUn4BLV5DtzT4A7c@infradead.org>
References: <168506074176.3745941.5054006111815853213.stgit@frogsfrogsfrogs>
 <168506074202.3745941.14916572151968287634.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506074202.3745941.14916572151968287634.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
