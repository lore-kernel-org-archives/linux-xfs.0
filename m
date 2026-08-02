Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A20394471;
	Sun,  2 Aug 2026 12:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785672767; cv=none; b=ua7Mw9RyQa9XBNulZ1+POocZTrZR/S6GawmCHhAm9/FapX7EejtCPYNFavCRuqlF26rwHsX+WOk1VvXgShAQQehTthHeFDcT4u17SICs0bpeztzX8cMXM3ptLkXp7jeBaLe7PC0BueqPgKg9NkdbkSTXysSUTLy612jpYWUX88M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785672767; c=relaxed/simple;
	bh=qip+Kprzqn2YKns8DGI0WU7nL6cLJFjUctabAvrwOls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jt4CqF/xJHhAxnJmL2WASJhqPi/ijJ1+Cmwt4vUispDKNSMC6Rzl89B48CpclGTb0bdFCqE8pKIn1ciTabxcvjgArKX0vBu10kPYT92EVzAks0dBcgVy8eNm4G45TLsp2NI8cR8b9g57LhSAi+LxeZu64GXkOFeorVVZRHKp9GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQgyNJjV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQgyNJjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB081F00A3A;
	Sun,  2 Aug 2026 12:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785672765;
	bh=C3lCWflyUkl75Hc6AtfOhzt9Nhbp572GU9Gs33TPepM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UQgyNJjVst/88Pq9hd7I8Uyy8gND+ZXLHNDC52CMbIlabD30UNUJMfK4lqvngZbHE
	 8EG9SPHxGjCZIodtUXW/AWYmTYFb2BobR7cpKtgLJEr6SYD4D2corDKI5UfOhjuuC7
	 CHW75Dr6cuEtDSyZS5PQfo3T+znqRWw1E2SUK68d7n4Or5d0R/aVRZ7QshBbW++p6J
	 pW7J7GukIShjiDRYad9yRWMuCEbmbaYOTo7O6v7CyldE8aL9hXieqxaS7uwEsO9rAl
	 qm86PasyKaoIF3ZMHt8FMXqR//AmKu6ojpOIfNfgHM7XU9Ax504fIojuuUlFJUSY2O
	 +W+2MxQKwJlIQ==
Date: Sun, 2 Aug 2026 20:12:38 +0800
From: Zorro Lang <zlang@kernel.org>
To: Lin Jiapeng <ljp1205831794@gmail.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, 
	djwong@kernel.org, jiapenglin@tencent.com
Subject: Re: [PATCH v2] xfs/842: verify CoW after exchangerange with
 FILE1_WRITTEN on shared extents
Message-ID: <am8xmal5nCP4ZvlN@zlang-mailbox>
Mail-Followup-To: Lin Jiapeng <ljp1205831794@gmail.com>, hch@lst.de, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org, 
	jiapenglin@tencent.com
References: <20260729025504.54586-1-jiapenglin@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729025504.54586-1-jiapenglin@tencent.com>

On Wed, Jul 29, 2026 at 10:54:54AM +0800, Lin Jiapeng wrote:
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

So this patch/case uncovers a known bug which is fixed by:
  "xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN" ?

If so please add:
  _fixed_by_fs_commit xfs xxxxxxxxxxxx \
        "xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN"

> FILE1_WRITTEN is requested, which makes this test pass.
> 
> Reported-by: Lin Jiapeng(TencentOS Red Team) <jiapenglin@tencent.com>
> Link: https://lore.kernel.org/r/amgekiNKKoAdACnc@infradead.org
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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

_require_scratch_reflink contains _require_scratch, so you can save the
_require_scratch.

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

This case has expected output, so it's not "Silence is golden",
please remove this line.

> +status=0
> +exit

I remember we've changed xfstests/new script, it should give "_exit 0" at here.

Thanks,
Zorro

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
