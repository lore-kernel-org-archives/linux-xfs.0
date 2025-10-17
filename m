Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205B860DCF
	for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 14:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713075; cv=none; b=YZShZd0f2wYxEmKn28cmAvGzoHNAexk9eHTsLxnALgFDpnFF6J9khZqWyWjuZlI06LPBAM+j7vF8tI0KDXVGm/40DjQQwdI5bZjHtrs7ODX3jEP1cpngZAhn/UJiFgOdSikry+FJtcz18AMROgE+1JmnnCiHZl2Px72gXcxy07s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713075; c=relaxed/simple;
	bh=L0bFPxDcqgJpPxvTaEYcFqpIamt+96UvErK7XQwmfBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GrzWERJ8s1VEyozmvCFa3WuEnBiaW77wcR1zA7mSGKJE6yjFaf6RM/OHstEUmj9bHot2dfPUUQ7rCRsWIpmLj2/kFcwNCPsyEBqwnY3WkM0abID23cFJV0Nb0dKEYGXt0QDZmFzfaoh+hUitttgXeU6AX03yQKvD7yJIth11UKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EQj8lZem; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EQj8lZem"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760713071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0CWIznKk8NO+pqJ/eP683zeyfH/gjzfyXn71NVQmDXo=;
	b=EQj8lZemU1Lc9Z+Rwy/YzL0MpXaUMH7BXQs1GUycRotw/nF3h+RkJzRNe7dbDLbMkoNOiB
	88D3dQaIUH5VYAIj1A6gZtSnKC2tuSF04dDsmyRV/V1FeSLYVma4OeA/EXHRgntbm8Gi5+
	b6x+l59XuEGBQ98/d871M/dwvvWmko4=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-INfNqKzkOVG5o9GdzOTkmA-1; Fri, 17 Oct 2025 10:57:50 -0400
X-MC-Unique: INfNqKzkOVG5o9GdzOTkmA-1
X-Mimecast-MFC-AGG-ID: INfNqKzkOVG5o9GdzOTkmA_1760713069
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7811a602576so2839968b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 07:57:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760713069; x=1761317869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0CWIznKk8NO+pqJ/eP683zeyfH/gjzfyXn71NVQmDXo=;
        b=aXeDEl1VxdmEpC19c6Af7nG0Qx2/9BZ4KzhS7yRzwQ6zNn4Y0G2TsWOg48m+drMWSP
         +JN0zOgVd1hEP4us3FGz7oKx+ihUVN3Qau1lHKlIWTTPbanOHX5RjvGKstHP0tKf46QH
         TyCGKRFke7aw7FGjE8QKlAAk0U/N6ZsBVmAx58SPwjDSYK+uklSGOvtdLAaLBHMiiK+y
         E/p2XeDlER4yT3/7C/GiNh6wW/Z1JX4kd/vEWRzNthCILuap4x1pDryztCz7ot3t8obl
         cmmY8w81zXDPopvC1B442iRUREIvaeu6F/c6asjFNqN24CzFtnI55VveowuXYGEqa4BD
         Q3zQ==
X-Forwarded-Encrypted: i=1; AJvYcCUu3ih9NU0tNkQZqbRQBItMGPxplikShnnEIbFVkROXvxdkkR/hNBodwk8EnKzRpLBAoU3FwWzfl94=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBiL/vQLW+/TKQ7a5+M3ay7y9kQF8avdRQjF1He+72lEVTCIcs
	37i0X+to0R2l6Lb7t7zFCjddfI6PYsckF8I23SAqsNbz+GQJq6OEyZ/xjySOe6wVnrpCYpL7Ij6
	ygSmhQ/tTyZ0ihPQ7HaqJ0bIz1Lo3ilrz9TXxbNBDtvmtPJ7KYX/Y8XnFSqwmZw==
X-Gm-Gg: ASbGncvoHkRfXUjiphNtlGB+s9QLSjaBJlKsJnaOIl6SSq10hBuFPhOC2gV4IqzyJeJ
	eY4+8DAV1ANmKHWnQvIhC3h8MqoweqJ5rJDMu0eePQB1wsAcADvfxgh4+rw6HbKa5CO4uMg5wFa
	iGWdYYD5nR8CsF5keykPCq3KcpRxM0DEw3J9yuwy6gIzAHya/w0tmU8KNrI4S1oiPfwNuD5ukfA
	tX943p/BXKeT4GigGyBMligb9opEYOe+MG1ce9L20Mh3DAj4hb1lDS0p0kNQ/4wGP5TDvv3BO8G
	Q5J7gvlKz65PVAj2MFc1ULnEfJpQn+A71+mXr0pqY6uA3mPGQOfpkLfaulcbvqlF5QzCoGNb/eZ
	ptH0oMo0uKl49LNTPyfOfP3nXMiEQSz5DFij9g0c=
