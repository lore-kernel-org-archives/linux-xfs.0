Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F9CC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 08:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EA522084F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 08:25:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZUDmnRGe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbfKLIZZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 03:25:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46488 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbfKLIZY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 03:25:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qnBTuwiOoDriKk7CHvP5ywFV9PzUeMSGf1KMsfqZUn0=; b=ZUDmnRGeJ8dy6sJEU6A2XTI+B
        TRzJwOn+tl36NhP+3l29jqQutuqn2ABmvZdJkyPg6uUx2JCdLFYJe0ykX6tJhHZyToExdbxu8eBwg
        C8sp5qC1il0CDUVd16/kW/qiUFWm4K/uyRivlSn/yZ8I6EgLg0H03k1xXn7AAw0utziZALTiCFBnH
        X5rGJh2Kpa0AF0p8W4joHamch7BzVVX/TyyXNk40PJ7bbIR/S41CXtywASu0LWwBKoNHECMhvdOYC
        jE3crqB/72QIrpCpfrcpKAjprvNAZcX0ftFRLiRdn+0pfeNQ9JYA9GfjAq2yqlMZNguD02sU/VU4d
        0Gt7cUXCw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iURUK-0006FT-1W; Tue, 12 Nov 2019 08:25:24 +0000
Date:   Tue, 12 Nov 2019 00:25:24 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC][PATCH] xfs: extended timestamp range
Message-ID: <20191112082524.GA18779@infradead.org>
References: <20191111213630.14680-1-amir73il@gmail.com>
 <20191111223508.GS6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111223508.GS6219@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 11, 2019 at 02:35:08PM -0800, Darrick J. Wong wrote:
> Also, please change struct xfs_inode.i_crtime to a timespec64 to match
> the other three timestamps in struct inode...

Or you could just merge my outstanding patch to do just that..
