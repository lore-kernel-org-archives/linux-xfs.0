Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B999EC54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 17:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 921412071E
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 17:23:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iQ1y8eP0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgDYRXk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 13:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYRXj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 13:23:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82A2C09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 10:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jHv1DwKtCPHz/rAx+YaB2Tail2Y9xzRwWB/IirxoYDE=; b=iQ1y8eP0t0bfwEO7aiSxIV39C9
        umA6qcGqGZxUjsqwlc5wq4wm32wP/kR1IvyRFb3OttFX4FVmO43oW2ThmheHDG6SjcbhkjfGkLi8K
        Xua6zxKXGp/jHEhkP+/BetWqLdFq/X/s3kmu6wCgUqPtZfjrQVDLWkIOHAii8cFB0GL2UUY6mCp59
        rk9tZKdV2W5yxUHuh5aNmsHL7BwHolLDtRJZQ5qG6jnk5u09Aq4lQZlMpEWShAILC3k3FD0c9zW4L
        Md5FmT5g+IaY0bgRGL7JO+N4X+NDUfcUyfI/CioE+b8aK18yayOxRckgC6nN486AVFKTu8L2MKQcI
        RrXBnZZw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSOWh-0002SH-Qx; Sat, 25 Apr 2020 17:23:39 +0000
Date:   Sat, 25 Apr 2020 10:23:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 02/13] xfs: factor out buffer I/O failure simulation
 code
Message-ID: <20200425172339.GB30534@infradead.org>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:18PM -0400, Brian Foster wrote:
> We use the same buffer I/O failure simulation code in a few
> different places. It's not much code, but it's not necessarily
> self-explanatory. Factor it into a helper and document it in one
> place.

The code looks good, but the term simularion sounds rather strange in
this context.  We don't really simulate an I/O failure, but we fail the
buffer with -EIO due to a file system shutdown.

I'd also just keep the ORing of XBF_ASYNC into b_flags in the two
callers, as that keeps the function a little more "compact".
