Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B39818FDD8;
	Mon,  5 May 2025 15:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746457698; cv=none; b=KkLGYCZLzi5k1Pa4BjDQYxiIgjwvY6TCOBQQE7siGYoz4NDnILd0cUnt0eGYsXard0I6wfgMIkhWh72dQwLoJp7HR7sOCK+SF22fZmxpAY/Kfl8245AuRFprHhl6E3/YnCdkrnaZH4dnBZf9b6qpeRGjDUkM+WQ8YBxAJGFhHbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746457698; c=relaxed/simple;
	bh=sMAjsFFxQiYb8/vKhmxLpMOJwCESCAcjkhBpDE+Ra90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FAn5SHfAsfqQ5ZhzPM3Y0cMNsferFJMsbok5BGEoDjPsXCUsuCu9LiFaj9bNNwz3AXhh+I0Th3bMofTOivgv8MhYRfKWZk0WXC9RyIMn8L4oT7icWofIffiZIj4hp2ftF9SkZi21MgqXwm/5rHsCov/AOxNkBWooXFBgiqKTMwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GUnWET9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GUnWET9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF492C4CEE4;
	Mon,  5 May 2025 15:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746457694;
	bh=sMAjsFFxQiYb8/vKhmxLpMOJwCESCAcjkhBpDE+Ra90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GUnWET9QNVXQJimDYtyYcOsr1son9n6cImEiX1SRLWTg0oUUDvu2fpjqsrxM8CYYi
	 27C8qb1mC+eHvW0rN9Sm/C7/XDKIszxFsczEIFatoHHAZK2a+YtZyDA5fkd6RKiFAT
	 KFbSWqZqr0TbjLwoz9VSsWYK29+BAhJrbM2CY83jM5HC6x1dXR/YHmx5Wvu157V36O
	 iQr0jN9k6StzeAfB+FtCJAFf9WE3vZnQb9XIYzijxF/ayt8YRrZ+aD/tmTkT2jCF6m
	 BmZRKnCx+iIlp9etkRB6rHi9ts+7qCxFaz0vCX0PN212/ufTat3XmpbMsrEOpTN1w0
	 IpG0AxQfAmWkw==
Date: Mon, 5 May 2025 08:08:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Zorro Lang <zlang@kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	hch <hch@lst.de>
Subject: Re: [PATCH v2 15/15] xfs: test that we can handle spurious zone wp
 advancements
Message-ID: <20250505150814.GB25675@frogsfrogsfrogs>
References: <20250501134302.2881773-16-hch@lst.de>
 <20250505095054.16030-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250505095054.16030-1-hans.holmberg@wdc.com>

On Mon, May 05, 2025 at 09:51:48AM +0000, Hans Holmberg wrote:
> From: Hans Holmberg <Hans.Holmberg@wdc.com>
> 
> Test that we can gracefully handle spurious zone write pointer
> advancements while unmounted.
> 
> Any space covered by the wp unexpectedly moving forward should just
> be treated as unused space, so check that we can still mount the file
> system and that the zone will be reset when all used blocks have been
> freed.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good now,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> 
> Canges since v1:
>  Added _require_realtime and fixed a white space error based
>  on Darrick's review comments.
> 
>  tests/xfs/4214     | 62 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/4214.out |  2 ++
>  2 files changed, 64 insertions(+)
>  create mode 100755 tests/xfs/4214
>  create mode 100644 tests/xfs/4214.out
> 
> diff --git a/tests/xfs/4214 b/tests/xfs/4214
> new file mode 100755
> index 000000000000..0637bbc7250e
> --- /dev/null
> +++ b/tests/xfs/4214
> @@ -0,0 +1,62 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Western Digital Corporation.  All Rights Reserved.
> +#
> +# FS QA Test 4214
> +#
> +# Test that we can gracefully handle spurious zone write pointer
> +# advancements while unmounted.
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick zone
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/zoned
> +
> +_require_scratch
> +_require_realtime
> +_require_zoned_device $SCRATCH_RTDEV
> +_require_command "$BLKZONE_PROG" blkzone
> +
> +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount
> +blksz=$(_get_file_block_size $SCRATCH_MNT)
> +
> +test_file=$SCRATCH_MNT/test.dat
> +dd if=/dev/zero of=$test_file bs=1M count=16 >> $seqres.full 2>&1 \
> +	oflag=direct || _fail "file creation failed"
> +
> +_scratch_unmount
> +
> +#
> +# Figure out which zone was opened to store the test file and where
> +# the write pointer is in that zone
> +#
> +open_zone=$($BLKZONE_PROG report $SCRATCH_RTDEV | \
> +	$AWK_PROG '/oi/ { print $2 }' | sed 's/,//')
> +open_zone_wp=$($BLKZONE_PROG report $SCRATCH_RTDEV | \
> +	grep "start: $open_zone" | $AWK_PROG '{ print $8 }')
> +wp=$(( $open_zone + $open_zone_wp ))
> +
> +# Advance the write pointer manually by one block
> +dd if=/dev/zero of=$SCRATCH_RTDEV bs=$blksz count=1 seek=$(($wp * 512 / $blksz))\
> +	oflag=direct >> $seqres.full 2>&1 || _fail "wp advancement failed"
> +
> +_scratch_mount
> +_scratch_unmount
> +
> +# Finish the open zone
> +$BLKZONE_PROG finish -c 1 -o $open_zone $SCRATCH_RTDEV
> +
> +_scratch_mount
> +rm $test_file
> +_scratch_unmount
> +
> +# The previously open zone, now finished and unused, should have been reset
> +nr_open=$($BLKZONE_PROG report $SCRATCH_RTDEV | grep -wc "oi")
> +echo "Number of open zones: $nr_open"
> +
> +status=0
> +exit
> diff --git a/tests/xfs/4214.out b/tests/xfs/4214.out
> new file mode 100644
> index 000000000000..a746546bc8f6
> --- /dev/null
> +++ b/tests/xfs/4214.out
> @@ -0,0 +1,2 @@
> +QA output created by 4214
> +Number of open zones: 0
> -- 
> 2.34.1
> 
