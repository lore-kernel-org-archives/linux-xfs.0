Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F01199EAD
	for <linux-xfs@vger.kernel.org>; Wed, 31 Dec 2025 22:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767219354; cv=none; b=tGja2iDAXmH8rPH7+gS+rBtKTn7k/aog8Ix2xD2OysFp8q4+cpdXVu/To+mjg82Y4wPwdnS/z9daiLQ3j/uiNf7qtEHa4ohjT/2USzCTbRKeo7z61ndWQqf4L08XRdRXI6nRInPvonxoFkpIA6GYv5u8exbyIARE1CHvOclFyGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767219354; c=relaxed/simple;
	bh=CPFbzQSnyGdRfse6VhOmKNp9pKpfXiifw4ZdLynMaDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5TKBStOLml6e/MSAdGHF8A49ASN7pg6lBeR+2wS92odCU4A2mqaOzWGcULDXO19HI6fdvifaxLkZzHj/djTNWvEM2wVsd1Q7WwHioZnTztqK9iJXxHI0STRnUfQcY8n9ynT1En4JQZXD98et/fQHYHmQGil/QNBylCTTLDXtXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G0vJTF0O; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=i661ZICV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G0vJTF0O";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="i661ZICV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767219351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VlAB3B0xJcewySBnPWve3s0J1CjpdgIHv2pKePHWa7M=;
	b=G0vJTF0OAQWnsrQu4JHuvpK5R9mhv0QXiCfrbgQTtO5p3CmPLOo1eJX7T41MHo89UvppS2
	VNUhVpWNdHIza28F3t8xZsn6JdDWIJPh7IceVzO/P91qvoQgiEj7WwtS/fTl8eL+rW+KIz
	GV3ww8ETMMyFlXOnSVNOJj8DqwY69DI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-HqzgESjEPOeyBaHuwKWbTw-1; Wed, 31 Dec 2025 17:15:48 -0500
X-MC-Unique: HqzgESjEPOeyBaHuwKWbTw-1
X-Mimecast-MFC-AGG-ID: HqzgESjEPOeyBaHuwKWbTw_1767219347
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34ab8aafd24so8286907a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 31 Dec 2025 14:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767219347; x=1767824147; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VlAB3B0xJcewySBnPWve3s0J1CjpdgIHv2pKePHWa7M=;
        b=i661ZICVOXeuhMmwEdlV8R8J73SbFq3857EIYykiAz84kkbcXHiojldNAb6Zr4kdCc
         U9vf/wH47yxH3D85N2do+xCyHEmIvIsCPdcW455I80DUX3oOas1seu2Si7K3HmZm0+oq
         XIcMue3Sp49aqmb9p0fOfe9HKpKU6/1RCZ89UR5RVDNIet0qiHdim4aaIArgxcLUq46a
         g4Mgx4S1cC8tJcbznUf8aqqkjltHQ1AK0Zwj8pKRtgqTwvYg5y7BzXDBDmncdpuDD/qO
         ihCNWBk3qxiJ6JPGUllQjodDAB2E0pBm3sChyJQTqLpbpCK+0VH1+nbFNYqLPWlSWKkq
         /AgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767219347; x=1767824147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VlAB3B0xJcewySBnPWve3s0J1CjpdgIHv2pKePHWa7M=;
        b=jxeVmXVD07Afzi4pScBgLzwOcSG5gKMjE2ZJ4HaWxcAuiBMNzTvdl46QJ4mWlhkDTK
         gHOcnAPTJzQIgJPvpxd2PPMFdDxTWBfzHc52X7IgF/IsLvfL7mWtBTHKf0x1XyWCk1ib
         IjW4dXAzE49pcsVgNZeiH0DXHE8u3jLJMTQYWSwYhuCNcu/8seJDRZUCdIRJRqrsPVp4
         7gBjjhKZHA5aMEPs1o6p24V75GA1xGW1edbrCgyJ9f/3qYUHbybSqk9YzJVwPd70AAif
         Z+xjbG4fCrjyugyYr46EqT7bEEdmSxV+qSu9mLdAvxsiuW6MMhU3h38QodvgSM/GYf57
         Ls/w==
