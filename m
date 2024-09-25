Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E64126C1C
	for <linux-xfs@vger.kernel.org>; Wed, 25 Sep 2024 11:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727262941; cv=none; b=d5Uf3OJ8++S7ETqW15ctrniBdWvlsK/sXiJbGY8H/w+wIeNVxQbMOp97V+2soIoS8ITrdAjUHHjaqz7fy/cKkpNsZvy+FvaknuekJWhLpmBkc2lsCrfLOwnWbZ2Iu7Dr2xKK4JIdEJTfs6zBgTfD2lbWwGZ6uqxFYS9Uv2kTKYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727262941; c=relaxed/simple;
	bh=TyzMD6cWNRSJJA9W1BVRPPwWWPauxyu2ZNquEMGRqno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oceFnVXgxc3IAokMHdOU2Xy8h+61RISZB0pudVPfll7pKbdHAroxMczqLSHuz9tuF4fzSPKxqmUaeHjK82aqfZDyFNz8/Jr5zNQYUE/qfPvAin/tGXGxflw7VNkdL1HEEoe/Ecq7+zqrMZs+u5HuQVoBSNsvVdIb4mearsmQHM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hDuvRwVM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hDuvRwVM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727262938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pXRcar87hVLEkI8TfvQHnR01o5Y4Km15BgS8tvGNowg=;
	b=hDuvRwVM0cgQuh16/suXsiwheeaDXsAHPcQpRVkyd2FyGxzFT/T+E60mj6AmpEcMMECBZ7
	oDdEfa9z9EGdHdhxDwCT7ZIFhjci5WkZglsAJae25bA8MsN/sVM/9egP54CsIEorGmR/8f
	3Yv8d6BDcfMhPGmZPoLMGLhKbmbcEuo=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-XN41VA26MsKGXXe1U0wGcg-1; Wed, 25 Sep 2024 07:15:37 -0400
X-MC-Unique: XN41VA26MsKGXXe1U0wGcg-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2070e327014so57131495ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 25 Sep 2024 04:15:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727262936; x=1727867736;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pXRcar87hVLEkI8TfvQHnR01o5Y4Km15BgS8tvGNowg=;
        b=ma3F+2lDKsP5t8za3vamjfkYq4PL7UbYx2KvoIy9Stk80G1sURg/GzdGWoxABWoGnI
         1/2orYeUY68KqeApFTYK1tZoEx9bAIIJK0WwxFNdx6IaKAUkulrK+PRG+3UJaW3Pzkrk
         81j3+WRroPj98koah6ogdSlJe4e++l8VWEdUSDwdqhMCb0BezUK9r5ZdbR/rKxdSN+D2
         S2kSvWaNtD//ztI6duV5akwkPsFJxNDwkJELzLsZi/7oW0ut3t0YR9tWWJ5kIeTDLSoX
         PrfUqobnA146XgjKVI2Buvl0T5FVqLAUt1kg6524O+HZY08sxCG1farHgYoEPbiCIOUa
         As1w==
X-Forwarded-Encrypted: i=1; AJvYcCXL307FNjdYFwqs4Jyav7CrLqproOaApLR9rJSdAJsDiwsOErO7JyM91qmzHC6QT/08NY4Jrr3AHdU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3tYTKoNaR/Su5kVWJJM3ZW8R7Hrdrx6iEiaH5mgi55sHu6++/
	vABtkOd8BSoxOjqGofrGmQlwkC9KdzYYXQC+BHA9xHcB+tereCGTnM+ALqMzWKD3xJWgVJ59Pui
	xSbcR+QBO9rkUz8u8x0odjDJTg2Ooco4BenQYFUsT4UCM/6xZUhXcomJnbw==
X-Received: by 2002:a17:902:ecc8:b0:206:ac11:f3bb with SMTP id d9443c01a7336-20afc5ee705mr23919035ad.47.1727262936400;
        Wed, 25 Sep 2024 04:15:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRR5lBFGS2iWO176br9Ok4y6tRKh1xas+W2wsFli95rNISseXzJsdUJy7EKgf1j5BYIiQCkw==
X-Received: by 2002:a17:902:ecc8:b0:206:ac11:f3bb with SMTP id d9443c01a7336-20afc5ee705mr23918665ad.47.1727262935856;
        Wed, 25 Sep 2024 04:15:35 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20af16e5478sm23081025ad.1.2024.09.25.04.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 04:15:35 -0700 (PDT)
