Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF6AC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 09:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2FBF20721
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 09:37:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xx0gvJgV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgEUJhQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 05:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728719AbgEUJhQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 05:37:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51288C061A0E
        for <linux-xfs@vger.kernel.org>; Thu, 21 May 2020 02:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Xx0gvJgVprBIk5cIM+Wjb2hZyA
        xZ3TIQ3K+/r89JAJADk+zPEVfaosNSh8Cssv++PCwhm9YjSjDRPxUIsmnNi669cHt1zSZfhnQMOhM
        ZvbW3D5YgGRH846FNS2A3qkjuX7CPYLWjqjT59Q7KZ1l79/P6yC+ZuXP3/MPF6jPzZo52/xqJmT5C
        BOPHkaZNU8ylUo1bzGRGD+gqRuogel8rW4JAkQ8wOsrW+Eszvu8oaR5twbtm+8fpGr0ToYSoyZMh3
        6nhcMYDS55x8lNdOMlZZei3FR4izvPyqJy4gvevd3cneqmz7Xik6hioeGXSZfqaHeHfzy2U+hdhJ+
        GbsymbpA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbhdc-0003aH-5d; Thu, 21 May 2020 09:37:16 +0000
Date:   Thu, 21 May 2020 02:37:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: allow individual quota grace period extension
Message-ID: <20200521093716.GC28324@infradead.org>
References: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
 <1590028518-6043-8-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590028518-6043-8-git-send-email-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
