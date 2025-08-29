Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69213224B09
	for <linux-xfs@vger.kernel.org>; Fri, 29 Aug 2025 19:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496996; cv=none; b=K9hlzMEDylNrBkk3gT4Eb8ULCtzJRcZder/gbXMRJqpdJD62kokBTt24CIZLkl65UxElmaUg0ndoybethiDH48Y6Jo4mTBsbmXEFsoh624PyJpNBw4Uvz77ueTwHcdUEO7DWtF58Hchxz7ZQnGqPVWrHLRlhakITZAomgSuyDyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496996; c=relaxed/simple;
	bh=a5eFrNkIcDrXe+Puhx3mGU4LOKgNBCBNHfW+ZFDpoWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kKYLmW9eu/+Nvc2R4zJP4lKizPHRev6nd2cAfjFVN49vHW7A4z4ySc+dvvZC+0+/HN+A73klu0DDD/W8GLYErqpEfQ9QVYkUeFzTdFpfetOUa9yeRUCBlgvYTVmEePGiVvYomFCLtgWewuN4NTx2mFtJAkXBwL6rcMWAOUchtak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IOtfL8Nz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IOtfL8Nz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756496993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RMdIQN66cD/YcQY6Z/a5UCF1NEW1DiO9Izgj9G8g51E=;
	b=IOtfL8NzbsrojT+LqYb6CFNN95tmMC42uSEhdR/dIT3SMIDcq339pvfaFpMAuHi42YpohV
	nCmbvFIYZWnY91RI37/bye5Pbf7+fKS/FmZO5nQqkF+iaebQ7ZTSFDkpD5AzjWsXtn7UPA
	gHapgksaXFzBkK/tFYz8uzwAyH3QmEg=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-_K9a6fqiNeOqWYm0mG-Z1w-1; Fri, 29 Aug 2025 15:49:50 -0400
X-MC-Unique: _K9a6fqiNeOqWYm0mG-Z1w-1
X-Mimecast-MFC-AGG-ID: _K9a6fqiNeOqWYm0mG-Z1w_1756496989
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b47253319b8so2028361a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 29 Aug 2025 12:49:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756496989; x=1757101789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RMdIQN66cD/YcQY6Z/a5UCF1NEW1DiO9Izgj9G8g51E=;
        b=iZwnOgYVjtciVOQ8wb6F6as6LgtF5Pve5d+3PdAJ1ICCNMeD9OLeO4JLE46PAGCPcH
         8C8E41HNV0t05vitVBiB6D+8slb/pI5srH2uJBJj5BGldTfmX2fUuObGqiWZSJSi29uP
         rrlOKHxTTAtxuJqAIrnUWG9hIx912mbH55jkkjCdncbPH4J4G/ZjrnBzzrAXXXwNZvBZ
         Lm62RmkpkWvgZ+qvnNKhOlxuG1t/DmW4vnIWKhKcaeNsaKot9Cn5dSo6hiPTYLb57+nr
         Hhb79sXkjpsPS7pEpAtQyaLQ1Ga5YSapovRjNt1N6Ih4iDPyEUaWtdxRvH07+uXKD1l1
         sUVA==
X-Gm-Message-State: AOJu0YxGmDAfMr0q87MO4b6X9En4voycDjkiEyYVAcVy9OO2DaiKEHX3
	fEyHQVZQHODbaL8kcYir3tj52FqFppv607bQwxldha7GG0FkHSH3UFnw3OS0cHR7rjuW3xdKWMl
	fV2y3xD5/DPPcjyTeAjnmdxH6r9G4y+VGTqHNQ4PocBuAdrPBgOT6XmkgFJjRxw==
X-Gm-Gg: ASbGnctMGIvc10htEgIrGYk4dNzUXDk0k4dCEhLMs2SP1cBVbS9/9kZC5CvqXxWhnHL
	9bdiQVEJZRq0sVEdli90OMjmhkqODPbQIRNvAkmF3ftXKjJGya14Z3kokIA5ifnJ+ttQ0XQQ7B6
	r/UIWQep+Rv5H8sxvstQmzCIPUL2AlrWNjQ1OrLWzrzC5/G3+MJNLFSvbhYQoD2HlzkI6RZl3Tb
	bHwt5BeJ0PF0H3d4lmp0PuNGfec9retsv/w9nlEr0hTJkMKX8/O6EvhfJbJjlU15lv72uJ8q+GS
	+bGE3u4aXJ5VfXjKr75MbXCeDdmiZoeZWyb74pXN9kJab68JFiwTLCeP3x8BhlDsB1vLTUJWdFw
	OWbFf
