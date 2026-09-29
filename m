Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC51B3CCA12;
	Tue, 29 Sep 2026 01:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790647007; cv=none; b=U4bou5ZCUq6wIciC6GZWLbDBnGMLoxWcfuNVMEVeIeDpel6n4j+QaR1c7zG6g5PlFj3+RYC7P7gl4LnDF2CuCTaVPHbfZe8Dm431Wdlm89VrZMecsU+z4IiXa8Jwy4sx8OCiMXZa1mw1xu2uwtWbZ7msK+NQNl8ehURtmZY9EpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790647007; c=relaxed/simple;
	bh=2p9TNA3DZ/Ovj1iHFVP50oW3bmfudCiamq2/x+97l10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qwzBcjHuhCVGJP/tHTrwq2Ml2TvV/1Nhcbzksh0t0alHZWuEk9efHmROtkKVgo3m367dJt+tVu2Berkv6m4cGXWC6MxVoGWH7SvPdRPR6oiawRL+g1ZkDzpyUSds71e1D1x/NC0MkIfoji+Y07cjwDeJ9Bb5LHIDHMrwBLS1JoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RX+QO+oe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RX+QO+oe"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 78EAE1F000FF;
	Tue, 29 Sep 2026 01:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790647005;
	bh=xJfGjlEj0QVC0rb4glVYsFrtdMEGIhUYL8gnHbFywsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RX+QO+oeZkuME3/J2QbqP7kDAaFU8TXjgkiILUNzIvIF87Kle9zYvRRDz1Fja5UAb
	 Bqs+YD0at2xzKYEkng4Ir60SKIDrzN6o/cugt6c/hN0xLLXCg7mH98tjEHBwHWgRfT
	 bErh98nGLziKwMwXiyAlYPQXNpLVQ8FGBo9N3eLiVDlnCmDp7btQpe8wS4/d6hlXkW
	 RUwBU3GB2hy2CbpdWoqfDvMdhagGYSQrb1+hUyTw5ZiyqsuSUqj7+i6wggagD4CT1i
	 NsdTeLgcEs6AqzeZQKYeTiX1J6VfpoSIIQo+PDxO5z96tuqg0ymV6NPfq8tGUqale1
	 i1T7HctkytuIw==
Date: Mon, 28 Sep 2026 18:56:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs/2304: version of generic/388 that run
 xfs_scrub -x for each iteration
Message-ID: <20260929015645.GL2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100855.2734089-10-hch@lst.de>

On Thu, Sep 24, 2026 at 12:07:50PM +0200, Christoph Hellwig wrote:
> To check both the metadata integrity and file system checksums after
> log replay.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/2304     | 61 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/2304.out |  2 ++
>  2 files changed, 63 insertions(+)
>  create mode 100755 tests/xfs/2304
>  create mode 100644 tests/xfs/2304.out
> 
> diff --git a/tests/xfs/2304 b/tests/xfs/2304
> new file mode 100755
> index 000000000000..ad4f45d79057
> --- /dev/null
> +++ b/tests/xfs/2304
> @@ -0,0 +1,61 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2016 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 2304
> +#
> +# Copied from generic/388, with added xfs_scrub -x calls for each iteration to
> +# verify the integrity of all file data and metadata.
> +#
> +# Test XFS log recovery ordering on v5 superblock filesystems. XFS had a problem
> +# where it would incorrectly replay older modifications from the log over more
> +# recent versions of metadata due to failure to update metadata LSNs during log
> +# recovery. This could result in false positive reports of corruption during log
> +# recovery and permanent mount failure.
> +#
> +# To test this situation, run frequent shutdowns immediately after log recovery.
> +# Ensure that log recovery does not recover stale modifications and cause
> +# spurious corruption reports and/or mount failures.
> +#
> +. ./common/preamble
> +_begin_fstest shutdown auto log metadata recoveryloop datacsum
> +
> +_require_scratch
> +_require_local_device $SCRATCH_DEV
> +_require_scratch_shutdown
> +
> +echo "Silence is golden."
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
> +_scratch_mount
> +_require_scratch_xfs_scrub
> +
> +while _soak_loop_running $((50 * TIME_FACTOR)); do
> +	_run_fsstress_bg -d $SCRATCH_MNT -n 999999 -p 4
> +
> +	# purposely include 0 second sleeps to test shutdown immediately after
> +	# recovery
> +	sleep $((RANDOM % 3))
> +	_scratch_shutdown
> +
> +	_kill_fsstress
> +
> +	# Toggle between rw and ro mounts for recovery. Quit if any mount
> +	# attempt fails so we don't shutdown the host fs.
> +	if [ $((RANDOM % 2)) -eq 0 ]; then
> +		_scratch_cycle_mount || _fail "cycle mount failed"
> +	else
> +		_scratch_cycle_mount "ro" || _fail "cycle ro mount failed"
> +		_scratch_cycle_mount || _fail "cycle rw mount failed"
> +	fi
> +
> +	$XFS_SCRUB_PROG -x $SCRATCH_MNT >> $seqres.full 2>&1

I think we should just change generic/388 to run xfs_scrub after
recovery, and add -x if data checksums are enabled?  That /would/ have
the effect of catching recovery errors (or scrub bugs) earlier.

Though I wonder how much that reduces the number of loop iterations over
a given SOAK_DURATION?

--D

> +	if [ $? -ne 0 ]; then
> +		_fail "scrub found errors"
> +	fi
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/2304.out b/tests/xfs/2304.out
> new file mode 100644
> index 000000000000..07ee489db9fa
> --- /dev/null
> +++ b/tests/xfs/2304.out
> @@ -0,0 +1,2 @@
> +QA output created by 2304
> +Silence is golden.
> -- 
> 2.53.0
> 
> 
