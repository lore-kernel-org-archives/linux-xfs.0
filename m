Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8147AC43331
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 13:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D9DA2078A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 13:10:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r01IY9uh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbgCYNKH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 09:10:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51490 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgCYNKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 09:10:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=r01IY9uhgkvZpFBzY/0KEdM3rF
        KJ707UPEsmadtlTNvr8yL6U/ErEs0rDpMfxomDcUcEEesYgYVTJMr4Gs9J9anD0Ygv+NhlOfXrsrF
        p0VR8dKilb7hkEjnRkB/+iz31GStRsBTeYD3ple3V+2RAPkrgcUIfejBhHPP79IbYCs+M778fxQLn
        LhfjI7yjO4jCXQ+WGbu/Dl1bS5/OGaMy8zhx0z6Q9ZobNh3lZa88HhkNatPkHK0Ry8Fj5j6GCUQiX
        sw/+yGKIRWgz1XsV8g2xJijd8RQhFIYEu/kEadklzdtV++UDkPp9MAwRJBfl2Oya2DQlj/iMutpWP
        pb9HC/4Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jH5nK-0005SV-L1; Wed, 25 Mar 2020 13:10:06 +0000
Date:   Wed, 25 Mar 2020 06:10:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: shutdown on failure to add page to log bio
Message-ID: <20200325131006.GA17437@infradead.org>
References: <20200325124032.14680-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325124032.14680-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
