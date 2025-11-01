Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605B22F12BA
	for <linux-xfs@vger.kernel.org>; Sat,  1 Nov 2025 11:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761994852; cv=none; b=a6vPr1WbnmM6gIisoMCKdMlpbsKsqp1bN9H51iF4MjffFVzvywhjt8arDpgM2iV/BZigr6Qn3qGfmQlIZ+dQfDGj7y4zHXKD+iOllwLjwTASQ0RdG+2h7UsBwxujk7rjxcVyh7XdaITbLrClvdYA4l/Qaow6ZE58BJB7uwTa3OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761994852; c=relaxed/simple;
	bh=QtrHZ3BNmQDYjMDBlN7tUMwsIr6mPKhSqcllk44Q7oQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=reukXo/ZFTzaJiM8wvhIU4Kyqb2Br0ny4DrCcx8vRvlJq3ZfZusfMANo3NXBRkJLg2VGP+9HBgN2bs+MOEfST9Qqy11WXGL42LuH7zDRsIEJGQ/+YGnINQq/GXvc2MUYyDoabC6G4SIreygFWK+sfb91K6Z00ROlwHARFvJ/Ack=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c0PTSrkL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cnul4tYc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c0PTSrkL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cnul4tYc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761994848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M9D1hZg0keX1f1tqEjjOCXz3mMV5j42zRaCxAoLpn3Q=;
	b=c0PTSrkLUbBYjgyJ2FtxaMMPvzrx4ggmqq/ISkK+nROaCaSDLPACZ8K/Q+u/yl2RNteh0z
	GkH07iCwE6U1PRxqZFh0Hq7O364HD+PX8okYc4yoRhKWmMQzaiZKeiJTRDOVQdjxZkoKly
	oi81R86u5FO58fJ+IDnh7nNLvJwJcmE=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-eRJQg_W3O3OepACn6a7hYw-1; Sat, 01 Nov 2025 07:00:47 -0400
X-MC-Unique: eRJQg_W3O3OepACn6a7hYw-1
X-Mimecast-MFC-AGG-ID: eRJQg_W3O3OepACn6a7hYw_1761994846
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b6cff817142so2157270a12.1
        for <linux-xfs@vger.kernel.org>; Sat, 01 Nov 2025 04:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1761994846; x=1762599646; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M9D1hZg0keX1f1tqEjjOCXz3mMV5j42zRaCxAoLpn3Q=;
        b=cnul4tYce7cpO0sNPY4R77C1SWWuQ0/By4ToGZDdnvP3diHtwVWO2IbV7tJNmBwLZq
         ZUOb4sCYgc88SKk/7gJvCGcbPKESRSfRB53kTJeM9yXMZ/q2uO0Z1njeYFIzgKpgPOwD
         61F9MXaNCnxiJUzPEvcaN8MRAgmlIH9Je2o5ySd+Y9232RCP3jfuBx1nR93WsxmG/hJh
         XSE+BCmxMXAHWOyES7Ekq09eU+qQvfrOfVkRc5fC6d9yYDS43Bn9+GOvR3t8tPcL/E4Z
         hRTSIhSNobg1iOYRJ/zFh9QLQIPCEAh+4Ew5jhbEqxgKzI0VPfqqcQrpvd1XBNAQTa34
         FUOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761994846; x=1762599646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M9D1hZg0keX1f1tqEjjOCXz3mMV5j42zRaCxAoLpn3Q=;
        b=C7wdQhNj97HVgdt6Eq4VBstwb6y2hxJAHn33m5F4DWMg9umWdhhxt2HLxt0B7MxqLg
         2vmGF8rnElz+bPuSRvYlO247bS6hqzCW4QIsiejgU3QWBwruZhP2Awbh7mukFr6fBrCn
         M3MElo+4FSLsSLANCZwfnq9JDwJEZ2yp8cYetCTW1819oEbFbPmDEgoaUX8ekmMbw3X2
         zrvwMGEZ2O7AJlESNP5dB/uxuHitbmeNSjjDuxequaJb2APnRm9E1HIWjEGZorz3hHq6
         QoSBPe6LjSy6HT9CC3MPfaBG+DnSajS2nGSIMmhsLuiap5LEa/WE/DcKKBwxa1KZaLJa
         Nw1g==
X-Forwarded-Encrypted: i=1; AJvYcCVa49CxqRHL49SMzR7/CP3lRKfrZGx46JGNrvGdhShQf5ebmXZ4Jnff4jTeqTwsyBLbrYoNdDmMQNk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7IfzmLTOvZLzLdUFzdkjZC6FciYe8qTHcmAerOUzvE+5QKodj
	cyHURxZRLjlS86+cSjhphteE6I/fD/lZRntwX7PVjDSv/kXGYOOV23ozo5uaQpDI9gh1BkgElbM
	nH+mHbGAuPdfJdGeG92sC4bimBGCDULbkbT3qrdYJ5e1FMzkuQJaTrih21WIF8w==
