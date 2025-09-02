Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005DC2E11DF
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 04:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756786352; cv=none; b=s/YsfdMrl4OgevQ85WMw71ue2HE8SObaxcvRVxBcs18+zfl0q9l9OQbv8jTTDKKSA+kpDnvi5erPC2elOn4u0kSmwcvyHZHHeQqhiOgQvg2zs9qNh594t/e58vJ5E5c1Llv4IBUMBqVzHD5f63TfdPIaVKWsKWJf6Qw0jfMwu88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756786352; c=relaxed/simple;
	bh=9QibaCAGQyYegm+8BHRvJikBpk5U8ZwwJL4U1cCvCO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b7XmQlQcMzRHY9YD5kxyJLXOmMeywVl9I8RYHODo0n2p5YhbDSpgNSMSbWHrX+3eoFTFjaRqk7GduTk6VmbdklJJg7lnzuroGCnEmLSBKlNKWlQ+cntHJ36+nwQQmA0y6cLAU/L6p32KGrdYrHw4ilXds39jlWtv7YIRw3XW5Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g5aEqNpt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g5aEqNpt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756786349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vSWWTQnnC0laewi8yEB6D79ek6P96L3c5RpPyyiP7MM=;
	b=g5aEqNptEB50A5c/Ik5mBwYDUVVMEHSjq2BG1MmAO9knGApaJGPj5s6GBYBxwNKXCa8pMn
	mcXIVHGu9A+lcV1uzwqGSIhbi4r60sY1KsPnlF690RkGCD5Lt+gnK4aAq6TAUpKz9xw4ae
	6M5x5fW4zaSk+mH0l10USFyIViVXQEc=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-fD5vLcWvMyKIFJcLsLmA3Q-1; Tue, 02 Sep 2025 00:12:27 -0400
X-MC-Unique: fD5vLcWvMyKIFJcLsLmA3Q-1
X-Mimecast-MFC-AGG-ID: fD5vLcWvMyKIFJcLsLmA3Q_1756786346
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b4e796ad413so3365025a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 01 Sep 2025 21:12:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756786346; x=1757391146;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vSWWTQnnC0laewi8yEB6D79ek6P96L3c5RpPyyiP7MM=;
        b=cFkwwq4Ja94sZsQCUzgFR+2Cjn7RQI/Q3EYIBJzNnDqIJaGVAoW8E2Oh2VeJVUUNnn
         DGD08fdnp/Oxumk71cvUJKqXBEln0XGDwVjj+URyHAwtolbLiSCgQg55yRC3GF8/jDfC
         XgF8eWGS/KLF7OVJZF0hN6vUqq6gQNm+rtpUe/A1SlHBpKd3bQ0R4JNljv/bADEcr8wS
         pGEDk+oi99jVLnIIOTqLk+ZVq6Va0LTqTxPydgH4M+t46H4Xh/Ruc9xlCY+vE7Y/w7so
         J1gPN35RiTWmcdUqVWyUQ4Vq6bmINqXdu8bzADNgwdAGhV0dnLDGcDYhrXp08cke4f8Z
         jXtQ==
X-Gm-Message-State: AOJu0YzELE9WK8JMwz+obltsxY4lkxBtKFmXw11X8ha4+Ae/Fe0TRsMP
	FcihiCZCPOHdaSQ9NyOHREIxxwA7eruBTkT3FNl87VLmpCyc0FfGm9rQf92PPTF/SYt28y6DFQv
	25W1P0luE8vJJCco8Ya+ybCudiUPPxuvkKH0PBmHuJAJH5ztiqqleiSiSJgchLw==
X-Gm-Gg: ASbGncuIxD21FZhhgK6zRw8O5p+/6fiS5xl8jmqQosPhu2zYd7n7TsBdtewpfGPFBtq
	DpeYHPCcsfr6lOXZs1PpP9xvJZKmkv2gFVRoXRozcUn1gJ1XL0FZt92q3ztYv7qdfhIwOfRaIBC
	iUw54xtOWaWm9LzYpWungtweiJbWS55wByY4DhU7vpjf8vo3Pd9Xt1bi+Vq/Vwt7lqiICNpxbtw
	ylilSEog0A/oIigXP19fBm62pj9jYO6ahYI9Dq01QwONMN6Zak+jYVQjVXJ0zIpE4ZcExKI/qgW
	ubO7sypkxkg+favT9ZveKeZLAQJc1j6MA6o3YUzZwYaD1L3LJJsMrWmBvFMVOVOLBegP3mihGuF
	3BET3dmB/Hb8=
