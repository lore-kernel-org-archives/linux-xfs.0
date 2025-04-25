Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FEB22F01;
	Fri, 25 Apr 2025 15:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745593416; cv=none; b=hbpHrtQhXEhsf4Es/9GXy9ykSq5FMlpvRoe+zEqVggcO/7etTNxYNPn3Ozv16ikk7g/MJPr5T7JaA78Wi4VZexFZQRLSeXVwMes9iF8KjsJoxVw6LMCT2Z9L/NN0XVUjHFpNolk0OVObFz7J5Ng+INfApD+TzPqZ/GR+udtCLo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745593416; c=relaxed/simple;
	bh=dsAeXpODhfvgYAgmSXOzBPWfAs2TBbND1cpcJ7Lkhgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dOXTYMlTmWj0wYgnT+5PobefWHlFO+LNy5PgdsFOnXvUiz9T8FPSgXrIWJUFDGIGonXOkQl4xmfnCx9zxhvq41sBN6QKDbVViOll43uxsM5vhgLqisCkW50ROc9HXc37kzZMTt19f3Q7gF5poS7/KI1ScG2S/w11JuVwBydCXLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ds+1Ci/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ds+1Ci/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CA3C4CEE4;
	Fri, 25 Apr 2025 15:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745593415;
	bh=dsAeXpODhfvgYAgmSXOzBPWfAs2TBbND1cpcJ7Lkhgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ds+1Ci/FlzUPO17PswcpR39smLrSiDjFGRBIYOARtmDmufzczdkPSu247J2DFBPJ+
	 6KkpZTENK4Kh+iZw9SW5JURXMpSoznIHoqxH8RcoinzTVWir8AmoJ75qNGoHAEzji5
	 nGSz47lyGgpxfk2OgNR8Q/7isVshb4MWmYKGK3NEJ/PzlwdV6kz7sJXAucosqi8I6Y
	 /Eea2S0cdWO6XBvtbrHEUaS74+3POUqETVOD8nH+O+iy7bS0UPWPerqZVIhenB4f8m
	 D7zWDlItSy0rvjjFy5//0WdVoljtzX/Qf9O0buPXMSYFdsy3p6Zjmu4t4BjYiMXFxb
	 y7TQeT5yoTBXA==
Date: Fri, 25 Apr 2025 08:03:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"zlang@kernel.org" <zlang@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>, hch <hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: add mount test for read only rt devices
Message-ID: <20250425150331.GG25667@frogsfrogsfrogs>
References: <20250425090259.10154-1-hans.holmberg@wdc.com>
 <20250425090259.10154-2-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425090259.10154-2-hans.holmberg@wdc.com>

On Fri, Apr 25, 2025 at 09:03:22AM +0000, Hans Holmberg wrote:
> Make sure that we can mount rt devices read-only if them themselves
> are marked as read-only.
> 
> Also make sure that rw re-mounts are not allowed if the device is
> marked as read-only.
> 
> Based on generic/050.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> ---
>  tests/xfs/837     | 55 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/837.out | 10 +++++++++
>  2 files changed, 65 insertions(+)
>  create mode 100755 tests/xfs/837
>  create mode 100644 tests/xfs/837.out
> 
> diff --git a/tests/xfs/837 b/tests/xfs/837
> new file mode 100755
> index 000000000000..b20e9c5f33f2
> --- /dev/null
> +++ b/tests/xfs/837
> @@ -0,0 +1,55 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2009 Christoph Hellwig.
> +# Copyright (c) 2025 Western Digital Corporation
> +#
> +# FS QA Test No. 837
> +#
> +# Check out various mount/remount/unmount scenarious on a read-only rtdev
> +# Based on generic/050
> +#
> +. ./common/preamble
> +_begin_fstest mount auto quick
> +
> +_cleanup_setrw()
> +{
> +	cd /
> +	blockdev --setrw $SCRATCH_RTDEV
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +
> +_require_realtime
> +_require_local_device $SCRATCH_RTDEV

I suspect this is copy-pasted from generic/050, but I wonder when
SCRATCH_RTDEV could be a character device, but maybe that's a relic of
Irix (and Solaris too, IIRC)?

The rest of the test looks fine to me though.

--D

> +_register_cleanup "_cleanup_setrw"
> +
> +_scratch_mkfs "-d rtinherit" > /dev/null 2>&1
> +
> +#
> +# Mark the rt device read-only.
> +#
> +echo "setting device read-only"
> +blockdev --setro $SCRATCH_RTDEV
> +
> +#
> +# Mount it and make sure it can't be written to.
> +#
> +echo "mounting read-only rt block device:"
> +_scratch_mount 2>&1 | _filter_ro_mount | _filter_scratch
> +if [ "${PIPESTATUS[0]}" -eq 0 ]; then
> +	echo "writing to file on read-only filesystem:"
> +	dd if=/dev/zero of=$SCRATCH_MNT/foo bs=1M count=1 oflag=direct 2>&1 | _filter_scratch
> +else
> +	_fail "failed to mount"
> +fi
> +
> +echo "remounting read-write:"
> +_scratch_remount rw 2>&1 | _filter_scratch | _filter_ro_mount
> +
> +echo "unmounting read-only filesystem"
> +_scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
> +
> +# success, all done
> +echo "*** done"
> +status=0
> diff --git a/tests/xfs/837.out b/tests/xfs/837.out
> new file mode 100644
> index 000000000000..0a843a0ba398
> --- /dev/null
> +++ b/tests/xfs/837.out
> @@ -0,0 +1,10 @@
> +QA output created by 837
> +setting device read-only
> +mounting read-only rt block device:
> +mount: device write-protected, mounting read-only
> +writing to file on read-only filesystem:
> +dd: failed to open 'SCRATCH_MNT/foo': Read-only file system
> +remounting read-write:
> +mount: cannot remount device read-write, is write-protected
> +unmounting read-only filesystem
> +*** done
> -- 
> 2.34.1
> 
