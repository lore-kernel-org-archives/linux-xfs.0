Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D633EC11F68
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0A5861411
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhGBIjS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 04:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhGBIjS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 04:39:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25DAC061762
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jul 2021 01:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=haPQ1OlHYMOPq+6/wp7tNLpQVpkL5OYMBSLOPJ2vJek=; b=bxtGBIc9DmNUJ+VO7X+q+ldwat
        hXSz57Gt69kZnDHD35YLNALZ0E49xO3ePRwsxg1zUVX01y5aNTmAi2NPDXUnD7B3w7ISnw7XBwAxC
        XUeSQSofwVmICdWUSPWvna41TpfPUFaGrhLaEcec5CxhuNf0bNOjIPF+Lsrh6/AnDu2Jd8PFq7CdY
        DWqLERKBMX3wPpDQMKl0yoGfo6npnNPznr68ATuN0Qz3Nt1v+aVhWZCcDta3mBmosnXC0bo40YldO
        /kV9vK61oiFVFY+XrlRBEUuxGvfSmmaYna7KGXibOQc0XFIyGRkYtGFLvyZQde3mMOGRup+1hHhT/
        DAIHNasA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzEey-007Vdj-7p; Fri, 02 Jul 2021 08:36:33 +0000
Date:   Fri, 2 Jul 2021 09:36:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: separate out log shutdown callback processing
Message-ID: <YN7QDC8j7YEl02JJ@infradead.org>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630063813.1751007-8-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 30, 2021 at 04:38:11PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The iclog callback processing done during a forced log shutdown has
> different logic to normal runtime IO completion callback processing.
> Separate out eh shutdown callbacks into their own function and call
> that from the shutdown code instead.
> 
> We don't need this shutdown specific logic in the normal runtime
> completion code - we'll always run the shutdown version on shutdown,
> and it will do what shutdown needs regardless of whether there are
> racing IO completion callbacks scheduled or in progress. Hence we
> can also simplify the normal IO completion callpath and only abort
> if shutdown occurred while we actively were processing callbacks.

What prevents a log shutdown from coming in during the callback
processing?  Or is there a reason why we simply don't care for that
case?
