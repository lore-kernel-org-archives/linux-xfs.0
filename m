Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C993178F4A
	for <linux-xfs@vger.kernel.org>; Thu, 20 Nov 2025 01:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763601317; cv=none; b=aKsyniDk+/dfGaadBKX3eOYA8F7+/kTxQMt9zVABHe45KZL1CzN8PiKATpa5OwkVda10v9ir6peXN4HpKCSu8cHxuOUFEoOEV6uyP8wkKnbzZ/ub0W0JjkIgQZuJhLjEpWd2AC+KQo5qCIk9ftNcWW5O1EqOIJBeQ20ZrcHko+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763601317; c=relaxed/simple;
	bh=enrbeARSJgv/CaMiA7uXqQrBJp4Pb05gpkgC+U48+tQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qr+2cliIZugFB++NhSbk8x763EAJ0oRUMNCf8MXsqWURg8ytZNy67TS82G+Kv6RlGl9QmmsT3oLnDVSZ/MTVPkDRsMB9D7W4FlMcpP8ONAopgvfK4eZpn6tcnOrnq2ht0NIuvsYHkX3BjwJmoa8CZU2+HpVKG9yCip7GCw3bIJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J56y9CC5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OJjs06mL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J56y9CC5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OJjs06mL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763601314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NqgqOwd5jqp5oDAf2y+M8e0ASYazdS1wJvsZ356bYZE=;
	b=J56y9CC5NRCYIDZtO+8tZLrw0DtIZQGhOKH36V/eVpfitRy77937Mjs3BiDla2LNAfN+MD
	4BwT0LjSNKjOujoweLE41Sn65/5VDOYDTjRT5C+J3eQ0InPaBXjjnUFX/ZxG/H2Pm9z63q
	/SiAh9VE12/8Xry35fJYQcTW6rrSnpY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-dcKTlc9IORq-6XWpRt__fQ-1; Wed, 19 Nov 2025 20:15:13 -0500
X-MC-Unique: dcKTlc9IORq-6XWpRt__fQ-1
X-Mimecast-MFC-AGG-ID: dcKTlc9IORq-6XWpRt__fQ_1763601313
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ee4a0ad6a6so6934531cf.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Nov 2025 17:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763601312; x=1764206112; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NqgqOwd5jqp5oDAf2y+M8e0ASYazdS1wJvsZ356bYZE=;
        b=OJjs06mLqNZ2gbuz4u/Q8evVDQvRIij0PkwPs9xuRAN71IRh495sVk2HlNM1z20KhD
         U1UdWcz9+z/GRWywHFu91UemBu/Z1LtEthlJkUtqGRJYWxZ27HiAQfF0ltsv/UlZ/qAP
         VPOAYrQCtWoUckw8kYOm60qEpe4YXTGu4yrqOADlZm+wo7E0RAj9sne/sZmF6/gIZxjK
         t3gsMO4bB8JkcUnvyebyCgIg5BaxgX06gP8L/LTQtr5v4p7fSx8rXEY9++fqEfHbTMrU
         mMGvN+nogGJiHW6rilqdH/6axeBxmzbll50+fruThAeaZe9hzxcCjIlVXg4qJmFFPnwm
         +/Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763601312; x=1764206112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NqgqOwd5jqp5oDAf2y+M8e0ASYazdS1wJvsZ356bYZE=;
        b=izGvfZbIcxq9K34D6Kij8bLPHa2/QFZtASnYap+9toVUUS6Z8DhgTg88zakZc+9GH9
         mrI5WjJLdriIClBZ3ArX1dn/x3wefprDITg/RgAs42hQnrcmkjd+Q/7QN8q/Zv2LCNBV
         NZ5QiIDJCFSuPZdh5VaSBOT2bzkx4EIouU7KQjb7N04bnVlxVZneiWdkZ21h/z7YUNf4
         G+AjN9m9PxnExdFHVeLwI6igI5hIqP/WboakFIwSkA2b0FUdQU+nJqjVZHpuwYgJWl78
         oWslwMYi/kmUiuRRVPMvcp9sciKg5CjCYMWYHv9g2JHjby5QDfswhAahT3TwJA9INEDQ
         3jRw==
