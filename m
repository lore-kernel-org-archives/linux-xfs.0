Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAAD269AF5
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 15:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214177; cv=none; b=Y6+KakgicucZySYaybLwAIBVXgr+OfpMlwoaaO6/RjMHJachxeiyeg6itF5LtduU/ljwq3f1k7SHAH+UT1o3oEpAE5NkXAOta5JqtJVX3m1+2wJb7ehW3BNUov90QfjGGiloKrSx4WpU7XfDDkoM5zHZsDl4BVgdwnfOClf80GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214177; c=relaxed/simple;
	bh=xxjCXQxJrmwUCmnqXYSu+8T8IJ/JBXWteUzPlirqT3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jUqBlZd0fjPTu4cyUeXzDwFUiGxZJBJXs0TXc8dwSBsLjS4myD4bcnncWV//4U+e5AbyoCSmh/3c97ECTGe46Vh8AqWZ9GjccMIjKD85MidVg1nrk7PRWcOyLw0dqWDPiOZrHXTpkNkNHELrVcTQtsu2t8SGxcwm2i9n+YQ2FxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lgCtRzl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lgCtRzl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A51C4CEE3;
	Wed,  9 Apr 2025 15:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744214176;
	bh=xxjCXQxJrmwUCmnqXYSu+8T8IJ/JBXWteUzPlirqT3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lgCtRzl7i9nZpEzyRK1z95l1MpbrIReI/JVhwdfXe8MYTsSaKejV9zsVTTnjBhtry
	 JRR3xFqqv2xjfH63OBeRP+JKdBzum3CclBsG7ZWus2RVpbzuQKwFNP63c0AvrAziNt
	 Xd4a3pgDWkXp+nIMdDW5U0sT3xyFzuNPEqVqdm6yTQ4cclY+iclW4FQsMDqPEfa1C4
	 3KCAbf2FR6sLEixB7+QZVVSSC2japySMHrPBU/jF86FDMgEPKYsU3VbJn0OMZUEV0s
	 WnM7aIGNSVt+mETtWhRo1T/DXac2zRfjdzkjP8gb13iHW3tgRAWw9oQc3aUgZOA9Eh
	 w3MboxMBICj6g==
Date: Wed, 9 Apr 2025 08:56:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/45] FIXUP: xfs: parse and validate hardware zone
 information
Message-ID: <20250409155616.GW6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-18-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-18-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:20AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/Makefile    | 6 ++++--
>  libxfs/xfs_zones.c | 2 ++
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/libxfs/Makefile b/libxfs/Makefile
> index f3daa598ca97..61c43529b532 100644
> --- a/libxfs/Makefile
> +++ b/libxfs/Makefile
> @@ -71,7 +71,8 @@ HFILES = \
>  	xfs_shared.h \
>  	xfs_trans_resv.h \
>  	xfs_trans_space.h \
> -	xfs_dir2_priv.h
> +	xfs_dir2_priv.h \
> +	xfs_zones.h
>  
>  CFILES = buf_mem.c \
>  	cache.c \
> @@ -135,7 +136,8 @@ CFILES = buf_mem.c \
>  	xfs_trans_inode.c \
>  	xfs_trans_resv.c \
>  	xfs_trans_space.c \
> -	xfs_types.c
> +	xfs_types.c \
> +	xfs_zones.c
>  
>  EXTRA_CFILES=\
>  	ioctl_c_dummy.c
> diff --git a/libxfs/xfs_zones.c b/libxfs/xfs_zones.c
> index b022ed960eac..712c0fe9b0da 100644
> --- a/libxfs/xfs_zones.c
> +++ b/libxfs/xfs_zones.c
> @@ -3,6 +3,8 @@
>   * Copyright (c) 2023-2025 Christoph Hellwig.
>   * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
>   */
> +#include <linux/blkzoned.h>
> +#include "libxfs_priv.h"
>  #include "xfs.h"
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
> -- 
> 2.47.2
> 
> 
