Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F021E84D11
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 13:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719147793; cv=none; b=sTb7LWlk+MWe8GNJZcOelwOU2kmO1OVBP03F+X729zXSAGs9ThgMHOTZ7AojKFWygmL6Ea6ynlY26HYCOJ5Diz6ICasQnEn4Vlf+EwGpwZLZnjWAuaHWMzmyqKCX9kwYEia20SV2iETaTXivz1/KkU21aQ+VEXqbhbz7pLdbeME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719147793; c=relaxed/simple;
	bh=4++v4HEk6e/WeEFDaJcCCqbW8dP4Szrm1d51vgrGxM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZUCSdCpDXLeSNIewiRfSKcmwsI7Gy8EDe+llz4QHYtHb9BnW4BGfPoaTtWlLRTZs75hqkpybr6tVGuGuu5izbJera9FPd75KiFVSFG0x8TCW9ekjZ8nqW9iGV9svK/NNjig6RXSJQFbPlExSuCc/XV7dJWEglIuIKRWq60Ra6Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VtVgk1pd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VtVgk1pd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719147789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OkGfeTc2GNP5SzhiS10auyUivc5f5wZgqAPMPPb3Dxs=;
	b=VtVgk1pdRvqAhIakq2+5ZlcPFuaxqsGfIB6WixUjk3kPlyHXzVJsE/BTkazHlXcZBVuKpE
	4ATq872ZBq20t87702YrEamNcjNiMWmTYbYyRPP/tr4pSBQ/keaWm01xOPOam74b54CkJl
	meAlha/GC5TptlHvG2jxo+XMMNCQJG4=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368-NH-I_15lPgSihOcdD5Ct-g-1; Sun, 23 Jun 2024 09:03:08 -0400
X-MC-Unique: NH-I_15lPgSihOcdD5Ct-g-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-7065bc8314cso1931359b3a.2
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 06:03:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719147787; x=1719752587;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OkGfeTc2GNP5SzhiS10auyUivc5f5wZgqAPMPPb3Dxs=;
        b=IfOytk4Y5qEIumqkebVbEF7P6MRly+xMrbNTiBSnp/NbbzzyLqcjmfGwwUDo+QPXB/
         GEKy8bqp7tvFCZhCLbRtBrIijsOmDlDZhj2wmZaHEaxo7GiLF82CsBa7NJocxkwkE+Uo
         3eHCVLB1hs1NWNF7SIPlyJQNtxuS33z0Y1AI6Pzv44zatDuouo9L6D+chL+pGpA0JPoa
         6q0Z0l4b7TBlxj8CJKKcoaAB+Xik4+5nI6GZpXO9xp84bnBtewLoWAc3SirK/KoXyELD
         cqzuTkacsfhTLEtSl5z5Y5csdQqUFnILE0HoAAbhKMzPKqJJgLQCKgk091Dp6CCXDGOG
         O+qw==
X-Forwarded-Encrypted: i=1; AJvYcCU/L9kuWFRyiw3gNhYiFt344unumNtn8MHjqgxW+T9vAWIbqeplZnyp+x/+uAJfic6NlEmrFSE30/wZzK0AkDSbtDNYIebvHtlp
X-Gm-Message-State: AOJu0YwnArrQ1joBGZlhBR2Mrxf19Xkk/3ZfNIG5WA1Uf/ksKgJruqhX
	b9v5ylqlO0ZB981XZUYBB+1b9juNczWxyXmJ4uYEFRA03wAfA3HZWZgR2n98Ya7r6OtNC1IQA5X
	jdHHIspCZkdCtupToWR73yWDMU0YlFTBEpGbHbXn0Ei8Vn14LqIV9Cbx4zQ==
X-Received: by 2002:aa7:98c3:0:b0:705:c0a1:61c9 with SMTP id d2e1a72fcca58-7066e52a6bamr2422469b3a.9.1719147786709;
        Sun, 23 Jun 2024 06:03:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtIC6oezlR23WxlMKwCdUR6QFWuss73xN1RWRn2RuZpNm84CJueDIm2bMkBqgiyUU5wzaHKA==
X-Received: by 2002:aa7:98c3:0:b0:705:c0a1:61c9 with SMTP id d2e1a72fcca58-7066e52a6bamr2422429b3a.9.1719147786090;
        Sun, 23 Jun 2024 06:03:06 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7067b4d5a82sm855302b3a.68.2024.06.23.06.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jun 2024 06:03:05 -0700 (PDT)
Date: Sun, 23 Jun 2024 21:03:01 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: new EOF fragmentation tests
Message-ID: <20240623130301.s2r2fv5qjaspmcxi@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240623053900.857695-1-hch@lst.de>
 <20240623053900.857695-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623053900.857695-2-hch@lst.de>

On Sun, Jun 23, 2024 at 07:38:53AM +0200, Christoph Hellwig wrote:
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
>  tests/xfs/1500     | 59 ++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1500.out |  9 ++++++
>  tests/xfs/1501     | 61 ++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1501.out |  9 ++++++
>  tests/xfs/1502     | 61 ++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1502.out |  9 ++++++
>  tests/xfs/1503     | 70 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1503.out | 33 ++++++++++++++++++++++
>  8 files changed, 311 insertions(+)
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
> index 000000000..222e90d6c
> --- /dev/null
> +++ b/tests/xfs/1500
> @@ -0,0 +1,59 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
                   ^^^^
Should I keep "2019" or change it to 2024, or no matter :)

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
> +_supported_fs xfs
> +_require_scratch
> +
> +_scratch_mkfs 2>&1 >> $seqres.full

Wrong order:) ">>$seqres.full 2>&1"


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
> +for ((n=0; n<$nfiles; n++)); do
> +	write_sync_file $n > /dev/null 2>&1 &
> +done
> +wait

If a case has background process, better to do kill&wait in _cleanup,
for unexpected Ctrl^C when fstests is running. e.g.

_cleanup{}
{
	# try to kill all background processes
	wait
	cd /
	rm -r -f $tmp.*
}

I'm not sure if there's a good to way to do "kill all background
processes" in this case, or if it's necessary. But a "wait" might
be worth, to avoid the "Device Busy" error. Any thoughts?

Thanks,
Zorro


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
> index 000000000..beae49bff
> --- /dev/null
> +++ b/tests/xfs/1501
> @@ -0,0 +1,61 @@
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
> +_supported_fs xfs
> +_require_scratch
> +
> +_scratch_mkfs 2>&1 >> $seqres.full
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
> index 000000000..9d303ced7
> --- /dev/null
> +++ b/tests/xfs/1502
> @@ -0,0 +1,61 @@
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
> +_supported_fs xfs
> +_require_scratch
> +
> +_scratch_mkfs 2>&1 >> $seqres.full
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
> index 000000000..41f4035ad
> --- /dev/null
> +++ b/tests/xfs/1503
> @@ -0,0 +1,70 @@
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
> +_supported_fs xfs
> +_require_scratch
> +
> +_scratch_mkfs 2>&1 >> $seqres.full
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
> 2.43.0
> 
> 