X-Received: by 2002:a05:6a20:9144:b0:243:d1bd:fbb8 with SMTP id adf61e73a8af0-243d1be0540mr2137563637.45.1756496989209;
        Fri, 29 Aug 2025 12:49:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJFXWKvEUk8NkIVE1vKO1pzKN6LKOy8f1M6xCrqPnVaW/CcwDFrYxjVr/EGngHYNjG/wTXEw==
X-Received: by 2002:a05:6a20:9144:b0:243:d1bd:fbb8 with SMTP id adf61e73a8af0-243d1be0540mr2137527637.45.1756496988673;
        Fri, 29 Aug 2025 12:49:48 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4cd073be18sm2875752a12.14.2025.08.29.12.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 12:49:48 -0700 (PDT)
Date: Sat, 30 Aug 2025 03:49:43 +0800
From: Zorro Lang <zlang@redhat.com>
To: Donald Douwsma <ddouwsma@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	Eric Sandeen <sandeen@sandeen.net>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH v2] xfs: test case for handling io errors when reading
 extended attributes
Message-ID: <20250829194943.bqzecrnelwze6svp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250829042419.1084367-1-ddouwsma@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829042419.1084367-1-ddouwsma@redhat.com>

On Fri, Aug 29, 2025 at 02:24:19PM +1000, Donald Douwsma wrote:
> We've seen reports from the field panicing in xfs_trans_brelse after
> an io error for an attribute block.
> 
> sd 0:0:23:0: [sdx] tag#271 CDB: Read(16) 88 00 00 00 00 00 9b df 5e 78 00 00 00 08 00 00
> critical medium error, dev sdx, sector 2615107192 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class 2
> XFS (sdx1): metadata I/O error in "xfs_da_read_buf+0xe1/0x140 [xfs]" at daddr 0x9bdf5678 len 8 error 61
> BUG: kernel NULL pointer dereference, address: 00000000000000e0
> ...
> RIP: 0010:xfs_trans_brelse+0xb/0xe0 [xfs]
> ...
> Call Trace:
>  <TASK>
>  ...
>  ? xfs_trans_brelse+0xb/0xe0 [xfs]
>  xfs_attr_leaf_get+0xb6/0xc0 [xfs]
>  xfs_attr_get+0xa0/0xd0 [xfs]
>  xfs_xattr_get+0x75/0xb0 [xfs]
>  __vfs_getxattr+0x53/0x70
>  inode_doinit_use_xattr+0x63/0x180
>  inode_doinit_with_dentry+0x196/0x510
>  security_d_instantiate+0x2f/0x50
>  d_splice_alias+0x46/0x2b0
>  xfs_vn_lookup+0x8b/0xb0 [xfs]
>  __lookup_slow+0x84/0x130
>  walk_component+0x158/0x1d0
>  path_lookupat+0x6e/0x1c0
>  filename_lookup+0xcf/0x1d0
>  vfs_statx+0x8d/0x170
>  vfs_fstatat+0x54/0x70
>  __do_sys_newfstatat+0x26/0x60
> 
> As this is specific to ENODATA test using scsi_debug instead of dmerror
> which returns EIO.
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
>  tests/xfs/999     | 193 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out |   2 +
>  2 files changed, 195 insertions(+)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 00000000..2a45eb7c
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,193 @@
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
> +#   [53887.310123] Call Trace:
> +#    <TASK>
> +#    ? show_trace_log_lvl+0x1c4/0x2df
> +#    ? show_trace_log_lvl+0x1c4/0x2df
> +#    ? xfs_attr_leaf_get+0xb6/0xc0 [xfs]
> +#    ? __die_body.cold+0x8/0xd
> +#    ? page_fault_oops+0x134/0x170
> +#    ? xfs_trans_read_buf_map+0x133/0x300 [xfs]
> +#    ? exc_page_fault+0x62/0x150
> +#    ? asm_exc_page_fault+0x22/0x30
> +#    ? xfs_trans_brelse+0xb/0xe0 [xfs]
> +#    xfs_attr_leaf_get+0xb6/0xc0 [xfs]
> +#    xfs_attr_get+0xa0/0xd0 [xfs]
> +#    xfs_xattr_get+0x88/0xd0 [xfs]
> +#    __vfs_getxattr+0x7b/0xb0
> +#    inode_doinit_use_xattr+0x63/0x180
> +#    inode_doinit_with_dentry+0x196/0x510
> +#    security_d_instantiate+0x3a/0xb0
> +#    d_splice_alias+0x46/0x2b0
> +#    xfs_vn_lookup+0x8b/0xb0 [xfs]
> +#    __lookup_slow+0x81/0x130
> +#    walk_component+0x158/0x1d0
> +#    ? path_init+0x2c5/0x3f0
> +#    path_lookupat+0x6e/0x1c0
> +#    filename_lookup+0xcf/0x1d0
> +#    ? tlb_finish_mmu+0x65/0x150
> +#    vfs_statx+0x82/0x160
> +#    vfs_fstatat+0x54/0x70
> +#    __do_sys_newfstatat+0x26/0x60
> +#    do_syscall_64+0x5c/0xe0
> +#
> +# For SELinux enabled filesystems the attribute security.selinux will be
> +# created before any additional attributes are added. Any attempt to open the
> +# file will read this entry, leading to the panic being triggered as above, via
> +# security_d_instantiate, rather than fgetxattr(2), to test via fgetxattr mount
> +# with a fixed context=
> +#
> +# Kernels prior to v4.16 don't have medium_error_start, and only return errors
> +# for a specific location, making scsi_debug unsuitable for checking old kernels.
> +# See d9da891a892a scsi: scsi_debug: Add two new parameters to scsi_debug driver

