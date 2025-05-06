Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFC84B1E4B
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 20:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746562580; cv=none; b=gCLY2/MVKixywIb1fyGiSFWHcL5LHLxPfa1dPck2S6onSUjE/SIYbTKR4se0zLlUOPh2L+n4JVPQw0LyqAY1IXtXatnSpc33gIZnAvvUf+vUnRkp3gUGoskKpHsh4X9cuzur/HANqQFr5u8RsmXqVqfQWake6qvCl6hpB+VpRTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746562580; c=relaxed/simple;
	bh=w91ERMvYNjD8AxkcDDuGxeAQsXuSundsTOd10md6120=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fFZevJBSqcZRBmwZBLxZeSA2NZa0H/VdDGqEUdvNbEbuHB1XUn1XcA2+yxmF3GiVG/SqTlMXoZ7L02Sc7veVcKOvw6GdRYTIfc63BAXEi0ngK/DzOH2HnNWn8pOoU78yLEOfRmjPnv7xTi/mHmyuCLSxXU0JuALkm8q7k8aelho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pf6olE6E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pf6olE6E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746562577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EiTwiC812fR8NWWsZHSKHCFWmLK0aJ0pgWsqi+Hiv2k=;
	b=Pf6olE6EFujyooCbyKec4wAOnaKknVCYG/MzKX0BnJPnixY3IOFCawbXYo5xsNfQF5pC6p
	pNrpCOOsnjrb5h9r0C+5+CjHTqHMDn8JdMPppoKw616nx5Gu5bH/EHwqaG8NFPZpedNsDv
	EtIc6MiffeMsLy97Xbxol7uLCeDUcLs=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-77YO7EFKPeuCL554Vov5NQ-1; Tue, 06 May 2025 16:16:14 -0400
X-MC-Unique: 77YO7EFKPeuCL554Vov5NQ-1
X-Mimecast-MFC-AGG-ID: 77YO7EFKPeuCL554Vov5NQ_1746562574
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-73720b253fcso4531124b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 06 May 2025 13:16:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746562573; x=1747167373;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EiTwiC812fR8NWWsZHSKHCFWmLK0aJ0pgWsqi+Hiv2k=;
        b=Cp/9Gsm+RFIB6sTNlSKi0nglwf/XQwxGCoVqOEn76LxPteTODQeT4Ewxh+szMRVpjP
         st7fNN+MNRjGmaOAHJM74AKZFO2jDMSrCt2zlrPx9+4NIQqinY3enh0vz7UxkkQibjlF
         BPJ81gifNCHMvk21utspV4XJw7POvCEykDkstFuQNKDttbNFU7jKUc9DIEYNLm2tVhm0
         cnhiEII8jMrkolo7IdY1HnSsXWKVhDpkfIeE6GMq/JrSvvoVTnA03o+YAKl/iVpQKXwf
         rQg4KLPGkTrZ60NUYyi0mvmsyWB2PogtmYgbFs19KXob8WbdYZJDlPPxx80GOO6r+x3Q
         lAdg==
X-Forwarded-Encrypted: i=1; AJvYcCWdZIDKJXLkdCu2+1+NHRs0HJX+uKT0qRrfnQZ8ASban2GqhPCn3xHDbuuLO+GmUeLOw3wHdkMi+oA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyibNJeR7xuqzD6Q2cX45wtIja0gTS0bO3sx0n+G9PS3D5HTME9
	4cxMSVesVkG5U/xS7dbc6fuQX/Vl7tLU7eMJupiJAgVxTZZVIjjlC4uQqm2+ZobvxLoAhvoO0rQ
	a5IF8vKixGgbKHAtSWx1aKB2hIdP1MtsiUOuHgO8b7A9HyHU1vHan1rqkRw==
X-Gm-Gg: ASbGnctHsURAWtlfpv5eyyaKakd2N3s2z4p+6/6GALxM/sR4pR66GVZJjVZaTBt/O4/
	85maIEf/dXG3DqIIKR5rhbEGrAbSm2c7Afk9Ebl7rk8dQZ7746FsnmZD2QdJBUEqxDewO5uJQA+
	aPuR/RfOr+ySVDJOv3jJp/A2lt3Rq2WJCPrvyfs2UdEVmj7e10LC5LOPbrNEtHORDfQH7GkH5PU
	YIfw7QiTKz5CHlYcMH+TC0pxym3iA7hZTdEC2iXEhWhmsDmPZ++fQ0BHVwGrq/t0IZCyqpJ5MBf
	HaUFG4vovDy1X+PP1ky6PoafC9hIUnwYHbcTTl60cMy5xE6C+6yf
X-Received: by 2002:aa7:930b:0:b0:736:532b:7c10 with SMTP id d2e1a72fcca58-7409cfda29cmr611078b3a.21.1746562573321;
        Tue, 06 May 2025 13:16:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyuyFKjjzC18sm6uQ4TbsIEzSyhk7yWBSipbUMLBuu7C3f6xKc7ISBa5A15kAWhM5TvGJtkQ==
