Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBD3267B1B
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 15:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214252; cv=none; b=OaGb7+Iy3KWycS/UX051kXqctyQhtsHWVJF5UwSWgAKqzzqAJ9xmMYck6DI2WWIoMN0evPJ4oonohfsxnxWCg1vgdw0Om68UnZ8fbYthd+rDno8M0i2X3qgurVObZP/ljgHRLNV7/jB96gRDIvOoqFgE9+5v5vPN2V4jamjYSVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214252; c=relaxed/simple;
	bh=h14hV3Mio3nemAxeVb/zaLX7+nM17Qzf5ozoaU5yPM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZoq/aOGlUhcwH0jiV39rrrN67KyPw1yylQ/V3v35tanFqvnfqyFG5U/wKBcbzbPmQ+U1k1RwkQW7uqC4s0i9EXlykSuIJtgnj7226thuRp0T+udzngUZ7rFkzkx9q/GWgL1EXdH9N4xGA+6PFeArPnKhLWEZ8PfsKjRsRwDW9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SBriousG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SBriousG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C31C4CEE2;
	Wed,  9 Apr 2025 15:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744214252;
	bh=h14hV3Mio3nemAxeVb/zaLX7+nM17Qzf5ozoaU5yPM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SBriousG5oFjqZnxIbjk+pa45gedwhWfPxqjatXD6YlRsHzQh7e+caX5cpKP9lxv5
	 d8i/+8iUfxynOU4c+pSPFDK95ej/IGDHhn4YRDp4RK5eOXBL51didV1hZgs3xocUoq
	 TdL79gpLNlOLzVBkSQP1MekFCp9+oNlU39RjWcRd3MAuH7qlZ53RGQW03Y/YZ7HACd
	 f5L5hPtky3bxgO6f86YD/irc4+z9/W7euxE0CmnFlkRA8EId1kzQRaxXHL0RsJrXZJ
	 8FsPBIuiCAJnyuc0nFAqpxC0bD51xrd5XzH0/7gFrr3r0X9/+CWGHGkUDZ9gXNoGuA
	 tDZuPwIZksqTw==
Date: Wed, 9 Apr 2025 08:57:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/45] FIXUP: xfs: support zone gaps
Message-ID: <20250409155731.GY6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-26-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-26-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:28AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  db/convert.c        | 6 +++++-
>  include/xfs_mount.h | 9 +++++++++
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/db/convert.c b/db/convert.c
> index 47d3e86fdc4e..3eec4f224f51 100644
> --- a/db/convert.c
> +++ b/db/convert.c
> @@ -44,10 +44,14 @@ xfs_daddr_to_rgno(
>  	struct xfs_mount	*mp,
>  	xfs_daddr_t		daddr)
>  {
> +	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
> +
>  	if (!xfs_has_rtgroups(mp))
>  		return 0;
>  
> -	return XFS_BB_TO_FSBT(mp, daddr) / mp->m_groups[XG_TYPE_RTG].blocks;
> +	if (g->has_daddr_gaps)
> +		return XFS_BB_TO_FSBT(mp, daddr) / (1 << g->blklog);
> +	return XFS_BB_TO_FSBT(mp, daddr) / g->blocks;
>  }
>  
>  typedef enum {
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index bf9ebc25fc79..5a714333c16e 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -47,6 +47,15 @@ struct xfs_groups {
>  	 */
>  	uint8_t			blklog;
>  
> +	/*
> +	 * Zoned devices can have gaps beyoned the usable capacity of a zone
> +	 * and the end in the LBA/daddr address space.  In other words, the
> +	 * hardware equivalent to the RT groups already takes care of the power
> +	 * of 2 alignment for us.  In this case the sparse FSB/RTB address space
> +	 * maps 1:1 to the device address space.
> +	 */
> +	bool			has_daddr_gaps;
> +
>  	/*
>  	 * Mask to extract the group-relative block number from a FSB.
>  	 * For a pre-rtgroups filesystem we pretend to have one very large
> -- 
> 2.47.2
> 
> 
