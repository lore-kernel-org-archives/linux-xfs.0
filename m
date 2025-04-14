Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BA2156236
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 22:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744668996; cv=none; b=G2KMNPGGhrQrnoi/scqcCrpNZ4h0iF+zcieuXI6Bban7G+F9QVi4Vj1sPINB1FaQp4IlUtK9nAeK4ti0DzogVsoc6TCOGmpVpVxWfmjuF7DeOiNe74/7BXrCGVb89Rp/XcZILf8a6MBYxHKseExTA39JTiheDroPV3cvAXCztSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744668996; c=relaxed/simple;
	bh=19PURgShzcoyP+oaF05J2tYJGUseT/YyBZsKSMQLeBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLlCWHNoCaEzTTwSm0PqZmSrnsfQm0i46hxuitPWov/K99cj7t6otrcqIEwu22Gpzvl1yrQoFJLqdPe/zF8rMP3nIfU7Ua3S5SO2xkmX3oKzHu/kn9QTo73mdTDhJHZd/R7p/kO9nejd5zReOSq/3wf97BUvp0wteAHHp6o51V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljokCpBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljokCpBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E4CC4CEE2;
	Mon, 14 Apr 2025 22:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744668995;
	bh=19PURgShzcoyP+oaF05J2tYJGUseT/YyBZsKSMQLeBs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ljokCpBaujc0XItI/6rs2XeFjtmVz+o08fspW+HTuso+wwsRtWmRmwiT37PMlhZlB
	 He+xlsAOXDwSbv6QXc4S3q1JPyPVsrvELmGbN+9IpyM+AkDxOhWbKRvvRDQzeCQsqW
	 emklvVpTZ3FwGU3kPbZO3PHnio/5svcj7yhXvPgLmbXRiezZ0DD9Mostu2TTuES3p7
	 +YH6H2wEIwC5XxRftuGdOMXDACMoKuYF/hzL+PE9pyhU71phOurRt72JZ0Iiz/J2dd
	 1kFLyug4StJ6LGx6fCxuBvT9Sz0PsL3nRmwA+yQbkwceIv+AXecA9MomQr8ODL41UX
	 YFGQsVU/9qmkQ==
Date: Mon, 14 Apr 2025 15:16:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/43] libfrog: report the zoned geometry
Message-ID: <20250414221635.GD25675@frogsfrogsfrogs>
References: <20250414053629.360672-1-hch@lst.de>
 <20250414053629.360672-27-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250414053629.360672-27-hch@lst.de>

On Mon, Apr 14, 2025 at 07:36:09AM +0200, Christoph Hellwig wrote:
> The rtdev_name helper is based on example code posted by Darrick Wong.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Much nicer, thanks for cleaning this up
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libfrog/fsgeom.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> index b5220d2d6ffd..571d376c6b3c 100644
> --- a/libfrog/fsgeom.c
> +++ b/libfrog/fsgeom.c
> @@ -8,6 +8,20 @@
>  #include "fsgeom.h"
>  #include "util.h"
>  
> +static inline const char *
> +rtdev_name(
> +	struct xfs_fsop_geom	*geo,
> +	const char		*rtname)
> +{
> +	if (!geo->rtblocks)
> +		return _("none");
> +	if (geo->rtstart)
> +		return _("internal");
> +	if (!rtname)
> +		return _("external");
> +	return rtname;
> +}
> +
>  void
>  xfs_report_geom(
>  	struct xfs_fsop_geom	*geo,
> @@ -34,6 +48,7 @@ xfs_report_geom(
>  	int			exchangerange;
>  	int			parent;
>  	int			metadir;
> +	int			zoned;
>  
>  	isint = geo->logstart > 0;
>  	lazycount = geo->flags & XFS_FSOP_GEOM_FLAGS_LAZYSB ? 1 : 0;
> @@ -55,6 +70,7 @@ xfs_report_geom(
>  	exchangerange = geo->flags & XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE ? 1 : 0;
>  	parent = geo->flags & XFS_FSOP_GEOM_FLAGS_PARENT ? 1 : 0;
>  	metadir = geo->flags & XFS_FSOP_GEOM_FLAGS_METADIR ? 1 : 0;
> +	zoned = geo->flags & XFS_FSOP_GEOM_FLAGS_ZONED ? 1 : 0;
>  
>  	printf(_(
>  "meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
> @@ -68,7 +84,8 @@ xfs_report_geom(
>  "log      =%-22s bsize=%-6d blocks=%u, version=%d\n"
>  "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
>  "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"
> -"         =%-22s rgcount=%-4d rgsize=%u extents\n"),
> +"         =%-22s rgcount=%-4d rgsize=%u extents\n"
> +"         =%-22s zoned=%-6d start=%llu reserved=%llu\n"),
>  		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
>  		"", geo->sectsize, attrversion, projid32bit,
>  		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
> @@ -81,10 +98,11 @@ xfs_report_geom(
>  		isint ? _("internal log") : logname ? logname : _("external"),
>  			geo->blocksize, geo->logblocks, logversion,
>  		"", geo->logsectsize, geo->logsunit / geo->blocksize, lazycount,
> -		!geo->rtblocks ? _("none") : rtname ? rtname : _("external"),
> +		rtdev_name(geo, rtname),
>  		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
>  			(unsigned long long)geo->rtextents,
> -		"", geo->rgcount, geo->rgextents);
> +		"", geo->rgcount, geo->rgextents,
> +		"", zoned, geo->rtstart, geo->rtreserved);
>  }
>  
>  /* Try to obtain the xfs geometry.  On error returns a negative error code. */
> -- 
> 2.47.2
> 
> 
