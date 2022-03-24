Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD6BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 05:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346218AbiCXF7r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 01:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347381AbiCXF7q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 01:59:46 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B4497C161
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 22:58:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BEDE810E51FA;
        Thu, 24 Mar 2022 16:58:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nXGU7-009CRG-Sg; Thu, 24 Mar 2022 16:58:11 +1100
Date:   Thu, 24 Mar 2022 16:58:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: document the XFS_ALLOC_AGFL_RESERVE constant
Message-ID: <20220324055811.GB1544202@dread.disaster.area>
References: <164779460699.550479.5112721232994728564.stgit@magnolia>
 <164779461278.550479.17511700626088235894.stgit@magnolia>
 <20220323203916.GU1544202@dread.disaster.area>
 <20220324051542.GR8241@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324051542.GR8241@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=623c0876
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=nL-kbA5hzPAI5XtuF5AA:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 23, 2022 at 10:15:42PM -0700, Darrick J. Wong wrote:
> On Thu, Mar 24, 2022 at 07:39:16AM +1100, Dave Chinner wrote:
> > On Sun, Mar 20, 2022 at 09:43:32AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Currently, we use this undocumented macro to encode the minimum number
> > > of blocks needed to replenish a completely empty AGFL when an AG is
> > > nearly full.  This has lead to confusion on the part of the maintainers,
> > > so let's document what the value actually means, and move it to
> > > xfs_alloc.c since it's not used outside of that module.
> > 
> > Code change looks fine, but....
> > 
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_alloc.c |   23 ++++++++++++++++++-----
> > >  fs/xfs/libxfs/xfs_alloc.h |    1 -
> > >  2 files changed, 18 insertions(+), 6 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > index 353e53b892e6..b0678e96ce61 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > @@ -82,6 +82,19 @@ xfs_prealloc_blocks(
> > >  }
> > >  
> > >  /*
> > > + * The number of blocks per AG that we withhold from xfs_mod_fdblocks to
> > > + * guarantee that we can refill the AGFL prior to allocating space in a nearly
> > > + * full AG.  We require two blocks per free space btree because free space
> > > + * btrees shrink to a single block as the AG fills up, and any allocation can
> > > + * cause a btree split.  The rmap btree uses a per-AG reservation to withhold
> > > + * space from xfs_mod_fdblocks, so we do not account for that here.
> > > + */
> > > +#define XFS_ALLOCBT_AGFL_RESERVE	4
> > 
> > .... that comment is not correct.  this number had nothing to do
> > with btree split reservations and is all about preventing
> > oversubscription of the AG when the free space trees are completely
> > empty.  By the time there is enough free space records in the AG for
> > the bno/cnt trees to be at risk of a single level root split
> > (several hundred free extent records), there is enough free space to
> > fully allocate the 4 blocks that the AGFL needs for that split.
> > 
> > That is, the set aside was designed to prevent AG selection in
> > xfs_alloc_vextent() having xfs_alloc_fixup_freelist() modifying an
> > AG to fix up the AGFL and then fail to fully fill the AGFL because,
> > say, there were only 2 blocks free in the AG and the AGFL needed 3.
> > Then we try all other AGs and get ENOSPC from all of them, and we
> > end up cancelling a dirty transaction and shutting down instead of
> > propagating ENOSPC up to the user.
> > 
> > This "not enough blocks to populate the AGFL" problem arose because
> > we can allocate extents directly from the AGFL if the free space
> > btree is empty, resulting in depletion of the AGFL and no free space
> > to re-populate it. Freeing a block will then go back into the btree,
> > and so the next allocation attempt might need 2 blocks for the AGFL,
> > have one block in the free space tree, and then we fail to fill
> > the AGFL completely because we still need one block for the AGFL and
> > there's no space available anymore. If all other AGs are like this
> > or ENOSPC, then kaboom.
> > 
> > IOWs, I originally added this per-ag set aside so that when the AG
> > was almost completely empty and we were down to allocating the last
> > blocks from the AG, users couldn't oversubscribe global free space by
> > consuming the blocks the AGs required to fill the AGFLs to allow the
> > last blocks that users could allocate to be allocated safely.
> > 
> > Hence the set aside of 4 blocks per AG was not to ensure the
> > freespace trees could be split, but to ensure every last possible
> > block could be allocated from the AG without causing the AG
> > selection algorithms to select and modify AGs that could not have
> > their AGFL fully fixed up to allocate the blocks that the caller
> > needed when near ENOSPC...
> 
> Hmmm, thanks for the context!  What do you think about this revised
> comment?
> 
> /*
>  * The number of blocks per AG that we withhold from xfs_mod_fdblocks to
>  * guarantee that we can refill the AGFL prior to allocating space in a
>  * nearly full AG.  Although the the space described in the free space
>  * btrees, the freesp btrees, and the blocks owned by the agfl are all
>  * added to the ondisk fdblocks, it's a mistake to let the ondisk free
>  * space in the AG drop so low that the free space btrees cannot refill
>  * an empty AGFL up to the minimum level.  Rather than grind through
>  * empty AGs until the fs goes down, we subtract this many AG blocks
>  * from the incore fdblocks to ENOSPC early.

s/ENOSPC early./ensure user allocation does not overcommit the space
the filesystem needs for the AGFLs./

And it's all good by me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