X-Gm-Message-State: AOJu0YwNNrLxQGVbmId4+XipJSRcMvq2S74WliWhOXhIhE0Ir0o0WofK
	3xVrb61SVvO6Nf9raynwgT/kTW7fhaGN7WEV6uL/xxrYCPcPvCbVRhsGwgs6HJhWdQUCDL9KulL
	u3q8wc7Wa1P23T1h4ZGtCGfGnZn+SjREiPSbY5iWaWQVt61nvfnfoaQf4e4ah5Q==
X-Gm-Gg: AY/fxX6mj1hPSiyA6u6BTxzPttuI6EEuOgDocquokeCSeAZeLWMY6ldNAnNhUHXpUn+
	VYTKpnbeGfEFp7v+xA2XnvlHeF1bfWpp+93yq213/56VgnN2x2SUM5FdXzFGxQsiU4Dsgve4AYb
	rswis2WnA0Xq0VojyKGuU1QUU2U4kW6ETrKDoBjR2oxHo+MFfoU/SPmCRfCJOCAtIm9fzkNEYXI
	kWmIpBeiTtD8dC3scKIOjOMmxJqHNsnCGZnWWeqRarWYoM26aB+1QWXe7rqRWOQTDs6atAsWA0d
	BX9PcGaUflJp3zMOnlM7BDBIVawlu+A+zS5aWPZhEXkyFcIMzvQZXR0EVw4UD9EVo0Xxy7+WEXa
	694XDUqvom2Z1d5SuWPfpFLcDBNBQ9kVrpeH2cFruuI2pq9nNSQ==
X-Received: by 2002:a17:90b:582f:b0:34c:ab9b:76c4 with SMTP id 98e67ed59e1d1-34e90c381ffmr33258552a91.0.1767219346947;
        Wed, 31 Dec 2025 14:15:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGUm+WVG5dbQtIZAS81wGWbMobEWLDNv90BBhuMRadMX4J7leh9Q5GDsnSryAsHq38K3AAGRA==
X-Received: by 2002:a17:90b:582f:b0:34c:ab9b:76c4 with SMTP id 98e67ed59e1d1-34e90c381ffmr33258538a91.0.1767219346433;
        Wed, 31 Dec 2025 14:15:46 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e772ac1basm15923637a91.10.2025.12.31.14.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 14:15:45 -0800 (PST)
Date: Thu, 1 Jan 2026 06:15:41 +0800
From: Zorro Lang <zlang@redhat.com>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
	hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH v5] xfs: test reproducible builds
Message-ID: <20251231221541.td3l6vf6sjkyop4n@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251217110653.2969069-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217110653.2969069-1-luca.dimaio1@gmail.com>

