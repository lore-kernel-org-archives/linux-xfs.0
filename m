Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B57515CD74;
	Wed, 21 May 2025 05:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747803623; cv=none; b=sFywN1b4cNdeTudcK7JEDpvjQLaK1nGPMqnMdNaVrfaAkW0V9KRl6psOKmg9i4bBQuJFGA6nMzwPbPg3FFxoySiqXJWBu7aMuQOkRxl6B+HohmmLP2CqItp2MO0KhmoILjV6VZaB4/mVhYNjQZetA8HCQXVpUwfReR3xue0tETE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747803623; c=relaxed/simple;
	bh=N8lKj+VtIBIbNrdFpoZqbuL/lshQrhSImqR+C0CiPCw=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=LSANkQa5ws+gAyVSW/bduJhvN7D+MMIygeAukIeNmBPwKQf8Hf52G2mFy18NyhejA5UVhW8oVA2reWm84RWBHtWKEjTrEX4gvTVCAHnEeGf24EineFsevql+SYpelGDFww+rnsZSgAJY3SnSo00xE4hM4ZJLbWsn4ZxGgud0qvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LDROsW2s; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LDROsW2s"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-30f0d8628c8so2029093a91.0;
        Tue, 20 May 2025 22:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747803620; x=1748408420; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=245JFheitocBNFaoaYPfPio6Yt/GuGU0XnWLiFu7Tiw=;
        b=LDROsW2szuBEf2/rXAeA8zj4crvfYkkWwMZFE+c4c95LAcEUIlrQFIt/LvlHBNx0r8
         ubPzI4YLd0dCd3Cdb07lBGMyMzSM0mDNBzqGpq0e9DWclZyD9Z20hirShOFqsgkPPZ4f
         WvnnqE6wUTqc7iw8QtlhfYG4jGLpkJB0WilsvkqiUUo/h6+uKhDvPG+FesXIXjbcEz1m
         4OI+smuZMYhasiJzK8S5rkfi9R3RBnFGz2Cc/9WvqJ0kuPRdQGe3RCyUS3x0cofUAeog
         ed/nEM4YZoWMaTUmsGA66BLkpyEuqvR0iU+y/wXU4xCDlL/3ZkaDNadfZXWNP1PkHtkx
         yXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747803620; x=1748408420;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=245JFheitocBNFaoaYPfPio6Yt/GuGU0XnWLiFu7Tiw=;
        b=UBvPX9tyBJc1NdmwcUQThmWRmdrqnEmRQEL9zwV3y0T0fT+LfANi8ZWIp+53AChrYd
         XFewRMjDIexM8TryB6qIeA/ed8FfbLipf5B2cPYyrWVZ06qGz0VHqCqU7xuZ3DFQT/pf
         +Ecyh713tRZHT7WEe3hQX78nV8hyXUX/tOuk3mrPudAILSvm9c5SaUemaeH6KCCbBHww
         jB3L2K2R5y42+kz5DwYh1ffqUosDMWC27izHChhG/tJgFtr4uzQqT85rHqpkxV473dpy
         VxhLZUs7eHzhdhFXUdMTIfshTSp5SHtk22d/Voycx9iSLnQWBh5FTErjjwDxxFiZrnbP
         a5RA==
X-Forwarded-Encrypted: i=1; AJvYcCV6KFUOiydjeFSW1ke62K82ASWZmAVWevw0dFgidk0eNkefrPYc06E2IM/ZE8rzWcxUpqOcgnV41+nv@vger.kernel.org, AJvYcCXINh6wdVBr+YpecfmB5uurbvtUNTtSlMlERLLpc2MdG0gFUUsGoOt1sqOuIhiOGv41/vnHb3Nb@vger.kernel.org
X-Gm-Message-State: AOJu0YzwA1GKjaC0MGQDdrqsI232GUDWEO0SVA4KdV8qiU89r2vjVg90
	RzbJ9L7XVoedwvppNxMOhlakBDsdgoAeS15lFlwhaPjMI7YrY/lFCdTr4F8HitRlTOg=
