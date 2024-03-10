Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A1E17BA4
	for <linux-xfs@vger.kernel.org>; Sun, 10 Mar 2024 09:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710062265; cv=none; b=t7WjZr/eX3W+y1GM1yQltA77XLYDJw5omrqv81Fu/+yLLqJgK535mFYuQOahl3TOFQciFEamv911QSgLT9WEhVmoQpuzScZWjRXKoJWGQab+Ms6e40F3LU8gRUxuy8xxkEDTG7Fafm3kts9C/ERMUeYRPURjUwOof96DYNHqbfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710062265; c=relaxed/simple;
	bh=FnJNEK5LlpYY5hdy8sojasBMwfaWk2CBPkYQ/q4YaBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFzGMOUEuNjspBpO0tBUK6bJvuNfskvHnevhQ+0tgaab/xpJlbR55XSNQ9wP9sgnfa9jl/1WsUoD8st+6ZF0UluCRBGpLHcMMtcHqnEna51vQr4gwqJRERZKvSV1Q9bP14AFZyO+9BN4auQP0gbaVX+Zm9TZHe/FDMG2ldtEjlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JsZz3Fea; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JsZz3Fea"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710062262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FRd4VpxSLyfmln6nGvNf70ZVhy22UjEkRsWlvWsGhng=;
	b=JsZz3FeaSLdH3K4YEr79ZdS0es/X4H9p8zTxKcGiIl41J6tk/o9hrPmXXnjjmD0pAXsxj2
	jxXmX/O+Ydepgv4+1h4M/CfzeLi9ukERSc69UO/zWXYm+bs3Gj/y+pGyeA0Q3vzS2ncFCy
	cTQ1x3UFjBpFcbC5esW2YWYIThKk0gM=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-rcKfUoq7OpikjpHvk8dbdA-1; Sun, 10 Mar 2024 05:17:39 -0400
X-MC-Unique: rcKfUoq7OpikjpHvk8dbdA-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-220ac2258bbso6436652fac.0
        for <linux-xfs@vger.kernel.org>; Sun, 10 Mar 2024 01:17:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710062258; x=1710667058;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FRd4VpxSLyfmln6nGvNf70ZVhy22UjEkRsWlvWsGhng=;
        b=BBIPkwXxhhktsOyiJ2uZnopgZ+rvfGA2p+fX9067eVERbbis/IqqBwQFZfhq8SgQxN
         QnT4xEU4iQkHBZnb/3j3WCjxqvMtVMeSTGTrjBATTVZwYf7DuVb8Sxd1BWUEa5yFhVeI
         gXVtlQUX8KvtDNJRwVxjnG427II2NIaaiyF9+bd6Xc0uhK8KaPf9zfkIqGD6GhCRZbdW
         Su9ezdkttxS6WOwaJhi2OQrMtWbNFq3KPSk4WOfFrLJRGqJ8kaAU5EniurHKX6JU1LPK
         HcmHYglewy5fgkmgunYk6OMBbJgbqC5EQOxsa1QeMzW2XJ8a8YKudfqd0wtnD1fck0So
         DPaA==
X-Gm-Message-State: AOJu0YwqD95QxveoiH2xI9Fl1WzRQFX92HONsH6jhCNABCvFGji291oZ
	+ho2sLu+sr4dAkothH0g8EI0naOsUWsmq17EVcTfaLsWhGpWUjmGhJ/I7cfxag1fBfpFAF4nF9N
	YbhmagalzZ05S/yOm3qiWvxCuVpZZatqNTbxE8fb/DkpPwpV00UFGIAdvp2RLi316dw==
X-Received: by 2002:a05:6871:520a:b0:21e:6669:c3b4 with SMTP id ht10-20020a056871520a00b0021e6669c3b4mr4539891oac.35.1710062258358;
        Sun, 10 Mar 2024 01:17:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF7KZDMGpwR57KEkN4XSglFKQq4LkzVVnlfHazkGlLvPzL7vrW6Uh4k4fgeXSLi9vnbzJlEqQ==
X-Received: by 2002:a05:6871:520a:b0:21e:6669:c3b4 with SMTP id ht10-20020a056871520a00b0021e6669c3b4mr4539875oac.35.1710062257743;
        Sun, 10 Mar 2024 01:17:37 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o70-20020a62cd49000000b006e4e616e520sm2398378pfg.72.2024.03.10.01.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Mar 2024 01:17:37 -0800 (PST)
Date: Sun, 10 Mar 2024 17:17:34 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v1.2 8/8] xfs: test for premature ENOSPC with large cow
 delalloc extents
Message-ID: <20240310091734.hn3twqri6cdgtxaf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915333.896550.18395785595853879309.stgit@frogsfrogsfrogs>
 <20240307232255.GG1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307232255.GG1927156@frogsfrogsfrogs>

On Thu, Mar 07, 2024 at 03:22:55PM -0800, Darrick J. Wong wrote:
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
> v1.2: fix cow fork dumping screwing up golden output

This version is good to me, I'll merge it.

Reviewed-by: Zorro Lang <zlang@redhat.com>

BTW, I only see this patch for [PATCH 8/8], but I didn't see the "later" patch
for [PATCH 6/8], just to make sure if I missed something :)

Thanks,
Zorro

> ---
>  common/rc          |   14 ++++++++
>  tests/xfs/1923     |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1923.out |    8 +++++
>  3 files changed, 108 insertions(+)
>  create mode 100755 tests/xfs/1923
>  create mode 100644 tests/xfs/1923.out
> 
> diff --git a/common/rc b/common/rc
> index 50dde313b8..9f54ab1e77 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1883,6 +1883,20 @@ _require_scratch_delalloc()
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
> index 0000000000..4ad3dfa764
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
> +$XFS_IO_PROG -c 'bmap -elpv' -c 'bmap -celpv' $file1 &>> $seqres.full
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

