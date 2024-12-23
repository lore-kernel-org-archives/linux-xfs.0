Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2C9188A0C
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 12:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734956258; cv=none; b=VooPBqpYSKUpagpdmZT2eHkPbW3bIjtV1hLAfiWmieMLfcseUdlwg7pYGzvBvJK/aw5iYUKi2kUej7LTUElAAgBLID+f6uqr5XYm6c9F6hImhudhLwce04mKKNqlgghTmKMUgykTN8Rwls5Q/CwaSTp9gEordSX9Xv6Imy0ICf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734956258; c=relaxed/simple;
	bh=PM275oSDAotRH6nhFuVcayd70e+kQVrI7OgLLoyryaE=;
	h=From:To:Subject:In-Reply-To:Date:Message-ID:References; b=oZRmVB1bLvGr/hU9seDoUe8AbK89mJUnO5nOgfxdHDzQtbm+KZe9cWqg9FrC7Gd63SHX9EljMjlwkY7/GUjHvUNTK9/WJmcixHV/pGthmgi6GZZnUp5n8WYLAxZs6f3DSXDDef94Wt/rirKM2mzBKC0KA73ViDoJ8yHzoJOXbDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P+HJrgKe; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P+HJrgKe"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ee8aa26415so3673153a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 04:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734956255; x=1735561055; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:to:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w7X4OadKTpDdwYB5EY3jo01Fd7z0egk2jGtRAXwi6Ng=;
        b=P+HJrgKe6UQhxPjFzaJGCf3UhjUml+omATYIBjTsw4U/Jq4NOG6FVtNmMUaCxd+yr0
         /crXpQtHdhQTLkbmBYPg472q0wyhQiojSYkOAgfRMU/LAgpEkJcKq0sh0+MpQXcXXYky
         LFJRb3ov7YChig9r19Q/d7dBqPXaOAFc+iXA7y5JijRa6rmBDoQXq1Piox875AQfJWIc
         8YWSk4+ZAbzX+OrKz4dDfrU+Kx4ckZRzcRj1SCCvUqKmmZoSrx/k8cqjAKDj79kzZuSH
         b32ZrexvF3tJ3Aj1eB79N5l3g+fFYbEjrauYp6cxWgYSyfhjrXEJqDOjEGiJ5fGLX+7u
         uJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734956255; x=1735561055;
        h=references:message-id:date:in-reply-to:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w7X4OadKTpDdwYB5EY3jo01Fd7z0egk2jGtRAXwi6Ng=;
        b=WRkgYZakw1Wn9UimYUCO+dE+QHdEaZR+wyfj8QWwNJqkCmkWVmsDrgKXuF+ufx3yEH
         spFA/XSXKRYRb5eIpzlG5MLyRzxXjEByC4q5ZwAPPjNKcp6RnL3oI16lBFxBNtOucAqA
         IWOHFMIq0fQXNPPGzB9FEQfjq0JS6Br3DVKCcpgJ7zdJjs+ZM1oD7njKz9xaxR6QINs5
         fnNhqwrDPnusoJ3czsdiY8/JzK7J6Hsjfgqy9rhOVCEKAV40/S3h+Xri/R0ZwdWf+NQz
         CWkYSO9I77EmT4rau1GcRFYD+I/OsxPIz88mfeTTYPv3sRI6O0uTY7MNmYF9BXSj9i3R
         vmTg==
X-Forwarded-Encrypted: i=1; AJvYcCXutriVbg/8wZTyXUXfbYtDWFaLqO0BRifKZlh38Os/ZGscGillqiep/Ai74XpaLpYsaHnK933MPNk=@vger.kernel.org
X-Gm-Message-State: AOJu0YykeDTulEZvnFsyBrlvGm6wl87tv7rMB6ixlMVyGxDfyDoUn5JI
	iOdsrOllGRBM2ZqFrNEZvcgNKYHZW3CiY0+A5bfD4vy3bVE2r2gI4WFdbf3I6TQ=
X-Gm-Gg: ASbGnctgMDgu/ww0ZlATLB2Na3jnB126ZrUj+804ZEYnX+sthWDxQLWQzUXJ3+RsC9V
	BRxh+y/CL6FpzOgSOzcfkpNQ6yJ+xdhiNzOILzJDSAXStLYpfVU+NhzbL50u5euC36shPnSx7FB
	G0LN7ay8MEJtvWsWL0NND/WZOt9EdHDY6rF/BImKub7xzCBf0R8FQdA9BC+LJfJWIogtT7asHJV
	Dowmh+YiGNqcamCn7kJDUeJcb03zlH3aZGgwNJfrCMIPaU=
