Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3952405879;
	Mon, 18 May 2026 12:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779107267; cv=none; b=S4JzTCKLb5Mot8A4fC5gmMsrdpD+xfqNRsCDMud22rduySkKjuO0ZderztQ6Q1lGKhcqiEJAql2xpZtRRcRllIdW5tzjkRZIkTu82a3guGYquTUAbvYa0OYRWwCriQooQCOSmal1btSbe1PE+E6gOAJ17rSFLugzlAt5d01u1S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779107267; c=relaxed/simple;
	bh=g510hoU7eOp0Qkla1GT5/SSksLOaNNb2pT6xb3nWWMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PYxD2BhT9Vpi57KYDdpOBBdtLWWfbcvvNxZ4KpaY5Q3NttanlTLsw2i6CD8rLlAMk1q7pGs4r1ufSx/R/PCF13tXmBEas9I72D4nV0bmIBGhq4bb8fxqTlq31S9+HmmyjBih5gXY2J2HUKL2JxON7iVq3Ow+CgC6fo/9+2y4pBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OWpjhW5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OWpjhW5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DB8C2BCB7;
	Mon, 18 May 2026 12:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779107266;
	bh=g510hoU7eOp0Qkla1GT5/SSksLOaNNb2pT6xb3nWWMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OWpjhW5cnqWy953wCIVDAwxhUsoC+pFUxs8SwOF/KYBhdixgQ+5JsaeAcIeFdzEzJ
	 /dxNfdnx1LC6t4ToikzyuNFgmZ/duEyuzV3orRPSkhC5ryChDxT2IOBKQZq2HGjglm
	 ddTnyayX26rlimahkMRwUTJHIzba2JUUDVxPfUd0P5PWET4WQV1Bir9+UuU/77TmIK
	 nFaSF+JTVY4TCBEh0HZBca4csmmVruBr+hQVC2qaYigsI9WVgg9BJuEFMM+0R6WguY
	 c8RbK9zqGshCwrCMU5ldUE/5WTToHE9CM41KUg/p8IDByPl0rsW63pV+LWEDGQR1O0
	 ejVs5CCrtHoAQ==
Date: Mon, 18 May 2026 14:27:42 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, cmaiolino@redhat.com, fstests@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: add a test that stresses metadata eviction
Message-ID: <agsEQ9TjHelfbWXr@nidhogg.toxiclabs.cc>
References: <20260518062514.506071-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518062514.506071-1-hch@lst.de>

On Mon, May 18, 2026 at 08:24:53AM +0200, Christoph Hellwig wrote:
> The fsverity test generic/759 could be used to reproduce a regression in
> the xfs buffer hashing.  Carlos Maiolino figured out that even removing
> the fsverity-specific bits would reproduce the issue.  This test is
> thus a copy of generic/759 with the fsverity bits striped out, and
> run 5 times as that seems to be the threshold at which the issue
> reproduces reliably.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> Not sure how to best credit Eric for the original patch and Carlos
> for the extraction, any ideas?

To be fair, Andrey initially suggested stripping off the fs-verity
parts, IIRC because he wanted to isolate his own series from this crash.
My role was mostly reproduce it and hunt the bug down.
Risking to come with yet another tag, perhaps something like:

Based-on-generic-579-by: <Eric...>

It doesn't look ugly to me, but who knows...

> 
>  tests/generic/4201     | 108 +++++++++++++++++++++++++++++++++++++++++
>  tests/generic/4201.out |   2 +
>  2 files changed, 110 insertions(+)
>  create mode 100755 tests/generic/4201
>  create mode 100644 tests/generic/4201.out
> 
> diff --git a/tests/generic/4201 b/tests/generic/4201
> new file mode 100755
> index 000000000000..fc367beeadaf
> --- /dev/null
> +++ b/tests/generic/4201
> @@ -0,0 +1,108 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright 2019 Google LLC
> +#
> +# FS QA Test generic/4201
> +#
> +# Race dropping file systems caches vs fsstress an repeated reading of files.
> +# Based on generic/579 with the fsverity bits stripped out, and an increased
> +# number of runs.
> +#
> +. ./common/preamble
> +_begin_fstest auto stress
> +
> +stop_run()
> +{
> +	# Stop all subprocesses.
> +	_kill_fsstress
> +	touch $tmp.done
> +	wait
> +}
> +
> +_cleanup()
> +{
> +	stop_run
> +	rm -f $tmp.*
> +}
> +
> +. ./common/filter
> +
> +fsv_file_size=10000000
> +nproc_enabler=$((4 * LOAD_FACTOR))
> +nproc_reader=$((6 * LOAD_FACTOR))
> +nproc_stress=$((3 * LOAD_FACTOR))
> +runtime=$((20 * TIME_FACTOR))
> +
> +run_test()
> +{
> +	rm -rf $tmp.done
> +
> +	# Create the test files and start the fs-verity enabler processes.
> +	for ((proc = 0; proc < nproc_enabler; proc++)); do
> +		orig_file=$SCRATCH_MNT/orig$proc
> +		fsv_file=$SCRATCH_MNT/fsv$proc
> +		head -c $fsv_file_size /dev/urandom > $orig_file
> +		(
> +			while [ ! -e $tmp.done ]; do
> +				rm -f $fsv_file
> +				cp $orig_file $fsv_file
> +				# Give the readers some time to read from the file.
> +				sleep 0.$((RANDOM % 100))
> +			done
> +		) &
> +	done
> +
> +	# Start the reader processes.
> +	for ((proc = 0; proc < nproc_reader; proc++)); do
> +		(
> +			while [ ! -e $tmp.done ]; do
> +				# Choose a random file for each iteration, so that
> +				# sometimes multiple processes read from the same file.
> +				i=$((RANDOM % nproc_enabler))
> +				orig_file=$SCRATCH_MNT/orig$i
> +				fsv_file=$SCRATCH_MNT/fsv$i
> +
> +				# After the copy from $orig_file to $fsv_file has
> +				# completed, the contents of these two files should
> +				# match, regardless of whether verity has been enabled
> +				# or not yet (or is currently being enabled).
> +				cmp $orig_file $fsv_file |& _filter_scratch | \
> +					sed -e "s/'//g" | \
> +					grep -v "SCRATCH_MNT/fsv$i: No such file or directory" | \
> +					grep -v "EOF on SCRATCH_MNT/fsv$i"
> +				done
> +		) &
> +	done
> +
> +	# Start a process that occasionally runs 'sync && drop_caches'.  This makes more
> +	# reads go through fs-verity for real, rather than just returning pagecache.
> +	(
> +		while [ ! -e $tmp.done ]; do
> +			sleep 2.$((RANDOM % 100))
> +			_scratch_sync && echo 3 > /proc/sys/vm/drop_caches
> +		done
> +	) &
> +
> +	# Start the fsstress processes.
> +	_run_fsstress_bg -p $nproc_stress -l 0 -d $SCRATCH_MNT/stressdir
> +
> +	# Run for a while.
> +	sleep $runtime
> +
> +	stop_run
> +}
> +
> +for i in $(seq 1 5); do
> +	echo "Starting run $i" >> $seqres.full
> +
> +	_scratch_mkfs &>> $seqres.full
> +	_scratch_mount
> +	run_test
> +	_scratch_unmount
> +done
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/4201.out b/tests/generic/4201.out
> new file mode 100644
> index 000000000000..2c3f3d42ff3f
> --- /dev/null
> +++ b/tests/generic/4201.out
> @@ -0,0 +1,2 @@
> +QA output created by 4201
> +Silence is golden
> -- 
> 2.53.0
> 
> 
