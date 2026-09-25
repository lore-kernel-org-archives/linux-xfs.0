Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCAC2E7162
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 23:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790378866; cv=none; b=a3tEtWYl8eL3033NCGX5Fv4Pj+qFMPOaE16n0HlcfRV34yUJiDe6A1OEBl2c9YzBo65JFtB0xSV80HW/aOCTADbe+4OLmf9FecQ0HZ3LNWGshAxJAiIi0s9W3mal/GQzx8AfN5Ea5WGcBJ7zR2NpdeexvWVpw7i1JDgQOwZVwQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790378866; c=relaxed/simple;
	bh=m+YjgbJaXI+CmJ9ouul6ZOt5qmRv4ECOnv9RfO5ucJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M36T4VyiQvegOT3+9zNu7Rd2tfwhawzh02VaWtECiyb/HJ989ckuQQJqdijVryLRUokpJ5n3gkz/hknF6VAKQEnk6e3P/lZhySwlFxWQyT00j6VByvapeKTIk/w7JJL4EkLrMIGzD5k3KlaiCPW03PRywLtBwFz17f89aME163g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jM3bwZlj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jM3bwZlj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7E33C1F000FF;
	Fri, 25 Sep 2026 23:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790378864;
	bh=FQya7SRBFy0k5259PuzjjK8SKhUNKAxJeQ2+WF3Y9xQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jM3bwZljqDf5ZeuFwNOQy/fx5owKoITHUUjGwJkx/DVwYayWzXUe9A6Q4zsP2uyC4
	 5Tci5NwmL56f1OSXfI5fzAOreZGD9hLF+nEDUsjBxYJgawOizTA/OUDYntWNUHjChi
	 9+bBLt7z6IOom6z9ALMxjsNuCTQK6Z/rC3xbyuPLiaZJgEircr7d8JiSh8H2Tk70px
	 j16eLO6Btm+Z0t/hz+WJqNgiv78ew/CbXIWLUtBZlwtQV6U3PSaBQrXDh+9lm5HD8s
	 s9m5aPcuijpHJtx5O8x8z7rruZxpd7ejRt3ec3F/qb0aL1TZKfBfRNHcp+nd6Ededx
	 92o2VM68uvXVQ==
Date: Fri, 25 Sep 2026 16:27:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/32] libxfs: add SZ_* constants
Message-ID: <20260925232744.GJ2705364@frogsfrogsfrogs>
References: <20260924100512.2733748-1-hch@lst.de>
 <20260924100512.2733748-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100512.2733748-7-hch@lst.de>

On Thu, Sep 24, 2026 at 12:03:56PM +0200, Christoph Hellwig wrote:
> Import a slightly adapted version of <linux/sizes.h> from the kernel so that
> we can use these constants in shared libxfs code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Marvelous!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  include/libxfs.h      |  1 +
>  include/sizes.h       | 67 +++++++++++++++++++++++++++++++++++++++++++
>  libxfs/xfs_platform.h |  1 +
>  3 files changed, 69 insertions(+)
>  create mode 100644 include/sizes.h
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 7f0c22ef4991..34dd267831c0 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -18,6 +18,7 @@
>  #include "platform_defs.h"
>  #include "xfs.h"
>  
> +#include "sizes.h"
>  #include "list.h"
>  #include "hlist.h"
>  #include "cache.h"
> diff --git a/include/sizes.h b/include/sizes.h
> new file mode 100644
> index 000000000000..69075e8f3370
> --- /dev/null
> +++ b/include/sizes.h
> @@ -0,0 +1,67 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __SIZES_H__
> +#define __SIZES_H__
> +
> +#define SZ_1				0x00000001
> +#define SZ_2				0x00000002
> +#define SZ_4				0x00000004
> +#define SZ_8				0x00000008
> +#define SZ_16				0x00000010
> +#define SZ_32				0x00000020
> +#define SZ_64				0x00000040
> +#define SZ_128				0x00000080
> +#define SZ_256				0x00000100
> +#define SZ_512				0x00000200
> +
> +#define SZ_1K				0x00000400
> +#define SZ_2K				0x00000800
> +#define SZ_4K				0x00001000
> +#define SZ_8K				0x00002000
> +#define SZ_16K				0x00004000
> +#define SZ_24K				0x00006000
> +#define SZ_32K				0x00008000
> +#define SZ_64K				0x00010000
> +#define SZ_128K				0x00020000
> +#define SZ_192K				0x00030000
> +#define SZ_256K				0x00040000
> +#define SZ_384K				0x00060000
> +#define SZ_512K				0x00080000
> +
> +#define SZ_1M				0x00100000
> +#define SZ_2M				0x00200000
> +#define SZ_3M				0x00300000
> +#define SZ_4M				0x00400000
> +#define SZ_6M				0x00600000
> +#define SZ_8M				0x00800000
> +#define SZ_12M				0x00c00000
> +#define SZ_16M				0x01000000
> +#define SZ_18M				0x01200000
> +#define SZ_24M				0x01800000
> +#define SZ_32M				0x02000000
> +#define SZ_64M				0x04000000
> +#define SZ_128M				0x08000000
> +#define SZ_256M				0x10000000
> +#define SZ_512M				0x20000000
> +
> +#define SZ_1G				0x40000000
> +#define SZ_2G				0x80000000
> +
> +#define SZ_4G				0x100000000ULL
> +#define SZ_8G				0x200000000ULL
> +#define SZ_16G				0x400000000ULL
> +#define SZ_32G				0x800000000ULL
> +#define SZ_64G				0x1000000000ULL
> +#define SZ_128G				0x2000000000ULL
> +#define SZ_256G				0x4000000000ULL
> +#define SZ_512G				0x8000000000ULL
> +
> +#define SZ_1T				0x10000000000ULL
> +#define SZ_2T				0x20000000000ULL
> +#define SZ_4T				0x40000000000ULL
> +#define SZ_8T				0x80000000000ULL
> +#define SZ_16T				0x100000000000ULL
> +#define SZ_32T				0x200000000000ULL
> +#define SZ_64T				0x400000000000ULL
> +#define SZ_128T				0x800000000000ULL
> +
> +#endif /* __SIZES_H__ */
> diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
> index a61d50de9dc0..0aeb80fb8244 100644
> --- a/libxfs/xfs_platform.h
> +++ b/libxfs/xfs_platform.h
> @@ -45,6 +45,7 @@
>  #include "platform_defs.h"
>  #include "xfs.h"
>  
> +#include "sizes.h"
>  #include "list.h"
>  #include "hlist.h"
>  #include "cache.h"
> -- 
> 2.53.0
> 
> 
