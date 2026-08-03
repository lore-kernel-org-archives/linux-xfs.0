Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACCE3B2FFE;
	Mon,  3 Aug 2026 08:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785746151; cv=none; b=oDUo2ylrvdGzClYMr3g9yUkymmuWEx73z8t+XvdiP38naUqTAJygxGHZCaNXwEHXGl5MJ+n129cbEmdiKzmj3EJk1hih6xFJzar4vnuETS/9j9/ibPhlfO4jX0j93ERsSqdiPFXJFjKJDYyvmSpuKMGy2RVL8dnTElxDnGm1iw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785746151; c=relaxed/simple;
	bh=Rq20Dx/xaTXCa48joO7akkWiO3IRUXZ1E+s64N2/UdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KnVPMA23pEzez8x51nCLr/+JIUXsCMS3c5Jtl+Dwk9/cmsp3hPmK2tiuB/As0fIHVqZ+OMvj0mYQJrUP66H3PbGoV+g7h+hLyjybYeDO//mtLpWjTfxHbM5zMfAWe49ePszHKseMBOpl3XeRuhqzgGsGbXn395Hwg8MgHVhQgs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LuyDRv+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LuyDRv+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD101F00A3A;
	Mon,  3 Aug 2026 08:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785746150;
	bh=F2DuQK8E0jnfan7rjF43ykebRpxRydnvO7BnYdw6DiY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LuyDRv+bFQ2dpTtM9Pn0UjI6yorplhJBWSajNEz0LAXgWa5Vp/tZmDMnZ5vpnHZTy
	 qG1KuAilrBY8GgJxF1b6wxSp3Ay53NHTi2rsI23aKbq+4/eCG/dhgw4kuM6SHxckCq
	 BDsHJcceFEO2kRgUd/Kodrj7XwsEJSpGp5Pj7wFaWj/KTfnBWZsp9kERnBnog233Q8
	 9ilOTI+GQgUGbkET9xowUMwpnBM6b3is6u29ouzTPTcQ4S41D4u9KpLJaWji3WOtTm
	 qCiZAielz2IdNrLxS0WAoi7Zn55QDYWeXL9rREsaqXomxf2bU8FpOnx21uAsVSZp1c
	 O4m3S4TNAnu0w==
Date: Mon, 3 Aug 2026 16:35:43 +0800
From: Zorro Lang <zlang@kernel.org>
To: Lin Jiapeng <ljp1205831794@gmail.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, 
	djwong@kernel.org, jiapenglin@tencent.com
Subject: Re: [PATCH v4] xfs/842: verify CoW after exchangerange with
 FILE1_WRITTEN on shared extents
Message-ID: <anBSuI5Twx-j-IRV@zlang-mailbox>
Mail-Followup-To: Lin Jiapeng <ljp1205831794@gmail.com>, hch@lst.de, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org, 
	jiapenglin@tencent.com
References: <20260803025621.52453-1-jiapenglin@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803025621.52453-1-jiapenglin@tencent.com>

On Mon, Aug 03, 2026 at 10:56:13AM +0800, Lin Jiapeng wrote:
> When a full-file exchangerange is requested with FILE1_WRITTEN for a
> fully sparse donor file, every mapping pair is skipped, so no extents
> actually move.  However, the kernel decides to swap the reflink inode
> flag based on the request geometry alone, so the target file used to
> lose its reflink flag to the donor while still owning shared extents.
> A subsequent write then took the non-reflink write path and modified
> the shared physical blocks in place, silently corrupting the other
> file sharing them:
> 
>  --- tests/xfs/842.out
>  +++ results/xfs/842.out.bad
>  @@ -1,3 +1,4 @@
>   QA output created by 842
>  +vX.reflink = 0
>   vX.reflink = 1
>  -vX.reflink = 1
>  +orig changed: md5 e6065c4aa2ab1603008fc18410f579d4 -> 32c5189478e6bafa1cc76423f06c88f2 (write hit shared blocks in place)
> 
> This test clones a file so that both share extents, swaps the clone
> against a sparse donor with FILE1_WRITTEN, and then checks the defect
> twice.  First it inspects the inodes directly with xfs_db: the clone
> must still be flagged reflink after the exchange (the donor carrying
> the flag too is the conservative outcome of the fix and is harmless).
> Then it writes to the clone and verifies after a mount cycle that the
> original file's data is intact, i.e. the write was redirected through
> CoW.
> 
> The kernel fix "xfs: fix exchange-range reflink flag clearing issue
> with INO1_WRITTEN" refuses the reflink flag exchange whenever
> FILE1_WRITTEN is requested, which makes this test pass.
> 
> Reported-by: Lin Jiapeng(TencentOS Red Team) <jiapenglin@tencent.com>
> Link: https://lore.kernel.org/r/amgekiNKKoAdACnc@infradead.org
> Suggested-by: Zorro Lang <zlang@kernel.org>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Thanks, this version is good to me now.

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/xfs/842     | 63 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/842.out |  3 +++
>  2 files changed, 66 insertions(+)
>  create mode 100755 tests/xfs/842
>  create mode 100644 tests/xfs/842.out
> 
> diff --git a/tests/xfs/842 b/tests/xfs/842
> new file mode 100755
> index 0000000..e9d01f8
> --- /dev/null
> +++ b/tests/xfs/842
> @@ -0,0 +1,63 @@
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
> +
> +md5_before=$(md5sum $SCRATCH_MNT/orig | awk '{print $1}')
> +
> +# Swap the clone against the sparse donor, claiming the donor is fully
> +# written (-w).  Every donor mapping is a hole, so all pairs are skipped
> +# and the clone keeps its shared extents in place.
> +$XFS_IO_PROG -c "exchangerange -f -w $SCRATCH_MNT/donor" $SCRATCH_MNT/clone \
> +	>> $seqres.full
> +
> +# Directly confirm the inode flag state after the exchange: the clone
> +# must still be flagged reflink.  The donor may also carry the flag, which
> +# is the conservative outcome of refusing the flag exchange under
> +# FILE1_WRITTEN; the extra flag is harmless and can be dropped later by
> +# the regular reflink flag cleanup path.
> +_scratch_unmount
> +_scratch_xfs_db -c "path /clone" -c print -c "path /donor" -c print | \
> +	grep reflink | sed -e 's/^v[0-9]*/vX/g'
> +_scratch_mount
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
> +# success, all done
> +_exit 0
> diff --git a/tests/xfs/842.out b/tests/xfs/842.out
> new file mode 100644
> index 0000000..69049d5
> --- /dev/null
> +++ b/tests/xfs/842.out
> @@ -0,0 +1,3 @@
> +QA output created by 842
> +vX.reflink = 1
> +vX.reflink = 1
> -- 
> 2.50.1 (Apple Git-155)
> 
