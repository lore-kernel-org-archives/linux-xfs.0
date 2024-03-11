Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647BD3FB2C
	for <linux-xfs@vger.kernel.org>; Mon, 11 Mar 2024 13:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710164411; cv=none; b=laPceU36N82Gt2UaTdNycsm7BJFaVz/N03dWjxjD6Ku5Vuj90sgHdIGDuO0tokflGyliAkQFFY7lfEJlThxFevkdpHXPSp+dQxKMCNXYTFRnbcmMsitXy4DYkD9YX/jVZbRRmfQtc+DylwU61dA9mLb6AukWGszwLdo6heOoQkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710164411; c=relaxed/simple;
	bh=XmHZUU1gtyxj/mKkPjonZ1VWZyeSVZkoZZ4SqIzeo78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YQfo+/sbZ0ExGx6t93AnT/EwnCow4lsYS/7JKfdurg5gQ6JoJ7fJICjLSDMJM4I39ihlJSS/0pMWDUDYV31Q5Uxv+G7IcnozdRGKZEdp5g2O5QdH+odGBjDzhI1oK1jqWwOEoY8c4655AEz2DiQJmTTSTbWUHFZ0Yh6p4Zy/yfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GU6wB8+e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GU6wB8+e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710164408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BQ5gRcz9vCw4j+6t6CSgpSEUvEz1f4NIff2T1meHZP8=;
	b=GU6wB8+etf4evmS+kBYVsm6T90ucy6j9EmdkE683apPCL7BGV+Vuht6w9uCdZrXo++2XXR
	kJc9fRVQDoDC3PKbxkrEyHnsqqs5WYbH4rCmn6EA5yStD+56Fsm7BMllOybmh1fzUH4a+t
	Urp+I8uLcuz9tQ7iksCz1NAEY+rCPJY=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-2Vivm_U-MKeX8a5eWYUb0g-1; Mon, 11 Mar 2024 09:40:07 -0400
X-MC-Unique: 2Vivm_U-MKeX8a5eWYUb0g-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6dd65194396so4750617b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Mar 2024 06:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710164405; x=1710769205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQ5gRcz9vCw4j+6t6CSgpSEUvEz1f4NIff2T1meHZP8=;
        b=CWXC9xX4Vvbi3sSP7szUcW2lBKKJEqa/FAAl7QEWbZ1JnHCvnJdH1rXL48bkyarxnB
         sEXAuGpRqNhrm0mst6zM3xNXtj69iL/ogC3crZe07Ck0AenKWs4k04SZOEPneqyqdmTa
         NNkOIRblkOZiPiSfbCMMUT1AodjCkvCF/fbw2esNbsvcr4MfUTLhH/muidOBz+scyl7E
         J37CcSXusuXLyyOg6P9ZiOmN69s1m5RJdd/LaMmAh763dJrVIaR6te/P49SsjExaLjuQ
         es6fGRqWSH46weUzmz8b0nUt5EiM4qLzkUAY3GAGEtPjP9hAdS5k6aeyHa5gcYEV0U6m
         3V0w==
X-Gm-Message-State: AOJu0Yzaz6TpOxAHjRjc83LDeNXGg4Mxa9dGQeMCrkQ9ewFyzG/hQDDN
	29dRrSMync35E30vjGC3HznQyRB6RC1VOPDQoxvSDHukBqo89BruQQaDaTP6M1dI0IfWcVcFVOt
	YO595UZdgENuTUsqW7FRG7aaskWAnkI3tLGZy7PpsF0sHn7ehqW0jeuPIM0lnC0pz5wWT
X-Received: by 2002:a05:6a20:12cb:b0:1a1:87b5:4b28 with SMTP id v11-20020a056a2012cb00b001a187b54b28mr8563706pzg.0.1710164405056;
        Mon, 11 Mar 2024 06:40:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMQFGzmOdUxFzKMo4ozsJtB90XObc8kPKNmFnDhBOUeXD0jYODDfC45/6o2orzBcj86D4GNA==
