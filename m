Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF79CC63793
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 06:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EA6961279
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 06:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhGVGIP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 02:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhGVGIP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 02:08:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3A4C061575
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jul 2021 23:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VAywGs1gMVyF3G1F0g2GBxJbpVqpAc85vRWodQZX9eY=; b=ebffW4lZDSDzR9MdmtCdO//q/1
        wowTdXmcgfVcOofJ/2riJL7sFIBTQSG67GXhzz3jsOYEkXSCVHeZm5Mxz2yCtKrrr5WYwLfkRW/C/
        bZQOOBEzVCl7MX947d9GUVUOwRq5hsgmZaOwIph8u8TwNCKEtice9TbA1fNIoGQqppwI4oT5Fxqpk
        EzPod1Q6p31LDV3fdIxhnoQp9+xyKmW45F/dERq/0IWWq+TA+xEruYKjyV7L4rhyFgXLq3wAaJb5F
        USH2herxBf4i1WXQItGBh6IXyf6NJF3AHUbvOhPipaeTREqHGodJZHz7CX0+yX8sChF/2NxiRwGMA
        iBHAa5rw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6SVV-009yEQ-Jk; Thu, 22 Jul 2021 06:48:40 +0000
Date:   Thu, 22 Jul 2021 07:48:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: external logs need to flush data device
Message-ID: <YPkUwd/IridkTHAQ@infradead.org>
References: <20210722015335.3063274-1-david@fromorbit.com>
 <20210722015335.3063274-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722015335.3063274-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 11:53:32AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The recent journal flush/FUA changes replaced the flushing of the
> data device on every iclog write with an up-front async data device
> cache flush. Unfortunately, the assumption of which this was based
> on has been proven incorrect by the flush vs log tail update
> ordering issue. As the fix for that issue uses the
> XLOG_ICL_NEED_FLUSH flag to indicate that data device needs a cache
> flush, we now need to (once again) ensure that an iclog write to
> external logs that need a cache flush to be issued actually issue a
> cache flush to the data device as well as the log device.
> 
> Fixes: eef983ffeae7 ("xfs: journal IO cache flush reductions")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
