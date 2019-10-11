Return-Path: <SRS0=M45Y=YE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F446ECE58C
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 07:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 091C321D7D
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 07:52:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="udT1k3fJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfJKHwp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 03:52:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59176 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfJKHwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 03:52:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2c+lvaDRERgLwzBnu1deq8RyaVIX+YKybOEDUjAgLcU=; b=udT1k3fJTemW3nQaaGJcEaG9Z
        /alkifNcNKwcLMffxkW7HJDCsEhQxJA39eh4J/qAYuV52Uxo46LGi00oj3cc5BC4eVYYBLFY79axk
        gzSijCIHpNPCjZiBb9PmTQeaXGbgtWVlddAAQZizyS3zdETRNujHuOVDwQg/H8xU8+Wu3v58SrM4i
        9+5JDJdRu9WrU5I7q+T8RPnzcmcQGZLQQgxZi2BNPmh52PYxSv6RZXunsGFeSsveBiCAjdNx5CcWL
        iUO/9C44ThVrmZIQ+9HgFsPoHfnhGCDXl6i4wWRFW5XIRlmOB4wEcloRyeiyH+/5orc/6xq5laC1V
        xZSkEPx2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIpjA-0000UI-3v; Fri, 11 Oct 2019 07:52:44 +0000
Date:   Fri, 11 Oct 2019 00:52:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 4/4] populate: punch files after writing to fragment
 free space properly
Message-ID: <20191011075244.GB26033@infradead.org>
References: <157049658503.2397321.13914737091290093511.stgit@magnolia>
 <157049660991.2397321.6295105033631507023.stgit@magnolia>
 <20191009181848.GG13097@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009181848.GG13097@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thanks, this looks much better:

Reviewed-by: Christoph Hellwig <hch@lst.de>
