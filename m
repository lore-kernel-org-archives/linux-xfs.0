Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0451A681B;
	Mon, 28 Sep 2026 15:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790610115; cv=none; b=juSde3oNOMW4PotQZIwyckblIA5kS+jt1sfdXwO0+QYfBsnAcDElWc8phkfEIFZSGrgt0r9zTS5zF6pMBxg87QMFXmrVlIheWU9Vn3+Uf60h2rKV/qhD0Hfss9wN6EJTetAzo3ZqufigE7YKNY5a7NAeUK9Sy/Y0cHJ3Zv4Rpuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790610115; c=relaxed/simple;
	bh=zO/3yLTnLzkBu/KWZjdtcM9XW56Nbq+sBRS6f3G/tFo=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3+scoFTR+LOte2U+w3hOKPV7r/iTNoMI+muAytXU//Ji3mnKr7b4WNmz6NL5+igMsXWJhEBH50yfNLhrMQibklKYxwMqqFxk8ru8XiPGXQBgeuooTY1TdSGDWjuTLkNW3EVdUWxio5p8hahjBPbgqkHkHdUT0o2Tdvjhs9a8pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mxTQOGGd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mxTQOGGd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9D68D1F0089A;
	Mon, 28 Sep 2026 15:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790610109;
	bh=406ll8SYjoCP+g9GH9MAvoT4p+fYrC9aNAp2zzfkMEc=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=mxTQOGGd9btmaEdWfE8hZltDxr0qvF/MisRfw0tKU2uCq55BXwpisQSDgptzYWkye
	 5Ge+hy7tmk+N/yNtMD7BYm6ayzKLYxNf6/PpKTv8hCBrQVjRUtgOcAW/RMfHFYvCOe
	 5IjlGX+u54wN6A4lsmMN+kz3IBMCBvqp8JxzgFtOUXQ1bhEU1vqaallwhL13IclIql
	 UvEu+Iw4XnsbUDT8I6IQgnRwnXyBU2ZQltiJNJxrKlKU+ZtQy975q6T+vrtT3grMKp
	 XX4q6jokGwLl6xpQg1okKBdV/MIDK0NkxHA/vs/7iQJksuB8gaR04jmIc7ScZWTnxC
	 G+u/vNO3C6BNw==
Date: Mon, 28 Sep 2026 08:41:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrea Parri <parri.andrea@gmail.com>, fstests@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: exercise a failed CoW conversion during writeback
Message-ID: <20260928154149.GA6253@frogsfrogsfrogs>
References: <20260928085047.7250-1-parri.andrea@gmail.com>
 <arprh9oyZEXs25CQ@zlang-mailbox>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arprh9oyZEXs25CQ@zlang-mailbox>

