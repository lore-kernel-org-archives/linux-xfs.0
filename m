Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35AF1CD23
	for <linux-xfs@vger.kernel.org>; Thu, 29 Feb 2024 00:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709167949; cv=none; b=D4fXLugTR+23cDvsbX1ESJQ47qntPkCcKsQN25Eo9TpHDyPm/u+DYoa/JeXXgkoXqdgnCp7IWsfuH1uylxiwV4R6p22aOWNYI3sU+4zDq+2nx07rJ1NQeHKF3CcJV90deMHaPylRp1dk9mm9otU5nakKWuifrm5GoCgWUMONTGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709167949; c=relaxed/simple;
	bh=7kiqRo4C79jX86NZ18PktkpiDlDKvHpWW3tGyaFWQzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kkxTi6r7onM7TGsFvfxRGblX/6uhYwG/xYEu90+uYCeyjmw+GSy7vEBi3gvlu6CddaNM4PqshASJBjcgHe07qJtekKq5Zv2DTNxtBGU8wGNoX+KbP9gaho8jGfw50xHbz3O+JF1DXPXdvfpVnlRAX4mDzu6Uvk3BCdwdDhd7Fb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Avj5Zc3H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Avj5Zc3H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709167945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S4Z4XMdfXLVsJomLpJcEF3QLXH+UPaiCBCHNXDpOapE=;
	b=Avj5Zc3HarSU1mmG2wQfo9vDuUcNTzlg5S2u1ptmjOSSyRU/bQXgKzr6+l/g4VjhBsXLtT
	b5Q1qwhcZhwOOtJqIw7IdD1VVSfKJ9AoTnnOha+rpwPs1m5utfQmCPMFRkaKlwdRhPRWq4
	N3Lof9TUsnr5M0C++/18FouMTfS77Hk=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-XKMZavyEO4mi2VMjP0z3PQ-1; Wed, 28 Feb 2024 19:52:23 -0500
X-MC-Unique: XKMZavyEO4mi2VMjP0z3PQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1dcabec8fddso3624555ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 16:52:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709167942; x=1709772742;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S4Z4XMdfXLVsJomLpJcEF3QLXH+UPaiCBCHNXDpOapE=;
        b=r/bcKdqoq4bEiiGiJEUkwVfFvqqZIHoc+B5wPNWiR7wiZo+UBPsflbi+LqCx62hc2G
         NVFOsE2KAkGYHs2iZ+FTCwjzYExNE15Qlp85v5fGCK/NSfqzY4BU3SLF1iv6wMXX2xcu
         nQUzXGv8nisWle9/qUO3M1HDKhtZbQPzLX7FA0fUl6/6/0sF2YXj42pW6YUQV3zTGEUv
         W10sX5WUXTR2qp9bJwxxkdr1JMLmEww6amPaLHTv6/s5X4BR3WBdLHS/JoCH3D6nQVTK
         zo+ZPet7c1npaRPA9kh5fdInkstcjVsCQvrkrSi2fH4JlnjanK/HWz6LOSV4kziOXIVy
         tjhw==
X-Forwarded-Encrypted: i=1; AJvYcCUeYWimkSLCwAKGS/qxCPMzgibnp56xTMbS1AHVAN5liDd61SnegXUCujC+y5SZFLs/N5NCx0gTawJ9DtcB/lDZgExQ931awrlZ
X-Gm-Message-State: AOJu0YzACJyAK6D9AElgnInJr+ZEcYVXopUr8Mgpe0dd717IiqbGZ656
	hCb4hD9CSripxwR3xxuGZNqidL000Kabv9V4VV0GVSe9eeBSk3hP/AX11+0JgAHxGrOx5HYUCCe
	HGnq3e9o8DXl0DGsGR4Jybu6YQv1F48Ly88THOjqY/Aol2iyMj0oczvqUow==
X-Received: by 2002:a17:902:c155:b0:1db:c3cb:b088 with SMTP id 21-20020a170902c15500b001dbc3cbb088mr635629plj.35.1709167942500;
        Wed, 28 Feb 2024 16:52:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHddbT9jLp0nFF1SIAMxDtA7omHOJn5KfcUqbi8RyeXC3q/MWfBxPHm7PHVB+A37liroboBFQ==
X-Received: by 2002:a17:902:c155:b0:1db:c3cb:b088 with SMTP id 21-20020a170902c15500b001dbc3cbb088mr635617plj.35.1709167942098;
        Wed, 28 Feb 2024 16:52:22 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c7-20020a170902d48700b001db5079b705sm76031plg.36.2024.02.28.16.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 16:52:21 -0800 (PST)
Date: Thu, 29 Feb 2024 08:52:18 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] generic: check logical-sector sized O_DIRECT
Message-ID: <20240229005218.pwgakn5x3fwwcjnj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20221107045618.2772009-1-zlang@kernel.org>
 <20240228155929.GD1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228155929.GD1927156@frogsfrogsfrogs>

