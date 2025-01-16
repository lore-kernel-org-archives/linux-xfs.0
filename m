Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE0C132103
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 16:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737046434; cv=none; b=DaajF32uEbqbwyWLL0iX4txKkl7Djr5TqGigV6lrLCR/AKv246gWuaRbTCzs5zV1ulQKacFspIG/sJ53VB0fa3IRepqNPDDRGTi3jsmo3cQf60ongU35qpmauRr2wiPncLtA565bWK7ROlyd+naL1I8DycNe/bEcU28Ny+/j/Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737046434; c=relaxed/simple;
	bh=PXAcKpWyouPZpkOHv4NXffYZsxWD6ILYyWXrP/34Gho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WOXXpiYh1g1D+UJG/r+GkHA8Em5W1usGoWO7tKEGoQ092cmU/ffMXVXEXCqj506N5IAQWWBqYVEQzIW6hLYSG40oZLRyK3gERtqubytsd0EZ5yZfG64dwc0WUU3Jw5jFmekShyJ2E8/vgSuYG2sFdxrMhQ4Ihd3oOaegCsVHOpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sFFenXjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sFFenXjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7124DC4CED6;
	Thu, 16 Jan 2025 16:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737046433;
	bh=PXAcKpWyouPZpkOHv4NXffYZsxWD6ILYyWXrP/34Gho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sFFenXjMVfFhagC5UKHkYrJnvqFYWzyuBsnB9H+4KxkMFCd+RHpfkB06aXojzNg/b
	 OA3VE+c+e2+T8NUqOyVcsosro405FQeVC7JiFyDrrM7Ec6/bDEsAUGCUiVoPew0ZmQ
	 VvV22pkw1rbrwVlVdYmQ/krV6X9D5IiyzTZ675Z8G5s1Tv6OOvELlugajffkDPk5Tr
	 RtpZ4UHwdNtnUnNcgxRw7SXkvjIIjs+H18KECodtKwcUQ++ua99GlFWx732NHNXFdc
	 Kt1EWI9m7HoVmrD5nsIuwbKfDQneIJt7gHSCGEoBPRiTqZuhF4EUacv4Mb2EfMk+qm
	 fgsui/iF19wqQ==
Date: Thu, 16 Jan 2025 08:53:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: Remove pointless crc flag check from
 xfs_agfl_verify
Message-ID: <20250116165352.GG3566461@frogsfrogsfrogs>
References: <20250116163304.492079-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116163304.492079-1-cem@kernel.org>

On Thu, Jan 16, 2025 at 05:32:56PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Just a small clean up.
> xfs_agfl_verify() is only called from xfs_agfl_{read,write}_verify()
> helpers.
> Both of them already check if crc is enabled, there seems to be no
> reason for checking for it again.

...but it does get called via ->verify_struct, which in turn is called
by online fsck and buffer log item "precommit" if
CONFIG_XFS_DEBUG_EXPENSIVE=y, so please don't remove this check.

--D

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 3d33e17f2e5c..619e6d6570f8 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -787,9 +787,6 @@ xfs_agfl_verify(
>  	__be32		*agfl_bno = xfs_buf_to_agfl_bno(bp);
>  	int		i;
>  
> -	if (!xfs_has_crc(mp))
> -		return NULL;
> -
>  	if (!xfs_verify_magic(bp, agfl->agfl_magicnum))
>  		return __this_address;
>  	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
> -- 
> 2.47.1
> 
> 
