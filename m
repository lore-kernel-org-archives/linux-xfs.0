Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACF91D61B1
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 20:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738875170; cv=none; b=hAHrtBqGsMXP8ktCIWTLViPTnztsWmYm/V9orE7z4ZKh8I20ga0VKq7yIg5at4m/cpPf4w1LD7Fcw2I1oC/ZQnPl1TAjZb7uDAHZD3spnyWV8E0cRxLdT8ZAOJ5REfBILFFt8wvQ/sfslOaQqjLaj+MezJoLr3WuQ0tPhnJCsuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738875170; c=relaxed/simple;
	bh=3PaASJu6mJxEnIJxDFL+I61a5n6fjbgVrQ0vipP7q+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rr7/i8iAXSpePLmCftdyH+eIfwZ83pHN2H8ZoyN75NBNctesgwJlEvECAcr+bKTv1e/eI9g9R0VEKKwwoZaZx2jdGHOMyYUasLtarZ0ac1EvWqQT7TSmsdc8CPUv+IH7czXMvjP4Qq5Ec3M1gk+EdGIS9GcZvtALfH4QXkmIQxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=We0ZW2Fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="We0ZW2Fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D65C4CEDD;
	Thu,  6 Feb 2025 20:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738875170;
	bh=3PaASJu6mJxEnIJxDFL+I61a5n6fjbgVrQ0vipP7q+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=We0ZW2Fl9RtlwypchsJNyWSDOJZNfANHuVPZdMeIXVgXURKXNrKfC9GVHyo9TKCFP
	 oCkknppZUOt1FiUCPxrGdgjH1I5qvjtX44jggMTrSwh8Q9wa8IwAxSp/zoNBrTpNeJ
	 VXnDurq5nS7WSOn8zc9/ftCEEKseJ84nuX/j5DmnKIsIBoCdQeA0cakUW5TYiUIebh
	 OMr70B0RbqqcdPMohBxwJf8ZYMSB6YgimTs5+XB7ADalYKztXRi14GDjcBS/knYSw6
	 8sImH4+ScMTd8LbZ7SNIiHfU/+bGeUX+lH24/5p3eGDzIod8WNHy7gexK8f7JN/l3T
	 2gIHkDAX2Ywxw==
Date: Thu, 6 Feb 2025 12:52:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/43] xfs: reduce metafile reservations
Message-ID: <20250206205249.GM21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-12-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:27AM +0100, Christoph Hellwig wrote:
> There is no point in reserving more space than actually available
> on the data device for the worst case scenario that is unlikely to
> happen.  Reserve at most 1/4th of the data device blocks, which is
> still a heuristic.

I wonder if this should be a bugfix for 6.14?  Since one could format a
filesystem with a 1T data volume and a 200T rt volume and immediately be
out of space on the data volume.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_metafile.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
> index 88f011750add..225923e463c4 100644
> --- a/fs/xfs/libxfs/xfs_metafile.c
> +++ b/fs/xfs/libxfs/xfs_metafile.c
> @@ -260,6 +260,7 @@ xfs_metafile_resv_init(
>  	struct xfs_rtgroup	*rtg = NULL;
>  	xfs_filblks_t		used = 0, target = 0;
>  	xfs_filblks_t		hidden_space;
> +	xfs_rfsblock_t		dblocks_avail = mp->m_sb.sb_dblocks / 4;
>  	int			error = 0;
>  
>  	if (!xfs_has_metadir(mp))
> @@ -297,6 +298,8 @@ xfs_metafile_resv_init(
>  	 */
>  	if (used > target)
>  		target = used;
> +	else if (target > dblocks_avail)
> +		target = dblocks_avail;
>  	hidden_space = target - used;
>  
>  	error = xfs_dec_fdblocks(mp, hidden_space, true);
> -- 
> 2.45.2
> 
> 
