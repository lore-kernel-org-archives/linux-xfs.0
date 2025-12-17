Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38D723A9B3
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 17:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765990925; cv=none; b=fyyjfsXhhXHrnroDgVoqvM0TgwUhBVoA77ZjERM4UCwk0uNF7JXqBG+Pd+nJHxZ+OeZE608kxZk+RQoCD1q/zfnaTPd2ZhQa28YZt45hL28G6lLfHjMa2XLcIrLFU+juxx++Dey51PAFY5xF0VNkm6i8Btq+pkBDne9gUXOeNJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765990925; c=relaxed/simple;
	bh=rgDhIZfdsOfkurhbewxOfigJvc2eSqaTwXIruE5NLKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=azsw0/79nqfaH7sYIRFKIfi+KsYroYB2nKvxjOclsIdXQmHFmeFLsdtT9mtuKgbRkpJREu6cKdKwjj0uQDKyoyzFFZVVJEElrnIRvw5B4Kuq7oPDbXKRwmAwpOVKHwI72r0VSHW1gdG+omdjyqeFWeUacIE03XHaTNzkJNcNIUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vm/At79V; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vm/At79V"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a0d6f647e2so59178655ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 09:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765990923; x=1766595723; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GKCp6fL8IQ3vq9/UmgCTuTo5F9F6pquy8iJD7G2eufg=;
        b=Vm/At79Vx6NGayser4e9SOUBq+8gM4Bov/0xmfAfuqmwGQAbm+0YmMPlVP3DgNgZSI
         cbJplth/y6eXdaQoUchGFS+vJxPd/L/qEVfXOZbSepIU7aIzyL8m44D+ZIRstTpB/t3p
         RwJiS76LWSfrTzWmFMRu74fB31qgg6XEuV/ybit5yeVKEDVBqq8mdbTLOVyHDw8EMZZV
         evDk7Hq8hVJ1XmNVRh/ju0trQY11c8+akHcSa/tz9e2/Of1m+v6CiatXFbQPdp2TPcY7
         FDSfgQ0fGDTfcRJQ0qx+xCyKwTIjHtfAQlzgX0BNc/+KgSF5BqtTVpQ6YEJAt5lacMAT
         BFaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765990923; x=1766595723;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GKCp6fL8IQ3vq9/UmgCTuTo5F9F6pquy8iJD7G2eufg=;
        b=XGR+wofrb5p0hOa6OVC5t1IX0Uayy3bxKVxR29NFTnWIca6RhsEAsJ3+HCNa1mOPOh
         t/uNAgcWBoRcFpHC+xP6L315nBdvQApMmQVICArgrrzcNh0DvxkGdoKCvC7Qe4s5yPj8
         Ip+Mkb8aYyxJhJXv1+f3l1/w3f9VUqNrhpT+zzfF4j4WwE1wpqCEwyjUWDhkvurKG+rX
         dm/eHTLxfjA3wKd0Kib9Pw3kNCBORPcGmhuBC9sgyPIKHBvvTAgjHH22Gc5DQOqAxnHJ
         3wFTOwpz6xr1qdn0rmQuIb4Zvje120B2YZKkIkux4vRJyIYy5rGg/syVMcASJgheX9WH
         tskA==
X-Forwarded-Encrypted: i=1; AJvYcCWXlPetAoemFnhbxJWFeOvtzYmK/+CEN/9riKOW+baqlSkd2gb8suRF6mQLM99Bjn5Lc0fhYGZ6E0I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrICpQ8oKcFxifqQ718XjPi91Ns4ICLV83HrHri3mPkATawATu
	b9xne5tsOZUa4ZwFQh1/JH8MDqlNeiDRldsehf9P5AO43QPDRpD7pSv/
X-Gm-Gg: AY/fxX4PsXw5BzE0xFT6p7p131vhCfAFCwVesAniEXVeSX8oRT7CQgFLikPL335Z+rO
	D+LHq3KpcntWX8/QRf7DvbB64gVl7hOSlJ1ekkBQxohLcgdWlpP9mLqvmNu6uLfnEwYGlBcmnIH
	BxNm5TW5KH6WJqHMXobr4DbST79Mz95EUrecxwBU7V4A3ql2zeMssyl1LFSKq0lLTINNQsxNjT7
	vIPXzHYs2ONme/I+SvCdl0R9/1PVBr3+0wHAbdYMzqEqdXTh3HNRkKHuJcseypmi+MomsDrEj2l
	UBaWAJnLWpIGm5ROXjcK8Yk7lQQrRFsYW3GD+gj6QcdZAAQSuLcXqB9BAvXfTDc3y4P+2e6Vgig
	K+tonK4FeDrpit/59sHkwFX2IGx4S7gJjPWdqABMB4swMYxN+mXOyrNvkkHPXoBWcs8AyAtvQr0
	RT9oYD6KL0P2FGUn8=
X-Google-Smtp-Source: AGHT+IHQU6VgGvHLOaZBxPkML0Q3IsVDTQ69nAbkvfgwbuU/wkhHQjsH+QVx4aUpRGynw0ZJLPOnfQ==
X-Received: by 2002:a17:903:1b47:b0:295:3d5d:fe37 with SMTP id d9443c01a7336-29f23ca6bb5mr228820485ad.41.1765990922266;
        Wed, 17 Dec 2025 09:02:02 -0800 (PST)
