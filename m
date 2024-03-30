Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62358479
	for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2024 07:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711782733; cv=none; b=CL46VAHNW7mE3JVt9w+3WDGuwt6dwgK6zKxuhM43wjvIRmOTFuh3vVUpx9u3HSUOpqVDUDLfNDwpXRJNbBs8s42TM7AxEGKDGJz1+c+wOOQW0/m2wcSrSIfCr624Harlykodd/Fb//+DPp+T1MRQmp+iOjJNdpY+IKoW3GCcGR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711782733; c=relaxed/simple;
	bh=l0qm6+C94zwsm/rezM2g/KDziYftbBxRBGvW5LdvXxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OT5erWLwtvnVlCeiHIlauHbcyLC8P3WSmifJciLjSAe6Pz1p1Wm0S5f4m0GHipSXNJHTy0iRGENKatWazwf0yenX3kuyzr+ptrtJVnplQRS90s/hnd3cllmAIQqCQS5Vf07lCqn3etzFp99I8k9YXMe0Rm0cAZvVlR2vBZ7kE0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VdLayx1Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VdLayx1Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711782730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wSfuh3hgBN5v+TJQtMt4wHJKKzn/IMeC4fo6vXTl7gQ=;
	b=VdLayx1YyBkbi8qhgw9yNo+2unhqBfK8+5BUvRGzNLTqOvVfPFEbRiyuCn4VZg66xD71Z+
	q2w6iX4gzEO/0NKgfdsFYKDKWiTrz9VvmYB/tgQxLx/VOm/RP2wGkFCtvCxQG19fyG4gpV
	31ApXMOE3JRtN4PCNI5xB3zXWDW9j64=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-156-bqge7-0NPfuU2YgkcuDJFA-1; Sat, 30 Mar 2024 03:12:06 -0400
X-MC-Unique: bqge7-0NPfuU2YgkcuDJFA-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-29df9eab3d4so2244455a91.0
        for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2024 00:12:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711782725; x=1712387525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wSfuh3hgBN5v+TJQtMt4wHJKKzn/IMeC4fo6vXTl7gQ=;
        b=NIliy70I2bfwX+D+SIw/ucqnU5uGHYW6AAKSHhvRf0Qqi28q4dOip9MvCCvyNQixID
         jwdgrklZJhlFyJHA9PSIOWAEPGHMI5mQEYJdoKjWGPVCSmhLt3T+cZCu1a7zdb/GR4s7
         lVT9wnKcTSjlgnJHyIL+o2/HZ1vCqiqOMGa+SoYRMkxBtAIIOPcR5UDPiv9JvonUA7+o
         ksqkrEx0xHBoRNid8WyQjuR87SdfpcKN+AAB1tsEi9aDkl13uTD0JqcyYPoE7Fey/vHl
         KmJvexnELsx+UcMJutmbauVxNDuN7zqZ+9ykxJvlu3puAt9UyrCr45l2PYGzSzZEHpro
         94PQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgCHQhgDlWB4HTHI3jGD1emV4rndT1ZGFGiNV7SI9ASGEgPBn9kC3QvMt9135QCVByeRlkCX516I29Acc/kbd7SNFfr7gYPnxa
X-Gm-Message-State: AOJu0Yw26R3XKmi70D+/RbwiewwaE3aJ7CJrsSuI/G49gTw9AVehfZ9s
	ROHfx6FG7wvaZ04fKTg97R77EjRdlha9rjviyCoGX9iv+K+szMk0xc/ctMmhP1suNjm9LcgVz0J
	qmkGWffdD62jzA6Ir4uUIXgVcauWrW2o1iMLlMgXRqrucyjESAhU0D95nLQ==
X-Received: by 2002:a17:903:258a:b0:1e0:a1c7:572c with SMTP id jb10-20020a170903258a00b001e0a1c7572cmr3643279plb.18.1711782725511;
        Sat, 30 Mar 2024 00:12:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZxybFUwvsRPzzvfaSmzhi58LRSaIHXEP38dchssw1hYNPJsiW2EhaKziaBRK0zHBvJQqwig==