X-Google-Smtp-Source: AGHT+IEHBt1B8QFrKYPgzL4iQv9O8xFbx++dxIfxstCp9WkyLkUCoo1forWMCkUZk1n1vzQwMJnDuA==
X-Received: by 2002:a17:90b:524d:b0:2ea:3f34:f18d with SMTP id 98e67ed59e1d1-2f452e10348mr19978204a91.10.1734956254821;
        Mon, 23 Dec 2024 04:17:34 -0800 (PST)
Received: from dw-tp ([129.41.58.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f2ee06dd54sm11259391a91.41.2024.12.23.04.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2024 04:17:34 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: add a test for atomic writes
In-Reply-To: <20241217020828.28976-1-catherine.hoang@oracle.com>
Date: Mon, 23 Dec 2024 17:43:54 +0530
Message-ID: <87jzbqlhq5.fsf@gmail.com>
References: <20241217020828.28976-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Catherine Hoang <catherine.hoang@oracle.com> writes:

> Add a test to validate the new atomic writes feature.

Thanks!

>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  common/rc         | 14 ++++++++
>  tests/xfs/611     | 81 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/611.out |  2 ++
>  3 files changed, 97 insertions(+)
>  create mode 100755 tests/xfs/611
>  create mode 100644 tests/xfs/611.out
>
> diff --git a/common/rc b/common/rc
> index 2ee46e51..b9da749e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -5148,6 +5148,20 @@ _require_scratch_btime()
>  	_scratch_unmount
>  }
>  
> +_require_scratch_write_atomic()
> +{
> +	_require_scratch
> +	_scratch_mkfs > /dev/null 2>&1
> +	_scratch_mount
> +
> +	export STATX_WRITE_ATOMIC=0x10000
> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_MNT \
> +		| grep atomic >>$seqres.full 2>&1 || \
> +		_notrun "write atomic not supported by this filesystem"
> +
> +	_scratch_unmount
> +}
> +
>  _require_inode_limits()
>  {
>  	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
> diff --git a/tests/xfs/611 b/tests/xfs/611
> new file mode 100755
> index 00000000..a26ec143
> --- /dev/null
> +++ b/tests/xfs/611
> @@ -0,0 +1,81 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 611
> +#
> +# Validate atomic write support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_scratch_write_atomic
> +
> +test_atomic_writes()
> +{
> +    local bsize=$1
> +
> +    _scratch_mkfs_xfs -b size=$bsize >> $seqres.full
> +    _scratch_mount
> +    _xfs_force_bdev data $SCRATCH_MNT
> +
> +    testfile=$SCRATCH_MNT/testfile
> +    touch $testfile
> +
> +    file_min_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile | \
> +        grep atomic_write_unit_min | cut -d ' ' -f 3)
> +    file_max_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile | \
> +        grep atomic_write_unit_max | cut -d ' ' -f 3)
> +    file_max_segments=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile | \
> +        grep atomic_write_segments_max | cut -d ' ' -f 3)
> +
> +    # Check that atomic min/max = FS block size
> +    test $file_min_write -eq $bsize || \
> +        echo "atomic write min $file_min_write, should be fs block size $bsize"
> +    test $file_min_write -eq $bsize || \
> +        echo "atomic write max $file_max_write, should be fs block size $bsize"
> +    test $file_max_segments -eq 1 || \
> +        echo "atomic write max segments $file_max_segments, should be 1"
> +
> +    # Check that we can perform an atomic write of len = FS block size
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D 0 $bsize" $testfile | \

Shouldn't we also have something like below to see whether pwrite supports -A option or not?

_require_xfs_io_command pwrite -A


So maybe like this?

    common/rc: Add support to validate -A option for pwrite

diff --git a/common/rc b/common/rc
index 6592c835..36fbaa53 100644
--- a/common/rc
+++ b/common/rc
@@ -2837,6 +2837,13 @@ _require_xfs_io_command()
                        opts+=" -d"
                        pwrite_opts+="-V 1 -b 4k"
                fi
+               # Let's check if -A option is supported in xfs_io or not
+               if [ "$param" == "-A" ]; then
+                       testio=$($XFS_IO_PROG -f -d -c \
+                                        "pwrite -V 1 -b 4k -A 0 4k" $testfile 2>&1)
+                       echo $testio |grep -q "invalid option" && \
+                               _notrun "xfs_io $command $param support is missing"
+               fi
                testio=`$XFS_IO_PROG -f $opts -c \
                        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
                param_checked="$pwrite_opts $param"


> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"


-ritesh