Date: Wed, 25 Sep 2024 19:15:32 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: new EOF fragmentation tests
Message-ID: <20240925111532.me7szmoqedt7ta63@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240924084551.1802795-1-hch@lst.de>
 <20240924084551.1802795-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240924084551.1802795-2-hch@lst.de>

On Tue, Sep 24, 2024 at 10:45:48AM +0200, Christoph Hellwig wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> These tests create substantial file fragmentation as a result of
> application actions that defeat post-EOF preallocation
> optimisations. They are intended to replicate known vectors for
> these problems, and provide a check that the fragmentation levels
> have been controlled. The mitigations we make may not completely
> remove fragmentation (e.g. they may demonstrate speculative delalloc
> related extent size growth) so the checks don't assume we'll end up
> with perfect layouts and hence check for an exceptable level of
> fragmentation rather than none.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> [move to different test number, update to current xfstest APIs]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

This patch looks good to me, just a few nit-picking below...

>  tests/xfs/1500     | 66 +++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1500.out |  9 ++++++
>  tests/xfs/1501     | 68 ++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1501.out |  9 ++++++
>  tests/xfs/1502     | 68 ++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1502.out |  9 ++++++
>  tests/xfs/1503     | 77 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1503.out | 33 ++++++++++++++++++++
>  8 files changed, 339 insertions(+)
>  create mode 100755 tests/xfs/1500
>  create mode 100644 tests/xfs/1500.out
>  create mode 100755 tests/xfs/1501
>  create mode 100644 tests/xfs/1501.out
>  create mode 100755 tests/xfs/1502
>  create mode 100644 tests/xfs/1502.out
>  create mode 100755 tests/xfs/1503
>  create mode 100644 tests/xfs/1503.out
> 
> diff --git a/tests/xfs/1500 b/tests/xfs/1500
> new file mode 100755
> index 000000000..de0e1df62
> --- /dev/null
> +++ b/tests/xfs/1500
> @@ -0,0 +1,66 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test xfs/500
> +#
> +# Post-EOF preallocation defeat test for O_SYNC buffered I/O.
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick prealloc rw
> +
> +. ./common/rc
> +. ./common/filter
> +
> +_require_scratch
> +
> +_cleanup()
> +{
> +	# try to kill all background processes

I didn't see "kill" below, maybe "wait all background processes done"? Or you'd
like to use "kill" but forgot? If you don't want to use "kill", please tell me,
then I'll help to change the comment when I merge it.

> +	wait
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +
> +# Write multiple files in parallel using synchronous buffered writes. Aim is to
> +# interleave allocations to fragment the files. Synchronous writes defeat the
> +# open/write/close heuristics in xfs_file_release() that prevent EOF block
> +# removal, so this should fragment badly. Typical problematic behaviour shows
> +# per-file extent counts of >900 (almost worse case) whilst fixed behaviour
> +# typically shows extent counts in the low 20s.
> +#
> +# Failure is determined by golden output mismatch from _within_tolerance().
> +
> +workfile=$SCRATCH_MNT/file
> +nfiles=8
> +wsize=4096
> +wcnt=1000
> +
> +write_sync_file()
> +{
> +	idx=$1
> +
> +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> +		$XFS_IO_PROG -f -s -c "pwrite $((cnt * wsize)) $wsize" $workfile.$idx
> +	done
> +}
> +
> +rm -f $workfile*

Hmm, "rm -f $XXX*", but looks like the $workdfile doesn't have chance to be
null :) Maybe rm -f $workfile.* is safer, as all test files are $workfile.$idx
or $workfile.$n. I can do this change when I merge it.

Thanks,
Zorro