X-Received: by 2002:a17:903:258a:b0:1e0:a1c7:572c with SMTP id jb10-20020a170903258a00b001e0a1c7572cmr3643255plb.18.1711782724749;
        Sat, 30 Mar 2024 00:12:04 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p2-20020a1709026b8200b001dc05535632sm4548412plk.170.2024.03.30.00.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Mar 2024 00:12:04 -0700 (PDT)
Date: Sat, 30 Mar 2024 15:12:00 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: David Hildenbrand <david@redhat.com>, Christoph Hellwig <hch@lst.de>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] generic: test MADV_POPULATE_READ with IO errors
Message-ID: <20240330071200.jmljkdyccwgdzmej@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
 <171150742156.3286541.2986329968568619601.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150742156.3286541.2986329968568619601.stgit@frogsfrogsfrogs>

On Tue, Mar 26, 2024 at 07:43:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a regression test for "mm/madvise: make
> MADV_POPULATE_(READ|WRITE) handle VM_FAULT_RETRY properly".
> 
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/generic/1835     |   65 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/1835.out |    4 +++
>  2 files changed, 69 insertions(+)
>  create mode 100755 tests/generic/1835
>  create mode 100644 tests/generic/1835.out
> 
> 
> diff --git a/tests/generic/1835 b/tests/generic/1835
> new file mode 100755
> index 0000000000..07479ab712
> --- /dev/null
> +++ b/tests/generic/1835
> @@ -0,0 +1,65 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1835
> +#
> +# This is a regression test for a kernel hang that I saw when creating a memory
> +# mapping, injecting EIO errors on the block device, and invoking
> +# MADV_POPULATE_READ on the mapping to fault in the pages.
> +#
> +. ./common/preamble
> +_begin_fstest auto rw
                         ^^ eio

> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	_dmerror_unmount
> +	_dmerror_cleanup
> +}
> +
> +# Import common functions.
> +. ./common/dmerror
> +
> +_fixed_by_kernel_commit XXXXXXXXXXXX \
> +	"mm/madvise: make MADV_POPULATE_(READ|WRITE) handle VM_FAULT_RETRY properly"
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_xfs_io_command madvise -R
> +_require_scratch
> +_require_dm_target error
> +_require_command "$TIMEOUT_PROG" "timeout"
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_dmerror_init
> +
> +filesz=2m
> +
> +# Create a file that we'll read, then cycle mount to zap pagecache
> +_dmerror_mount
> +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $filesz" "$SCRATCH_MNT/a" >> $seqres.full
> +_dmerror_unmount
> +_dmerror_mount
> +
> +# Try to read the file data in a regular fashion just to prove that it works.
> +echo read with no errors
> +timeout -s KILL 10s $XFS_IO_PROG -c "mmap -r 0 $filesz" -c "madvise -R 0 $filesz" "$SCRATCH_MNT/a"

timeout -> $TIMEOUT_PROG

Others looks good to me, if there's not more review points, I'll merge this
patch with above changes, after testing done.

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

> +_dmerror_unmount
> +_dmerror_mount
> +
> +# Load file metadata and induce EIO errors on read.  Try to provoke the kernel;
> +# kill the process after 10s so we can clean up.
> +stat "$SCRATCH_MNT/a" >> $seqres.full
> +echo read with IO errors
> +_dmerror_load_error_table
> +timeout -s KILL 10s $XFS_IO_PROG -c "mmap -r 0 $filesz" -c "madvise -R 0 $filesz" "$SCRATCH_MNT/a"
> +_dmerror_load_working_table
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1835.out b/tests/generic/1835.out
> new file mode 100644
> index 0000000000..1b03586e8c
> --- /dev/null
> +++ b/tests/generic/1835.out
> @@ -0,0 +1,4 @@
> +QA output created by 1835
> +read with no errors
> +read with IO errors
> +madvise: Bad address
> 

