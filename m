Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B0A5ECE588
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 08:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56C812168B
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 08:26:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lJ1ruqwM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfJPI0W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 04:26:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45376 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfJPI0V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 04:26:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lJ1ruqwMQLNEPSkOOm1m97x7J
        8XMu+HqTnaL1vpo9PzupQ0JvkY+6ePn7xSeS9jm43lW3EAax1X4qV98EHfVY1z+cb0I6Fu3wlTP7z
        vzSuGHHBnwEXhsvAAtEoha1ANiex7k7KjF4I6ZjYpdFKtZYhYbFVB6PnZqGho7x67zOQAEwmZl4Q6
        Di2fDoPuqNc0UV7KhbOAWBvmcXNLHW7g8Nq5sBTEbqG87Kh3U1sjoVRljfN+xISm0pxwOsd4hXeqR
        xHH1Py+LLBlG1Rrr6qX46gCAPg7UMNEa8WWVFbpICyr7ahbcFo3FxojYlUp2SUITUGrcjkVQH8toe
        Kf9tTPJ7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKedQ-0001U2-7G; Wed, 16 Oct 2019 08:26:20 +0000
Date:   Wed, 16 Oct 2019 01:26:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v6 02/12] xfs: remove very old mount option
Message-ID: <20191016082620.GA29140@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118645272.9678.5887961059070306546.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157118645272.9678.5887961059070306546.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
