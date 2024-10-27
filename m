Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C4A17A5A4
	for <linux-xfs@vger.kernel.org>; Sun, 27 Oct 2024 22:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730069621; cv=none; b=oxkGk4C6dlpn5SRcE3/6ImCUU6+IfQ48ZmTUcz7v75B22g2RaC2qBd1c+YzjAxz3MlNseTqpN6RCUxqutjlqojCEKn2leHCUsDRTrNU7XRhSLiW6wRolfRgdwcVrR5Iwu+1jzj3Mh2MUCX8KOzWzqPzs8NNmslLxktgVMqmPrNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730069621; c=relaxed/simple;
	bh=u9/0ARz33371gpbvia/4zMBxB73y5XPWJIiEiIAFKo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ORs+fVjAKixmj9DIFo21IC5o0Pwd5YIiFN7OccQTD2NNs7pXgjWUQxwWkCPPtHvvQXMGSx83jtXdsBjzgeCBOS8mt/0Fuh7sWDek7xHosjDR20P0GbhRz2P+nCBtj6uWmGuy0fBwOGbQyTSS5wvEYlQmQCjRdIBPgvkfLOhuOpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=mRG6Hswu; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="mRG6Hswu"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2e2a999b287so2942171a91.0
        for <linux-xfs@vger.kernel.org>; Sun, 27 Oct 2024 15:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1730069619; x=1730674419; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nro3XxCXpJF+bC6xNwB831aGBU1HecPqJX4rsBIEnQw=;
        b=mRG6Hswu0n5OkbQnCQRyF7ZqspO5KNseAWwIzOPv15UnoSHr9kMsG+EKqdA3N46gQk
         NuiFj7FYEuVl5bBNGAYqjeRyR/0f8tyEjCYJwK53/F5LALKECQyKluDp750s89BLRVKM
         KPP/+K3KI7HnQ7EM6aQ2kw+T/pFkAAGYRsV7DY0+jbzE68xAhrjjOOuTaQIcBbIUOmCL
         r1gBGPGJjiEP515o9BAq4ML0FtdCE4HvqmSTzQFTD+gTJjvLv/0JNNfpu1xr7MJF/NEZ
         T+71O+aIf0PVRFxZx8izE9FMYY0udxm23HDePZ7fDMJdjGQ5yNKYm6kAWTBuWrtPa+fy
         1jIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730069619; x=1730674419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nro3XxCXpJF+bC6xNwB831aGBU1HecPqJX4rsBIEnQw=;
        b=NSZ98MhjbfGWvTJKkTI3/CSIb6vsiGH23fqsqyjwV0aKBPsDc5EAzW4DkKmUyUMeGo
         wYhKc1GMXEwmBp056NSf+4mo7F1D3qdUHGMlprgKXP+qlIVrQtG/hV68pZr7c6OKgzag
         ciedBizg2PClxAjgMkVCR3S0gAglfD+PJofspOtJT1jRlkcXM5cLhLRHPHHCi1xNROXF
         9PNYsz1NtvByXSy8bDXDMKxjJhiz7/wllvlzwURlb1cCv9JBSVVQqcLNynkmNjlPZ0no
         /qelvq9pRHebbgSxnpHI4Eruxcqqmfirj5Oc0L/nITtKjjcIv19qmPg3Lk/tMo8aDPXA
         Gx/g==
X-Forwarded-Encrypted: i=1; AJvYcCV+AsDcwA120eeXFKOX96xxcuEcgM+iZ2Cd5WKPUmxSjBGHv8hzX30FULYgVYyVF6xucpYCPnIrP/s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxW9HN9A4B3jI7rOpSeXX9Sa+tznErGHFmjdakY8rLDogt1+0n5
	lXCF/2FUBA78iilOPEKCYA9w7CTNfJMEmizz7InxJNiRQk0HeB1/RHr0dbYiJlc=
X-Google-Smtp-Source: AGHT+IHJqXWaT3OZaNBdV7tF8LBOsA9mbk2i8yEcHUuwgfPiBXIf3iPvulK6GrS91qfDhUAAEqwctQ==
X-Received: by 2002:a17:90b:4b42:b0:2e2:8995:dd1b with SMTP id 98e67ed59e1d1-2e8f0f533f7mr7653538a91.3.1730069618666;
        Sun, 27 Oct 2024 15:53:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e8e3555c1dsm5595585a91.4.2024.10.27.15.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2024 15:53:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t5C8c-006f5z-22;
	Mon, 28 Oct 2024 09:53:34 +1100
Date: Mon, 28 Oct 2024 09:53:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: MottiKumar Babu <mottikumarbabu@gmail.com>
Cc: cem@kernel.org, djwong@kernel.org, chandanbabu@kernel.org,
	dchinner@redhat.com, zhangjiachen.jaycee@bytedance.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, anupnewsmail@gmail.com,
	skhan@linuxfoundation.org
Subject: Re: [PATCH] Fix out-of-bounds access in xfs_bmapi_allocate by
 validating whichfork
Message-ID: <Zx7EbudZfwLQDuVS@dread.disaster.area>
References: <20241027193541.14212-1-mottikumarbabu@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241027193541.14212-1-mottikumarbabu@gmail.com>

On Mon, Oct 28, 2024 at 01:05:27AM +0530, MottiKumar Babu wrote:
> This issue was reported by Coverity Scan.
> 
> Report:
> CID 1633175 Out-of-bounds access - Access of memory not owned by this buffer may cause crashes or incorrect computations.
> In xfs_bmapi_allocate: Out-of-bounds access to a buffer (CWE-119)

We really need more details than thisi about the issue. I have no
idea what issue this describes, nor the code which it refers to.
Where is the out of bounds memory access occurring, how does it
trigger and where does the code end up crashing as a result?

A link to the coverity report woudl certainly help....

> Signed-off-by: MottiKumar Babu <mottikumarbabu@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 36dd08d13293..6ff378d2d3d9 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4169,6 +4169,10 @@ xfs_bmapi_allocate(
>  		 * is not on the busy list.
>  		 */
>  		bma->datatype = XFS_ALLOC_NOBUSY;
> +		// Ensure whichfork is valid (0 or 1) before further checks
> +		if (whichfork < 0 || whichfork > 1) {
> +			return -EINVAL; // Invalid fork
> +		}
>  		if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
>  			bma->datatype |= XFS_ALLOC_USERDATA;
>  			if (bma->offset == 0)

That's not going to work. If you look at how whichfork is
initialised early on in the xfs_bmapi_allocate() function, you'll
see it calls this function:

static inline int xfs_bmapi_whichfork(uint32_t bmapi_flags)
{
        if (bmapi_flags & XFS_BMAPI_COWFORK)
                return XFS_COW_FORK;
        else if (bmapi_flags & XFS_BMAPI_ATTRFORK)
                return XFS_ATTR_FORK;
        return XFS_DATA_FORK;
}

A value of 2 (XFS_COW_FORK) is definitely a valid value for
whichfork to have. Indeed, the line of code after the fix checks if
whichfork == XFS_COW_FORK, indicating that such a value is expected
and should be handled correctly.

However, this patch will result in rejecting any request to allocate
blocks in the XFS_COW_FORK. This will fail any COW operation we try
to perform with -EINVAL. i.e. overwrites after a reflink copy will
fail.

This sort of regression would be picked up very quickly by fstests.
Hence it is important that any change - even simple changes - are
regression tested before they are proposed for review and merge....

-Dave.

-- 
Dave Chinner
david@fromorbit.com
