Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6658CC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 07:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 288E82312D
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 07:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbhASHaV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 02:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbhASHaN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 02:30:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40875C061573
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 23:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GBwtDy8OpCfR/b4bnf7ln8g32Se39a9g77VY2o4qPII=; b=T6jsUjtIT/STPm2MY0bRWYRhso
        i4PLX8sva4+EFoXcYx93i75TYbjCvltRCAhzOE1kDHt/nlk758+sgPnW9ilDnBLaf3rjSDAyfD6bn
        xk9FhNRk0goyWOeqXetrjIIXJZC/cZL3w1Qzy8wTnFAcxlr7NJ5bFrljUV6bwQw6r/IE131tzcudc
        C0kxWey0l7RzrWXRrEohexONuh92oDzilsH/9EIlxUXnIo9NpfuXMU7BSERwXkjPkNyNJU4JHwJs+
        cLQVwcihDbvyLPgizUZJKjPq7g597CCMPBO8E06oJ9ORD+feuwcYXMH6ObVucbRI3nHyVtmOy4ND5
        J2+HjwPA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l1lRE-00DzsI-Qp; Tue, 19 Jan 2021 07:28:34 +0000
Date:   Tue, 19 Jan 2021 07:28:28 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: assertation failures in generic/388
Message-ID: <20210119072828.GA3335757@infradead.org>
References: <20210118192547.GA3167248@infradead.org>
 <20210118200123.GA1537873@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118200123.GA1537873@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 03:01:23PM -0500, Brian Foster wrote:
> On Mon, Jan 18, 2021 at 07:25:47PM +0000, Christoph Hellwig wrote:
> > Hi all,
> > 
> > latest Linus' tree crashes every few runs for me when running on x86_64,
> > 4k block size, virtio-blk, CONFIG_XFS_DEBUG enabled:
> > 
> > Dmesg:
> > [   93.950923] XFS: Assertion failed: percpu_counter_compare(&mp->m_ifree, 0) >5
> 
> This is likely fixed by the first patch [1] in my log covering rework
> series. generic/388 was recently modified to reproduce.

Would be great if we could push the fix to mainline and -stable then.
