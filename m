Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B9033E34B;
	Tue, 29 Sep 2026 01:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790647147; cv=none; b=otBxY9NY8BB71FsO3FarfcrfnuWrSG49nSNhStfKkDNQ6DfRybsOSkFZxzEv2ydHhYdqhGXl1iucUzNLMHB6dC0PCeZvWaxqbtz2AITLDK1ATu2YlFx4zcEwfcmM94kQEJ2SKJQaJpJUpQuvmtgY/qsKy0C55nTa+4z8iIAJ9rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790647147; c=relaxed/simple;
	bh=dR7QjYftdReKv8IH3D5i2GzQDloiKir69184ryunugs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HiO8bqBp34cq9KdRM59EZoc8IEOrR5Y61VUarqqjTbq1BPdQe9RaTiafaDQYlMuoQii1lBcdeHGWFSiqa3+IcPhKC84E1RYgFvmB68UCuEaZvmQ4XUusNc/+1zVwZTPnjqwgWmLkzGIZ6nKHr9Qr8AZ5Ip3nqvWsynVR3Sm8TWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OW9cU7or; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OW9cU7or"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4784E1F000FF;
	Tue, 29 Sep 2026 01:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790647146;
	bh=G3Ix7/bpneRQgAKAFllB962KvlRo+my+G6eT2Sf2Vsc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OW9cU7or7M1Em1J5INjXpU9fae9oFSY5AL5aFOMsKYxKmdp86eh+oNHoFSK8VKU4L
	 /8ktwpS8l6m/6+jPKVN48mKixqr7jVlNY/dVbhz7m4Lv9Enmb0FzLtzXxNfK0JVq8H
	 F1aUGlwLP3lZ1dtSlUrU8kOat2wxzUJVnTUZlEuX0fNRzKXNGHuBSjwuhz75oF1UsJ
	 NFZjs4RZDgCkppIm/Zhvj/ywnqRixIgAnDMzaXN7KxLsnlDgs7OXhlL2VOSpRofEVu
	 yqZhhuFvYGFV49Thnvz7svm4au6UvgcgE6yjdJzmBfLU7ZBz5j6G1iUld+lpLlJfzc
	 jp1iI3O8b/JhQ==
Date: Mon, 28 Sep 2026 18:59:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/13] xfs/2306: test mkfs input validation for RT data
 csum options
Message-ID: <20260929015905.GN2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100855.2734089-12-hch@lst.de>

On Thu, Sep 24, 2026 at 12:07:52PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/2306     | 50 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/2306.out | 20 +++++++++++++++++++
>  2 files changed, 70 insertions(+)
>  create mode 100755 tests/xfs/2306
>  create mode 100644 tests/xfs/2306.out
> 
> diff --git a/tests/xfs/2306 b/tests/xfs/2306
> new file mode 100755
> index 000000000000..76dac5bb2a69
> --- /dev/null
> +++ b/tests/xfs/2306
> @@ -0,0 +1,50 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2026 Christoph Hellwig.
> +#
> +# FS QA Test No. 2306
> +#
> +# Test mkfs input checking for the csum and csumbsize options.

I wonder if you want -N so that *only* the options parsing occurs?
That would speed up this test by skipping the actual writes.

OTOH it's useful to test writing out the rtcsum files...

--D

> +#
> +. ./common/preamble
> +_begin_fstest auto quick mkfs zone datacsum
> +
> +. ./common/filter
> +
> +_require_scratch_nocheck
> +
> +expect_fail()
> +{
> +	opts=$1
> +	msg=$2
> +
> +	echo "Testing $msg (expect failure)"
> +	$MKFS_XFS_PROG -f $opts $SCRATCH_DEV 2>&1 | head -n1
> +}
> +
> +expect_fail "-r csum=crc32c" "csum option without zoned"
> +expect_fail "-r csumbsize=32k" "csumbsize option without zoned"
> +expect_fail "-r zoned,csum=crc16" "invalid csum value"
> +expect_fail "-r zoned,csum=crc32c,csumbsize=1k" "too small csumbsize"
> +expect_fail "-r zoned,csum=crc32c,csumbsize=48k" "non-pow2 csumbsize"
> +expect_fail "-r zoned,csum=crc32c,csumbsize=128k" "too large csumbsize"
> +expect_fail "-b size=64k -r zoned,csum=crc32c,csumbsize=32k" "csumbsize < bsize"
> +
> +expect_pass()
> +{
> +	opts=$1
> +	msg=$2
> +
> +	echo "Testing $msg (expect pass)"
> +	$MKFS_XFS_PROG -f $opts $SCRATCH_DEV >> $seqres.full 2>&1 || \
> +		_fail "could not mkfs for $opts"
> +}
> +
> +expect_pass "-r zoned,csum=none" "csum=none"
> +expect_pass "-r zoned,csum=crc32c" "csum=crc32c"
> +expect_pass "-r zoned,csum=crc64" "csum=crc64"
> +expect_pass "-r zoned,csum=crc64,csumbsize=32k" "csum=crc64,csumbsize=32k"
> +expect_pass "-r zoned,csum=crc64,csumbsize=64k" "csum=crc64,csumbsize=64k"
> +
> +status=0
> +exit
> diff --git a/tests/xfs/2306.out b/tests/xfs/2306.out
> new file mode 100644
> index 000000000000..5e79103212ad
> --- /dev/null
> +++ b/tests/xfs/2306.out
> @@ -0,0 +1,20 @@
> +QA output created by 2306
> +Testing csum option without zoned (expect failure)
> +data checksums not supported without zoned mode
> +Testing csumbsize option without zoned (expect failure)
> +RT data csum block size options requires RT data csum type.
> +Testing invalid csum value (expect failure)
> +unknown option -r crc16
> +Testing too small csumbsize (expect failure)
> +Invalid value 1k for -r csumbsize option. Value is too small.
> +Testing non-pow2 csumbsize (expect failure)
> +RT data csum block size of 49152 bytes is not a power of 2
> +Testing too large csumbsize (expect failure)
> +Invalid value 128k for -r csumbsize option. Value is too large.
> +Testing csumbsize < bsize (expect failure)
> +RT data csum block size of 32768 bytes is smaller than fsblock size 65536.
> +Testing csum=none (expect pass)
> +Testing csum=crc32c (expect pass)
> +Testing csum=crc64 (expect pass)
> +Testing csum=crc64,csumbsize=32k (expect pass)
> +Testing csum=crc64,csumbsize=64k (expect pass)
> -- 
> 2.53.0
> 
> 
