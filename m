Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B1030B535
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 21:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760475849; cv=none; b=Vb1gJs0YVeR5nh3WFRfrrMK5fkoGhxXocwS0siR7SqVqQeSJuax0C61fSGfS51Syl56XMS4nfgZUlE4J6a6SuSa5SbRwusq/pQ75EL4gE91THjQo/ZBUWf5buwVm8znJS74uqExn5xRkaD0c79B+Q7el/30AuxtgN8NHCtJ4RCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760475849; c=relaxed/simple;
	bh=7F84UB/wOAVzbYoLhR/QLzxALIfrhhT9J8300HHcVJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PDs5NoTfn55J5qLx8TufmkxTbMCmjMpt4cjDyx34+Pi9FQFnOmzr1US0ydbB6oyi899aTCXQADlhxbw20vSuD1dFIIOpuPctPLtXiTT6TetdcxC30lJav4TzgMlIXCjyH7RPVLAcRFzXsP902TcsgCRTCb3lpFwAqej0/iahCgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rOXUo45B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rOXUo45B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B88C4CEE7;
	Tue, 14 Oct 2025 21:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760475847;
	bh=7F84UB/wOAVzbYoLhR/QLzxALIfrhhT9J8300HHcVJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rOXUo45BqoGVjHuJJlKcYj5YjhKYDn51ct1tgyfZd1JxbDOHK3PMdX0jT5h+H2F3t
	 v8J1JN+MayTeUdroYLLuzKZJIfpyTxXDUAsQGBqgUmXCbsNQhC6dMzHmmdEOOZYzbl
	 uqjWbAgjhvCJv3Icho17oCph4dGvAhus4b39h/k4d4psmLFCEKlORR+k0JD462k6Hj
	 CbHrb8svjWOX1Fgwro+YCoeAhZ4RsD9q3Hq8lurjBk1RbNgGBZ1NHrXH+95pawOdw5
	 afaOin9/HUunYQHV6MMcKP5HO3ipEDFRNP8qmnUx/qQ4VcUg7UNqT0OqS3TFhuuOoy
	 GkED7ik41yGUQ==
Date: Tue, 14 Oct 2025 14:04:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: Re: [PATCH v4] xfs: do not tightly pack-write large files
Message-ID: <20251014210406.GD6188@frogsfrogsfrogs>
References: <20251014041945.760013-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014041945.760013-1-dlemoal@kernel.org>

On Tue, Oct 14, 2025 at 01:19:45PM +0900, Damien Le Moal wrote:
> When using a zoned realtime device, tightly packing of data blocks
> belonging to multiple closed files into the same realtime group (RTG)
> is very efficient at improving write performance. This is especially
> true with SMR HDDs as this can reduce, and even suppress, disk head
> seeks.
> 
> However, such tight packing does not make sense for large files that
> require at least a full RTG. If tight packing placement is applied for
> such files, the VM writeback thread switching between inodes result in
> the large files to be fragmented, thus increasing the garbage collection
> penalty later when the RTG needs to be reclaimed.
> 
> This problem can be avoided with a simple heuristic: if the size of the
> inode being written back is at least equal to the RTG size, do not use
> tight-packing. Modify xfs_zoned_pack_tight() to always return false in
> this case.
> 
> With this change, a multi-writer workload writing files of 256 MB on a
> file system backed by an SMR HDD with 256 MB zone size as a realtime
> device sees all files occupying exactly one RTG (i.e. one device zone),
> thus completely removing the heavy fragmentation observed without this
> change.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Seems reasonable to me, it's like tail packing of the old days.
Only now the blocks are 256M, like mkp says. ;)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> Changes from v1:
>  - Improved commit message
>  - Improved code comments
> Changes from v2:
>  - Fixed typos in the commit message
> Changes from v3:
>  - Changed code comment as suggested by Christoph.
> 
>  fs/xfs/xfs_zone_alloc.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 1147bacb2da8..1b462cd5d8fa 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -614,14 +614,25 @@ static inline enum rw_hint xfs_inode_write_hint(struct xfs_inode *ip)
>  }
>  
>  /*
> - * Try to pack inodes that are written back after they were closed tight instead
> - * of trying to open new zones for them or spread them to the least recently
> - * used zone.  This optimizes the data layout for workloads that untar or copy
> - * a lot of small files.  Right now this does not separate multiple such
> + * Try to tightly pack small files that are written back after they were closed
> + * instead of trying to open new zones for them or spread them to the least
> + * recently used zone. This optimizes the data layout for workloads that untar
> + * or copy a lot of small files. Right now this does not separate multiple such
>   * streams.
>   */
>  static inline bool xfs_zoned_pack_tight(struct xfs_inode *ip)
>  {
> +	struct xfs_mount *mp = ip->i_mount;
> +	size_t zone_capacity =
> +		XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_RTG].blocks);
> +
> +	/*
> +	 * Do not pack write files that are already using a full zone to avoid
> +	 * fragmentation.
> +	 */
> +	if (i_size_read(VFS_I(ip)) >= zone_capacity)
> +		return false;
> +
>  	return !inode_is_open_for_write(VFS_I(ip)) &&
>  		!(ip->i_diflags & XFS_DIFLAG_APPEND);
>  }
> -- 
> 2.51.0
> 
> 