On Wed, Dec 17, 2025 at 12:06:53PM +0100, Luca Di Maio wrote:
> With the addition of the `-p` populate option, SOURCE_DATE_EPOCH and
> DETERMINISTIC_SEED support, it is possible to create fully reproducible
> pre-populated filesystems. We should test them here.
> 
> v1 -> v2:
> - Changed test group from parent to mkfs
> - Fixed PROTO_DIR to point to a new dir
> - Populate PROTO_DIR with relevant file types
> - Move from md5sum to sha256sum
> v2 -> v3
> - Properly check if mkfs.xfs supports SOURCE_DATE_EPOCH and
>   DETERMINISTIC_SEED
> - use fsstress program to generate the PROTO_DIR content
> - simplify test output
> v3 -> v4
> - Add _cleanup function
> v4 -> v5
> - copy _cleanup from common/preamble
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> ---
>  tests/xfs/841     | 173 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/841.out |   3 +
>  2 files changed, 176 insertions(+)
>  create mode 100755 tests/xfs/841
>  create mode 100644 tests/xfs/841.out
> 
> diff --git a/tests/xfs/841 b/tests/xfs/841
> new file mode 100755
> index 00000000..60982a41
> --- /dev/null
> +++ b/tests/xfs/841
> @@ -0,0 +1,173 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Chainguard, Inc. All Rights Reserved.
> +#
> +# FS QA Test No. 841
> +#
> +# Test that XFS filesystems created with reproducibility options produce
> +# identical images across multiple runs. This verifies that the combination
> +# of SOURCE_DATE_EPOCH, DETERMINISTIC_SEED, and -m uuid= options result in
> +# bit-for-bit reproducible filesystem images.
> +
> +. ./common/preamble
> +_begin_fstest auto quick mkfs
> +
> +# Image file settings
> +IMG_SIZE="512M"
> +IMG_FILE="$TEST_DIR/xfs_reproducible_test.img"
> +PROTO_DIR="$TEST_DIR/proto"
> +
> +# Fixed values for reproducibility
> +FIXED_UUID="12345678-1234-1234-1234-123456789abc"
> +FIXED_EPOCH="1234567890"
> +
> +_cleanup() {
> +	cd /
> +	command -v _kill_fsstress &>/dev/null && _kill_fsstress
> +	rm -r -f $tmp.* "$PROTO_DIR" "$IMG_FILE"
> +}
> +
> +# Check if mkfs.xfs supports required options
> +_check_mkfs_xfs_options()
> +{
> +	local check_img="$TEST_DIR/mkfs_check.img"
> +	truncate -s 64M "$check_img" || return 1
> +
> +	# Check -m uuid support
> +	$MKFS_XFS_PROG -m uuid=00000000-0000-0000-0000-000000000000 \
> +		-N "$check_img" &> /dev/null
> +	local uuid_support=$?
> +
> +	# Check -p support (protofile/directory population)
> +	$MKFS_XFS_PROG 2>&1 | grep populate &> /dev/null
> +	local proto_support=$?
> +
> +	grep -q SOURCE_DATE_EPOCH "$MKFS_XFS_PROG"
> +	local reproducible_support=$?
> +
> +	rm -f "$check_img"
> +
> +	if [ $uuid_support -ne 0 ]; then
> +		_notrun "mkfs.xfs does not support -m uuid= option"
> +	fi
> +	if [ $proto_support -ne 0 ]; then
> +		_notrun "mkfs.xfs does not support -p option for directory population"
> +	fi
> +	if [ $reproducible_support -ne 0 ]; then
> +		_notrun "mkfs.xfs does not support env options for reproducibility"
> +	fi
> +}
> +
> +# Create a prototype directory with all file types supported by mkfs.xfs -p
> +_create_proto_dir()
> +{
> +	rm -rf "$PROTO_DIR"
> +	mkdir -p "$PROTO_DIR"
> +
> +	$FSSTRESS_PROG -d $PROTO_DIR -s 1 $F -n 2000 -p 2 -z \
                                          ^^

 Sorry, what's the $F? 

> +		-f creat=15 \
> +		-f mkdir=8 \
> +		-f write=15 \
> +		-f truncate=5 \
> +		-f symlink=8 \
> +		-f link=8 \
> +		-f setfattr=12 \
> +		-f chown=3 \
> +		-f rename=5 \
> +		-f unlink=2 \
> +		-f rmdir=1

I think you can write this part as:

        FSSTRESS_ARGS=`_scale_fsstress_args -d $PROTO_DIR -s 1 -n 2000 -p 2 -z
                -f creat=15 \
                -f mkdir=8 \
                -f write=15 \
                -f truncate=5 \
                -f symlink=8 \
                -f link=8 \
                -f setfattr=12 \
                -f chown=3 \
                -f rename=5 \
                -f unlink=2 \
                -f rmdir=1`
        _run_fsstress $FSSTRESS_ARGS

I tried to merge this patch with this change, but I don't what's the $F for, so
ask you for sure :)

