Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31B5230D17
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 05:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736747952; cv=none; b=lXKZTDUbsl+iOqyU/JGZ9B6e0ZHxxG9v/SusLpvtlAQ8Eg2/jexh1+P4o6pDUpskNiEqJ5UVtqVTa+jd7BbQgCy+5H6pkL48C0NejxBM5fk/wnFYz3LZmCibDEYCNreSd+lmhynJaSFFujvjjLTw9P/CUigD3R9iARWm6u/jmC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736747952; c=relaxed/simple;
	bh=C39mN0AGKam4fPZkuskbkFWMDrHUCVwNm3cApZ7vd1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWUtRKABYAD+6eW3hrNXNys70e0aLMMEmdsBDPGeA0izWLM71SSicgc1kNDYOo0BbUh8BoktbkQ9hJ1miwXVV71MUGCuR3XSJiDWALSBFoeov1uaWyHM5HXz3Q3GLa1onzYhaHr0fNkJBbbsJmVkytcE8t1wNweUj2rm530+tnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bMzBApo5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bMzBApo5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736747949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oL+5vUlgz5yLIb+gwcjM7Mbg/85PRr0b1Vaj0WPDgvc=;
	b=bMzBApo5n4UzVrd5Ncnt5oFq62VvetcdoiZQooMwwpNjz6Azl2KYfhu1moZ5toHZ1EhCUr
	LXRqORZ8GNof/GkbICT3QMcsyMOhNTvNq4iMUkrJ/1jLPxUsb+NOxeR7u6kNZvfQifj+a7
	+g/auS87bchM7AcL6QBZEWFxYdC+VJI=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-R2rvb9wGN5O2GajwNbUAyg-1; Mon, 13 Jan 2025 00:59:07 -0500
X-MC-Unique: R2rvb9wGN5O2GajwNbUAyg-1
X-Mimecast-MFC-AGG-ID: R2rvb9wGN5O2GajwNbUAyg
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-216266cc0acso79208005ad.0
        for <linux-xfs@vger.kernel.org>; Sun, 12 Jan 2025 21:59:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736747946; x=1737352746;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oL+5vUlgz5yLIb+gwcjM7Mbg/85PRr0b1Vaj0WPDgvc=;
        b=pv/y9JqiHxXVQ91TRjkX1q9CWeY2Z+ZuR4+jb1gaiT+ESWoTp1gG6t1Xg1PS40ZA5z
         J+TObxrPWPyjzSQynpusd5A7oa7AmrxZ3E+v1OxpAdNiZN+hpxlw0KEu9w+obYrQMR3B
         RMjHUE9VmV0BbwTLZIi1EH+ovofrcc4TN3MtEYPKV6QDCWtL8o5b6ih2wDXjZIQOEfhZ
         S1tidGc9pR0wK+AyTzSOXn1b8cVG/Rf6OHMrnkPHmeZG0zZDH0Uo4Re9Gp34uokn5hO2
         5q7ptY+7+A21ovkA8JUSQxkaRXv2PZ2odGp4RXn2P6o+21RS0/BcUSI/Hk3qYEDxtq2E
         kgGA==
X-Forwarded-Encrypted: i=1; AJvYcCWae6Tz+EQeZxfdVJ1ABccax3Qc/saPnQ08sx4W3pK96S5qGoghsfbnZejI9rBYy/UcUddiAEohwtU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBgnCbZlDdvm1pP6ao6q66ftatWAImq29jYsgCPn3/z0rGVumO
	4xni7bN/LPqkBzRSJrr3ZKyfmf1YtMDCWpVUYEQHuyWgA72riJLHLTJzTDNeaHVR1H60b6oSNmM
	w01uQLWDrMUl7ewlh68Dbyxy9B9G98kOkf+OVbFJyavQRklBL5C+A4OE0eg==
X-Gm-Gg: ASbGncsZnYctbPiqTzKtY+tzpFiBsxg9GAcnQNmgmIwJAU71LVFbDS59ppob+ggFrf2
	nWShe/qdNRgxBMpQBZOyDQACbiiyF2aT8EHU9CkqXXYIbBaSVenYuL94uyWKS3PJgP9VLHykY0p
	TJzWE85ugK8++qRRxyqT1TJnZAAP4fUtaFVVY62Dv2IJ43qxGGLKhJjH8PZK07M3QxZOchujMAd
	BveBVsSCZoBtKL8CCUKQvm/arVfL55QOpByW58USf5tDqdUn9uMsJuBDyZ0XZ6GpSeWmefcHKYE
	H2A6AbpAVoclX+u10aaFyg==
