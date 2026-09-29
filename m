Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551B82DCF45;
	Tue, 29 Sep 2026 01:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790646126; cv=none; b=MJZeHl4BWT4m5b6Bs3V4wdx9FlMvvvKW4wclZ59UcX+CQWHbTLrSKohV5tPA5wytw16bRxwcIE0dVsKoyv7XarOS6U7eUfwjU5qpbxGi9OqwrXaofet1TzchBXLuN9Vy9GwzYwZZ7/jjpxqVqUfUufIVEMdx9ETABpFwbhrJdH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790646126; c=relaxed/simple;
	bh=axvjDf4ANynwtCYeKuads9RtPTdWo7cbFS3qp/xOxbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QFSqmBI9RltCBomD7LKCEY7YH8C306SREtWnPOZCHPJRthqx5k2qRbBWeuAiA9zymwl8m1IFtQJeov1eMx1XKR55Fm+NhhT87i7yGsI7mQ4JKQfsEaYqg9/naXa1MfQBe2FjUshBOlLqAkcQ+pCWbyysg77fcP5H4tSesrs0V5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GYs5WB/N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GYs5WB/N"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E4DFB1F000FF;
	Tue, 29 Sep 2026 01:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790646125;
	bh=f4kFL01/YD6ELDixNESa9+8kJo/Iy2OD/a1UC5b21wY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GYs5WB/NkWJy7HKH5fFoCBOlUojo0vXvVmA1VLrQgByr/3sPeJ5R6b5rkXINaTCtw
	 ZRc9gCA8H7mbe+nGURRfbtvDWUapvpkNlK1QSy4L3AkTlCFqVqzT6TYHlt0162AgLt
	 Sa3Lx8lXCbDm4b1nVLUty0zGggXkzt7axiiLdTSEEX80msA6uIYMUoI1BHowxCaFJd
	 KkLpW4qm2Qzm38wjHJcBbY2Q+q63pa7cJ3FdXGVJ1hQ1mOrM5xJrxel6pAz/gLih4s
	 3Uun8+Z2phz4kG02OneWLrjf5i5mRQHtj/bm4Y3UPoIR/6Nt8HMy0ieiiANM8NfTxA
	 XIg0RTv+2Gktg==
Date: Mon, 28 Sep 2026 18:42:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/13] xfs/2301: test lazy bounce buffering mode
Message-ID: <20260929014204.GI2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100855.2734089-7-hch@lst.de>

On Thu, Sep 24, 2026 at 12:07:47PM +0200, Christoph Hellwig wrote:
> Run fsx (based on generic/091) while injecting lazy bounce buffer
> retries for reads.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/2301     | 43 +++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/2301.out | 13 +++++++++++++
>  2 files changed, 56 insertions(+)
>  create mode 100755 tests/xfs/2301
>  create mode 100644 tests/xfs/2301.out
> 
> diff --git a/tests/xfs/2301 b/tests/xfs/2301
> new file mode 100755
> index 000000000000..605510c6dbc8
> --- /dev/null
> +++ b/tests/xfs/2301
> @@ -0,0 +1,43 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
> +# Copyright (c) 2026 Christoph Hellwig.
> +#
> +# FS QA Test No. 2301
> +#
> +# Run fsx with error injection for re-retries with bounce buffers, simulating

Aren't these just retries?

> +# users modifying the in-flight data buffer.
> +#
> +. ./common/preamble
> +_begin_fstest rw auto quick datacsum
> +
> +. ./common/filter
> +. ./common/inject
> +
> +_require_test
> +_require_odirect
> +_require_xfs_data_csum $TEST_DIR
> +
> +psize=`$here/src/feature -s`
> +bsize=`$here/src/min_dio_alignment $TEST_DIR $TEST_DEV`
> +
> +_test_inject_error bounce_reread 100

Were it not for this I'd say this should be a generic test.  But I guess
generic/091 tests the no-bounce code paths just fine, right?

> +# fsx load similar to generic/091
> +echo "Testing direct I/O"
> +run_fsx -N 10000            -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +run_fsx -N 10000  -o 8192   -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +run_fsx -N 10000  -o 32768  -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +run_fsx -N 10000  -o 8192   -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +run_fsx -N 10000  -o 32768  -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +run_fsx -N 10000  -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
> +
> +# fsx load similar to generic/091 but using buffered I/O
> +echo "Testing buffered I/O"
> +run_fsx -N 10000            -l 500000
> +run_fsx -N 10000  -o 8192   -l 500000
> +run_fsx -N 10000  -o 32768  -l 500000
> +run_fsx -N 10000  -o 128000 -l 500000
> +
> +status=0
> +exit

_exit 0

--D

> diff --git a/tests/xfs/2301.out b/tests/xfs/2301.out
> new file mode 100644
> index 000000000000..221a3185970c
> --- /dev/null
> +++ b/tests/xfs/2301.out
> @@ -0,0 +1,13 @@
> +QA output created by 2301
> +Testing direct I/O
> +fsx -N 10000 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 8192 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 32768 -l 500000 -r BSIZE -w BSIZE -Z -R -W
> +fsx -N 10000 -o 128000 -l 500000 -r BSIZE -w BSIZE -Z -W
> +Testing buffered I/O
> +fsx -N 10000 -l 500000
> +fsx -N 10000 -o 8192 -l 500000
> +fsx -N 10000 -o 32768 -l 500000
> +fsx -N 10000 -o 128000 -l 500000
> -- 
> 2.53.0
> 
> 
