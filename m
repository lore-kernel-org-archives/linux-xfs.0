Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835821C10;
	Wed, 28 Feb 2024 01:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709084174; cv=none; b=OcRXJdVGJl+yo5y/x90VL9WFpcXU4Zk1azPSBI+dWZvX3tknJcWOl8E2A1YBN9dTwrXq8z+A4gtn3yVtqWrGKhMJkRLpFELzMuLLgs/5AQbaFMWnjjNOZewA9OhuN2KaB0ts/H3yl4rrlKfGB6odyLgqUUXIlPOjflHIyarQWqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709084174; c=relaxed/simple;
	bh=fxOrSTygOa4rFTh6gOYci9DPOUjMqg6tIFEGag6in44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e+kptUTtreb0CrHVsNlTePqolRjZaGKVjJwB8rCiHQqUEKGCAxobq8HhIQsGLBnfVuGwyi9oMvMNgwZO2gUnIbhEZuAq0Lwln7HJOkwpzbPezsmUUspp1zh1+ZrmAkk8X/cnkLJddG/XTequQTI3/fcTyszvO+1sn+6SA3Dh/qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QccrZZX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QccrZZX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA51C433C7;
	Wed, 28 Feb 2024 01:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709084174;
	bh=fxOrSTygOa4rFTh6gOYci9DPOUjMqg6tIFEGag6in44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QccrZZX64WMDEjTHo6YWT+JbgiOXJ1c61xZnTOQ7N5sQhyCAhrrZzPP8zqDhwB+L/
	 YazhHKYkbywydU3F00n67mciRqHq416JHiT3Ub6WfHBxo06qe0jVIE2eWtoa/mo+zr
	 7HlopDl4iSLAbaX2X/G/J5hK7HPE7w07occaKw1HL5vUliqBwGbQyHC6M6mRM8/UBf
	 lmj0xlHt5LdjKKs5BtvMu2enECuAonNQiGj+xvAWJlY9QvQQhE4CLYvz2thq6P6lCB
	 b2fqqdaoSEj4jOYPlbMy69aQ8s2Jh8JKLC+u6ga3a31zPJcoO2JsAdqLCeUb8xy2QP
	 coCJ03zNlJbrw==
Date: Tue, 27 Feb 2024 17:36:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: test for premature ENOSPC with large cow
 delalloc extents
Message-ID: <20240228013613.GW6188@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915333.896550.18395785595853879309.stgit@frogsfrogsfrogs>
 <20240227060021.5hcpvn2ar5xsup6d@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227060021.5hcpvn2ar5xsup6d@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Tue, Feb 27, 2024 at 02:00:21PM +0800, Zorro Lang wrote:
> On Mon, Feb 26, 2024 at 06:02:37PM -0800, Darrick J. Wong wrote:
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
> >  common/rc          |   14 +++++++++
> >  tests/xfs/1923     |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/1923.out |    8 +++++
> >  3 files changed, 107 insertions(+)
> >  create mode 100755 tests/xfs/1923
> >  create mode 100644 tests/xfs/1923.out
> > 
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
> 
> I'm wondering if it's a 100% reliable way to get the "delalloc" flag when
> the delalloc is supported? If not, is it worth testing with several files
> or a loop, then return 0 if one of them get delalloc ?
> 
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
> > index 0000000000..4e494ad8c2
> > --- /dev/null
> > +++ b/tests/xfs/1923
> > @@ -0,0 +1,85 @@
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
> > +_fixed_by_kernel_commit XXXXX \
> > +	"xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork"
> 
> Is it this commit below, or a new fix with same subject?
> 
> commit d62113303d691bcd8d0675ae4ac63e7769afc56c
> Author: Chandan Babu R <chandan.babu@oracle.com>
> Date:   Thu Aug 4 08:59:27 2022 -0700
> 
>     xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork
> 
> If it's an old commit, please replace the "XXXXX" to "d62113303d69".

Ah, yes, it is that one.  Sorry I forgot to update that.  As you can
tell, this is a really old test that ... I guess we never sent
upstream.

> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> 
> "xfs"? As it's in tests/xfs/ directory.

<nod>

> > +_require_test_program "punch-alternating"
> > +_require_test_reflink
> > +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> > +_require_test_delalloc
> > +
> > +file1=$TEST_DIR/file1.$seq
> > +file2=$TEST_DIR/file2.$seq
> > +fragmentedfile=$TEST_DIR/fragmentedfile.$seq
> 
> As you use the $TEST_DIR, it might be worth making sure these files
> aren't existed. Due to the files (from other cases) in $TEST_DIR might
> not be cleaned, especially if they don't take much free space.

Ok.

> So if these 3 files won't take much space, we can keep them, don't need
> a specific _cleanup(). And move the "rm -f $file1 $file2 $fragmentedfile"
> at here.

Well you make a good point that we should remove those files so that
they end up in a known state (i.e. nonexistence) where we can't get
tripped up by someone creating, say, a /dev/sda symlink to
$TEST_DIR/file1.$seq.

I don't think the files are all that big, but I'll continue removing
them anyway.  Deletion is part of aging.

> > +
> > +# COW operates on pages, so we must not perform operations in units smaller
> > +# than a page.
> > +blksz=$(_get_file_block_size $TEST_DIR)
> > +pagesz=$(_get_page_size)
> > +if (( $blksz < $pagesz )); then
> > +	blksz=$pagesz
> > +fi
> 
> Just curious, this's a xfs specific test case, can xfs support blocksize >
> pagesize? If not, can we just use pagesz directly at here ?

It doesn't support bs > ps yet, but the point of clamping $blksz here
is the fact that we'll never try to writeback less than a page, so we
might as well run with those units.

(This test has nothing to do with the ongoing bs>ps effort.)

> > +
> > +echo "Create source file"
> > +$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 256))" $file1 >> $seqres.full
> > +
> > +sync
> > +
> > +echo "Create Reflinked file"
> > +_cp_reflink $file1 $file2 >> $seqres.full
> > +#$XFS_IO_PROG -f -c "reflink $file1" $file2 >> $seqres.full
> 
> There's a "#", do you hope to run it or not?

Oops.  That's redundant with the _cp_reflink.

--D

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
