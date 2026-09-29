Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC70A30BF4F;
	Tue, 29 Sep 2026 01:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790647052; cv=none; b=P68zehrb5AvPbnck/vTbk2J34p/E6yC+cAI89GDhXztLG09gOrgLZnNSykxcl4iy3eJZ7ZV/EVuClcIRUw/F8m4sjD5GOrO31J56rMQ+oBiUSVRE1hmI77MaqA4VXQs5znf8iF9LTAbtUWo1bN/XgxFIFMJYH5M0HaYPxyOu39U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790647052; c=relaxed/simple;
	bh=vje8VB3HRpkp1+8OP8cNY7h2W1Ny6nRCJDbNVyWc5mI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lchuRp7hf6YYG+9JrjsrynC/TXGqxr6umzZlKUA3OnUzuZchenSLvsQKcJWdvHkleGqs7Q5Fw6N9pIREIjjrXyt59TiZhf1slXpbbboLdpqhN2uHLhJ3BkAJPWSrd335/0Kz6sERZaPrvWz4xRNxKXc92KIynK66j/qm05cYUjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W/Tjptbw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W/Tjptbw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 507941F000FF;
	Tue, 29 Sep 2026 01:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790647050;
	bh=gnVQQfMMmwOdew/49/6GbhpV3BhlCu741Paom9BoAdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W/TjptbwG4U0bOUEp1wA+A6LS4bpGfbXaTig2wN+we6G1bXtt/y3xKAg6Sb4nDv+7
	 aLSCSyfwVJlz/7cUYbD2+aMF5r1xnU1L9V3vizKpG/3foagmq2SoyCtDHlCyP8sTa2
	 oXv/hCJOIDUtPMEHO8wKBMGlJpUw8kIfz0OEl10JkEiTRfOb04UmnGY1UqyHHoh7Is
	 oEZFTeENBfpP55ukrB8v9tvTE14CIyy/LVNPAcaq/Td/Q4bh3x1aesVHgUbBZCzlZm
	 J3b3rnBs2+NvJAMSZhTK0lavK1pgBYck3sK+zpthjo5f9DeNk/DimSWnFry/Pn449a
	 2/PZHFWQl31Bw==
Date: Mon, 28 Sep 2026 18:57:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/13] xfs/2305: version of generic/475 that run
 xfs_scrub -x for each iteration
Message-ID: <20260929015729.GM2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100855.2734089-11-hch@lst.de>

On Thu, Sep 24, 2026 at 12:07:51PM +0200, Christoph Hellwig wrote:
> To check both the metadata integrity and file system checksums after
> log replay.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/2305     | 75 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/2305.out |  2 ++
>  2 files changed, 77 insertions(+)
>  create mode 100755 tests/xfs/2305
>  create mode 100644 tests/xfs/2305.out
> 
> diff --git a/tests/xfs/2305 b/tests/xfs/2305
> new file mode 100755
> index 000000000000..277f81c13887
> --- /dev/null
> +++ b/tests/xfs/2305
> @@ -0,0 +1,75 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 2305
> +#
> +# Copied from generic/475, with added xfs_scrub -x calls for each iteration to
> +# verify the integrity of all file data and metadata.

Same questions that I had for xfs/2304. :D

--D

> +# Test log recovery with repeated (simulated) disk failures.  We kick
> +# off fsstress on the scratch fs, then switch out the underlying device
> +# with dm-error to see what happens when the disk goes down.  Having
> +# taken down the fs in this manner, remount it and repeat.  This test
> +# is a Good Enough (tm) simulation of our internal multipath failure
> +# testing efforts.
> +#
> +. ./common/preamble
> +_begin_fstest shutdown auto log metadata eio recoveryloop smoketest datacsum
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	_kill_fsstress
> +	_dmerror_unmount
> +	_dmerror_cleanup
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# Import common functions.
> +. ./common/dmerror
> +
> +# Modify as appropriate.
> +
> +_require_scratch
> +_require_dm_target error
> +
> +echo "Silence is golden."
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
> +_dmerror_init
> +_dmerror_mount
> +
> +while _soak_loop_running $((50 * TIME_FACTOR)); do
> +	_run_fsstress_bg -d $SCRATCH_MNT -n 999999 -p $((LOAD_FACTOR * 4))
> +
> +	# purposely include 0 second sleeps to test shutdown immediately after
> +	# recovery
> +	sleep $((RANDOM % 3))
> +
> +	# This test aims to simulate sudden disk failure, which means that we
> +	# do not want to quiesce the filesystem or otherwise give it a chance
> +	# to flush its logs.  Therefore we want to call dmsetup with the
> +	# --nolockfs parameter; to make this happen we must call the load
> +	# error table helper *without* 'lockfs'.
> +	_dmerror_load_error_table
> +
> +	_kill_fsstress
> +
> +	# Mount again to replay log after loading working table, so we have a
> +	# consistent XFS after test.
> +	_dmerror_unmount || _fail "unmount failed"
> +	_dmerror_load_working_table
> +	_dmerror_mount || _fail "mount failed"
> +
> +	$XFS_SCRUB_PROG -x $SCRATCH_MNT >> $seqres.full 2>&1
> +	if [ $? -ne 0 ]; then
> +		_fail "scrub found errors"
> +	fi
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/2305.out b/tests/xfs/2305.out
> new file mode 100644
> index 000000000000..8265227294ca
> --- /dev/null
> +++ b/tests/xfs/2305.out
> @@ -0,0 +1,2 @@
> +QA output created by 2305
> +Silence is golden.
> -- 
> 2.53.0
> 
> 