On Wed, Feb 28, 2024 at 07:59:29AM -0800, Darrick J. Wong wrote:
> On Mon, Nov 07, 2022 at 12:56:18PM +0800, Zorro Lang wrote:
> > If the physical sector size is 4096, but the logical sector size
> > is 512, the 512b dio write/read should be allowed.
> 
> Huh, did we all completely forget to review this patch?

Hmm?? This patch has been reviewed and merged in 2022, refer to g/704.
Why did it appear (be refreshed) at here suddenly ?

> 
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> > 
> > Hi,
> > 
> > This reproducer was written for xfs, I try to make it to be a generic
> > test case for localfs. Current it test passed on xfs, extN and btrfs,
> > the bug can be reproduced on old rhel-6.6 [1]. If it's not right for
> > someone fs, please feel free to tell me.
> > 
> > Thanks,
> > Zorro
> > 
> > [1]
> > # ./check generic/888
> > FSTYP         -- xfs (non-debug)
> > PLATFORM      -- Linux/x86_64 xxx-xxxxx-xxxxxx 2.6.32-504.el6.x86_64
> > MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop1
> > MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/loop1 /mnt/scratch
> > 
> > generic/888      - output mismatch (see /root/xfstests-dev/results//generic/888.out.bad)
> >     --- tests/generic/888.out   2022-11-06 23:42:44.683040977 -0500
> >     +++ /root/xfstests-dev/results//generic/888.out.bad 2022-11-06 23:48:33.986481844 -0500
> >     @@ -4,3 +4,4 @@
> >      512
> >      mkfs and mount
> >      DIO read/write 512 bytes
> >     +pwrite64: Invalid argument
> >     ...
> >     (Run 'diff -u tests/generic/888.out /root/xfstests-dev/results//generic/888.out.bad'  to see the entire diff)
> > Ran: generic/888
> > Failures: generic/888
> > Failed 1 of 1 tests
> > 
> >  tests/generic/888     | 52 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/888.out |  6 +++++
> >  2 files changed, 58 insertions(+)
> >  create mode 100755 tests/generic/888
> >  create mode 100644 tests/generic/888.out
> > 
> > diff --git a/tests/generic/888 b/tests/generic/888
> > new file mode 100755
> > index 00000000..b5075d1e
> > --- /dev/null
> > +++ b/tests/generic/888
> > @@ -0,0 +1,52 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 888
> > +#
> > +# Make sure logical-sector sized O_DIRECT write is allowed
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick
> > +
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -r -f $tmp.*
> > +	[ -d "$SCSI_DEBUG_MNT" ] && $UMOUNT_PROG $SCSI_DEBUG_MNT 2>/dev/null
> > +	_put_scsi_debug_dev
> > +}
> > +
> > +# Import common functions.
> > +. ./common/scsi_debug
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_fixed_by_kernel_commit 7c71ee78031c "xfs: allow logical-sector sized O_DIRECT"
> > +_require_scsi_debug
> > +# If TEST_DEV is block device, make sure current fs is a localfs which can be
> > +# written on scsi_debug device
> > +_require_test
> > +_require_block_device $TEST_DEV
> 
> _require_odirect?
> 
> > +
> > +echo "Get a device with 4096 physical sector size and 512 logical sector size"
> > +SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 256`
> > +blockdev --getpbsz --getss $SCSI_DEBUG_DEV
> > +
> > +echo "mkfs and mount"
> > +_mkfs_dev $SCSI_DEBUG_DEV || _fail "Can't make $FSTYP on scsi_debug device"
> > +SCSI_DEBUG_MNT="$TEST_DIR/scsi_debug_$seq"
> > +rm -rf $SCSI_DEBUG_MNT
> > +mkdir $SCSI_DEBUG_MNT
> > +run_check _mount $SCSI_DEBUG_DEV $SCSI_DEBUG_MNT
> 
> /me wonders, should we try to use $MKFS_OPTIONS and $MOUNT_OPTIONS
> on the scsidebug device?  To catch cases where the config actually
> matters for that kind of thing?

It's been merged, if we need to change something, better to send a new
patch to change that :)

Thanks,
Zorro

> 
> --D
> 
> > +
> > +echo "DIO read/write 512 bytes"
> > +# This dio write should succeed, even the physical sector size is 4096, but
> > +# the logical sector size is 512
> > +$XFS_IO_PROG -d -f -c "pwrite 0 512" $SCSI_DEBUG_MNT/testfile >> $seqres.full
> > +$XFS_IO_PROG -d -c "pread 0 512" $SCSI_DEBUG_MNT/testfile >> $seqres.full
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/888.out b/tests/generic/888.out
> > new file mode 100644
> > index 00000000..0f142ce9
> > --- /dev/null
> > +++ b/tests/generic/888.out
> > @@ -0,0 +1,6 @@
> > +QA output created by 888
> > +Get a device with 4096 physical sector size and 512 logical sector size
> > +4096
> > +512
> > +mkfs and mount
> > +DIO read/write 512 bytes
> > -- 
> > 2.31.1
> > 
> 

