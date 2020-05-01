Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2907CC4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04C90214D8
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:07:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Af1qpeyL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgEAIHb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 04:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgEAIHb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:07:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C685C035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dHX5uiOrHO+0+bh4R92KwcwNExxO9Cvb8EBNc+0PCZk=; b=Af1qpeyLxf1n9iTxOh2bgPZArC
        /fq6trHpjAMpuZpBwfaCb5Dh6U9zA2/SQlLtFSSn//090S3gSyaw84WUQhSwx3lBjOI3GX3Mnb0Vs
        aqUNo87UKuPJFN/WCqS/mMOql9kwYZQQksdXaEWqnX3KDYzthXHUc2Lf6o6zXl2+M3Amyn/Wx3chI
        STaTevOYbdZOs+e+GoNM5pNpsMIm4ugLkGGO90fIi6Gm2TgdLmNOcE73swH7fHVOuNVUeITevTEge
        8mQus2doHotfkY89scc7IFSoWPImFtvb2S+fxM1fua5Hv70Nkn/TNe480zI0nJA4116XbNNhpOf0X
        VLOR1wyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQhm-0007ja-Th; Fri, 01 May 2020 08:07:30 +0000
Date:   Fri, 1 May 2020 01:07:30 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_io: copy_range can take up to 8 arguments
Message-ID: <20200501080730.GB17731@infradead.org>
References: <08c6de7b-4caf-1162-29e5-94d8dfe959d6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08c6de7b-4caf-1162-29e5-94d8dfe959d6@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 04:41:55PM -0500, Eric Sandeen wrote:
> If we use the "-f N" variant for the source file specification, we will
> have up to 8 total arguments.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