X-Gm-Message-State: AOJu0YwebBItU1u1dj+rYbJbCOB/S8/dP58aNkd7qEr7h0UYXZb1jATD
	pZ+ggPg3WZufyKxnHWAd3GChVegrcTYjlxa18APxmF+ei/llkoqf3XqZ7ZHTTANOjS7NRP2sVNl
	XrRfXZ2D6KfoyiRia78v5xTpXefE2/5zZ2feXSlp99Hy5lUyk9H5skvCwZ/UkLg==
X-Gm-Gg: ASbGncsEPHuhNdGazsi/nhIzXmRW+aXWoUoxxhoaIGErlAyejhAGp2HNgs+izqFXmG1
	qeTSKMFRADybIPLZJLdmncSJ3BkzFaM3T8HMat1IJjEhwcdOCeVx7tFCe6XkyCByXEw4GL8eme+
	duJBzjKMhdoiB5BpzKt4acP0BxtZ2mUvnoYe8sO70Op/vVu5kOPCmm/1T0KMnXPryZWZCay7N1X
	rVVdUa2oYACHhN0p2JYUC2e4HgPgfqSjvgFTTS3McX081ZIFZlWrL8oqG1m1/EUkygTXIQeH5J5
	V5FCm9TB/UlwJcypj0N/4iC7tKO2eZgkMVuZC6TncfhaeikCwSPVlGOTg524AkeGM1r6GD06IK8
	mCksrwKO4oNvib0UaSUm/z4XRr2H1J8WV0dy2E9SpbuCuqeI0WP3dR8CF
X-Received: by 2002:ac8:7e85:0:b0:4ec:f1cc:37c0 with SMTP id d75a77b69052e-4ee4971e94bmr19540041cf.81.1763601312591;
        Wed, 19 Nov 2025 17:15:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFo80YT4ij2I/FfCnf4li9DX7WFNQtjycZ4PKqwbBCDEA0dksjzzKSCwFXp54r7zQ2EpoKMDQ==
X-Received: by 2002:ac8:7e85:0:b0:4ec:f1cc:37c0 with SMTP id d75a77b69052e-4ee4971e94bmr19539621cf.81.1763601312121;
        Wed, 19 Nov 2025 17:15:12 -0800 (PST)
Received: from ?IPV6:2001:8003:4a36:e700:8cd:5151:364a:2095? ([2001:8003:4a36:e700:8cd:5151:364a:2095])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee4cbc3c81sm1215061cf.16.2025.11.19.17.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Nov 2025 17:15:11 -0800 (PST)
Message-ID: <193ae927-9a53-4fa0-9cbe-4e677af2525c@redhat.com>
Date: Thu, 20 Nov 2025 12:15:06 +1100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] xfs: test case for handling io errors when reading
 extended attributes
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
 Zorro Lang <zlang@kernel.org>
References: <20251119041210.2385106-1-ddouwsma@redhat.com>
 <20251119100709.zbkenjwztblkjobd@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Content-Language: en-US, en-AU
