Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9762512D1F6
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 23:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715298034; cv=none; b=YrOBzt3L2QReg/WkFwa7+XPUwQyMXRUCWHoNaTD5sYowDYbMtZYrXEwhW1m1nQFgaF4I5ohMj/SI2j/bhCz1VlTUa5VWp9h1Kim34EQWJnFH1dfmWMIhDJSB5ApegcyPEYnNcAQoK2s4Ro92H08lQkxNwjXaSHkpxiAYUA8ZI/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715298034; c=relaxed/simple;
	bh=l3QxiBqlvY7j9wljVG9Tc7t7Lkaf+nos6syHpA/YIjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d2s5blr2vYsafOs2oJa629vwvYqyjVT6bf5ZfZAGUkR7S5C9/q7cfnvK39YjRrbBXTjbqv1I03HUxGHqLMeq34hCfcBlRh5tamOBy1pSvIiWG9FfsEi8kTr0Dmbx8TFGnGtAtfbqTWegGLImA9mBRU2SniZgpGXstBivr/drAdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=m6r62sR7; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="m6r62sR7"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6f453d2c5a1so1378385b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 May 2024 16:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1715298032; x=1715902832; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TumGwD21CXpwquRMa7OnRwmjTE1NYn/U+PKZRtUOBa0=;
        b=m6r62sR7kP5KPd8SJbR4clSNJSteKIzRS4sHFKj81HbMu8KchIEI+Pw1fVSndVRThl
         kEvYnodD2mk31p60b2FdTavNNzUK73WmQmytPNVDu5dk0oNo1XKDnbON+FP+N+kphwos
         xI4X7Hk2JP0Z1HYxSh7v2ZtMyRhlLgYsM3VBYsk2x4KHu2yxRwy4sPMrn4Jfnzt0FgiA
         afv3OV4Y3yUuEXm1TE9JacZzVpx+f5ryNnVNXBkjeINqTCQ7cjN3jsYIrkc5gHIEsMJa
         HHO8lcs78J4hhQ773AkSgmJ5C2TthWkV2O25aO8EBHjoEzvypL9Y3NnMc6hWTCyJ7PKo
         FuDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715298032; x=1715902832;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TumGwD21CXpwquRMa7OnRwmjTE1NYn/U+PKZRtUOBa0=;
        b=j5y+ecy+dF9EMHjStc7+0j7E7pUQyCBGkcFa1o+WXSFNX5Jzgk4mVrrPPDvWOgTrLC
         xKBAZw4M4vhuJZuocHlNBHq/j0e2P0bGIYh8s47QguC4BLgLdAnY7mQ0K0eEyIUnqr3t
         4zu1vYuEfOvG9RD7uL/tTs1pcam0XSq00ZXP/9o3nw1sXnqWa+d3qjXOIJ1DC3c1ohe3
         wdYMlADluudy2pfSHTFUJfAwkzimwzAZlZaX/pplHAyn9TSIb7zKxS4cl1ZTdZk/EWWP
         yrfiNtMnr4ji5CZmjwy3eE8BHD+3BnSSFnF93y/WOLqVGR/Wy8835FBd73zq6Q3Q3KYH
         BkIg==
X-Forwarded-Encrypted: i=1; AJvYcCWc6jAFVQEnethlvD9cujSMRmgWtixL3neC8v3x3D8FTwCXXljNa17/KiD912bNQpsZI9JPL8TrHjU+5JW5TUsmTpNkttDW3Zqq
X-Gm-Message-State: AOJu0YzPrVAmzn49gldqggvcDHF2cA8wmZ10lAfwsyYBxEEPgaccr2bW
	7mwk/09sAzpjjxU1KH2YxXC1MoN4WZg0CHA/CcAcjHIlWXuHxBl/DFaR+rO/f3pMZzcNLWx1gbu
	O
X-Google-Smtp-Source: AGHT+IHBwuAHc6fyW5QSj+pzDDfGP04AXmofDgd2guXhw80ysyfb7ktOLvy0IKy4Y9rnMlfE/fGJfA==
X-Received: by 2002:a05:6a21:9181:b0:1af:dba9:2ff8 with SMTP id adf61e73a8af0-1afde130cd6mr1354563637.37.1715298031492;
        Thu, 09 May 2024 16:40:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2a6669dsm1831650b3a.31.2024.05.09.16.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 16:40:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s5DNE-009ZXH-02;
	Fri, 10 May 2024 09:40:28 +1000
Date: Fri, 10 May 2024 09:40:27 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
	hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: Fix xfs_flush_unmap_range() range for RT
Message-ID: <Zj1e66zN0iReurEu@dread.disaster.area>
References: <20240509104057.1197846-1-john.g.garry@oracle.com>
 <20240509104057.1197846-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509104057.1197846-2-john.g.garry@oracle.com>

On Thu, May 09, 2024 at 10:40:56AM +0000, John Garry wrote:
> Currently xfs_flush_unmap_range() does unmap for a full RT extent range,
> which we also want to ensure is clean and idle.
> 
> This code change is originally from Dave Chinner.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index ac2e77ebb54c..5d4aac50cbf5 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -794,14 +794,18 @@ xfs_flush_unmap_range(
>  	xfs_off_t		offset,
>  	xfs_off_t		len)
>  {
> -	struct xfs_mount	*mp = ip->i_mount;
>  	struct inode		*inode = VFS_I(ip);
>  	xfs_off_t		rounding, start, end;
>  	int			error;
>  
> -	rounding = max_t(xfs_off_t, mp->m_sb.sb_blocksize, PAGE_SIZE);
> -	start = round_down(offset, rounding);
> -	end = round_up(offset + len, rounding) - 1;
> +	/*
> +	 * Make sure we extend the flush out to extent alignment
> +	 * boundaries so any extent range overlapping the start/end
> +	 * of the modification we are about to do is clean and idle.
> +	 */
> +	rounding = max_t(xfs_off_t, xfs_inode_alloc_unitsize(ip), PAGE_SIZE);
> +	start = rounddown(offset, rounding);
> +	end = roundup(offset + len, rounding) - 1;

These are 64 bit values, so roundup_64() and rounddown_64().

-Dave.
-- 
Dave Chinner
david@fromorbit.com
