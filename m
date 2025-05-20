Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A299461;
	Tue, 20 May 2025 12:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747745650; cv=none; b=dla432HNOivetljVFHKKoF9hdUUs2Cf9is5zdaayND8AhHjoiQHifV0rSyTkFEwvpljWCgIloDr8KktGHzwRukQ/irKlWaiRqzTZFif14DbwOhORKxMQPot2s7VH0ySJXCDaIbFmIMm5OWC/KQa/XruNk+curezyHPN3Dbdnsqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747745650; c=relaxed/simple;
	bh=KuA6h1/SxzK1kBrEC20eTyTqbuQdx7B7p3JTGA8XH1c=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=NGhdluk8kAeKQ5TRyyS7da17UeaNXAD2haoMCqVwy2gpo9csg1RWwoeGXY91f+zDjxBDuPqlQ7zw/1wkxyZ8ojZG2k8ExpRcra1QDrnhFuh0ya+F2LGMC2a4Gi1+Y0sFLueAIfZr3ChYKt4P91TzLORyFLUJDxZgzRyHe2JIERI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GaicDwJK; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GaicDwJK"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-742caef5896so2250466b3a.3;
        Tue, 20 May 2025 05:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747745648; x=1748350448; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WNdHOz5PsoDVfhTVQog7UfIg7ObjYz+hOX4F/EuRvVY=;
        b=GaicDwJKEkKIw8G8Fb7A31vcFxndQEHA4lxaieXnEP/c39AuSlFa6/0T0rw+q+rtV4
         UclXBnfyVZbEJkpqgzUxUSeoSJV2hS517PC9lNYSDnZIK/lbLhWVF98TNEcTOJV4s76E
         zZynwEHH3ljqQ+vr2DxeOCHavG9DNg1OrIYSk7ej+tKPsiGGLvQpF758C3BNfDOMU6gg
         gCqHRh8ckY2xIBhy8hLmXCgTcPARdYWN0N8IWv3ly9cfNTc7iralq11Ty96eMbIl4Yvh
         F1mwl6YpzWolF5Vnmradg6aP40tnYBINuU5dGCJeAFGq7eyx5bU+ROSCZguOhOFIR7Vr
         uxDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747745648; x=1748350448;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WNdHOz5PsoDVfhTVQog7UfIg7ObjYz+hOX4F/EuRvVY=;
        b=nWmKn1bhSLPp3tJcNMB16b15wZVHjvY/J/XfZ5C7+miC9sib3wAsi8YiLYdvDCSib7
         /8+mgEu8vT8rvlmlkZJohrg44XCFD7yXqbT+bExaDy3hWBgaAaHYGATneTHoWksPNKwC
         z7toMIVc5p+X6HmjUEt3/mT846TIVrecGY2nzxs7LthBK71E1OsRK6YBPPCH5uZ2HnBR
         5UffGnZbQ22ElBd5+1N4hOLAEKM98Q37CxigDwKK/3CaY24VAXTOBNbRNjLkgT4FuCWE
         4INuQJYamAiu3J9+UgFhalc4hHHdLiIL8QEg6g8D8B4yUCWBC+zi29afm3vy63AQ52n8
         ipHg==
X-Forwarded-Encrypted: i=1; AJvYcCULBVRGk6Uk25IUS3VbtgLv7r7xVF721hBI+DVNe/sd8Cmn/2i/smn+Y8ltYtOStDhZ6MBhmhsWmos2@vger.kernel.org, AJvYcCULIdvkTqs2cg6KByIGZEaSYvkkPDUxwN/GW6vtsTMLCbBZpFz2AepCZ9ldvARcLVlgk3rCyE5M@vger.kernel.org
X-Gm-Message-State: AOJu0YyC9sxrFGO5brQ9dCAB/t6RUoHdAFxthKKqGEYg+GnZfRWOE3XB
	xios3q4Wxp6rVi/vmVjJjJWFIe1VMW/MNiXMS2wWFSL3b/g555NkE8RJ
X-Gm-Gg: ASbGncvpBYyYL9i3nsJe5+YUckDxEk/ZVFv6eyvIus9iLKY0Kq2iMnM5469uSEPsy7m
	OwFzJcn1/qpd3Qu75KJLqx8OErmgHWlzvjESFSlwPWLURWHpt5mWaahT7K6Pw//Y0lkUUpxu99W
	9n/1Zc2HDdH5Z6/1LuEj2pBpLvU5vqGfnHaUCvPdeIgX+cJfqcOgQSrzQ99RtN3h88/TXArLKnB
	KJ55VC1O+00k2gO2i8JIbPpMj7MIClQwg7nAHxWKOj9Z0xy9sDH42GNl8e9nUs6RE5UePfYemBr
	yEJBrPdM0fxbTA8A2+ONRT2fWvci1trDuco09xkhACM=
X-Google-Smtp-Source: AGHT+IGGH+tUlnYfa62gaIm+e7KQMZFLyHIjMyCYgg9csYPVdOV0/L5CZr90b7HgTyES7H8XGtpgUQ==
X-Received: by 2002:a05:6a21:3993:b0:1f5:56fe:b437 with SMTP id adf61e73a8af0-216219b13demr29922948637.32.1747745647659;
        Tue, 20 May 2025 05:54:07 -0700 (PDT)
