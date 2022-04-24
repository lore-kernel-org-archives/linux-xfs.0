Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887DBC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Apr 2022 05:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238286AbiDXFqn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Apr 2022 01:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiDXFqm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 01:46:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57B219C741
        for <linux-xfs@vger.kernel.org>; Sat, 23 Apr 2022 22:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rrjOwByFeNL96zazDK9qrUqO0x
        /yup0npneuVQ1PX9DZOngz79199HfnTIelcX1rHChcX58uJ5yYGDNP/S3F8UJ0t53WtK0LiBM9B1A
        Uf9vw3OQ70H4/FhSK3I+bNpiYMzbV8mEs+vZk/LJFF+f7vs7SJU9qJUpzwCEP+8uexPMBNK9k5kfu
        bkv2+2jy/FdmZ1BRL0rKKEtAp12LmoWlbzJpHGW12YmyI3nKJE9XuXhhZXWnnSwp728nLiFs7xCdq
        YaMBpCdQzyf5lAUYPeuuheGnhhWPy52Vd7z9v4fjyfCGqsQl8zdVeMC3mmhN1cb7NwFEQnGonGQoT
        fxZPwzEw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1niV26-005rt9-6d; Sun, 24 Apr 2022 05:43:42 +0000
Date:   Sat, 23 Apr 2022 22:43:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/4] mkfs: improve log extent validation
Message-ID: <YmTjjloutbTp2Y3b@infradead.org>
References: <164996213753.226891.14458233911347178679.stgit@magnolia>
 <20220415235735.GD17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415235735.GD17025@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
