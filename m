Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD992E1F0E
	for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 07:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761291117; cv=none; b=aDZ2OWia6vuCPgHDp/8uruHLM2NSRxo2Dga30Ulmfcz9nyW7EsAvHHvMUg2HICe4IuZeStupbytds9bKZnJkzHHwhPeN+mpqFmqlmUcveCQfsMYOiJGIpQeU7mIcgrjTz/Vb+rUmrpBdmhNDUl0BKnMv6Qf/oZe9rgb7/6BzMHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761291117; c=relaxed/simple;
	bh=hGGXbnlJbNirMVKZsmuNJSZHVRJA0rz2SBB/4/CB6WQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=HqimIP/dVL7d1DKvFLyODciPt1Us0nFiVFkwqcsAzO0WK/YYDhJZ0PVhe/KUNRPrQLzZPQw1YHp/ifuKXiBc2jWOjNbBGmXXpkD8/+RdWA9JYe5K8URoHtVNHJZeEOfVyFkKOYY7Z4mtbIr8XSHEq9+XnkK1nU9L8iW0rBF1slA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W4pBvXHg; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W4pBvXHg"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-781997d195aso1269391b3a.3
        for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 00:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761291116; x=1761895916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1A7P5IMbPn+t40gCyqItOLfp70nnc5B3DPRJaxQKRqg=;
        b=W4pBvXHgcPqidzw48Ycy9P/eA+hD8L2VOrpdwfuCIm7zlvrRKabKcjHYQEs+dMzdSu
         P81HuReZ8am02yCKw4Hx+JovB4tKrzjtKRdfbNWocPbGKcdrmTmh2t5bCbUeelNO9Om0
         pEJ2GZTHQEWRKeWDGkrirsEm+b0lqhsBaNjtUD3ujVFQxhBj49DEsB8RdYKLRf9J7scF
         TDk1XnxS0nJjTmTy62zSd3MEkf3/VWw2Rmd6FZNQZzs9Z9qrgtqV20wO0FQ/rSj6bdlX
         R+EnvRe5n5ImiupTUm/xudYbMwoqLrLA08zmzqiK6mt5u27SP+XLU0qBUzBfK/6jS2q+
         FRqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761291116; x=1761895916;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1A7P5IMbPn+t40gCyqItOLfp70nnc5B3DPRJaxQKRqg=;
        b=aHTgHCw+6WGxgVjVMkgN1kzJx3VWaAJLtXysBFqhO5szpSfUxHeVs8dYgRA8vKZCju
         nhEBvIibcOe9BIo+JW2I6BgPWVe0d256VOv5XSLsAJ/gM1n3j4KrJjhTu+H+/auWooFy
         YkSDx03fL5QB3sS/CQhfb4uSUi2cn4pKR7DucPNuebDfFW5rXwBRxpXkIn/oJOx/8TO+
         AgJs5YKyOMCGf2kE6+U9F/glXPBJ8Q29Jm0AjKJwSqzAzoiLxxmVK7/Z2NMnZaY7HSL5
         w/An7tBbx+No1IpVDRFflkEmOEQEZ6RFkYJxBfOyCpiD/AlSLjNgFw0zGl5/KJZZOtoO
         JhnA==
X-Forwarded-Encrypted: i=1; AJvYcCUkRiGL4UnLJj0QVbEUGgMumqfNbTpn1MZ8QcDVD9OuPtpl3Qu/D51gKWqw533PefqhggNfL5XoCI4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb2gMN1wX1gDLFh+8k7NKxwZ1UelTswKAl0XSL7djlo136vs2y
	NU/Ubdtc3cJqBFrNBkohYLlt0y99eSjUT/vzQg9N3dV2tPBJlZa2ZfaC0Qgttg==
