Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BED94B1E5C
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 19:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746559977; cv=none; b=a+BwvRDUHDSe3fvn2H0uMvNGhZmabLndNpPovlowwYUaA7yhRfUH4TUvwkWyUxrxklbckKqIO9DHRy55CO5UxRNyLyAyxCWVekS5GE9DESWliFxaSX5IcL9yqzsmRFwEVLH5WXlJcZ2OaRt7GxQBa3IZvOZH4a+2VMTdZhAm3tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746559977; c=relaxed/simple;
	bh=LvObEHWsQF7hF5FIl1fkRgo6awFX8wq3UZYuzJX8o1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b7afgcNsSV482EHKDy9HF+lf9p2/ASwafBcctes1fTULsCdXdbnQ+vzchNWWDCcuHmfYIkLuiOaHa0p+AllWJQDhP+55vJb9hNMPygqV0oqegW/vl7LooCp1BBEwNjmcJxg1Ezzhtxf/XoYzVS3Z4VMmoLh74gSkZlxsZo0XOHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a9qTi4Im; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a9qTi4Im"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746559974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1rS96Ut7wQKZkL1iY8HQWTUupzrZlbLDUMN2/a/FXfg=;
	b=a9qTi4ImEdFM0OIqgMALcQw+DipCKE/cZuQCfuUDh6gTTLSFnoaSEQSCL/44peet1h/UEh
	tuv3wyKzQORB9QrIsyk4kY12zXUdopy1JLccgiXmdv77POXz3g2aQdM7cxT4fM/V9LFfDG
	80jComtEYw0bLT3odu7VN8x0Ku5/E+o=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-kyT4dHPuNZGBVQhhmRIUXA-1; Tue, 06 May 2025 15:32:52 -0400
X-MC-Unique: kyT4dHPuNZGBVQhhmRIUXA-1
X-Mimecast-MFC-AGG-ID: kyT4dHPuNZGBVQhhmRIUXA_1746559972
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7375e2642b4so3911541b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 06 May 2025 12:32:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746559971; x=1747164771;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1rS96Ut7wQKZkL1iY8HQWTUupzrZlbLDUMN2/a/FXfg=;
        b=TO9a3GE342rrBxdYyb7veYT+V1OapVPvsEVsC9OJXuMvlEjz//umjbUtffQz5LZ51B
         r9nqm4KKs23DKP7jFEW9VUbcyBO1aJjIdADapmDSiAf/w7m51LjMSpcd9QOjYFKvV8ts
         tAKWg+ya2lS4Rbt7G24k5qEc3NcMOTC/dSJLG28Ekq24cSNAPTNiRUBqF9q+lqZH6Am+
         a8pPPO5ymblyVBPGolxMIDTUYS1u/9EhseYs0UNsTmrrj/OhMPI/C1vbJ9tcwJQkXYmt
         3Jy0S+6jj3cdFDI0WfAjUifAJ6yMightE4CxFOe1tAlXA9iTgRncVMNH4ljwuAg1wiwI
         onTA==
X-Forwarded-Encrypted: i=1; AJvYcCUbseIpW2Ye42CET7Le3eH3gj/iqCP+f/FDpEd9YRXYme3vk2uPczVTuUpUorl0mBm7r/ybQLywSNc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8PlgxuJ52yJ9qhUJWParvwZGCdV6fBelEyO7+cRjAimIUx0+9
	mEzOOS7Pe+gOwRYTz2sOZ7Pm0U41zwVLG5Nyc1j6eo2f96tgn+7xYx2FOLxOfsOQBq14cs2Iw2T
	haE9PjxiBKyazuphAZc/D8dBk0Zh6xKQM6SK1CRlmtldsZY41XcGO8FKNmMeJn8/42Q==
