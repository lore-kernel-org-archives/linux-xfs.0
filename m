Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA323271F7
	for <linux-xfs@vger.kernel.org>; Wed, 19 Nov 2025 10:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763546842; cv=none; b=kNJRQ8/wnQWKJwkK+ZBAa37rgtQcRvaY/qfcd5VVcBhqUtpC5V6qrXdjg6NCwBZwVWmOKPoUQHJ30UDxkJBnD/DNZ4mXI7FXL3jJlNxAkzAIigYKiSzXh4Rg3XLc7JJOpsNeyZGz6W/onTci7DtPoQjmEFmv5pd2W1NhiKBuSYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763546842; c=relaxed/simple;
	bh=a0fZsPHfFz6EIOKiJRlhIKx4YZ9/MoQhh76o2pEkfS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nlATYegO8ed1qWz7NGwAbFZa/yxma2Phb0+ff9iW9V/JoVGgPfvqNNCvZ778KBZbSoPokoSlKzst9Ep5i8ojs0LSkXd/2Hj/6NCOiUqCMsKIdAcphkcKki1x5ZcDfGkU85OFGxxsvNixxCMfvGYOFza9/PILkiDWjqF0rEN/f/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e4g2nJZm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OJd9crNx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e4g2nJZm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OJd9crNx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763546839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WszxwMa10KM0DX9YUmjHkdh+SdZBhe4zpc44s1sPiFE=;
	b=e4g2nJZmdJirvctCTsvj2X7jcAhQ1DDpQl8vhLiAh8I3GqV6QYDSWzw/4OjREKUneEbHpQ
	WQs9FlT3hvyE0YM9yupo/pgxzUyovgrvclgYja1bsONS+sxaxLD3bfAf+4uE9lzB0xkxbH
	1umpfs7nx3bsDCwOGbz9ZHPEWd0L6fk=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-lKYvthgzN26hpqZC1mOMUg-1; Wed, 19 Nov 2025 05:07:15 -0500
X-MC-Unique: lKYvthgzN26hpqZC1mOMUg-1
X-Mimecast-MFC-AGG-ID: lKYvthgzN26hpqZC1mOMUg_1763546835
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-29806c42760so239343865ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 19 Nov 2025 02:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763546835; x=1764151635; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WszxwMa10KM0DX9YUmjHkdh+SdZBhe4zpc44s1sPiFE=;
        b=OJd9crNxBWT2DbEI+Wbh771CJhSSuVPjpHAudc8jSwg0oJTkz5XGbFi7ckp+6l2l+g
         5NGmmyvJIkjTO+gzgxLX4YlF4MCO14+CumxcxV8Ez53fPrmuhb1IfdX/dAGzgApqpZbx
         4yqHh20QaGjtpa/WcBKCL70IGAuLabG2sMljDjWKJDsmCtXCHmNcyYQq5M5EyFNyzyrr
         gkVoXtDdTRSHDyyaaOjC5qcRtvILoI0NaxjpZUzdw/QkBRNChP2CIwkrdX6ZeBcqCoDT
         YRlw5/vh6aI7PLMbizatn2+cBkFL4J2ARPKH4V7SkmbRpextdmHrLvOifY9JSFO1/1E5
         h6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763546835; x=1764151635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WszxwMa10KM0DX9YUmjHkdh+SdZBhe4zpc44s1sPiFE=;
        b=f3j1p3pgiWqwXQ3zw9fb+W5B0WdPf5OGSyjoxBT2BhvuXohaNTekUUHMQP6kEi70vc
         rzSugL8oRGxUpbb5bvt/ecAZnR43Fktn/bN3ilULVK2Mq4IKhCZkipt0nXWbgMBjWEkt
         Af9UYo6AAz9/+y7NVFDHE3+6RcgTwrt/lccyOlUjDLqwuxK6D7rSADVlugrFxCbsIISy
         aHvuatsUBW8kQYDjcVCWsQn17rGe8QIntlZQ2eVmfnMdQwhT0aGPK7EZfMpI9XsD1/Jl
         TpFparx5SIG4fP1+phYI6IdAQBqBjExFOVxVOks+65CJgdwl3t2spiAA32RQur/lGFMc
         9Oww==
