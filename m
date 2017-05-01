Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55720 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935993AbdEAPg5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 May 2017 11:36:57 -0400
Date: Mon, 1 May 2017 10:58:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: try to avoid blowing out the transaction
 reservation when bunmaping a shared extent
Message-ID: <20170501145839.GB2109@bfoster.bfoster>
References: <20170425020954.GV23371@birch.djwong.org>
 <20170426135912.GB42456@bfoster.bfoster>
 <20170426213731.GC23371@birch.djwong.org>
 <20170427073519.GA18392@infradead.org>
 <20170428194032.GF22884@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170428194032.GF22884@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>

On Fri, Apr 28, 2017 at 12:40:32PM -0700, Darrick J. Wong wrote:
> On Thu, Apr 27, 2017 at 12:35:19AM -0700, Christoph Hellwig wrote:
> > On Wed, Apr 26, 2017 at 02:37:31PM -0700, Darrick J. Wong wrote:
> > > That's so shockingly obvious I don't know why it didn't occur to me.
> > > Uh, I'll go give that a try with that horrid generic/931 testcase that
> > > I sent to the list a couple of weeks ago. :)
> 
> ...and now I've realized why I never thought of it -- it's unfortunately
> racy.  We want to constrain the number of blocks that we unmap from the
> file based on the refcount, but because the transaction rolling unlocks
> the AGF in between the unmap and decrement-refcount transactions,
> another process can swoop in and make changes to the sharedness that
> screw us over.  Let's say files A and B both share the same 1000 blocks,
> and threads A and B are modifying files A and B, respectively.
> 
> Thread A:                            Thread B:
> 1. punch blocks backed by (0-1000)   1. punch blocks backed by (500-600)
> 2. grab agf to read refcbt  
> 3. unmap blocks 0-1000; no
>    refcount edges so we can
>    unmap everything at once
> 4. roll transaction, unlock agf
>                                      2. grab agf to read refcbt
>                                      3. unmap blocks 500-600; no refcount
>                                         edges so we can unmap everything in
>                                         a single operation
>                                      4. roll transaction, unlock agf
>                                      5. grab agf again. lucky!
>                                      6. split refcbt record because 500-600
>                                         is now only owned by file A.
>                                      7. complete transaction, unlock agf
> 5. grab agf to read refcbt
> 6. whoah!  why are there two
>    edges in the refcount tree at
>    500 and 600???
> 

Ugh, ok. So we basically can't make any assumptions about shared extent
state across the transactions, because that can change as soon as we
start processing deferred actions. This is presumably why we have high
level refcount inc/dec deferred ops such that the specific shared state
of a range of blocks isn't really assessed until the deferred op runs.

Therefore, this patch limits the high level unmap operation based on a
worst case assumption that every other block is shared..? If we do end
up going with this approach, I think the comment where we calc the max
unmap block count could be slightly improved to point out the specifics
of the issue here. E.g., each individual block of a contiguous extent
could result in an independent EFI or reflink adjustment, therefore we
need to convert available log reservation into a block based unmap
limit.

> So either we have to keep the AGF buffer locked and attached across
> all the transaction rolls until we around to processing the refcount
> decrement deferred op, or figure out something else clever...?
> 

Keeping the AGF locked still sounds like the most preferable approach to
me, provided there are no other dragons lurking around locking or
whatnot and we can do so cleanly. Perhaps we could plumb in a mechanism
to xfs_trans_bhold() a buffer across a dop list and then
_bhold_release() it for the last transaction returned by
xfs_defer_finish()..?

Otherwise, another question I had more related to the approach of the
current patch... could we use a deterministic unmap length baked into
the transaction rather than a dynamic assumption that a certain
percentage of the transaction is designated for reflink adjustments?
E.g., use a transaction that is explicitly designed for a max extent
modification count or a max block adjustment (based on the worst link
reflink requirements) and fix xfs_bunmapi() to use that max count. What
concerns me about the dynamic approach is that if we ever had to
increase or modify this transaction res for something else that happens
to also affect unmap (*handwave*), we'd have to also know to go and
possibly reverse engineer/adjust this reflink heuristic appropriately
(or more likely, not do so and set a landmine).

Brian

> --D
> 
> > I like the idea too.  But once thing to remember is that freeing
> > blocks from two AG in the same transaction is deadlock prone as the
> > other thread shows.  I've been doing some work to mitigate that, but
> > I guess I'll just wait for your new patch and will rebase on top of
> > that.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
