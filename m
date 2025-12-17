Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE11B1A9FAA
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 17:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765990969; cv=none; b=eibAxFLcsgrfcwWjzRb5rHCB7Lrntq5vo4yGLevlG3Yswcc53WzG0dehctiqPaonsgZwZR5GqS+r0oZqVMGjayJa7vA78GC881FLNc8z3loJJ/Krx8OsHOC9RrcWInNFIeqbSLrhfIborcBwwfw2F/O1P6yLTdFqTSlQkNYqKFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765990969; c=relaxed/simple;
	bh=ToRJHcpjvXVga4X877HC3kIL7IrMUEU1J2VVkV8cndc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZvZJ1opzwgn8PQ46LtJWM0MhIKEBr/+PyHQ09EPKqf9iEdeuXNd6OPsNPf2f2QvkgfdnuDSRLby3QtXkoWiGFcCdjAVFad94zcSgpR1nEyKrmU2HVjHyffQVthtTmCFOeBH0Yx1lF84lxvqEbgmnIq9ANR6HWAtQLYoU9H6yV8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lrCbc00H; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lrCbc00H"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-34ca40c1213so2733260a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 09:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765990967; x=1766595767; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3BlAKzA21ErBWFpH53H6S+ldLrYlUKuDSpGtu3kSDeU=;
        b=lrCbc00HEbRr6b+RJNwKbSt0O2VWfxdq7QcAC+gbQU5Rc3TYV/D8+in0hJPHFZweJ9
         E+fyKhwtVK8INnPGiZhmGif8Iq4c5gna92K6HXby0Tu34fB/hkNI6UMnSlclGNj6zxNW
         z6ac6mP2Gf3Rx1yMHGokppfnzHML1TqkNBoNHTkfirXPx0VZZtWxhBjkYaF41T8l29Zr
         xFjESe5ciixJLKAq1nzPAz0Gl4dmRbzy9euDwYx/rVQ15BfaIb7RmOnWS5cQANXyKeOe
         7A25LFMPxAjn+4F96XRdW7v0yv6KjhFD3yxnjY1vd+9x8YTtwfXbRAZ7t5L0OrMX8TnS
         X0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765990967; x=1766595767;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3BlAKzA21ErBWFpH53H6S+ldLrYlUKuDSpGtu3kSDeU=;
        b=CUEfuwD+nRuGGZBXLMn3rkrVGAQq9H67QDRkwSWuE/ZcUk8DTMm+pv0nMoPn1h2dDS
         uAXdIdN0NSsMZkZ0ffkXNO5rZ5PMZr7nd+qyKo9B2VmA4e5xMcW9wt0OfS7VBZXIqw1q
         9MSyhtUR7NddKI2oY1RtxtrMpj0R8+UQr6oJ1+dKIV8gS28fle345f8qvvLUBuxIv5pi
         mQdLxvxrcBG6yuizrOSvN9Bmujf4KEWTczl+wSr1YIILNkV7TNicWeWLNSUrdbZR70cZ
         GrW775bmZMi0/NUhIQSxwkKI2cNjEVpO+/GFx8ISoqq0XFbptoX4LhBTPwDt5NldP4K5
         9cKw==
X-Forwarded-Encrypted: i=1; AJvYcCW4VXenLg4SLclbqtUcS4Cf9p5wo7N2hSNrCSgbgiwCL/vrEp0iyEyb2+6hngWhEcQuCPgNvBw/eoo=@vger.kernel.org
X-Gm-Message-State: AOJu0YybZAD2ARmvJjb8GFRnaNq9lyof7FXFQOhBfh7jGi6LjHe5Bi+/
	ntEHzb7LP69YKCZBaekp60WyyLb6Kjq5RjpyiTMxmXtCEsJx+7sz+XDb
X-Gm-Gg: AY/fxX7WfMQlVhY0I9szJmK2w+w9dhgoKHaaf1qsNpzVZeG++28ppgN8thZaCGXKSsn
	+FKsJju2kgoFqOVQLTSSrZUjSyRBFz7LAfsjDvT2L9reVaHzsh4LAnX1YMVs76RrHaXmDjlnEe/
	6TG+mD23m19IviKdeEaRoOWpjUdtyDQ7pGHeq0k5i+YB1RPbOVvAKovtd8qn9H2Ye05hmFwKDSn
	8rJOIAh1x+goUPqsJhChWQfdNQOBXJuE2QkqFocwDFzXkQpPlJvUvrcZMnaUb3Ns1F1/6/0/oDZ
	byr08TFXfTJcAgosl+51sOOpFZrts6tPwd2w1r5Aort71GAkJwnxi70147XiBNbB1qk5f9LmQgP
	edcgsEd5lhEz+NhvFcQe/KEAmO64gi8ZYHDdWbUlCgMmTrdNDx1j+WHwFs5NJi+qcSdkj5mSqH6
	gLyzNPHZ2eyLpv5DK4lqPKrkfJFw==
X-Google-Smtp-Source: AGHT+IEjJA54aEA6lI7AscWvPNd06zlq1bSw1wMcFH8bsgGXOTWLSkjWYzIWJqEuLnR0WZ1MVIJLCQ==
X-Received: by 2002:a17:90b:3912:b0:34a:4a8d:2e2e with SMTP id 98e67ed59e1d1-34abe47924fmr19838591a91.17.1765990964073;
        Wed, 17 Dec 2025 09:02:44 -0800 (PST)
Received: from [192.168.50.70] ([49.245.38.171])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34cd9aaaf2csm1933817a91.5.2025.12.17.09.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 09:02:43 -0800 (PST)
Message-ID: <7f13d1fb-92c0-4175-806a-0f7dbb2bfc63@gmail.com>
Date: Thu, 18 Dec 2025 01:02:39 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/13] ext4/032: use _check_dev_fs
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20251212082210.23401-1-hch@lst.de>
 <20251212082210.23401-5-hch@lst.de>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <20251212082210.23401-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


Looks good
Reviewed-by: Anand Jain <asj@kernel.org>

Thanks

On 12/12/25 16:21, Christoph Hellwig wrote:
> _check_dev_fs is the new designated helper to check file systems on
> arbitrary devices, use that instead of _check_generic_filesystem, which
> is just an implementation detail.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>   tests/ext4/032 | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/ext4/032 b/tests/ext4/032
> index 690fcf066c11..043ae4f53505 100755
> --- a/tests/ext4/032
> +++ b/tests/ext4/032
> @@ -66,7 +66,7 @@ ext4_online_resize()
>   	$UMOUNT_PROG ${IMG_MNT}
>   
>   	echo "+++ check fs" | tee -a $seqres.full
> -	_check_generic_filesystem $LOOP_DEVICE >> $seqres.full 2>&1 || \
> +	_check_dev_fs $LOOP_DEVICE >> $seqres.full 2>&1 || \
>   		_fail "fsck should not fail"
>   	_destroy_loop_device $LOOP_DEVICE && LOOP_DEVICE=
>   }

