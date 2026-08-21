Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8FE434406;
	Fri, 21 Aug 2026 23:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787355544; cv=none; b=BeuVvQsZTT5cFoaqPZyqanxGvAjzmPnjJEi2zZY1D0+4i6MudwRvWCYRCZdJdtoy+zevHb+4uIl4a8m49AowAhZ6Diqf7vKxW3AIK7VQgDRtRDSJc40Csb5ZBOidgwjaqfpzfTWgcVTZ3QYoMcKFO3gCOinPLia9bnP9IuOe3BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787355544; c=relaxed/simple;
	bh=B0SZ03pI1M5yeJEYaDjPcn8zNltFK88FuHA1VIa8aNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MbRW74qnNj0qRYSnfGUSj5OKytaVGhUKkfLT7m0zW/moVvi6LfUFRezSmqD+tpKlzP3FtrMWEPZc+lTyscxrPpjlqddrEXG8zOCpv8Wd91I6Y50GVyqdbg/VWf4QTbYXubxWgDth5/4t8RIf8GYza0LrXw8+XTtLCAy/eLx0Mw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f3tMl2kM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f3tMl2kM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D8DB81F000E9;
	Fri, 21 Aug 2026 23:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787355542;
	bh=m5wxy7zbK2qIsm9hVNYxEN14EcgII31+9H61AoN+k1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f3tMl2kM6UNfq7FSCvRppGUAwFbC67dToe9yT6W60DBJMIuybYFsMmLdVm7FqCCGK
	 zZ4pMo3p7cNHryqBVXtW7/uIgMPnK7IgAGF9KkSmYAw8cIxnxJNWLOnachpbcyfsCx
	 tprM9fqEyoPK4DbLwVbX7LnAsN1TW63XSI5yM/g/xSPy2lEDtwM9968I5KzVMXtYIp
	 0HtThL1lBV1DpqHMkqZvFzE4mMCPzbW2w5uWgp8wjDTL/sLzlCvC4no+ART3uID/A3
	 fwBRJVnw2B6zqU8Ir2oPse36loKS4FTi6S6UjThICtPhy3pi1dpuPDxWnsEuxK9w/t
	 CXo79emGeDyCQ==
Date: Fri, 21 Aug 2026 16:39:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] generic/730: don't override $SCRATCH_DEV
Message-ID: <20260821233902.GI839663@frogsfrogsfrogs>
References: <20260821051435.1818249-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821051435.1818249-1-hch@lst.de>

On Fri, Aug 21, 2026 at 07:14:35AM +0200, Christoph Hellwig wrote:
> generic/730 operates on a scsi_debug device, but overrides SCRATCH_DEV
> to test for shutdown support.  Switch this to test the shutdown support
> on the actual scratch device without overriding it, as shutdown support
> should not depend on the actual device, and this ensures that options
> that might not work on the scsi_debug device don't get applied to it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/generic/730 | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/generic/730 b/tests/generic/730
> index 1798afb7deea..64d10bba73db 100755
> --- a/tests/generic/730
> +++ b/tests/generic/730
> @@ -25,14 +25,17 @@ _cleanup()
>  _require_test
>  _require_block_device $TEST_DEV
>  _require_scsi_debug
> -# scsi_debug doesn't support DAX, so skip this test if MOUNT_OPTIONS
> -# contains "dax"
> -_exclude_scratch_mount_option "dax"
> +
> +# The actual test does not use the scratch device, but _require_scratch_shutdown
> +# is the most sensible way to check that a file system supports shutdown.
> +# Require scratch to use that check, but otherwise just use the scsi_debug
> +# device.
> +_require_scratch_nocheck
> +_require_scratch_shutdown

Makes sense,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  
>  size=$(_small_fs_size_mb 256)
>  SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 $size`
>  test -b "$SCSI_DEBUG_DEV" || _notrun "Failed to initialize scsi debug device"
> -SCRATCH_DEV=$SCSI_DEBUG_DEV _require_scratch_shutdown
>  echo "SCSI debug device $SCSI_DEBUG_DEV" >>$seqres.full
>  
>  run_check _mkfs_dev $SCSI_DEBUG_DEV
> -- 
> 2.53.0
> 
> 
