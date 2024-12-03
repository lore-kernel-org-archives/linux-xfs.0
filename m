Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454C7208978
	for <linux-xfs@vger.kernel.org>; Tue,  3 Dec 2024 20:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733258426; cv=none; b=KO1fVgYU5aTGNd51KKyWzLCuWAi5mULFSPmwYheeVEPQonkU1Dm5J0fHgq9dYfeWcloOOGmCV0CHufxWRxHldFln0d+UxlZz78icX1mwYIkUSuRfwpzMqqtM04r4dGwCAdkdJq4b0SYeDR/B3fA/xEtunj9eY8CipUDKurvCbD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733258426; c=relaxed/simple;
	bh=rSeMRzYyG+qr3owWq1fdPRuk1G0UR6sd75t7TH+Te8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i9nQEyOCzojhI7Pa718qVloS0mrKc8b9hEGKh23y+QnwytRdMnqK1zXlpWTERa6IB59jlPGij2m2Mr/+ZGZYssAHGJvX57EooUitsNKc++X8M/tupwivQdtdsXDoGfiyRHx6S4PhQJEj0BVxidVEg8s9Bun79UB2RzRnsGl5/+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=p80H0VL/; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="p80H0VL/"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7251d20e7f2so5997508b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Dec 2024 12:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1733258424; x=1733863224; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gh+WkW3kMcY8GItbOWmb7Albb9UCyz9TXbZGgcVLwPQ=;
        b=p80H0VL/ZHEQCKRlYsIwGZ8v+qDOwaC+6sz2fuVUzIaoWRIs9w2VABkmVIPFVgQyLc
         9k3oaAZCyz5AcaQcTio/j1HyViDbfjfnEIQPArYkJZlQBT5GB6wiNLFUfLY+0Qzxk88E
         JVyqjFuKELVcfeF6jOXlAnuwf+fQOMoEIV1vOWDDKCVneLusHRIwlGZbq72/lO0t6fQs
         WoHxD2rJez0/Of+NAWwJSExKazn8Ii9OFpdaX17pVNv07V5Wvs4I/C2UVMNgCJQuPWto
         VuMWhhxfosATMxRZpQNYaVO8o6irXSeWjgcPYSOMQvJEpKQfaYitdth2pvSu+iO3FbVG
         zVjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733258424; x=1733863224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gh+WkW3kMcY8GItbOWmb7Albb9UCyz9TXbZGgcVLwPQ=;
        b=a5agRkMpuk2G6IPXdoy//eWdy2zDyV5QZRvEZUiGdLRfynMIUDxxJx4hL0olbt9BGQ
         pKEf821D9L547jdRWYWmin+Y9T2dom9n99Z0vx4sYV0uTS7xpKGqPgtxoxv69Y618gDN
         qZdJos44MRgDf28CYhSFxV/SEMPcncjE8/ryfpJqsBKOjix88q0/7RIWoRmjLFD1AjlD
         RBFva5DeEqvEKcTHvduWVrojOlL4VgZ0b7uZooGH8IFsE8UKJeZ424EtB5g9yjgoQ8Hs
         rqlubOaqkU7FM5TS55KtNWXqcTRAiKG4SjFDGPpc8JyzqPmwoULHmoB1GekHFcetd5IN
         zrkw==
X-Forwarded-Encrypted: i=1; AJvYcCVp6W9XjQ5w8wzgFoncpRt4zGEhApCvNxkgCEVxhSjSn488Ir7afMnsicoNaKKfnTt9eBIYEzgA4pY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDS1MUFIH5e2D+u28bDVxki1Jbo+AzUvu+hIJYrIlnd/yEo6Kp
	8HZ4UoElPc9qagYtYM5FeJofBR4CMalE1rfBJ7VXiZmTs596pCUa3OXtWx2hE/lXOozit2kTQY2
	p
