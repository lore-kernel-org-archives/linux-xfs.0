Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8238F14010
	for <linux-xfs@vger.kernel.org>; Sat,  2 Mar 2024 20:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709412669; cv=none; b=CrHdEOkTEUaQGaNOqbV2o6NP9U+5QqGx2s2zrNxlNBcPDO7zW9xeO1ERywTWixFtGQ8Tp9fiboj8kfc/97HAtasJu/m1I8C8TCq6SYN9iXdjgXnKx6uT1uTjVSBuCJw5PlRoJk+pcRat68VfYiCmFSnZXyEn/aPth7ExXPQdck0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709412669; c=relaxed/simple;
	bh=BVrw5LhkTYuopDPUL6smrZOomjBsxOCbR2f5PIrP4PA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JMBuuyjliG3gX7aHaboPvzcmjMmHxjfsy/i7xh0ED2quwrfDRryyPo84coELT24/2pH+k4h0rK2vb2Azvvp4JftLgTUBYXO34y1FSRMaYm5eEqEdfh5ns8Sf24chTYp6Xqu71/A3vp1IaLRC8Sx8IhXtXrJHHgKbO0Vu4z6c938=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N8CU7PSC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N8CU7PSC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709412665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NiyWFGpgIt47rDjjJWLUKS580snu9a6YNBj3glQK/HI=;
	b=N8CU7PSCtgbWt1A/zuViruyQWDgIq4k3SuQhm/RCQWtUSFbmH9weO6tLKuMkzSfQpbHWp8
	cuIMdI2pnUuEffegK0m5hOOPGnvFXPuim1FGnDAooKZcwgrOgM4+HcX+RVvHfL2BCblWHs
	NscIMNOGz+zCqpjeV+LWMWUNZc5P/Nc=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-7P0ZRgOSNyWZ9085B8cF9A-1; Sat, 02 Mar 2024 15:51:03 -0500
X-MC-Unique: 7P0ZRgOSNyWZ9085B8cF9A-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-21e7751f76fso3921243fac.2
        for <linux-xfs@vger.kernel.org>; Sat, 02 Mar 2024 12:51:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709412662; x=1710017462;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NiyWFGpgIt47rDjjJWLUKS580snu9a6YNBj3glQK/HI=;
        b=IdQ3ylo1O/nLRpbaeprhKBuzeZduLpmnHmvVF4T0PHf2u1xyJNW3GTZjTA7n5Cxg+U
         hPt0qiu8ma2uFZtc31VMwLkqoGli7GaBbr9d0D7CgU8i/hZXydBNjnk89EfGim76q6uH
         1GZeG9lXYsqxS7iU9v+fD/irfjaRXaq/amN7x+CR26Tn2GbKJKP3nsvkjpwszg4veJlN
         eR22ebo0wzESxkvQS+OTrXkbzflXxtummC/rqPu+JVNWqBzXMf2tAWZuk8ihbIMp0CCv
         vGAEFqvTkRIXyidhNU1otzMtTQ5auiRKY4I8eqs1SfN51o7hiKWMnMXRrpmU95EX5uhu
         7Shw==
X-Gm-Message-State: AOJu0Yx0Qa/pD/r4TQUI8eiUiouTWUbM1+ntNDH+cDW923PAchZrGicS
	wN5h4xe26qX9Ppn3DTOwI5hOKQ4391HdNdkF22NwiOWJyPnqYnbue0+I5FEHetCx8bbImLbvmwt
	qGW1jJUZHbjFXwLC2ir46YxINCG1/9wqcnB43K4iIZbi6269aNnsKaRR/mg==
X-Received: by 2002:a05:6870:5708:b0:21e:3c57:18d4 with SMTP id k8-20020a056870570800b0021e3c5718d4mr5680427oap.19.1709412661679;
        Sat, 02 Mar 2024 12:51:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHkv2uc4EZFgiv/aeHOSxLVWWmJ3ZKm06w2+fL+h6BsAZrTzzh5lymgtHj6VndwqSkGKD7cFA==
X-Received: by 2002:a05:6870:5708:b0:21e:3c57:18d4 with SMTP id k8-20020a056870570800b0021e3c5718d4mr5680380oap.19.1709412660431;
        Sat, 02 Mar 2024 12:51:00 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w62-20020a636241000000b005e485fbd455sm4986934pgb.45.2024.03.02.12.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Mar 2024 12:50:59 -0800 (PST)
Date: Sun, 3 Mar 2024 04:50:56 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v1.1 8/8] xfs: test for premature ENOSPC with large cow
 delalloc extents
Message-ID: <20240302205056.saexqlexlmwpfy4e@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915333.896550.18395785595853879309.stgit@frogsfrogsfrogs>
 <20240301175202.GK1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240301175202.GK1927156@frogsfrogsfrogs>

