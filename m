Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E6A1C3F06
	for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2024 19:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730317304; cv=none; b=VAPWuji2EUu4K5hYx0mx6+XzPReiBr/3nXNxozWQiw6a+6TCzhEZPX7r7HtlPWQbu9dG+zGczi4034DYRGqEIAWhX9IO4MMqzhke6MqN3plD4mA6b8RfFJ6UsimQ7mvDZ0SCoVOiM1Zc5ceQ5sJwXsbMpkS+wQE92V3yPxcQp6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730317304; c=relaxed/simple;
	bh=5v7JZpPNIXbZGakWf5jbHZAEkbzz95hiueV0WhWMmgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRw2tVQ77zKPgF1EdOX2e4d+YY08wOVlYUyV5zjBmDNMpUhGQTUwpks60gSlCj5eNd/IokLLoAKM3N9VTFrxxWEjT1ZWghCc+Zmn2XjTBw9PZvo7TLwdxolR1CYLYzzIsS+4enyoeZkoxYPvlE8aNlOpKb2YiyTFrHIMxRCj/Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SxxoP82G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SxxoP82G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730317300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=im2WeWMM0m/HAney6qhhwXHd44WxDCRhUUDih/Yw9f0=;
	b=SxxoP82GVfnUIllAvu6YBXIfWMUYXNYrP/jBM0OD3xzfM7VIVv/nkTiWQBQzbV4R81+ko+
	hhWwPDuVFkGU3R/Ok4qr4t7yrX+2oDc4iUaW5YTmKgv1y14Wa9B15je/o7E8V7+tPMVxJb
	ac1+L1ZkZz8LdBYF/b1vlZOAU3aehB8=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-K0PdhK9AMUC-c1qmbfOwMg-1; Wed, 30 Oct 2024 15:41:39 -0400
X-MC-Unique: K0PdhK9AMUC-c1qmbfOwMg-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-71e8641f2a7so190847b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2024 12:41:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730317298; x=1730922098;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=im2WeWMM0m/HAney6qhhwXHd44WxDCRhUUDih/Yw9f0=;
        b=mHmnaEUE7d8NOY1QHJK1Pek6uCx/Zlcor9xmctV6FFluRL/JfB7uRiPIKCbiL1RdJU
         +LJLdszjK+3RKbyWhhz260ec/FDuwGQjGdg96Pl3KkxybyC9uqORmqT/VYW7NUCyOuVM
         DukNzMWpLIBrqdETTW33T/AqZXG0XXxDmq4EpMjGfG6ZunM2AJBFkyoj2ajNeowj/McJ
         vbUeikewE/7bwMpWEXsFVUhTeGWnnTit1v98TJUf3KWe/9kZ+69c4FRR6+zr0JHGBQLX
         6cjwqhUF4FFOJz0h+GchDPFxufvB13SUnhbvwmepgJfPEONbLmixaTSf2b3RNbG+V/g0
         6YHg==
X-Forwarded-Encrypted: i=1; AJvYcCWZHI/xE2AEWwI1to7pr5gl/+657RGJhnRO/+7f1vg4slmPx34uotenrzE/A6P9VRA9vzWv/T120gE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyj3LhOG7uW/uNw44yh35mWIvjsVVzkv8wtVdAU1/VVyELriiUP
	J8AzjqZPsuYBrefHu5plR27P7ieFEWNxpE0qJpKPRM3Rm8+GU/Nsau6gMm9M+dYsoEHULj8UuLV
	OAKOn5eod2SMvmpKzjDqwuGbAtUVS85G3z0DXrIF3x1h6DVDJ/14NpJDRxQ==
X-Received: by 2002:a05:6a00:1823:b0:71e:6eb:786e with SMTP id d2e1a72fcca58-72062fb21c6mr22710391b3a.13.1730317298081;
        Wed, 30 Oct 2024 12:41:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgxGc4l8ZjFP8ZAwOPVdjbP6IeQHTHvWFZ3VbAd/kLX2o4z+IeHcuYpVy6kFlTXXMKkKZS4w==
