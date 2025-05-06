Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B849C1A9B3F
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 20:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746561991; cv=none; b=nOZRsJegd5DPZ3xS+WHzboMrKPxbli+ToXLl/SWM3Oxe1p9ioqUUps/mDzhNlcn1X6VIq0aNkS8xC085VVBNM77e/skHcZjFy4XTWhoG691qSwJctG+5efNJZ5I1j7LmCbAdPfXmSaPalLQnwsH38Ku5tB5xfcdHHb5iFmz5lhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746561991; c=relaxed/simple;
	bh=NYy3xHVXIyoYeELDISED5594kNW6aqRLE3/ZNS6rRqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VxTHigH7eXvVX/fPSNyd24rsEwUrK8JYNuWcDkNRdZWwlhzhiM7Ih7mI2L3zKFIb4HZ+IRWUTo8AjbJ1WOrx5ASEH+YQCcZJxqWInEra7UIaFxx6853sIZX/fviQDFOPVweKpOR0b6Hxr5w5CfXkdDvLnFAgqG8kZZkRkGxJC1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f0tx4KBt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f0tx4KBt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746561985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TYeBemnuRj4EU+b7WtJxfwDQx91qscDXsnOk/LuYgps=;
	b=f0tx4KBtTNKhlfzUFcN0J4hXujI4kq9bR6vmyaRBKK/TVoXX4zxlc1BfKKcfE+Fd7R8Sq+
	BOw3EKfBPBPWBYk7yj2n0FZo2rTmvv/cXXRr1Tt59lrAaB2uxTV36R7MTvx8hCwq6stwK8
	ClWibfsHKEEpKVfMdr9afLwrzz+yyTE=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-cDGcusvIMg29-xsInV6q_Q-1; Tue, 06 May 2025 16:06:24 -0400
X-MC-Unique: cDGcusvIMg29-xsInV6q_Q-1
X-Mimecast-MFC-AGG-ID: cDGcusvIMg29-xsInV6q_Q_1746561983
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-72f3b4c0305so6371927b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 06 May 2025 13:06:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746561983; x=1747166783;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TYeBemnuRj4EU+b7WtJxfwDQx91qscDXsnOk/LuYgps=;
        b=JjKZ4EbVN9QAkD+AxxC0eKQtPCrcdJFnlJDErzhxM3gbrftkhd6+eLGR7LE5JFyYK7
         X/t79gEVbzzecN8AZxybiQNliZjpSsz5cgY9PVzMy0VUH0tUDTVsfY2FDQFoforaMenZ
         FZUulelJ7MyqbbdocJqIHEub8p561OvHZj0NPUTpXRhxJA77lQQ9h2wupa3+X41XjcpT
         b6QVDAvz1WBBchG5GMmOQ7ezu2wlQc6Ev7Fvu8ckQ3GJ0I7zOfikVSjo20N07+EFG4mu
         Zp95viFGxC02CSDcxvwbypbJ+k51mBp37WEWRtcvVmSlWwZR0JBgLRCQai0gZ+uIZDOn
         sthg==
X-Forwarded-Encrypted: i=1; AJvYcCV0lm2TMEXnH5q78I1KcDReyiP30Hmks7YitXs7KzTop75TgIJaN9rTZdifA05nBxulcxqBSKiypbA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgA5PvzPs1iOvxCOnRof//kZnotYKLGhqWqT9RkbNVGTUsT8nP
	+bVOwBkyvyfyy3lhOFf/A9eZnJUEE3EGyxa//+Z1RdnMGORIh6/ymnGxwj4hOsVP1FntCsGrUn+
	16IPDTlRHdWO0lIGitZzVQmAlkCsLwlAOZTu5QlM7FmoVZQH28qoQ4Perkw==