X-Gm-Message-State: AOJu0YwvHWVusN6GhaqiGCljLRgL0LYFk9c39LIFU22JfdhnprxNT4L+
	GKEvy8UmR11rj2KFWHpwDCL78VFGHBgyyWN0zEWLroP9wJL8KPBK7H8D+gGXMekDzopGM+KjLo2
	9FNXeNBZkF8JNiEztuVOP6c6PqOeR+jhvXA+hSuMCXQ578vJ54kuWgSrg+Ev+Qg==
X-Gm-Gg: ASbGnctAnQ7yP/hTb0aoRt9qtOxYGdDGpju8qqoObFFLVIesd8nxc42e84jRo+s8F02
	kYcLIS+68qpp2rZbxvWE27Zh4meEFVy3/3cz6hdXUb0G4cSO7v1gy10ExXNfSyLLTqhAdVmBGGG
	1Pdk1qaj0AbSAFpNaXSdPZSmfSRTy2Wq6OCjylmVBboKDHNVo+ueHvcOGEML9ftbOZrwmA4RxwR
	ohD3jPFMHQ+PxjLmUlmd6/z39+Pyjcsa5orP5FpI3sFhN3NYV5GYjcDvTuo11M7GpeK4nprYiwY
	lReMqosDmVcoPMDRt/u05VzvEV2dDkjaeYdaVw2QIBqaLGmDI9mxHtQvyBKROHrUtKGxLnz9wB/
	c22y/UC83inRg5yA+9AdepX2xLhjV+1gZxTT66MzPrwAzLKU6Zw==
X-Received: by 2002:a17:903:1b04:b0:269:b6c8:4a4b with SMTP id d9443c01a7336-2986a6b89ebmr223119725ad.6.1763546834479;
        Wed, 19 Nov 2025 02:07:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFnRlAWY0+IJsNWg8uhnENCS8pxXs/DxCJDD7YFCP4cmcvQBqp8i4OVfIF68+04tjbQvVoqQ==
X-Received: by 2002:a17:903:1b04:b0:269:b6c8:4a4b with SMTP id d9443c01a7336-2986a6b89ebmr223119345ad.6.1763546833902;
        Wed, 19 Nov 2025 02:07:13 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b0c92sm202872115ad.69.2025.11.19.02.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 02:07:13 -0800 (PST)
Date: Wed, 19 Nov 2025 18:07:09 +0800
From: Zorro Lang <zlang@redhat.com>
To: Donald Douwsma <ddouwsma@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	Zorro Lang <zlang@kernel.org>
Subject: Re: [PATCH v3] xfs: test case for handling io errors when reading
 extended attributes
Message-ID: <20251119100709.zbkenjwztblkjobd@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251119041210.2385106-1-ddouwsma@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119041210.2385106-1-ddouwsma@redhat.com>

