Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13E63BCD29;
	Mon,  3 Aug 2026 09:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785748073; cv=none; b=q7XR9XWhUt3bjzv2AYj2phbeTy4b0R3DHTQ62aR1sSFn9a+xW1Ag6TvSk6tCaRgyfTt2OjID9H9QI9o/lyeZRLIFQAMo5tKnaGFrZpEyhVCMRL4S2cLipotPEVmoMWosNfF3uPf6gl7dY2jTGMVQ2DQcrSmhGPDWlcZlNyal/TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785748073; c=relaxed/simple;
	bh=yHdiUNVZEOVQCn6+EXnvwHZDpHYmhWv/bbDOhmDrF9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W8jFPneppPvV0Q0G1BTCXoxLj8Ebp66MR0+XOplUT0O3b6CeuX5Q5Xp+x6kIFj6K5DLr/WBfo10sHbpQy8DiHcMRdbjnxSv8sELEVkSOL/tdZZOT5UiZz7zpox5UYT6TqibP7Ix9WH08Q8ZGlNhpmwaZSc4tlBeDub1aobYb40M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M6l0X0al; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M6l0X0al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036E61F000E9;
	Mon,  3 Aug 2026 09:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785748071;
	bh=j4pQ7WfgwBxkr+0q9PyvO7LJoAzPLvzOTJO0g969duU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M6l0X0alffaGelN773VoYLH7RgRUwU6rGg8y+SKCOd7WZ9qpFi7VL0HH9p1hrz7lZ
	 QEId8rgm39Khnv5cZx/1eR6IvePgI+cjGotYocNfUnAX985QQ7y/Qe8GJ9pspAW3+n
	 iHEhFl3V9MLoCFGd9jzoZK09uhT5rqq1A3IPoOWPjgty8bD/NN75AjGKPq+tD4NCZU
	 amBr8Uzm2OQsR4OccyKeFgPfZMvW6GimNsWlLe8uocz+CmmwtZoAiAtOCaeMSPH6JT
	 POG2r3ym/20tiwMPZhUNj7yXrkAHRKSZWyeXrm7EQUb5+xKxD7MiEFqlMjWnRWn51V
	 vdRvUmyL0USyw==
Date: Mon, 3 Aug 2026 17:07:43 +0800
From: Zorro Lang <zlang@kernel.org>
To: Lin Jiapeng <ljp1205831794@gmail.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, 
	djwong@kernel.org, jiapenglin@tencent.com
Subject: Re: [PATCH v2] xfs/842: verify CoW after exchangerange with
 FILE1_WRITTEN on shared extents
Message-ID: <anBTKpvN_N7rA6Vu@zlang-mailbox>
Mail-Followup-To: Lin Jiapeng <ljp1205831794@gmail.com>, hch@lst.de, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org, 
	jiapenglin@tencent.com
References: <20260729025504.54586-1-jiapenglin@tencent.com>
 <am8xmal5nCP4ZvlN@zlang-mailbox>
 <ddc3741c-612a-4d0b-bc58-bc5f54a4080b@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ddc3741c-612a-4d0b-bc58-bc5f54a4080b@gmail.com>