From: Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <20251119100709.zbkenjwztblkjobd@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/11/25 21:07, Zorro Lang wrote:
> On Wed, Nov 19, 2025 at 03:12:10PM +1100, Donald Douwsma wrote:
>> We've seen reports from the field panicking in xfs_trans_brelse after an
>> IO error when reading an attribute block.
>>
>> sd 0:0:23:0: [sdx] tag#271 CDB: Read(16) 88 00 00 00 00 00 9b df 5e 78 00 00 00 08 00 00
>> critical medium error, dev sdx, sector 2615107192 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class 2
>> XFS (sdx1): metadata I/O error in "xfs_da_read_buf+0xe1/0x140 [xfs]" at daddr 0x9bdf5678 len 8 error 61
>> BUG: kernel NULL pointer dereference, address: 00000000000000e0
>> ...
>> RIP: 0010:xfs_trans_brelse+0xb/0xe0 [xfs]
>>
>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>>
>> ---
>> V3
>> - Zorro's suggestions (_require_scsi_debug, _require_scratch, ..., use _get_file_block_size
>>   drop dry_run, fix local variables and parameters, common/attr, ...)
>> - Override SELINUX_MOUNT_OPTIONS to avoid _scratch_mount breaking the test
>> - Add test to quick attr
>> - Change test_attr() to work with blocks instead of bytes
>> - Name the scsi_debug options to make it clearer where the error is active
>> - Determine size of the attr value required based on filesystem block size
>> V2
>> - As this is specific to ENODATA test using scsi_debug instead of dmerror
>> which returns EIO.
>> ---
>>  common/scsi_debug |   8 ++-
>>  tests/xfs/999     | 139 ++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/999.out |   2 +
>>  3 files changed, 148 insertions(+), 1 deletion(-)
>>  create mode 100755 tests/xfs/999
>>  create mode 100644 tests/xfs/999.out
>>
>> diff --git a/common/scsi_debug b/common/scsi_debug
>> index 1e0ca255..c3fe7be6 100644
>> --- a/common/scsi_debug
>> +++ b/common/scsi_debug
>> @@ -6,6 +6,7 @@
>>  
>>  . common/module
>>  
>> +# _require_scsi_debug [mod_param]
>>  _require_scsi_debug()
>>  {
>>  	local mod_present=0
>> @@ -30,9 +31,14 @@ _require_scsi_debug()
>>  			_patient_rmmod scsi_debug || _notrun "scsi_debug module in use"
>>  		fi
>>  	fi
>> +
>>  	# make sure it has the features we need
>>  	# logical/physical sectors plus unmap support all went in together
>> -	modinfo scsi_debug | grep -wq sector_size || _notrun "scsi_debug too old"
>> +	grep -wq sector_size <(modinfo scsi_debug) || _notrun "scsi_debug too old"
>> +	# make sure it supports this module parameter
>> +	if [ -n "$1" ];then
>> +		grep -Ewq "$1" <(modinfo scsi_debug) || _notrun "scsi_debug not support $1"
>> +	fi
>>  }
>>  
>>  # Args: [physical sector size, [logical sector size, [unaligned(0|1), [size in megs]]]]
>> diff --git a/tests/xfs/999 b/tests/xfs/999
>> new file mode 100755
>> index 00000000..2a571195
>> --- /dev/null
>> +++ b/tests/xfs/999
>> @@ -0,0 +1,139 @@
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
>> +# For SELinux enabled filesystems the attribute security.selinux will be
>> +# created before any additional attributes are added. In this case the
>> +# regression will trigger via security_d_instantiate() during a stat(2),
>> +# without SELinux this should trigger from fgetxattr(2).
>> +#
>> +# Kernels prior to v4.16 don't have medium_error_start, and only return errors
>> +# for a specific location, making scsi_debug unsuitable for checking old
>> +# kernels. See d9da891a892a scsi: scsi_debug: Add two new parameters to
>> +# scsi_debug driver
>> +#
>> +
>> +. ./common/preamble
>> +_begin_fstest auto quick attr
>> +
>> +_fixed_by_kernel_commit ae668cd567a6 \
>> +	"xfs: do not propagate ENODATA disk errors into xattr code"
>> +
>> +# Override the default cleanup function.
>> +_cleanup()
>> +{
>> +	_unmount $SCRATCH_MNT 2>/dev/null
>> +	_put_scsi_debug_dev
>> +	cd /
>> +	rm -f $tmp.*
>> +}
>> +
>> +# Import common functions.
>> +. ./common/attr
>> +. ./common/scsi_debug
>> +
>> +_require_scratch_nocheck
>> +_require_scsi_debug "medium_error_start"
>> +_require_attrs user
>> +
>> +# If SELinux is enabled common/config sets a default context, which which breaks this test.
>                                                                        ^^^^^
> 
>> +export SELINUX_MOUNT_OPTIONS=""
>> +
>> +scsi_debug_dev=$(_get_scsi_debug_dev)
>> +scsi_debug_opt_noerror=0
>> +scsi_debug_opt_error=${scsi_debug_opt_error:=2}
>> +test -b $scsi_debug_dev || _notrun "Failed to initialize scsi debug device"
>> +echo "SCSI debug device $scsi_debug_dev" >>$seqres.full
>> +
>> +SCRATCH_DEV=$scsi_debug_dev
>> +_scratch_mkfs >> $seqres.full
>> +_scratch_mount
>> +
>> +block_size=$(_get_file_block_size $SCRATCH_MNT)
>> +inode_size=$(_xfs_get_inode_size $SCRATCH_MNT)
>> +error_length=$((block_size/512)) # Error all sectors in the block
>> +
>> +echo Block size $block_size >> $seqres.full
>> +echo Inode size $inode_size >> $seqres.full
>> +
>> +test_attr()
>> +{
>> +	local test=$1
>> +	local testfile=$SCRATCH_MNT/$test
>> +	local attr_blocks=$2
>> +	local error_at_block=${3:-0}
>> +
>> +	local attr_size_bytes=$((block_size/2*attr_blocks))
>> +
>> +	# The maximum size for a single value is ATTR_MAX_VALUELEN (64*1024)
>> +	# If we wanted to test a larger range of extent combinations the test
>> +	# would need to use multiple values.
>> +	[[ $attr_size_bytes -ge 65536 ]] && echo "Test would need to be modified to support > 64k values for $attr_blocks blocks".
>> +
>> +	echo $scsi_debug_opt_noerror > /sys/module/scsi_debug/parameters/opts
>> +
>> +	echo -e "\nTesting : $test" >> $seqres.full
>> +	echo -e "attr size: $attr_blocks" >> $seqres.full
>> +	echo -e "error at block: $error_at_block\n" >> $seqres.full
>> +
>> +	touch $testfile
>> +	local inode=$(stat -c '%i' $testfile)
>> +	$SETFATTR_PROG -n user.test_attr -v $(printf "%0*d" $attr_size_bytes $attr_size_bytes) $testfile
>> +
>> +	$XFS_IO_PROG -c "bmap -al" $testfile >> $seqres.full
>> +	start_blocks=($($XFS_IO_PROG -c "bmap -al" $testfile | awk 'match($3, /[0-9]+/, a) {print a[0]}'))
>         ^^^^^^^^^^^^
>         local start_blocks
> 
> 
> OK, so you still don't want to use:
> 
>   local start_blocks=$(_scratch_xfs_get_metadata_field "a.bmx[0].startblock" "inode $inode")

I'm used to looking at extent information on mounted filesystems with xfs_bmap,
so it felt more natural.

I also wanted to make it easy to extend this to btree format attr if required.
It may be possible to do that with _scratch_xfs_get_metadata_field if it works
with btdump, but would add complexity.

> Anyway, both ways are good to get the start_blocks for this case. So ... (don't need to send v4)
> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 

Thanks for your help and feedback with this,
Don


>> +	echo "Attribute fork extent(s) start at ${start_blocks[*]}" >> $seqres.full
>> +
>> +	_scratch_unmount
>> +
>> +	echo "Dump inode $inode details with xfs_db" >> $seqres.full
>> +	_scratch_xfs_db -c "inode $inode" -c "print core.aformat core.naextents a" >> $seqres.full
>> +
>> +	if [[ start_blocks[0] -ne 0 ]]; then
>> +		# Choose the block to error, currently only works with a single extent.
>> +		error_daddr=$((start_blocks[0] + error_at_block*block_size/512))
>> +	else
>> +		# Default to the inode daddr when no extents were found.
>> +		# Errors when getfattr(1) stats the inode and doesnt get to getfattr(2)
>> +		error_daddr=$(_scratch_xfs_db -c "inode $inode" -c "daddr" | awk '{print $4}')
>> +	fi
>> +
>> +	_scratch_mount
>> +
>> +	echo "Setup scsi_debug to error when reading attributes from block" \
>> +	     "$error_at_block at daddr $error_daddr" >> $seqres.full
>> +	echo $error_daddr > /sys/module/scsi_debug/parameters/medium_error_start
>> +	echo $error_length > /sys/module/scsi_debug/parameters/medium_error_count
>> +	echo $scsi_debug_opt_error > /sys/module/scsi_debug/parameters/opts
>> +	grep ^ /sys/module/scsi_debug/parameters/{medium_error_start,medium_error_count,opts} >> $seqres.full
>> +
>> +	echo "Read the extended attribute on $testfile" >> $seqres.full
>> +	sync # the fstests logs to disk.
>> +
>> +	_getfattr -d -m - $testfile >> $seqres.full 2>&1 # Panic here on failure
>> +}
>> +
>> +# aformat shortform
>> +test_attr "attr_local" 0 0
>> +
>> +# aformat extents
>> +# Single leaf block, known to panic
>> +test_attr "attr_extent_one_block" 1 0
>> +
>> +# Other tests to exercise multi block extents
>> +test_attr "attr_extent_two_blocks_1" 2 1
>> +test_attr "attr_extent_two_blocks_2" 2 2
>> +
>> +# success, all done
>> +echo Silence is golden
>> +status=0
>> +exit
>> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
>> new file mode 100644
>> index 00000000..3b276ca8
>> --- /dev/null
>> +++ b/tests/xfs/999.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 999
>> +Silence is golden
>> -- 
>> 2.47.3
>>
>>
> 