X-Received: by 2002:a05:6a20:3d88:b0:243:cff1:3c9a with SMTP id adf61e73a8af0-243d6e06218mr13767218637.23.1756786346197;
        Mon, 01 Sep 2025 21:12:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgWECl9ZywRwmtRo9OxzFKys+pe9UPovz4NpbZXZTcaPWlhvuMgRU8FatudiA7kfjuuvFHYQ==
X-Received: by 2002:a05:6a20:3d88:b0:243:cff1:3c9a with SMTP id adf61e73a8af0-243d6e06218mr13767179637.23.1756786345670;
        Mon, 01 Sep 2025 21:12:25 -0700 (PDT)
Received: from ?IPV6:2001:8003:4a36:e700:8cd:5151:364a:2095? ([2001:8003:4a36:e700:8cd:5151:364a:2095])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4e1d4fsm11887618b3a.73.2025.09.01.21.12.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 21:12:25 -0700 (PDT)
Message-ID: <b6a8e352-e351-4f40-833a-b7b63d2fd392@redhat.com>
Date: Tue, 2 Sep 2025 14:12:20 +1000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs: test case for handling io errors when reading
 extended attributes
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
 Eric Sandeen <sandeen@sandeen.net>, "Darrick J . Wong" <djwong@kernel.org>,
 Carlos Maiolino <cem@kernel.org>
References: <20250829042419.1084367-1-ddouwsma@redhat.com>
 <20250829194943.bqzecrnelwze6svp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Content-Language: en-US
