Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AA7C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Apr 2022 05:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238289AbiDXFcE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Apr 2022 01:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiDXFcD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 01:32:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E372506DF
        for <linux-xfs@vger.kernel.org>; Sat, 23 Apr 2022 22:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GisCWrbldxt7GNhnM8cwBCE/TT
        m/E3FXLbYhW7yGywdx9sr55UJy8Fc4SMYmz/4bdeGqNPXQRghBv+mzMZp+lyB8ZsUsQzxW1FKzB4h
        iIWezQMiClr0tw3EgrYV2Lro1B+wW8lQ+RhtRkXbd63HeqYEXFLv1p/0L9JnIcWUbKFQbLgXm9AUq
        sP8dYBxfq7tZzzsLYT0ynmEdskZIHIt9y8jGN2QrpMv2GSKaql0Z8orYzBxU0r8ub64UJ3kdOFUZN
        TPH95dSJdCbiArJlSpFqP2Ec1TwNJDtJtVuJe6IRBxZdYRylfwMj0D1oLGsoq2XxaUWqZkCQe5C4K
        o2UugXAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1niUnv-005q8a-5W; Sun, 24 Apr 2022 05:29:03 +0000
Date:   Sat, 23 Apr 2022 22:29:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/5] xfs_quota: separate get_dquot() and dump_file()
Message-ID: <YmTgH8TM7hCA/qRE@infradead.org>
References: <20220420144507.269754-1-aalbersh@redhat.com>
 <20220420144507.269754-3-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420144507.269754-3-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
