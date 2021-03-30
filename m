Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6A4C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FEF2619CF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhC3SGn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 14:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232419AbhC3SGU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 14:06:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E655D619B9;
        Tue, 30 Mar 2021 18:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617127580;
        bh=7Cpa77knbjS/A2QqPOSpItOIeALrtCgVZSObzgYaLGQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X42mWEXm11sQTlvNIEWrZnMyVH5Lf+KvWdEk13djORgvjTmEGbMaSZxpdCEZLCbum
         J3DWSUuvm1RyHDQKceNMFjSvPHQwJnatf2HtwCy9a6WDcf4o0Koxx8N+DYt4Tg2Fdm
         AG/5UZLs18Mm1dmAfjygL0icdrQNDRAB78WlBsdYYA+Az2ZKo7GV23Jbq+cMyhj32X
         niWg4aQofy2x0Rk4u6k7YmI2GUN26MIPXHpa81TNkRdf74L1XvueUZQf7gr8NCZPWN
         dtVTLtGSqKgxC7kgU9q9R7xHeZUtYtNW0PclgS7dVn+IkEnkK/anL0Et8VGiqTOU5M
         B0WJ2ImZU2yog==
Date:   Tue, 30 Mar 2021 11:06:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: inode fork allocation depends on XFS_IFEXTENT
 flag
Message-ID: <20210330180617.GR4090233@magnolia>
References: <20210330053059.1339949-1-david@fromorbit.com>
 <20210330053059.1339949-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330053059.1339949-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 04:30:57PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS_IFEXTENT has two incompatible meanings to the code. The first
> meaning is that the fork is in extent format, the second meaning is
> that the extent list has been read into memory.

I don't agree that IFEXTENTS has two meanings.  This is what I
understand of how xfs_ifork fields and surrounding code are supposed to
work; can you point out what's wrong?

 1. xfs_ifork.if_format == XFS_DINODE_FMT_EXTENTS tells us if the fork
    is in extent format.

 2. (xfs_ifork.if_flags & XFS_IFEXTENTS) tells us if the incore extent
    map is initialized.

 3. If we are creating a fork with if_format == EXTENTS, the incore map
    is trivially initialized, and therefore IFEXTENTS should be set
    because no further work is required.

 4. If we are reading an if_format == EXTENTS fork in from disk (during
    xfs_iread), we always populate the incore map and set IFEXTENTS.

 5. If if_format == BTREE and IFEXTENTS is not set, the incore map is
    *not* initialized, and we must call xfs_iread_extents to walk the
    ondisk btree to initialize the incore btree, and to set IFEXTENTS.

 6. xfs_iread_extents requires that if_format == BTREE and will return
    an error and log a corruption report if it sees another fork format.

From points 3 and 4, I conclude that (prior to xfs-5.13-merge) IFEXTENTS
is always set if if_format is FMT_EXTENTS.

From point 6, I conclude that it's not possible for IFEXTENTS not to be
set if if_format is FMT_EXTENTS, because if an inode fork ever ended up
in that state, there would not be any way to escape.

> When the inode fork is in extent format, we automatically read the
> extent list into memory and indexed by the inode extent btree when
> the inode is brought into memory off disk.

Agreed, that's #4 above.

> Hence we set the flag to mean both "in extent format and in memory".

I don't agree.  I think #1 tells us "in extent format" and #2 tells us
"in memory"; and #3 and #4 are how we guarantee that.

> That requires all new
> fork allocations where the default state is "extent format with zero
> extents" to set the XFS_IFEXTENT to indicate we've initialised the
> in-memory state even though we've really done no such thing.

<shrug> IMHO we initialized it trivially, but that's splitting hairs and
doesn't warrant further argument, so I'll move on.

> This fixes a scrub regression because it assumes XFS_IFEXTENT means
> "on disk format" and not "read into memory" and e6a688c33238 assumed
> it mean "read into memory". In reality, the XFS_IFEXTENT flag needs
> to be split up into two flags - one for the on disk fork format and
> one for the in-memory "extent btree has been populated" state.

Let's look at the relevant code in xchk_bmap(), since I wrote that
function:

	/* Check the fork values */
	switch (ifp->if_format) {
	...
	case XFS_DINODE_FMT_EXTENTS:
		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
			xchk_fblock_set_corrupt(sc, whichfork, 0);
			goto out;
		}
		break;

The switch statement checks the format (#1), and the flag test checks
that the incore state (#3 and #4) hold true.  Perhaps it was unwise of
scrub to check *incore* state flags here, but as of the time the code
was written, it was always the case that FMT_EXTENTS and IFEXTENTS went
together.  Setting SCRUB_OFLAG_CORRUPT is how scrub signals that
something is wrong and administrator intervention is needed.

I agree with the code fix, but not with the justification.

--D

> Fixes: e6a688c33238 ("xfs: initialise attr fork on inode create")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 1 -
>  fs/xfs/libxfs/xfs_inode_fork.c | 9 +++++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 5574d345d066..2f72849c05f9 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1095,7 +1095,6 @@ xfs_bmap_add_attrfork(
>  	ASSERT(ip->i_afp == NULL);
>  
>  	ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
> -	ip->i_afp->if_flags = XFS_IFEXTENTS;
>  	logflags = 0;
>  	switch (ip->i_df.if_format) {
>  	case XFS_DINODE_FMT_LOCAL:
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 1851d6f266d0..03e1a21848eb 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -292,6 +292,15 @@ xfs_ifork_alloc(
>  	ifp = kmem_cache_zalloc(xfs_ifork_zone, GFP_NOFS | __GFP_NOFAIL);
>  	ifp->if_format = format;
>  	ifp->if_nextents = nextents;
> +
> +	/*
> +	 * If this is a caller initialising a newly created fork, we need to
> +	 * set XFS_IFEXTENTS to indicate the fork state is completely up to
> +	 * date. Otherwise it is up to the caller to initialise the in-memory
> +	 * state of the inode fork from the on-disk state.
> +	 */
> +	if (format == XFS_DINODE_FMT_EXTENTS && nextents == 0)
> +		ifp->if_flags |= XFS_IFEXTENTS;
>  	return ifp;
>  }
>  
> -- 
> 2.31.0
> 
