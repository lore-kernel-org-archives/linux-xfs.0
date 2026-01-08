Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA6B296BBF
	for <linux-xfs@vger.kernel.org>; Thu,  8 Jan 2026 17:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767892249; cv=none; b=q0bBz+KmALLbq9UJPuIf2p1aGWcoGUPbPduOK8PU2WHZochPcDuhZKjM/tWqAh6SAd9fvEhAX8qB7D6Ot2QNorOF55VMYHNetw4pnzmAgo7zzSHP0xHf8HWpheO6LlDSfq8BHMWkapu40uHuaPdU4RrOllBNdcC8AuScnCGR9LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767892249; c=relaxed/simple;
	bh=yYSExh2s70xVIIdothzVOmPw+VUAQEokN+qrCZNF4cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQB3rxY8yKwqoU14Tni1FDs23ymWbbviB0bVB5Einm91jk2ayTyu3oEqzEhMCDr/62C00r1cH/4O7L/qyf+xQ48kxaEW3LV3QcOdFOmpM5wUeHsa2pHx7OBK0OY7mqD5EAxy4VaHktIy7ZJtm3IOc4/ulRKqTbjCXw0LjLY4Nls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fiZ9imDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fiZ9imDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1B5C116C6;
	Thu,  8 Jan 2026 17:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892247;
	bh=yYSExh2s70xVIIdothzVOmPw+VUAQEokN+qrCZNF4cs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fiZ9imDxjYPTyQ0gv2OzfQW6pu6NQaxulfakO6a1Pq637MMlsawdEHyMp61BjhR/O
	 pvWFsSELTg5Dc1EVVEJZ4WoXJR3V0DKgTPMK4m85dHJ/kL887gqLbNxJ0yKlNTWJVX
	 yV3zAQM9+hqH49EGFzP8nqPSFhk9tKnV9HPvaZ/hQ8JBQCF8A7oxdAQuwfDYgUVqas
	 nY1wf4C6hIulbeRU1b/BReWWPw7eNNqTN5+8LKpa5kkcp+Lu62bRJ257+njt+uCFwW
	 02ZOB36nRFQ91AzAiWPs8LUzRjQFMWCJ6FncDjYVvMg/zxstm6wNQsf3Rb96/4NYmo
	 tJQVnUdbHEyBQ==
Date: Thu, 8 Jan 2026 09:10:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: set max_agbno to allow sparse alloc of last full
 inode chunk
Message-ID: <20260108171047.GL15551@frogsfrogsfrogs>
References: <20260108141129.7765-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108141129.7765-1-bfoster@redhat.com>

On Thu, Jan 08, 2026 at 09:11:29AM -0500, Brian Foster wrote:
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

<nod> It makes sense to me that we ought to be able to examine space out
to the final(ish) agbno of the runt AG.

Question for you: There are 16 holemask bits for 64 inodes per inobt
record, or in other words the new allocation has to be aligned at least
to the number of blocks needed to write 4 inodes.  I /think/
sb_spino_align reflects that, right?

> Fixes: 56d1115c9bc7 ("xfs: allocate sparse inode chunks on full chunk allocation failure")

Cc: <stable@vger.kernel.org> # v4.2

--D

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index d97295eaebe6..c19d6d713780 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -848,15 +848,16 @@ xfs_ialloc_ag_alloc(
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
>  							pag_agno(pag)),
> -					    args.mp->m_sb.sb_inoalignmt) -
> -				 igeo->ialloc_blks;
> +					    args.mp->m_sb.sb_inoalignmt) - 1;
>  
>  		error = xfs_alloc_vextent_near_bno(&args,
>  				xfs_agbno_to_fsb(pag,
> -- 
> 2.52.0
> 
> 
