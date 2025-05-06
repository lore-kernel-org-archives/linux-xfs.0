Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30632147EE
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 19:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746561492; cv=none; b=b9Pn9TMrq+lXLujb1+QJTS4qHC9pZmuMqH7ea4EF7VPNeXwZxMp3kHt3eFk8/iNkoUwr2lcDkoIWCSuVTqMtJfIaeaOQ59S5hs57cYfm3v09SQE7jyfSAakVzUNM8wztgy9l7ktLxS4EEwee+8OqXgDruE5lTZJ6hYGX7Q0nrpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746561492; c=relaxed/simple;
	bh=pxOumpn8edzvQUJ1t2Q9X98SP1tCY7dDbklEqXK7W7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCAcs25F5FBcPek9VrkzZxCtfF5yHdstIIv/UBtuHZhl2KUI208n85jDzT2f7J2h94EuIebPhy/O11eF3EQmtvFTrtqSQ9rfBVYXOO0TeSNSrGcgS+R6c+G8l7Z1Bd1f6Q6Ro2GfdyvCo9tZCaAWK176pyeQPGaR4bgKxxoFYf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NDhI666w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NDhI666w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746561490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sRZQT0CskZdtv6TLYE7RW1NOGw+9GRWZW23abSS5fgU=;
	b=NDhI666wfki8HoNuxXIL7SBw6ED2S3CgEoRIB6Jvg866UrwCe5iLeCfi+54uarkdtRny7J
	P6zGZDzu9f74dNgOWnWkFirXTziISg5DV7sHlqgxRLQiRxbhbTCudi3egg3nu/TbyjNsTw
	n6O4RyHaMKHqibT6NIS0YP1HyWdg9mg=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-BmQEFYe8MvOw5TvH39PZeQ-1; Tue, 06 May 2025 15:58:09 -0400
X-MC-Unique: BmQEFYe8MvOw5TvH39PZeQ-1
X-Mimecast-MFC-AGG-ID: BmQEFYe8MvOw5TvH39PZeQ_1746561488
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-740774348f6so2316531b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 06 May 2025 12:58:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746561488; x=1747166288;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sRZQT0CskZdtv6TLYE7RW1NOGw+9GRWZW23abSS5fgU=;
        b=Pz3uWl2j6QSYHeeNE7ZZON651MV0L51jTIoARTG1yWgd6iJhAmbWRgFBNJgeexkl89
         4WOYZvsTcMEZIU0ai+7t5EiVRPFUce4vfcO46X+ahBCY0ghJNd4FDU85XeEC0o45kY9Y
         ShfLIZ0akN6fEy7AFEVSC8Ev1IZ9vqAEbhuSvd5D+Diyvi6EU5ql6E+cbcckqv4b10qQ
         BOor66MG5R4Y1FTYiVps1u/UnmPcOPrRrRdFUHNJlHIPgfCjq4Cyd0L/u7ZF39XfgtDN
         FA5xYYblCVQRb1bh3MOUxoDWbDZfT2kPFrOv5RkwzgtJmH9bOHZ2KlIFyRDei8ZcHYsB
         I4EA==
X-Forwarded-Encrypted: i=1; AJvYcCXvsav3uxX5KwwEW0AFArnjrpXDxv3cxH4wx0cX1/SDAVffvtZHlmFz+zTAudnTW/grvmPYGXZf9gs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm7mNqaO2i4ShIl8AE6N/As89io4kMEUr6BVeAOf4DyDGcLxoo
	EQ8kgVPoivmY8CCaH+Xf+fqlgo28+lG4rihBJJIKEqUpb5ZV+KcQjtqOx36QinnoTZeFXNtPTgt
	l3i1mL+XP4riQawknUgqUtIcv4ge/onYpvLwNJ/PgESCKdz7mOaaE9pjaJg==
X-Gm-Gg: ASbGncs0TKByZ6Srr3YaEGRgRNoNkAbsAf+OjyZLuABn92GJ3dtnksPkmEWWVgBpuWS
	GTHEoSPBwJXV3vUwm82qFtyJPpVMGjBOOo3++dQR1U3bhWaY744PwjaTM6jjNq5X59k3s2nPGT3
	Fo/cLo7rm6XAxs/zUhFeFeViLl8q2Uzsi4drMerRIBA4nE0AnNdiYamvPz9wgJnoNfnbr/mOAPY
	8hJgoRrjZFyaT5iOn6bAaqW1kWIo+36ACF+eslV/rSiEWzVT1/QQx/kW9tFyh1x5XVrVqUeTcCT
	RnxwaVPtkm5fEypC7kFvGegxP7KVLj69/7GlUgF3qBEBte1ZF7S5
