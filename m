Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD5014A619;
	Fri, 25 Sep 2026 19:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790365677; cv=none; b=b/ZyOGy+JSe4TsI/TN7No7M2pwaHAJit2D6catVitX1i3pmju5yrAAI240NvPBhLCJ1jm2SY5+URHvgeqK42aU+cMVvwnRx0iEeCuwmlyjxKdMttwxvD/bqhmLpsZBIGqLr0sasM1JiF+oXB/o1z71bpemtL2DSvwc0cThzu1vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790365677; c=relaxed/simple;
	bh=8IiRXLsvhGxthqMuBFH1TTh3o9GFCcmeTPr9R2u9XDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bbzQQ5z3fyH03gXYTtXIi7yzgGngG7Da2HHbxzCzzbbhZkK+unjp2Ii0b5ipL2u9Z80ULxTi1C3VbW6ZbuZ1Ud2n4t7BtGHaMTI6R5BWPAfaBMsvgBpzmwooHQVtfmNtMwx0HMK2kChON32s8bLW/QZrwF/augIQkf/PXlg6Swo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmsOByst; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmsOByst"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4C8681F000FF;
	Fri, 25 Sep 2026 19:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790365676;
	bh=L+n+R2v3TLKdA1TVIzt0BCfz7qWTvFOh8ShAYOAQvfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LmsOBystTMwVuZbeuIY2pq30euYIty2Rs5869cRyXZPIFsqwYtrn30CMsqWIXYpVr
	 mnYhX8dMEWxBUOV1obL1JLGs9v0jwagOAbdsOZH5tcbvZBG7Ew/4sYtMBHkcMVRPJ7
	 L6uE/HbtYN/XPxyDUGpvx3dXUREEf5j15bbRTM+kipkjMjOhnZaWPoaTGPVKnoaK9C
	 vFGhIH40yrXfOE/KITp3BrIrTmyk83l9gzllJpqRKvgXrJ+rVzGGskffa/ahC00d3T
	 37JXp+HRcMt5u44viGzUuXsKJxgQuZgupnXY6XxGjYqrZHtkB3eTCcnQhkO7jy8NQP
	 TAH5CvSndWJEQ==
Date: Fri, 25 Sep 2026 12:47:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test libxfs handling of missing RT devices
Message-ID: <20260925194755.GK6253@frogsfrogsfrogs>
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

Looks good now!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

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
> 
