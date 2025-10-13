Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1728022D4E9
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 07:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760339392; cv=none; b=d8c+naBJnnR7EDyZ/yCaCLPiZ09EizeSojBkQqG2tdBWKNjh2oCTrly82xVKBhjlq00QanySgcC1wsLdhfpDd4l7hIIVyBPPeKPuegqcNlkpgqXGoqML+REUq7eGgCBN7wI9epPWKOA6fdzJUiTycCsbHjwOw2L4DihfbVnBpuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760339392; c=relaxed/simple;
	bh=2Mbr8kkz7sJlrWKmWUITwNh1boJDUqTuHPpddPULtQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=olOOyriSNDE6adE6d9R6oqqQFix6iIQ+xPDxpoMm4vQYrW+jGF2V9Xo262ukO7DayfIPSTMhJFACLnGKEZadSU3OTOsRHepSK3CR8lWZzItx0i34XxNiSntr8LIpmAVSqF8v/nl3KvZ3SqUk0AHlfp6rNkeQGG/WkXSzlCv+0D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 985EE227A87; Mon, 13 Oct 2025 09:09:45 +0200 (CEST)
Date: Mon, 13 Oct 2025 09:09:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: Re: [PATCH] xfs: do not tight-pack write large files
Message-ID: <20251013070945.GA2446@lst.de>
References: <20251013064512.752089-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013064512.752089-1-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 13, 2025 at 03:45:12PM +0900, Damien Le Moal wrote:
> The tick-packing data block allocation which writes blocks of closed
> files in the same zone is very efficient at improving write performance
> on HDDs by reducing, and even suppressing, disk head seeks. However,
> such tight packing does not make sense for large files that require at
> least a full realtime block group (i.e. a zone). If tight-packing
> placement is applied for such files, the VM writeback thread switching
> between inodes result in the large file to be fragmented, thus
> increasing the garbage collection penalty later when the used realtime
> block group/zone needs to be reclaimed.
> 
> This problem can be avoided with a simple heuristic: if the size of the
> inode being written back is at least equal to the realtime block group
> size, do not use tight-packing. Modify xfs_zoned_pack_tight() to always
> return false in this case.
> 
> With this change, a multi-writer workload writing files of 256 MB on a
> file system backed by an SMR HDD with 256 MB zone size sees all files
> occupying exactly one zone, thus completely removing the heavy
> fragmentation observed without this change.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  fs/xfs/xfs_zone_alloc.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 1147bacb2da8..c51788550c7c 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -622,6 +622,17 @@ static inline enum rw_hint xfs_inode_write_hint(struct xfs_inode *ip)
>   */
>  static inline bool xfs_zoned_pack_tight(struct xfs_inode *ip)
>  {
> +	struct xfs_mount *mp = ip->i_mount;
> +	size_t zone_capacity =
> +		XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_RTG].blocks);
> +
> +	/*
> +	 * Do not pack tight large files that are already using a full group

I'm not a native speaker, but shouldn't this be ordered differently

	  Do not pack large files that are already using a full group (zone)
	  to avoid fragmentation?

Also I'd say either zone or RTG. but not mix both names to avoid confusion.

Otherwise this looks good to me.

