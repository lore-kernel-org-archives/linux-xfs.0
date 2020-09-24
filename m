Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5EBAC4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 01:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D7472145D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 01:10:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mdxOda+b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgIXBKJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 21:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXBKJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 21:10:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C2AC0613CE;
        Wed, 23 Sep 2020 18:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0/0SGFMwxthgjvuRFvMv1mpYU9WObyFYjO/sQ1qc82Y=; b=mdxOda+b2IaFiWwnXlQhRvoVvR
        hC2+JUre0xKcysiCXPPUn3kuPFuxy5Gg/ISApsfD7khvcB5cFqucLY1LdbVtht8oTuN2gDCAG0U4D
        247fkoOjE5StgSRVKSCIcSPa4XpS3kPPdjUkgrYdVuRWLQHXENfFAnWjGPK5e5L2oIcEJKvJTpGoO
        wbliS799EQv8fGnhTm8Xt2QMfoVb/2HJoAgKBgQH/RYTtSjb3QSjDyrKil6zF2iwUjRfsdq8gOBju
        Ydl9W+IfscU/iIQgkhg3BAi1h362+fsKkBK4prvJY6nENyrA+IUHXbDh6Bd7/tHJf/FJ9wYrd+Mkh
        dtYLsyUQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLFlu-0001B3-Mr; Thu, 24 Sep 2020 01:10:06 +0000
Date:   Thu, 24 Sep 2020 02:10:06 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jens Axboe <axboe@kernel.dk>, linux-xfs@vger.kernel.org,
        dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Message-ID: <20200924011006.GT32101@casper.infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
 <20200924003902.GA10500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924003902.GA10500@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 23, 2020 at 08:39:02PM -0400, Mike Snitzer wrote:
> On Thu, Jun 25 2020 at  7:31am -0400,
> Matthew Wilcox (Oracle) <willy@infradead.org> wrote:
> 
> > Similar to memalloc_noio() and memalloc_nofs(), memalloc_nowait()
> > guarantees we will not sleep to reclaim memory.  Use it to simplify
> > dm-bufio's allocations.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >  drivers/md/dm-bufio.c    | 30 ++++++++----------------------
> >  include/linux/sched.h    |  1 +
> >  include/linux/sched/mm.h | 12 ++++++++----
> >  3 files changed, 17 insertions(+), 26 deletions(-)
> 
> 
> Hi,
> 
> Curious on the state of this patchset?  Not seeing it in next-20200923
> 
> The dm-bufio cleanup looks desirable.

I've been busy with THPs and haven't pushed this patchset for this window.
It's probably a bit late now we're at rc6, so I'll clean it up and push
it for 5.11?
