Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527EFC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Oct 2023 21:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjJaVYG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Oct 2023 17:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjJaVYG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2023 17:24:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E36B9
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2023 14:24:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEAAC433C8;
        Tue, 31 Oct 2023 21:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698787443;
        bh=yG0llj7B9GeXoCpO0cfyCJwVNpkXJehxqfb24+EQQkk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NAfFKZgcW/xCDDeJeaJBNbpdonPzwuWtaHi8k81xgk1xA9g7klJYdbP0vJ6TMNuiU
         KPaZF8EuSH+sc86VXvF1qeeTUfs754rJCl1COCYwHCICVlYcyCYFvNzKxRo+EdL3ql
         NdcczPzHgYw5y+my+5s7ZIZ/QKfbGJWu4tJauOnMYE38dStUXCbbHvh0uK0jJ2hw5A
         WFGhFf221iUgq/2s+9HBrevAtlVzAcBHdlisZRrRuv9yIbU1joN3a1Zvjy8dIbW+Ns
         07hk0b/s4rKrQdKTM19B99V3bbjXnTNSHVeP8YY+7PPJHw1L0obzXd2r6QZMVaF9a1
         jKDRC6B7Hrn6g==
Date:   Tue, 31 Oct 2023 14:24:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, kernel-team@fb.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2] xfs: fix internal error from AGFL exhaustion
Message-ID: <20231031212400.GA1205143@frogsfrogsfrogs>
References: <68cd85697855f686529829a2825b044913148caf.1698699188.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68cd85697855f686529829a2825b044913148caf.1698699188.git.osandov@fb.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 30, 2023 at 02:00:02PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> We've been seeing XFS errors like the following:
> 
> XFS: Internal error i != 1 at line 3526 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_insert+0x1ec/0x280
> ...
> Call Trace:
>  xfs_corruption_error+0x94/0xa0
>  xfs_btree_insert+0x221/0x280
>  xfs_alloc_fixup_trees+0x104/0x3e0
>  xfs_alloc_ag_vextent_size+0x667/0x820
>  xfs_alloc_fix_freelist+0x5d9/0x750
>  xfs_free_extent_fix_freelist+0x65/0xa0
>  __xfs_free_extent+0x57/0x180
> ...
> 
> This is the XFS_IS_CORRUPT() check in xfs_btree_insert() when
> xfs_btree_insrec() fails.
> 
> After converting this into a panic and dissecting the core dump, I found
> that xfs_btree_insrec() is failing because it's trying to split a leaf
> node in the cntbt when the AG free list is empty. In particular, it's
> failing to get a block from the AGFL _while trying to refill the AGFL_.
> 
> If a single operation splits every level of the bnobt and the cntbt (and
> the rmapbt if it is enabled) at once, the free list will be empty. Then,
> when the next operation tries to refill the free list, it allocates
> space. If the allocation does not use a full extent, it will need to
> insert records for the remaining space in the bnobt and cntbt. And if
> those new records go in full leaves, the leaves (and potentially more
> nodes up to the old root) need to be split.
> 
> Fix it by accounting for the additional splits that may be required to
> refill the free list in the calculation for the minimum free list size.
> 
> P.S. As far as I can tell, this bug has existed for a long time -- maybe
> back to xfs-history commit afdf80ae7405 ("Add XFS_AG_MAXLEVELS macros
> ...") in April 1994! It requires a very unlucky sequence of events, and
> in fact we didn't hit it until a particular sparse mmap workload updated
> from 5.12 to 5.19. But this bug existed in 5.12, so it must've been
> exposed by some other change in allocation or writeback patterns. It's
> also much less likely to be hit with the rmapbt enabled, since that
> increases the minimum free list size and is unlikely to split at the
> same time as the bnobt and cntbt.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Changes since v1 [1]:
> 
> - Updated calculation to account for internal nodes that may also need
>   to be split.
> - Updated comments and commit message accordingly.
> 
> 1: https://lore.kernel.org/linux-xfs/ZTrSiwF7OAq0hJHn@dread.disaster.area/T/
> 
>  fs/xfs/libxfs/xfs_alloc.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 3069194527dd..3949c6ad0cce 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2275,16 +2275,35 @@ xfs_alloc_min_freelist(
>  
>  	ASSERT(mp->m_alloc_maxlevels > 0);
>  
> +	/*
> +	 * For a btree shorter than the maximum height, the worst case is that
> +	 * every level gets split and a new level is added, then while inserting
> +	 * another entry to refill the AGFL, every level under the old root gets
> +	 * split again. This is:
> +	 *
> +	 *   (current height + 1) + (current height - 1)

Could you make this comment define this relationship more explicitly?

	 *   (full height split reservation) + (AGFL refill split height)
	 *   (current height + 1) + (current height - 1)

With that added,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +	 * = (new height)         + (new height - 2)
> +	 * = 2 * new height - 2
> +	 *
> +	 * For a btree of maximum height, the worst case is that every level
> +	 * under the root gets split, then while inserting another entry to
> +	 * refill the AGFL, every level under the root gets split again. This is
> +	 * also:
> +	 *
> +	 *   2 * (new_height - 1)
> +	 * = 2 * new height - 2
> +	 */
> +
>  	/* space needed by-bno freespace btree */
>  	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
> -				       mp->m_alloc_maxlevels);
> +				       mp->m_alloc_maxlevels) * 2 - 2;
>  	/* space needed by-size freespace btree */
>  	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
> -				       mp->m_alloc_maxlevels);
> +				       mp->m_alloc_maxlevels) * 2 - 2;
>  	/* space needed reverse mapping used space btree */
>  	if (xfs_has_rmapbt(mp))
>  		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
> -						mp->m_rmap_maxlevels);
> +						mp->m_rmap_maxlevels) * 2 - 2;
>  
>  	return min_free;
>  }
> -- 
> 2.41.0
> 
