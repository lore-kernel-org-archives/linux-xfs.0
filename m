Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4B948643D;
	Mon, 14 Sep 2026 15:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789398352; cv=none; b=a0N6DzRf6qaz5VELJhp3DWvbkVuc3drzmNE9guVesRP1wzpRp7pyh4b5m15grxJ8rCIyEGZxbbVApT1RUzUS5tRjHTz2C17V9rvVJJXaYHvYtt2x3uGqAImO7eDeDm4T4/g/Aq+iDtZh5riftdZRw/tKO5iRXGAmYSatHHUByyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789398352; c=relaxed/simple;
	bh=xZWQ2zjSflSPtpH8GxcGKdnWuzWgxzBvXnwYXAYqhl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gd3dbY8ZusEcxc13bRFldquyTOqsqsNGwRDt05cTnr3VOTv7njm1B8iu+UlFDGYtOQI99gkSlxvQiWRgjkAiPHy+p/SQVlaJmwpSizrfHAp5cyhylDf2LY6iCD4h7DLp+BQs3ZWOMlEek7YdvMG8zjwem1ctbJ0lpQzFVRWcSzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IioRmap/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IioRmap/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D16991F00893;
	Mon, 14 Sep 2026 15:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398349;
	bh=vvKITJcYQgzh2hEi+wt48NuedpLUcXbpT6DKOA9q8kk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IioRmap/0CkLbsriKWFcwzhWnyFDK12tE2OrlADRCCt0D/d1Ul9636m+cGPGlPDNW
	 Uk6JH9Mn7rkqBRna6wbOtoTmJ3KBv88eGT+mwSEmhAHN0Dx2MSMPUYo4xzY10rdR9h
	 3sSFq52KEpUwVPGV+G/SmcDSg9YVG+vKZY3uryYtuF00S2jzwwmttMrvL50PZ5NL96
	 bqyXBHar60y4GPW9rmf3andlzjReoib511nVVoY+nTGv6hfqrufQtsykMNBv0XApci
	 U1NuN4CIRjDODQF+1346BH6uTiIGL3Pd1dx+egu61+UeYwxf91ZeSfR+nDU0x2LgoY
	 +w4lLyv3wVYNQ==
Date: Mon, 14 Sep 2026 08:05:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test libxfs handling of missing RT devices
Message-ID: <20260914150549.GO6265@frogsfrogsfrogs>
References: <20260914113634.2448723-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914113634.2448723-1-hch@lst.de>

On Mon, Sep 14, 2026 at 01:36:34PM +0200, Christoph Hellwig wrote:
> Test that libxfs rejects initializing a file systems unless in debugger
> mode by running xfs_repair and xfs_db with missing arguments.  For
> db additionally test that command that require a RT device still do not
> work even after libxfs can be initialized using a missing RT device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/2300     | 48 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/2300.out | 14 ++++++++++++++
>  2 files changed, 62 insertions(+)
>  create mode 100755 tests/xfs/2300
>  create mode 100644 tests/xfs/2300.out
> 
> diff --git a/tests/xfs/2300 b/tests/xfs/2300
> new file mode 100755
> index 000000000000..70c1d6bad9cc
> --- /dev/null
> +++ b/tests/xfs/2300
> @@ -0,0 +1,48 @@
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
> +_cleanup()
> +{
> +	_unmount $LOOP_MNT 2>/dev/null
> +	[ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
> +	rm -rf $LOOP_IMG $LOOP_MNT

I don't see any users of loop devices here?

Otherwise this test looks ok to me.

--D

> +	cd /
> +	rm -f $tmp.*
> +}
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
