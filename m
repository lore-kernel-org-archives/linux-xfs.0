Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023EA1C2BD;
	Thu, 29 Aug 2024 01:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724895423; cv=none; b=MXh/6yIOFWGbN2N4qgzlZLG1U6D0rK5UepIbRWmj9bwhCXQ1VrzKN4MPdqSEd/3+RZ96LxSrPrB1xzA3dpGj20LL41XaL3qM9ZqxwUToKoCSWlezDRQX3FKdpIK+7GCJGz8onX88zbkJpbIZ+P35pZLX4naETqN7XTCmru7EVrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724895423; c=relaxed/simple;
	bh=PTGnsmunYnDgG8KW45HibCbCUBkY5Cs6937TPjjgD1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oeSIztPygwuFZPFd8oaUPThbpdcGW5ZdPX0pe3tCOFNEiSg2lGkCrGKICITYPfyU9lHxAPjKbIuhurQixs+tRbWfcJa0vExWj6k+cLeaYSgocO0XkAW8MzasfZuHjDJTk9zaypfSVrX7ut+SbKamkgH5T6qIx0/WGNAHxSq7Lew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lEbFUnnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lEbFUnnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A42FC4CEC0;
	Thu, 29 Aug 2024 01:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724895422;
	bh=PTGnsmunYnDgG8KW45HibCbCUBkY5Cs6937TPjjgD1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lEbFUnnmDlaBvh53yiIQmBuTXkGqGAeGL8ivX72qlpSWPy38Giih+aXHPqlS5eR2M
	 pAVQuQZLokSKEcQSEsCWpmojBQckXPOVLHVm6AweP7OdiPB+24JbVCIynGFuDE1C4N
	 AG2470y33h+Nj/68B46nuWul2pt1co8+gh6X8Wn5YLKdL6o57LjPCdEslyRWodigXL
	 JK7USPGUv6ecbfszhdvcKmoxUS87Tz2Fo9a9BnwjLlY2kGeiuUTER5MUhkwddjN01V
	 BmYfJfF91OXoxPwRKzwODH/rFWbpChEsD9JRrUUUTKjdij/d/nHTeyksOHv5EN0M23
	 YgwztQzvWXPSQ==
Date: Wed, 28 Aug 2024 18:37:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	josef@toxicpanda.com, david@fromorbit.com
Subject: Re: [PATCH v2 4/4] generic: test to run fsx eof pollution
Message-ID: <20240829013701.GI6224@frogsfrogsfrogs>
References: <20240828181534.41054-1-bfoster@redhat.com>
 <20240828181534.41054-5-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828181534.41054-5-bfoster@redhat.com>

On Wed, Aug 28, 2024 at 02:15:34PM -0400, Brian Foster wrote:
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

Looks good!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/generic/363     | 23 +++++++++++++++++++++++
>  tests/generic/363.out |  2 ++
>  2 files changed, 25 insertions(+)
>  create mode 100755 tests/generic/363
>  create mode 100644 tests/generic/363.out
> 
> diff --git a/tests/generic/363 b/tests/generic/363
> new file mode 100755
> index 00000000..477c111c
> --- /dev/null
> +++ b/tests/generic/363
> @@ -0,0 +1,23 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FSQA Test No. 363
> +#
> +# Run fsx with EOF pollution enabled. This provides test coverage for partial
> +# EOF page/block zeroing for operations that change file size.
> +#
> +
> +. ./common/preamble
> +_begin_fstest rw auto
> +
> +_require_test
> +
> +# currently only xfs performs enough zeroing to satisfy fsx
> +_supported_fs xfs
> +
> +# on failure, replace -q with -d to see post-eof writes in the dump output
> +run_fsx "-q -S 0 -e 1 -N 100000"
> +
> +status=0
> +exit
> diff --git a/tests/generic/363.out b/tests/generic/363.out
> new file mode 100644
> index 00000000..3d219cd0
> --- /dev/null
> +++ b/tests/generic/363.out
> @@ -0,0 +1,2 @@
> +QA output created by 363
> +fsx -q -S 0 -e 1 -N 100000
> -- 
> 2.45.0
> 
> 
