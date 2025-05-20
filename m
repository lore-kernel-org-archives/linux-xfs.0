Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558542566EB;
	Tue, 20 May 2025 02:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747707346; cv=none; b=gw159GcIvhKHdm10W424eEKBTGVqQdR/9O4WagPKTZkZajKtmNAaXeO/Ja5MYDvseen2Q0eTfC/pdKW1TZ53yzhaybtNVwis6KFl9qyp3a56T5st6YBOBC9dYN6ntG/koXXjzEfXtUD+bDhCicrdswLtOqSHPoGkYz+v+G+QYkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747707346; c=relaxed/simple;
	bh=cM5ZM+/oRG3JtGyx5defvVY6eGcmT5Tdd8q06CbUL0M=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=FIY9gfnO6sWoTwGRKq3lv/aLRzTZ9DqUDxjWAewbx4zw7/LWSf4YUS7faO0+t8183ADaeYdqHg3FvIab2Nheb+uBku+OV1NlY7E1ICu/w8sjUpqV/+TYgIvIx/mrwyoFY+B/nhTpr4VPqmO+ShapqvHs9vXjbWZoJSbfpYGHd0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LxsOpLVW; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxsOpLVW"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-231fc83a33aso25955885ad.0;
        Mon, 19 May 2025 19:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747707343; x=1748312143; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w5qQBNBheDBZ1ExMUftu/6hIs7FmNyJZi6tl2AyRFk8=;
        b=LxsOpLVWFm7bJJ2/UYspplIA1lKTZ7lRNJ5Y11aeBSTxzodiXGB9kqfMqWKfHvSJu+
         h/Gz75SGMtBsFTTA2u967PTJuGJSqI1haMZg3f4ebjiRzFADxOIna3NqbEEgRM6Uu5x8
         FAmbNLB6YJBsoEaMm2yf9FsTJdrKLnviZnzQRCh7hGlFM3/AGCYsrkNd6YXaHljvS4o7
         2qErgT3fw+I1lMxWfLqh/+P8rEf1+CxzGCwgpDiovGi2mW5RCK+1eLoHlfqk2PvIXdFK
         TkJOigTuwerzYUq3EbfwGLPMhJW6QzgrCj2/VkKFPNPUXBuuRyVR+zyOPqWTBdKVAAip
         qCAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747707343; x=1748312143;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w5qQBNBheDBZ1ExMUftu/6hIs7FmNyJZi6tl2AyRFk8=;
        b=cxENYF1kyEdaf0MRrc8lgCGZG+cDb9WtPCTmUIph4ngCAfW788grZtEn51CWmYHePi
         ywSDDBPL8NF6F1X/nrJb4hBIPmgSBGxtFFgyt/Te3WOIfmhEcCzo+I0eLS6G173u0MAO
         zYA0BT8B5/hqBUkFlYl1IH0EJ00WU1PV/XHDp6FLJqxX5L6i8/1pkvFBGPD3KVwvng02
         9f7iws9XmtlOyJySRYx62xmjAcWMHgyerUehiK19Yak2lPzFAW1GBchzsH+CnwFau9jr
         NSq7N2ZynugPXE5c7pYvQI0GyeJ0AObYKFZ9h4KGHIH+u9UDYzBhN30Kf/kYHD1I0adF
         3PmA==
X-Forwarded-Encrypted: i=1; AJvYcCVBUVHTDUr6+Ks9p+IwAsfbGh3u3VxrYCqdE5fmEBlTF9Kcl6y3iGj0FGaavt5THrUsa4jasHOX@vger.kernel.org, AJvYcCW6HrLiEqtyb/t9n5n23WTdklyHxAO1JJoXaElgOJWJc7DMRoHXpzr6wWz/B494CG87EaQcgiQllNXW@vger.kernel.org
X-Gm-Message-State: AOJu0YyhPyblqdfDpgbrUxRP9jqDjjdZBgL0ZkEQn75Kr5GhLizH5p7Q
	Jb1BgpdwxWowkIWghdm3ms5hEemmNtkY8+i/Z1VDs5Ze1LrmZ49c/U5y
X-Gm-Gg: ASbGncttFnFc6a50lG5X3tIlMZJgWMWoEueVF7L9cd2k2I9H2GX5vpQD2Wvxmi/uIiQ
	J7HKPrRsp6dr/w4ouhSQMuXe7lANDemsJWyK7HDzUWG6/rkD3PDsZyhVHucGetdXIBpZD2bNZ2y
	vimIA96CVIwS8vw1YqN3eM3zQ94lyvUFWP4fdo3KNKA3m2wUjPQoJintvoZmtaGjGvoZOjtLkds
	H+pUzj16OHKn6ilsAksG465XFap9MoV6Az6sWg+o2GVsgtLM3IhA300Jj78pPMc76fG1nygvHwk
	VRCpWFWH2yQTpNNe6w+i3l8aF+fzGmZYlDH3k3pJHQY=
X-Google-Smtp-Source: AGHT+IFKAYES+5QkxkJMbZn3oV3iH1FoR9dDGRomaInjaiMoppAtgeEZ6ysKh44P8ipjbkutKKtpag==
X-Received: by 2002:a17:903:46cd:b0:223:54e5:bf4b with SMTP id d9443c01a7336-231de36c29emr208781115ad.25.1747707343389;
        Mon, 19 May 2025 19:15:43 -0700 (PDT)
Received: from dw-tp ([171.76.82.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4ebabfesm66504615ad.174.2025.05.19.19.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 19:15:42 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH v2 5/6] common/atomicwrites: fix _require_scratch_write_atomic
In-Reply-To: <20250520013400.36830-6-catherine.hoang@oracle.com>
Date: Tue, 20 May 2025 07:44:44 +0530
Message-ID: <874ixgvxij.fsf@gmail.com>
References: <20250520013400.36830-1-catherine.hoang@oracle.com> <20250520013400.36830-6-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Catherine Hoang <catherine.hoang@oracle.com> writes:

> From: "Darrick J. Wong" <djwong@kernel.org>
>
> Fix this function to call _notrun whenever something fails.  If we can't
> figure out the atomic write geometry, then we haven't satisfied the
> preconditions for the test.
>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> ---
>  common/atomicwrites | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)

This make sense. Thanks for fixing it. 
Please feel free to add: 

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

>
> diff --git a/common/atomicwrites b/common/atomicwrites
> index 9ec1ca68..391bb6f6 100644
> --- a/common/atomicwrites
> +++ b/common/atomicwrites
> @@ -28,21 +28,23 @@ _require_scratch_write_atomic()
>  {
>  	_require_scratch
>  
> -	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> -	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> +	local awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> +	local awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
>  
>  	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
>  		_notrun "write atomic not supported by this block device"
>  	fi
>  
> -	_scratch_mkfs > /dev/null 2>&1
> -	_scratch_mount
> +	_scratch_mkfs > /dev/null 2>&1 || \
> +		_notrun "cannot format scratch device for atomic write checks"
> +	_try_scratch_mount || \
> +		_notrun "cannot mount scratch device for atomic write checks"
>  
> -	testfile=$SCRATCH_MNT/testfile
> +	local testfile=$SCRATCH_MNT/testfile
>  	touch $testfile
>  
> -	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
> -	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
> +	local awu_min_fs=$(_get_atomic_write_unit_min $testfile)
> +	local awu_max_fs=$(_get_atomic_write_unit_max $testfile)
>  
>  	_scratch_unmount
>  
> -- 
> 2.34.1
