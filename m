Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2D62574B
	for <linux-xfs@vger.kernel.org>; Wed, 14 Feb 2024 23:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707952275; cv=none; b=DCAqHUhJPI+qJga6uNGQK2JdZpZZEWoey39z+9qB9VvtQOI9WXiTGxYFINSgLbMd/VMvUUIk7kAVD3w/FLJdbtoQe0d265lGlCjekx2hYVpE1qb8hkzH5n3mimp4I+LGyyaZWkO9gvrjs0CLZGDfwpqCWjSP8YoBUTF2gl6ObWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707952275; c=relaxed/simple;
	bh=uPHnXkfHIlk0I3QS58jubPixVmi9sQiQzUc5UrvbLMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lIx6b55u+me6wwlh6QMaYM9XYxVmSFxGsu9aLLfdDxL2B30B3eHiBJfN+eum4mhoELzaZbLKJXkhmXfOoRImZ9isEFQjWGvQjBsHS7k8t5oF/UfYMLWxp5DNV6omfXVDIR5ychGhiPKf/ALnh4F59oQLRu1Se1WST8G8HINABSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=IZm68w6c; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="IZm68w6c"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5d8b887bb0cso248537a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 14 Feb 2024 15:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1707952273; x=1708557073; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BTHVUDbtBvZUQg8f8LBwdNiUB6nPHCiGfZSsATLJSXE=;
        b=IZm68w6cdBkd5HrjHBcnKjr9OtO8WrvuupHVm+sV+oCuyh6FGngpBNQeuxPH2gxVq5
         +GtLCWhvu4upUUcbIDwCx86jm0DOav2vMCFpbJkr+FoQqSY1RGUH9Tp49ZhI2ptbEGDF
         hTRE5PquiId8Cy8zIW+B6bE/YfvFqK03eom35gcezYogGjc7o3coTep2J7+Omt5TBGlC
         PRkD0+Mkj1Z5reR4T14vjc7eGvy6NpgRhndN8QFzZep1hL6QaF3IQqWULf9bv3GzYrV0
         mhcnQMsHqyZ5RVlC6mL+w8IA90dk92G0JOXqGFuHC3F3yBYgOsXBfJLlQWazn1ixcTzb
         naXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707952273; x=1708557073;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BTHVUDbtBvZUQg8f8LBwdNiUB6nPHCiGfZSsATLJSXE=;
        b=YOXzuZMVTsOSCBGkG5HfGRJxucn9ETJAGPfm7PKcb3T1NcuYBAPIyxCBqHpvQiU4xC
         BXN1qmImEECJMU1pmHjn/TOTOBa+TTusW37Qe771S4Na9GgBIrkJyNsiR9/QloafXrR+
         sjNU5HxDFtuk7k4Pah680taN+BiB/HEWlhJyD8dj1l4LYB8qooDAJ0M09lmTfVDhubql
         oiZTZ7/0Nqo/zxzH8539QmQUvaEgKpYWQ8BxW3o3WXJ3Y3JzssBcLqbMKGlRd2gXhju8
         PBxZaB71jEcqdK/lXjrhnBwTSF/kSrI7TaGOhNf9h0QoHzeCEyUO1asCSUFSN3fYcYI+
         YQSg==
X-Forwarded-Encrypted: i=1; AJvYcCW8GWE/rKhtIYjSniGzDPWs1B1T/oue4WVpYLY8Mv3fr7cb7nlgdeIudQVqLRPgXsr2SZRQCmjc2qJfbcZkeMv4x4K0Uqf518lc
X-Gm-Message-State: AOJu0Yw0e93wXtSeVUk2SFASaogkM1u16hNIQxZ7RJsseSz7IvnCunAz
	ERiaShGKQRvVtT8o70WVtldf8zgcr7p+m7NqtpK07a6D9oE95wN8fhbnAuW+RpacqqqnePB3Fli
	L
X-Google-Smtp-Source: AGHT+IGqtOudqIcEivR+68Kcb0n8h47VimP7JsgUIWbDK8LXD3cIJTdQa7Pz5fKWL8k8DEZTpxlKoQ==
X-Received: by 2002:a05:6a20:87a8:b0:19e:ba40:83e9 with SMTP id g40-20020a056a2087a800b0019eba4083e9mr281639pzf.17.1707952272956;
        Wed, 14 Feb 2024 15:11:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXBHd/RTFMXrlYJM2FD0734JbFjpWWQ43q5vqxwRb7Hdihalj8nPaLjtROUGTSSiCvhSpOZgJyDOAo0bYsXw8Z6JJItW8mtkgYD
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id y26-20020aa793da000000b006e04c3b3b5asm10029429pff.175.2024.02.14.15.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 15:11:12 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1raOPF-006aWa-2h;
	Thu, 15 Feb 2024 10:11:09 +1100
Date: Thu, 15 Feb 2024 10:11:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/27] repair: refactor the BLKMAP_NEXTS_MAX check
Message-ID: <Zc1IjZm8sd2dLSBV@dread.disaster.area>
References: <20240129073215.108519-1-hch@lst.de>
 <20240129073215.108519-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240129073215.108519-4-hch@lst.de>

On Mon, Jan 29, 2024 at 08:31:51AM +0100, Christoph Hellwig wrote:
> Check the 32-bit limits using sizeof instead of cpp ifdefs so that we
> can get rid of BITS_PER_LONG.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  repair/bmap.c | 23 +++++++++++++++--------
>  repair/bmap.h | 13 -------------
>  2 files changed, 15 insertions(+), 21 deletions(-)
> 
> diff --git a/repair/bmap.c b/repair/bmap.c
> index cd1a8b07b..d1b2faaec 100644
> --- a/repair/bmap.c
> +++ b/repair/bmap.c
> @@ -22,6 +22,15 @@
>  pthread_key_t	dblkmap_key;
>  pthread_key_t	ablkmap_key;
>  
> +/*
> + * For 32 bit platforms, we are limited to extent arrays of 2^31 bytes, which
> + * limits the number of extents in an inode we can check. If we don't limit the
> + * valid range, we can overflow the BLKMAP_SIZE() calculation and allocate less
> + * memory than we think we needed, and hence walk off the end of the array and
> + * corrupt memory.
> + */
> +#define BLKMAP_NEXTS32_MAX	((INT_MAX / sizeof(bmap_ext_t)) - 1)
> +
>  blkmap_t *
>  blkmap_alloc(
>  	xfs_extnum_t	nex,
> @@ -35,8 +44,7 @@ blkmap_alloc(
>  	if (nex < 1)
>  		nex = 1;
>  
> -#if (BITS_PER_LONG == 32)	/* on 64-bit platforms this is never true */
> -	if (nex > BLKMAP_NEXTS_MAX) {
> +	if (sizeof(long) == 32 && nex > BLKMAP_NEXTS32_MAX) {

That's a really, really big long. sizeof(long) = 4, perhaps?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
