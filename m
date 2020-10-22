Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB33C55179
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 16:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ED4B2464B
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 16:46:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PSyTwhKE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897895AbgJVQqe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 12:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2897884AbgJVQqd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 12:46:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44B0C0613CE;
        Thu, 22 Oct 2020 09:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xro6DWExEiJhODwXOAby9O4a+I7/GqhPz/+TxrJCSCI=; b=PSyTwhKEJI7x6Yu1qPkYUlYXbj
        3NqqmLBtG03MbjTHdDGJBrpt5Ev5AwfD6v1ObDzWTzNpwECQsirZtMgIFPFMcvVoDS+LxyiaDvJVa
        yQQgYFDKrPbnKsQgzHlZ+UBttzVn4O8gnIaS4m1e4A7cpCdedooUcoKaFbVlb20zznFVPu8+U/hD6
        TxA0vBUNaYfrcx55mgpAT7H5P3GLgxVdcQOKi55Ta65jj2LWvJek6vxpiYtgYOMau2fIXK3Up7P6B
        6QhfrNiW51zGsPK4jwNiBLey0oCMNYPtzHSN4XMbmo5zMKUcDlGTYuO68J31gzhjz+4qL/cXqZiWx
        tvHZG5Hw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kVdjM-0003Cv-50; Thu, 22 Oct 2020 16:46:24 +0000
Date:   Thu, 22 Oct 2020 17:46:24 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     William Kucharski <william.kucharski@oracle.com>
Cc:     Qian Cai <cai@lca.pw>, Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org
Subject: Re: kernel BUG at mm/page-writeback.c:2241 [
 BUG_ON(PageWriteback(page); ]
Message-ID: <20201022164624.GW20115@casper.infradead.org>
References: <645a3f332f37e09057c10bc32f4f298ce56049bb.camel@lca.pw>
 <20201022004906.GQ20115@casper.infradead.org>
 <361D9B8E-CE8F-4BA0-8076-8384C2B7E860@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <361D9B8E-CE8F-4BA0-8076-8384C2B7E860@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 07:23:33AM -0600, William Kucharski wrote:
> 
> 
> > On Oct 21, 2020, at 6:49 PM, Matthew Wilcox <willy@infradead.org> wrote:
> > 
> > On Wed, Oct 21, 2020 at 08:30:18PM -0400, Qian Cai wrote:
> >> Today's linux-next starts to trigger this wondering if anyone has any clue.
> > 
> > I've seen that occasionally too.  I changed that BUG_ON to VM_BUG_ON_PAGE
> > to try to get a clue about it.  Good to know it's not the THP patches
> > since they aren't in linux-next.
> > 
> > I don't understand how it can happen.  We have the page locked, and then we do:
> > 
> >                        if (PageWriteback(page)) {
> >                                if (wbc->sync_mode != WB_SYNC_NONE)
> >                                        wait_on_page_writeback(page);
> >                                else
> >                                        goto continue_unlock;
> >                        }
> > 
> >                        VM_BUG_ON_PAGE(PageWriteback(page), page);
> > 
> > Nobody should be able to put this page under writeback while we have it
> > locked ... right?  The page can be redirtied by the code that's supposed
> > to be writing it back, but I don't see how anyone can make PageWriteback
> > true while we're holding the page lock.
> 
> Looking at __test_set_page_writeback(), I see that it (and most other
> callers to lock_page_memcg()) do the following:

lock_page_memcg() is, unfortunately, completely unrelated to lock_page().
I believe all callers of __test_set_page_writeback() have the page lock
held already, but I'm going to put in an assert to that effect.