Haha, I think we don't need to write such long comment, how about shorten it a bit,
for example remove the call trace details :)

> +#
> +
> +. ./common/preamble
> +_begin_fstest auto
                      ^^^^
                      attr

> +
> +_fixed_by_kernel_commit ae668cd567a6 "xfs: do not propagate ENODATA disk errors into xattr code"
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	_unmount $SCRATCH_MNT
> +	_put_scsi_debug_dev
> +}
> +
> +# Import common functions.
> +. ./common/scsi_debug
> +
> +_require_scsi_debug
> +modinfo scsi_debug | grep -wq medium_error_start || _notrun "test requires scsi_debug medium_error_start"

Oh, maybe we can improve _require_scsi_debug, help it to accept arguments, likes:

  _require_scsi_debug medium_error_start

> +scsi_debug_dev=$(_get_scsi_debug_dev)
> +test -b $scsi_debug_dev || _notrun "Failed to initialize scsi debug device"
> +echo "SCSI debug device $scsi_debug_dev" >>$seqres.full
> +
> +_mkfs_dev $scsi_debug_dev  >> $seqres.full
> +_mount $scsi_debug_dev $SCRATCH_MNT  >> $seqres.full

Hmm... if you use $SCRATCH_MNT, you might need _require_scratch. You can set
SCRATCH_DEV=$scsi_debug_dev, then use _scratch_mkfs and _scratch_mount and
other _scratch_* functions in this case.

> +
> +blocksize=$(_get_block_size $SCRATCH_MNT) >> $seqres.full
                                             ^^^^^^^^^^^^^^^
                                             what's this for?

Better to use _get_file_block_size.

> +echo Blocksize $blocksize >> $seqres.full
> +
> +# Use dry_run=1 when verifying the test to avoid panicking.
> +enable_error=1
> +[ ${dry_run:-0} -eq 1 ] && enable_error=0

I think the dry_run is useless for this case in xfstests, except you
hope to create a new global parameter named "dry_run" for xfstests.
I think we don't need that. Please use other method to decide enable_error.
Or always "enable error" if that's a necessary condition to reproduce the
bug.