X-Received: by 2002:a05:6a00:1823:b0:71e:6eb:786e with SMTP id d2e1a72fcca58-72062fb21c6mr22710362b3a.13.1730317297586;
        Wed, 30 Oct 2024 12:41:37 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057a0c8aasm9634353b3a.100.2024.10.30.12.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 12:41:37 -0700 (PDT)
Date: Thu, 31 Oct 2024 03:41:33 +0800
From: Zorro Lang <zlang@redhat.com>
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	hch@lst.de
Subject: Re: [PATCH v2 1/2] xfs: online grow vs. log recovery stress test
Message-ID: <20241030194133.vrtci4c5ozex6thv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241029172135.329428-1-bfoster@redhat.com>
 <20241029172135.329428-2-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029172135.329428-2-bfoster@redhat.com>

On Tue, Oct 29, 2024 at 01:21:34PM -0400, Brian Foster wrote:
> fstests includes decent functional tests for online growfs and
> shrink, and decent stress tests for crash and log recovery, but no
> combination of the two. This test combines bits from a typical
> growfs stress test like xfs/104 with crash recovery cycles from a
> test like generic/388. As a result, this reproduces at least a
> couple recently fixed issues related to log recovery of online
> growfs operations.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  tests/xfs/609     | 81 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/609.out |  2 ++
>  2 files changed, 83 insertions(+)
>  create mode 100755 tests/xfs/609
>  create mode 100644 tests/xfs/609.out
> 
> diff --git a/tests/xfs/609 b/tests/xfs/609
> new file mode 100755
> index 00000000..4df966f7
> --- /dev/null
> +++ b/tests/xfs/609
> @@ -0,0 +1,81 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 609
> +#
> +# Test XFS online growfs log recovery.
> +#
> +. ./common/preamble
> +_begin_fstest auto growfs stress shutdown log recoveryloop
> +
> +# Import common functions.
> +. ./common/filter
> +
> +_stress_scratch()
> +{
> +	procs=4
> +	nops=999999
> +	# -w ensures that the only ops are ones which cause write I/O
> +	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
> +	    -n $nops $FSSTRESS_AVOID`
> +	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1 &
> +}
> +
> +_require_scratch
> +_require_command "$XFS_GROWFS_PROG" xfs_growfs
> +_require_command "$KILLALL_PROG" killall
> +
> +_cleanup()
> +{
> +	$KILLALL_ALL fsstress > /dev/null 2>&1
> +	wait
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> +. $tmp.mkfs	# extract blocksize and data size for scratch device
> +
> +endsize=`expr 550 \* 1048576`	# stop after growing this big
> +[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
> +
> +nags=4
> +size=`expr 125 \* 1048576`	# 120 megabytes initially
> +sizeb=`expr $size / $dbsize`	# in data blocks
> +logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
> +
> +_scratch_mkfs_xfs -lsize=${logblks}b -dsize=${size} -dagcount=${nags} \
> +	>> $seqres.full || _fail "mkfs failed"


This test fails on my testing machine, as [1], due to above mkfs.xfs print
a warning:

"mkfs.xfs: small data volume, ignoring data volume stripe unit 128 and stripe width 256"

My test device is scripted, if without the specific mkfs options, it got:
  # mkfs.xfs -f $SCRATCH_DEV
  meta-data=/dev/sda6              isize=512    agcount=25, agsize=1064176 blks
           =                       sectsz=512   attr=2, projid32bit=1
           =                       crc=1        finobt=1, sparse=1, rmapbt=1
           =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
           =                       exchange=0  
  data     =                       bsize=4096   blocks=26604400, imaxpct=25
           =                       sunit=16     swidth=32 blks
  naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
  log      =internal log           bsize=4096   blocks=179552, version=2
           =                       sectsz=512   sunit=16 blks, lazy-count=1
  realtime =none                   extsz=4096   blocks=0, rtextents=0

But if with the specific mkfs options, it got:

  # /usr/sbin/mkfs.xfs  -f   -lsize=3075b -dsize=131072000 -dagcount=4 $SCRATCH_DEV
  mkfs.xfs: small data volume, ignoring data volume stripe unit 128 and stripe width 256
  meta-data=/dev/sda6              isize=512    agcount=4, agsize=8000 blks
           =                       sectsz=512   attr=2, projid32bit=1
           =                       crc=1        finobt=1, sparse=1, rmapbt=1
           =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
           =                       exchange=0  
  data     =                       bsize=4096   blocks=32000, imaxpct=25
           =                       sunit=0      swidth=0 blks
  naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
  log      =internal log           bsize=4096   blocks=3075, version=2
           =                       sectsz=512   sunit=0 blks, lazy-count=1
  realtime =none                   extsz=4096   blocks=0, rtextents=0

Hi Brian, if you think "ignoreing volume stripe" doesn't affect the test, we can
filter out the stderr with "2>&1". I can help to change that when I merge.

Others looks good to me, with above confirmation:

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

[1]
SECTION       -- default
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 dell-per750-41 6.11.0-0.rc6.49.fc42.x86_64+debug #1 SMP PREEMPT_DYNAMIC Mon Sep  2 02:18:15 UTC 2024
MKFS_OPTIONS  -- -f /dev/sda6
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda6 /mnt/scratch

xfs/609       [failed, exit status 1]_check_dmesg: something found in dmesg (see /root/git/xfstests/results//default/xfs/609.dmesg)
- output mismatch (see /root/git/xfstests/results//default/xfs/609.out.bad)
    --- tests/xfs/609.out       2024-10-30 16:29:52.250176790 +0800
    +++ /root/git/xfstests/results//default/xfs/609.out.bad     2024-10-30 16:31:01.759590117 +0800
    @@ -1,2 +1,2 @@
     QA output created by 609
    -Silence is golden.
    +mkfs.xfs: small data volume, ignoring data volume stripe unit 128 and stripe width 256
    ...
    (Run 'diff -u /root/git/xfstests/tests/xfs/609.out /root/git/xfstests/results//default/xfs/609.out.bad'  to see the entire diff)
xfs/610       [not run] External volumes not in use, skipped this test
Ran: xfs/609 xfs/610
Not run: xfs/610
Failures: xfs/609
Failed 1 of 2 tests


> +_scratch_mount
> +
> +# Grow the filesystem in random sized chunks while stressing and performing
> +# shutdown and recovery. The randomization is intended to create a mix of sub-ag
> +# and multi-ag grows.
> +while [ $size -le $endsize ]; do
> +	echo "*** stressing a ${sizeb} block filesystem" >> $seqres.full
> +	_stress_scratch
> +	incsize=$((RANDOM % 40 * 1048576))
> +	size=`expr $size + $incsize`
> +	sizeb=`expr $size / $dbsize`	# in data blocks
> +	echo "*** growing to a ${sizeb} block filesystem" >> $seqres.full
> +	$XFS_GROWFS_PROG -D ${sizeb} $SCRATCH_MNT >> $seqres.full
> +
> +	sleep $((RANDOM % 3))
> +	_scratch_shutdown
> +	ps -e | grep fsstress > /dev/null 2>&1
> +	while [ $? -eq 0 ]; do
> +		$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> +		wait > /dev/null 2>&1
> +		ps -e | grep fsstress > /dev/null 2>&1
> +	done
> +	_scratch_cycle_mount || _fail "cycle mount failed"
> +done > /dev/null 2>&1
> +wait	# stop for any remaining stress processes
> +
> +_scratch_unmount
> +
> +echo Silence is golden.
> +
> +status=0
> +exit
> diff --git a/tests/xfs/609.out b/tests/xfs/609.out
> new file mode 100644
> index 00000000..8be27d3a
> --- /dev/null
> +++ b/tests/xfs/609.out
> @@ -0,0 +1,2 @@
> +QA output created by 609
> +Silence is golden.
> -- 
> 2.46.2
> 
> 