X-Received: by 2002:a05:6a20:72a2:b0:334:8002:740f with SMTP id adf61e73a8af0-334a85bacd8mr5263220637.41.1760713068698;
        Fri, 17 Oct 2025 07:57:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEV8bycvyQSRyozXfQHV3RbBixEHjX0DtEj7uEL8WhTY3bj+WlE9auL1ONIzq/ZrxZgb2EPDQ==
X-Received: by 2002:a05:6a20:72a2:b0:334:8002:740f with SMTP id adf61e73a8af0-334a85bacd8mr5263181637.41.1760713068196;
        Fri, 17 Oct 2025 07:57:48 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b67fa4sm2528a12.33.2025.10.17.07.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 07:57:47 -0700 (PDT)
Date: Fri, 17 Oct 2025 22:57:42 +0800
From: Zorro Lang <zlang@redhat.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, Naohiro Aota <naohiro.aota@wdc.com>,
	linux-btrfs@vger.kernel.org, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: basic smoke for filesystems on zoned block
 devices
Message-ID: <20251017145742.thvvkyk7qafi4aju@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251006132455.140149-1-johannes.thumshirn@wdc.com>
 <20251006132455.140149-3-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251006132455.140149-3-johannes.thumshirn@wdc.com>

On Mon, Oct 06, 2025 at 03:24:55PM +0200, Johannes Thumshirn wrote:
> Add a basic smoke test for filesystems that support running on zoned
> block devices.
> 
> It creates a zloop device with 2 sequential and 62 sequential zones,
> mounts it and then runs fsx on it.
> 
> Currently this tests supports BTRFS, F2FS and XFS.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  tests/generic/772     | 52 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/772.out |  2 ++
>  2 files changed, 54 insertions(+)
>  create mode 100755 tests/generic/772
>  create mode 100644 tests/generic/772.out
> 
> diff --git a/tests/generic/772 b/tests/generic/772
> new file mode 100755
> index 00000000..412fd024
> --- /dev/null
> +++ b/tests/generic/772
> @@ -0,0 +1,52 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Wesgtern Digital Corporation.  All Rights Reserved.
> +#
> +# FS QA Test 772
> +#
> +# Smoke test for FSes with ZBD support on zloop
> +#
> +. ./common/preamble
> +_begin_fstest auto zone quick
> +
> +_cleanup()
> +{
> +	if test -b /dev/zloop$ID; then
> +		echo "remove id=$ID" > /dev/zloop-control
> +	fi
> +}
> +
> +. ./common/zoned
> +
> +# Modify as appropriate.
> +_require_scratch
> +_require_scratch_size $((16 * 1024 * 1024)) #kB

_require_scratch_size contains _require_scratch, so you can remove _require_scratch.

Can you explain why we need 16GiB free space for these parameters?

> +_require_zloop
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +


> +last_id=$(ls /dev/zloop* 2> /dev/null | grep -E "zloop[0-9]+" | wc -l)
> +ID=$((last_id + 1))
> +
> +mnt="$SCRATCH_MNT/mnt"
> +zloopdir="$SCRATCH_MNT/zloop"
> +
> +zloop_args="add id=$ID,zone_size_mb=256,conv_zones=2,base_dir=$zloopdir"
> +
> +mkdir -p "$zloopdir/$ID"
> +mkdir -p $mnt
> +echo "$zloop_args" > /dev/zloop-control
> +zloop="/dev/zloop$ID"

About this part, can we have a common helper (e.g. _create_zloop_device) which
can get a free zloop number and create a zloop dev, then output the device name
if it's created successfully ?

> +
> +_try_mkfs_dev $zloop 2>&1 >> $seqres.full ||\
> +	_notrun "cannot mkfs zoned filesystem"

As this's a generic test case, I'm wondering if the zloop device can be created
on any FSTYP? For example if FSTYP is nfs or cifs or overlay or tmpfs or exfat
and so on.

> +_mount $zloop $mnt
> +
> +$FSX_PROG -q -N 20000 $FSX_AVOID "$mnt/fsx" >> $seqres.full

Do you care about the return status of fsx? If so, you can use _run_fsx or run_fsx.

> +
> +umount $mnt

Please make sure "the $mnt is unmounted" and "all zloop devices are removed"
in _cleanup.

Thanks,
Zorro

> +
> +echo Silence is golden
> +# success, all done
> +_exit 0
> diff --git a/tests/generic/772.out b/tests/generic/772.out
> new file mode 100644
> index 00000000..98c13968
> --- /dev/null
> +++ b/tests/generic/772.out
> @@ -0,0 +1,2 @@
> +QA output created by 772
> +Silence is golden
> -- 
> 2.51.0
> 

