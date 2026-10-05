Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFB63E8660;
	Mon,  5 Oct 2026 21:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791235160; cv=none; b=nTfmVCoUy1sesNxGf9tsA2d4piczDzhkGg0RHJLTkWc6T9JaAOHTaW1VLVXxcmuYkrlSoasF9Z73xbtq/UYDfjGRBCL96pCeMPJJc5xz3mcCUQksPn7iN1DqMsKd/8LYtqwbHdbbmn0tamhTJ3BlC2eVv3Nypkb4Yry2d8uc1EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791235160; c=relaxed/simple;
	bh=wSSBNMOSBTT81BXLSEdsQz92z+dzhN2/bv/xpI0Szvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cQ1iiP1ZeEOQ9HKfQu9Xn4y1mamDMHMWvtyv6IKhLhBI20pa8aaGEbWV//dlXAaGlqeo2rcj4g/7nZHWG6mTeMZdKSIOwxbmIRcqNnbdtDrZsqdOUuBmjPCc8WVCe8ZHcaeNAyVQ7+PLzrBuQZWZnBIVl2XnkZbm6+xI/Jlc7CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eBn3fvRb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eBn3fvRb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 939A51F000FF;
	Mon,  5 Oct 2026 21:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791235154;
	bh=Rs+h5CMTGvV+jY2OHN9MLjmoUZEpGtCuIPpYS+5ApQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eBn3fvRbXfN44Dln2JKAOGR1FxeeSUqB7Z6CQ//n8fVya3rHeLV6EHIVMoS87cUkH
	 s2r+9pTKV9YIcfa5aQz9BzNf+e0XyaupKfBAZIcDunvl7yoOR6RMEce1Lm8s3EZeL+
	 SBDmngOUtcONV8Ivi2A4XhGoVfZtp7NfWfYD4boF2nNgC8KXyuOd3zZiRqFNOaOg3e
	 WZC+JLKDId7Vkg7g9JbrNCTR+668J9OszblgLD0EqKxTSqVwVLRIhT86UZw96iYqQx
	 M5Ql1uPZigw6XC0LI2EEEAv4uwnfiyFIQcF/na3YjsC+njf8e7qYDJY/cI5585hGzy
	 SLa4MjEqsNpJQ==
Date: Mon, 5 Oct 2026 14:19:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: test libxfs handling of missing RT devices
Message-ID: <20261005211914.GG2705364@frogsfrogsfrogs>
References: <20261005125548.1340322-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005125548.1340322-1-hch@lst.de>

On Mon, Oct 05, 2026 at 02:55:43PM +0200, Christoph Hellwig wrote:
> Test that libxfs rejects initializing a file systems unless in debugger
> mode by running xfs_repair and xfs_db with missing arguments.  For
> db additionally test that command that require a RT device still do not
> work even after libxfs can be initialized using a missing RT device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Still looks fine to me!
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
> index 000000000000..9c96e802241f
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
> +_require_external_realtime_device
> +
> +# require metadir for the rtsb command
> +$MKFS_XFS_PROG -f \
> +	-m metadir=1 \
> +	-r rtdev=$SCRATCH_RTDEV \
> +	$SCRATCH_DEV >> $seqres.full 2>&1
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
