Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6BE2F1FD2
	for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 07:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761291875; cv=none; b=oUAYtLL20Fz84BNuu66AGKB6xK3AhCJZfjiI8n0CUYnvUKHA9bf2KGNrHH9Y/cI+gbFW7qM1D4gGKV38lPxPa/p3PZNotihbJiSBAstBGlKax9RbjUUrrDA14axqPByJMPHmD55SPisb+Lcw48u/x6DBrR2cXdP21pbTTUpCtKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761291875; c=relaxed/simple;
	bh=ArZYbRNMdA6N4gxDdcBF9wkRYxv5mM3zDGm0GProB9Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=IRGd2Ff/naUoCQ6QE/SToFI2qaFqgZ8K91l3So2FxCf9LhxWuaUHZhDjNQhxFeuSAz+58e/LeKaeZtKUa2YRmXJnxNeq65WCR2S/j3AKQQnGUY6p4/IUHUvv6iKYCuiwb5BauvX7JevYvg6SBRPFs+vsac8T4bXFd4OoRy0cs3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JMXWtk8X; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JMXWtk8X"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-781ea2cee3fso1730408b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 00:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761291873; x=1761896673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5YK5Cv2mHUZf0+sS6ZBkjl83GDLbEDehObxxO+NhiJw=;
        b=JMXWtk8X5j6syd33yn+4vwYWYkH98W5IdJme7pzVgtElqhKon+8qobp9XJ8dLk88NE
         KbPyoqJyv6SWjQeNl3vw0i1g6wkJJer2ysjOi9i9B9FdIgSKJ0nL7NRwM79Y+RS7DCRd
         Etf4EDO7s3rm4m6pu+JbFb1sVhb7PqcV3Q+jlUIfveYobr08oHDfC7fbJ75covf8RQnW
         TlkWzBwSpb3305XEiFUKqcAwkAoq3jogWqbYJT2TdicfSGTdMmIGIcDJPnk4PjP7ixo8
         XLSdYIm4+SnGC2dOKaOubYTtHqohuiI6JAc3//bevdZYcjJbWuY8FI5QcYnd1Ct9u5em
         ngbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761291873; x=1761896673;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5YK5Cv2mHUZf0+sS6ZBkjl83GDLbEDehObxxO+NhiJw=;
        b=of3eCAhwW0c4AaDHQZtfHU819deBBdh1+OBUfc80Gz1SC/Q1PtntcDWxrp7stQm6Z3
         WQ3RYy2fuVlCFiERWwfJm5+Q3chM/7LQZiIwaGA2Y76fRPMjCi6+5wCZ5wgR9i0RYPxk
         Ry3Gh16WnMwRoT11wa11H/hj2gpOufodPpD8M7JJ7QAdK2ktqnSQ3pJ/a/zOYbtnq3ie
         4jvFUHkcXKclsuZdsHhE+y9XOtKAraYy2NQmDtNSgPAIK8N6UGkThz+AkInzpHCRvnwa
         YX9D1AjERriMrAPP9zo4nes/2jHm0cSSz1L0huoHYhraQBNHsCLa75ApWdqe3t+vv/Ld
         BI1w==
X-Forwarded-Encrypted: i=1; AJvYcCVgLbjnLvNnnVnugrEcSShO3HGvEGOfX88EVIOEANlfgQS6bthRbTYsCCGyWDub8GMtivXGLPBR04M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHyoJwqJ2dLuFBELvovIzn9twdz9smW+i5s3ZKXeFCsLtQbi9l
	6TczNqb+uXyPrezjQ1P1BiPaXt9ErUd81fXGPf3DQ+Gb+DyLcntBUAsG
X-Gm-Gg: ASbGncuAN2SxDHN+Dg0QkdFp87tir/Rn546ilq9R2tpog2W8KbYN+GjTMiQMFy2fTZm
	ex0TacTiCKTi6dW18xzv6Uj6bIyVryaT1CIxIGyb1kM6lOatn31M2UzhCpGjbeeMVlDyCNrye8L
	QNPJgZ3BIHH08R02c68Bho1f24Zc/9x+y4S9Epj/wHzMQoa9nrcXlYQ+Xo4kbV1aWqzdM3Ocyx5
	qKIsVzncftF25HAm8fCi6GWBbrQ1uBzd2LfNwnWrv5lxsmG4nB2CQ/+E6giTf1/02cOHOPSFkvh
	tH+wU9zGPcBwXgJUMjateetUbxTvBuDL/68RTRM7HWWYPF8JUfIpq5MVZnqWAxOMnhKuiihwuwz
	tDiwhyywOwZE6+nZiCVV97kHFi9mdFovI+3k+5S/vhxRpCM4ZNegqxtTfhzo24XBvZ3jmivorDq
	Wt832OtP2uDfhF0xSUIf9Sp1KKTBxXUiGlaVHz7L/LlB6PqzFx670W
