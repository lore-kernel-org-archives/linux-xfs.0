Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D65C77B75
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 12:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjEQM7w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 08:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjEQM7w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 08:59:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EF65253
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 05:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QyspIeScz/FEJnCPzxbF5DOWaE
        eGcZxKHyt/nldh2xI29eIlUYQYQtrzNJBtJzfgfErV9UjDYeBj0n5N7VnNI5W8JnUe810s9L75qiR
        s0zkBwR2Lh7RUFtMp8pt/iLDp6At9RcEbbpuXQji6ev4bAfg46gbYzg6YoUS7AEpKZ43d6KWWM4XG
        prjVa9LwVcautFyAi3P5FGxMGGxhbgofwtoohnHJLcW0uFZp0o2RnFwnLpPrFXpOYykAWaDSE4BBe
        tImnYrbnx8A2m1oHTI5Kyz/T3Kngvt57qa3rHDHhaxRrtdcBX+HvpaVVldBpQYG4nJUTYohVqT1CX
        9ZbEpdkg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pzGkx-009seH-0N;
        Wed, 17 May 2023 12:59:51 +0000
Date:   Wed, 17 May 2023 05:59:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: restore allocation trylock iteration
Message-ID: <ZGTPx6oIVA2tIuoW@infradead.org>
References: <20230517000449.3997582-1-david@fromorbit.com>
 <20230517000449.3997582-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517000449.3997582-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
