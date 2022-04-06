Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD964C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 18:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbiDFSGE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 14:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240026AbiDFSF4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 14:05:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF0D1C7E89
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 09:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=FABA+EUX9JU+TgmOGBViWh7A+l
        CXoswLKKY3KLuPmZcgXgesgQA3quGRqFG7f10f2u0eYnBoosf/uUsvX9qpym1z2T4mgIR0DJjVMP4
        PXTjcFYrWNtwMw4NIympneS3913szUsip/6Ap8qvbQMPYlcPe07DpeCad/hQLN8unO78UHXY5h0NR
        RmqezSgIWUBLR/9q6Vot3dz1CCMhAm3jiaPykY63X4rSDBIKEAHUoECK53kx7e0Ghrme1WCPXm+Mu
        kkF4gFGrqrOu8vPA52JQj0G2IEEfU35v17146TgcZ+DWB+RNaK25qWWw2T/04x5WfhwSurfVry9Sg
        f8pKuivg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nc8hj-007ELw-Vz; Wed, 06 Apr 2022 16:40:24 +0000
Date:   Wed, 6 Apr 2022 09:40:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH 3/6] xfs: remove infinite loop when reserving free block
 pool
Message-ID: <Yk3Cd0m8eMmCJU5r@infradead.org>
References: <164840029642.54920.17464512987764939427.stgit@magnolia>
 <164840031362.54920.15815650183086189788.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164840031362.54920.15815650183086189788.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
