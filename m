Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859D72F546B
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 16:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681809; cv=none; b=XRCsHujKzMrPTLxBDedW7rZ1ol7UdlV4YbJcjnxb1jFc+c2c7yo+Hs9+hnERowV969a8xNihA1x31GCR99gQKi6HtPqSICprxu8eDt4mzYef7PkMNN5evcPc4B1r9CuMOrMtCrD2J5CzqFAMRSpTJcethBMWNot+Ow67duH0d70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681809; c=relaxed/simple;
	bh=YiwEYEcx0GSZpnuUJ5Yxz3tQkEwlzDQjCJ55IWFqh8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jIq+qE5vxnn0PuxvDWysoqdnoIHRsweUQk9V232FOFZapVYcc44qvQg+lyvuDUlcbS4XPv5avJigOt8TFTtNddm3sgFEe/hXRbM4Pbr7WY8MWdIwWvfswC9prnnUVxW6Jmns+4z03RTtKj3ckyvb42NACbJTnM7iMxkQitkQ7wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=STnyvWFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="STnyvWFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116ECC4CEF0;
	Wed, 16 Jul 2025 16:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752681809;
	bh=YiwEYEcx0GSZpnuUJ5Yxz3tQkEwlzDQjCJ55IWFqh8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=STnyvWFI0CUCa1NFOb1TDIK4+YAcXw0oTytLSvsT2YK2ra3+dfIxTrJ9OkGKNBLVq
	 +YVByyMlE6z1x8HnqmcZGwO7/V+cbFRW3xnfYey1XCtqQsrubE7TzxMvVDmaMcIILk
	 B5jdb84vFA0/M+w5+V7bzblTBHoLNCSwAdCTVlSV2sxcXIGo3D5A3sqJxVXQqCDi31
	 vB/wdQZunLW21lXM4mUCs5yKlZdznxT5y3Hjb+uvWcOtcwMnA33kFXnansv9FD/BPa
	 Ja0vqx0rJa+yGvuNBXPcSzUrxf+XJxjwzLcTS7Jr2nUacCxAWD+2yPC3uqBl9Ua5Nw
	 d4bjvSaw7iXfA==
Date: Wed, 16 Jul 2025 09:03:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: improve the comments in xfs_select_zone_nowait
Message-ID: <20250716160326.GN2672049@frogsfrogsfrogs>
References: <20250716125413.2148420-1-hch@lst.de>
 <20250716125413.2148420-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716125413.2148420-8-hch@lst.de>

On Wed, Jul 16, 2025 at 02:54:07PM +0200, Christoph Hellwig wrote:
> The top of the function comment is outdated, and the parts still correct
> duplicate information in comment inside the function.  Remove the top of
> the function comment and instead improve a comment inside the function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_alloc.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index c1f053f4a82a..4e4ca5bbfc47 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -654,13 +654,6 @@ static inline bool xfs_zoned_pack_tight(struct xfs_inode *ip)
>  		!(ip->i_diflags & XFS_DIFLAG_APPEND);
>  }
>  
> -/*
> - * Pick a new zone for writes.
> - *
> - * If we aren't using up our budget of open zones just open a new one from the
> - * freelist.  Else try to find one that matches the expected data lifetime.  If
> - * we don't find one that is good pick any zone that is available.
> - */
>  static struct xfs_open_zone *
>  xfs_select_zone_nowait(
>  	struct xfs_mount	*mp,
> @@ -688,7 +681,8 @@ xfs_select_zone_nowait(
>  		goto out_unlock;
>  
>  	/*
> -	 * See if we can open a new zone and use that.
> +	 * See if we can open a new zone and use that so that data for different
> +	 * files is mixed as little as possible.
>  	 */
>  	oz = xfs_try_open_zone(mp, write_hint);
>  	if (oz)
> -- 
> 2.47.2
> 
> 
