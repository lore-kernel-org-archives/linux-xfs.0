Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DE3C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 09:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239023AbiEJJmM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 05:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238996AbiEJJmG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 05:42:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1875336B46
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 02:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uOO9ZZJIUm6/AGQoFeNTI8/8eq
        ST6J0Z/4di7uL2o4zvloAM85voxNXMi1gzxVp7fkrKR4pGrtZwvbi2zOq85toWFwKL12lO5jGmoal
        40ou0Xk5evHdlT/R1yjyOZOxSRifPlnzJRxoAtjO/ozvpLsXuzoFCzUTwhphBLVIfe1j3Ccpd103F
        eUgPaly4bRCbQES0tMIM7Cs0F+7pNB7ddqZo+nsnGxX31Ey4nK+qTideUeISGkCUNqlDUd/811kgC
        Mg9DU13jOoIhrmbVA4HLRox5zxGHD6GM+N30C4savM0/WUzFy8LONf2xrATHl97HiIJukyIKWioT4
        +VqnjVbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noMJk-000so9-OD; Tue, 10 May 2022 09:38:08 +0000
Date:   Tue, 10 May 2022 02:38:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_scrub: move to mallinfo2 when available
Message-ID: <YnoygM3189Bteg41@infradead.org>
References: <165176663972.246897.5479033385952013770.stgit@magnolia>
 <165176664529.246897.6962083531265042879.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176664529.246897.6962083531265042879.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
