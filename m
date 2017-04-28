Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43906 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756059AbdD1TlF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2017 15:41:05 -0400
Date: Fri, 28 Apr 2017 12:40:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: try to avoid blowing out the transaction
 reservation when bunmaping a shared extent
Message-ID: <20170428194032.GF22884@birch.djwong.org>
References: <20170425020954.GV23371@birch.djwong.org>
 <20170426135912.GB42456@bfoster.bfoster>
 <20170426213731.GC23371@birch.djwong.org>
 <20170427073519.GA18392@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170427073519.GA18392@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, Apr 27, 2017 at 12:35:19AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 26, 2017 at 02:37:31PM -0700, Darrick J. Wong wrote:
> > That's so shockingly obvious I don't know why it didn't occur to me.
> > Uh, I'll go give that a try with that horrid generic/931 testcase that
> > I sent to the list a couple of weeks ago. :)

...and now I've realized why I never thought of it -- it's unfortunately
racy.  We want to constrain the number of blocks that we unmap from the
file based on the refcount, but because the transaction rolling unlocks
the AGF in between the unmap and decrement-refcount transactions,
another process can swoop in and make changes to the sharedness that
screw us over.  Let's say files A and B both share the same 1000 blocks,
and threads A and B are modifying files A and B, respectively.

Thread A:                            Thread B:
1. punch blocks backed by (0-1000)   1. punch blocks backed by (500-600)
2. grab agf to read refcbt  
3. unmap blocks 0-1000; no
   refcount edges so we can
   unmap everything at once
4. roll transaction, unlock agf
                                     2. grab agf to read refcbt
                                     3. unmap blocks 500-600; no refcount
                                        edges so we can unmap everything in
                                        a single operation
                                     4. roll transaction, unlock agf
                                     5. grab agf again. lucky!
                                     6. split refcbt record because 500-600
                                        is now only owned by file A.
                                     7. complete transaction, unlock agf
5. grab agf to read refcbt
6. whoah!  why are there two
   edges in the refcount tree at
   500 and 600???

So either we have to keep the AGF buffer locked and attached across
all the transaction rolls until we around to processing the refcount
decrement deferred op, or figure out something else clever...?

--D

> I like the idea too.  But once thing to remember is that freeing
> blocks from two AG in the same transaction is deadlock prone as the
> other thread shows.  I've been doing some work to mitigate that, but
> I guess I'll just wait for your new patch and will rebase on top of
> that.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