Received: from dw-tp ([171.76.82.96])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26eb081aa2sm7990339a12.48.2025.05.20.05.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 05:54:06 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH v2 6/6] generic: various atomic write tests with scsi_debug
In-Reply-To: <20250520013400.36830-7-catherine.hoang@oracle.com>
Date: Tue, 20 May 2025 17:35:30 +0530
Message-ID: <8734czwkqd.fsf@gmail.com>
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
> ---
>  common/atomicwrites    |  10 +++
>  tests/generic/1222     |  86 +++++++++++++++++++++++++
>  tests/generic/1222.out |  10 +++
>  tests/generic/1223     |  66 +++++++++++++++++++
>  tests/generic/1223.out |   9 +++
>  tests/generic/1224     | 140 +++++++++++++++++++++++++++++++++++++++++
>  tests/generic/1224.out |  17 +++++
>  tests/xfs/1216         |  67 ++++++++++++++++++++
>  tests/xfs/1216.out     |   9 +++
>  tests/xfs/1217         |  70 +++++++++++++++++++++
>  tests/xfs/1217.out     |   3 +
>  tests/xfs/1218         |  59 +++++++++++++++++
>  tests/xfs/1218.out     |  15 +++++
>  13 files changed, 561 insertions(+)
>  create mode 100755 tests/generic/1222
>  create mode 100644 tests/generic/1222.out
>  create mode 100755 tests/generic/1223
>  create mode 100644 tests/generic/1223.out
>  create mode 100644 tests/generic/1224
>  create mode 100644 tests/generic/1224.out
>  create mode 100755 tests/xfs/1216
>  create mode 100644 tests/xfs/1216.out
>  create mode 100755 tests/xfs/1217
>  create mode 100644 tests/xfs/1217.out
>  create mode 100644 tests/xfs/1218
>  create mode 100644 tests/xfs/1218.out
>
> diff --git a/common/atomicwrites b/common/atomicwrites
> index 391bb6f6..c75c3d39 100644
> --- a/common/atomicwrites
> +++ b/common/atomicwrites
> @@ -115,3 +115,13 @@ _test_atomic_file_writes()
>      $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
>          echo "atomic write requires offset to be aligned to bsize"
>  }
> +
> +_simple_atomic_write() {
> +	local pos=$1
> +	local count=$2
> +	local file=$3
> +	local directio=$4
> +
> +	echo "testing pos=$pos count=$count file=$file directio=$directio" >> $seqres.full
> +	$XFS_IO_PROG $directio -c "pwrite -b $count -V 1 -A -D $pos $count" $file >> $seqres.full
> +}
> diff --git a/tests/generic/1222 b/tests/generic/1222
> new file mode 100755
> index 00000000..9d02bd70
> --- /dev/null
> +++ b/tests/generic/1222
> @@ -0,0 +1,86 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1222
> +#
> +# Validate multi-fsblock atomic write support with simulated hardware support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/scsi_debug
> +. ./common/atomicwrites
> +
> +_cleanup()
> +{
> +	_scratch_unmount &>/dev/null
> +	_put_scsi_debug_dev &>/dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +_require_scsi_debug
> +_require_scratch_nocheck
> +# Format something so that ./check doesn't freak out
> +_scratch_mkfs >> $seqres.full
> +
> +# 512b logical/physical sectors, 512M size, atomic writes enabled
> +dev=$(_get_scsi_debug_dev 512 512 0 512 "atomic_wr=1")
> +test -b "$dev" || _notrun "could not create atomic writes scsi_debug device"
> +
> +export SCRATCH_DEV=$dev
> +unset USE_EXTERNAL
> +
> +_require_scratch_write_atomic
> +_require_atomic_write_test_commands

Is it possible to allow pwrite -A to be tested on $SCRATCH_MNT rather
than on TEST_MNT? For e.g. 

What happens when TEST_DEV is not atomic write capable? Then this test
won't run even though we are passing scsi_debug which supports atomic writes.

> +
> +echo "scsi_debug atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +echo "filesystem atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> +
> +sector_size=$(blockdev --getss $SCRATCH_DEV)
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
> +echo "all should work"
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
> +_simple_atomic_write $sector_size $min_awu $testfile -d
> +
> +_scratch_unmount
> +_put_scsi_debug_dev
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/generic/1222.out b/tests/generic/1222.out
> new file mode 100644
> index 00000000..158b52fa
> --- /dev/null
> +++ b/tests/generic/1222.out
> @@ -0,0 +1,10 @@
> +QA output created by 1222
> +two EINVAL for unsupported sizes
> +pwrite: Invalid argument
> +pwrite: Invalid argument
> +all should work
> +one EOPNOTSUPP for buffered atomic
> +pwrite: Operation not supported
> +one EINVAL for unaligned directio
> +pwrite: Invalid argument
> +Silence is golden
> diff --git a/tests/generic/1223 b/tests/generic/1223
> new file mode 100755
> index 00000000..8a77386e
> --- /dev/null
> +++ b/tests/generic/1223
> @@ -0,0 +1,66 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1223
> +#
> +# Validate multi-fsblock atomic write support with or without hw support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +
> +_require_scratch
> +_require_atomic_write_test_commands
> +
> +echo "scratch device atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +echo "filesystem atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> +
> +sector_size=$(blockdev --getss $SCRATCH_DEV)
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

If the kernel we are testing on doesn't have SW XFS atomic write patches
and if the scratch device does not support HW atomic write, then this
could cause an infinite loop, right? Since both min_awu and max_awu can
come out to be 0? 

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
> diff --git a/tests/generic/1223.out b/tests/generic/1223.out
> new file mode 100644
> index 00000000..edf5bd71
> --- /dev/null
> +++ b/tests/generic/1223.out
> @@ -0,0 +1,9 @@
> +QA output created by 1223
> +two EINVAL for unsupported sizes
> +pwrite: Invalid argument
> +pwrite: Invalid argument
> +one EOPNOTSUPP for buffered atomic
> +pwrite: Operation not supported
> +one EINVAL for unaligned directio
> +pwrite: Invalid argument
> +Silence is golden


Will continue reviewing from g/1224 and will let you know if I
have any comments.

-ritesh
