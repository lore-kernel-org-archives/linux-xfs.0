Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6B6259CBD;
	Wed, 18 Feb 2026 23:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456370; cv=none; b=V30Vo1o1Rq4knYHIYQ02VXY1LCMyDK9N7FpmKcxj+vcS69KtP/ESv8u6SN1DBtjPGPTVVjmwAGEffIcaCFR+31hPhJArrDFMtGM0bdj/nZGYu+TVjpXYy4lFlF9sSgmnWjuz19yDA1nSOIxohBxt+/BXxNW9EapQvtW/8RDnQYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456370; c=relaxed/simple;
	bh=vnfMBnkZ70F9tmp16F0mDr+VnO+JS4AVgyvbIWS7ZCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ntPgASuavIGdxwUMy9mhRGo2JcNcQBDNmC4WFDbdf0TMglZXu0FmhS8+LFFZQ2JyFS4K6AA0Yveq8eDjW1XXrfsi7OPuFEJTTwAjaQ1NXdebDHCbH3mI8eCmbJvt+zbm+QGTvVWewJQ8v4WwpyN5lGQ5i2aXbOWyVbzlm5dvGvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kPvPE90z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kPvPE90z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399E2C116D0;
	Wed, 18 Feb 2026 23:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771456370;
	bh=vnfMBnkZ70F9tmp16F0mDr+VnO+JS4AVgyvbIWS7ZCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kPvPE90zX5kKwQKmTs8PuG36xJyt9D70pfBNNeo5hKqUrP+NVKV3CVCzpGOngEulG
	 /XazQdto2pXlIGXMPVMHhpiWRPdHCTnq37hVoVNQvxWXGkUE0I8VAg6ukCqfdzOqrR
	 34avx0t10VeOXRFj4EIXmTP3+nnrbZU9a5Db3vpPC35R+SF1as3/JOgUKc1d75oe34
	 zDb/m8czGmauIxlkrYN0Cf8DNyxo60unCuedz/vhCIRygvtc69iCHW1LYx3azsPN/0
	 6vbFjrp7dTTLJWWORaPrJ84NHm3ONmHRvMue9xmtzFts1btoMGwcQJgDlxi0n8OVg0
	 IpGBn5Zle1awQ==
Date: Wed, 18 Feb 2026 15:12:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de
Subject: Re: [PATCH v3 21/35] xfs: disable preallocations for fsverity Merkle
 tree writes
Message-ID: <20260218231249.GL6467@frogsfrogsfrogs>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-22-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217231937.1183679-22-aalbersh@kernel.org>

On Wed, Feb 18, 2026 at 12:19:21AM +0100, Andrey Albershteyn wrote:
> While writing Merkle tree, file is read-only and there's no further
> writes except Merkle tree building. The file will be truncated
> beforehand to remove any preallocated extents in futher patches.
> 
> The Merkle tree is the only data XFS will write. We don't want XFS to
> truncate any post EOF extests due to existing preallocated extents.

The file will be unwritable after fsverity construction is complete.
Perhaps xfs *should* trim the post-eof speculative preallocations if it
doesn't already?

--D

> Therefore, we also need to disable preallocations while writing merkle
> tree.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/xfs/xfs_iomap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index b5d70bcb63b9..52c41ef36d6d 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1941,7 +1941,9 @@ xfs_buffered_write_iomap_begin(
>  		 * Determine the initial size of the preallocation.
>  		 * We clean up any extra preallocation when the file is closed.
>  		 */
> -		if (xfs_has_allocsize(mp))
> +		if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> +			prealloc_blocks = 0;
> +		else if (xfs_has_allocsize(mp))
>  			prealloc_blocks = mp->m_allocsize_blocks;
>  		else if (allocfork == XFS_DATA_FORK)
>  			prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork,
> -- 
> 2.51.2
> 
> 
