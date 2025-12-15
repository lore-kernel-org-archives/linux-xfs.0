Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967973451CA;
	Mon, 15 Dec 2025 19:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765827226; cv=none; b=pScpULycanDH2DLy7fJ/EIK1RG4jd9Cca7BcB1ZJIJ/nzlVjKRAvaPdvudND95tKM3RgLQP6idQU7uhRNucUF9F3Tx+XGnOjB7bO+ecDD8zKijmqahUG257nRrA3hVRNenvViVglyBFuLdjnywwuBeskd+Ai9Rm0K9eEjmfnH8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765827226; c=relaxed/simple;
	bh=0s5EcIFiND0XMGM+9m1O7YQGiGqO2Dc1fabTBo/ggeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mw3ZfTX+jDHDXc4RBfQhlhx5lpjntKCOakf7pkWkMZSGlMBCFi6ywPROxfUBCTvPeKZqsahKx7E8Ll672chV/gEq0xuHdN+U7gB4eNl/0KGcwhhE0a9lpOMJTiWObla1qU3NoIbzBoP0fjRo7oZh9W7aDjcWpR9LJha6jfOtQ34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FRCcR2/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FRCcR2/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B634C116B1;
	Mon, 15 Dec 2025 19:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765827226;
	bh=0s5EcIFiND0XMGM+9m1O7YQGiGqO2Dc1fabTBo/ggeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FRCcR2/kMUwEDEFfsvyqknF/pToIGLhtuTN2jDpiSgPyUkX5ILcTaFV53DZWQSGyK
	 /otQNNg7weIbe/2Z8Zq6QXBpVhUnfeGnI0vLrnLFnXLkSm8iVnu7ees7tde3QLo9kv
	 7kePmNSmcbud3KbU6mtV49dpaXGnJae1Yrl2RE0cEp2lspqDo4GJwOpNtGmnSOxgsv
	 qV/u0tGWXD7Vn9rM2P2j+ILdNnRW86nP+wCTbaD+bIJhkP8JXuQYCk+fkx8Gar8Z6t
	 lZn+svF9ai90f7Qb5XvdBs1kHlkGO33bwEkvjKn8iyQTQY+PvfNJDbp4VtiHM5EmfB
	 h63YdgpFbFRaw==
Date: Mon, 15 Dec 2025 11:33:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add a test that zoned file systems with rump
 RTG can't be mounted
Message-ID: <20251215193345.GM7725@frogsfrogsfrogs>
References: <20251215095036.537938-1-hch@lst.de>
 <20251215095036.537938-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215095036.537938-2-hch@lst.de>

On Mon, Dec 15, 2025 at 10:50:27AM +0100, Christoph Hellwig wrote:
> Garbage collection assumes all zones contain the full amount of blocks.
> Mkfs already ensures this happens, but the kernel mount code did not
> verify this.  Instead such a file system would eventually fail scrub.
> 
> Add a test to verify the new superblock verifier check.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/651     | 30 ++++++++++++++++++++++++++++++
>  tests/xfs/651.out |  2 ++
>  2 files changed, 32 insertions(+)
>  create mode 100755 tests/xfs/651
>  create mode 100644 tests/xfs/651.out
> 
> diff --git a/tests/xfs/651 b/tests/xfs/651
> new file mode 100755
> index 000000000000..1fa9627098f6
> --- /dev/null
> +++ b/tests/xfs/651
> @@ -0,0 +1,30 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Christoph Hellwig.
> +#
> +# FS QA Test No. 651
> +#
> +# Test that the sb verifier rejects zoned file system with rump RTGs.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick zone
> +
> +. ./common/zoned
> +
> +_require_scratch_nocheck
> +
> +_scratch_mkfs > /dev/null 2>&1
> +blocks=$(_scratch_xfs_db -c 'sb 0' -c 'print rblocks' | awk '{print $3}')
> +blocks=$((blocks - 4096))
> +_scratch_xfs_db -x -c 'sb 0' -c "write -d rblocks $blocks" > /dev/null 2>&1
> +_scratch_xfs_db -x -c 'sb 0' -c "write -d rextents $blocks" > /dev/null 2>&1

You could put both of the write commands in the same invocation, e.g.

_scratch_xfs_db -x \
	-c 'sb 0' \
	-c "write -d rblocks $blocks" \
	-c "write -d rextents $blocks" > /dev/null 2>&1

For a little bit lower runtime.

> +
> +if _try_scratch_mount >/dev/null 2>&1; then
> +	# for non-zoned file systems this can succeed just fine
> +	_require_xfs_scratch_non_zoned

The logic in this test looks fine to me, but I wonder: have you (or
anyone else) gone to Debian 13 and noticed this:

# mount /dev/sda /mnt
# mount /dev/sda /mnt
# grep /mnt /proc/mounts
/dev/sda /mnt xfs rw,relatime,inode64,logbufs=8,logbsize=32k,noquota 0 0
/dev/sda /mnt xfs rw,relatime,inode64,logbufs=8,logbsize=32k,noquota 0 0

It looks like util-linux switched to the new fsopen mount API between
Debian 12 and 13, and whereas the old mount(8) would fail if the fs was
already mounted, the new one just creates two mounts, which both then
must be unmounted.  So now I'm hunting around for unbalanced
mount/unmount pairs in fstests. :(

Anyhow the test looks fine, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +fi
> +
> +echo "Can't mount rump RTG file system (good)"
> +
> +status=0
> +exit
> diff --git a/tests/xfs/651.out b/tests/xfs/651.out
> new file mode 100644
> index 000000000000..5d491b1894ea
> --- /dev/null
> +++ b/tests/xfs/651.out
> @@ -0,0 +1,2 @@
> +QA output created by 651
> +Can't mount rump RTG file system (good)
> -- 
> 2.47.3
> 
> 
