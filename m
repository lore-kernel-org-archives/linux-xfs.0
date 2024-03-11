Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883B1446D2;
	Mon, 11 Mar 2024 15:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710169495; cv=none; b=QQC6/ftfOzkGgFlmxZ4dQT3RhFOwgNULDKIrvf6vydBdLcoup+dNuyq1QB2/IQ3FEPAPqJqqYoYXbFAJ07IjRgr8CjD9CX4AvNkX/AnHUeK62k5uUV4DR1I0ntp3a5aEEyqhz59EmLKu3yLe75f/wv7HBH0K/z4oAxXwJrVwccM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710169495; c=relaxed/simple;
	bh=toyq8dgHTXTBIQy1+EkMWGa5wD0w+lhyiKrdO94wsac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YMYAN+Gs0IZSIoMkPLzSQENcPyBRYcE9kJm4ySiCEYTlrBlGol00GtEigEPe30CkN6kl/mpJmYgKwKCpXfSY5a36/UsSDrmUWVtyOCwtpPm+yKPUy0O7OposoQ0cX5wG1RVFSO0W2gHqWiQ4UktvMPOSIsXfp9RkGZrwYLQvS/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S188yjmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S188yjmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1BDC433A6;
	Mon, 11 Mar 2024 15:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710169495;
	bh=toyq8dgHTXTBIQy1+EkMWGa5wD0w+lhyiKrdO94wsac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S188yjmtLk6hTsGlyWbty5vYWJALwJF23tYcvLHL/vjS2xH5A6zUotXzNErk0vdYC
	 O0jehoNGpOosTPXHKN6RigxLmJGMIKvNl3kXrbWSNrWCXwk7LqAfpH+7bb67ySi33T
	 NUBLqZkU/WVQQfg1MFXb5vyRsahizbDoJR7azeoygroCoKDNuRANbLr16sdJxK6ZFJ
	 wbVXP/lceHF0Zdgl8NMzhGbExlUFv5HLdyOH843wTB+cl4291K5OTHC2TCyrTa9gEv
	 +aGcopDCBQnElyGXnUtmdhoylOtOLKfYBX3R/am7i3I9aAtlD2+Ymfd3cKqw++AxWL
	 Vmh1NaGnGmj1Q==
Date: Mon, 11 Mar 2024 08:04:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v1.2 8/8] xfs: test for premature ENOSPC with large cow
 delalloc extents
Message-ID: <20240311150454.GC6188@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915333.896550.18395785595853879309.stgit@frogsfrogsfrogs>
 <20240307232255.GG1927156@frogsfrogsfrogs>
 <20240310091734.hn3twqri6cdgtxaf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240310162654.GB6226@frogsfrogsfrogs>
 <20240311134001.6qflb7gjyjnwwetr@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240311134001.6qflb7gjyjnwwetr@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Mon, Mar 11, 2024 at 09:40:01PM +0800, Zorro Lang wrote:
> On Sun, Mar 10, 2024 at 09:26:54AM -0700, Darrick J. Wong wrote:
> > On Sun, Mar 10, 2024 at 05:17:34PM +0800, Zorro Lang wrote:
> > > On Thu, Mar 07, 2024 at 03:22:55PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > On a higly fragmented filesystem a Direct IO write can fail with -ENOSPC error
> > > > even though the filesystem has sufficient number of free blocks.
> > > > 
> > > > This occurs if the file offset range on which the write operation is being
> > > > performed has a delalloc extent in the cow fork and this delalloc extent
> > > > begins much before the Direct IO range.
> > > > 
> > > > In such a scenario, xfs_reflink_allocate_cow() invokes xfs_bmapi_write() to
> > > > allocate the blocks mapped by the delalloc extent. The extent thus allocated
> > > > may not cover the beginning of file offset range on which the Direct IO write
> > > > was issued. Hence xfs_reflink_allocate_cow() ends up returning -ENOSPC.
> > > > 
> > > > This test addresses this issue.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > > v1.1: address some missing bits and remove extraneous code
> > > > v1.2: fix cow fork dumping screwing up golden output
> > > 
> > > This version is good to me, I'll merge it.
> > > 
> > > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > > 
> > > BTW, I only see this patch for [PATCH 8/8], but I didn't see the "later" patch
> > > for [PATCH 6/8], just to make sure if I missed something :)
> > 
> > Oh!  Yeah, on re-reading that thread, I remembered that Christoph said
> > he'd look into making xfs_ondisk.h check ioctl structure sizes like
> > xfs/122 currently does.
> > 
> > In the meantime, there weren't any changes other than your RVB tag.  If
> > you want, I can resend it with that added.
> 
> Oh, if that patch don't need to be changed, I'll merge it directly, don't
> need resending it :)

That's correct -- the patch itself doesn't need changes, but the test
itself may get removed some day.

--D

> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > > ---
> > > >  common/rc          |   14 ++++++++
> > > >  tests/xfs/1923     |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/1923.out |    8 +++++
> > > >  3 files changed, 108 insertions(+)
> > > >  create mode 100755 tests/xfs/1923
> > > >  create mode 100644 tests/xfs/1923.out
> > > > 
> > > > diff --git a/common/rc b/common/rc
> > > > index 50dde313b8..9f54ab1e77 100644
> > > > --- a/common/rc
> > > > +++ b/common/rc
> > > > @@ -1883,6 +1883,20 @@ _require_scratch_delalloc()
> > > >  	_scratch_unmount
> > > >  }
> > > >  
> > > > +# Require test fs supports delay allocation.
> > > > +_require_test_delalloc()
> > > > +{
> > > > +	_require_command "$FILEFRAG_PROG" filefrag
> > > > +
> > > > +	rm -f $TEST_DIR/testy
> > > > +	$XFS_IO_PROG -f -c 'pwrite 0 64k' $TEST_DIR/testy &> /dev/null
> > > > +	$FILEFRAG_PROG -v $TEST_DIR/testy 2>&1 | grep -q delalloc
> > > > +	res=$?
> > > > +	rm -f $TEST_DIR/testy
> > > > +	test $res -eq 0 || \
> > > > +		_notrun "test requires delayed allocation buffered writes"
> > > > +}
> > > > +
> > > >  # this test needs a test partition - check we're ok & mount it
> > > >  #
> > > >  _require_test()
> > > > diff --git a/tests/xfs/1923 b/tests/xfs/1923
> > > > new file mode 100755
> > > > index 0000000000..4ad3dfa764
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1923
> > > > @@ -0,0 +1,86 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. 1923
> > > > +#
> > > > +# This is a regression test for "xfs: Fix false ENOSPC when performing direct
> > > > +# write on a delalloc extent in cow fork".  If there is a lot of free space but
> > > > +# it is very fragmented, it's possible that a very large delalloc reservation
> > > > +# could be created in the CoW fork by a buffered write.  If a directio write
> > > > +# tries to convert the delalloc reservation to a real extent, it's possible
> > > > +# that the allocation will succeed but fail to convert even the first block of
> > > > +# the directio write range.  In this case, XFS will return ENOSPC even though
> > > > +# all it needed to do was to keep converting until the allocator returns ENOSPC
> > > > +# or the first block of the direct write got some space.
> > > > +#
> > > > +. ./common/preamble
> > > > +_begin_fstest auto quick clone
> > > > +
> > > > +_cleanup()
> > > > +{
> > > > +	cd /
> > > > +	rm -f $file1 $file2 $fragmentedfile
> > > > +}
> > > > +
> > > > +# Import common functions.
> > > > +. ./common/reflink
> > > > +. ./common/inject
> > > > +
> > > > +# real QA test starts here
> > > > +_fixed_by_kernel_commit d62113303d69 \
> > > > +	"xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork"
> > > > +
> > > > +# Modify as appropriate.
> > > > +_supported_fs xfs
> > > > +_require_test_program "punch-alternating"
> > > > +_require_test_reflink
> > > > +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> > > > +_require_test_delalloc
> > > > +
> > > > +file1=$TEST_DIR/file1.$seq
> > > > +file2=$TEST_DIR/file2.$seq
> > > > +fragmentedfile=$TEST_DIR/fragmentedfile.$seq
> > > > +
> > > > +rm -f $file1 $file2 $fragmentedfile
> > > > +
> > > > +# COW operates on pages, so we must not perform operations in units smaller
> > > > +# than a page.
> > > > +blksz=$(_get_file_block_size $TEST_DIR)
> > > > +pagesz=$(_get_page_size)
> > > > +if (( $blksz < $pagesz )); then
> > > > +	blksz=$pagesz
> > > > +fi
> > > > +
> > > > +echo "Create source file"
> > > > +$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 256))" $file1 >> $seqres.full
> > > > +
> > > > +sync
> > > > +
> > > > +echo "Create Reflinked file"
> > > > +_cp_reflink $file1 $file2 >> $seqres.full
> > > > +
> > > > +echo "Set cowextsize"
> > > > +$XFS_IO_PROG -c "cowextsize $((blksz * 128))" -c stat $file1 >> $seqres.full
> > > > +
> > > > +echo "Fragment FS"
> > > > +$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 512))" $fragmentedfile >> $seqres.full
> > > > +sync
> > > > +$here/src/punch-alternating $fragmentedfile
> > > > +
> > > > +echo "Allocate block sized extent from now onwards"
> > > > +_test_inject_error bmap_alloc_minlen_extent 1
> > > > +
> > > > +echo "Create big delalloc extent in CoW fork"
> > > > +$XFS_IO_PROG -c "pwrite 0 $blksz" $file1 >> $seqres.full
> > > > +
> > > > +sync
> > > > +
> > > > +$XFS_IO_PROG -c 'bmap -elpv' -c 'bmap -celpv' $file1 &>> $seqres.full
> > > > +
> > > > +echo "Direct I/O write at offset 3FSB"
> > > > +$XFS_IO_PROG -d -c "pwrite $((blksz * 3)) $((blksz * 2))" $file1 >> $seqres.full
> > > > +
> > > > +# success, all done
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/xfs/1923.out b/tests/xfs/1923.out
> > > > new file mode 100644
> > > > index 0000000000..a0553cf3ee
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1923.out
> > > > @@ -0,0 +1,8 @@
> > > > +QA output created by 1923
> > > > +Create source file
> > > > +Create Reflinked file
> > > > +Set cowextsize
> > > > +Fragment FS
> > > > +Allocate block sized extent from now onwards
> > > > +Create big delalloc extent in CoW fork
> > > > +Direct I/O write at offset 3FSB
> > > > 
> > > 
> > 
> 
> 
