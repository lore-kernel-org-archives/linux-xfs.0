Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A49E472534;
	Tue, 28 Jul 2026 14:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785250788; cv=none; b=TWrGprXk/jjrMo4AZ8SMpZXCcw6wFnX/rQNuVLmcbeJJla60uR4+Uhd7TUEmC90nT5KZwCW4btjP6T4BgaCJkytt/VHzbjBJIiRI3toyOOnzkcEwGVy6gw86HgTbSa9a6Dyj3hVg4iYP0gEcfn/sGtIE7l5qRyu+YwqPWp+Ez1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785250788; c=relaxed/simple;
	bh=sRk6c4kick86NEt1MUpvlo0Z8uLS7gr1nxZwp8kVqlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e8mfGu/XNqKTFbbSm5AyeCAaLxqVY3FW/MCU4rL4G+WkZyv/rK7SCHz2Va+ie434LVQLSYHPu2oePHrw20aDB2ldzg8D1upluXFbHfEASFVE3Fsxlr95Z8F6xXLEE6OuSyvjjJvGzPEi1dCxghrVRDVpS0gZAyg38putXMHumfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aI18/76S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aI18/76S"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C4EF51F000E9;
	Tue, 28 Jul 2026 14:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785250786;
	bh=Sh5dYU/f1v+W2SJpNOuarRKhWy8WgRMbaLkuKwmMoiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aI18/76SDc9RBko7l1vBlrfOv5eQDTg1iVXyE4O+wDoeDp0COAiX/sxB5kgxIexsn
	 iSjbMeQ9jltcaQV/aR3l/wGcSG8lMd2l/VR9IExRUKZehIyKB3CTSPX1Jz12lGU5Vm
	 PYo+lv3ijYLsgiY8UCsssIYDIlvzJ6rtxFHwjnZ8GyJ+TaKRBUSOWW4ueWNFJsvlCi
	 kN9c5vHI3DWet3UgOFxzh15VuvQ9LSAYKuDD/CeVfIavMlaqSUazFux448+Yzd/HB7
	 431z8JY+7fetIjHRkDry2spJejpmtHZhOavUFZltLIcNxYBjZw7Tbwmq8vV+mfiKfk
	 GNrW+ZhdN61Ng==
Date: Tue, 28 Jul 2026 07:59:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lin Jiapeng <ljp1205831794@gmail.com>
Cc: zlang@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, jiapenglin@tencent.com
Subject: Re: [PATCH] xfs/842: verify CoW after exchangerange with
 FILE1_WRITTEN on shared extents
Message-ID: <20260728145946.GK2901224@frogsfrogsfrogs>
References: <20260728071625.79516-1-jiapenglin@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728071625.79516-1-jiapenglin@tencent.com>

On Tue, Jul 28, 2026 at 03:16:20PM +0800, Lin Jiapeng wrote:
> When a full-file exchangerange is requested with FILE1_WRITTEN for a
> fully sparse donor file, every mapping pair is skipped, so no extents
> actually move.  However, the kernel decides to swap the reflink inode
> flag based on the request geometry alone, so the target file used to
> lose its reflink flag while still owning shared extents.  A subsequent
> write then took the non-reflink write path and modified the shared
> physical blocks in place, silently corrupting the other file sharing
> them:
> 
>  --- tests/xfs/842.out
>  +++ results/xfs/842.out.bad
>  @@ -1,2 +1,3 @@
>   QA output created by 842
>  +orig changed: md5 e6065c4aa2ab1603008fc18410f579d4 -> 32c5189478e6bafa1cc76423f06c88f2 (write hit shared blocks in place)
>   Silence is golden
> 
> This test clones a file so that both share extents, swaps the clone
> against a sparse donor with FILE1_WRITTEN, writes to the clone, and
> verifies after a mount cycle that the original file's data is intact,
> i.e. the write was redirected through CoW.
> 
> The kernel fix "xfs: fix exchange-range reflink flag clearing issue
> with INO1_WRITTEN" refuses the reflink flag exchange whenever
> FILE1_WRITTEN is requested, which makes this test pass.
> 
> Reported-by: Lin Jiapeng(TencentOS Red Team) <jiapenglin@tencent.com>
> Link: https://lore.kernel.org/r/amgekiNKKoAdACnc@infradead.org
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
> ---
>  tests/xfs/842     | 55 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/842.out |  2 ++
>  2 files changed, 57 insertions(+)
>  create mode 100755 tests/xfs/842
>  create mode 100644 tests/xfs/842.out
> 
> diff --git a/tests/xfs/842 b/tests/xfs/842
> new file mode 100755
> index 0000000..6d5bcab
> --- /dev/null
> +++ b/tests/xfs/842
> @@ -0,0 +1,55 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2026 Tencent.  All Rights Reserved.
> +#
> +# FS QA Test No. 842
> +#
> +# Make sure that a full-file exchangerange under FILE1_WRITTEN does not strip
> +# the reflink flag from a file that still owns shared extents.  When the
> +# donor file is fully sparse, every mapping pair is skipped, so no extents
> +# actually move; the target file must keep its reflink flag, and a later
> +# write must go through CoW instead of modifying the shared blocks in place.
> +
> +. ./common/preamble
> +_begin_fstest auto quick fiexchange
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/reflink
> +
> +_require_xfs_io_command exchangerange
> +_require_scratch_reflink
> +_require_scratch
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +
> +# Create the original file with a known pattern and clone it, so that both
> +# files share the same extents.
> +_pwrite_byte 0x41 0 1m $SCRATCH_MNT/orig >> $seqres.full
> +_reflink $SCRATCH_MNT/orig $SCRATCH_MNT/clone >> $seqres.full
> +
> +# Create a fully sparse donor file of the same size.
> +$XFS_IO_PROG -f -c 'truncate 1m' $SCRATCH_MNT/donor

Hehe, this is exactly the same sequence as the testcase I wrote
yesterday afternoon, so the review is easy;

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

(For extra clarity I also had done:

# Check reflink flags
_scratch_unmount
_scratch_xfs_db -c "path /orig" -c 'print' -c "path /donor" -c 'print' | grep reflink
_scratch_mount

for direct confirmation of the incorrect inode flag state, but the
md5sum failure suffices to prove the defect.)

--D

> +
> +md5_before=$(md5sum $SCRATCH_MNT/orig | awk '{print $1}')
> +
> +# Swap the clone against the sparse donor, claiming the donor is fully
> +# written (-w).  Every donor mapping is a hole, so all pairs are skipped
> +# and the clone keeps its shared extents in place.
> +$XFS_IO_PROG -c "exchangerange -f -w $SCRATCH_MNT/donor" $SCRATCH_MNT/clone \
> +	>> $seqres.full
> +
> +# Overwrite part of the clone.  With the reflink flag correctly retained,
> +# this must go through CoW and leave the shared blocks of orig untouched.
> +_pwrite_byte 0x42 0 64k $SCRATCH_MNT/clone >> $seqres.full
> +_scratch_cycle_mount
> +
> +md5_after=$(md5sum $SCRATCH_MNT/orig | awk '{print $1}')
> +
> +test "$md5_before" != "$md5_after" && \
> +	echo "orig changed: md5 $md5_before -> $md5_after (write hit shared blocks in place)"
> +
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/842.out b/tests/xfs/842.out
> new file mode 100644
> index 0000000..643d052
> --- /dev/null
> +++ b/tests/xfs/842.out
> @@ -0,0 +1,2 @@
> +QA output created by 842
> +Silence is golden
> -- 
> 2.50.1 (Apple Git-155)
> 
> 
