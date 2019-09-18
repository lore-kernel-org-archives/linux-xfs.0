Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F8BFC4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 17:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7164D21907
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 17:08:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eaLgnG8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732069AbfIRRIT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 13:08:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727243AbfIRRIT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 13:08:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FNodd08ZTeShZt9JTA3nS0OnQ7ZUhpy2Ydi1z/WWNGQ=; b=eaLgnG8u+2H64nWn7zfKTCUKx
        o0QvdHYPu03sqkToveC/fwGwjcJtEfeQwCOtToAXef15/DinbNIbTBYhTbM13taKu83N+WZhwDGRG
        V6p1AkkZ7VkzkL0R08UZxeoxxS8185VJ0MKcx5mK2MtGvpmNPKLI5nKYfGBYYnj+Cxo3h3y3sOQ2C
        7xb7V/rLmE03Ym4/0zf8zV2Bm+ZIzmqCD6WPFjFyiwLMcjv7WF3EDv8nBOzy26BfVSh78BKE+Vfks
        ljQKZMFlOU9EY6tiJk8N59IpNlAs6LSRcS4JnxWXQC/3+EtmILVSlP3kC97wQvwcTTFl07zDJJjZ8
        9vaX1/NOg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iAdRD-0005G1-BW; Wed, 18 Sep 2019 17:08:19 +0000
Date:   Wed, 18 Sep 2019 10:08:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: convert inode to extent format after extent merge
 due to shift
Message-ID: <20190918170819.GA19633@infradead.org>
References: <20190918145538.30376-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918145538.30376-1-bfoster@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This looks sensible:

Reviewed-by: Christoph Hellwig <hch@lst.de>

For a while I've been wondering if we can find some good way to take
care of conversion to btree or extent format automatically without all
that boilerplate code, but I haven't come up with a good idea yet.
