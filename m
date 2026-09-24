Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116084B1263;
	Thu, 24 Sep 2026 18:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790276091; cv=none; b=jtpsg+wV3TARzL0HOnO9ClfNONz9kNqzL8cttfKFjFNPQTsFcra2w9Cr78obFtmvcoxjlSxeHznP6LCiqqnJAjKBhA2xs7KVbGqP41aEMg9l39FHDdenLWGAGFtbyDc7bt5JK1Fzne+75z5xS9OEQLJ6AEyfrqW1FHsWIITMZUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790276091; c=relaxed/simple;
	bh=k57Fd4RS2rnjCT9tbCuQA38PTnDUAcUPMy3EC0JTrk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YMBlxJYH2mLII9k9TJ1O98s9m894GxjhS+SWvBqrtZb6OswjxL6DNrRrY9p2gBrwC7qkCvKTDTkkoRUIZYmrIRLfwWam5fjPEYjCfPeMqsuWC4br4fUILLDRhpjcKhA9/T58JomzUd1GcLy0oVo6HN4LUXJYt6oiSUHrmRmCRgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PACAW3L1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PACAW3L1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DC9F41F000FF;
	Thu, 24 Sep 2026 18:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790276090;
	bh=TyRRzKwjTM3AikJxZeKxetlh7iB6Q+msI4nvJVi6xqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PACAW3L1+2Uesxd/FKcrUhdm9WerKnzuuXQCGxc7JfLpDJBOuLagkmff6sgF0seRf
	 x29zqv/Lcign8+PSLmRH8hExTEaEV+Motn9+h5EvcwtZ3fG5+igZibCnyv1WVS6v+Y
	 Z9p6500/c7SNFljnj4rgb6sg8Im9j1Cvwn6mRZt12bhMaEAaTHuCRRnjk3qtmBZarN
	 NxSKm38OgrkG+Elq9CGQmdNq/RG3R2o5FrGZW5knBEjgJQCnRXaxSqnfrcZuOeC87J
	 eJpjZXMxsqNmBbZzp2128s9j3YecNE/oau5PcsKula7GpokMaYjpe3WYvrg0eKQDlK
	 qGnrB9yJ5YGDg==
Date: Thu, 24 Sep 2026 11:54:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: exercise a failed CoW conversion during writeback
Message-ID: <20260924185449.GL2705364@frogsfrogsfrogs>
References: <20260924091338.198407-1-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924091338.198407-1-parri.andrea@gmail.com>

On Thu, Sep 24, 2026 at 11:13:36AM +0200, Andrea Parri wrote:
> iomap_add_to_ioend() submits the pending ioend through
> ->writeback_submit() before allocating a new one for the current
> range.  For XFS, xfs_writeback_submit() converts the ioend's CoW
> extents via xfs_reflink_convert_cow() before submitting the bio; if
> that conversion fails, ->writeback_submit() completes the ioend with
> an error and returns it.  A kernel bug left the stale ioend behind in
> wpc->wb_ctx, which iomap_writepages() then submitted a second time,
> corrupting XFS's ip->i_ioend_list.
> 
> Exercise this path with the wb_cow_convert_error error tag: reflink a
> file, dirty several widely separated ranges of the shared extent so
> that a single writepages() call has to build and submit more than one
> ioend, inject the error, and let writeback run.  On a kernel without
> the fix this reliably hits a "list_add double add" WARN from
> xfs_end_bio(); on a fixed kernel writeback just fails cleanly.
> 
> This requires the wb_cow_convert_error XFS error tag; the test cleanly
> not-runs on kernels without it.
> 
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
> ---
>  tests/xfs/842     | 70 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/842.out |  7 +++++
>  2 files changed, 77 insertions(+)
>  create mode 100755 tests/xfs/842
>  create mode 100644 tests/xfs/842.out
> 
> diff --git a/tests/xfs/842 b/tests/xfs/842
> new file mode 100755
> index 0000000000000..c15760a4c7f89
> --- /dev/null
> +++ b/tests/xfs/842
> @@ -0,0 +1,70 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Andrea Parri.  All Rights Reserved.
> +#
> +# FS QA Test No. 842
> +#
> +# Regression test for a failed ->writeback_submit() call leaving a stale
> +# wpc->wb_ctx behind.  iomap_writepages() then resubmits whatever
> +# wpc->wb_ctx points to, i.e. the ioend that ->writeback_submit() already
> +# completed with an error.  For XFS the second bio_endio() lands back in
> +# xfs_end_bio(), which list_add_tail()s the already-linked ioend into
> +# ip->i_ioend_list a second time, corrupting the list.
> +#
> +# The only in-tree way for XFS's ->writeback_submit() to fail is a
> +# failing xfs_reflink_convert_cow(), so this uses the
> +# wb_cow_convert_error error tag to force that on a reflinked file whose
> +# CoW extents are dirtied in several widely separated ranges, so that a
> +# single writepages() call has to submit more than one ioend.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick clone
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/reflink
> +. ./common/inject

If this is a regression testcase, it should cite a kernel fix commit,
right?

> +
> +_require_cp_reflink
> +_require_scratch_reflink
> +_require_xfs_io_error_injection "wb_cow_convert_error"
> +_require_kernel_config CONFIG_LIST_HARDENED
> +
> +blksz=65536
> +nr=8
> +sz=$((blksz * nr * 2))
> +
> +echo "Format and mount"
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount
> +
> +echo "Create reflinked file with several CoW extents"
> +_pwrite_byte 0x58 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
> +_scratch_sync
> +_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
> +
> +# Dirty several widely separated ranges of file2's CoW extents so that a
> +# single writepages() call has to submit more than one ioend.
> +seq=0
> +while [ $seq -lt $nr ]; do
> +	off=$((seq * blksz * 2))
> +	_pwrite_byte 0x59 $off $blksz $SCRATCH_MNT/file2 >> $seqres.full
> +	seq=$((seq + 1))
> +done
> +
> +echo "Inject wb_cow_convert_error"
> +_scratch_inject_error "wb_cow_convert_error"
> +
> +echo "Trigger writeback with CoW conversion forced to fail"
> +_scratch_sync
> +
> +_scratch_inject_error "wb_cow_convert_error" 0

It's not necessary to reset the error handlers if you're just going to
unmount after.

--D

> +
> +echo "Remount"
> +_scratch_cycle_mount
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/842.out b/tests/xfs/842.out
> new file mode 100644
> index 0000000000000..72c9c67e7d5fb
> --- /dev/null
> +++ b/tests/xfs/842.out
> @@ -0,0 +1,7 @@
> +QA output created by 842
> +Format and mount
> +Create reflinked file with several CoW extents
> +Inject wb_cow_convert_error
> +Trigger writeback with CoW conversion forced to fail
> +Remount
> +Silence is golden
> -- 
> 2.53.0
> 
> 
