Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE640381CC;
	Sat, 30 Mar 2024 15:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711812707; cv=none; b=sB6iPsHjx81ppVdIpUDktBVnCCaJ+duAqI27uZjvzSY4qwh+O7hT7SN1e6+u3yKE1tleD9UORkBxrcrZdOjcnAZKzPZLE2F3MWYuJkYu1HWET6hfpS9IEGq/RH6g5uqv57b9mTxOAxScvteovPF3NKg4KgeQ+sDrFK6FYqPiqr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711812707; c=relaxed/simple;
	bh=lBBWaVACCEXBNvvAEejfoAeohL86BY41s2TY13yzTo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C8am1dZjuiHKuA5LYeSI89/gxTLOyhEbd2tE3ZFCrMjsNs29Q7G9ysAhIWFuDtoqtE0caht1cQ6Cdx6JCTm9brfTpzlxz5zELGG500XFGcARX6NMVuZ4hvED0v0h6OBTmmJvX26avy8glVNdyBWf/2iP+Y/q6mIrFlNyt4myGPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mS6n9Z5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mS6n9Z5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F196C433C7;
	Sat, 30 Mar 2024 15:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711812707;
	bh=lBBWaVACCEXBNvvAEejfoAeohL86BY41s2TY13yzTo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mS6n9Z5Djv0cno9qfAyvxmZyEkMedtRoWXzUuxKlxBBMYUQvKxZ3kA7f1IId2JplN
	 mBEfm3aHY1qDl88kvR/P5LvIPywTov6pqHxRrQ9rOcprpmnAr8E0IvHwulucneg7UA
	 zbbUu6FpEJ/1SbJGjZNFYKbYDmqvrVX+q69zVoabmFPbBHLaXP/qO6MFkkoO3C+7xv
	 jAf9msaZltG60q+6ETWtXf9mNcVo86Bf5jsbUfXWoR4oFI2TouRlBWhLqxxkNqIMa3
	 7bFhF2ObNeJVzS4Eak4i5uz/w0HqefYGSnv5DRL8iSGivjvgy6Yr8zjDLtJTgZCs2f
	 PaDUfpSuMBHgA==
Date: Sat, 30 Mar 2024 08:31:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, Christoph Hellwig <hch@lst.de>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] generic: test MADV_POPULATE_READ with IO errors
Message-ID: <20240330153146.GU6390@frogsfrogsfrogs>
References: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
 <171150742156.3286541.2986329968568619601.stgit@frogsfrogsfrogs>
 <20240330071200.jmljkdyccwgdzmej@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240330071200.jmljkdyccwgdzmej@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Mar 30, 2024 at 03:12:00PM +0800, Zorro Lang wrote:
> On Tue, Mar 26, 2024 at 07:43:41PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This is a regression test for "mm/madvise: make
> > MADV_POPULATE_(READ|WRITE) handle VM_FAULT_RETRY properly".
> > 
> > Cc: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  tests/generic/1835     |   65 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/1835.out |    4 +++
> >  2 files changed, 69 insertions(+)
> >  create mode 100755 tests/generic/1835
> >  create mode 100644 tests/generic/1835.out
> > 
> > 
> > diff --git a/tests/generic/1835 b/tests/generic/1835
> > new file mode 100755
> > index 0000000000..07479ab712
> > --- /dev/null
> > +++ b/tests/generic/1835
> > @@ -0,0 +1,65 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 1835
> > +#
> > +# This is a regression test for a kernel hang that I saw when creating a memory
> > +# mapping, injecting EIO errors on the block device, and invoking
> > +# MADV_POPULATE_READ on the mapping to fault in the pages.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto rw
>                          ^^ eio
> 
> > +
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +	_dmerror_unmount
> > +	_dmerror_cleanup
> > +}
> > +
> > +# Import common functions.
> > +. ./common/dmerror
> > +
> > +_fixed_by_kernel_commit XXXXXXXXXXXX \
> > +	"mm/madvise: make MADV_POPULATE_(READ|WRITE) handle VM_FAULT_RETRY properly"
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_require_xfs_io_command madvise -R
> > +_require_scratch
> > +_require_dm_target error
> > +_require_command "$TIMEOUT_PROG" "timeout"
> > +
> > +_scratch_mkfs >> $seqres.full 2>&1
> > +_dmerror_init
> > +
> > +filesz=2m
> > +
> > +# Create a file that we'll read, then cycle mount to zap pagecache
> > +_dmerror_mount
> > +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $filesz" "$SCRATCH_MNT/a" >> $seqres.full
> > +_dmerror_unmount
> > +_dmerror_mount
> > +
> > +# Try to read the file data in a regular fashion just to prove that it works.
> > +echo read with no errors
> > +timeout -s KILL 10s $XFS_IO_PROG -c "mmap -r 0 $filesz" -c "madvise -R 0 $filesz" "$SCRATCH_MNT/a"
> 
> timeout -> $TIMEOUT_PROG
> 
> Others looks good to me, if there's not more review points, I'll merge this
> patch with above changes, after testing done.

Ok.  I don't have any further changes to make to this test, other than
the XXXXX above whenever the fixes get merged.

--D

> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> Thanks,
> Zorro
> 
> > +_dmerror_unmount
> > +_dmerror_mount
> > +
> > +# Load file metadata and induce EIO errors on read.  Try to provoke the kernel;
> > +# kill the process after 10s so we can clean up.
> > +stat "$SCRATCH_MNT/a" >> $seqres.full
> > +echo read with IO errors
> > +_dmerror_load_error_table
> > +timeout -s KILL 10s $XFS_IO_PROG -c "mmap -r 0 $filesz" -c "madvise -R 0 $filesz" "$SCRATCH_MNT/a"
> > +_dmerror_load_working_table
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/1835.out b/tests/generic/1835.out
> > new file mode 100644
> > index 0000000000..1b03586e8c
> > --- /dev/null
> > +++ b/tests/generic/1835.out
> > @@ -0,0 +1,4 @@
> > +QA output created by 1835
> > +read with no errors
> > +read with IO errors
> > +madvise: Bad address
> > 
> 
> 