On Wed, Nov 19, 2025 at 03:12:10PM +1100, Donald Douwsma wrote:
> We've seen reports from the field panicking in xfs_trans_brelse after an
> IO error when reading an attribute block.
> 
> sd 0:0:23:0: [sdx] tag#271 CDB: Read(16) 88 00 00 00 00 00 9b df 5e 78 00 00 00 08 00 00
> critical medium error, dev sdx, sector 2615107192 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class 2
> XFS (sdx1): metadata I/O error in "xfs_da_read_buf+0xe1/0x140 [xfs]" at daddr 0x9bdf5678 len 8 error 61
> BUG: kernel NULL pointer dereference, address: 00000000000000e0
> ...
> RIP: 0010:xfs_trans_brelse+0xb/0xe0 [xfs]
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> 
> ---
> V3
> - Zorro's suggestions (_require_scsi_debug, _require_scratch, ..., use _get_file_block_size
>   drop dry_run, fix local variables and parameters, common/attr, ...)
> - Override SELINUX_MOUNT_OPTIONS to avoid _scratch_mount breaking the test
> - Add test to quick attr
> - Change test_attr() to work with blocks instead of bytes
> - Name the scsi_debug options to make it clearer where the error is active
> - Determine size of the attr value required based on filesystem block size
> V2
> - As this is specific to ENODATA test using scsi_debug instead of dmerror
> which returns EIO.
> ---
>  common/scsi_debug |   8 ++-
>  tests/xfs/999     | 139 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out |   2 +
>  3 files changed, 148 insertions(+), 1 deletion(-)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> diff --git a/common/scsi_debug b/common/scsi_debug
> index 1e0ca255..c3fe7be6 100644
> --- a/common/scsi_debug
> +++ b/common/scsi_debug
> @@ -6,6 +6,7 @@
>  
>  . common/module
>  
> +# _require_scsi_debug [mod_param]
>  _require_scsi_debug()
>  {
>  	local mod_present=0
> @@ -30,9 +31,14 @@ _require_scsi_debug()
>  			_patient_rmmod scsi_debug || _notrun "scsi_debug module in use"
>  		fi
>  	fi
> +
>  	# make sure it has the features we need
>  	# logical/physical sectors plus unmap support all went in together
> -	modinfo scsi_debug | grep -wq sector_size || _notrun "scsi_debug too old"
> +	grep -wq sector_size <(modinfo scsi_debug) || _notrun "scsi_debug too old"
> +	# make sure it supports this module parameter
> +	if [ -n "$1" ];then
> +		grep -Ewq "$1" <(modinfo scsi_debug) || _notrun "scsi_debug not support $1"
> +	fi
>  }
>  
>  # Args: [physical sector size, [logical sector size, [unaligned(0|1), [size in megs]]]]
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 00000000..2a571195
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,139 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Red Hat Inc.  All Rights Reserved.
> +#
> +# FS QA Test 999
> +#
> +# Regression test for panic following IO error when reading extended attribute blocks
> +#
> +#   XFS (sda): metadata I/O error in "xfs_da_read_buf+0xe1/0x140 [xfs]" at daddr 0x78 len 8 error 61
> +#   BUG: kernel NULL pointer dereference, address: 00000000000000e0
> +#   ...
> +#   RIP: 0010:xfs_trans_brelse+0xb/0xe0 [xfs]
> +#
> +# For SELinux enabled filesystems the attribute security.selinux will be
> +# created before any additional attributes are added. In this case the
> +# regression will trigger via security_d_instantiate() during a stat(2),
> +# without SELinux this should trigger from fgetxattr(2).
> +#
> +# Kernels prior to v4.16 don't have medium_error_start, and only return errors
> +# for a specific location, making scsi_debug unsuitable for checking old
> +# kernels. See d9da891a892a scsi: scsi_debug: Add two new parameters to
> +# scsi_debug driver
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick attr
> +
> +_fixed_by_kernel_commit ae668cd567a6 \
> +	"xfs: do not propagate ENODATA disk errors into xattr code"
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	_unmount $SCRATCH_MNT 2>/dev/null
> +	_put_scsi_debug_dev
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# Import common functions.
> +. ./common/attr
> +. ./common/scsi_debug
> +
> +_require_scratch_nocheck
> +_require_scsi_debug "medium_error_start"
> +_require_attrs user
> +
> +# If SELinux is enabled common/config sets a default context, which which breaks this test.
                                                                       ^^^^^