> +for ((n=0; n<$nfiles; n++)); do
> +	write_sync_file $n > /dev/null 2>&1 &
> +done
> +wait
> +sync
> +
> +for ((n=0; n<$nfiles; n++)); do
> +	count=$(_count_extents $workfile.$n)
> +	# Acceptible extent count range is 1-40
> +	_within_tolerance "file.$n extent count" $count 21 19 -v
> +done
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1500.out b/tests/xfs/1500.out
> new file mode 100644
> index 000000000..414df87ed
> --- /dev/null
> +++ b/tests/xfs/1500.out
> @@ -0,0 +1,9 @@
> +QA output created by 1500
> +file.0 extent count is in range
> +file.1 extent count is in range
> +file.2 extent count is in range
> +file.3 extent count is in range
> +file.4 extent count is in range
> +file.5 extent count is in range
> +file.6 extent count is in range
> +file.7 extent count is in range
> diff --git a/tests/xfs/1501 b/tests/xfs/1501
> new file mode 100755
> index 000000000..cf3cbf8b5
> --- /dev/null
> +++ b/tests/xfs/1501
> @@ -0,0 +1,68 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test xfs/501
> +#
> +# Post-EOF preallocation defeat test for buffered I/O with extent size hints.
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick prealloc rw
> +
> +. ./common/rc
> +. ./common/filter
> +
> +_require_scratch
> +
> +_cleanup()
> +{
> +	# try to kill all background processes
> +	wait
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +
> +# Write multiple files in parallel using buffered writes with extent size hints.
> +# Aim is to interleave allocations to fragment the files. Writes w/ extent size
> +# hints set defeat the open/write/close heuristics in xfs_file_release() that
> +# prevent EOF block removal, so this should fragment badly. Typical problematic
> +# behaviour shows per-file extent counts of 1000 (worst case!) whilst
> +# fixed behaviour should show very few extents (almost best case).
> +#
> +# Failure is determined by golden output mismatch from _within_tolerance().
> +
> +workfile=$SCRATCH_MNT/file
> +nfiles=8
> +wsize=4096
> +wcnt=1000
> +extent_size=16m
> +
> +write_extsz_file()
> +{
> +	idx=$1
> +
> +	$XFS_IO_PROG -f -c "extsize $extent_size" $workfile.$idx
> +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> +		$XFS_IO_PROG -f -c "pwrite $((cnt * wsize)) $wsize" $workfile.$idx
> +	done
> +}
> +
> +rm -f $workfile*
> +for ((n=0; n<$nfiles; n++)); do
> +	write_extsz_file $n > /dev/null 2>&1 &
> +done
> +wait
> +sync
> +
> +for ((n=0; n<$nfiles; n++)); do
> +	count=$(_count_extents $workfile.$n)
> +	# Acceptible extent count range is 1-10
> +	_within_tolerance "file.$n extent count" $count 2 1 8 -v
> +done
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1501.out b/tests/xfs/1501.out
> new file mode 100644
> index 000000000..a266ef74b
> --- /dev/null
> +++ b/tests/xfs/1501.out
> @@ -0,0 +1,9 @@
> +QA output created by 1501
> +file.0 extent count is in range
> +file.1 extent count is in range
> +file.2 extent count is in range
> +file.3 extent count is in range
> +file.4 extent count is in range
> +file.5 extent count is in range
> +file.6 extent count is in range
> +file.7 extent count is in range
> diff --git a/tests/xfs/1502 b/tests/xfs/1502
> new file mode 100755
> index 000000000..f4228667a
> --- /dev/null
> +++ b/tests/xfs/1502
> @@ -0,0 +1,68 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test xfs/502
> +#
> +# Post-EOF preallocation defeat test for direct I/O with extent size hints.
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick prealloc rw
> +
> +. ./common/rc
> +. ./common/filter
> +
> +_require_scratch
> +
> +_cleanup()
> +{
> +	# try to kill all background processes
> +	wait
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +
> +# Write multiple files in parallel using O_DIRECT writes w/ extent size hints.
> +# Aim is to interleave allocations to fragment the files. O_DIRECT writes defeat
> +# the open/write/close heuristics in xfs_file_release() that prevent EOF block
> +# removal, so this should fragment badly. Typical problematic behaviour shows
> +# per-file extent counts of ~1000 (worst case) whilst fixed behaviour typically
> +# shows extent counts in the low single digits (almost best case)
> +#
> +# Failure is determined by golden output mismatch from _within_tolerance().
> +
> +workfile=$SCRATCH_MNT/file
> +nfiles=8
> +wsize=4096
> +wcnt=1000
> +extent_size=16m
> +
> +write_direct_file()
> +{
> +	idx=$1
> +
> +	$XFS_IO_PROG -f -c "extsize $extent_size" $workfile.$idx
> +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> +		$XFS_IO_PROG -f -d -c "pwrite $((cnt * wsize)) $wsize" $workfile.$idx
> +	done
> +}
> +
> +rm -f $workfile*
> +for ((n=0; n<$nfiles; n++)); do
> +	write_direct_file $n > /dev/null 2>&1 &
> +done
> +wait
> +sync
> +
> +for ((n=0; n<$nfiles; n++)); do
> +	count=$(_count_extents $workfile.$n)
> +	# Acceptible extent count range is 1-10
> +	_within_tolerance "file.$n extent count" $count 2 1 8 -v
> +done
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1502.out b/tests/xfs/1502.out
> new file mode 100644
> index 000000000..82c8760a3
> --- /dev/null
> +++ b/tests/xfs/1502.out
> @@ -0,0 +1,9 @@
> +QA output created by 1502
> +file.0 extent count is in range
> +file.1 extent count is in range
> +file.2 extent count is in range
> +file.3 extent count is in range
> +file.4 extent count is in range
> +file.5 extent count is in range
> +file.6 extent count is in range
> +file.7 extent count is in range
> diff --git a/tests/xfs/1503 b/tests/xfs/1503
> new file mode 100755
> index 000000000..9002f87e6
> --- /dev/null
> +++ b/tests/xfs/1503
> @@ -0,0 +1,77 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test xfs/503
> +#
> +# Post-EOF preallocation defeat test with O_SYNC buffered I/O that repeatedly
> +# closes and reopens the files.
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto prealloc rw
> +
> +. ./common/rc
> +. ./common/filter
> +
> +_require_scratch
> +
> +_cleanup()
> +{
> +	# try to kill all background processes
> +	wait
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +
> +# Write multiple files in parallel using synchronous buffered writes that
> +# repeatedly close and reopen the fails. Aim is to interleave allocations to
> +# fragment the files. Assuming we've fixed the synchronous write defeat, we can
> +# still trigger the same issue with a open/read/close on O_RDONLY files. We
> +# should not be triggering EOF preallocation removal on files we don't have
> +# permission to write, so until this is fixed it should fragment badly.  Typical
> +# problematic behaviour shows per-file extent counts of 50-350 whilst fixed
> +# behaviour typically demonstrates post-eof speculative delalloc growth in
> +# extent size (~6 extents for 50MB file).
> +#
> +# Failure is determined by golden output mismatch from _within_tolerance().
> +
> +workfile=$SCRATCH_MNT/file
> +nfiles=32
> +wsize=4096
> +wcnt=1000
> +
> +write_file()
> +{
> +	idx=$1
> +
> +	$XFS_IO_PROG -f -s -c "pwrite -b 64k 0 50m" $workfile.$idx
> +}
> +
> +read_file()
> +{
> +	idx=$1
> +
> +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> +		$XFS_IO_PROG -f -r -c "pread 0 28" $workfile.$idx
> +	done
> +}
> +
> +rm -f $workdir/file*
> +for ((n=0; n<$((nfiles)); n++)); do
> +	write_file $n > /dev/null 2>&1 &
> +	read_file $n > /dev/null 2>&1 &
> +done
> +wait
> +
> +for ((n=0; n<$nfiles; n++)); do
> +	count=$(_count_extents $workfile.$n)
> +	# Acceptible extent count range is 1-40
> +	_within_tolerance "file.$n extent count" $count 6 5 10 -v
> +done
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1503.out b/tests/xfs/1503.out
> new file mode 100644
> index 000000000..1780b16df
> --- /dev/null
> +++ b/tests/xfs/1503.out
> @@ -0,0 +1,33 @@
> +QA output created by 1503
> +file.0 extent count is in range
> +file.1 extent count is in range
> +file.2 extent count is in range
> +file.3 extent count is in range
> +file.4 extent count is in range
> +file.5 extent count is in range
> +file.6 extent count is in range
> +file.7 extent count is in range
> +file.8 extent count is in range
> +file.9 extent count is in range
> +file.10 extent count is in range
> +file.11 extent count is in range
> +file.12 extent count is in range
> +file.13 extent count is in range
> +file.14 extent count is in range
> +file.15 extent count is in range
> +file.16 extent count is in range
> +file.17 extent count is in range
> +file.18 extent count is in range
> +file.19 extent count is in range
> +file.20 extent count is in range
> +file.21 extent count is in range
> +file.22 extent count is in range
> +file.23 extent count is in range
> +file.24 extent count is in range
> +file.25 extent count is in range
> +file.26 extent count is in range
> +file.27 extent count is in range
> +file.28 extent count is in range
> +file.29 extent count is in range
> +file.30 extent count is in range
> +file.31 extent count is in range
> -- 
> 2.45.2
> 
> 