X-Received: by 2002:a17:903:234d:b0:215:58be:3349 with SMTP id d9443c01a7336-21ad9f4635dmr136645205ad.14.1736747946090;
        Sun, 12 Jan 2025 21:59:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEDmm6ZZRVjFPKHhHKrndw/vlyb3LQJwyethFxWNNB4Va9jGuBtbjvc15JP6Ne39lGPrLRA7Q==
X-Received: by 2002:a17:903:234d:b0:215:58be:3349 with SMTP id d9443c01a7336-21ad9f4635dmr136644875ad.14.1736747945787;
        Sun, 12 Jan 2025 21:59:05 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f22f6d1sm46855395ad.202.2025.01.12.21.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2025 21:59:05 -0800 (PST)
Date: Mon, 13 Jan 2025 13:59:01 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org
Subject: Re: [PATCH] check: Fix fs specfic imports when $FSTYPE!=$OLD_FSTYPE
Message-ID: <20250113055901.u5e5ghzi3t45hdha@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <f49a72d9ee4cfb621c7f3516dc388b4c80457115.1736695253.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f49a72d9ee4cfb621c7f3516dc388b4c80457115.1736695253.git.nirjhar.roy.lists@gmail.com>

On Sun, Jan 12, 2025 at 03:21:51PM +0000, Nirjhar Roy (IBM) wrote:
> Bug Description:
> 
> _test_mount function is failing with the following error:
> ./common/rc: line 4716: _xfs_prepare_for_eio_shutdown: command not found
> check: failed to mount /dev/loop0 on /mnt1/test
> 
> when the second section in local.config file is xfs and the first section
> is non-xfs.
> 
> It can be easily reproduced with the following local.config file
> 
> [s2]
> export FSTYP=ext4
> export TEST_DEV=/dev/loop0
> export TEST_DIR=/mnt1/test
> export SCRATCH_DEV=/dev/loop1
> export SCRATCH_MNT=/mnt1/scratch
> 
> [s1]
> export FSTYP=xfs
> export TEST_DEV=/dev/loop0
> export TEST_DIR=/mnt1/test
> export SCRATCH_DEV=/dev/loop1
> export SCRATCH_MNT=/mnt1/scratch
> 
> ./check selftest/001
> 
> Root cause:
> When _test_mount() is executed for the second section, the FSTYPE has
> already changed but the new fs specific common/$FSTYP has not yet
> been done. Hence _xfs_prepare_for_eio_shutdown() is not found and
> the test run fails.
> 
> Fix:
> call _source_specific_fs $FSTYP at the correct call site of  _test_mount()
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  check | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/check b/check
> index 607d2456..8cdbb68f 100755
> --- a/check
> +++ b/check
> @@ -776,6 +776,7 @@ function run_section()
>  	if $RECREATE_TEST_DEV || [ "$OLD_FSTYP" != "$FSTYP" ]; then
>  		echo "RECREATING    -- $FSTYP on $TEST_DEV"
>  		_test_unmount 2> /dev/null
> +		[[ "$OLD_FSTYP" != "$FSTYP" ]] && _source_specific_fs $FSTYP

The _source_specific_fs is called when importing common/rc file:

  # check for correct setup and source the $FSTYP specific functions now
  _source_specific_fs $FSTYP

From the code logic of check script:

        if $RECREATE_TEST_DEV || [ "$OLD_FSTYP" != "$FSTYP" ]; then
                echo "RECREATING    -- $FSTYP on $TEST_DEV"
                _test_unmount 2> /dev/null
                if ! _test_mkfs >$tmp.err 2>&1
                then
                        echo "our local _test_mkfs routine ..."
                        cat $tmp.err
                        echo "check: failed to mkfs \$TEST_DEV using specified options"
                        status=1
                        exit
                fi
                if ! _test_mount
                then
                        echo "check: failed to mount $TEST_DEV on $TEST_DIR"
                        status=1
                        exit
                fi
                # TEST_DEV has been recreated, previous FSTYP derived from
                # TEST_DEV could be changed, source common/rc again with
                # correct FSTYP to get FSTYP specific configs, e.g. common/xfs
                . common/rc
                ^^^^^^^^^^^
we import common/rc at here. 

So I'm wondering if we can move this line upward, to fix the problem you
hit (and don't bring in regression :) Does that help?

Thanks,
Zorro


>  		if ! _test_mkfs >$tmp.err 2>&1
>  		then
>  			echo "our local _test_mkfs routine ..."
> -- 
> 2.34.1
> 
> 