> +export SELINUX_MOUNT_OPTIONS=""
> +
> +scsi_debug_dev=$(_get_scsi_debug_dev)
> +scsi_debug_opt_noerror=0
> +scsi_debug_opt_error=${scsi_debug_opt_error:=2}
> +test -b $scsi_debug_dev || _notrun "Failed to initialize scsi debug device"
> +echo "SCSI debug device $scsi_debug_dev" >>$seqres.full
> +
> +SCRATCH_DEV=$scsi_debug_dev
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +
> +block_size=$(_get_file_block_size $SCRATCH_MNT)
> +inode_size=$(_xfs_get_inode_size $SCRATCH_MNT)
> +error_length=$((block_size/512)) # Error all sectors in the block
> +
> +echo Block size $block_size >> $seqres.full
> +echo Inode size $inode_size >> $seqres.full
> +
> +test_attr()
> +{
> +	local test=$1
> +	local testfile=$SCRATCH_MNT/$test
> +	local attr_blocks=$2
> +	local error_at_block=${3:-0}
> +
> +	local attr_size_bytes=$((block_size/2*attr_blocks))
> +
> +	# The maximum size for a single value is ATTR_MAX_VALUELEN (64*1024)
> +	# If we wanted to test a larger range of extent combinations the test
> +	# would need to use multiple values.
> +	[[ $attr_size_bytes -ge 65536 ]] && echo "Test would need to be modified to support > 64k values for $attr_blocks blocks".
> +
> +	echo $scsi_debug_opt_noerror > /sys/module/scsi_debug/parameters/opts
> +
> +	echo -e "\nTesting : $test" >> $seqres.full
> +	echo -e "attr size: $attr_blocks" >> $seqres.full
> +	echo -e "error at block: $error_at_block\n" >> $seqres.full
> +
> +	touch $testfile
> +	local inode=$(stat -c '%i' $testfile)
> +	$SETFATTR_PROG -n user.test_attr -v $(printf "%0*d" $attr_size_bytes $attr_size_bytes) $testfile
> +
> +	$XFS_IO_PROG -c "bmap -al" $testfile >> $seqres.full
> +	start_blocks=($($XFS_IO_PROG -c "bmap -al" $testfile | awk 'match($3, /[0-9]+/, a) {print a[0]}'))
        ^^^^^^^^^^^^
        local start_blocks


OK, so you still don't want to use:

  local start_blocks=$(_scratch_xfs_get_metadata_field "a.bmx[0].startblock" "inode $inode")

Anyway, both ways are good to get the start_blocks for this case. So ... (don't need to send v4)

Reviewed-by: Zorro Lang <zlang@redhat.com>

> +	echo "Attribute fork extent(s) start at ${start_blocks[*]}" >> $seqres.full
> +
> +	_scratch_unmount
> +
> +	echo "Dump inode $inode details with xfs_db" >> $seqres.full
> +	_scratch_xfs_db -c "inode $inode" -c "print core.aformat core.naextents a" >> $seqres.full
> +
> +	if [[ start_blocks[0] -ne 0 ]]; then
> +		# Choose the block to error, currently only works with a single extent.
> +		error_daddr=$((start_blocks[0] + error_at_block*block_size/512))
> +	else
> +		# Default to the inode daddr when no extents were found.
> +		# Errors when getfattr(1) stats the inode and doesnt get to getfattr(2)
> +		error_daddr=$(_scratch_xfs_db -c "inode $inode" -c "daddr" | awk '{print $4}')
> +	fi
> +
> +	_scratch_mount
> +
> +	echo "Setup scsi_debug to error when reading attributes from block" \
> +	     "$error_at_block at daddr $error_daddr" >> $seqres.full
> +	echo $error_daddr > /sys/module/scsi_debug/parameters/medium_error_start
> +	echo $error_length > /sys/module/scsi_debug/parameters/medium_error_count
> +	echo $scsi_debug_opt_error > /sys/module/scsi_debug/parameters/opts
> +	grep ^ /sys/module/scsi_debug/parameters/{medium_error_start,medium_error_count,opts} >> $seqres.full
> +
> +	echo "Read the extended attribute on $testfile" >> $seqres.full
> +	sync # the fstests logs to disk.
> +
> +	_getfattr -d -m - $testfile >> $seqres.full 2>&1 # Panic here on failure
> +}
> +
> +# aformat shortform
> +test_attr "attr_local" 0 0
> +
> +# aformat extents
> +# Single leaf block, known to panic
> +test_attr "attr_extent_one_block" 1 0
> +
> +# Other tests to exercise multi block extents
> +test_attr "attr_extent_two_blocks_1" 2 1
> +test_attr "attr_extent_two_blocks_2" 2 2
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> new file mode 100644
> index 00000000..3b276ca8
> --- /dev/null
> +++ b/tests/xfs/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +Silence is golden
> -- 
> 2.47.3
> 
> 

