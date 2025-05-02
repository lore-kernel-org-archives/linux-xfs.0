Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B7B146A68;
	Fri,  2 May 2025 16:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746201877; cv=none; b=PHDjinjKpiPbop7xv7AI52JfAUEpdCvmmRp4w1gASo+CrXLwZaBMCdvH57oIq4REYTtf3TNJhrD6p4mllB6DPGHM1cL4s1kjtCQu/7Mzklyb7qrPg5aRRY/bJU724pvugqY+gPxep7SUdh+aXv5POJGKjsKPEm+HKUIhqdi53PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746201877; c=relaxed/simple;
	bh=nhGZIU8WtEYbI08rPQrrzzbVSkaBssDIf0ptL5oncEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r4tYN2/R17vZyuYh7jAhxHnGFLLhuRIZUtrrMPyHXsJca+1KYIL0CXwlbtzUwUAAMR4FZqy67YkZLjwxKT9ac3wXYOE1UTNe3a2USYUovGUS9DsGKVnrNfGDiJCq516AAutgMKMhNOvxtpcNGGImxsKJxD/JFJfy/ho6cWXursg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KsQ1hReP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KsQ1hReP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99382C4CEE4;
	Fri,  2 May 2025 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746201876;
	bh=nhGZIU8WtEYbI08rPQrrzzbVSkaBssDIf0ptL5oncEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KsQ1hRePlKqHvW10A3xJWu7V4qwDa57kt2/8x53dkyEIvvkKcbS4sHMzcspnbgA46
	 OqTkKHeeSL11R4KrH3IepsoeAB1eWl+kq0/uDltlDwuEVXkkVfBIibDRcT6FkAd50B
	 6tzPjVgWYF0FN1+Y+cfzlrnKPgaR7/d4oNjaPIgHQ4yqLNBc7duEvo8a2QBye0oAQT
	 7r2eENEskJ/tBYYfjz6YdR6aUpz9TnSHwkL8lyqImROwecm/LTu8Lns+0cCZLWGXja
	 Kl8Kz3BTKm91IxFltrKfx/fq6mhEANsXbL7RK3Hu/WsP6HuLgKW/33UwyzYy1owUJV
	 x/3E/yZ07Y72g==
Date: Fri, 2 May 2025 09:04:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/15] xfs: test that we can handle spurious zone wp
 advancements
Message-ID: <20250502160436.GO25667@frogsfrogsfrogs>
References: <20250501134302.2881773-1-hch@lst.de>
 <20250501134302.2881773-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501134302.2881773-16-hch@lst.de>

On Thu, May 01, 2025 at 08:42:52AM -0500, Christoph Hellwig wrote:
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
> ---
>  tests/xfs/4214     | 61 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/4214.out |  2 ++
>  2 files changed, 63 insertions(+)
>  create mode 100755 tests/xfs/4214
>  create mode 100644 tests/xfs/4214.out
> 
> diff --git a/tests/xfs/4214 b/tests/xfs/4214
> new file mode 100755
> index 000000000000..3e73a54614d5
> --- /dev/null
> +++ b/tests/xfs/4214
> @@ -0,0 +1,61 @@
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

Needs _require_realtime so that the next command doesn't fail on
undefined SCRATCH_RTDEV

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
> +       	grep "start: $open_zone" | $AWK_PROG '{ print $8 }')

   ^ spaces here before a tab

--D

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
> 2.47.2
> 
> 