On Sun, Aug 02, 2026 at 09:59:16PM +0800, Lin Jiapeng wrote:
> 
>
> 在 2026/8/2 20:12, Zorro Lang 写道:
> > On Wed, Jul 29, 2026 at 10:54:54AM +0800, Lin Jiapeng wrote:
> > > When a full-file exchangerange is requested with FILE1_WRITTEN for a
> > > fully sparse donor file, every mapping pair is skipped, so no extents
> > > actually move.  However, the kernel decides to swap the reflink inode
> > > flag based on the request geometry alone, so the target file used to
> > > lose its reflink flag to the donor while still owning shared extents.
> > > A subsequent write then took the non-reflink write path and modified
> > > the shared physical blocks in place, silently corrupting the other
> > > file sharing them:
> > > 
> > >   --- tests/xfs/842.out
> > >   +++ results/xfs/842.out.bad
> > >   @@ -1,4 +1,5 @@
> > >    QA output created by 842
> > >   +vX.reflink = 0
> > >    vX.reflink = 1
> > >   -vX.reflink = 1
> > >   +orig changed: md5 e6065c4aa2ab1603008fc18410f579d4 -> 32c5189478e6bafa1cc76423f06c88f2 (write hit shared blocks in place)
> > >    Silence is golden
> > > 
> > > This test clones a file so that both share extents, swaps the clone
> > > against a sparse donor with FILE1_WRITTEN, and then checks the defect
> > > twice.  First it inspects the inodes directly with xfs_db: the clone
> > > must still be flagged reflink after the exchange (the donor carrying
> > > the flag too is the conservative outcome of the fix and is harmless).
> > > Then it writes to the clone and verifies after a mount cycle that the
> > > original file's data is intact, i.e. the write was redirected through
> > > CoW.
> > > 
> > > The kernel fix "xfs: fix exchange-range reflink flag clearing issue
> > > with INO1_WRITTEN" refuses the reflink flag exchange whenever
> > 
> > So this patch/case uncovers a known bug which is fixed by:
> >    "xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN" ?
> > 
> > If so please add:
> >    _fixed_by_fs_commit xfs xxxxxxxxxxxx \
> >          "xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN"
> > 
> > > FILE1_WRITTEN is requested, which makes this test pass.
> > > 
> > > Reported-by: Lin Jiapeng(TencentOS Red Team) <jiapenglin@tencent.com>
> > > Link: https://lore.kernel.org/r/amgekiNKKoAdACnc@infradead.org
> > > Suggested-by: Christoph Hellwig <hch@lst.de>
> > > Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> > > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > > Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
> > > ---
> > >   tests/xfs/842     | 65 +++++++++++++++++++++++++++++++++++++++++++++++
> > >   tests/xfs/842.out |  4 +++
> > >   2 files changed, 69 insertions(+)
> > >   create mode 100755 tests/xfs/842
> > >   create mode 100644 tests/xfs/842.out
> > > 
> > > diff --git a/tests/xfs/842 b/tests/xfs/842
> > > new file mode 100755
> > > index 0000000..c4c2be9
> > > --- /dev/null
> > > +++ b/tests/xfs/842
> > > @@ -0,0 +1,65 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0-or-later
> > > +# Copyright (c) 2026 Tencent.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 842
> > > +#
> > > +# Make sure that a full-file exchangerange under FILE1_WRITTEN does not strip
> > > +# the reflink flag from a file that still owns shared extents.  When the
> > > +# donor file is fully sparse, every mapping pair is skipped, so no extents
> > > +# actually move; the target file must keep its reflink flag, and a later
> > > +# write must go through CoW instead of modifying the shared blocks in place.
> > > +
> > > +. ./common/preamble
> > > +_begin_fstest auto quick fiexchange
> > > +
> > > +# Import common functions.
> > > +. ./common/filter
> > > +. ./common/reflink
> > > +
> > > +_require_xfs_io_command exchangerange
> > > +_require_scratch_reflink
> > > +_require_scratch
> > 
> > _require_scratch_reflink contains _require_scratch, so you can save the
> > _require_scratch.
> > 
> > > +
> > > +_scratch_mkfs >> $seqres.full
> > > +_scratch_mount
> > > +
> > > +# Create the original file with a known pattern and clone it, so that both
> > > +# files share the same extents.
> > > +_pwrite_byte 0x41 0 1m $SCRATCH_MNT/orig >> $seqres.full
> > > +_reflink $SCRATCH_MNT/orig $SCRATCH_MNT/clone >> $seqres.full
> > > +
> > > +# Create a fully sparse donor file of the same size.
> > > +$XFS_IO_PROG -f -c 'truncate 1m' $SCRATCH_MNT/donor
> > > +
> > > +md5_before=$(md5sum $SCRATCH_MNT/orig | awk '{print $1}')
> > > +
> > > +# Swap the clone against the sparse donor, claiming the donor is fully
> > > +# written (-w).  Every donor mapping is a hole, so all pairs are skipped
> > > +# and the clone keeps its shared extents in place.
> > > +$XFS_IO_PROG -c "exchangerange -f -w $SCRATCH_MNT/donor" $SCRATCH_MNT/clone \
> > > +	>> $seqres.full
> > > +
> > > +# Directly confirm the inode flag state after the exchange: the clone
> > > +# must still be flagged reflink.  The donor may also carry the flag, which
> > > +# is the conservative outcome of refusing the flag exchange under
> > > +# FILE1_WRITTEN; the extra flag is harmless and can be dropped later by
> > > +# the regular reflink flag cleanup path.
> > > +_scratch_unmount
> > > +_scratch_xfs_db -c "path /clone" -c print -c "path /donor" -c print | \
> > > +	grep reflink | sed -e 's/^v[0-9]*/vX/g'
> > > +_scratch_mount
> > > +
> > > +# Overwrite part of the clone.  With the reflink flag correctly retained,
> > > +# this must go through CoW and leave the shared blocks of orig untouched.
> > > +_pwrite_byte 0x42 0 64k $SCRATCH_MNT/clone >> $seqres.full
> > > +_scratch_cycle_mount
> > > +
> > > +md5_after=$(md5sum $SCRATCH_MNT/orig | awk '{print $1}')
> > > +
> > > +test "$md5_before" != "$md5_after" && \
> > > +	echo "orig changed: md5 $md5_before -> $md5_after (write hit shared blocks in place)"
> > > +
> > > +echo Silence is golden
> > 
> > This case has expected output, so it's not "Silence is golden",
> > please remove this line.
> > 
> > > +status=0
> > > +exit
> > 
> > I remember we've changed xfstests/new script, it should give "_exit 0" at here.
> > 
> > Thanks,
> > Zorro
> > 
> > > diff --git a/tests/xfs/842.out b/tests/xfs/842.out
> > > new file mode 100644
> > > index 0000000..1e6345a
> > > --- /dev/null
> > > +++ b/tests/xfs/842.out
> > > @@ -0,0 +1,4 @@
> > > +QA output created by 842
> > > +vX.reflink = 1
> > > +vX.reflink = 1
> > > +Silence is golden
> > > -- 
> > > 2.50.1 (Apple Git-155)
> > > 
> 
> Thanks a lot for your review!
> 
> Yes, this test case uncovers the bug fixed by "xfs: fix exchange-range
> reflink flag clearing issue with INO1_WRITTEN". However, that fix is still
> under review on linux-xfs and has not landed in for-next / xfs-7.2-fixes

Generally, we don't merge a test case before its corresponding kernel patch
is guaranteed to be merged. However, given that Darrick has already acked
this patch, I feel like that xfs fix has strong backing, so merging this
test case now should be fine.

> yet, so there is no stable commit ID to reference. I will add the
> _fixed_by_fs_commit annotation as soon as the fix is merged.

Thanks, actually we can write:

_fixed_by_fs_commit xfs xxxxxxxxxxxx
    "xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN"

Before the fix is officially merged into mainline Linux, "xxxx..." can serve
as a placeholder for the commit ID to remind us to update it later.

Don't need one more patch, I'll help to add that it when I merge your v4,
please feel free to update it after that fix is merged.

Thanks,
Zorro

> 
> The other comments will be addressed in v4.
> 
> Lin Jiapeng
> 
> 