X-Gm-Gg: ASbGncvtHAk5HSQU2KEatDXLtNxG/bcNR7POtQ1SwaQq0aOglZMjXD4b7vemm8odErH
	K+5vbXQyGYhCfh1wF5a8CP4mDK8S42Kcooe1saeuhd0ivDP1feXDiD6HxH+wHUS0ShBmgk9VKnn
	n3lhBPFUWCw8OPaxWe0bPsm8HmBwJH6x65QwXVJkl0op0PvfBzeGzT4dUYhT83xUGll8iic3Xn3
	dRlaOUAYDcUpZl+n4WcQadOffBJfYEIONqrAXSB/abp32SQETPiiZGPqYsqfMKA/faWtbGGt9kA
	qf5IIXWsRzzIj5PKbpDvIUkCXnpiUSepaiaT9u85Qkbn
X-Google-Smtp-Source: AGHT+IH6nTBsbCgZaXSlVOlMZbzMekxsQMxv6FM1DcvKe/ZgM3r656Gab4ZMcnN9EcH4cCl+eB3Qsg==
X-Received: by 2002:a17:90b:520f:b0:2fa:6793:e860 with SMTP id 98e67ed59e1d1-30e4d98fc12mr38397534a91.0.1747803620247;
        Tue, 20 May 2025 22:00:20 -0700 (PDT)
Received: from dw-tp ([171.76.84.129])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f36368ecbsm2709859a91.8.2025.05.20.22.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 22:00:19 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH v2 6/6] generic: various atomic write tests with scsi_debug
In-Reply-To: <20250520013400.36830-7-catherine.hoang@oracle.com>
Date: Wed, 21 May 2025 10:13:15 +0530
Message-ID: <871psiwp3w.fsf@gmail.com>
References: <20250520013400.36830-1-catherine.hoang@oracle.com> <20250520013400.36830-7-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Catherine Hoang <catherine.hoang@oracle.com> writes:

> From: "Darrick J. Wong" <djwong@kernel.org>
>
> Simple tests of various atomic write requests and a (simulated) hardware
> device.
>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
<...>

> diff --git a/tests/generic/1224 b/tests/generic/1224
> new file mode 100644
> index 00000000..fb178be4
> --- /dev/null
> +++ b/tests/generic/1224
> @@ -0,0 +1,140 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1224
> +#
> +# test large atomic writes with mixed mappings
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +. ./common/filter
> +. ./common/reflink
> +
> +_require_scratch
> +_require_atomic_write_test_commands
> +_require_xfs_io_command pwrite -A
> +_require_cp_reflink
> +
> +_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
> +_scratch_mount
> +
> +file1=$SCRATCH_MNT/file1
> +file2=$SCRATCH_MNT/file2
> +file3=$SCRATCH_MNT/file3
> +
> +touch $file1
> +
> +max_awu=$(_get_atomic_write_unit_max $file1)
> +test $max_awu -ge 262144 || _notrun "test requires atomic writes up to 256k"
> +
> +min_awu=$(_get_atomic_write_unit_min $file1)
> +test $min_awu -le 4096 || _notrun "test requires atomic writes down to 4k"
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +test $max_awu -gt $((bsize * 2)) || \
> +	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
> +
> +# reflink tests (files with shared extents)
> +
> +# atomic write shared data and unshared+shared data
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# atomic write shared data and shared+unshared data
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# atomic overwrite unshared data
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# atomic write shared+unshared+shared data
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# atomic write interweaved hole+unwritten+written+reflinked
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +blksz=4096
> +nr=32
> +_weave_reflink_rainbow $blksz $nr $file1 $file2 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# non-reflink tests

Can we split these non-reflink tests into a separate test, so that ext4
could use the same?


