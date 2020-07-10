Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC35C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 16:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 369CA206C3
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 16:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lqYYf0xy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgGJQJs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 12:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgGJQJs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 12:09:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87648C08C5CE
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 09:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=S2OnuBnMweivfv5xq8NQUsd9WMk76fA9akv/6Jh5FQo=; b=lqYYf0xyszSlqc90uhREOOffOS
        i10K1v4D4Xhc4E4V5IeTMNGUbTjUjyM16clzHONKHVafXTGBeUAQNRyUqWGZEqKj8WqWz9zQs47Ki
        Yohf4nmAryiVezPBKfns0oF2sYkzMw/OfDVeBPAq3oBIs9LP8MDF22seZJF56+oAr4F27q3o5DCY5
        +Z0eXWq9QtW8Bctly9VniBEr7KQZYNytgn6I1YDltmlrgnMzc03VjrVILBRQV+uX8gdVFURkz/Zld
        qZUi1wLCFJnPrVakatWJ3U/Cl3jRRw6wFy5qN40c+b3AxjN/C/1pzh9eEs/2xLJzrRjChfXRnKBuW
        Y8omUo4g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtvat-00032m-87; Fri, 10 Jul 2020 16:09:47 +0000
Date:   Fri, 10 Jul 2020 17:09:47 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: remove xfs_zone_{alloc,zalloc} helpers
Message-ID: <20200710160947.GD10364@infradead.org>
References: <20200710091536.95828-1-cmaiolino@redhat.com>
 <20200710091536.95828-5-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710091536.95828-5-cmaiolino@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 10, 2020 at 11:15:35AM +0200, Carlos Maiolino wrote:
> All their users have been converted to use MM API directly, no need to
> keep them around anymore.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