X-Received: by 2002:aa7:930b:0:b0:736:532b:7c10 with SMTP id d2e1a72fcca58-7409cfda29cmr611035b3a.21.1746562572804;
        Tue, 06 May 2025 13:16:12 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058dbbe25sm9748091b3a.59.2025.05.06.13.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 13:16:12 -0700 (PDT)
Date: Wed, 7 May 2025 04:16:07 +0800
From: Zorro Lang <zlang@redhat.com>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Zorro Lang <zlang@kernel.org>, "djwong@kernel.org" <djwong@kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	hch <hch@lst.de>
Subject: Re: [PATCH v2 15/15] xfs: test that we can handle spurious zone wp
 advancements
Message-ID: <20250506201607.erolq5xpceam65tv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250501134302.2881773-16-hch@lst.de>
 <20250505095054.16030-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250505095054.16030-1-hans.holmberg@wdc.com>

On Mon, May 05, 2025 at 09:51:48AM +0000, Hans Holmberg wrote:
> From: Hans Holmberg <Hans.Holmberg@wdc.com>
> 
> Test that we can gracefully handle spurious zone write pointer
> advancements while unmounted.
> 
> Any space covered by the wp unexpectedly moving forward should just
> be treated as unused space, so check that we can still mount the file
> system and that the zone will be reset when all used blocks have been
> freed.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

This's good to me, just below picky review points.

> 
> Canges since v1:
>  Added _require_realtime and fixed a white space error based
>  on Darrick's review comments.
> 
>  tests/xfs/4214     | 62 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/4214.out |  2 ++
>  2 files changed, 64 insertions(+)
>  create mode 100755 tests/xfs/4214
>  create mode 100644 tests/xfs/4214.out
> 
> diff --git a/tests/xfs/4214 b/tests/xfs/4214
> new file mode 100755
> index 000000000000..0637bbc7250e
> --- /dev/null
> +++ b/tests/xfs/4214
> @@ -0,0 +1,62 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Western Digital Corporation.  All Rights Reserved.
> +#
> +# FS QA Test 4214
> +#
> +# Test that we can gracefully handle spurious zone write pointer
> +# advancements while unmounted.
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick zone
> +
> +# Import common functions.
> +. ./common/filter

Looks like this case doesn't use any filter helper.

> +. ./common/zoned
> +
> +_require_scratch
> +_require_realtime
> +_require_zoned_device $SCRATCH_RTDEV
> +_require_command "$BLKZONE_PROG" blkzone
> +
> +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount
> +blksz=$(_get_file_block_size $SCRATCH_MNT)
> +
> +test_file=$SCRATCH_MNT/test.dat
> +dd if=/dev/zero of=$test_file bs=1M count=16 >> $seqres.full 2>&1 \
> +	oflag=direct || _fail "file creation failed"

Why put the "oflag=direct" behind the ">> $seqres.full 2>&1" ? I'm saying
it's wrong, just a bit weird :)

Thanks,
Zorro

> +
> +_scratch_unmount
> +
> +#
> +# Figure out which zone was opened to store the test file and where
> +# the write pointer is in that zone
> +#
> +open_zone=$($BLKZONE_PROG report $SCRATCH_RTDEV | \
> +	$AWK_PROG '/oi/ { print $2 }' | sed 's/,//')
> +open_zone_wp=$($BLKZONE_PROG report $SCRATCH_RTDEV | \
> +	grep "start: $open_zone" | $AWK_PROG '{ print $8 }')
> +wp=$(( $open_zone + $open_zone_wp ))
> +
> +# Advance the write pointer manually by one block
> +dd if=/dev/zero of=$SCRATCH_RTDEV bs=$blksz count=1 seek=$(($wp * 512 / $blksz))\
> +	oflag=direct >> $seqres.full 2>&1 || _fail "wp advancement failed"
> +
> +_scratch_mount
> +_scratch_unmount
> +
> +# Finish the open zone
> +$BLKZONE_PROG finish -c 1 -o $open_zone $SCRATCH_RTDEV
> +
> +_scratch_mount
> +rm $test_file
> +_scratch_unmount
> +
> +# The previously open zone, now finished and unused, should have been reset
> +nr_open=$($BLKZONE_PROG report $SCRATCH_RTDEV | grep -wc "oi")
> +echo "Number of open zones: $nr_open"
> +
> +status=0
> +exit
> diff --git a/tests/xfs/4214.out b/tests/xfs/4214.out
> new file mode 100644
> index 000000000000..a746546bc8f6
> --- /dev/null
> +++ b/tests/xfs/4214.out
> @@ -0,0 +1,2 @@
> +QA output created by 4214
> +Number of open zones: 0
> -- 
> 2.34.1
> 

