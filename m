Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A781326B2CA
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 15:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214198; cv=none; b=cakA5OJZAozGMg8dchdqt5tZhMYdPdu+c31i1AsYVChYmGeSKGod48akJUo3RYDGedZZz6s3Bydby0feRSYxoU0Zh/+ncxhQIdlT+rZFe6PkBmiCZ3WIj58h42oqXseU1dLWE+4QFCNn2kLbImLjP946ZigfBCgsUusyFldRFm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214198; c=relaxed/simple;
	bh=Hs9GsaKD7o9yNaHYjUDkEj6fFb6C0NW0R/OwKZJay0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k7meDJzqORF3nUFvXtzVioZTdg+zvH8DOuMsiG+ZBenSVqEBuhjk0NOyAD2GRBdLJlMPfjrCqGIfC4t5S87KBwR8LCBJSbHO/4SLdC79morNlbghq0uFBLRCwvT4Y1SbfBgtOVqhmc2+EJ+3lTeKe2NhzqWasUAAHtFsVnkKHh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzJet7v9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzJet7v9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BF9C4CEE2;
	Wed,  9 Apr 2025 15:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744214198;
	bh=Hs9GsaKD7o9yNaHYjUDkEj6fFb6C0NW0R/OwKZJay0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mzJet7v99vq2KeZ0RPWT7pYHeLYKBSGSUedzkAlMyIOEacZPg2ZXHTjQsq5AQN94F
	 V12Tm2QupUbQcmIy48AXwazMNcGkHrj4KKpa6YMMBqrLDYdTE1T9xinOC2bg0jx4ph
	 A5Q8NmdEpyZHMB2x3I8hRFDyOwGxBGUmGm3bztw9gq9ZfRnDTJaiysX4LXsoIumXrx
	 2rAfPxT6vwptQkm+pyGLJDFc8rkPT9APd3+3okDhgYTJJ3yAgHdAZWo0hoG6nBLthi
	 KDiQwvdoxhpDPZLVV727flUAUF2pUor9KI7fxA20JzfAPk49McRUjWV6Y5U77aF7Ob
	 xXYg29hiI+evw==
Date: Wed, 9 Apr 2025 08:56:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/45] FIXUP: xfs: add support for zoned space
 reservations
Message-ID: <20250409155637.GX6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-21-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-21-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:23AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/libxfs_priv.h | 2 ++
>  libxfs/xfs_bmap.c    | 1 -
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 82952b0db629..d5f7d28e08e2 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -471,6 +471,8 @@ static inline int retzero(void) { return 0; }
>  #define xfs_sb_validate_fsb_count(sbp, nblks)		(0)
>  #define xlog_calc_iovec_len(len)		roundup(len, sizeof(uint32_t))
>  
> +#define xfs_zoned_add_available(mp, rtxnum)	do { } while (0)
> +
>  /*
>   * Prototypes for kernel static functions that are aren't in their
>   * associated header files.
> diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
> index 3a857181bfa4..3cb47c3c8707 100644
> --- a/libxfs/xfs_bmap.c
> +++ b/libxfs/xfs_bmap.c
> @@ -35,7 +35,6 @@
>  #include "xfs_symlink_remote.h"
>  #include "xfs_inode_util.h"
>  #include "xfs_rtgroup.h"
> -#include "xfs_zone_alloc.h"
>  
>  struct kmem_cache		*xfs_bmap_intent_cache;
>  
> -- 
> 2.47.2
> 
> 