X-Gm-Gg: ASbGnctC9jxlyekrov5oZtUZZjoH8pHXvXQD+INxY1Z8PxbViqRMAaKQqbKvrqxiF3w
	GPhX6gQGzp4GDWnX+qYFosbjnGTCMhZdjUiK8DTNbtsrGVbbT0sAj5R0Kxmc+umgxfj5p68gzYd
	EUeAQsiFA0DH6EXVbVxGVoJcN5W3NtM8I65GNY1cNo95GP4SwtoWwxELbtPqCKctD0r/N1NyS8v
	D6INSErUOGXuyV8+MmQiaX/QzolK9iDE0AoOsbVacqAD6oCVuhl5oMFLkMIOmoNvD/d/LHBQoBs
	qVu7gjSYJB75z9vp3QhH57a/PY5YovR0nOazuZVbG8dzo/q6xk2p/QQg8rdsf5prroKTa+/jNr4
	OvBl9UKj9rLprAmYrq3h+K4EtjQShflSOYReb1Qw=
X-Received: by 2002:a05:6a21:6d9f:b0:341:d5f3:f1ac with SMTP id adf61e73a8af0-348cc2d99b8mr9839140637.41.1761994845898;
        Sat, 01 Nov 2025 04:00:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzv4olWro4P40LuHR5fqURv48AHGfNA1mhFufBKeiNw7xSQzvDyhSpIfxk8Nk1EllL1hOoSg==
X-Received: by 2002:a05:6a21:6d9f:b0:341:d5f3:f1ac with SMTP id adf61e73a8af0-348cc2d99b8mr9839045637.41.1761994845074;
        Sat, 01 Nov 2025 04:00:45 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a9af0eb37csm361456b3a.29.2025.11.01.04.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 04:00:43 -0700 (PDT)
Date: Sat, 1 Nov 2025 19:00:37 +0800
From: Zorro Lang <zlang@redhat.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
	Hans Holmberg <Hans.Holmberg@wdc.com>, linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>, Anand Jain <asj@kernel.org>
Subject: Re: [PATCH v7 3/3] generic: basic smoke for filesystems on zoned
 block devices
Message-ID: <20251101105949.gh6jczdtn5nty5ww@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251022092707.196710-1-johannes.thumshirn@wdc.com>
 <20251022092707.196710-4-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022092707.196710-4-johannes.thumshirn@wdc.com>

On Wed, Oct 22, 2025 at 11:27:07AM +0200, Johannes Thumshirn wrote:
> Add a basic smoke test for filesystems that support running on zoned
> block devices.
> 
> It creates a zloop device with 2 conventional and 62 sequential zones,
> mounts it and then runs fsx on it.
> 
> Currently this tests supports BTRFS, F2FS and XFS.
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Anand Jain <asj@kernel.org>
> Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  tests/generic/772     | 43 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/772.out |  2 ++
>  2 files changed, 45 insertions(+)
>  create mode 100755 tests/generic/772
>  create mode 100644 tests/generic/772.out
> 
> diff --git a/tests/generic/772 b/tests/generic/772
> new file mode 100755
> index 00000000..f9840cba
> --- /dev/null
> +++ b/tests/generic/772
> @@ -0,0 +1,43 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Wesgtern Digital Corporation.  All Rights Reserved.
> +#
> +# FS QA Test 772
> +#
> +# Smoke test for FSes with ZBD support on zloop
> +#
> +. ./common/preamble
> +. ./common/zoned
> +
> +_begin_fstest auto zone quick
> +
> +_cleanup()
> +{
> +	_destroy_zloop $zloop
> +}
> +
> +# Modify as appropriate.
> +_require_scratch_size $((16 * 1024 * 1024)) #kB
> +_require_block_device $SCRATCH_DEV
> +_require_zloop
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +
> +mnt="$SCRATCH_MNT/mnt"
> +zloopdir="$SCRATCH_MNT/zloop"
> +
> +mkdir -p $mnt
> +zloop=$(_create_zloop $zloopdir 256 2)
> +
> +_try_mkfs_dev $zloop >> $seqres.full 2>&1 ||\
> +	_notrun "cannot mkfs zoned filesystem"
> +_mount $zloop $mnt
> +
> +$FSX_PROG -q -N 20000 $FSX_AVOID "$mnt/fsx" >> $seqres.full
> +
> +umount $mnt

This version looks good to me. Just this unmount should be in _cleanup to make
sure we always can umount and destroy zloop device at the end of the test. If
no more review points, I'll change this case as below [1] when I merge it.

Reviewed-by: Zorro Lang <zlang@redhat.com>

[1]
diff --git a/tests/generic/772 b/tests/generic/772
index f9840cba..eaeb0c18 100755
--- a/tests/generic/772
+++ b/tests/generic/772
@@ -13,7 +13,10 @@ _begin_fstest auto zone quick
 
 _cleanup()
 {
+       [ -n "$mnt" ] && _unmount $mnt 2>/dev/null
        _destroy_zloop $zloop
+       cd /
+       rm -r -f $tmp.*
 }
 
 # Modify as appropriate.
@@ -36,8 +39,6 @@ _mount $zloop $mnt
 
 $FSX_PROG -q -N 20000 $FSX_AVOID "$mnt/fsx" >> $seqres.full
 
-umount $mnt
-
 echo Silence is golden
 # success, all done
 _exit 0


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

