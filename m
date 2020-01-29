Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D69C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 21:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 087DD20702
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 21:32:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qZ//hON5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgA2VcT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 16:32:19 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:37992 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgA2VcT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 16:32:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BjNd1MbjE1Uy5ZTImk+LBbXAv0B01vlc+GgWdD3H2xs=; b=qZ//hON5EbsdVN7ZQ5bBfMPuK
        bpA+n1XKmQgthr099SJXv5mtvtjL1QqpM2cueExOVlj0ZKvqsInyIpUFn5QgfJEe61LpuGRqMkGGP
        mhaR/jiPK4vMTwnfu73ACvhbfcgkFzyjS3ogZsVAlceee6enmXuh13s1U7RwTIJB9SGfqqoZU+zmI
        aIqZKrhF0ZnWqJAlXeiyb0r15Ct4/L4YMXzURVYJrBqXaTIEXlQKpn+AMHAf9hFBjoWu3g5Uajq1T
        +RiKb5ctV/kzb9nI0axDwbnKpMUJGCh67I0umsItp9pjevvgWlmwvMxhSly8di+VsTEHA4zdDeMXy
        yOnFnZzPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwuwd-0004Lw-18; Wed, 29 Jan 2020 21:32:19 +0000
Date:   Wed, 29 Jan 2020 13:32:19 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V3] xfsprogs: do not redeclare globals provided by
 libraries
Message-ID: <20200129213219.GA16593@infradead.org>
References: <0892b951-ac99-9f84-9c65-421798daa547@sandeen.net>
 <a2b9920e-8f65-31d8-8809-a862213117df@sandeen.net>
 <db48723d-10dd-a86d-b623-58befde5961e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db48723d-10dd-a86d-b623-58befde5961e@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 01:47:49PM -0600, Eric Sandeen wrote:
> V3: ditto, plus enforce -fno-common so older gcc users will play
>     by the same rules as gcc 10

I don't mind adding -fno-common, but it has aboslutely nothing to do
with removing pointless duplicate variable defintions.

I'd say apply v2 and make this a separate patch.

> @@ -13,7 +13,7 @@ OPTIMIZER = @opt_build@
>  MALLOCLIB = @malloc_lib@
>  LOADERFLAGS = @LDFLAGS@
>  LTLDFLAGS = @LDFLAGS@
> -CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64
> +CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64 -fno-common

Are there any compilers not supporting -fno-common?  (And do we care?)