X-Gm-Gg: ASbGnctggR/1R7gkcZt13xUxw+azsFA3bTrlrhlAeBkiClpykwxJo6joLx6ODXG4yuh
	092450N+9bTsO8463u5YviQEnGmPTP2udXs3Un4w7UfXYwInfWXymEZPjDrPAzuvIlGVrPOu2X/
	hU+KKb1R7MV5oZDqaufj9WrPlaLQD0Q6/zXeeCSD68RxfHgGpsewK2GGwb7V8mXWCKyo61kh7y6
	ykUeE3dt+47CtJQexZTpHDL1gl0A41mlA95GFtWH9r98rZNpAIdHCMyLYXzg5km7Dv4wj5lfgCr
	fagOZ9b0+F0SJwYbmr99TRR93fguDFvp2G/pB6177xDF/AS5uyB5
X-Received: by 2002:a05:6a21:6d83:b0:1ee:c390:58ac with SMTP id adf61e73a8af0-2148d86b384mr840005637.34.1746561983129;
        Tue, 06 May 2025 13:06:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUZtnxLGqfX+wlNLn4Bm4JcPm6guhgB1CxDLoh0dEhU5cw1HJq5Kp/VJdwOKt0ouOlltww/w==
X-Received: by 2002:a05:6a21:6d83:b0:1ee:c390:58ac with SMTP id adf61e73a8af0-2148d86b384mr839974637.34.1746561982763;
        Tue, 06 May 2025 13:06:22 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74059064ba3sm9676997b3a.130.2025.05.06.13.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 13:06:22 -0700 (PDT)
Date: Wed, 7 May 2025 04:06:17 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/15] xfs: test that truncate does not spuriously return
 ENOSPC
Message-ID: <20250506200617.5sj7pc7tb6kigjfn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250501134302.2881773-1-hch@lst.de>
 <20250501134302.2881773-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501134302.2881773-15-hch@lst.de>

On Thu, May 01, 2025 at 08:42:51AM -0500, Christoph Hellwig wrote:
> For zoned file systems, truncate to an offset not aligned to the block
> size need to allocate a new block for zeroing the remainder.
> 
> Test that this allocation can dip into the reserved pool even when other
> threads are waiting for space freed by GC.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/4213     | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/4213.out |  1 +
>  2 files changed, 46 insertions(+)
>  create mode 100755 tests/xfs/4213
>  create mode 100644 tests/xfs/4213.out
> 
> diff --git a/tests/xfs/4213 b/tests/xfs/4213
> new file mode 100755
> index 000000000000..1509307d39d0
> --- /dev/null
> +++ b/tests/xfs/4213
> @@ -0,0 +1,45 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Christoph Hellwig.
> +#
> +# FS QA Test No. 4213
> +#
> +# Ensure that a truncate that needs to zero the EOFblock doesn't get ENOSPC
> +# when another thread is waiting for space to become available through GC.
> +#
> +. ./common/preamble
> +_begin_fstest auto rw zone
> +
> +_cleanup()
> +{
> +	cd /
> +	_scratch_unmount >/dev/null 2>&1

Remove this _cleanup if "unmount" isn't necessary at here.

> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/zoned
> +
> +_require_scratch
> +
> +_scratch_mkfs_sized $((256 * 1024 * 1024))  >>$seqres.full 2>&1
> +_scratch_mount
> +_require_xfs_scratch_zoned
> +
> +for i in `seq 1 20`; do
> +	# fill up all user capacity
> +	PUNCH_FILE=$SCRATCH_MNT/punch.$i
> +	TEST_FILE=$SCRATCH_MNT/file.$i
> +
> +	dd if=/dev/zero of=$PUNCH_FILE bs=1M count=128 conv=fdatasync \
> +		>> $seqres.full 2>&1
> +
> +	dd if=/dev/zero of=$TEST_FILE bs=4k >> $seqres.full 2>&1 &
> +	# truncate to a value not rounded to the block size
> +	$XFS_IO_PROG -c "truncate 3275" $PUNCH_FILE
> +	sync $SCRATCH_MNT
> +	rm -f $TEST_FILE
> +done
> +
> +status=0
> +exit
> diff --git a/tests/xfs/4213.out b/tests/xfs/4213.out
> new file mode 100644
> index 000000000000..acf8716f9e13
> --- /dev/null
> +++ b/tests/xfs/4213.out
> @@ -0,0 +1 @@
> +QA output created by 4213
> -- 
> 2.47.2
> 
> 

