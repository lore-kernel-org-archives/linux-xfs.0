Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33EE3AAF53;
	Wed, 29 Jul 2026 15:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338739; cv=none; b=IjZrVQG3MOpNiIOV/NSipMaoRwpi+qVUGfmvBjrCeCzTb6PgzbnGOPfsmO6XGrckfiLeDQsggzaVDsMJ9Yp4KPhGE35KwN9mN7goTNu7Yzd4czF+PwpdNYc+DIcQwY+TwavPEhNmOqJsAv1PYxko/j0zmshT80qPmLX+RhLx0xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338739; c=relaxed/simple;
	bh=Zf3WvbDZYnx1kIzlBEqKTlMP2KfmbFNEf2x1Y2k5DFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/VMnD4b9S0LVOhZ7tmOaDytDVKAuDuwXtN+da6xrEu8VGyxGb5F9UPtx1tRJaqLInztH7+nHCXJ+W+UPWFygAZ2tcp0Jq1XyZskRzt6QSdgYrNaQXpfiEs8TBkGvza+5OOXDz/Y7B8Ovlzf/pLIr95gRzlbvtkjPIwK/0iC5qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gf6GTeTB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gf6GTeTB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6E02C1F000E9;
	Wed, 29 Jul 2026 15:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785338737;
	bh=k2sc3553XcuoMak8eBneXA7+/J30oR6eDVEnzfddeqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gf6GTeTBs7jiF7aGfps+3k4DVT96MhRCwg1dddpodiK45+jK718dBI9orM765babx
	 HG7isQ8Lf3mPXJY6E+cNS2R0XvJZ1LOBtUA4srSJpdnwW9/8ziRoA5oRMTIDgTshdm
	 yzD85TKMJCbpCcT+E3jX2s82iCZsLcHM3fl1DZwElLvufQi4PcUiOcsgPV3EjCw382
	 vz9qf8T0T8lYwsF/+mM1ZCiLRqAwlkedyXsCQ+ERVeQVkKa+qkm59UGjM4RNkD/gTY
	 k2luGI5EcJeG4CJk4JNOmS/tevUrOOWzjI8gXqVDSpeMkowMD1K3saYak0koxUEAsk
	 KrN318HJlQ95g==
Date: Wed, 29 Jul 2026 08:25:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lin Jiapeng <ljp1205831794@gmail.com>
Cc: zlang@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, jiapenglin@tencent.com
Subject: Re: [PATCH v3] xfs/842: verify CoW after exchangerange with
 FILE1_WRITTEN on shared extents
Message-ID: <20260729152536.GU2901224@frogsfrogsfrogs>
References: <20260729063956.3664-1-jiapenglin@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729063956.3664-1-jiapenglin@tencent.com>

On Wed, Jul 29, 2026 at 02:39:52PM +0800, Lin Jiapeng wrote:
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
>  @@ -1,4 +1,5 @@
>   QA output created by 842
>  +vX.reflink = 0
>   vX.reflink = 1
>  -vX.reflink = 1
>  +orig changed: md5 e6065c4aa2ab1603008fc18410f579d4 -> 32c5189478e6bafa1cc76423f06c88f2 (write hit shared blocks in place)
>   Silence is golden
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
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
> ---
>  tests/xfs/842     | 65 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/842.out |  4 +++
>  2 files changed, 69 insertions(+)
>  create mode 100755 tests/xfs/842
>  create mode 100644 tests/xfs/842.out
> 
> diff --git a/tests/xfs/842 b/tests/xfs/842
> new file mode 100755
> index 0000000..c4c2be9
> --- /dev/null
> +++ b/tests/xfs/842
> @@ -0,0 +1,65 @@
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
> +echo Silence is golden

Nitpick: If the test generates any .out output, you don't need the
"Silence is golden" marker.

The test itself looks ok and the above is a minor point so:
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +status=0
> +exit
> diff --git a/tests/xfs/842.out b/tests/xfs/842.out
> new file mode 100644
> index 0000000..1e6345a
> --- /dev/null
> +++ b/tests/xfs/842.out
> @@ -0,0 +1,4 @@
> +QA output created by 842
> +vX.reflink = 1
> +vX.reflink = 1
> +Silence is golden
> -- 
> 2.50.1 (Apple Git-155)
> 
> 
