Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02990C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 02:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1457271AbiDFCzJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 22:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581718AbiDEXkl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 19:40:41 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C22C1D190F
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 15:01:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1A32853440B;
        Wed,  6 Apr 2022 08:01:23 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nbrEn-00EDOq-O0; Wed, 06 Apr 2022 08:01:21 +1000
Date:   Wed, 6 Apr 2022 08:01:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: remove a superflous hash lookup when inserting
 new buffers
Message-ID: <20220405220121.GZ1544202@dread.disaster.area>
References: <20220403120119.235457-1-hch@lst.de>
 <20220403120119.235457-4-hch@lst.de>
 <20220403230452.GP1544202@dread.disaster.area>
 <20220405150027.GB15992@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405150027.GB15992@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=624cbc33
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=hXaI3DBZFvCx01V-dgwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 05, 2022 at 05:00:27PM +0200, Christoph Hellwig wrote:
> On Mon, Apr 04, 2022 at 09:04:52AM +1000, Dave Chinner wrote:
> > On Sun, Apr 03, 2022 at 02:01:17PM +0200, Christoph Hellwig wrote:
> > > xfs_buf_get_map has a bit of a strange structure where the xfs_buf_find
> > > helper is called twice before we actually insert a new buffer on a cache
> > > miss.  Given that the rhashtable has an interface to insert a new entry
> > > and return the found one on a conflict we can easily get rid of the
> > > double lookup by using that.
> > 
> > We can do that without completely rewriting this code.
> 
> We could.  And I had something similar earlier.  But I actually thing
> the structure of the code after this patch makes much more sense.  All
> the logic for the fast path buffer lookup is clearly layed out in one
> function, which then just calls a helper to perform the lookup.
> The new scheme also is slightly less code overall.  Even more so once
> the lockless lookup comes into play which requires different locking
> and refcount increments.

Agreed, but you're making two distinct, significant modifications in
the one patchset. One is changing the way we use a generic library
functionality, the other is changing the entire structure of the
lookup path.

IOWs, I was not saying the end result was bad, I was (clumsily)
trying to suggest that you should split these two modifications into
separate patches because they are largely separate changes.

Once I thought about it that way, and
looking that them that way made me want to structure the code quite
differently.

> > The return cases of this function end up being a bit of a mess. We can return:
> > 
> >  - error = 0 and a locked buffer in *bpp
> >  - error = -EEXIST and an unlocked buffer in *bpp
> >  - error != 0 and a modified *bpp pointer
> >  - error != 0 and an unmodified *bpp pointer
> 
> The last two are the same  - the *bpp pointer simply is not valid on a
> "real" error return.  So the return really is a tristate, similar
> to many other places in xfs.

I think you missed the point I was making. I'm not complaining about
whether it's a tristate return or not, it's the fact that it can
return buffers in different states and the caller has to handle that
inconsistency itself whilst still maintaining an efficient fast
path.

That's what makes the code difficult to follow - xfs_buf_insert() is
the slow path, so all the complexity and twisted logic should be
inside that function rather than directly impacting the fast path
code.

e.g. Most of the complexity goes away if we factor out the buffer
trylock/locking code into a helper (like we have in the iomap code)
and then have xfs_buf_insert() call it when it finds an existing
buffer. Then the -EEXIST return value can go away, and
xfs_buf_insert can return a locked buffer exactly the same as if it
inserted a new buffer. Have the newly allocated buffer take a new
perag reference, too, instead of stealing the caller's reference,
and then all the differences between insert and -EEXIST cases go
away.

Then you can move all the conditional lookup failure cases into
xfs_buf_insert(), too, and we end up with high level fast path code
that is clear and concise:

	/* cache hits generally outnumber misses by at least 10:1 */
	bp = xfs_buf_lookup_fast(pag, &cmap);
	if (likely(bp))
		error = xfs_buf_lookup_lock(bp, flags);
	else
		error = xfs_buf_lookup_insert(pag, &cmap, flags, &bp);

	xfs_perag_put(pag);
	if (!error)
		*bpp = bp;
	return error;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