X-Gm-Gg: ASbGncvnZ443GI7a8xADTXIXFzAUmTrlYdPqj62qljtO/1Bkp1zq/6ZNRBN77Pny1Ia
	LTEaMcOzUvkjcMEFWEt9VwUL85Y6wil8xKZVSl4nGAtPZocgystNBzvU5L3j9M9W+J7j9L02iGW
	Z+o4rTOqTpGj8msfYcbt+XF4Rv25i/vjk5DMG4ZJsPgFu139Y81Kh5Imy5eWnSP8ArSHO8GAR3s
	M6To1ZDyERqGPHgcHqAztthhABhLFAPkiHZ0rE74O6JjX5O6GqmDOhKFfw5fsW2947lPZBijBQp
	06fv4sRLiQcb9SNDVkM2NAK7UA==
X-Google-Smtp-Source: AGHT+IHu1DUrZWKsZf2sxYqF3mSf+fZSaDb0CZwptZ+kh51z1iAIA1GqYtP7epMmpdosj0IIbBaGhg==
X-Received: by 2002:a05:6a00:3998:b0:71e:5e04:be9b with SMTP id d2e1a72fcca58-7257fa70dc6mr4903784b3a.12.1733258424461;
        Tue, 03 Dec 2024 12:40:24 -0800 (PST)
Received: from dread.disaster.area (pa49-180-121-96.pa.nsw.optusnet.com.au. [49.180.121.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725417614f5sm10922852b3a.7.2024.12.03.12.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 12:40:23 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tIZgy-00000006GzU-1Z32;
	Wed, 04 Dec 2024 07:40:20 +1100
Date: Wed, 4 Dec 2024 07:40:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jinliang Zheng <alexjlzheng@gmail.com>
Cc: cem@kernel.org, djwong@kernel.org, hch@infradead.org,
	dchinner@redhat.com, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [RESEND PATCH v2] xfs: fix the entry condition of exact EOF
 block allocation optimization
Message-ID: <Z09stGvgxKV91XfX@dread.disaster.area>
References: <20241130111132.1359138-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241130111132.1359138-1-alexjlzheng@tencent.com>

On Sat, Nov 30, 2024 at 07:11:32PM +0800, Jinliang Zheng wrote:
> When we call create(), lseek() and write() sequentially, offset != 0
> cannot be used as a judgment condition for whether the file already
> has extents.
> 
> Furthermore, when xfs_bmap_adjacent() has not given a better blkno,
> it is not necessary to use exact EOF block allocation.
> 
> Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> ---
> Changelog:
> - V2: Fix the entry condition
> - V1: https://lore.kernel.org/linux-xfs/ZyFJm7xg7Msd6eVr@dread.disaster.area/T/#t
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 36dd08d13293..c1e5372b6b2e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3531,12 +3531,14 @@ xfs_bmap_btalloc_at_eof(
>  	int			error;
>  
>  	/*
> -	 * If there are already extents in the file, try an exact EOF block
> -	 * allocation to extend the file as a contiguous extent. If that fails,
> -	 * or it's the first allocation in a file, just try for a stripe aligned
> -	 * allocation.
> +	 * If there are already extents in the file, and xfs_bmap_adjacent() has
> +	 * given a better blkno, try an exact EOF block allocation to extend the
> +	 * file as a contiguous extent. If that fails, or it's the first
> +	 * allocation in a file, just try for a stripe aligned allocation.
>  	 */
> -	if (ap->offset) {
> +	if (ap->prev.br_startoff != NULLFILEOFF &&
> +	     !isnullstartblock(ap->prev.br_startblock) &&
> +	     xfs_bmap_adjacent_valid(ap, ap->blkno, ap->prev.br_startblock)) {

There's no need for calling xfs_bmap_adjacent_valid() here -
we know that ap->blkno is valid because the
bounds checking has already been done by xfs_bmap_adjacent().

Actually, for another patch, the bounds checking in
xfs_bmap_adjacent_valid() is incorrect. What happens if the last AG
is a runt? i.e. it open codes xfs_verify_fsbno() and gets it wrong.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
