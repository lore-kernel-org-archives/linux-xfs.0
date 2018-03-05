Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57656 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbeCESxG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Mar 2018 13:53:06 -0500
Date: Mon, 5 Mar 2018 10:52:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Correctly invert xfs_buftarg LRU isolation logic
Message-ID: <20180305185259.GC18989@magnolia>
References: <20180228154951.31714-1-vbendel@redhat.com>
 <20180301224800.GI12763@magnolia>
 <20180302163603.GQ19312@magnolia>
 <CAHrQN1w2DxYD_ZscBhsuGq2b6CKn41AnVCaH6_hSQ2tN8DkA1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHrQN1w2DxYD_ZscBhsuGq2b6CKn41AnVCaH6_hSQ2tN8DkA1Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vratislav Bendel <vbendel@redhat.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, djwong@kernel.org

On Mon, Mar 05, 2018 at 11:19:46AM +0100, Vratislav Bendel wrote:
> (In response to Luis' comment:)
> > Can you add a respective Fixes: tag?
> 
> It was apparently present since LRU was added to xfs buffer cache via:
> commit 430cbeb86fdcbbdabea7d4aa65307de8de425350
> [xfs: add a lru to the XFS buffer cache]
> 
> But I wouldn't say this patch "fixes" that commit.
> What do you think? Should a fixes tag be added in this case?
> 
> 
> > Also what effects are observed by
> > the user when this happens on the kernel log?
> 
> I haven't spotted any differences visible to user, nor in the kernel log.
> 
> (In response to Brian's comment:)
> >> However, as per documentation, atomic_add_unless() returns _zero_
> >> if the atomic value was originally equal to the specified *unsless* value.
> >>
> > Nit:                                                         unless
> 
> Thanks very much for feedback. Since it's my very first upstream
> commit-proposal,
> I expected that some polish would be needed.
> 
> 
> > It might be worth pointing out in the commit log that currently isolated
> > buffers end up right back on the LRU once they are released, because
> > ->b_lru_ref remains elevated. Therefore, this patch essentially fixes
> > that circuitous route by leaving them on the LRU as originally intended.
> > Otherwise this looks Ok to me:
> 
> So the final commit message could be:
> ~~~
> Currently the xfs_buftarg_isolate() is causing an xfs_buffer

"Due to an inverted logic mistake in xfs_buftarg_isolate()..."?

> with zero b_lru_ref, to take another trip around LRU, while

                   ^^^^ no need for this comma

> isolating buffers with non-zero b_lru_ref.
> 
> Additionally those isolated buffers end up right back on the LRU
> once they are released, because ->b_lru_ref remains elevated.
> 
> Fix that circuitous route by leaving them on the LRU
> as originally intended.

Otherwise this seems fine to me; can you please resend the patch w/
updated change log and reviewed-by tags?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> >> Signed-off-by: Vratislav Bendel <vbendel@redhat.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > ---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
