Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57325339BF;
	Thu,  7 Mar 2024 23:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709853469; cv=none; b=TEX0W+KYgSb7HNDAynVR/n3941v1MRHTIgB7nh/elu0Ve6tFqAnXQFLHa8VVcrLwFxyAUoxJx/ekqV1O3oF/gaBhiYZDRiCp1BlB3rCheXk77ie5cxR9Jpm1grI4AxlZrSi2uuUmkncoVxPcMMbFPOQgO3Gs1noyfLHyumUieVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709853469; c=relaxed/simple;
	bh=bWtbE5gm88lFI6iVlchHoyZVNppdW+bGltTULtpI0ec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LqrfaIXqSnN6Qbc8cfB1aGK2NYr7XODNv3WhzM2mpEc8FXYJLfD3NU/sV5C1/fIqjw9eK6lDpirmYnLh3ijxUNKKs0qugS07uvZKgbu6plKnE0S8vpzFdzA8CtYoVsQLT4WXL+xqSCrPKG+BWipdOE19JkJF19r68CcOjirrnQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CtC2q5ix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CtC2q5ix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4C6C433C7;
	Thu,  7 Mar 2024 23:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709853468;
	bh=bWtbE5gm88lFI6iVlchHoyZVNppdW+bGltTULtpI0ec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CtC2q5ixjQuo82ZkffHFSFholhnmbPOh4MAWvBVGxXfB4vTzatSMERZgkNcKVQeeX
	 Z8KMDJSz4K3ZbRSi2jfiot6gY+RfhxQst5rmM2Y6QeGuvQrVAV6EyrZERDFmmqrX+r
	 mnPnUoBSZAgI+wM2UetZNqSMvBEoJzKiNJ1+F/PU+BtF6VkZ7tjzdOUwz0x7pVdegF
	 wkRjd5Lg2SeaAZoIkHLF28ZFrjlX2M4/ZHMh4m/ukE9Y2qKt1eRdLZlsH1mp2ApMdg
	 RI0DSYZJQ7dYYPFbruW7AWdCHk7vkGEg0jVOqAt8p+W48Pn5mM6KbjmCn1p/BXZUqT
	 6MD70luBuRrkQ==
Date: Thu, 7 Mar 2024 15:17:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v1.1 8/8] xfs: test for premature ENOSPC with large cow
 delalloc extents
Message-ID: <20240307231748.GE1927156@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915333.896550.18395785595853879309.stgit@frogsfrogsfrogs>
 <20240301175202.GK1927156@frogsfrogsfrogs>
 <20240302205056.saexqlexlmwpfy4e@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240302205056.saexqlexlmwpfy4e@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sun, Mar 03, 2024 at 04:50:56AM +0800, Zorro Lang wrote:
