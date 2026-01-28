Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B582426CE2C
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 05:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769577093; cv=none; b=KJUkiwJ6hiCxYp/vhyP0Iy8on1dARNjfjAIgpvnJlWBiyr5/n2bzXyRF4kMBdrdejqXhyfQrxyOzFfRLplo5DVvSoWkBAsx1XWQKQIDsNLQy/XhthNY4ou+KC4svh/v+bxnjljm2j74jn+snkbZVjB15a1Wq1opvYnHXj9QoFgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769577093; c=relaxed/simple;
	bh=2d3kBRfd034Quvy9RzbqvsA1UGk6uWqvdK1EJRZFqQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+Lk/+7pQ382xQ0iwU0KeO9h31+ibJmX1c68g6UppJekVUlm5hD7hNMU8vGh6KwrNkiKRASIGcwASMjQyR4rSpKkcZow3Tr/BALNzReqxesu1Hzs4UoO3Kdk5eoINSVq0hXAyuCpgKyDi2Jgd2W+wgWumpZDzKcZB25guy5wANo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOk3/aL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOk3/aL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E819C4CEF1;
	Wed, 28 Jan 2026 05:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769577093;
	bh=2d3kBRfd034Quvy9RzbqvsA1UGk6uWqvdK1EJRZFqQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YOk3/aL2sro6ruKH7D8XUazD3Gxl8AgOUonqhFh/xnNBZtPa/hpdrxlQpbDTgtMdE
	 gDkMXLCzIeu0Dnidjk+yJ0QysnDihRjQQJDvswzQsbNSpAOzKN2gSRbX7qQnEVqlob
	 gCc/qukrdGo9cuVE0VtUKrS4MevYvzchnwn3VNOlvgY/dA56ePUjYok8lfE2zwZtfs
	 qIdo5haN/ro07Xhc/4MuhCBBXgTY8PZJGTP52w/CCarOS/6nV/monw0od7AK/XpitK
	 gycdtDWwuU5uFuoGPgHSQBz+8JQsVwuB0AgRiaiHDDuNhOHNXI1XqQS7I9QcAy2dE5
	 ewjVrCnpF3HcA==
Date: Tue, 27 Jan 2026 21:11:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] include blkzoned.h in platform_defs.h
Message-ID: <20260128051133.GQ5945@frogsfrogsfrogs>
References: <20260128043318.522432-1-hch@lst.de>
 <20260128043318.522432-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128043318.522432-2-hch@lst.de>

On Wed, Jan 28, 2026 at 05:32:55AM +0100, Christoph Hellwig wrote:
> We'll need to conditionally add definitions added in later version of
> blkzoned.h soon.  The right place for that is platform_defs.h, which
> means blkzoned.h needs to be included there for cpp trickery to work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I was /almost/ about to get cranky about including blkzoned.h
unconditionally but then I noticed that the header has been in
include/uapi/ since October 2016.

So I guess it won't cause any problems with a current distro release.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  include/platform_defs.h   | 1 +
>  libxfs/xfs_zones.c        | 1 -
>  mdrestore/xfs_mdrestore.c | 1 -
>  mkfs/xfs_mkfs.c           | 1 -
>  repair/zoned.c            | 1 -
>  5 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/include/platform_defs.h b/include/platform_defs.h
> index da966490b0f5..1152f0622ccf 100644
> --- a/include/platform_defs.h
> +++ b/include/platform_defs.h
> @@ -24,6 +24,7 @@
>  #include <stdbool.h>
>  #include <libgen.h>
>  #include <urcu.h>
> +#include <linux/blkzoned.h>
>  
>  /* long and pointer must be either 32 bit or 64 bit */
>  #define BITS_PER_LONG (sizeof(long) * CHAR_BIT)
> diff --git a/libxfs/xfs_zones.c b/libxfs/xfs_zones.c
> index 7a81d83f5b3e..c1ad7075329c 100644
> --- a/libxfs/xfs_zones.c
> +++ b/libxfs/xfs_zones.c
> @@ -3,7 +3,6 @@
>   * Copyright (c) 2023-2025 Christoph Hellwig.
>   * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
>   */
> -#include <linux/blkzoned.h>
>  #include "libxfs_priv.h"
>  #include "xfs.h"
>  #include "xfs_fs.h"
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index b6e8a6196a79..eece58977f97 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -8,7 +8,6 @@
>  #include "xfs_metadump.h"
>  #include <libfrog/platform.h>
>  #include "libfrog/div64.h"
> -#include <linux/blkzoned.h>
>  
>  union mdrestore_headers {
>  	__be32				magic;
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index b34407725f76..46f4faf4de5a 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -6,7 +6,6 @@
>  #include "libfrog/util.h"
>  #include "libxfs.h"
>  #include <ctype.h>
> -#include <linux/blkzoned.h>
>  #include "libxfs/xfs_zones.h"
>  #include "xfs_multidisk.h"
>  #include "libxcmd.h"
> diff --git a/repair/zoned.c b/repair/zoned.c
> index 206b0158f95f..49cc43984883 100644
> --- a/repair/zoned.c
> +++ b/repair/zoned.c
> @@ -3,7 +3,6 @@
>   * Copyright (c) 2024 Christoph Hellwig.
>   */
>  #include <ctype.h>
> -#include <linux/blkzoned.h>
>  #include "libxfs_priv.h"
>  #include "libxfs.h"
>  #include "xfs_zones.h"
> -- 
> 2.47.3
> 
> 