X-Gm-Gg: ASbGncupMviMdjJKsl0MbgdydhxrzHCNd9Ag20QbCKDV2DD8kaaGHSvzakZ9+b6KJad
	nd80OQq7YUgFoxNLWwKJeReAMW902wbHtEkvXIW87SSumG8CwZ3gFtM7eFjCiHPW2JjqaesCAZl
	uKzSRUT+S8evQIJG9qfbbBkVCw7SCjy3Sak+Z9JKRglyzFeRNR+okecLvCrenvge7NQ4cboY0t3
	OZ/EwVov6/vY9sLXN11gdqsOlLR8i3XCQSADVZHIcqbQ2mhjM8CH4f6Yi/FwqnBCKIoXrkGS4C9
	vAjHnyudvNMHIheROvztrTIcW9b/XjEkJYXV92eTRGIzBmY/3F14
X-Received: by 2002:a05:6a20:438d:b0:1f5:6e71:e45 with SMTP id adf61e73a8af0-2148d01196emr582955637.27.1746559971708;
        Tue, 06 May 2025 12:32:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGg0YCgxHV0BEAyMABjhQdsZGlqhgZpNpKUUikDx04PLugplHWPn9yp+GvNCpQXlk7HvoLoMQ==
X-Received: by 2002:a05:6a20:438d:b0:1f5:6e71:e45 with SMTP id adf61e73a8af0-2148d01196emr582925637.27.1746559971296;
        Tue, 06 May 2025 12:32:51 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058b7e30esm9338522b3a.0.2025.05.06.12.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 12:32:50 -0700 (PDT)
Date: Wed, 7 May 2025 03:32:46 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/15] xfs: add a test for zoned block accounting after
 remount
Message-ID: <20250506193246.hc2xtgxibh7osztb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250501134302.2881773-1-hch@lst.de>
 <20250501134302.2881773-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501134302.2881773-3-hch@lst.de>

On Thu, May 01, 2025 at 08:42:39AM -0500, Christoph Hellwig wrote:
> Test for a problem with an earlier version of the zoned XFS mount code
> where freeded blocks in an open zone weren't properly accounted for.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/4201     | 47 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/4201.out |  6 ++++++
>  2 files changed, 53 insertions(+)
>  create mode 100755 tests/xfs/4201
>  create mode 100644 tests/xfs/4201.out
> 
> diff --git a/tests/xfs/4201 b/tests/xfs/4201
> new file mode 100755
> index 000000000000..5367291f3e87
> --- /dev/null
> +++ b/tests/xfs/4201
> @@ -0,0 +1,47 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Christoph Hellwig.
> +#
> +# FS QA Test No. 4201
> +#
> +# Regression test for mount time accounting of an open zone with freed blocks.
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick zone
> +
> +_require_scratch
> +_require_odirect
> +
> +tmp=`mktemp -d`

Why not use "$tmp" directly, it's defined in _begin_fstest?

> +
> +_cleanup()
> +{
> +	rm -rf $tmp

Then we can save this specific _cleanup.

> +}
> +
> +#
> +# Create a 256MB file system.  This is picked as the lowest common zone size
> +# to ensure both files are placed into the same zone.
> +#
> +_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
> +_scratch_mount
> +
> +dd if=/dev/zero of=$SCRATCH_MNT/test1 oflag=direct conv=fsync bs=1M count=32
> +dd if=/dev/zero of=$SCRATCH_MNT/test2 oflag=direct conv=fsync bs=1M count=32
> +rm $SCRATCH_MNT/test1
> +
> +# let delayed inode deactivate do its work
> +sleep 1
> +df -h $SCRATCH_MNT > $tmp/df.old

then use $tmp.df.old and ..

> +
> +_scratch_cycle_mount
> +
> +echo "Check that df output matches after remount"
> +df -h $SCRATCH_MNT > $tmp/df.new
> +diff -u $tmp/df.old $tmp/df.new

$tmp.df.new

Thanks,
Zorro

> +
> +_scratch_unmount
> +
> +status=0
> +exit
> diff --git a/tests/xfs/4201.out b/tests/xfs/4201.out
> new file mode 100644
> index 000000000000..4cff86d90b0f
> --- /dev/null
> +++ b/tests/xfs/4201.out
> @@ -0,0 +1,6 @@
> +QA output created by 4201
> +32+0 records in
> +32+0 records out
> +32+0 records in
> +32+0 records out
> +Check that df output matches after remount
> -- 
> 2.47.2
> 