> On Fri, Mar 01, 2024 at 09:52:02AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > On a higly fragmented filesystem a Direct IO write can fail with -ENOSPC error
> > even though the filesystem has sufficient number of free blocks.
> > 
> > This occurs if the file offset range on which the write operation is being
> > performed has a delalloc extent in the cow fork and this delalloc extent
> > begins much before the Direct IO range.
> > 
> > In such a scenario, xfs_reflink_allocate_cow() invokes xfs_bmapi_write() to
> > allocate the blocks mapped by the delalloc extent. The extent thus allocated
> > may not cover the beginning of file offset range on which the Direct IO write
> > was issued. Hence xfs_reflink_allocate_cow() ends up returning -ENOSPC.
> > 
> > This test addresses this issue.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> > v1.1: address some missing bits and remove extraneous code
> > ---
> >  common/rc          |   14 ++++++++
> >  tests/xfs/1923     |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/1923.out |    8 +++++
> >  3 files changed, 108 insertions(+)
> >  create mode 100755 tests/xfs/1923
> >  create mode 100644 tests/xfs/1923.out
> > 
> > diff --git a/common/rc b/common/rc
> > index 30c44dddd9..d3a2a0718b 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -1873,6 +1873,20 @@ _require_scratch_delalloc()
> >  	_scratch_unmount
> >  }
> >  
> > +# Require test fs supports delay allocation.
> > +_require_test_delalloc()
> > +{
> > +	_require_command "$FILEFRAG_PROG" filefrag
> > +
> > +	rm -f $TEST_DIR/testy
> > +	$XFS_IO_PROG -f -c 'pwrite 0 64k' $TEST_DIR/testy &> /dev/null
> > +	$FILEFRAG_PROG -v $TEST_DIR/testy 2>&1 | grep -q delalloc
> > +	res=$?
> > +	rm -f $TEST_DIR/testy
> > +	test $res -eq 0 || \
> > +		_notrun "test requires delayed allocation buffered writes"
> > +}
> > +
> >  # this test needs a test partition - check we're ok & mount it
> >  #
> >  _require_test()
> > diff --git a/tests/xfs/1923 b/tests/xfs/1923
> > new file mode 100755
> > index 0000000000..7068fda64c
> > --- /dev/null
> > +++ b/tests/xfs/1923
> > @@ -0,0 +1,86 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 1923
> > +#
> > +# This is a regression test for "xfs: Fix false ENOSPC when performing direct
> > +# write on a delalloc extent in cow fork".  If there is a lot of free space but
> > +# it is very fragmented, it's possible that a very large delalloc reservation
> > +# could be created in the CoW fork by a buffered write.  If a directio write
> > +# tries to convert the delalloc reservation to a real extent, it's possible
> > +# that the allocation will succeed but fail to convert even the first block of
> > +# the directio write range.  In this case, XFS will return ENOSPC even though
> > +# all it needed to do was to keep converting until the allocator returns ENOSPC
> > +# or the first block of the direct write got some space.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick clone
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $file1 $file2 $fragmentedfile
> > +}
> > +
> > +# Import common functions.
> > +. ./common/reflink
> > +. ./common/inject
> > +
> > +# real QA test starts here
> > +_fixed_by_kernel_commit d62113303d69 \
> > +	"xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork"
> > +
> > +# Modify as appropriate.
> > +_supported_fs xfs
> > +_require_test_program "punch-alternating"
> > +_require_test_reflink
> > +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> > +_require_test_delalloc
> > +
> > +file1=$TEST_DIR/file1.$seq
> > +file2=$TEST_DIR/file2.$seq
> > +fragmentedfile=$TEST_DIR/fragmentedfile.$seq
> > +
> > +rm -f $file1 $file2 $fragmentedfile
> > +
> > +# COW operates on pages, so we must not perform operations in units smaller
> > +# than a page.
> > +blksz=$(_get_file_block_size $TEST_DIR)
> > +pagesz=$(_get_page_size)
> > +if (( $blksz < $pagesz )); then
> > +	blksz=$pagesz
> > +fi
> > +
> > +echo "Create source file"
> > +$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 256))" $file1 >> $seqres.full
> > +
> > +sync
> > +
> > +echo "Create Reflinked file"
> > +_cp_reflink $file1 $file2 >> $seqres.full
> > +
> > +echo "Set cowextsize"
> > +$XFS_IO_PROG -c "cowextsize $((blksz * 128))" -c stat $file1 >> $seqres.full
> > +
> > +echo "Fragment FS"
> > +$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 512))" $fragmentedfile >> $seqres.full
> > +sync
> > +$here/src/punch-alternating $fragmentedfile
> > +
> > +echo "Allocate block sized extent from now onwards"
> > +_test_inject_error bmap_alloc_minlen_extent 1
> > +
> > +echo "Create big delalloc extent in CoW fork"
> > +$XFS_IO_PROG -c "pwrite 0 $blksz" $file1 >> $seqres.full
> > +
> > +sync
> > +
> > +$XFS_IO_PROG -c 'bmap -elpv' -c 'bmap -celpv' $file1 >> $seqres.full
> 
> The "-c" option might get:
> 
>   $ xfs_io -c "bmap -celpv" testfile 
>   xfs_io: xfsctl(XFS_IOC_GETBMAPX) iflags=0x28 ["testfile"]: Invalid argument
> 
> It will break the golden image, can we redirect stderr to $seqres.full,
> as it's just for debug? If you agree, I can help to change that by adding
> "2>&1" at the end. Or you hope to deal with it by other method?

That's fine, I don't need the stderr output.  "&>> $seqres.full" works
just as well.

--D

> Thanks,
> Zorro
> 
> 
> > +
> > +echo "Direct I/O write at offset 3FSB"
> > +$XFS_IO_PROG -d -c "pwrite $((blksz * 3)) $((blksz * 2))" $file1 >> $seqres.full
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/1923.out b/tests/xfs/1923.out
> > new file mode 100644
> > index 0000000000..a0553cf3ee
> > --- /dev/null
> > +++ b/tests/xfs/1923.out
> > @@ -0,0 +1,8 @@
> > +QA output created by 1923
> > +Create source file
> > +Create Reflinked file
> > +Set cowextsize
> > +Fragment FS
> > +Allocate block sized extent from now onwards
> > +Create big delalloc extent in CoW fork
> > +Direct I/O write at offset 3FSB
> > 
> 
> 
