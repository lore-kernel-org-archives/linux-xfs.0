Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922FA2C86D
	for <linux-xfs@vger.kernel.org>; Mon,  8 Dec 2025 17:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765215606; cv=none; b=freBoJuJYmMfZY1nG4VpzHD5+bsqWwxWOIAZtY4YmCGcgNCtVCfx27yUCJyohh3WoadQmIwZqULHBXzStioqD224o+cttebDl9OMFa4mTvBJT/aBgWvfDli3B/bt7C4ADrG+tyt+lZupHsbC+B5/zTGSImRv39vz4WKvw4dD+y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765215606; c=relaxed/simple;
	bh=OolkI3gfp1FcuV2D258WlaqyXiBdbcKWcSDODYsM5WA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I4yRAWOXby+A5msL3SfHYnQ63YIchSV7rq1BBO7V8s4+qtupwfZduzShkv9EF9DajL8uaql0g4Ux3d8QZd1LkM6u+rxv+fqmikJczlZOj2qSLZlR/BMFTmmeKiQjRHBTmvD3INdMvxmXGu24vZ6lbeh8DGmzju2V+14Q8+TAO6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WomarHnV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WomarHnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FB7C4CEF1;
	Mon,  8 Dec 2025 17:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765215606;
	bh=OolkI3gfp1FcuV2D258WlaqyXiBdbcKWcSDODYsM5WA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WomarHnV/XeXWAbUtBdxbdpDmbkjYyBGs231Z4jSJix6+DN1ON2Cs05m8v8vxgr4n
	 72Q1Z+BFSWXKKglSvn1PkJx4frVvcwc0jQr2KMi0di5rI9I/Ax6qm7eIkqrtGkK+T6
	 EsVjhXhmlkdrGBsKztu5PtpaFb2H31jjGwyrn30uJXeRqCVU7WVocL3GuPLDPIGfct
	 vVCsqeGzvTrOSklPrqXyYqO8GUuYw03gVT0RgU1WiW8mtFPcmckg3Jj05A6ZT9geRe
	 /cRHnsePG5bJsG0v7aKUsvc3E/n2oVeoGmWlfnxwHP5ofVT1nc/DMTd6fepvpv6I16
	 mTJ2w9KO8RN+w==
Date: Mon, 8 Dec 2025 09:40:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	hch@infradead.org
Subject: Re: [PATCH v1] xfs: Fix rgcount/rgsize value reported in
 XFS_IOC_FSGEOMETRY ioctl
Message-ID: <20251208174005.GT89472@frogsfrogsfrogs>
References: <50441ebab613e02219545cca9caec58aacf77446.1765206687.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50441ebab613e02219545cca9caec58aacf77446.1765206687.git.nirjhar.roy.lists@gmail.com>

On Mon, Dec 08, 2025 at 08:46:11PM +0530, Nirjhar Roy (IBM) wrote:
> With mkfs.xfs -m dir=0 i.e, with XFS_SB_FEAT_INCOMPAT_METADIR
> disabled, number of realtime groups should be reported as 1 and
> the size of it should be equal to total number of realtime
> extents since this the entire realtime filesystem has only 1
> realtime group.

No.  This (pre-metadir realtime having one group encompassing the entire
rt volume) is an implementation detail, not a property of the filesystem
geometry.

Or put another way: a metadir rt filesystem with one rtgroup that covers
the entire rt device is different from a pre-metadir rt filesystem.
xfs_info should present that distinction to userspace, particularly
since xfs_scrub cares about that difference.

--D

> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index cdd16dd805d7..989553e7ec02 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -875,7 +875,7 @@ __xfs_sb_from_disk(
>  	} else {
>  		to->sb_metadirino = NULLFSINO;
>  		to->sb_rgcount = 1;
> -		to->sb_rgextents = 0;
> +		to->sb_rgextents = to->sb_rextents;
>  	}
>  
>  	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) {
> @@ -1586,10 +1586,8 @@ xfs_fs_geometry(
>  
>  	geo->version = XFS_FSOP_GEOM_VERSION_V5;
>  
> -	if (xfs_has_rtgroups(mp)) {
> -		geo->rgcount = sbp->sb_rgcount;
> -		geo->rgextents = sbp->sb_rgextents;
> -	}
> +	geo->rgcount = sbp->sb_rgcount;
> +	geo->rgextents = sbp->sb_rgextents;
>  	if (xfs_has_zoned(mp)) {
>  		geo->rtstart = sbp->sb_rtstart;
>  		geo->rtreserved = sbp->sb_rtreserved;
> -- 
> 2.43.5
> 
> 
