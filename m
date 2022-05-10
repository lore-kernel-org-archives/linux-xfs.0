Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E08C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 09:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbiEJJnB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 05:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237970AbiEJJnA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 05:43:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8D93123E
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 02:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UZTYRtDKNI/XE68NR76XN4CGvW
        2ZfOkfboVdRR6mNMwJcTOv4RwdtlfOYuybZUm4HceDC40aN4RuytAmVuuB2e/uNWPv+DDsPxZ79aP
        EhsuNaGQDdwAU80OTCzsj5AVDHRHKXmTN0dkqLqBpxt0NEECfKGPn99+dtpeEa1mQl9tF4X8i0i3a
        5aObCLmEIAXLWWCk1HJ96H3qe4/lQxSj9GcBedrXx17OiT0LtN4/zvLi29XrUYvl6JITo184jva3j
        jpOtFm0rpIrG/9VKh6RnS9+pQFe4NQ/2awZsE+vGtmL/CK+dGNUQIVuDY798gZrYQcbFxNOzEncxV
        wDodf+mw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noMKd-000tGj-59; Tue, 10 May 2022 09:39:03 +0000
Date:   Tue, 10 May 2022 02:39:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: warn about suspicious finobt trees when
 metadumping
Message-ID: <YnoytzHC4sWu4Buy@infradead.org>
References: <165176665416.246985.13192803422215905607.stgit@magnolia>
 <165176665975.246985.16711050246120025448.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176665975.246985.16711050246120025448.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
