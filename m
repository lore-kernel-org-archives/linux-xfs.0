Return-Path: <SRS0=dxv4=BH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689D8C433E5
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 13:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4885D206D8
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 13:15:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b/7l3miI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbgG1NPJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 09:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729853AbgG1NPI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jul 2020 09:15:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604A5C061794;
        Tue, 28 Jul 2020 06:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZHMkQDJHn0zeY8FYCEBJ2eds7Y8bNR+OKpl6shmcGbI=; b=b/7l3miILmZezVLADSpph+v5Or
        Xn6wZxOT4Aa7YplNd7piMOxm73z0wsg6c709ExUWYVuIh6qVekx78kXSHmB1TigNQlG4OWgaqydae
        /ljo9oqOdRgDmBlhGej+pTENWzR9KAER2L5RQQnF7VAPr6fcNelXyvggF00BeO7oQim50GaFjS3xv
        zseW3J0Ps0Xtpb9ji5+/m5G9M6szb4vLNjcEJAAbUoETTYdvQJr1902KyTcfnszq0K04vZ4Nae6gL
        LdAWObKGeK3HqYvhyaGX69eFD0FHSW1OLAJMlHjkvoAB/qK1CduggVaApPJeftgsph60MsUGx+s8f
        0iWrzlBQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0PRh-0004V8-63; Tue, 28 Jul 2020 13:15:05 +0000
Date:   Tue, 28 Jul 2020 14:15:05 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iomap: Ensure iop->uptodate matches PageUptodate
Message-ID: <20200728131505.GQ23808@casper.infradead.org>
References: <20200726091052.30576-1-willy@infradead.org>
 <20200726230657.GT2005@dread.disaster.area>
 <20200726232022.GH23808@casper.infradead.org>
 <20200726235335.GU2005@dread.disaster.area>
 <20200728092301.GA32142@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728092301.GA32142@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 28, 2020 at 10:23:01AM +0100, Christoph Hellwig wrote:
> On Mon, Jul 27, 2020 at 09:53:35AM +1000, Dave Chinner wrote:
> > Yes, I understand the code accepts it can happen; what I dislike is
> > code that asserts subtle behaviour can happen, then doesn't describe
> > that exactly why/how that condition can occur. And then, because we
> > don't know exactly how something happens, we add work arounds to
> > hide issues we can't reason through fully. That's .... suboptimal.
> > 
> > Christoph might know off the top of his head how we get into this
> > state. Once we work it out, then we need to add comments...
> 
> Unfortunately I don't know offhand.  I'll need to spend some more
> quality time with this code first.

The code reads like you had several ideas for how the uptodate array
works, changing your mind as you went along, and it didn't quite get to
a coherent state before it was merged.  For example, there are parts
of the code which think that a clear bit in the uptodate array means
there's a hole in the file, eg

fs/iomap/seek.c:page_seek_hole_data() calls iomap_is_partially_uptodate()

but we set the uptodate bits when zeroing the parts of the page which
are covered by holes in iomap_readpage_actor()

> > > Way ahead of you
> > > http://git.infradead.org/users/willy/pagecache.git/commitdiff/5a1de6fc4f815797caa4a2f37c208c67afd7c20b
> > 
> > *nod*
> > 
> > I would suggest breaking that out as a separate cleanup patch and
> > not hide is in a patch that contains both THP modifications and bug
> > fixes. It stands alone as a valid cleanup.
> 
> I'm pretty sure I already suggested that when it first showed up.
> 
> That being said I have another somewhat related thing in this area
> that I really want to get done before THP support, and maybe I can
> offload it to willy:
> 
> Currently we always allocate the iomap_page structure for blocksize
> < PAGE_SIZE.  While this was easy to implement and a major improvement
> over the buffer heads it actually is quite silly, as we only actually
> need it if we either have sub-page uptodate state, or have extents
> boundaries in the page.  So what I'd like to do is to only actually
> allocate it in that case.  By doing the allocation lazy it should also
> help to never allocate one that is marked all uptodate from the start.

Hah, I want to do that too, and I was afraid I was going to have to
argue with you about it!

My thinking was to skip the allocation if the page lies entirely within
an iomap extent.  That will let us skip the allocation even for THPs
unless the file is fragmented.

I don't think it needs to get done before THP support, they're pretty
orthogonal.
