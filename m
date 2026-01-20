Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CDE33439F;
	Tue, 20 Jan 2026 17:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768930020; cv=none; b=Zx7JAxDOwgles5SWlSabgAqJ9u/ZttSGkOZR7ugABLvLwlzmd0Qc5PRJIR6ZuhHm4lgeqiCZAHtQu6lgCjoX4/wLpvkKv900+DdFpHmmh/kBm2ia4XP2isWFWpQBV7ZsFNBbeoV/y6lzVsvUwRN9Byr1rdXFCmPfAw3xdVwP1o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768930020; c=relaxed/simple;
	bh=bc9vokYqyjabIGtTQIBJIXCFeY5ewweEqWg1TjCb27A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jihvTaBUPPok04mnaSdYKzqa2nfxKcYrB/GMW5Gz/h591yy/XeewWhnumPhHtnJbVe2Imo4e7312besmNeDbOSX64h3/phKL1GTzXbevjYaU7MG+KRTVDFvspFmrtq5SbXINnr5FYikE10gMoCU/cUr32w15VdWtFH8NnLZjMGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FYsT7x58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FYsT7x58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8117C16AAE;
	Tue, 20 Jan 2026 17:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768930020;
	bh=bc9vokYqyjabIGtTQIBJIXCFeY5ewweEqWg1TjCb27A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FYsT7x58kimq/jRPuq+W7AWYsEzNI1Ctiv+YFo2IzrzLION8Ada5lXUnMvl59uht/
	 jhfI6N6vkDD24p8VGh3TH39Gp5V4VTgeUpkY83OPyY5EMZWgQq9TbNDmzHXG50Bqn5
	 4mLj+C/C5tyNO+5JHD41g+49CVdk+AkT0bv9JLJ+KaiYBAt03KfuVvx3cdCcwrJIy0
	 66VShfBsfVYbShV7C6dbHuhMyUX0WHmhwnexU5BElx5UgiQjzcyTvde77JhGorRWMT
	 JSjambYHWMOX82hTu7wF8JtwmBBwY8+oVRNcyHTP3jghMfW36cm99Vjnvn7lhsAs+i
	 L2q48nshwZsrA==
Date: Tue, 20 Jan 2026 09:26:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH 6.12.y] xfs: set max_agbno to allow sparse alloc of last
 full inode chunk
Message-ID: <20260120172659.GR15551@frogsfrogsfrogs>
References: <2026012006-doorway-print-237d@gregkh>
 <20260120164038.137155-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120164038.137155-1-bfoster@redhat.com>

On Tue, Jan 20, 2026 at 11:40:38AM -0500, Brian Foster wrote:
> Sparse inode cluster allocation sets min/max agbno values to avoid
> allocating an inode cluster that might map to an invalid inode
> chunk. For example, we can't have an inode record mapped to agbno 0
> or that extends past the end of a runt AG of misaligned size.
> 
> The initial calculation of max_agbno is unnecessarily conservative,
> however. This has triggered a corner case allocation failure where a
> small runt AG (i.e. 2063 blocks) is mostly full save for an extent
> to the EOFS boundary: [2050,13]. max_agbno is set to 2048 in this
> case, which happens to be the offset of the last possible valid
> inode chunk in the AG. In practice, we should be able to allocate
> the 4-block cluster at agbno 2052 to map to the parent inode record
> at agbno 2048, but the max_agbno value precludes it.
> 
> Note that this can result in filesystem shutdown via dirty trans
> cancel on stable kernels prior to commit 9eb775968b68 ("xfs: walk
> all AGs if TRYLOCK passed to xfs_alloc_vextent_iterate_ags") because
> the tail AG selection by the allocator sets t_highest_agno on the
> transaction. If the inode allocator spins around and finds an inode
> chunk with free inodes in an earlier AG, the subsequent dir name
> creation path may still fail to allocate due to the AG restriction
> and cancel.
> 
> To avoid this problem, update the max_agbno calculation to the agbno
> prior to the last chunk aligned agbno in the AG. This is not
> necessarily the last valid allocation target for a sparse chunk, but
> since inode chunks (i.e. records) are chunk aligned and sparse
> allocs are cluster sized/aligned, this allows the sb_spino_align
> alignment restriction to take over and round down the max effective
> agbno to within the last valid inode chunk in the AG.
> 
> Note that even though the allocator improvements in the
> aforementioned commit seem to avoid this particular dirty trans
> cancel situation, the max_agbno logic improvement still applies as
> we should be able to allocate from an AG that has been appropriately
> selected. The more important target for this patch however are
> older/stable kernels prior to this allocator rework/improvement.
> 
> Cc: stable@vger.kernel.org # v4.2
> Fixes: 56d1115c9bc7 ("xfs: allocate sparse inode chunks on full chunk allocation failure")
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Carlos Maiolino <cem@kernel.org>
> (cherry picked from commit c360004c0160dbe345870f59f24595519008926f)
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks like a correct backport to me,
Acked-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 6258527315f2..8223464e23e7 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -850,15 +850,16 @@ xfs_ialloc_ag_alloc(
>  		 * invalid inode records, such as records that start at agbno 0
>  		 * or extend beyond the AG.
>  		 *
> -		 * Set min agbno to the first aligned, non-zero agbno and max to
> -		 * the last aligned agbno that is at least one full chunk from
> -		 * the end of the AG.
> +		 * Set min agbno to the first chunk aligned, non-zero agbno and
> +		 * max to one less than the last chunk aligned agbno from the
> +		 * end of the AG. We subtract 1 from max so that the cluster
> +		 * allocation alignment takes over and allows allocation within
> +		 * the last full inode chunk in the AG.
>  		 */
>  		args.min_agbno = args.mp->m_sb.sb_inoalignmt;
>  		args.max_agbno = round_down(xfs_ag_block_count(args.mp,
>  							pag->pag_agno),
> -					    args.mp->m_sb.sb_inoalignmt) -
> -				 igeo->ialloc_blks;
> +					    args.mp->m_sb.sb_inoalignmt) - 1;
>  
>  		error = xfs_alloc_vextent_near_bno(&args,
>  				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
> -- 
> 2.52.0
> 
> 