Thanks,
Zorro

> +
> +
> +	# FIFO (named pipe)
> +	mkfifo "$PROTO_DIR/fifo"
> +
> +	# Unix socket
> +	$here/src/af_unix "$PROTO_DIR/socket" 2> /dev/null || true
> +
> +	# Block device (requires root)
> +	mknod "$PROTO_DIR/blockdev" b 1 0 2> /dev/null || true
> +
> +	# Character device (requires root)
> +	mknod "$PROTO_DIR/chardev" c 1 3 2> /dev/null || true
> +}
> +
> +_require_test
> +_check_mkfs_xfs_options
> +
> +# Create XFS filesystem with full reproducibility options
> +# Uses -p to populate from directory during mkfs (no mount needed)
> +_mkfs_xfs_reproducible()
> +{
> +	local img=$1
> +
> +	# Create fresh image file
> +	rm -f "$img"
> +	truncate -s $IMG_SIZE "$img" || return 1
> +
> +	# Set environment variables for reproducibility:
> +	# - SOURCE_DATE_EPOCH: fixes all inode timestamps to this value
> +	# - DETERMINISTIC_SEED: uses fixed seed (0x53454544) instead of
> +	#   getrandom()
> +	#
> +	# mkfs.xfs options:
> +	# - -m uuid=: fixed filesystem UUID
> +	# - -p dir: populate filesystem from directory during creation
> +	SOURCE_DATE_EPOCH=$FIXED_EPOCH \
> +	DETERMINISTIC_SEED=1 \
> +	$MKFS_XFS_PROG \
> +		-f \
> +		-m uuid=$FIXED_UUID \
> +		-p "$PROTO_DIR" \
> +		"$img" >> $seqres.full 2>&1
> +
> +	return $?
> +}
> +
> +# Compute hash of the image file
> +_hash_image()
> +{
> +	sha256sum "$1" | awk '{print $1}'
> +}
> +
> +# Run a single reproducibility test iteration
> +_run_iteration()
> +{
> +	local iteration=$1
> +
> +	echo "Iteration $iteration: Creating filesystem with -p $PROTO_DIR" >> $seqres.full
> +	if ! _mkfs_xfs_reproducible "$IMG_FILE"; then
> +		echo "mkfs.xfs failed" >> $seqres.full
> +		return 1
> +	fi
> +
> +	local hash=$(_hash_image "$IMG_FILE")
> +	echo "Iteration $iteration: Hash = $hash" >> $seqres.full
> +
> +	echo $hash
> +}
> +
> +# Create the prototype directory with various file types
> +_create_proto_dir
> +
> +echo "Test: XFS reproducible filesystem image creation"
> +
> +# Run three iterations
> +hash1=$(_run_iteration 1)
> +[ -z "$hash1" ] && _fail "Iteration 1 failed"
> +
> +hash2=$(_run_iteration 2)
> +[ -z "$hash2" ] && _fail "Iteration 2 failed"
> +
> +hash3=$(_run_iteration 3)
> +[ -z "$hash3" ] && _fail "Iteration 3 failed"
> +
> +# Verify all hashes match
> +if [ "$hash1" = "$hash2" ] && [ "$hash2" = "$hash3" ]; then
> +	echo "All filesystem images are identical."
> +else
> +	echo "ERROR: Filesystem images differ!"
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/841.out b/tests/xfs/841.out
> new file mode 100644
> index 00000000..3bdfbfda
> --- /dev/null
> +++ b/tests/xfs/841.out
> @@ -0,0 +1,3 @@
> +QA output created by 841
> +Test: XFS reproducible filesystem image creation
> +All filesystem images are identical.
> -- 
> 2.52.0
> 
> 