From: Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <20250829194943.bqzecrnelwze6svp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 30/8/25 05:49, Zorro Lang wrote:
> On Fri, Aug 29, 2025 at 02:24:19PM +1000, Donald Douwsma wrote:
>> We've seen reports from the field panicing in xfs_trans_brelse after
>> an io error for an attribute block.
>>
>> sd 0:0:23:0: [sdx] tag#271 CDB: Read(16) 88 00 00 00 00 00 9b df 5e 78 00 00 00 08 00 00
>> critical medium error, dev sdx, sector 2615107192 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class 2
>> XFS (sdx1): metadata I/O error in "xfs_da_read_buf+0xe1/0x140 [xfs]" at daddr 0x9bdf5678 len 8 error 61
>> BUG: kernel NULL pointer dereference, address: 00000000000000e0
>> ...
>> RIP: 0010:xfs_trans_brelse+0xb/0xe0 [xfs]
>> ...
>> Call Trace:
>>   <TASK>
>>   ...
>>   ? xfs_trans_brelse+0xb/0xe0 [xfs]
>>   xfs_attr_leaf_get+0xb6/0xc0 [xfs]
>>   xfs_attr_get+0xa0/0xd0 [xfs]
>>   xfs_xattr_get+0x75/0xb0 [xfs]
>>   __vfs_getxattr+0x53/0x70
>>   inode_doinit_use_xattr+0x63/0x180
>>   inode_doinit_with_dentry+0x196/0x510
>>   security_d_instantiate+0x2f/0x50
>>   d_splice_alias+0x46/0x2b0
>>   xfs_vn_lookup+0x8b/0xb0 [xfs]
>>   __lookup_slow+0x84/0x130
>>   walk_component+0x158/0x1d0
>>   path_lookupat+0x6e/0x1c0
>>   filename_lookup+0xcf/0x1d0
>>   vfs_statx+0x8d/0x170
>>   vfs_fstatat+0x54/0x70
>>   __do_sys_newfstatat+0x26/0x60
>>
>> As this is specific to ENODATA test using scsi_debug instead of dmerror
>> which returns EIO.
>>
>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>> ---
>>   tests/xfs/999     | 193 ++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/xfs/999.out |   2 +
>>   2 files changed, 195 insertions(+)
>>   create mode 100755 tests/xfs/999
>>   create mode 100644 tests/xfs/999.out
>>
>> diff --git a/tests/xfs/999 b/tests/xfs/999
>> new file mode 100755
>> index 00000000..2a45eb7c
>> --- /dev/null
>> +++ b/tests/xfs/999
>> @@ -0,0 +1,193 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2025 Red Hat Inc.  All Rights Reserved.
>> +#
>> +# FS QA Test 999
>> +#
>> +# Regression test for panic following IO error when reading extended attribute blocks
>> +#
>> +#   XFS (sda): metadata I/O error in "xfs_da_read_buf+0xe1/0x140 [xfs]" at daddr 0x78 len 8 error 61
>> +#   BUG: kernel NULL pointer dereference, address: 00000000000000e0
>> +#   ...
>> +#   RIP: 0010:xfs_trans_brelse+0xb/0xe0 [xfs]
>> +#
>> +#   [53887.310123] Call Trace:
>> +#    <TASK>
>> +#    ? show_trace_log_lvl+0x1c4/0x2df
>> +#    ? show_trace_log_lvl+0x1c4/0x2df
>> +#    ? xfs_attr_leaf_get+0xb6/0xc0 [xfs]
>> +#    ? __die_body.cold+0x8/0xd
>> +#    ? page_fault_oops+0x134/0x170
>> +#    ? xfs_trans_read_buf_map+0x133/0x300 [xfs]
>> +#    ? exc_page_fault+0x62/0x150
>> +#    ? asm_exc_page_fault+0x22/0x30
>> +#    ? xfs_trans_brelse+0xb/0xe0 [xfs]
>> +#    xfs_attr_leaf_get+0xb6/0xc0 [xfs]
>> +#    xfs_attr_get+0xa0/0xd0 [xfs]
>> +#    xfs_xattr_get+0x88/0xd0 [xfs]
>> +#    __vfs_getxattr+0x7b/0xb0
>> +#    inode_doinit_use_xattr+0x63/0x180
>> +#    inode_doinit_with_dentry+0x196/0x510
>> +#    security_d_instantiate+0x3a/0xb0
>> +#    d_splice_alias+0x46/0x2b0
>> +#    xfs_vn_lookup+0x8b/0xb0 [xfs]
>> +#    __lookup_slow+0x81/0x130
>> +#    walk_component+0x158/0x1d0
>> +#    ? path_init+0x2c5/0x3f0
>> +#    path_lookupat+0x6e/0x1c0
>> +#    filename_lookup+0xcf/0x1d0
>> +#    ? tlb_finish_mmu+0x65/0x150
>> +#    vfs_statx+0x82/0x160
>> +#    vfs_fstatat+0x54/0x70
>> +#    __do_sys_newfstatat+0x26/0x60
>> +#    do_syscall_64+0x5c/0xe0
>> +#
>> +# For SELinux enabled filesystems the attribute security.selinux will be
>> +# created before any additional attributes are added. Any attempt to open the
>> +# file will read this entry, leading to the panic being triggered as above, via
>> +# security_d_instantiate, rather than fgetxattr(2), to test via fgetxattr mount
>> +# with a fixed context=
>> +#
>> +# Kernels prior to v4.16 don't have medium_error_start, and only return errors
>> +# for a specific location, making scsi_debug unsuitable for checking old kernels.
>> +# See d9da891a892a scsi: scsi_debug: Add two new parameters to scsi_debug driver
> 
> Haha, I think we don't need to write such long comment, how about shorten it a bit,
> for example remove the call trace details :)

I'll try. I wanted to document that this involves the call path through
xfs_attr_get and xfs_attr_leaf_get, since I'd like to cover the
different fork's in xfs_attr_get_ilocked (inlined in xfs_attr_get).

> 
>> +#
>> +
>> +. ./common/preamble
>> +_begin_fstest auto
>                        ^^^^
>                        attr

Ack

> 
>> +
>> +_fixed_by_kernel_commit ae668cd567a6 "xfs: do not propagate ENODATA disk errors into xattr code"
>> +
>> +# Override the default cleanup function.
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -f $tmp.*
>> +	_unmount $SCRATCH_MNT
>> +	_put_scsi_debug_dev
>> +}
>> +
>> +# Import common functions.
>> +. ./common/scsi_debug
>> +
>> +_require_scsi_debug
>> +modinfo scsi_debug | grep -wq medium_error_start || _notrun "test requires scsi_debug medium_error_start"
> 
> Oh, maybe we can improve _require_scsi_debug, help it to accept arguments, likes:
> 
>    _require_scsi_debug medium_error_start

I started down that track, but wanted to keep it self contained.
Happy to move it there for you.

