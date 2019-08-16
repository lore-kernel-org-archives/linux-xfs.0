Return-Path: <SRS0=CZ9Z=WM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 663CAC3A59D
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 06:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DB6C2133F
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Aug 2019 06:52:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="owb7svbS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbfHPGwa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 02:52:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60582 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfHPGwa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Aug 2019 02:52:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EdyyKKMIutVc3nOpSSkE+3twjEQDT2MXZfWI9z78Zh0=; b=owb7svbSNpMi0iO7jrBG7+kxb
        2hf2B2xIFqTO6nBL6Wdxsbkdv4IA1S0Xixg6BAU7O1gL75v9dWlDWCo7cKH/sdnU8j+j6JqTUVgtD
        jyIO43Z13qrpeC9/ojBe6x5HCTN80ehlXampGutkdanViKGWDCbibZ9HkZkkaYDnSvWM/1sVDtIWr
        YMt5AzFlQiNVQqFRPGf81KxTngwQUMF+OSnssBnrlrzje8gXma6qs4yM6r5AcLjloBZhEslzlgJdx
        B8KUIL/bgEv6BP9QD9of3mn5PJ4Uu1FEw694Y78wWspl/HEHE6ztoEjqiBI3Vzvj9Ml8tICplQ4/H
        10p5PADqw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hyW69-0007rP-F5; Fri, 16 Aug 2019 06:52:29 +0000
Date:   Thu, 15 Aug 2019 23:52:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     hch@infradead.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Damien.LeMoal@wdc.com,
        agruenba@redhat.com
Subject: Re: [PATCH v4 0/6] iomap: lift the xfs writepage code into iomap
Message-ID: <20190816065229.GA28744@infradead.org>
References: <156444945993.2682261.3926017251626679029.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156444945993.2682261.3926017251626679029.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Darrick,

are you going to queue this up?
