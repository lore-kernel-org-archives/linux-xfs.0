Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9B51D7E26
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 16:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681727; cv=none; b=e0oAQBXpOr6I3ydDEEdK6tvyCBZZ/NIwDXyELq7gYiJANVeZ1QHdC+3SyliY1C+N3ZRT7CUyLxhajeFH0qmv3FlfMIEzEnC5STf4GNF3I5hDTB0rqu5JgI6v486ORHvgh+IUnvnNW06guP+PFZxReAICjyAVnniASGxCKPOwH9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681727; c=relaxed/simple;
	bh=7u/uCxc1oIYIn3GRq67FCHgbaVkYOXp4IDq2ztsItDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dxZ8yy2fHBn5LUcSZiunbPYN7Go72EJUo8L8do4guh+h1E01ElLck2R+PCFNFDc6Hxa8X/sPz2QLPGzXGj5F7fDoimH3Gc0rQpDCXcRM4R68FRHiaQbtfeeT9MrvXK9LBMtz0YHnKiWWp75UqX+z2RRm6C/MrqsdfPn4e9SV62s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3TzxL1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3TzxL1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5D3C4CEE7;
	Wed, 16 Jul 2025 16:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752681726;
	bh=7u/uCxc1oIYIn3GRq67FCHgbaVkYOXp4IDq2ztsItDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V3TzxL1ftKVxsB8sHVAQE70RkRSMomY9+28BxDDwh0lYOQ5C5PInO4hFrS5GXGlBB
	 nSX2NbuR1K/8QoCqQ4GhA+GEe3AuV8zM8B7mOwnFBaEHNKBOEsszX8FDk148eD3Nq3
	 RQ9mXUOE85tGnTjBejDZCAlji1MduGtFAB3fUkDr4jOEjSprgyvujkKUZ3z+EHTri2
	 UxR5MHT6ldggUmhv+hXIi+B1ygCLSbNBbxXPWRfjw1+K7Ptk5zMeC+Lbvrj3ovc6gr
	 GHuF+T3DzI29Out3QRBBmEellqzuQbrG2OGtOiUTVQe7XaKXvpVdmKHrCDL/oWC59c
	 sm4I6dbp4D6dA==
Date: Wed, 16 Jul 2025 09:02:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org, George Hu <integral@archlinux.org>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH 5/7] xfs: replace min & max with clamp() in
 xfs_max_open_zones()
Message-ID: <20250716160206.GL2672049@frogsfrogsfrogs>
References: <20250716125413.2148420-1-hch@lst.de>
 <20250716125413.2148420-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716125413.2148420-6-hch@lst.de>

On Wed, Jul 16, 2025 at 02:54:05PM +0200, Christoph Hellwig wrote:
> From: George Hu <integral@archlinux.org>
> 
> Refactor the xfs_max_open_zones() function by replacing the usage of
> min() and max() macro with clamp() to simplify the code and improve
> readability.
> 
> Signed-off-by: George Hu <integral@archlinux.org>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> ---
>  fs/xfs/xfs_zone_alloc.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 729d80ff52c1..d9e2b1411434 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -1133,9 +1133,7 @@ xfs_max_open_zones(
>  	/*
>  	 * Cap the max open limit to 1/4 of available space
>  	 */
> -	max_open = min(max_open, mp->m_sb.sb_rgcount / 4);
> -
> -	return max(XFS_MIN_OPEN_ZONES, max_open);
> +	return clamp(max_open, XFS_MIN_OPEN_ZONES, mp->m_sb.sb_rgcount / 4);

Does clamp() handle the case where @max < @min properly?
I'm worried about shenanigans on a runt 7-zone drive, though I can't
remember off the top of my head if we actually prohibit that...

--D

>  }
>  
>  /*
> -- 
> 2.47.2
> 
> 