X-Received: by 2002:a05:6a20:12cb:b0:1a1:87b5:4b28 with SMTP id v11-20020a056a2012cb00b001a187b54b28mr8563669pzg.0.1710164404462;
        Mon, 11 Mar 2024 06:40:04 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id du3-20020a056a002b4300b006e5ed7c0b35sm4351111pfb.67.2024.03.11.06.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 06:40:04 -0700 (PDT)
Date: Mon, 11 Mar 2024 21:40:01 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v1.2 8/8] xfs: test for premature ENOSPC with large cow
 delalloc extents
Message-ID: <20240311134001.6qflb7gjyjnwwetr@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915333.896550.18395785595853879309.stgit@frogsfrogsfrogs>
 <20240307232255.GG1927156@frogsfrogsfrogs>
 <20240310091734.hn3twqri6cdgtxaf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240310162654.GB6226@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240310162654.GB6226@frogsfrogsfrogs>

On Sun, Mar 10, 2024 at 09:26:54AM -0700, Darrick J. Wong wrote:
> On Sun, Mar 10, 2024 at 05:17:34PM +0800, Zorro Lang wrote:
> > On Thu, Mar 07, 2024 at 03:22:55PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > On a higly fragmented filesystem a Direct IO write can fail with -ENOSPC error
> > > even though the filesystem has sufficient number of free blocks.
> > > 
> > > This occurs if the file offset range on which the write operation is being
> > > performed has a delalloc extent in the cow fork and this delalloc extent
> > > begins much before the Direct IO range.
> > > 
> > > In such a scenario, xfs_reflink_allocate_cow() invokes xfs_bmapi_write() to
> > > allocate the blocks mapped by the delalloc extent. The extent thus allocated
> > > may not cover the beginning of file offset range on which the Direct IO write
> > > was issued. Hence xfs_reflink_allocate_cow() ends up returning -ENOSPC.
> > > 
> > > This test addresses this issue.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > > v1.1: address some missing bits and remove extraneous code
> > > v1.2: fix cow fork dumping screwing up golden output
> > 
> > This version is good to me, I'll merge it.
> > 
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > 
> > BTW, I only see this patch for [PATCH 8/8], but I didn't see the "later" patch
> > for [PATCH 6/8], just to make sure if I missed something :)
> 
> Oh!  Yeah, on re-reading that thread, I remembered that Christoph said
> he'd look into making xfs_ondisk.h check ioctl structure sizes like
> xfs/122 currently does.
> 
> In the meantime, there weren't any changes other than your RVB tag.  If
> you want, I can resend it with that added.