Received: from [192.168.50.70] ([49.245.38.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2ccebafa0sm153975ad.25.2025.12.17.09.02.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 09:02:01 -0800 (PST)
Message-ID: <52111335-ca0e-4ede-a7b6-668ce2c81325@gmail.com>
Date: Thu, 18 Dec 2025 01:01:59 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] common: add a _check_dev_fs helper
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20251212082210.23401-1-hch@lst.de>
 <20251212082210.23401-4-hch@lst.de>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <20251212082210.23401-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

looks good

Reviewed-by: Anand Jain <asj@kernel.org>


Thanks


On 12/12/25 16:21, Christoph Hellwig wrote:
> Add a helper to run the file system checker for a given device, and stop
> overloading _check_scratch_fs with the optional device argument that
> creates complication around scratch RT and log devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>   common/dmthin     |  6 +++++-
>   common/rc         | 21 +++++++++++++++++----
>   tests/btrfs/176   |  4 ++--
>   tests/generic/648 |  2 +-
>   tests/xfs/601     |  2 +-
>   5 files changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/common/dmthin b/common/dmthin
> index a1e1fb8763c0..3bea828d0375 100644
> --- a/common/dmthin
> +++ b/common/dmthin
> @@ -33,7 +33,11 @@ _dmthin_cleanup()
>   _dmthin_check_fs()
>   {
>   	_unmount $SCRATCH_MNT > /dev/null 2>&1
> -	_check_scratch_fs $DMTHIN_VOL_DEV
> +	OLD_SCRATCH_DEV=$SCRATCH_DEV
> +	SCRATCH_DEV=$DMTHIN_VOL_DEV
> +	_check_scratch_fs
> +	SCRATCH_DEV=$OLD_SCRATCH_DEV
> +	unset OLD_SCRATCH_DEV
>   }
>   
>   # Set up a dm-thin device on $SCRATCH_DEV
> diff --git a/common/rc b/common/rc
> index c3cdc220a29b..8618f77a00b5 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3692,14 +3692,14 @@ _check_test_fs()
>       esac
>   }
>   
> -_check_scratch_fs()
> +# check the file system passed in as $1
> +_check_dev_fs()
>   {
> -    local device=$SCRATCH_DEV
> -    [ $# -eq 1 ] && device=$1
> +    local device=$1
>   
>       case $FSTYP in
>       xfs)
> -	_check_xfs_scratch_fs $device
> +	_check_xfs_filesystem $device "none" "none"
>   	;;
>       udf)
>   	_check_udf_filesystem $device $udf_fsize
> @@ -3751,6 +3751,19 @@ _check_scratch_fs()
>       esac
>   }
>   
> +# check the scratch file system
> +_check_scratch_fs()
> +{
> +	case $FSTYP in
> +	xfs)
> +		_check_xfs_scratch_fs $SCRATCH_DEV
> +		;;
> +	*)
> +		_check_dev_fs $SCRATCH_DEV
> +		;;
> +	esac
> +}
> +
>   _full_fstyp_details()
>   {
>        [ -z "$FSTYP" ] && FSTYP=xfs
> diff --git a/tests/btrfs/176 b/tests/btrfs/176
> index 86796c8814a0..f2619bdd8e44 100755
> --- a/tests/btrfs/176
> +++ b/tests/btrfs/176
> @@ -37,7 +37,7 @@ swapoff "$SCRATCH_MNT/swap" > /dev/null 2>&1
>   # Deleting device 1 should work again after swapoff.
>   $BTRFS_UTIL_PROG device delete "$scratch_dev1" "$SCRATCH_MNT"
>   _scratch_unmount
> -_check_scratch_fs "$scratch_dev2"
> +_check_dev_fs "$scratch_dev2"
>   
>   echo "Replace device"
>   _scratch_mkfs >> $seqres.full 2>&1
> @@ -55,7 +55,7 @@ swapoff "$SCRATCH_MNT/swap" > /dev/null 2>&1
>   $BTRFS_UTIL_PROG replace start -fB "$scratch_dev1" "$scratch_dev2" "$SCRATCH_MNT" \
>   	>> $seqres.full
>   _scratch_unmount
> -_check_scratch_fs "$scratch_dev2"
> +_check_dev_fs "$scratch_dev2"
>   
>   # success, all done
>   status=0
> diff --git a/tests/generic/648 b/tests/generic/648
> index 7473c9d33746..1bba78f062cf 100755
> --- a/tests/generic/648
> +++ b/tests/generic/648
> @@ -133,7 +133,7 @@ if [ -f "$loopimg" ]; then
>   		_metadump_dev $DMERROR_DEV $seqres.scratch.final.md
>   		echo "final scratch mount failed"
>   	fi
> -	SCRATCH_RTDEV= SCRATCH_LOGDEV= _check_scratch_fs $loopimg
> +	_check_dev_fs $loopimg
>   fi
>   
>   # success, all done; let the test harness check the scratch fs
> diff --git a/tests/xfs/601 b/tests/xfs/601
> index df382402b958..44911ea389a7 100755
> --- a/tests/xfs/601
> +++ b/tests/xfs/601
> @@ -39,7 +39,7 @@ copy_file=$testdir/copy.img
>   
>   echo copy
>   $XFS_COPY_PROG $SCRATCH_DEV $copy_file >> $seqres.full
> -_check_scratch_fs $copy_file
> +_check_dev_fs $copy_file
>   
>   echo recopy
>   $XFS_COPY_PROG $copy_file $SCRATCH_DEV >> $seqres.full