On Fri, Mar 01, 2024 at 09:52:02AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On a higly fragmented filesystem a Direct IO write can fail with -ENOSPC error
> even though the filesystem has sufficient number of free blocks.
> 
> This occurs if the file offset range on which the write operation is being
> performed has a delalloc extent in the cow fork and this delalloc extent
> begins much before the Direct IO range.
> 
> In such a scenario, xfs_reflink_allocate_cow() invokes xfs_bmapi_write() to
> allocate the blocks mapped by the delalloc extent. The extent thus allocated
> may not cover the beginning of file offset range on which the Direct IO write
> was issued. Hence xfs_reflink_allocate_cow() ends up returning -ENOSPC.
> 
> This test addresses this issue.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v1.1: address some missing bits and remove extraneous code
> ---
>  common/rc          |   14 ++++++++
>  tests/xfs/1923     |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1923.out |    8 +++++
>  3 files changed, 108 insertions(+)
>  create mode 100755 tests/xfs/1923
>  create mode 100644 tests/xfs/1923.out
> 
> diff --git a/common/rc b/common/rc
> index 30c44dddd9..d3a2a0718b 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1873,6 +1873,20 @@ _require_scratch_delalloc()
>  	_scratch_unmount
>  }
>  
> +# Require test fs supports delay allocation.
> +_require_test_delalloc()
> +{
> +	_require_command "$FILEFRAG_PROG" filefrag
> +
> +	rm -f $TEST_DIR/testy
> +	$XFS_IO_PROG -f -c 'pwrite 0 64k' $TEST_DIR/testy &> /dev/null
> +	$FILEFRAG_PROG -v $TEST_DIR/testy 2>&1 | grep -q delalloc
> +	res=$?
> +	rm -f $TEST_DIR/testy
> +	test $res -eq 0 || \
> +		_notrun "test requires delayed allocation buffered writes"
> +}
> +
>  # this test needs a test partition - check we're ok & mount it
>  #
>  _require_test()
> diff --git a/tests/xfs/1923 b/tests/xfs/1923
> new file mode 100755
> index 0000000000..7068fda64c
> --- /dev/null
> +++ b/tests/xfs/1923
> @@ -0,0 +1,86 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 1923
> +#
> +# This is a regression test for "xfs: Fix false ENOSPC when performing direct
> +# write on a delalloc extent in cow fork".  If there is a lot of free space but
> +# it is very fragmented, it's possible that a very large delalloc reservation
> +# could be created in the CoW fork by a buffered write.  If a directio write
> +# tries to convert the delalloc reservation to a real extent, it's possible
> +# that the allocation will succeed but fail to convert even the first block of
> +# the directio write range.  In this case, XFS will return ENOSPC even though
> +# all it needed to do was to keep converting until the allocator returns ENOSPC
> +# or the first block of the direct write got some space.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick clone
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $file1 $file2 $fragmentedfile
> +}
> +
> +# Import common functions.
> +. ./common/reflink
> +. ./common/inject
> +
> +# real QA test starts here
> +_fixed_by_kernel_commit d62113303d69 \
> +	"xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork"
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_require_test_program "punch-alternating"
> +_require_test_reflink
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +_require_test_delalloc
> +
> +file1=$TEST_DIR/file1.$seq
> +file2=$TEST_DIR/file2.$seq
> +fragmentedfile=$TEST_DIR/fragmentedfile.$seq
> +
> +rm -f $file1 $file2 $fragmentedfile
> +
> +# COW operates on pages, so we must not perform operations in units smaller
> +# than a page.
> +blksz=$(_get_file_block_size $TEST_DIR)
> +pagesz=$(_get_page_size)
> +if (( $blksz < $pagesz )); then
> +	blksz=$pagesz
> +fi
> +
> +echo "Create source file"
> +$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 256))" $file1 >> $seqres.full
> +
> +sync
> +
> +echo "Create Reflinked file"
> +_cp_reflink $file1 $file2 >> $seqres.full
> +
> +echo "Set cowextsize"
> +$XFS_IO_PROG -c "cowextsize $((blksz * 128))" -c stat $file1 >> $seqres.full
> +
> +echo "Fragment FS"
> +$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 512))" $fragmentedfile >> $seqres.full
> +sync
> +$here/src/punch-alternating $fragmentedfile
> +
> +echo "Allocate block sized extent from now onwards"
> +_test_inject_error bmap_alloc_minlen_extent 1
> +
> +echo "Create big delalloc extent in CoW fork"
> +$XFS_IO_PROG -c "pwrite 0 $blksz" $file1 >> $seqres.full
> +
> +sync
> +
> +$XFS_IO_PROG -c 'bmap -elpv' -c 'bmap -celpv' $file1 >> $seqres.full

The "-c" option might get:

  $ xfs_io -c "bmap -celpv" testfile 
  xfs_io: xfsctl(XFS_IOC_GETBMAPX) iflags=0x28 ["testfile"]: Invalid argument

It will break the golden image, can we redirect stderr to $seqres.full,
as it's just for debug? If you agree, I can help to change that by adding
"2>&1" at the end. Or you hope to deal with it by other method?

Thanks,
Zorro


> +
> +echo "Direct I/O write at offset 3FSB"
> +$XFS_IO_PROG -d -c "pwrite $((blksz * 3)) $((blksz * 2))" $file1 >> $seqres.full
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/1923.out b/tests/xfs/1923.out
> new file mode 100644
> index 0000000000..a0553cf3ee
> --- /dev/null
> +++ b/tests/xfs/1923.out
> @@ -0,0 +1,8 @@
> +QA output created by 1923
> +Create source file
> +Create Reflinked file
> +Set cowextsize
> +Fragment FS
> +Allocate block sized extent from now onwards
> +Create big delalloc extent in CoW fork
> +Direct I/O write at offset 3FSB
> 