X-Gm-Gg: ASbGncvRTAYOZaujNS4LN1AXDCTP0Yyym8Ux4O/IOZTVt6cv4VIuEsn+yXkJnFBqDQ0
	1fkAXuVisVBvBwG6mKhl20XYyQMwiXsOyq7OFi9txGm/JAbXYPAyQh5PvDd9RIx8ZKc9aA5mVQJ
	Ukeqw7RS03Is/1BD6dwCaKubEj4+NiKDYDFraMBpvYmY/T0zR5YRA+JAouV4/Omvd5e5OXTxlW5
	DYkeMRtfMyXDhUiLNJARudU1jqlCyOFfuLJhCU5tzdCwDm+iGJ+knRJi01OhZJcV0ho8D6ae2I/
	F1XFXq1xr6nNw5SLz9ZEnxgztGdCKRBd+5y3aSRAOhLB9f5dQvLiQtsSDU/XzZ2ykriDRNRVO5k
	/UAITeZCIEK6+dmaxr1+mNML60g2VSwq9b8KLqsFHlcARh5Ms6cyr6Ht8O9w6reHyEgXho4kjQF
	n7eU1eV48HMX4swgnrDD2CHabZKEp7HKJRV9gXybr7AVPXWLwJOOkv
X-Google-Smtp-Source: AGHT+IG/J5FlS1bROellmIONy1OUUsTDN1yuoEJ8FKRhOP/Hr0N9ZSHlvALYSp9AXRyRCWHg0DFhMQ==
X-Received: by 2002:a05:6a21:3397:b0:2e4:9004:52fb with SMTP id adf61e73a8af0-33de8fa0809mr1819180637.4.1761291115702;
        Fri, 24 Oct 2025 00:31:55 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.202.82])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6cf4e2d787sm4233408a12.29.2025.10.24.00.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 00:31:55 -0700 (PDT)
Message-ID: <ee99fc234ccfc433662975d45f24c8900428e2ea.camel@gmail.com>
Subject: Re: [PATCH 2/8] common/rc: fix _require_xfs_io_shutdown
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Fri, 24 Oct 2025 13:01:50 +0530
In-Reply-To: <176054617932.2391029.3304833304093152893.stgit@frogsfrogsfrogs>
References: 
	<176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
	 <176054617932.2391029.3304833304093152893.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-10-15 at 09:37 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Capturing the output of _scratch_shutdown_handle requires one to enclose
> the callsite with $(), otherwise you're comparing the literal string
> "_scratch_shutdown_handle" to $SCRATCH_MNT, which always fails.
> 
> Also fix _require_xfs_io_command to handle testing the shutdown command
> correctly.
> 
> Cc: <fstests@vger.kernel.org> # v2025.06.22
> Fixes: 4b1cf3df009b22 ("fstests: add helper _require_xfs_io_shutdown")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/rc |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/common/rc b/common/rc
> index 1ec84263c917c0..1b78cd0c358bb9 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -619,7 +619,7 @@ _scratch_shutdown_and_syncfs()
>  # requirement down to _require_scratch_shutdown.
>  _require_xfs_io_shutdown()
>  {
> -	if [ _scratch_shutdown_handle != $SCRATCH_MNT ]; then
> +	if [ $(_scratch_shutdown_handle) != $SCRATCH_MNT ]; then
Yeah, right. _scratch_shutdown_handle is a function call and should be placed in a $() or ``. 
>  		# Most likely overlayfs
>  		_notrun "xfs_io -c shutdown not supported on $FSTYP"
>  	fi
> @@ -3073,6 +3073,11 @@ _require_xfs_io_command()
>  		rm -f $testfile.1
>  		param_checked="$param"
>  		;;
> +	"shutdown")
> +		testio=$($XFS_IO_PROG -f -x -c "$command $param" $testfile 2>&1)
> +		param_checked="$param"
> +		_test_cycle_mount
> +		;;
Looks good to me. Just curious, any reason why we are testing with TEST_DIR and not with
SCRATCH_MNT? 
Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>  	"utimes" )
>  		testio=`$XFS_IO_PROG -f -c "utimes 0 0 0 0" $testfile 2>&1`
>  		;;
> 

