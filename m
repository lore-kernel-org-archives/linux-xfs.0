Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959A83254AC;
	Mon, 15 Dec 2025 19:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826753; cv=none; b=LLWrIQYpt42+iB5fXA9NUcXqcMn19Yzef2sFiUlkZ+LSa4+RWo2YFJn43ExqgOj1AB79Ad2RyoFPiYEtzjZb7JGWK8B4SOf6YKRbEKoZs1c6DqqJJ9GmPMByhGVe9q/QnXv/Xo17acwKZePLPICiJ5lRXCCqWbGQBCy1GKyJs4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826753; c=relaxed/simple;
	bh=PGYnLgduNN5eGHwe4uE1s/WwyAcmoq1oR0d3qfSDNCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jTh4jFQRpduPgvL/SFKk5tsgjyu+VnULYNXtYMiiGK2JA3uZGLkt72WJGoCiUyygSPdBIDGsoAoOChiD0+niRXHls6sk+Hp32xSJEgadpNSomad7hYccAPNEDthLM+1Ga4kkKl4Jvip+leFYw8voKHWEjgpz83zsTB/WfoG69sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WTCVibvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WTCVibvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D31EC4CEF5;
	Mon, 15 Dec 2025 19:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765826753;
	bh=PGYnLgduNN5eGHwe4uE1s/WwyAcmoq1oR0d3qfSDNCc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WTCVibvLmrJedQ5bcCXN25xTjBLyMIjFOkBIcUJ5LvmX2SCQa+OcXeTnnqb4WATkU
	 trGQvVXTXkbUFFAdMTsf/RGwyLqIaPZ7HU2fuf+lkFUYGYUo9ZPEFga35yCdxI+P04
	 Pb2kgb2EChCs0TMwDXJ71eZeBXAl6MPL8Rpai2RAqw/NvDDWmYcE8VwGOpw8QFQ9aZ
	 pfGVB0bL3KJWWzxVD/VcaQskwAal/yIwePDHDdr2NndH+G3WbrS5dssO+cASmR4Wht
	 nm1ZhDBe4NPowjCx1Ba5I9iAWpCBQdc5CdiE0KcAs+fZU45GosPPhc5gEMSAjG0UrE
	 VUX9oRrL+74EA==
Date: Mon, 15 Dec 2025 11:25:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: add a test that mkfs round up realtime
 subvolume sizes to the zone size
Message-ID: <20251215192552.GK7725@frogsfrogsfrogs>
References: <20251215095036.537938-1-hch@lst.de>
 <20251215095036.537938-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215095036.537938-4-hch@lst.de>

On Mon, Dec 15, 2025 at 10:50:29AM +0100, Christoph Hellwig wrote:
> Make sure mkfs doesn't create unmountable file systems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/653     | 33 +++++++++++++++++++++++++++++++++
>  tests/xfs/653.out |  2 ++
>  2 files changed, 35 insertions(+)
>  create mode 100755 tests/xfs/653
>  create mode 100644 tests/xfs/653.out
> 
> diff --git a/tests/xfs/653 b/tests/xfs/653
> new file mode 100755
> index 000000000000..07d9125c2ff0
> --- /dev/null
> +++ b/tests/xfs/653
> @@ -0,0 +1,33 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2025 Christoph Hellwig.
> +#
> +# FS QA Test No. 653
> +#
> +# Tests that mkfs for a zoned file system rounds realtime subvolume sizes up to
> +# the zone size to create mountable file systems.

What size rt volume does this create?  It looks like you're specifying
an rt zone size of ... (1GB + 52K)?  And testing that mkfs rounds the
rt volume size down to some multiple of that?  Or is it rounding the
*zone* size down to 1G?

<confused>

--D

> +. ./common/preamble
> +_begin_fstest auto quick realtime growfs zone
> +
> +. ./common/filter
> +. ./common/zoned
> +
> +_require_realtime
> +_require_scratch
> +_require_scratch_size $((2 * 1024 * 1024)) # 1GiB in kiB units
> +
> +fsbsize=4096
> +unaligned_size=$((((1 * 1024 * 1024 * 1024) + (fsbsize * 13)) / fsbsize))
> +
> +# Manual mkfs and mount to not inject an existing RT device
> +echo "Try to format file system"
> +_try_mkfs_dev -b size=4k -r zoned=1,size=${unaligned_size}b $SCRATCH_DEV \
> +		>> $seqres.full 2>&1 ||\
> +	_notrun "cannot mkfs zoned filesystem"
> +_mount $SCRATCH_DEV $SCRATCH_MNT
> +umount $SCRATCH_MNT
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/653.out b/tests/xfs/653.out
> new file mode 100644
> index 000000000000..2cba5cdf1171
> --- /dev/null
> +++ b/tests/xfs/653.out
> @@ -0,0 +1,2 @@
> +QA output created by 653
> +Try to format file system
> -- 
> 2.47.3
> 
> 
