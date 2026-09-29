Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA043D47B8;
	Tue, 29 Sep 2026 02:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790647441; cv=none; b=P1DReX594osGz4WKNxEklQepcTSexnbcvwWF4Sz0kS8RHcoepjWYoZMTIfsPlWqknqfUu6FYHNeX7SH/5ilyfOKZ2rxKebpWHFtVknEVtq7lXuv1pw9dYY+gMySuYy2KK/EF76b696RZVx4YbrgANLOjrHSgP2XJ/a7XUUhtjFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790647441; c=relaxed/simple;
	bh=nyaOo48QWZry0dRaKoZW0e8TdZmVQQRpQm0lMrH/pHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kbe5lKR0Nr5Pq8p1IUihxBpuM4qw+c4xQ7TtwYQ5prM/fn+L5/bdmxFXvdCQLQY067+xY5BBUtsrANz1YBJm/ioH/yyMI4mklypF5aSua/Fo/grufLNUyegf3gargJZeo6R4bZqRSPiPEzbl3701UWapwzZESxQyn0KkVO13w04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nf4dMx9E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nf4dMx9E"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5D67B1F000FF;
	Tue, 29 Sep 2026 02:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790647438;
	bh=rRIgKmqR8rhjyYR5TBMgfJ99Q8YfDr2GnsJSGuVCwdA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nf4dMx9EY1b28UiB8wGkhtvvkX67YqdOkDXR+Bsd4XdEZWxnv98UI7yRTd7guc4tx
	 r6ooXYyMSstXzNE7yDb8T/PUOKk4BLPTlijqJ9RZZjcgF13/R0n/hCnPUsu5ZGS6cs
	 Nx4J3QWaIKCUWXDUcmvtE9H84jh/VgbraXXyCWd8XCdym92c9l6cRpZOZM1BlNfUcd
	 9hLngVkN8TGmEEBJ/U0fTt/8ajB9T3z42o0qOjkAsDOV6gRmU5LQ42QMQa6A9gh1am
	 aHfE7YLFBKKSugh9B0JgYKVKvLszwZ3bUeRn7BNXDk8Xe/K5rZNwJjQNzrSFVFfvak
	 KKM3okU/L3cIg==
Date: Mon, 28 Sep 2026 19:03:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/13] xfs/2308: test rebuilding of csum files in
 xfs_repair
Message-ID: <20260929020357.GO2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100855.2734089-14-hch@lst.de>

On Thu, Sep 24, 2026 at 12:07:54PM +0200, Christoph Hellwig wrote:
> Plus handling of corrupted csum files in the kernel as a side effect.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/2308     | 47 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/2308.out |  4 ++++
>  2 files changed, 51 insertions(+)
>  create mode 100755 tests/xfs/2308
>  create mode 100644 tests/xfs/2308.out
> 
> diff --git a/tests/xfs/2308 b/tests/xfs/2308
> new file mode 100755
> index 000000000000..5c4f647ced7a
> --- /dev/null
> +++ b/tests/xfs/2308
> @@ -0,0 +1,47 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2026 Christoph Hellwig.
> +#
> +# FS QA Test No. 2308
> +#
> +# Corrupt rtcsum and check that scrub and different kinds of reads catch them.

Heh ok here's the real meat :D

> +#
> +. ./common/preamble
> +_begin_fstest auto quick zone datacsum scrub
> +
> +. ./common/filter
> +. ./common/fuzzy
> +
> +_require_scratch_nocheck
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount
> +_require_xfs_data_csum $TEST_DIR
> +
> +cat /bin/sh > $SCRATCH_MNT/sh
> +sync $SCRATCH_MNT
> +
> +rg=`xfs_bmap -v $SCRATCH_MNT/sh | _filter_bmap_gno`
> +rg="${rg// /}"
> +
> +_scratch_unmount
> +
> +$XFS_DB_PROG -x $SCRATCH_DEV \
> +	-c "path -m /rtgroups/$rg.csum" \
> +	-c 'dblock 0' \
> +	-c 'write csums[0] 4266'
> +
> +_scratch_mount
> +$XFS_SCRUB_PROG -x -a 1 $SCRATCH_MNT >> $seqres.full 2>&1
> +if [ $? -eq 0 ]; then
> +	_fail "scrub did not find corruption"
> +fi
> +
> +# Test buffered I/O
> +$XFS_IO_PROG -c 'pread 0 64k' $SCRATCH_MNT/sh
> +
> +# Test direct  I/O
> +$XFS_IO_PROG -d -c 'pread 0 64k' $SCRATCH_MNT/sh

Should this also run xfs_repair to make sure that it also notices the
checksum validation errors?

--D

> +
> +status=0
> +exit
> diff --git a/tests/xfs/2308.out b/tests/xfs/2308.out
> new file mode 100644
> index 000000000000..55f6a0c97264
> --- /dev/null
> +++ b/tests/xfs/2308.out
> @@ -0,0 +1,4 @@
> +QA output created by 2308
> +csums[0] = 4266
> +pread: Input/output error
> +pread: Input/output error
> -- 
> 2.53.0
> 
> 
