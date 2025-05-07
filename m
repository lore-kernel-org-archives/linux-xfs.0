Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3D828BAAF;
	Wed,  7 May 2025 17:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746637266; cv=none; b=rc+3A0KcVDVtUYX97//+H+iVZnSxgQe0o3ytO3xYy+C41JLWmCqaj5qNDt8KBsEjA29tAF2g+1JPotYCJ3rk2caAFkK/lADEvZInstyhFn8XvTDfZMNsM1C9SKLEv59lIjJY1HDrm08FCADi6lya3mseCUHIMVXWc6bjgZ+jBxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746637266; c=relaxed/simple;
	bh=u6AZ6kU59/7hxI5Dn9KpiI190gICF70koF26H8PzqhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2Gf60VLUEIRdxc7gZrB2CrVbW4tZTFrlV0TNFwHsdFpiLxCZnFeK7SeFfl82nk1w/lTLtQMSPyma6GmB9IlcEFXItWHkMLd1srtO5i4fujZmEerNMkv+1PUTsngba4MlF8F2bFTdSE1aMgReyxcqMhRoRD/1/amRqQkEUUxbT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQOBkUqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQOBkUqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BED2C4CEE9;
	Wed,  7 May 2025 17:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746637266;
	bh=u6AZ6kU59/7hxI5Dn9KpiI190gICF70koF26H8PzqhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PQOBkUqznN8zfjPAjmnC0yTCzjwFdJC+KxmUWPMdmRREaU77XEoDN2J8rmPseg+X1
	 VfEQG7WIYOeVm2goFu67hGZjtn+J2CIMInjx8KJMwsMCbYsz/C6u5/6O9Kx+w1ZJGO
	 vM4m/gIE3sWf+hqHOKMoAKXTOsIMerKBSxxhB3g5LchQ+M+NH/85jeZxaVYoCmiJ0i
	 gB46eHbk1gUe2tIsXJlv9mp/ISRVbZRWmHAWaVJ/2KoPkwH9ohF5xjzSRWW47hJlDt
	 6ng2aeiSRosof8+LUd37nTezh6bSb/MTzQdVzcpvqgGvtqlBJbwcZtRSQMXAn/dqVH
	 6RvS8akyjBYxw==
Date: Wed, 7 May 2025 10:01:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Zorro Lang <zlang@kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	hch <hch@lst.de>
Subject: Re: [PATCH v3] xfs: test that we can handle spurious zone wp
 advancements
Message-ID: <20250507170105.GF25675@frogsfrogsfrogs>
References: <20250507102913.13759-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507102913.13759-1-hans.holmberg@wdc.com>

On Wed, May 07, 2025 at 10:30:14AM +0000, Hans Holmberg wrote:
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
> Changes since v1:
>  Added _require_realtime and fixed a white space error based
>  on Darrick's review comments.
> 
> Changes since v2:
>  Make sure we don't fail when the rt section is internal
>  Dropped inclusion of common filters and fixed dd parameter ordering
> 
>  tests/xfs/4214     | 71 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/4214.out |  2 ++
>  2 files changed, 73 insertions(+)
>  create mode 100755 tests/xfs/4214
>  create mode 100644 tests/xfs/4214.out
> 
> diff --git a/tests/xfs/4214 b/tests/xfs/4214
> new file mode 100755
> index 000000000000..f5262a40b229
> --- /dev/null
> +++ b/tests/xfs/4214
> @@ -0,0 +1,71 @@
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
> +. ./common/zoned
> +
> +_require_scratch
> +_require_realtime
> +
> +#
> +# Figure out if the rt section is internal or not
> +#
> +if [ -z "$SCRATCH_RTDEV" ]; then
> +	zdev=$SCRATCH_DEV
> +else
> +	zdev=$SCRATCH_RTDEV
> +fi
> +
> +_require_zoned_device $zdev
> +_require_command "$BLKZONE_PROG" blkzone
> +
> +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount
> +blksz=$(_get_file_block_size $SCRATCH_MNT)
> +
> +test_file=$SCRATCH_MNT/test.dat
> +dd if=/dev/zero of=$test_file bs=1M count=16 oflag=direct >> $seqres.full 2>&1 \
> +	|| _fail "file creation failed"
> +
> +_scratch_unmount
> +
> +#
> +# Figure out which zone was opened to store the test file and where
> +# the write pointer is in that zone
> +#
> +open_zone=$($BLKZONE_PROG report $zdev | \
> +	$AWK_PROG '/oi/ { print $2 }' | sed 's/,//')
> +open_zone_wp=$($BLKZONE_PROG report $zdev | \
> +	grep "start: $open_zone" | $AWK_PROG '{ print $8 }')
> +wp=$(( $open_zone + $open_zone_wp ))
> +
> +# Advance the write pointer manually by one block
> +dd if=/dev/zero of=$zdev bs=$blksz count=1 seek=$(($wp * 512 / $blksz)) \
> +	oflag=direct >> $seqres.full 2>&1 || _fail "wp advancement failed"
> +
> +_scratch_mount
> +_scratch_unmount
> +
> +# Finish the open zone
> +$BLKZONE_PROG finish -c 1 -o $open_zone $zdev
> +
> +_scratch_mount
> +rm $test_file
> +_scratch_unmount
> +
> +# The previously open zone, now finished and unused, should have been reset
> +nr_open=$($BLKZONE_PROG report $zdev | grep -wc "oi")
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
