Return-Path: <SRS0=/U9k=3O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04805C35242
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFE1D20704
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jan 2020 23:15:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VVJM8Fpz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgAYXPd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 18:15:33 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47156 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbgAYXPd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 18:15:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Aoj0LsITKnW5KTRBHlc8BRF0LbgQ44tvxlRq83JRbNM=; b=VVJM8Fpz7ATz0UubIByc89Snc
        EfYBU/4mpEHzYdeozkmGehAsXX0hfw2FtbhC7J8KPke75RAoeFVMh1Y8XJ+sxzxEZlj89e/y32hTe
        RdG4pxfP9beBfE3kiIgYYoZql72k/rAlEt9dMBlvwDPp4QfDqRKJ8rVn1+b/2Oo3F9lC+XQpVolO/
        fBzxm8hF2IyPGIAgZNEnD3d93CunP+kcqx2wKmyJm6jdRHw3AwkAR1fT1nRkFT0Iln0ESP4PKNeQA
        i0s+emZAkmtA3QNxOaNi6VkRMz4omjErukrrasJD5Auc920Bz88ugsnUsbAXtbO/y5Ze6ZCVKNkFe
        i64KrjAfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivUeK-0006e8-N9; Sat, 25 Jan 2020 23:15:32 +0000
Date:   Sat, 25 Jan 2020 15:15:32 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] libxfs: move header includes closer to kernelspace
Message-ID: <20200125231532.GD15222@infradead.org>
References: <e0f6e0e5-d5e0-1829-f08c-0ec6e6095fb0@redhat.com>
 <4d8501f5-4db1-9f46-bbf8-e2a7ae5726b6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8501f5-4db1-9f46-bbf8-e2a7ae5726b6@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 22, 2020 at 10:48:51AM -0600, Eric Sandeen wrote:
> Aid application of future kernel patches which change #includes;
> not all headers exist in userspace so this is not a 1:1 match, but
> it brings userspace files a bit closer to kernelspace by adding all
> #includes which do match, and putting them in the same order.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Given how our headers are such a mess I wonder if we should reduce them
to something like just a handful.  Life would become a lot simpler..