>> +scsi_debug_dev=$(_get_scsi_debug_dev)
>> +test -b $scsi_debug_dev || _notrun "Failed to initialize scsi debug device"
>> +echo "SCSI debug device $scsi_debug_dev" >>$seqres.full
>> +
>> +_mkfs_dev $scsi_debug_dev  >> $seqres.full
>> +_mount $scsi_debug_dev $SCRATCH_MNT  >> $seqres.full
> 
> Hmm... if you use $SCRATCH_MNT, you might need _require_scratch. You can set
> SCRATCH_DEV=$scsi_debug_dev, then use _scratch_mkfs and _scratch_mount and
> other _scratch_* functions in this case.

That would be clearer and allow the scratch options to be used, I'll
check it out.

> 
>> +
>> +blocksize=$(_get_block_size $SCRATCH_MNT) >> $seqres.full
>                                               ^^^^^^^^^^^^^^^
>                                               what's this for?

Reflex, fixed.

> Better to use _get_file_block_size.

Ack

>> +echo Blocksize $blocksize >> $seqres.full
>> +
>> +# Use dry_run=1 when verifying the test to avoid panicking.
>> +enable_error=1
>> +[ ${dry_run:-0} -eq 1 ] && enable_error=0
> 
> I think the dry_run is useless for this case in xfstests, except you
> hope to create a new global parameter named "dry_run" for xfstests.
> I think we don't need that. Please use other method to decide enable_error.
> Or always "enable error" if that's a necessary condition to reproduce the
> bug.

I agree a one off here is bad.

But it was useful when developing a test script that was expected to
panic. How else can folk validate tests designed to panic a system?

