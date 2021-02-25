Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18640C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA04D64EC3
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 09:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhBYJnA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 04:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbhBYJmU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 04:42:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145F9C061794
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 01:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AmpU++cHa+y/Nq9YQvTH0/EGaTVUZBkjFpNjCnzYhrs=; b=oQBW0Q80kESf8CTKdwqDC0APy8
        VnnWUx/X5eiYQ6WvEke51jDNUNFozrGv7s6Ph7JE3ub/PBUO4GKrhD0+vmmEumiQJb8tQS27caSV0
        Y6npZsFnItKK7XewzHaXBKtxiI5V6iDNfGSGHcLvDBKqWL5K0rp9ObhhtXc7M1UMJf/tex1rlG2N/
        Y65fvmMk5OvsnOONUTRtb3QcpQmt1rpqL0IIh899YhDIvmfEBYOzY7SV5Si3pEAG8ktl7O0kGvDQx
        wHoLhF5fIubXGHzE4g7dKa5ehoRML6Ki1NRaifvGpxKLVfQGPhcgzVe4D/wcss52TPXnNNYpg02ti
        4WnyUINQ==;
Received: from [2001:4bb8:188:6508:774c:3d81:3abc:7b82] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFD7O-00AWzV-6C; Thu, 25 Feb 2021 09:39:37 +0000
Date:   Thu, 25 Feb 2021 10:39:32 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/13] xfs: move log iovec alignment to preparation
 function
Message-ID: <YDdwVEodKSIZWkg0@infradead.org>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224063459.3436852-7-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 24, 2021 at 05:34:52PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To include log op headers directly into the log iovec regions that
> the ophdrs wrap, we need to move the buffer alignment code from
> xlog_finish_iovec() to xlog_prepare_iovec(). This is because the
> xlog_op_header is only 12 bytes long, and we need the buffer that
> the caller formats their data into to be 8 byte aligned.
> 
> Hence once we start prepending the ophdr in xlog_prepare_iovec(), we
> are going to need to manage the padding directly to ensure that the
> buffer pointer returned is correctly aligned.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