> +
> +test_attr()
> +{
> +	test=$1
> +	testfile=$SCRATCH_MNT/$test
> +	attr_size=$2 # bytes
> +	error_at_block=${3:-0}

Better to use "local" for variables in a function.

> +	shift 3

But there might be not the 3rd argument, as you set it to 0 by default.

I didn't see you use any $4, $* or $@ below, so maybe we don't need this
line ?

> +
> +	value_size=$attr_size

Looks like the attr_size and value_size are duplicated, due to I didn't
see you change any of them below.

> +
> +	echo 0 > /sys/module/scsi_debug/parameters/opts
> +
> +	echo -e "\nTesting : $test" >> $seqres.full
> +	echo -e "attr size: $attr_size" >> $seqres.full
> +	echo -e "error at block: $error_at_block\n" >> $seqres.full
> +
> +	touch $testfile
> +
> +	inode=$(ls -i $testfile|awk '{print $1}')

inode=$(stat -c '%i' $testfile)

> +	printf "inode: %d Testfile: %s\n" $inode $testfile >> $seqres.full
> +	setfattr -n user.test_attr -v $(printf "%0*d" $value_size $value_size) $testfile

As this case is "attr" related, so you need these:

. common/attr

_require_attrs user

$SETFATTR_PROG ....

> +
> +	$XFS_IO_PROG -c "bmap -al" $testfile >> $seqres.full
> +	start_blocks=($($XFS_IO_PROG -c "bmap -al" $testfile | awk 'match($3, /[0-9]+/, a) {print a[0]}'))
> +	echo "Attribute fork extent(s) start at ${attrblocks[*]}" >> $seqres.full
> +
> +	_unmount $SCRATCH_MNT >>$seqres.full 2>&1
> +
> +	echo "Dump inode $inode details with xfs_db" >> $seqres.full
> +	$XFS_DB_PROG -c "inode $inode" -c "print core.aformat core.naextents a" $scsi_debug_dev >> $seqres.full
> +	inode_daddr=$($XFS_DB_PROG -c "inode $inode" -c "daddr" $scsi_debug_dev | awk '{print $4}')

_scratch_xfs_get_metadata_field ...

> +	echo inode daddr $inode_daddr >> $seqres.full
> +
> +
> +	_mount $scsi_debug_dev $SCRATCH_MNT  >> $seqres.full
> +
> +        if [[ start_blocks[0] -ne 0 ]]; then
        ^^^

> +                # Choose the block to error, currently only works with a single extent.
> +                error_daddr=$((start_blocks[0] + error_at_block*blocksize/512))
> +        else
> +                # Default to the inode daddr when no extents were found.
> +                # Fails reading the inode during stat, so arguably useless
> +                # even for testing the upper layers of getfattr.
> +                error_daddr=$inode_daddr

I'm curious, won't this affect the inode core ? If inode core can't be read, won't
this cause other problem which isn't as you expect?

> +        fi
        ^^^

Bad indentation ...

> +
> +	echo "Setup scsi_debug to error when reading attributes from block" \
> +	     "$error_at_block at daddr $error_daddr" >> $seqres.full
> +	echo $error_daddr > /sys/module/scsi_debug/parameters/medium_error_start
> +	echo $(($blocksize/512)) > /sys/module/scsi_debug/parameters/medium_error_count
> +
> +	if [ $enable_error -eq 1 ]; then
> +		echo Enabling error >> $seqres.full
> +        	echo 2 > /sys/module/scsi_debug/parameters/opts
> +	fi
> +
> +	grep ^ /sys/module/scsi_debug/parameters/{medium_error_start,medium_error_count,opts} >> $seqres.full
> +
> +	echo "Re-read the extended attribute on $testfile, panics on IO errors" >> $seqres.full
> +	sync # Let folk see where we failed in the results.
> +	getfattr -d -m - $testfile >> $seqres.full 2>&1 # Panic here on failure

If you don't care about the getfattr output, you don't need to call _getfattr, but
please use $GETFATTR_PROG at least.



> +}
> +
> +
> +# TODO: Avoid assumptions about inode size using _xfs_get_inode_size and
> +#       _xfs_get_inode_core_bytes, currently assuming 512 byte inodes.
> +
> +# aformat shortform
> +# Include shortform for completeness, we can only inject errors for attributes
> +# stored outside of the inode.
> +test_attr "attr_local" 1 0
> +
> +# aformat extents
> +# Single leaf block, known to panic
> +test_attr "attr_extent_one_block" 512 0
> +
> +# Other tests to exercise multi block extents and multi extent attribute forks.
> +# Before the panic was understood it seemed possible that failing on the second
> +# block of a multi block attribute fork was involved. Seems like it may be
> +# worth testing in the future.
> +
> +test_attr "attr_extent_two_blocks_1" 5000 0
> +test_attr "attr_extent_two_blocks_2" 5000 1
> +# test_attr "attr_extent_many_blocks" 16000 4
> +#
> +# When using a single name=value pair to fill the space these tend to push out
> +# to multiple extents, rather than a single long extent, so don't yet test
> +# failing subsequent blocks within the first extent.
> +#
> +# i.e.
> +# xfs_bmap -va $testfile
> +# /mnt/test/testfile:
> +# EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
> +#   0: [0..7]:          96..103           0 (96..103)            8
> +#   1: [8..23]:         80..95            0 (80..95)            16
> +
> +# aformat btree
> +# test_attr "attr_extents" 50000 0
> +# test_attr "attr_extents" 50000 $blocksize
> +# test_attr "attr_extents" 50000 $((blocksize+1))

Can you really get a btree aformat through this ? I doubt that. You
might need lots of attribute entries, not only one attribute with huge
data.

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

