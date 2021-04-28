Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FAD8C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E719613ED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhD1EPz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 00:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhD1EPy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:15:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D4F7613FF;
        Wed, 28 Apr 2021 04:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619583310;
        bh=tr3RiEkYUpXM0cW8jK6LjLFqHkkIURxZQlz7091I7Sw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vQu5kofmdeukixE/zMm7Yir71aiZ+Z7SoG8Xn83xeQDwVLKuraZenjVpeQQ58J849
         QaSIe+a0WhT6Wr0T3vqndiDHGAzNrCuudyF0frIzj6hdYMy+WM+tC0KMkjra259vqU
         Zz/hqTvTrzXIEw5/zuugBV74uDdXZzOy/yL0uUXMgRug1/d2ByxL52pwWNlXHaRejD
         8N5LpOq6GemD9pDvfRKVwxBNN+QWIqvCvQUmEtcLdt7W9AkAXiGARCc0Qx/HOnLUZp
         Crq+4FdNtne26gpCFm9tGErMtJ5GI6kvvIvtxLBs6fxoWPgFJK+H+UxMWek9ZS5tG5
         fuSYEgdM8JDGQ==
Date:   Tue, 27 Apr 2021 21:15:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 2/3] xfs: introduce in-core global counter of allocbt
 blocks
Message-ID: <20210428041509.GH3122264@magnolia>
References: <20210423131050.141140-1-bfoster@redhat.com>
 <20210423131050.141140-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423131050.141140-3-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 23, 2021 at 09:10:49AM -0400, Brian Foster wrote:
> Introduce an in-core counter to track the sum of all allocbt blocks
> used by the filesystem. This value is currently tracked per-ag via
> the ->agf_btreeblks field in the AGF, which also happens to include
> rmapbt blocks. A global, in-core count of allocbt blocks is required
> to identify the subset of global ->m_fdblocks that consists of
> unavailable blocks currently used for allocation btrees. To support
> this calculation at block reservation time, construct a similar
> global counter for allocbt blocks, populate it on first read of each
> AGF and update it as allocbt blocks are used and released.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c       | 12 ++++++++++++
>  fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
>  fs/xfs/xfs_mount.h              |  6 ++++++
>  3 files changed, 20 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index aaa19101bb2a..144e2d68245c 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3036,6 +3036,7 @@ xfs_alloc_read_agf(
>  	struct xfs_agf		*agf;		/* ag freelist header */
>  	struct xfs_perag	*pag;		/* per allocation group data */
>  	int			error;
> +	uint32_t		allocbt_blks;
>  
>  	trace_xfs_alloc_read_agf(mp, agno);
>  
> @@ -3066,6 +3067,17 @@ xfs_alloc_read_agf(
>  		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
>  		pag->pagf_init = 1;
>  		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
> +
> +		/*
> +		 * Update the global in-core allocbt block counter. Filter
> +		 * rmapbt blocks from the on-disk counter because those are
> +		 * managed by perag reservation.
> +		 */
> +		if (pag->pagf_btreeblks > be32_to_cpu(agf->agf_rmap_blocks)) {

As pointed out elsewhere in the thread, agf_rmap_blocks counts the total
number of blocks in the rmapbt (whereas agf_btreeblks counts the number
of non-root blocks in all three free space btrees).  Does this need a
change?

	int delta = (int)pag->pagf_btreeblks - (be32_to_cpu(...) - 1);
	if (delta > 0)
		atomic64_add(delta, &mp->m_allocbt_blks);

--D

> +			allocbt_blks = pag->pagf_btreeblks -
> +					be32_to_cpu(agf->agf_rmap_blocks);
> +			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
> +		}
>  	}
>  #ifdef DEBUG
>  	else if (!XFS_FORCED_SHUTDOWN(mp)) {
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 8e01231b308e..9f5a45f7baed 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -71,6 +71,7 @@ xfs_allocbt_alloc_block(
>  		return 0;
>  	}
>  
> +	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
>  	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1, false);
>  
>  	xfs_trans_agbtree_delta(cur->bc_tp, 1);
> @@ -95,6 +96,7 @@ xfs_allocbt_free_block(
>  	if (error)
>  		return error;
>  
> +	atomic64_dec(&cur->bc_mp->m_allocbt_blks);
>  	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
>  			      XFS_EXTENT_BUSY_SKIP_DISCARD);
>  	xfs_trans_agbtree_delta(cur->bc_tp, -1);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 81829d19596e..bb67274ee23f 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -170,6 +170,12 @@ typedef struct xfs_mount {
>  	 * extents or anything related to the rt device.
>  	 */
>  	struct percpu_counter	m_delalloc_blks;
> +	/*
> +	 * Global count of allocation btree blocks in use across all AGs. Only
> +	 * used when perag reservation is enabled. Helps prevent block
> +	 * reservation from attempting to reserve allocation btree blocks.
> +	 */
> +	atomic64_t		m_allocbt_blks;
>  
>  	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
>  	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
> -- 
> 2.26.3
> 
