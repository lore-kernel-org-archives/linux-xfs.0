Return-Path: <SRS0=M45Y=YE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AB2C47404
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 13:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 544862089F
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Oct 2019 13:06:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RmZkfXzi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfJKNG4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 09:06:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33306 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbfJKNG4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 09:06:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VJPwvfHIvtLJZWfIUInsoNX3aOxAk5L6tKcqHih/7qA=; b=RmZkfXzi70T8NYuZbanez7ZDm
        D5FBCN1pONmF95o0Wj2wl9GpJTSNM6gXdayQLQum+4oAybwNarypjOhDvL2zSJ4JloP1hcGznA4+e
        DY8Ln7z8cF0t0QIGz5dwCRm8ByWyOLhBtEzwnZP8R1/rEUm3soUndCsPfzIdl7CsTwJTjJthCB3Ea
        OGULnxrngNdSkgkBuIQNJCi+3PBf9J+OeI46RYtHRNKD07wgv2TeaIJDW7oYxDQT++Uq5Fb1VskGQ
        OzW4u/WAef1LWxsjDFeZVK5VwqyuifWMARxT1CNb3EpLK9IPK57FUu+3LbKzrb6liJBrWZfZYDj3R
        0AnX65mTw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIud1-0000RS-HP; Fri, 11 Oct 2019 13:06:43 +0000
Date:   Fri, 11 Oct 2019 06:06:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH] fstests: remove duplicated renameat2 system call number
 for i386
Message-ID: <20191011130643.GB27614@infradead.org>
References: <6d0c1a12-b4b2-cb35-1150-001ffa83a5db@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d0c1a12-b4b2-cb35-1150-001ffa83a5db@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 11, 2019 at 03:03:24PM +0800, kaixuxia wrote:
> Remove duplicated renameat2 system call number for i386.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
