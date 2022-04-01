Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D663EC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Apr 2022 12:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbiDAMEI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 08:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345706AbiDAMEI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Apr 2022 08:04:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364A226A959
        for <linux-xfs@vger.kernel.org>; Fri,  1 Apr 2022 05:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=O8xwdFOZ8/trrt4SpYwmNo7qdS
        Xvt3bA4hqH2sLDXv15P3ERPaE9Zp1gVqQu5/pkdGJPA8t842AV2tIXU/y1X4xN0Scpp0P3ibUcg0/
        VSGzi3K6DGDAfVXgUsXRyXuFw91X+cALrGT8IzURw21KVNm0187X8LYgVANCrTnunRwUSIFvWum3Y
        VcZf6UYIrJyP7mMusi7t/dpvgSLjy8ro7Q1HDS0caE7/SiPpRnqXD4Sgx0QI7572cWzo9BVT16qOh
        cyODjZkJsBLRaPxI29EtDbWSmDh7JF5cgXV0hhJ80OaNrCFg85q72sm6zSlH1PsHTm4BQkYvBscB1
        CZyI3OqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1naFys-005TW9-Rm; Fri, 01 Apr 2022 12:02:18 +0000
Date:   Fri, 1 Apr 2022 05:02:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: xfs_do_force_shutdown needs to block racing
 shutdowns
Message-ID: <YkbpykaSN7nI3Iev@infradead.org>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330011048.1311625-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