Oh, if that patch don't need to be changed, I'll merge it directly, don't
need resending it :)

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > ---
> > >  common/rc          |   14 ++++++++
> > >  tests/xfs/1923     |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/1923.out |    8 +++++
> > >  3 files changed, 108 insertions(+)
> > >  create mode 100755 tests/xfs/1923
> > >  create mode 100644 tests/xfs/1923.out
> > > 
> > > diff --git a/common/rc b/common/rc
> > > index 50dde313b8..9f54ab1e77 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -1883,6 +1883,20 @@ _require_scratch_delalloc()
> > >  	_scratch_unmount
> > >  }
> > >  
> > > +# Require test fs supports delay allocation.
> > > +_require_test_delalloc()
> > > +{
> > > +	_require_command "$FILEFRAG_PROG" filefrag
> > > +
> > > +	rm -f $TEST_DIR/testy
> > > +	$XFS_IO_PROG -f -c 'pwrite 0 64k' $TEST_DIR/testy &> /dev/null
> > > +	$FILEFRAG_PROG -v $TEST_DIR/testy 2>&1 | grep -q delalloc
> > > +	res=$?
> > > +	rm -f $TEST_DIR/testy
> > > +	test $res -eq 0 || \
> > > +		_notrun "test requires delayed allocation buffered writes"
> > > +}
> > > +
> > >  # this test needs a test partition - check we're ok & mount it
> > >  #
> > >  _require_test()
> > > diff --git a/tests/xfs/1923 b/tests/xfs/1923
> > > new file mode 100755
> > > index 0000000000..4ad3dfa764
> > > --- /dev/null
> > > +++ b/tests/xfs/1923
> > > @@ -0,0 +1,86 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 1923
> > > +#
> > > +# This is a regression test for "xfs: Fix false ENOSPC when performing direct
> > > +# write on a delalloc extent in cow fork".  If there is a lot of free space but
> > > +# it is very fragmented, it's possible that a very large delalloc reservation
> > > +# could be created in the CoW fork by a buffered write.  If a directio write
> > > +# tries to convert the delalloc reservation to a real extent, it's possible
> > > +# that the allocation will succeed but fail to convert even the first block of
> > > +# the directio write range.  In this case, XFS will return ENOSPC even though
> > > +# all it needed to do was to keep converting until the allocator returns ENOSPC
> > > +# or the first block of the direct write got some space.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick clone
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $file1 $file2 $fragmentedfile
> > > +}
> > > +
> > > +# Import common functions.
> > > +. ./common/reflink
> > > +. ./common/inject
> > > +
> > > +# real QA test starts here
> > > +_fixed_by_kernel_commit d62113303d69 \
> > > +	"xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork"
> > > +
> > > +# Modify as appropriate.
> > > +_supported_fs xfs
> > > +_require_test_program "punch-alternating"
> > > +_require_test_reflink
> > > +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> > > +_require_test_delalloc
> > > +
> > > +file1=$TEST_DIR/file1.$seq
> > > +file2=$TEST_DIR/file2.$seq
> > > +fragmentedfile=$TEST_DIR/fragmentedfile.$seq
> > > +
> > > +rm -f $file1 $file2 $fragmentedfile
> > > +
> > > +# COW operates on pages, so we must not perform operations in units smaller
> > > +# than a page.
> > > +blksz=$(_get_file_block_size $TEST_DIR)
> > > +pagesz=$(_get_page_size)
> > > +if (( $blksz < $pagesz )); then
> > > +	blksz=$pagesz
> > > +fi
> > > +
> > > +echo "Create source file"
> > > +$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 256))" $file1 >> $seqres.full
> > > +
> > > +sync
> > > +
> > > +echo "Create Reflinked file"
> > > +_cp_reflink $file1 $file2 >> $seqres.full
> > > +
> > > +echo "Set cowextsize"
> > > +$XFS_IO_PROG -c "cowextsize $((blksz * 128))" -c stat $file1 >> $seqres.full
> > > +
> > > +echo "Fragment FS"
> > > +$XFS_IO_PROG -f -c "pwrite 0 $((blksz * 512))" $fragmentedfile >> $seqres.full
> > > +sync
> > > +$here/src/punch-alternating $fragmentedfile
> > > +
> > > +echo "Allocate block sized extent from now onwards"
> > > +_test_inject_error bmap_alloc_minlen_extent 1
> > > +
> > > +echo "Create big delalloc extent in CoW fork"
> > > +$XFS_IO_PROG -c "pwrite 0 $blksz" $file1 >> $seqres.full
> > > +
> > > +sync
> > > +
> > > +$XFS_IO_PROG -c 'bmap -elpv' -c 'bmap -celpv' $file1 &>> $seqres.full
> > > +
> > > +echo "Direct I/O write at offset 3FSB"
> > > +$XFS_IO_PROG -d -c "pwrite $((blksz * 3)) $((blksz * 2))" $file1 >> $seqres.full
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/1923.out b/tests/xfs/1923.out
> > > new file mode 100644
> > > index 0000000000..a0553cf3ee
> > > --- /dev/null
> > > +++ b/tests/xfs/1923.out
> > > @@ -0,0 +1,8 @@
> > > +QA output created by 1923
> > > +Create source file
> > > +Create Reflinked file
> > > +Set cowextsize
> > > +Fragment FS
> > > +Allocate block sized extent from now onwards
> > > +Create big delalloc extent in CoW fork
> > > +Direct I/O write at offset 3FSB
> > > 
> > 
> 

