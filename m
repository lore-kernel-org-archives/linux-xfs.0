Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F128CC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 13:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C98A92072E
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 13:11:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kzbXYUu5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404803AbgFYNLN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 09:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404783AbgFYNLN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 09:11:13 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CDCC08C5C1;
        Thu, 25 Jun 2020 06:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lf76WPH88lH813mY9Yo8ZHZHFHxan9PWrz3Tg7MET60=; b=kzbXYUu53U2ernxrU8NemdCmxZ
        w8ncV08dVPq7jkm2cnmqpBU10R9U4MKgzsV3vbpTA/25y2MNDYhjdSx1ozsXt6oevq61pyUP0LFlN
        X1BMrmzYQVNWdH60xTMWVqG82GP+i/OC1pkmtsfLT7aQe54L7UFUGSlvQBNfREuI40WcjJPuruX2U
        FTQUv6+jqMK/G0pYgB6Nl2mc7FM/HNyXAcHxnU7/kNqND9/NyZMdZHvBn6HhSWlbaOJ/mVVcQu4FW
        0S+3ys8xvGXnZwngL2GvKy4lY/uO6CH03hVI6iEklM4HtYBx89uulHC/8zCzBs9QJcScc77VI+vS0
        rBYHy2Bw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1joReZ-00077i-S6; Thu, 25 Jun 2020 13:10:55 +0000
Date:   Thu, 25 Jun 2020 14:10:55 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Message-ID: <20200625131055.GC7703@casper.infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
 <20200625124017.GL1320@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625124017.GL1320@dhcp22.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 25, 2020 at 02:40:17PM +0200, Michal Hocko wrote:
> On Thu 25-06-20 12:31:22, Matthew Wilcox wrote:
> > Similar to memalloc_noio() and memalloc_nofs(), memalloc_nowait()
> > guarantees we will not sleep to reclaim memory.  Use it to simplify
> > dm-bufio's allocations.
> 
> memalloc_nowait is a good idea! I suspect the primary usecase would be
> vmalloc.

That's funny.  My use case is allocating page tables in an RCU protected
page fault handler.  Jens' use case is allocating page cache.  This one
is a vmalloc consumer (which is also indirectly page table allocation).

> > @@ -877,7 +857,9 @@ static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client
> >  	 */
> >  	while (1) {
> >  		if (dm_bufio_cache_size_latch != 1) {
> > -			b = alloc_buffer(c, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> > +			unsigned nowait_flag = memalloc_nowait_save();
> > +			b = alloc_buffer(c, GFP_KERNEL | __GFP_NOMEMALLOC | __GFP_NOWARN);
> > +			memalloc_nowait_restore(nowait_flag);
> 
> This looks confusing though. I am not familiar with alloc_buffer and
> there is quite some tweaking around __GFP_NORETRY in alloc_buffer_data
> which I do not follow but GFP_KERNEL just struck my eyes. So why cannot
> we have 
> 		alloc_buffer(GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_NOWARN);

Actually, I wanted to ask about the proliferation of __GFP_NOMEMALLOC
in the block layer.  Am I right in thinking it really has no effect
unless GFP_ATOMIC is set?  It seems like a magic flag that some driver
developers are sprinkling around randomly, so we probably need to clarify
the documentation on it.

What I was trying to do was just use the memalloc_nofoo API to control
what was going on and then the driver can just use GFP_KERNEL.  I should
probably have completed that thought before sending the patches out.
