Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12475C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 23:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiKBXxT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 19:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKBXxT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 19:53:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663912628
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 16:53:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0148D614D6
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 23:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBF2C433C1;
        Wed,  2 Nov 2022 23:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667433197;
        bh=5cpt5N+2idGygop6eaUYYzcLmvuz4xZQZdngQR+Rkws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AA2ijEX4qIKEWeqNKEhvdKWvCW3Nh7iJKmjcStDpMhRJyMR7x55+VyN5RjUeq+bUZ
         IyK5dRi/KrjL3hgo7DNBCG0wfjFqR3mdLh7vrpT4vumkl4BYrI+et0K2MMa1R0F+WJ
         cbrIzg5r8NX5iAs1yInmLa5ZgxcaWapfN03bR7JAC67UPycpmxdcK3zpGtxrxn09Qg
         +9bo47chOsABtA7C23ail/nJIyD8D2YWDvLJiJuQYXnO//jlbW0DGrnynZMAINBMIx
         w91t44z/4J3zMPVYpV4fkReBs4py14hqsbqu50VqgmypoZuhjU53F1o7uX8oWhRJ3t
         37ca23pgkEJiQ==
Date:   Wed, 2 Nov 2022 16:53:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix rmap key comparison functions
Message-ID: <Y2MC7O6rSMcBec2Y@magnolia>
References: <166473481246.1084112.5533985608121370791.stgit@magnolia>
 <166473481263.1084112.1077820948503334734.stgit@magnolia>
 <20221101234022.GO3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101234022.GO3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 02, 2022 at 10:40:22AM +1100, Dave Chinner wrote:
> On Sun, Oct 02, 2022 at 11:20:12AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Keys for extent interval records in the reverse mapping btree are
> > supposed to be computed as follows:
> > 
> > (physical block, owner, fork, is_btree, offset)
> > 
> > This provides users the ability to look up a reverse mapping from a file
> > block mapping record -- start with the physical block; then if there are
> > multiple records for the same block, move on to the owner; then the
> > inode fork type; and so on to the file offset.
> > 
> > However, the key comparison functions incorrectly remove the fork/bmbt
> > information that's encoded in the on-disk offset.  This means that
> > lookup comparisons are only done with:
> > 
> > (physical block, owner, offset)
> > 
> > This means that queries can return incorrect results.  On consistent
> > filesystems this isn't an issue because bmbt blocks and blocks mapped to
> > an attr fork cannot be shared, but this prevents us from detecting
> > incorrect fork and bmbt flag bits in the rmap btree.
> > 
> > A previous version of this patch forgot to keep the (un)written state
> > flag masked during the comparison and caused a major regression in
> > 5.9.x since unwritten extent conversion can update an rmap record
> > without requiring key updates.
> > 
> > Note that blocks cannot go directly from data fork to attr fork without
> > being deallocated and reallocated, nor can they be added to or removed
> > from a bmbt without a free/alloc cycle, so this should not cause any
> > regressions.
> > 
> > Found by fuzzing keys[1].attrfork = ones on xfs/371.
> > 
> > Fixes: 4b8ed67794fe ("xfs: add rmap btree operations")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_rmap_btree.c |   25 +++++++++++++++++--------
> >  1 file changed, 17 insertions(+), 8 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> > index 7f83f62e51e0..e2e1f68cedf5 100644
> > --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> > +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> > @@ -219,6 +219,15 @@ xfs_rmapbt_init_ptr_from_cur(
> >  	ptr->s = agf->agf_roots[cur->bc_btnum];
> >  }
> >  
> > +/*
> > + * Fork and bmbt are significant parts of the rmap record key, but written
> > + * status is merely a record attribute.
> > + */
> > +static inline uint64_t offset_keymask(uint64_t offset)
> > +{
> > +	return offset & ~XFS_RMAP_OFF_UNWRITTEN;
> > +}
> 
> Ok. but doesn't that mean xfs_rmapbt_init_key_from_rec() and
> xfs_rmapbt_init_high_key_from_rec() should be masking out the
> XFS_RMAP_OFF_UNWRITTEN bit as well?

It ought to, but it might be too late for that because
_init_*key_from_rec have been letting the unwritten bit slip into the
rmap key structures since 4.8.  Somewhere out there is a filesystem with
rmapbt node blocks containing struct xfs_rmap_key's with that unwritten
bit set.  The best we can do is ignore it in the key comparison
function.

Let me think about this overnight though, because once we stop paying
attention to the unwritten bit for key comparisons, it might not matter
what's in the ondisk node blocks.

--D

> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
