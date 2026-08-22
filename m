Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1363C33F5A5;
	Sat, 22 Aug 2026 17:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787418770; cv=none; b=nBQhEwuKsfdd9tPSk+ZdMgWtdW9GQWbVKrcWL8OxqpT7wN6YLFFS4ydnvB56uxNRC3ihPjfr5vKvS1ROVaPFa8hk4M/rVbC2D6Ni4D2r4eiD1PW6CgMjkqIRcpW728ICertcxnfHkYMx1ZqQsBkCvP4xNcIuqjDpvoGBE+RzaTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787418770; c=relaxed/simple;
	bh=5zt/tVmAMsdWbvQSaLi2w5/PGwvHo6C3ydqX40WFSHw=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Epc//xbbampur6mx9ygQ1ELHC6/t5IvxyC6gGvAErCyslwmVa77whYwPjgRZ6LffM3ylVQOJWLlwq+03R6QI0nwO3eNVtc+Rs50ljumT8San7QgCYLctyUD2hvje2iqetYTLKN0RLHxTbEholuW0oySva8WJ1+5U8npHDWLdZPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gbKUcw/B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gbKUcw/B"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5431E1F000E9;
	Sat, 22 Aug 2026 17:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787418767;
	bh=Z0ozkO/7kIOKySHdAg7HpVbbcF6htLUUaAifrtnFqjs=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=gbKUcw/B+PH7thwDVoN08tfjOTPeW0hT17Wf+nYqLUk2oRylM48YCp6is55WdnLuK
	 MxnD416cdQtkpY9OIbc64Di3oV0YlaXt/bOHaZsIpdagp+Ow+5RXH0wz0Kjowrnptd
	 mmWuNKsTSiobXgGRlPWS6e65TGqNjmSTCPODbiGJIZTZFLIgcG4T2po8hGS64nrSut
	 P9SXlxj4i4jCXvedDsuNx2bPPk1WMVz1tG2OnY5GaDX6GNVj27rIB55D9wV2BUcEE9
	 2EYBxPGT+UHBkaG3iGzStBWWdQ4z+HGfSbECA9B4P3HRky9epe1sR5p6SzYXbbCxHn
	 8CDG3SI9Z1UhA==
Date: Sat, 22 Aug 2026 10:12:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	ljp1205831794@gmail.com
Subject: Re: [PATCH] xfs: test reflux with exchange-range
Message-ID: <20260822171246.GB6110@frogsfrogsfrogs>
References: <20260819155121.GA839663@frogsfrogsfrogs>
 <aolYPXE0VupxrUEO@zlang-mailbox>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aolYPXE0VupxrUEO@zlang-mailbox>

On Sat, Aug 22, 2026 at 04:13:11PM +0800, Zorro Lang wrote:
> On Wed, Aug 19, 2026 at 08:51:21AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Regression test for the XFS_IOC_EXCHRANGE flag INO1_WRITTEN clearing
> > reflink flags when that shouldn't happen.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  tests/generic/1957     |   72 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/1957.out |   16 +++++++++++
> >  2 files changed, 88 insertions(+)
> >  create mode 100755 tests/generic/1957
> >  create mode 100644 tests/generic/1957.out
> > 
> > diff --git a/tests/generic/1957 b/tests/generic/1957
> > new file mode 100755
> > index 00000000000000..bb039771970d15
> > --- /dev/null
> > +++ b/tests/generic/1957
> > @@ -0,0 +1,72 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 1957
> > +#
> > +# Regression test for refluxfs, which is an exploit for a race condition in
> > +# XFS' directio copy-on-write code that can be used to rewrite shared blocks
> > +# to gain root privileges.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick fiexchange
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -r -f $tmp.*
> > +	test -n "$dummydir" && rm -r -f "$dummydir"
> 
> Hmm... what's the $dummydir?
> 
> > +}
> > +
> > +. ./common/filter
> > +. ./common/reflink
> > +
> > +_require_scratch_reflink
> > +_require_xfs_io_command exchangerange
> 
> OK, if a filesystem supports reflink and exchange-range, it definitely
> supports truncate I think.
> 
> This patch is good enough, just not sure what's that "$dummydir". With
> the definition of dummydir clarified:

Eh, it's just copy-pasta garbage.  I'll post a v3.

--D

> Reviewed-by: Zorro Lang <zlang@kernel.org>
> 
> > +_require_cp_reflink
> > +
> > +_fixed_by_fs_commit xfs XXXXXXXXXXXXXX \
> > +	"xfs: fix exchange-range reflink flag clearing issue with  INO1_WRITTEN"
> > +
> > +_scratch_mkfs >> $seqres.full
> > +_scratch_mount
> > +
> > +# Create file1 as a fully written file, and file2 as a sparse file with one
> > +# written area.
> > +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 1m" $SCRATCH_MNT/file1 >> $seqres.full
> > +$XFS_IO_PROG -f -c "truncate 1m" -c "pwrite -S 0x59 64k 64k" $SCRATCH_MNT/file2 >> $seqres.full
> > +
> > +_scratch_unmount
> > +_scratch_xfs_db -c "path /file1" -c 'print' -c "path /file2" -c 'print' | grep reflink
> > +_scratch_mount
> > +
> > +# Reflink file1 so that the reflink flag gets set
> > +_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/fileC
> > +
> > +md5sum $SCRATCH_MNT/file1 $SCRATCH_MNT/file2 $SCRATCH_MNT/fileC | _filter_scratch
> > +
> > +# Exchange the written parts of file2 with file1, but only file1 has the
> > +# reflink flag set.
> > +$XFS_IO_PROG -c "exchangerange -w $SCRATCH_MNT/file2" $SCRATCH_MNT/file1 >> $seqres.full
> > +
> > +# Check reflink flags
> > +_scratch_unmount
> > +_scratch_xfs_db -c "path /file1" -c 'print' -c "path /file2" -c 'print' | grep reflink
> > +_scratch_mount
> > +
> > +# Record content and layout
> > +md5sum $SCRATCH_MNT/file1 $SCRATCH_MNT/file2 $SCRATCH_MNT/fileC | _filter_scratch
> > +$XFS_IO_PROG -c 'bmap -vvvvvvvv' $SCRATCH_MNT/file[12C] >> $seqres.full
> > +
> > +# Write a single byte to file1, does that get echoed in fileC?
> > +$XFS_IO_PROG -c 'pwrite -S 0x59 0 1' $SCRATCH_MNT/file1 >> $seqres.full
> > +#
> > +# Check reflink flags
> > +_scratch_unmount
> > +_scratch_xfs_db -c "path /file1" -c 'print' -c "path /file2" -c 'print' | grep reflink
> > +_scratch_mount
> > +
> > +md5sum $SCRATCH_MNT/file1 $SCRATCH_MNT/file2 $SCRATCH_MNT/fileC | _filter_scratch
> > +$XFS_IO_PROG -c 'bmap -vvvvvvvv' $SCRATCH_MNT/file[12C] >> $seqres.full
> > +
> > +_exit 0
> > diff --git a/tests/generic/1957.out b/tests/generic/1957.out
> > new file mode 100644
> > index 00000000000000..7d64ea0e2c372d
> > --- /dev/null
> > +++ b/tests/generic/1957.out
> > @@ -0,0 +1,16 @@
> > +QA output created by 1957
> > +v3.reflink = 0
> > +v3.reflink = 0
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/file1
> > +e6ee47dca6e786a44ae5b912be870d96  SCRATCH_MNT/file2
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/fileC
> > +v3.reflink = 1
> > +v3.reflink = 1
> > +b630c7de58afd0ba5b8dfa24d701b5b8  SCRATCH_MNT/file1
> > +18cc9868973139a0bb558e09802a51b6  SCRATCH_MNT/file2
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/fileC
> > +v3.reflink = 1
> > +v3.reflink = 1
> > +82b27c6f1b1de8fba44a911af80d9a7a  SCRATCH_MNT/file1
> > +18cc9868973139a0bb558e09802a51b6  SCRATCH_MNT/file2
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/fileC