On Mon, Sep 28, 2026 at 09:53:29PM +0800, Zorro Lang wrote:
> On Mon, Sep 28, 2026 at 10:50:46AM +0200, Andrea Parri wrote:
> > iomap_add_to_ioend() submits the pending ioend through
> > ->writeback_submit() before allocating a new one for the current
> > range.  For XFS, xfs_writeback_submit() converts the ioend's CoW
> > extents via xfs_reflink_convert_cow() before submitting the bio; if
> > that conversion fails, ->writeback_submit() completes the ioend with
> > an error and returns it.  A kernel bug left the stale ioend behind in
> > wpc->wb_ctx, which iomap_writepages() then submitted a second time,
> > corrupting XFS's ip->i_ioend_list.
> > 
> > Exercise this path with the wb_cow_convert_error error tag: reflink a
> > file, dirty several widely separated ranges of the shared extent so
> > that a single writepages() call has to build and submit more than one
> > ioend, inject the error, and let writeback run.  On a kernel without
> > the fix this reliably hits a "list_add double add" WARN from
> > xfs_end_bio(); on a fixed kernel writeback just fails cleanly.
> > 
> > This requires the wb_cow_convert_error XFS error tag; the test cleanly
> > not-runs on kernels without it.
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
> > ---
> > The kernel fix and the wb_cow_convert_error error tag this test relies
> > on are part of the series at:
> > 
> >   https://lore.kernel.org/all/cover.1790342457.git.parri.andrea@gmail.com/
> > 
> > Changes since v1:
> >  - Cite the kernel fix with _fixed_by_kernel_commit (Darrick).
> >  - Don't reset the error tag before the remount; the unmount clears it
> >    anyway (Darrick).
> >  - Picked up Christoph's Reviewed-by.
> > 
> > v1: https://lore.kernel.org/all/20260924091338.198407-1-parri.andrea@gmail.com/
> 
> Overall the patch looks good to me, but I have one minor comment below ...
> 
> > 
> >  tests/xfs/842     | 71 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/842.out |  7 +++++
> >  2 files changed, 78 insertions(+)
> >  create mode 100755 tests/xfs/842
> >  create mode 100644 tests/xfs/842.out
> > 
> > diff --git a/tests/xfs/842 b/tests/xfs/842
> > new file mode 100755
> > index 0000000000000..4495e9bdfa530
> > --- /dev/null
> > +++ b/tests/xfs/842
> > @@ -0,0 +1,71 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 Andrea Parri.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 842
> > +#
> > +# Regression test for a failed ->writeback_submit() call leaving a stale
> > +# wpc->wb_ctx behind.  iomap_writepages() then resubmits whatever
> > +# wpc->wb_ctx points to, i.e. the ioend that ->writeback_submit() already
> > +# completed with an error.  For XFS the second bio_endio() lands back in
> > +# xfs_end_bio(), which list_add_tail()s the already-linked ioend into
> > +# ip->i_ioend_list a second time, corrupting the list.
> > +#
> > +# The only in-tree way for XFS's ->writeback_submit() to fail is a
> > +# failing xfs_reflink_convert_cow(), so this uses the
> > +# wb_cow_convert_error error tag to force that on a reflinked file whose
> > +# CoW extents are dirtied in several widely separated ranges, so that a
> > +# single writepages() call has to submit more than one ioend.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick clone
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/reflink
> > +. ./common/inject
> > +
> > +_fixed_by_kernel_commit XXXXXXXXXXXX \
> > +	"iomap: don't resubmit an ioend after ->writeback_submit() failed"
> > +
> > +_require_cp_reflink
> > +_require_scratch_reflink
> > +_require_xfs_io_error_injection "wb_cow_convert_error"
> > +_require_kernel_config CONFIG_LIST_HARDENED
> > +
> > +blksz=65536
> > +nr=8
> > +sz=$((blksz * nr * 2))
> > +
> > +echo "Format and mount"
> > +_scratch_mkfs >> $seqres.full 2>&1
> > +_scratch_mount
> > +
> > +echo "Create reflinked file with several CoW extents"
> > +_pwrite_byte 0x58 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
> > +_scratch_sync
> > +_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
> > +
> > +# Dirty several widely separated ranges of file2's CoW extents so that a
> > +# single writepages() call has to submit more than one ioend.
> > +seq=0
> 
> In fstests, $seq is a core global variable representing the test sequence
> number. Overwriting it here might lead to unexpected side effects with
> framework helpers or cleanup logic. Could we rename this loop variable to
> something else to avoid trouble? If you need, I can help that when I merge
> it.
> 
> Thanks,
> Zorro
> 
> > +while [ $seq -lt $nr ]; do
> > +	off=$((seq * blksz * 2))
> > +	_pwrite_byte 0x59 $off $blksz $SCRATCH_MNT/file2 >> $seqres.full
> > +	seq=$((seq + 1))
> > +done

for ((off = 0; off < (blksz * nr * 2); off += (blksz * 2))); do
	_pwrite_byte 0x59 $off $blksz $SCRATCH_MNT/file2 >> $seqres.full
done

--D

> > +
> > +echo "Inject wb_cow_convert_error"
> > +_scratch_inject_error "wb_cow_convert_error"
> > +
> > +echo "Trigger writeback with CoW conversion forced to fail"
> > +_scratch_sync
> > +
> > +echo "Remount"
> > +_scratch_cycle_mount
> > +
> > +echo "Silence is golden"
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/842.out b/tests/xfs/842.out
> > new file mode 100644
> > index 0000000000000..72c9c67e7d5fb
> > --- /dev/null
> > +++ b/tests/xfs/842.out
> > @@ -0,0 +1,7 @@
> > +QA output created by 842
> > +Format and mount
> > +Create reflinked file with several CoW extents
> > +Inject wb_cow_convert_error
> > +Trigger writeback with CoW conversion forced to fail
> > +Remount
> > +Silence is golden
> > -- 
> > 2.53.0
> > 
> 
