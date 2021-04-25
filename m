Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FAE8C433ED
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Apr 2021 23:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37A3361090
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Apr 2021 23:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhDYXW0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Apr 2021 19:22:26 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:55480 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231247AbhDYXW0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Apr 2021 19:22:26 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 5EC79105802;
        Mon, 26 Apr 2021 09:21:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lao4L-007idV-Kr; Mon, 26 Apr 2021 09:21:41 +1000
Date:   Mon, 26 Apr 2021 09:21:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, bfoster@redhat.com,
        zlang@redhat.com
Subject: Re: [PATCH] xfs: fix debug-mode accounting for deferred AGFL freeing
Message-ID: <20210425232141.GE63242@dread.disaster.area>
References: <20210425154634.GZ3122264@magnolia>
 <20210425225052.GC63242@dread.disaster.area>
 <20210425230550.GB3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210425230550.GB3122264@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_f
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=VwQbUJbxAAAA:8 a=eJfxgxciAAAA:8
        a=pGLkceISAAAA:8 a=7-415B0cAAAA:8 a=69nqnO1nyyudLD0VCSYA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=xM9caqqi1sUkTy8OJ5Uh:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 25, 2021 at 04:05:50PM -0700, Darrick J. Wong wrote:
> On Mon, Apr 26, 2021 at 08:50:52AM +1000, Dave Chinner wrote:
> > On Sun, Apr 25, 2021 at 08:46:34AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > In commit f8f2835a9cf3 we changed the behavior of XFS to use EFIs to
> > > remove blocks from an overfilled AGFL because there were complaints
> > > about transaction overruns that stemmed from trying to free multiple
> > > blocks in a single transaction.
> > > 
> > > Unfortunately, that commit missed a subtlety in the debug-mode
> > > transaction accounting when a realtime volume is attached.  If a
> > > realtime file undergoes a data fork mapping change such that realtime
> > > extents are allocated (or freed) in the same transaction that a data
> > > device block is also allocated (or freed), we can trip a debugging
> > > assertion.  This can happen (for example) if a realtime extent is
> > > allocated and it is necessary to reshape the bmbt to hold the new
> > > mapping.
> > > 
> > > When we go to allocate a bmbt block from an AG, the first thing the data
> > > device block allocator does is ensure that the freelist is the proper
> > > length.  If the freelist is too long, it will trim the freelist to the
> > > proper length.
> > > 
> > > In debug mode, trimming the freelist calls xfs_trans_agflist_delta() to
> > > record the decrement in the AG free list count.  Prior to f8f28 we would
> > > put the free block back in the free space btrees in the same
> > > transaction, which calls xfs_trans_agblocks_delta() to record the
> > > increment in the AG free block count.  Since AGFL blocks are included in
> > > the global free block count (fdblocks), there is no corresponding
> > > fdblocks update, so the AGFL free satisfies the following condition in
> > > xfs_trans_apply_sb_deltas:
> > > 
> > > 	/*
> > > 	 * Check that superblock mods match the mods made to AGF counters.
> > > 	 */
> > > 	ASSERT((tp->t_fdblocks_delta + tp->t_res_fdblocks_delta) ==
> > > 	       (tp->t_ag_freeblks_delta + tp->t_ag_flist_delta +
> > > 		tp->t_ag_btree_delta));
> > > 
> > > The comparison here used to be: (X + 0) == ((X+1) + -1 + 0), where X is
> > > the number blocks that were allocated.
> > > 
> > > After commit f8f28 we defer the block freeing to the next chained
> > > transaction, which means that the calls to xfs_trans_agflist_delta and
> > > xfs_trans_agblocks_delta occur in separate transactions.  The (first)
> > > transaction that shortens the free list trips on the comparison, which
> > > has now become:
> > > 
> > > (X + 0) == ((X) + -1 + 0)
> > > 
> > > because we haven't freed the AGFL block yet; we've only logged an
> > > intention to free it.  When the second transaction (the deferred free)
> > > commits, it will evaluate the expression as:
> > > 
> > > (0 + 0) == (1 + 0 + 0)
> > > 
> > > and trip over that in turn.
> > > 
> > > At this point, the astute reader may note that the two commits tagged by
> > > this patch have been in the kernel for a long time but haven't generated
> > > any bug reports.  How is it that the author became aware of this bug?
> > > 
> > > This originally surfaced as an intermittent failure when I was testing
> > > realtime rmap, but a different bug report by Zorro Lang reveals the same
> > > assertion occuring on !lazysbcount filesystems.
> > > 
> > > The common factor to both reports (and why this problem wasn't
> > > previously reported) becomes apparent if we consider when
> > > xfs_trans_apply_sb_deltas is called by __xfs_trans_commit():
> > > 
> > > 	if (tp->t_flags & XFS_TRANS_SB_DIRTY)
> > > 		xfs_trans_apply_sb_deltas(tp);
> > 
> > IIUC, what you are saying is that this debug code is simply not
> > exercised in normal testing and hasn't been for the past decade?
> 
> Yes.
> 
> > And it still won't be exercised on anything other than realtime
> > device testing?
> 
> Yes.  Note that I've added it to my regular testing routine since I
> actually /do/ have users of rt volumes now.

Ok.

> 
> > I don't really consider !lazycount worth investing time and
> > effort into because deprecated and default for over a decade, so if
> > this is the case, then why not just remove it?
> 
> I think I understand [this infrequently exercised code path], which
> means I don't understand it, so rather than be one of those idiots who
> rips out everything he doesn't understand, I thought I'd at least try to
> figure out what it did and patch it back together.
> 
> So now that I actually understand what that debug code does having dug
> around to see what those fields do, I'd also be just fine ripping it
> out.  But I wanted to know what I would be tearing out first...

History. In 2006 this went from being calculated and checked on
every transaction, to just being debug code:

commit a7b0e16180bdc21c42331259b741c86ebd27b9bf
Author: Nathan Scott <nathans@sgi.com>
Date:   Fri Jun 23 02:49:59 2006 +0000

    Reduce size of xfs_trans_t structure.
    * remove ->t_forw, ->t_back -- unused
    * ->t_ag_freeblks_delta, ->t_ag_flist_delta, ->t_ag_btree_delta
      are debugging aid -- wrap them in everyone's favourite way.
    
    As a result, cut "xfs_trans" slab object size from 592 to 572 bytes here.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Merge of xfs-linux-melb:xfs-kern:26319a by kenmcd.
    
      Reduce size of xfs_trans_t structure.

But the fields are largely unchanged from when they were introduced
in 1994 as a debugging aid:

commit a6116f5f96658a400f122527163d2a233c45904c
Author: Adam Sweeney <ajs@sgi.com>
Date:   Mon Jun 27 23:53:59 1994 +0000

    Add debugging accounting for agf btree blocks.

commit 785055c77c166e935f22afd3379a861e2967a3b1
Author: Adam Sweeney <ajs@sgi.com>
Date:   Fri Jun 24 20:46:39 1994 +0000

    Add calls to track agf counter changes in the transaction
    so we can ensure that they are consistent with the changes
    to the superblock.

So it was debugging code from 1994 that was largely turned into dead
code when lazysbcounters were introduced in 2007. Hence I'm not sure
it holds any value anymore, especially if we are just going to turn
lazycount for everyone...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
