Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D514B4C79;
	Fri, 19 Dec 2025 02:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766110447; cv=none; b=hDNkf2+d4rJ4yDJWKW9vybb4VkYsoDn0VOcvTl6hXMIXl/pAkzyK3i+iZAZ8WDz+G7D3QA6MNsMCbqQlzDxP9i1pkcYkEd/aJcNq/bTc7YjkhTdtkEFnZMq7T4fPEiQCpUamdnA+bs896JtnffX3FORVshbnfeW4q38jL3iUlLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766110447; c=relaxed/simple;
	bh=+8FRjjcYkOjGsJi3zKKaSIDPtFuJE10O2LV0hDRLH74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KV+S91r33NISVD5aAHsOlG8H6fk7lw820Y56Pw7N+seD6IBW/HsL8eNOf8+Y6AwFXptUbqQLb99pX8i9sOAmYkbKGZ/4ip5uRuoBbWnqNCHZtM4UlwPRe4l9KJejXzuaCiwEfj3KeC4q08H0kLbtvvxS5ne8BXRvEkUfuSL617U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qdg2slts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qdg2slts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4A2C4CEFB;
	Fri, 19 Dec 2025 02:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766110445;
	bh=+8FRjjcYkOjGsJi3zKKaSIDPtFuJE10O2LV0hDRLH74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qdg2sltsOR/Kw1lbRo0ule3/09JwvLVmQLQfNVrE/nDVy/1aAJ9Xl7iauLRtvZY6I
	 b1BA4Cy8lqvNRGCGvqHGSjoQqgIlNyY4zdKqJQw9UXlF1ee+dEXitXCmvb3+H8J5Cr
	 buuL/1cUPwLvXGQdejHP3hGbiIbhvphN1Bu24bGJf7/oAfCKVggqJBY2RqpO8KdDRF
	 rtfZbCGZLxFvjYLO546poBlbC7B50XFugbQ2L5a0gXt0+PwhhesCipNbHNgziANoWv
	 em65On+Sd4L7FzBB+ndag50vdLmkyIYWQKrB5/1rrALtkGSGnCyKq8drEHSQzykqS1
	 M6pKfLLSKBpMQ==
Date: Thu, 18 Dec 2025 18:14:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: test that mkfs creates zone-aligned RT devices
Message-ID: <20251219021404.GC7725@frogsfrogsfrogs>
References: <20251218161045.1652741-1-hch@lst.de>
 <20251218161045.1652741-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218161045.1652741-4-hch@lst.de>

On Thu, Dec 18, 2025 at 05:10:18PM +0100, Christoph Hellwig wrote:
> Make sure mkfs doesn't create unmountable file systems and instead rounds
> down the RT subvolume size to a multiple of the zone size.
> 
> Two passes: one with a device that is not aligned, and one for an
> explicitly specified unaligned RT device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/xfs/653     | 66 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/653.out |  3 +++
>  2 files changed, 69 insertions(+)
>  create mode 100755 tests/xfs/653
>  create mode 100644 tests/xfs/653.out
> 
> diff --git a/tests/xfs/653 b/tests/xfs/653
> new file mode 100755
> index 000000000000..12d606c436f0
> --- /dev/null
> +++ b/tests/xfs/653
> @@ -0,0 +1,66 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2025 Christoph Hellwig.
> +#
> +# FS QA Test No. 653
> +#
> +# Tests that mkfs for a zoned file system rounds realtime subvolume sizes up to
> +# the zone size to create mountable file systems.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick realtime growfs zone
> +
> +. ./common/filter
> +. ./common/zoned
> +
> +_cleanup()
> +{
> +	_unmount $LOOP_MNT 2>/dev/null
> +	[ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
> +	rm -rf $LOOP_IMG $LOOP_MNT
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +_require_test
> +_require_loop
> +_require_xfs_io_command "truncate"
> +
> +fsbsize=4096
> +aligned_size=$((3 * 1024 * 1024 * 1024))
> +unaligned_size=$((2 * 1024 * 1024 * 1024 + fsbsize * 13))
> +
> +_require_fs_space $TEST_DIR $((aligned_size / 1024))
> +
> +LOOP_IMG=$TEST_DIR/$seq.dev
> +LOOP_MNT=$TEST_DIR/$seq.mnt
> +rm -rf $LOOP_IMG $LOOP_MNT
> +mkdir -p $LOOP_MNT
> +
> +# try to create an unaligned RT volume by manually specifying the RT device size
> +$XFS_IO_PROG -f -c "truncate ${aligned_size}" $LOOP_IMG
> +loop_dev=$(_create_loop_device $LOOP_IMG)
> +
> +echo "Formatting file system (unaligned specified size)"
> +_try_mkfs_dev -b size=4k -r zoned=1,size=$((unaligned_size / fsbsize))b $loop_dev \
> +		>> $seqres.full 2>&1 ||\
> +	_notrun "cannot mkfs zoned filesystem"
> +_mount $loop_dev $LOOP_MNT
> +umount $LOOP_MNT
> +_destroy_loop_device $loop_dev
> +rm -rf $LOOP_IMG
> +
> +# try to create an unaligned RT volume on on an oddly sized device
> +$XFS_IO_PROG -f -c "truncate ${unaligned_size}" $LOOP_IMG
> +loop_dev=$(_create_loop_device $LOOP_IMG)
> +
> +echo "Formatting file system (unaligned device)"
> +_try_mkfs_dev -b size=4k -r zoned=1 $loop_dev \
> +		>> $seqres.full 2>&1 ||\
> +	_notrun "cannot mkfs zoned filesystem"
> +_mount $loop_dev $LOOP_MNT
> +umount $LOOP_MNT
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/653.out b/tests/xfs/653.out
> new file mode 100644
> index 000000000000..96158d93f55c
> --- /dev/null
> +++ b/tests/xfs/653.out
> @@ -0,0 +1,3 @@
> +QA output created by 653
> +Formatting file system (unaligned specified size)
> +Formatting file system (unaligned device)
> -- 
> 2.47.3
> 
> 
