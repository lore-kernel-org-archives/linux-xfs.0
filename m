Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E997C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 20:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19FD720791
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 20:35:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AMrFzgXk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407135AbgFYUfB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 16:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405196AbgFYUfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 16:35:01 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94E6C08C5C1;
        Thu, 25 Jun 2020 13:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=28eoYY2uGIc1DwA6QcApRQG+3fffIKYfjFEy3EC/Dxs=; b=AMrFzgXkDAU0Jk+yRxwizHzv3T
        dIDsB2abYaN/5WBY9xDm5Tu+LBOnLcxAaW6925hooa0nzJIycKlPZ32RLl24kZESHi9Sho1VRRn6h
        nKObtZ5wWxOCNdchklkwz77RInazmElcmZk5AahCU+Izn/4NqJW6KEPW6xyFvb7b7WrNN+oijtO6g
        bI2KH7eCf66Uw23DtnoRJqmfDuY+oW85z5Wg4KNW2YNISFLtOD0xuzpziSjBgJJ7c9L7t4mtV9jTK
        B/mMv3e50NGZvDQ8q64GlomBn85rEOxtZFrBCWx90//a8VYf5vxUHN5H/u7engQjgSg/Aepl2ju79
        c/GfljpA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1joYa2-0004hi-NK; Thu, 25 Jun 2020 20:34:42 +0000
Date:   Thu, 25 Jun 2020 21:34:42 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
        Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH 0/6] Overhaul memalloc_no*
Message-ID: <20200625203442.GG7703@casper.infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625184832.GP7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625184832.GP7606@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 25, 2020 at 11:48:32AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 25, 2020 at 12:31:16PM +0100, Matthew Wilcox (Oracle) wrote:
> > I want a memalloc_nowait like we have memalloc_noio and memalloc_nofs
> > for an upcoming patch series, and Jens also wants it for non-blocking
> > io_uring.  It turns out we already have dm-bufio which could benefit
> > from memalloc_nowait, so it may as well go into the tree now.
> > 
> > The biggest problem is that we're basically out of PF_ flags, so we need
> > to find somewhere else to store the PF_MEMALLOC_NOWAIT flag.  It turns
> > out the PF_ flags are really supposed to be used for flags which are
> > accessed from other tasks, and the MEMALLOC flags are only going to
> > be used by this task.  So shuffling everything around frees up some PF
> > flags and generally makes the world a better place.
> 
> So, uh, how does this intersect with the patch "xfs: reintroduce
> PF_FSTRANS for transaction reservation recursion protection" that
> re-adds PF_TRANS because uh I guess we lost some subtlety or another at
> some point?

I don't know.  I read that thread, but I couldn't follow the argument.

