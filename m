Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05CBC433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 18:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AB5664DF2
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 18:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhBVSnW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 13:43:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:43870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231490AbhBVSmj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 13:42:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54E9A64E32;
        Mon, 22 Feb 2021 18:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614018466;
        bh=u44ZNNRdsICfOWMaODjhv/Q4W2UkqT1g9FDxN5+GAo8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XpQlOdGchwuSKrBk62RWkd2RTPJZVKg3Mf228m+iAbGxltZGp0HDILfznq3n32KnK
         0SoXIoBvafkbzM563P5CzYswGbeq1el7anDb5/W36QT/QDtZqoPcgZs/xrZILw/Y/Q
         LaKQkTuyJs4u/PocJtX02C6lsuavD3961EUBVz41VWaiw8DuOv4yRJhio1K8Rsont1
         6hJOg4jZD6gp0kFQ4cVl4FLYPHAXV9W5ehkFnAFdzp+6a1vhqMM0ZRJv6SNUoQNgg+
         JdnBg6vwVxUoz3q9KSkuloR/qO4+mgPXnUl7mKxLOkkSvCHuAUmCUGnvsVcUp/IV9E
         czggyyBDigLLA==
Date:   Mon, 22 Feb 2021 10:27:45 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
Message-ID: <20210222182745.GA7272@magnolia>
References: <20210222153442.897089-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222153442.897089-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 22, 2021 at 10:34:42AM -0500, Brian Foster wrote:
> Freed extents are marked busy from the point the freeing transaction
> commits until the associated CIL context is checkpointed to the log.
> This prevents reuse and overwrite of recently freed blocks before
> the changes are committed to disk, which can lead to corruption
> after a crash. The exception to this rule is that metadata
> allocation is allowed to reuse busy extents because metadata changes
> are also logged.
> 
> As of commit 97d3ac75e5e0 ("xfs: exact busy extent tracking"), XFS
> has allowed modification or complete invalidation of outstanding
> busy extents for metadata allocations. This implementation assumes
> that use of the associated extent is imminent, which is not always
> the case. For example, the trimmed extent might not satisfy the
> minimum length of the allocation request, or the allocation
> algorithm might be involved in a search for the optimal result based
> on locality.
> 
> generic/019 reproduces a corruption caused by this scenario. First,
> a metadata block (usually a bmbt or symlink block) is freed from an
> inode. A subsequent bmbt split on an unrelated inode attempts a near
> mode allocation request that invalidates the busy block during the
> search, but does not ultimately allocate it. Due to the busy state
> invalidation, the block is no longer considered busy to subsequent
> allocation. A direct I/O write request immediately allocates the
> block and writes to it.

I really hope there's a fstest case coming for this... :)

> Finally, the filesystem crashes while in a
> state where the initial metadata block free had not committed to the
> on-disk log. After recovery, the original metadata block is in its
> original location as expected, but has been corrupted by the
> aforementioned dio.

Wheee!

Looking at xfs_alloc_ag_vextent_exact, I guess the allocator will go
find a freespace record, call xfs_extent_busy_trim (which could erase
the busy extent entry), decide that it's not interested after all, and
bail out without restoring the busy entry.

Similarly, xfs_alloc_cur_check calls _busy_trim (same side effects) as
we wander around the free space btrees looking for a good chunk of
space... and doesn't restore the busy record if it decides to consider a
different extent.

So I guess this "speculatively remove busy records and forget to restore
them" behavior opens the door to the write allocating blocks that aren't
yet free and nonbusy, right?  And the solution presented here is to
avoid letting go of the busy record for the bmbt allocation, and if the
btree split caller decides it really /must/ have that block for the bmbt
it can force the log and try again, just like we do for a file data
allocation?

Another solution could have been to restore the record if we decide not
to go ahead with the allocation, but as we haven't yet committed to
using the space, there's no sense in thrashing the busy records?

Assuming I got all that right,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> This demonstrates that it is fundamentally unsafe to modify busy
> extent state for extents that are not guaranteed to be allocated.
> This applies to pretty much all of the code paths that currently
> trim busy extents for one reason or another. Therefore to address
> this problem, drop the reuse mechanism from the busy extent trim
> path. This code already knows how to return partial non-busy ranges
> of the targeted free extent and higher level code tracks the busy
> state of the allocation attempt. If a block allocation fails where
> one or more candidate extents is busy, we force the log and retry
> the allocation.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_extent_busy.c | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 3991e59cfd18..ef17c1f6db32 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -344,7 +344,6 @@ xfs_extent_busy_trim(
>  	ASSERT(*len > 0);
>  
>  	spin_lock(&args->pag->pagb_lock);
> -restart:
>  	fbno = *bno;
>  	flen = *len;
>  	rbp = args->pag->pagb_tree.rb_node;
> @@ -363,19 +362,6 @@ xfs_extent_busy_trim(
>  			continue;
>  		}
>  
> -		/*
> -		 * If this is a metadata allocation, try to reuse the busy
> -		 * extent instead of trimming the allocation.
> -		 */
> -		if (!(args->datatype & XFS_ALLOC_USERDATA) &&
> -		    !(busyp->flags & XFS_EXTENT_BUSY_DISCARDED)) {
> -			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
> -							  busyp, fbno, flen,
> -							  false))
> -				goto restart;
> -			continue;
> -		}
> -
>  		if (bbno <= fbno) {
>  			/* start overlap */
>  
> -- 
> 2.26.2
> 