>> +
>> +test_attr()
>> +{
>> +	test=$1
>> +	testfile=$SCRATCH_MNT/$test
>> +	attr_size=$2 # bytes
>> +	error_at_block=${3:-0}
> 
> Better to use "local" for variables in a function.

Ack

>> +	shift 3
> 
> But there might be not the 3rd argument, as you set it to 0 by default.
> 
> I didn't see you use any $4, $* or $@ below, so maybe we don't need this
> line ?

Ouch, yes, removed.

> 
>> +
>> +	value_size=$attr_size
> 
> Looks like the attr_size and value_size are duplicated, due to I didn't
> see you change any of them below.

When I first started work on this it wasn't clear to me how the error
from the SCSI layer provoked it. Was it only the first failing attr
block, did it behave differently on the second, could it involve the
name and value split across block boundaries. The variable value_size
was the start of working out how to cover this.

After Eric figured out the cause of the panic it became more obvious
as to which caused it, but I think it may be worth putting some effort
into covering the different possibilities.

If anyone else thinks this is worth the effort to get more coverage this
would need to calculate the sizes of name/value and count required to
create the required block and extent layout. Taking into account the
current size of the attribute fork, with any security attributes added
on file create.

Or I could simplify this back down to just the case that that triggers
the panic.


> 
>> +
>> +	echo 0 > /sys/module/scsi_debug/parameters/opts
>> +
>> +	echo -e "\nTesting : $test" >> $seqres.full
>> +	echo -e "attr size: $attr_size" >> $seqres.full
>> +	echo -e "error at block: $error_at_block\n" >> $seqres.full
>> +
>> +	touch $testfile
>> +
>> +	inode=$(ls -i $testfile|awk '{print $1}')
> 
> inode=$(stat -c '%i' $testfile)

Ack, much nicer

>> +	printf "inode: %d Testfile: %s\n" $inode $testfile >> $seqres.full
>> +	setfattr -n user.test_attr -v $(printf "%0*d" $value_size $value_size) $testfile
> 
> As this case is "attr" related, so you need these:
> 
> . common/attr
> 
> _require_attrs user
> 
> $SETFATTR_PROG ....

Ack

> 
>> +
>> +	$XFS_IO_PROG -c "bmap -al" $testfile >> $seqres.full
>> +	start_blocks=($($XFS_IO_PROG -c "bmap -al" $testfile | awk 'match($3, /[0-9]+/, a) {print a[0]}'))
>> +	echo "Attribute fork extent(s) start at ${attrblocks[*]}" >> $seqres.full
>> +
>> +	_unmount $SCRATCH_MNT >>$seqres.full 2>&1
>> +
>> +	echo "Dump inode $inode details with xfs_db" >> $seqres.full
>> +	$XFS_DB_PROG -c "inode $inode" -c "print core.aformat core.naextents a" $scsi_debug_dev >> $seqres.full
>> +	inode_daddr=$($XFS_DB_PROG -c "inode $inode" -c "daddr" $scsi_debug_dev | awk '{print $4}')
> 
> _scratch_xfs_get_metadata_field ...

OK

> 
>> +	echo inode daddr $inode_daddr >> $seqres.full
>> +
>> +
>> +	_mount $scsi_debug_dev $SCRATCH_MNT  >> $seqres.full
>> +
>> +        if [[ start_blocks[0] -ne 0 ]]; then
>          ^^^

You mean the white space in the indent? If so ack.

>> +                # Choose the block to error, currently only works with a single extent.
>> +                error_daddr=$((start_blocks[0] + error_at_block*blocksize/512))
>> +        else
>> +                # Default to the inode daddr when no extents were found.
>> +                # Fails reading the inode during stat, so arguably useless
>> +                # even for testing the upper layers of getfattr.
>> +                error_daddr=$inode_daddr
> 
> I'm curious, won't this affect the inode core ? If inode core can't be read, won't
> this cause other problem which isn't as you expect?

Yes, the read for the inode fails and getfattr(1) will never get far
enough to call getfattr(2) to read the attribute. But does end up
testing how getfattr(1) handles this case.

>> +        fi
>          ^^^
> 
> Bad indentation ...
> 
>> +
>> +	echo "Setup scsi_debug to error when reading attributes from block" \
>> +	     "$error_at_block at daddr $error_daddr" >> $seqres.full
>> +	echo $error_daddr > /sys/module/scsi_debug/parameters/medium_error_start
>> +	echo $(($blocksize/512)) > /sys/module/scsi_debug/parameters/medium_error_count
>> +
>> +	if [ $enable_error -eq 1 ]; then
>> +		echo Enabling error >> $seqres.full
>> +        	echo 2 > /sys/module/scsi_debug/parameters/opts
>> +	fi
>> +
>> +	grep ^ /sys/module/scsi_debug/parameters/{medium_error_start,medium_error_count,opts} >> $seqres.full
>> +
>> +	echo "Re-read the extended attribute on $testfile, panics on IO errors" >> $seqres.full
>> +	sync # Let folk see where we failed in the results.
>> +	getfattr -d -m - $testfile >> $seqres.full 2>&1 # Panic here on failure
> 
> If you don't care about the getfattr output, you don't need to call _getfattr, but
> please use $GETFATTR_PROG at least.

Ack, I'll look into _getfattr or use $GETFATTR_PROG

> 
>> +}
>> +
>> +
>> +# TODO: Avoid assumptions about inode size using _xfs_get_inode_size and
>> +#       _xfs_get_inode_core_bytes, currently assuming 512 byte inodes.
>> +
>> +# aformat shortform
>> +# Include shortform for completeness, we can only inject errors for attributes
>> +# stored outside of the inode.
>> +test_attr "attr_local" 1 0
>> +
>> +# aformat extents
>> +# Single leaf block, known to panic
>> +test_attr "attr_extent_one_block" 512 0
>> +
>> +# Other tests to exercise multi block extents and multi extent attribute forks.
>> +# Before the panic was understood it seemed possible that failing on the second
>> +# block of a multi block attribute fork was involved. Seems like it may be
>> +# worth testing in the future.
>> +
>> +test_attr "attr_extent_two_blocks_1" 5000 0
>> +test_attr "attr_extent_two_blocks_2" 5000 1
>> +# test_attr "attr_extent_many_blocks" 16000 4
>> +#
>> +# When using a single name=value pair to fill the space these tend to push out
>> +# to multiple extents, rather than a single long extent, so don't yet test
>> +# failing subsequent blocks within the first extent.
>> +#
>> +# i.e.
>> +# xfs_bmap -va $testfile
>> +# /mnt/test/testfile:
>> +# EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
>> +#   0: [0..7]:          96..103           0 (96..103)            8
>> +#   1: [8..23]:         80..95            0 (80..95)            16
>> +
>> +# aformat btree
>> +# test_attr "attr_extents" 50000 0
>> +# test_attr "attr_extents" 50000 $blocksize
>> +# test_attr "attr_extents" 50000 $((blocksize+1))
> 
> Can you really get a btree aformat through this ? I doubt that. You
> might need lots of attribute entries, not only one attribute with huge
> data.

This is indeed the question, but the code supports btrees.

Thanks for all the feedback!

Now I just need to test the changes, with

  dry_run=1 ./check tests/xfs/999

Before removing dry_run :)

Don

