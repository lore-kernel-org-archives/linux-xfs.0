Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2ED038382
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2024 20:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706734494; cv=none; b=A02epLQ22/eJu7Oq5Wx6Wtk3KXrmB8Ox1J8xXta+9fe9KiU9pA2V2HDUP8tHpVahuR0m5j2ArdKDyBLS+skEB4NUL9u/cGAx3VrmuU485PXISZNRiBJ2HGsDVNmdrAy0LI6Mzi/sO1JCQrLxfmNXqC8fXgeEHMxjAILCFvoEXkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706734494; c=relaxed/simple;
	bh=H5DnkfQGNOz6GamJMFEzRhXjZIQ8SlIv4ZB51qj7/Os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vc5InPmCr5gqbCOzwjem4krpr216QBjm2M4swBp9TtmZGG5YXrR7Yr5NSE+b23IDJiOSsGlZxdi5iGdRALPapMnHmWQxZj6PqfnvzanGjeJAwW14yb7OqzkbzVRPgGQU1tqIS38xtBKlGn/oCRV8pe7XuauirB4KWN0s85gEsik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=o/0S3BHb; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="o/0S3BHb"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5c229dabbb6so162969a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2024 12:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1706734492; x=1707339292; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MkVM4g5f5NoUF4lp3lmazvI9savgZJHknskq3tSp4ps=;
        b=o/0S3BHbmHkQr9vXEOAesCITal/h+KQigJLQAkROFCDnKwEZRHRFVdnUCk6AsGV78c
         WPaZX7GIqB+8fnrS9LXgj87yglRR76GP62kJjWoq9S2VcO+8triuSuj5KZ4TFzRkJLxG
         T14WSj/GKE5Nx4edtISFK2YG1LYJ6oa/PQ9E4ElENSDmDg8tmPg1FlYThjJryPRwMle5
         TjVS2pI5NPUpwXZYf8cfD2zfR2fw6cpqJBSyxpL4GaO+qGP9I3SocgRDx+am8dt1gtfT
         9sbgjWYZGFYOiZfWFl7orDTgODLR06Nx9tK+qmO/6MXs8IjElimx8aHj7Pw6jnCGIBf3
         ggBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706734492; x=1707339292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MkVM4g5f5NoUF4lp3lmazvI9savgZJHknskq3tSp4ps=;
        b=TWAqruyft0FfaGh6KKXP9Rmeb5D6i5Q6dSULDr5+jxme93FeYoD32xYqy3lVH9s/PN
         b4VWf4XJvxiqtkiRBTZim224i2OjYxTR6Toga9+U/o7JrXQhw9GUwQLFQOdodNFTj82q
         /XL+Fm9/l4zMJWA//hinpJFhf37fp0N4imSG5YeOwUvU555JfCHCeP1X6G84w6c1DuL0
         3Ki5CBXigC5q2zBOy1S5Qm/HUVOeKbqC98s/UKuLwS+OZr0Wxpppvt6gw009kdPSSCyq
         CMF1hOqflOBtZfyVtKnA++o3ITl5rJ4jvKbeHWlgWuR9cqw/CaHYR1nhS7No2merMqpM
         nLzw==
X-Gm-Message-State: AOJu0YxXkZbGQqcZjzoolowN3oSBe71ebFxnLIQMZSMPEd8U7zzcZvYs
	z6EBjHAAL4ARxX8mb1iY5OQThTfS5AabXT8onTYu6+zJXq1HokvOym5SkleGvOg=
X-Google-Smtp-Source: AGHT+IGNm77E8xHqZrrhJR2Qo7u6yv0DNd80hrzXtSV7knc3ifYpZj6Z1DuVOk7Ia4zjDHP4pvb7ng==
X-Received: by 2002:a17:90a:e618:b0:295:b31b:2b85 with SMTP id j24-20020a17090ae61800b00295b31b2b85mr2549003pjy.42.1706734492179;
        Wed, 31 Jan 2024 12:54:52 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id l7-20020a17090a150700b0028e821155efsm2114425pja.46.2024.01.31.12.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 12:54:51 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rVHbd-000JWO-1h;
	Thu, 01 Feb 2024 07:54:49 +1100
Date: Thu, 1 Feb 2024 07:54:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanrlinux@gmail.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: disable sparse inode chunk alignment check when
 there is no alignment
Message-ID: <ZbqzmZs++8RVHk0U@dread.disaster.area>
References: <20240131194714.GO1371843@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240131194714.GO1371843@frogsfrogsfrogs>

On Wed, Jan 31, 2024 at 11:47:14AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While testing a 64k-blocksize filesystem, I noticed that xfs/709 fails
> to rebuild the inode btree with a bunch of "Corruption remains"
> messages.  It turns out that when the inode chunk size is smaller than a
> single filesystem block, no block alignments constraints are necessary
> for inode chunk allocations, and sb_spino_align is zero.  Hence we can
> skip the check.

Should sparse inodes even be enabled by mkfs in this case?

Regardless, if sb_spino_align = 0 then xfs_ialloc_setup_geometry()
does:

	igeo->ialloc_min_blks = igeo->ialloc_blks;

And this turns off sparse inode allocation for this situation....

> Fixes: dbfbf3bdf639 ("xfs: repair inode btrees")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/ialloc_repair.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
> index b3f7182dd2f5d..e94f108000825 100644
> --- a/fs/xfs/scrub/ialloc_repair.c
> +++ b/fs/xfs/scrub/ialloc_repair.c
> @@ -369,7 +369,7 @@ xrep_ibt_check_inode_ext(
>  	 * On a sparse inode fs, this cluster could be part of a sparse chunk.
>  	 * Sparse clusters must be aligned to sparse chunk alignment.
>  	 */
> -	if (xfs_has_sparseinodes(mp) &&
> +	if (xfs_has_sparseinodes(mp) && mp->m_sb.sb_spino_align &&
>  	    (!IS_ALIGNED(agbno, mp->m_sb.sb_spino_align) ||
>  	     !IS_ALIGNED(agbno + len, mp->m_sb.sb_spino_align)))
>  		return -EFSCORRUPTED;

... which makes this additional check reasonable.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