> +
> +# atomic write hole+mapped+hole
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write adjacent mapped+hole and hole+mapped
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write mapped+hole+mapped
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write at EOF
> +dd if=/dev/zero of=$file1 bs=128K count=3 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 262144 262144" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write preallocated region
> +fallocate -l 10M $file1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write max size
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +aw_max=$(_get_atomic_write_unit_max $file1)
> +cp $file1 $file1.chk
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 $aw_max" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -c "pwrite 0 $aw_max" $file1.chk >>$seqres.full 2>&1
> +cmp -s $file1 $file1.chk || echo "file1 doesnt match file1.chk"
> +#md5sum $file1 | _filter_scratch

I guess atomic write max size above is not really doing any atomic
writes. No -A options provided? 
Also a left out comment of md5sum can be fixed.


> +
> +# atomic write max size on fragmented fs
> +avail=`_get_available_space $SCRATCH_MNT`
> +filesizemb=$((avail / 1024 / 1024 - 1))
> +fragmentedfile=$SCRATCH_MNT/fragmentedfile
> +$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $fragmentedfile
> +$here/src/punch-alternating $fragmentedfile
> +touch $file3
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file3 >>$seqres.full 2>&1
> +md5sum $file3 | _filter_scratch

Nice :)

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1224.out b/tests/generic/1224.out
> new file mode 100644
> index 00000000..1c788420
> --- /dev/null
> +++ b/tests/generic/1224.out
> @@ -0,0 +1,17 @@
> +QA output created by 1224
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +4edfbc469bed9965219ea80c9ae54626  SCRATCH_MNT/file1
> +93243a293a9f568903485b0b2a895815  SCRATCH_MNT/file2
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +75572c4929fde8faf131e84df4c6a764  SCRATCH_MNT/file1
> +27a248351cd540bc9ac2c2dc841abca2  SCRATCH_MNT/file1
> +27c9068d1b51da575a53ad34c57ca5cc  SCRATCH_MNT/file3

Nit: Can we add the test name above each checksum to identify it easily? 

e.g.
atomic write shared+unshared+shared data
f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
atomic write at EOF
75572c4929fde8faf131e84df4c6a764  SCRATCH_MNT/file1


> diff --git a/tests/xfs/1216 b/tests/xfs/1216
> new file mode 100755
> index 00000000..04aa77fe
> --- /dev/null
> +++ b/tests/xfs/1216
> @@ -0,0 +1,67 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1216
> +#
> +# Validate multi-fsblock realtime file atomic write support with or without hw
> +# support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +
> +_require_realtime
> +_require_scratch
> +_require_atomic_write_test_commands
> +
> +echo "scratch device atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_RTDEV >> $seqres.full
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +echo "filesystem atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> +
> +sector_size=$(blockdev --getss $SCRATCH_RTDEV)
> +min_awu=$(_get_atomic_write_unit_min $testfile)
> +max_awu=$(_get_atomic_write_unit_max $testfile)
> +
> +$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +
> +# try outside the advertised sizes
> +echo "two EINVAL for unsupported sizes"
> +min_i=$((min_awu / 2))
> +_simple_atomic_write $min_i $min_i $testfile -d
> +max_i=$((max_awu * 2))
> +_simple_atomic_write $max_i $max_i $testfile -d
> +
> +# try all of the advertised sizes
> +for ((i = min_awu; i <= max_awu; i *= 2)); do
> +	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +	_test_atomic_file_writes $i $testfile
> +	_simple_atomic_write $i $i $testfile -d
> +done
> +
> +# does not support buffered io
> +echo "one EOPNOTSUPP for buffered atomic"
> +_simple_atomic_write 0 $min_awu $testfile
> +
> +# does not support unaligned directio
> +echo "one EINVAL for unaligned directio"
> +if [ $sector_size -lt $min_awu ]; then
> +	_simple_atomic_write $sector_size $min_awu $testfile -d
> +else
> +	# not supported, so fake the output
> +	echo "pwrite: Invalid argument"
> +fi
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit

Can we split tests/xfs/121{6,7,8} into a separate patch please?
Will be just easier to review XFS atomicwrites tests separately.


Thanks!
-ritesh

> diff --git a/tests/xfs/1216.out b/tests/xfs/1216.out
> ...
