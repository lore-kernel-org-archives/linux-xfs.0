Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38776 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbfEGW4k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 May 2019 18:56:40 -0400
Subject: Re: [PATCH] xfs: don't reserve per-AG space for an internal log
References: <20190507154754.GU5207@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e969e2fb-3cc1-0843-5bbc-ab5947c317d7@sandeen.net>
Date: Tue, 7 May 2019 17:56:39 -0500
MIME-Version: 1.0
In-Reply-To: <20190507154754.GU5207@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On 5/7/19 10:47 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> It turns out that the log can consume nearly all the space in an AG, and
> when this happens this it's possible that there will be less free space
> in the AG than the reservation would try to hide.  On a debug kernel
> this can trigger an ASSERT in xfs/250:
> 
> XFS: Assertion failed: xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved + xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <= pag->pagf_freeblks + pag->pagf_flcount, file: fs/xfs/libxfs/xfs_ag_resv.c, line: 319
> 
> The log is permanently allocated, so we know we're never going to have
> to expand the btrees to hold any records associated with the log space.
> We therefore can treat the space as if it doesn't exist.

Neato.

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |    9 +++++++++
>  fs/xfs/libxfs/xfs_refcount_btree.c |    9 +++++++++
>  fs/xfs/libxfs/xfs_rmap_btree.c     |    9 +++++++++
>  3 files changed, 27 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 1080381ff243..bc2dfacd2f4a 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -549,6 +549,15 @@ xfs_inobt_max_size(
>  	if (mp->m_inobt_mxr[0] == 0)
>  		return 0;
>  
> +	/*
> +	 * The log is permanently allocated, so the space it occupies will
> +	 * never be available for the kinds of things that would require btree
> +	 * expansion.  We therefore can pretend the space isn't there.
> +	 */
> +	if (mp->m_sb.sb_logstart &&
> +	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == agno)
> +		agblocks -= mp->m_sb.sb_logblocks;
> +

So we started agblocks at xfs_ag_block_count, and I wondered if we should roll
this adjustment into that function, but no - most callers really want to know
how many blocks are in it, not how many are available for use as we do here.

This looks right to me,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

>  	return xfs_btree_calc_size(mp->m_inobt_mnr,
>  				(uint64_t)agblocks * mp->m_sb.sb_inopblock /
>  					XFS_INODES_PER_CHUNK);
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 6f47ab876d90..5d9de9b21726 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -427,6 +427,15 @@ xfs_refcountbt_calc_reserves(
>  	tree_len = be32_to_cpu(agf->agf_refcount_blocks);
>  	xfs_trans_brelse(tp, agbp);
>  
> +	/*
> +	 * The log is permanently allocated, so the space it occupies will
> +	 * never be available for the kinds of things that would require btree
> +	 * expansion.  We therefore can pretend the space isn't there.
> +	 */
> +	if (mp->m_sb.sb_logstart &&
> +	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == agno)
> +		agblocks -= mp->m_sb.sb_logblocks;
> +
>  	*ask += xfs_refcountbt_max_size(mp, agblocks);
>  	*used += tree_len;
>  
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index 5738e11055e6..5d1f8884c888 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -578,6 +578,15 @@ xfs_rmapbt_calc_reserves(
>  	tree_len = be32_to_cpu(agf->agf_rmap_blocks);
>  	xfs_trans_brelse(tp, agbp);
>  
> +	/*
> +	 * The log is permanently allocated, so the space it occupies will
> +	 * never be available for the kinds of things that would require btree
> +	 * expansion.  We therefore can pretend the space isn't there.
> +	 */
> +	if (mp->m_sb.sb_logstart &&
> +	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == agno)
> +		agblocks -= mp->m_sb.sb_logblocks;
> +
>  	/* Reserve 1% of the AG or enough for 1 block per record. */
>  	*ask += max(agblocks / 100, xfs_rmapbt_max_size(mp, agblocks));
>  	*used += tree_len;
> 
