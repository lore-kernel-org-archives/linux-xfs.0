Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3AFC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 01:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbiDGCA6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 22:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiDGCA5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 22:00:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5155F8F5
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 18:58:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 03A1ACE25B2
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 01:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659A9C385A1;
        Thu,  7 Apr 2022 01:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649296736;
        bh=9tLhofyY5Bd8Uzabjy2h5l7IFxTTwbzSxlg+Er5E4DE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JyW75qSSc45j54DO7uZPaB86eQCIUwhFbq0sJxmn6rb8/i+xs3xLJoOpHbGPHply4
         IRzUVb07fTdRim8m/fyKyXWZdUQK+BYFwgVK8rZPOBm5VpBnBo8PlPz63GknPsW925
         Vpa8dA6rxkHdEP4IXQk0zbLY1Z8uLo/g7vCNUaAWzYxZcIZ1vTAN33dgGhGLnVGLBK
         zxfLTivkEbo64KuAxQmVyXu63CaLfWvjvD2aAQNs+M6cBWOATatqL4VJA/X/urJbiT
         iWE/tUFVWMH64jwIkQQN6zi2BIHTjIarVkbpO6fH2owCCKdxcjsRodYw4ZH0Jh2Mkp
         mol3vMGKfSZOA==
Date:   Wed, 6 Apr 2022 18:58:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V9 12/19] xfs: Introduce macros to represent new maximum
 extent counts for data/attr forks
Message-ID: <20220407015855.GZ27690@magnolia>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-13-chandan.babu@oracle.com>
 <20220407010544.GC1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407010544.GC1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 07, 2022 at 11:05:44AM +1000, Dave Chinner wrote:
> On Wed, Apr 06, 2022 at 11:48:56AM +0530, Chandan Babu R wrote:
> > This commit defines new macros to represent maximum extent counts allowed by
> > filesystems which have support for large per-inode extent counters.
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c       |  9 ++++-----
> >  fs/xfs/libxfs/xfs_bmap_btree.c |  3 ++-
> >  fs/xfs/libxfs/xfs_format.h     | 24 ++++++++++++++++++++++--
> >  fs/xfs/libxfs/xfs_inode_buf.c  |  4 +++-
> >  fs/xfs/libxfs/xfs_inode_fork.c |  3 ++-
> >  fs/xfs/libxfs/xfs_inode_fork.h | 21 +++++++++++++++++----
> >  6 files changed, 50 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index b317226fb4ba..1254d4d4821e 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -61,10 +61,8 @@ xfs_bmap_compute_maxlevels(
> >  	int		sz;		/* root block size */
> >  
> >  	/*
> > -	 * The maximum number of extents in a file, hence the maximum number of
> > -	 * leaf entries, is controlled by the size of the on-disk extent count,
> > -	 * either a signed 32-bit number for the data fork, or a signed 16-bit
> > -	 * number for the attr fork.
> > +	 * The maximum number of extents in a fork, hence the maximum number of
> > +	 * leaf entries, is controlled by the size of the on-disk extent count.
> >  	 *
> >  	 * Note that we can no longer assume that if we are in ATTR1 that the
> >  	 * fork offset of all the inodes will be
> > @@ -74,7 +72,8 @@ xfs_bmap_compute_maxlevels(
> >  	 * ATTR2 we have to assume the worst case scenario of a minimum size
> >  	 * available.
> >  	 */
> > -	maxleafents = xfs_iext_max_nextents(whichfork);
> > +	maxleafents = xfs_iext_max_nextents(xfs_has_large_extent_counts(mp),
> > +				whichfork);
> >  	if (whichfork == XFS_DATA_FORK)
> >  		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
> >  	else
> 
> Just to confirm, the large extent count feature bit can only be
> added when the filesystem is unmounted?

Yes, because we (currently) don't support /any/ online feature upgrades.
IIRC Chandan said that you'd have to be careful about validating the min
log size requirements are still met because the tx reservation sizes can
change with the taller bmbts.

> > diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> > index 453309fc85f2..7aabeccea9ab 100644
> > --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> > +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> > @@ -611,7 +611,8 @@ xfs_bmbt_maxlevels_ondisk(void)
> >  	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
> >  
> >  	/* One extra level for the inode root. */
> > -	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
> > +	return xfs_btree_compute_maxlevels(minrecs,
> > +			XFS_MAX_EXTCNT_DATA_FORK_LARGE) + 1;
> >  }
> 
> Why is this set to XFS_MAX_EXTCNT_DATA_FORK_LARGE rather than being
> conditional xfs_has_large_extent_counts(mp)? i.e. if the feature bit
> is not set, the maximum on-disk levels in the bmbt is determined by
> XFS_MAX_EXTCNT_DATA_FORK_SMALL, not XFS_MAX_EXTCNT_DATA_FORK_LARGE.

This function (and all the other _maxlevels_ondisk functions) compute
the maximum possible btree height for any filesystem that we'd care to
mount.  This value is then passed to the functions that create the btree
cursor caches, which is why this is independent of any xfs_mount.

That said ... depending on how much this inflates the size of the bmbt
cursor cache, I think we could create multiple slabs.

> The "_ondisk" suffix implies that it has something to do with the
> on-disk format of the filesystem, but AFAICT what we are calculating
> here is a constant used for in-memory structure allocation? There
> needs to be something explained/changed here, because this is
> confusing...

You suggested it. ;)

https://lore.kernel.org/linux-xfs/20211013075743.GG2361455@dread.disaster.area/

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
