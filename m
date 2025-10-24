Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6A4306B08
	for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 09:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761297487; cv=none; b=PSrI8MhTEzM6J7+Me//yYA5CbyVKGcxXX5w7+2XgDzeF3EL+udJi41UFaB+awU1/eyVoYCOVZo6j5g7gTIuBRxinO+peDpKzTSdoATZmKTvIHNc7Obh61f/xDQ4QULUTnnsohrnTA0EUMg037b8VICIScIqb+d/7SKTSkGTJw5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761297487; c=relaxed/simple;
	bh=MkHSCjiuGbedRTO0h6kA5KeA8QWtdD4n/Bl601uZN10=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=A3wpKebHs2d5wu7u34s8xZvMib0DA1iXxH4bxwEgouH7wcq2IPmcErRNSe1CZrNaLVoqfbX9GjFS3CWzTcWnCzM5COD/0PLHHprv2nv7QshCmK2Oee2a1lMWxYhxSdS6wE9ONqtxas+gKts6T5qyTVJRHyRoyumIf7crWOcKB2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RpX+1xOz; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RpX+1xOz"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-33e27a3b153so1884595a91.3
        for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 02:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761297486; x=1761902286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VTneT4Vk3qDp9GQmX9ch/ZDi0+H9sikLlw+PPuUwI9Y=;
        b=RpX+1xOz0niX0y/9HZZ9qInEjuu1efGesWqva+aXrqsXE0Kfwdjon/xs2ik7yoE2sR
         PiEqs4p/iiyQo4ofe6/YW+W5/HHTkmAC6pgaQ7oGPGgmCck53Q7Hn6vY1/9ZDv86jGIm
         XNhmSTkPoPjAEjWyfgswIKZK5FRT76aR9kt48lg4fLdpyYxEl2E3672yIHFstKjLW7vb
         v0p5KWQ9INgq21NoJ10az/HYRMibotQTYndF1+yVM3hMtptN4numo+n+9diSwC6ofzZz
         b5lA+YL/bwQTUIQeYsTWSZfAh2dhd2ByMKKw/FIuTfJjR238A9ojPBFWLmieQEvataoQ
         bayA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761297486; x=1761902286;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VTneT4Vk3qDp9GQmX9ch/ZDi0+H9sikLlw+PPuUwI9Y=;
        b=CBRWwsmGquRoFCD9dldHadEVZp5gRrD583sirSqnlTNRj0+1IZXVt/b7GGxe4cMrsw
         Z0SXkox9Sjh0lHUasNAILOyeOt7nb5b3kJgdgUyHpfHxeONV+Ry7tKXjIh4j3lZMAbvp
         +h9cDgVQLbmVz5svUDibwoW44e/mkG6DF2u4FkpqFmQBrjSA5vY5OyDo4PJLhwYk1Bc7
         jzZSdH0XZm1iMAXvdPDccxBZqStWPHQ6WpmnR6JMFkDsmI0Ec5fwbL0K2SXU3SUzZ/QB
         bMlCApkMQ+e+00NxLh3G5q8Jua1a0Vow5v4m+Ta8HrFMXNhS+OMkCVgHVzjz/qBhpGAK
         avNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqDbtl/Eym3hgf1qvw2PNfxHlZ9CDN/H7xCsZaCKRk7aBDRslqe1N7Pu1QiDlWY0wmh5sbPQ2INjA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI2UOrHiT4z3YSn6USDCMpXaaiphAb7MVjkpu/kLskvbJxWxSv
	JXE06YmSjWLP9ZC3MtW7VcINh/YkFlYZIsAODgjCeMtGESFdVOQT46l+