X-Google-Smtp-Source: AGHT+IFjb5mZJgyR6bGIzS0AMBegu+BQn8DvDFMRLJFSSMUddJwgyi8DVtG32VC9u1C+4NcA8h2O6g==
X-Received: by 2002:a05:6a20:3d20:b0:2fb:62bb:dec with SMTP id adf61e73a8af0-33dead55a43mr1920840637.39.1761291872700;
        Fri, 24 Oct 2025 00:44:32 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.202.82])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274aaec46sm4906323b3a.31.2025.10.24.00.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 00:44:32 -0700 (PDT)
Message-ID: <68e2839c0a7848a95fa5b2b8f6107b1e941636a4.camel@gmail.com>
Subject: Re: [PATCH 5/8] generic/772: actually check for file_getattr
 special file support
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Fri, 24 Oct 2025 13:14:29 +0530
In-Reply-To: <176054617988.2391029.18130416327249525205.stgit@frogsfrogsfrogs>
References: 
	<176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
	 <176054617988.2391029.18130416327249525205.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-10-15 at 09:38 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On XFS in 6.17, this test fails with:
> 
>  --- /run/fstests/bin/tests/generic/772.out	2025-10-06 08:27:10.834318149 -0700
>  +++ /var/tmp/fstests/generic/772.out.bad	2025-10-08 18:00:34.713388178 -0700
>  @@ -9,29 +9,34 @@ Can not get fsxattr on ./foo: Invalid ar
>   Can not set fsxattr on ./foo: Invalid argument
>   Initial attributes state
>   ----------------- SCRATCH_MNT/prj
>  ------------------ ./fifo
>  ------------------ ./chardev
>  ------------------ ./blockdev
>  ------------------ ./socket
>  ------------------ ./foo
>  ------------------ ./symlink
>  +Can not get fsxattr on ./fifo: Inappropriate ioctl for device
>  +Can not get fsxattr on ./chardev: Inappropriate ioctl for device
>  +Can not get fsxattr on ./blockdev: Inappropriate ioctl for device
>  +Can not get fsxattr on ./socket: Inappropriate ioctl for device
> 
> This is a result of XFS' file_getattr implementation rejecting special
> files prior to 6.18.  Therefore, skip this new test on old kernels.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  tests/generic/772 |    3 +++
>  tests/xfs/648     |    3 +++
>  2 files changed, 6 insertions(+)
> 
> 
> diff --git a/tests/generic/772 b/tests/generic/772
> index cc1a1bb5bf655c..e68a6724654450 100755
> --- a/tests/generic/772
> +++ b/tests/generic/772
> @@ -43,6 +43,9 @@ touch $projectdir/bar
>  ln -s $projectdir/bar $projectdir/broken-symlink
>  rm -f $projectdir/bar
>  
> +file_attr --get $projectdir ./fifo &>/dev/null || \
> +	_notrun "file_getattr not supported on $FSTYP"
> +
Shouldn't we use $here/src/file_attr like we have done later (maybe just for consistency)?
Also, I am wondering if we can have something like
_require_get_attr_for_special_files() helper kind of a thing?
--NR
>  echo "Error codes"
>  # wrong AT_ flags
>  file_attr --get --invalid-at $projectdir ./foo
> diff --git a/tests/xfs/648 b/tests/xfs/648
> index 215c809887b609..e3c2fbe00b666a 100755
> --- a/tests/xfs/648
> +++ b/tests/xfs/648
> @@ -47,6 +47,9 @@ touch $projectdir/bar
>  ln -s $projectdir/bar $projectdir/broken-symlink
>  rm -f $projectdir/bar
>  
> +$here/src/file_attr --get $projectdir ./fifo &>/dev/null || \
> +	_notrun "file_getattr not supported on $FSTYP"
> +
>  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
>  	-c "project -sp $projectdir $id" $SCRATCH_DEV | filter_quota
>  $XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> 