X-Received: by 2002:a05:6a00:4ac5:b0:740:4fd8:a2bc with SMTP id d2e1a72fcca58-7409cedc76cmr578474b3a.5.1746561487897;
        Tue, 06 May 2025 12:58:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9SS168JCQ2w3sutqRcY4MbXLmEZ46nNtyhOav5Kb/9lrDR2KSYAvkslDrnz9O7fJ1B3Pmpg==
X-Received: by 2002:a05:6a00:4ac5:b0:740:4fd8:a2bc with SMTP id d2e1a72fcca58-7409cedc76cmr578442b3a.5.1746561487486;
        Tue, 06 May 2025 12:58:07 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3c3da9dsm8033783a12.50.2025.05.06.12.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 12:58:07 -0700 (PDT)
Date: Wed, 7 May 2025 03:58:02 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/15] xfs: test zoned ENOSPC behavior with multiple
 writers
Message-ID: <20250506195802.vxgqxhvxrdfeh6ch@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250501134302.2881773-1-hch@lst.de>
 <20250501134302.2881773-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501134302.2881773-11-hch@lst.de>

On Thu, May 01, 2025 at 08:42:47AM -0500, Christoph Hellwig wrote:
> Test that multiple parallel writers can't accidentally dip into the reserved
> space pool.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/4209     | 90 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/4209.out |  2 ++
>  2 files changed, 92 insertions(+)
>  create mode 100755 tests/xfs/4209
>  create mode 100644 tests/xfs/4209.out
> 
> diff --git a/tests/xfs/4209 b/tests/xfs/4209
> new file mode 100755
> index 000000000000..18c84a968c40
> --- /dev/null
> +++ b/tests/xfs/4209
> @@ -0,0 +1,90 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Christoph Hellwig.
> +#
> +# FS QA Test No. 4209
> +#
> +# Test that multiple parallel writers can't accidentally dip into the reserved
> +# space pool.
> +#
> +. ./common/preamble
> +_begin_fstest quick auto rw zone enospc
> +
> +_cleanup()
> +{
> +	cd /
> +	_scratch_unmount >/dev/null 2>&1

Same review points with patch 8/15

> +}
> +
> +# Import common functions.
> +. ./common/filter

Looks like this case doesn't use any filter helper.

> +. ./common/zoned
> +
> +_require_scratch
> +
> +_scratch_mkfs_sized $((256 * 1024 * 1024))  >>$seqres.full 2>&1
> +
> +# limit to two max open zones so that all writes get thrown into the blender
> +export MOUNT_OPTIONS="$MOUNT_OPTIONS -o max_open_zones=2"
> +_try_scratch_mount || _notrun "mount option not supported"
> +_require_xfs_scratch_zoned
> +
> +fio_config=$tmp.fio
> +
> +cat >$fio_config <<EOF
> +[global]
> +bs=64k
> +iodepth=16
> +iodepth_batch=8
> +directory=$SCRATCH_MNT
> +ioengine=libaio
> +rw=write
> +direct=1

Same review points with patch 8/15

> +size=60m
> +
> +[file1]
> +filename=file1
> +
> +[file2]
> +filename=file2
> +
> +[file3]
> +filename=file3
> +
> +[file4]
> +filename=file4
> +
> +[file5]
> +filename=file5
> +
> +[file6]
> +filename=file6
> +
> +[file7]
> +filename=file7
> +
> +[file8]
> +filename=file8
> +EOF
> +
> +_require_fio $fio_config
> +
> +# try to overfill the file system
> +$FIO_PROG $fio_config 2>&1 | \
> +	grep -q "No space left on dev" || \
> +	_fail "Overfill did not cause ENOSPC"
> +
> +sync
> +
> +#
> +# Compare the df and du values to ensure we did not overshoot
> +#
> +# Use within_tolerance to paper over the fact that the du output includes
> +# the root inode, which does not sit in the RT device, while df does not
> +#
> +df_val=`df --output=size $SCRATCH_MNT | tail -n 1`
> +du_val=`du -s $SCRATCH_MNT | awk '{print $1}'`
> +_within_tolerance "file space usage" $df_val $du_val 64 -v
> +
> +status=0
> +exit
> diff --git a/tests/xfs/4209.out b/tests/xfs/4209.out
> new file mode 100644
> index 000000000000..cb72138a1bf6
> --- /dev/null
> +++ b/tests/xfs/4209.out
> @@ -0,0 +1,2 @@
> +QA output created by 4209
> +file space usage is in range
> -- 
> 2.47.2
> 

