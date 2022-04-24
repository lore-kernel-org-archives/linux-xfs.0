Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83714C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Apr 2022 05:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbiDXFsL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Apr 2022 01:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiDXFsK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 01:48:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FC8F71
        for <linux-xfs@vger.kernel.org>; Sat, 23 Apr 2022 22:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=NP2XJlrMQXUTYAACQeMa9VZnY8
        Fsk3fpuJsnD2v8xebQytJMgN1ihzn5UIVvhOp5W4V4S3qpL+m4Iz7FDUIrTA90ysXEeEFrSiLBu3L
        f2ePdWuofPsn0NVEuIlIaiUjNeRQhZbrZNuFYZQaEcstb7mFzOPQZE7Nw3bhWB4RvsQ+tuMgB2v5L
        kmRe8R4EurQs067tC1nGoG+iHXwgzofRYtjjsccOtQXaApp87G1QNh/9xu9jRwkEBjuDlotFpjMWh
        e9CahR5cg4kK2RX9b4TrrJ/OeJVPMAler7c0XMEDqnpVFWeLdbWFq7BW98kG1k11ue84Od/twH++i
        vnx0swgA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1niV3S-005s17-Rv; Sun, 24 Apr 2022 05:45:06 +0000
Date:   Sat, 23 Apr 2022 22:45:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: simplify xfs_rmap_lookup_le call sites
Message-ID: <YmTj4kP6jjYFqHAB@infradead.org>
References: <164997683918.383709.10179435130868945685.stgit@magnolia>
 <164997685075.383709.9161047695879739444.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164997685075.383709.9161047695879739444.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