X-Gm-Gg: ASbGncv/z0R/X8Hjdc6hHUTj6oHLAo4OM6Z9lyysoFnbUhli8I6WWQv15TVzLxvTjKi
	bFQDd0crwdS9xQtAWmm9xL1JV2y+ZURp/nYOOG84EDsiKAJXSD//rusGasIg8O2QurGP73ZVncM
	wpZO7vCbJ4mFZHPktIMEJlacXPuS/3zFQsrA9kk3dFuhAZ9qDsNCO/h2un6PhBy1DqtBc13S1Bm
	/NM77S3f6Vikp4yIhO/FbMyub1aOy/ZpqJHFGL+9Aqyr6H3q4xBgQXiVrU/r1DPwmhHuz9PyoJN
	zOqrRl4lbLC/BZH09GMkHYAwSweW83UkJhCzQrlBVmSATrf+8Rq49cGll78eIPDDzqAunwIqNvL
	jf0X/LSJM+q1v6tw1ULLor0eTcT93k+CnZXlpcHsnHv/G9To0/4q56vN+wwqzRJ1wZEjxmVfJ93
	/hMYVoz3tUyRqLJT/z9acJiEDKvR0O7wHkomNIQSvt7hmBCDSAyGNE
X-Google-Smtp-Source: AGHT+IHtqGH6GpsWMe5DfeL4ZG5hW8+CzCw1Icbbe6oa59Qq4QMqv2SGK239tZT1wwgZrx9aw6abfg==
X-Received: by 2002:a17:90b:3907:b0:32c:2cd:4d67 with SMTP id 98e67ed59e1d1-33fafbac1d9mr7627042a91.13.1761297485604;
        Fri, 24 Oct 2025 02:18:05 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.202.82])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33e223cb0a5sm8399329a91.1.2025.10.24.02.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 02:18:05 -0700 (PDT)
Message-ID: <4e8a9b373fdfeecd3e0de2a91ecdd75fbb94e18e.camel@gmail.com>
Subject: Re: [PATCH 8/8] common: fix _require_xfs_io_command pwrite -A for
 various blocksizes
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Fri, 24 Oct 2025 14:48:00 +0530
In-Reply-To: <176054618045.2391029.13403718073912452422.stgit@frogsfrogsfrogs>
References: 
	<176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
	 <176054618045.2391029.13403718073912452422.stgit@frogsfrogsfrogs>
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
> In this predicate, we should test an atomic write of the minimum
> supported size, not just 4k.  This fixes a problem where none of the
> atomic write tests actually run on a 32k-fsblock xfs because you can't
> do a sub-fsblock atomic write.
> 
> Cc: <fstests@vger.kernel.org> # v2025.04.13
> Fixes: d90ee3b6496346 ("generic: add a test for atomic writes")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/rc |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/common/rc b/common/rc
> index 1b78cd0c358bb9..dcae5bc33b19ce 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3030,16 +3030,24 @@ _require_xfs_io_command()
>  	"pwrite")
>  		# -N (RWF_NOWAIT) only works with direct vectored I/O writes
>  		local pwrite_opts=" "
> +		local write_size="4k"
>  		if [ "$param" == "-N" ]; then
>  			opts+=" -d"
> -			pwrite_opts+="-V 1 -b 4k"
> +			pwrite_opts+="-V 1 -b $write_size"
Nit: We can still keep this to 4k (or any random size and not necessarily a size = fsblocksize),
right?
>  		fi
>  		if [ "$param" == "-A" ]; then
>  			opts+=" -d"
> -			pwrite_opts+="-V 1 -b 4k"
> +			# try to write the minimum supported atomic write size
> +			write_size="$($XFS_IO_PROG -f -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile 2>/dev/null | \
> +				grep atomic_write_unit_min | \
> +				grep -o '[0-9]\+')"
> +			if [ -z "$write_size" ] || [ "$write_size" = "0" ]; then
> +				write_size="0 --not-supported"
> +			fi
> +			pwrite_opts+="-V 1 -b $write_size"
>  		fi
>  		testio=`$XFS_IO_PROG -f $opts -c \
> -		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
> +		        "pwrite $pwrite_opts $param 0 $write_size" $testfile 2>&1`
This looks good to me:

Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>  		param_checked="$pwrite_opts $param"
>  		;;
>  	"scrub"|"repair")
> 

