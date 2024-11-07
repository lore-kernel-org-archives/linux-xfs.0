Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575731D63F1;
	Thu,  7 Nov 2024 08:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730969167; cv=none; b=Vq3GE3unP3gXiIOBDhOlKrRQJLVq5TmuKx28oWGm2pzKXRmyiDXgv2fpo7gXAKxyJzLH8vrqwgWncvoetsXzD/avFsNSgaqyGl4KQF+ueY+VLThz9C/eK0sgspQRgQLtVjlffTCG7kxdT/1uTojiIj5Vgp419QvdzVEVZS3D2p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730969167; c=relaxed/simple;
	bh=XVpC0vL4dSyCmv2UW97S7ZmNuXpcUPzT4PIDs5lfG8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtF2y0EBLdKer10QccwBNKSssKkRoeM6ZfvCdREdcqB/dbWz6gw5XOR8t6ocYIwrIHpJ9zmAr7DbV+jKH18W93uVrmJ8Q2KIuDUgnUfHesV2u3PAk5S+EkpoDA1RIHxHKcKpVx9Wqh44m+FI2+xJ7ehZYKq12acae9cJFlFUAjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IH2mq9Gv; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IH2mq9Gv"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21145812538so6671105ad.0;
        Thu, 07 Nov 2024 00:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730969165; x=1731573965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=87ab9pEUneStoi9BaOdzV5RSJLTcxraQ1crI3Oaa3hQ=;
        b=IH2mq9GvscLKdOQhH62pH1q1oTlMWAd50oc4ByDSSXZP5dY8qHoeFkVajnVJ5POxE5
         OhfuG7tsbA+ZHtwN2y+pVMkoVO7kH+oT3+J404XhD6ZtLZUTrphf+dHMwhRl5tWJiGIt
         4ip5GkKPtvXR2NMKI94shZCelEOKlGTHJQadEdOoMpwQgRN98CSK8mDdU9IyjCPa7D+t
         PPP4KN2xANoS80sKCkWpXQ1lRQhNzLu8dKjB6CZSNyzHJ7UAgGDmTm0ElRxrXTv1tzaz
         WU63+NnquIqDi0RER858BuC3YF1NkaMoHRgbe6Q4gk2bLn3pSESvZoGjF8rK1ucmvQrs
         NayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730969165; x=1731573965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=87ab9pEUneStoi9BaOdzV5RSJLTcxraQ1crI3Oaa3hQ=;
        b=uF4l7TlxagIloHyMliGyxIpTHHxspsbXs+XgrkeoXCtfdouIXJCe1ZVQ0bea6UxIge
         6CmEnD4FMtEzNr9o16H4WWZG9s+7wu3nbl3+4momAy5mL1EQcYW7UX7x6p5d6wdJQU/f
         E/GBoNtrjP0u8Nuph0FH12YcrCAyb6yVGwIkcKzG7CcYlhHaHmR6lHZanQdKmFsXFXOC
         eZ8sZx+1aecE9D+WJoewaPWznHsLVMOrq0et30O5T6DX+tuz7qCM2DLQNwhY8M3ubi4m
         hpF/NFFmoXcqdPOR9uk0FjGbkLsbhok50x2mF47EiY0v646Pv1Ndxpuq0i47i7qQ+OpO
         grIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUlg4YayVgkquaWxQ4m5IDWCwjEnKo9bUINymUgq1g9S304BpbcewBowk075iVLnhpymHc6y+LUBR3RWU=@vger.kernel.org, AJvYcCX76uEzQ/VegDWXIv539vRI7YRQaLfJnixHhkJqmTP3ZMzYMkJCr32gbXT01u6wZ4QaSs4vEjzSpMmC@vger.kernel.org
X-Gm-Message-State: AOJu0YxLFaw8q7s7ZC14iyBHWAMuAJn6vAYehe/1kCmWGDiWroBJ1Xnd
	ew8tL1lY2e48vEzrVFNRMqU5PHDW7SlNf7DJvqhsz6bn+glgIYay
X-Google-Smtp-Source: AGHT+IFz4+e7Z2dki2CDZSqJI+sHIwVnHGysxySVe4iL7eIJ99BC/qHJhwQYwiRrf8nHppSz5sSqpQ==
X-Received: by 2002:a17:903:189:b0:20f:c225:f28c with SMTP id d9443c01a7336-210c6c9417amr578558895ad.52.1730969165604;
        Thu, 07 Nov 2024 00:46:05 -0800 (PST)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177e6b656sm7299435ad.254.2024.11.07.00.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 00:46:05 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: alexjlzheng@gmail.com
Cc: alexjlzheng@tencent.com,
	chandanbabu@kernel.org,
	dchinner@redhat.com,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix extent length after xfs_alloc_compute_diff()
Date: Thu,  7 Nov 2024 16:46:02 +0800
Message-ID: <20241107084602.185986-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
In-Reply-To: <20241107070300.13535-1-alexjlzheng@tencent.com>
References: <20241107070300.13535-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu,  7 Nov 2024 15:03:00 +0800, alexjlzheng@gmail.com wrote:
> After xfs_alloc_compute_diff(), the length of the candidate extent
> may change, so make necessary corrections to args->len.
> 
> Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 22bdbb3e9980..6a5e6cc7a259 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1069,6 +1069,10 @@ xfs_alloc_cur_check(
>  	if (bnew == NULLAGBLOCK)
>  		goto out;
>  
> +	args->len = XFS_EXTLEN_MIN(bnoa + lena - bnew, args->maxlen);
> +	if (args->len < acur->len)
> +		goto out;
> +
>  	/*
>  	 * Deactivate a bnobt cursor with worse locality than the current best.
>  	 */
> -- 
> 2.41.1

Sorry, I must have misunderstood the intent of the code when sending this
patch. In fact, args->len should not be changed.

But my starting point is I was wondering what will happen if
xfs_alloc_compute_diff()'s changes to bnew cause the extent's remaining
length to be less than args->len? So I have send a new patch:
https://lore.kernel.org/linux-xfs/20241107084044.182463-1-alexjlzheng@tencent.com/T/#u

Also, am I missing some key code to ensure that the above situation does
not occur?

Jinliang Zheng :)
