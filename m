Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2637E170A18;
	Thu, 22 Aug 2024 20:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724360072; cv=none; b=ny900IY2TbMC+S1qk9X+x/tYS2hbYArgX3KmSRibNs6p+V6McNVpz4bgq1PlgIR1/6igarMKUzFaNeRWrBCkUOHn8OIl5EcfS35DOtR6XB1v5RxAolQWJHkoMTvh1yjqttROQKWlSlsQ8M5VeqV1vyl4AVmBKPdD3KpGzwJY08U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724360072; c=relaxed/simple;
	bh=OGivwRbCZjDo85iQQwUrGF/ww9g1WqgA3umDFoCZTl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oa8WQ7IAPG7b2RGewkiFzXCRekmsd+lwBH9FjTh9DPDZyOiD3MDHOTVUiWoePWsXHNibGZwy97tOonFrZxweEjaa5AIsFuVcx6FWO0VJkWmk0vyQljC1xtNNuxwJEFNFt50+TDS+/px0snguhmcw5e7O9H2eB+pvyjOQm1f7XwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBcEbiIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBcEbiIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97861C32782;
	Thu, 22 Aug 2024 20:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724360071;
	bh=OGivwRbCZjDo85iQQwUrGF/ww9g1WqgA3umDFoCZTl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DBcEbiIM8Xq1u4OCRK1zwRAiStiBWZtksLZZ9Txi8q2+aKZIHZ2ueFq8xJ7y/PVDE
	 +DE2zjU5bBdc3Te1F/UoPRwUfKt9IBiAf8yP+/8tG50OzXwR1gIZzaIZz3HriXJ3NI
	 6X6WGcfEtp4nShqBHxDaRI2D3FYPLY30NR6ceOSblknjIVuHRyBWLch0G/qefzm9/q
	 vH9kEhLhHar/7MTfljFYLlH2aorbt4VQADYAa76R3uEVEeE8TYefQxYJ26g2eGkR8n
	 HRsieaOP2sWms8peCFwDenyDCwpCj9af4LXP3pqQNEBwKYrtRq/OH6rkdl68TE5vPT
	 Yjfl4VdUvNlEw==
Date: Thu, 22 Aug 2024 13:54:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	josef@toxicpanda.com, david@fromorbit.com
Subject: Re: [PATCH 3/3] generic: test to run fsx eof pollution
Message-ID: <20240822205430.GX865349@frogsfrogsfrogs>
References: <20240822144422.188462-1-bfoster@redhat.com>
 <20240822144422.188462-4-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822144422.188462-4-bfoster@redhat.com>

On Thu, Aug 22, 2024 at 10:44:22AM -0400, Brian Foster wrote:
> Filesystem regressions related to partial page zeroing can go
> unnoticed for a decent amount of time. A recent example is the issue
> of iomap zero range not handling dirty pagecache over unwritten
> extents, which leads to wrong behavior on certain file extending
> operations (i.e. truncate, write extension, etc.).
> 
> fsx does occasionally uncover these sorts of problems, but failures
> can be rare and/or require longer running tests outside what is
> typically run via full fstests regression runs. fsx now supports a
> mode that injects post-eof data in order to explicitly test partial
> eof zeroing behavior. This uncovers certain problems more quickly
> and applies coverage more broadly across size changing operations.
> 
> Add a new test that runs an fsx instance (modeled after generic/127)
> with eof pollution mode enabled. While the test is generic, it is
> currently limited to XFS as that is currently the only known major
> fs that does enough zeroing to satisfy the strict semantics expected
> by fsx. The long term goal is to uncover and fix issues so more
> filesystems can enable this test.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  tests/generic/362     | 27 +++++++++++++++++++++++++++
>  tests/generic/362.out |  2 ++
>  2 files changed, 29 insertions(+)
>  create mode 100755 tests/generic/362
>  create mode 100644 tests/generic/362.out
> 
> diff --git a/tests/generic/362 b/tests/generic/362
> new file mode 100755
> index 00000000..30870cd0
> --- /dev/null
> +++ b/tests/generic/362
> @@ -0,0 +1,27 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FSQA Test No. 362
> +#
> +# Run fsx with EOF pollution enabled. This provides test coverage for partial
> +# EOF page/block zeroing for operations that change file size.
> +#
> +
> +. ./common/preamble
> +_begin_fstest rw auto
> +
> +FSX_FILE_SIZE=262144
> +# on failure, replace -q with -d to see post-eof writes in the dump output
> +FSX_ARGS="-q -l $FSX_FILE_SIZE -e 1 -N 100000"
> +
> +_require_test
> +
> +# currently only xfs performs enough zeroing to satisfy fsx
> +_supported_fs xfs

Should get rid of this. ;)

> +ltp/fsx $FSX_ARGS $FSX_AVOID $TEST_DIR/fsx.$seq > $tmp.output 2>&1

I wonder, is there a reason not to use run_fsx from common/rc?

Otherwise this looks ok to me.

--D

> +cat $tmp.output
> +
> +status=0
> +exit
> diff --git a/tests/generic/362.out b/tests/generic/362.out
> new file mode 100644
> index 00000000..7af6b96a
> --- /dev/null
> +++ b/tests/generic/362.out
> @@ -0,0 +1,2 @@
> +QA output created by 362
> +All 100000 operations completed A-OK!
> -- 
> 2.45.0
> 
> 
