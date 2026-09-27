Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13F2384CEE;
	Sun, 27 Sep 2026 12:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790511633; cv=none; b=l0rqL52dOIzXJ/dUTOG4ILzloYP7XzL/3X6Qb9RYAjEpq2orTfj6Qs2seBKQ5YHRQZZdD0ZlO1sVM/1JTYrqdJCjy1ybQSgQlNf/gBMiD8JARUEA1OPnGpSTEDbhpE1eav5AOCFZbIToDrtUhvKWC9odD17AoJvB15D8dh79anI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790511633; c=relaxed/simple;
	bh=G/0V/tVdB+1vy6LhPLO5n/2OrJBu9NFwhz9OHan2Hrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sFl2usUtKy8ZdL/E7tEPgphGa1q1ey8biTkEA4chzOlZi0ffSvljL0/cPegcZ22wLR9TCefu1NIPhrW7AeQT0CL5tO7niH7d9zMXcnZYor6/dNl/0In8Q8JEhwtIfqOHkWShm5w34E2WHmwcYcPJ2cv8s7/aKAbCxlsCotGTN3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=caztystI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caztystI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3301F000FF;
	Sun, 27 Sep 2026 12:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790511618;
	bh=27VfbBYrgETQGkFdL79NZbtbr3yqew4IO/tOyRnGkes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=caztystILC3QgadFTMF9F17i4htyxDj/tcf3mMDLf1bA7+l2/8HKvahjv01DL9Wge
	 gmPAtcFzHi3t4pwUHT1ffXPfn5B9M6zFvcq4xDObjKpuOvbfqRRNmFkx+lYa1ln+Gr
	 5D0JoaqKAUw0W6LnN2n1AZEBvXeK820F179vSYyme1hiK2uCsP/xFkVtz2EhsaD8lb
	 e6UcAK1bvJGbbR7sim2JvgxOgkIXg2+1vNJDD+oDgnm6HdqV7aWaILoDYhOyjG4Cul
	 ZEtteKuAKVTub/+yJq6qfHXjMp8nZhHiLKezXtAOnWQM0Vd0+4nCz4WirbtSy/Nc/s
	 K/ZQNgaOICnCQ==
Date: Sun, 27 Sep 2026 20:20:12 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test libxfs handling of missing RT devices
Message-ID: <arkF56Qtd-kQS9jH@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, djwong@kernel.org, 
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260925051519.3002168-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925051519.3002168-1-hch@lst.de>

On Fri, Sep 25, 2026 at 07:15:15AM +0200, Christoph Hellwig wrote:
> Test that libxfs rejects initializing a file systems unless in debugger
> mode by running xfs_repair and xfs_db with missing arguments.  For
> db additionally test that command that require a RT device still do not
> work even after libxfs can be initialized using a missing RT device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/2300     | 39 +++++++++++++++++++++++++++++++++++++++
>  tests/xfs/2300.out | 14 ++++++++++++++
>  2 files changed, 53 insertions(+)
>  create mode 100755 tests/xfs/2300
>  create mode 100644 tests/xfs/2300.out
> 
> diff --git a/tests/xfs/2300 b/tests/xfs/2300
> new file mode 100755
> index 000000000000..9d8bd9c6ae44
> --- /dev/null
> +++ b/tests/xfs/2300
> @@ -0,0 +1,39 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2026 Christoph Hellwig.
> +#
> +# FS QA Test No. 2300
> +#
> +# Tests that repair refuses to work without -r argument, and xfs_db works fine
> +# even without it to check libxfs initialization behavior with missing RT
> +# devices.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick repair db
> +
> +. ./common/filter
> +
> +_require_scratch_nocheck
> +_require_realtime
> +
> +if [ -z "$SCRATCH_RTDEV" ]; then
> +	_notrun "external RT device required"
> +fi

I think "_require_realtime -> _require_external_realtime_device" already covers
the "_notrun" above. I'll help to remove above redundant code when merging.

> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +
> +echo "Dumping superblock using xfs_db without rtdev"
> +$XFS_DB_PROG $SCRATCH_DEV -c 'sb 0' -c 'p' >> $seqres.full
> +
> +echo "Loading RT superblock using xfs_db without rtdev, should fail"
> +$XFS_DB_PROG $SCRATCH_DEV -c 'rtsb'
> +
> +echo "Running xfs_repair -n without rt device, should fail"
> +$XFS_REPAIR_PROG -n $SCRATCH_DEV
> +
> +echo "Running xfs_repair without rt device, should fail"
> +$XFS_REPAIR_PROG $SCRATCH_DEV
> +
> +
> +status=0
> +exit

_exit 0

I'll remove the extra blank line above.

Others look good to me, thanks!

Reviewed-by: Zorro Lang <zlang@kernel.org>

> diff --git a/tests/xfs/2300.out b/tests/xfs/2300.out
> new file mode 100644
> index 000000000000..50aab2b83ec9
> --- /dev/null
> +++ b/tests/xfs/2300.out
> @@ -0,0 +1,14 @@
> +QA output created by 2300
> +Dumping superblock using xfs_db without rtdev
> +Loading RT superblock using xfs_db without rtdev, should fail
> +realtime device not loaded, use -R.
> +Running xfs_repair -n without rt device, should fail
> +Phase 1 - find and verify superblock...
> +xfs_repair: filesystem has a realtime subvolume
> +xfs_repair: realtime device init failed
> +xfs_repair: cannot repair this filesystem.  Sorry.
> +Running xfs_repair without rt device, should fail
> +Phase 1 - find and verify superblock...
> +xfs_repair: filesystem has a realtime subvolume
> +xfs_repair: realtime device init failed
> +xfs_repair: cannot repair this filesystem.  Sorry.
> -- 
> 2.53.0
> 
