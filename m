Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDE2209669
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 20:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730234786; cv=none; b=Ebhpw0UIE/6oHUuTUsEr5goht7uzj3UjXTBOHzZ7cNjYBRrJKSTNR3ci8Jc7bT8bypbDvhywVBD+H2qysGmijuHmxymZBq6kF0o+L60jVGUVo244TxC3us1KBBa/Qgk+sdxrQGvVcUUpxwFl/x1WxEPJX+xlpNQAjXaigFkDmOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730234786; c=relaxed/simple;
	bh=+CNEOSC0DbQZy4K5AT+A96cCKNBKUjA01x9QZbYl6NM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/Q/XuWyXxx68Hp6bOT8XShJAA4DMJTYjFleKtw0jdRJ9PaGo+69weU/66xX/Rj96IOKBdnoixPRsHUeZQiq4xe2USclMsbkIYdXBIskAnYia0WR4JH4GcTqEzyFnJCVgXWDH7VkOCfZSjSpkJoMiwlE8dGLRsvabpe/gh5oZHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=1P67kI4g; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="1P67kI4g"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2e31af47681so4724514a91.2
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 13:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1730234784; x=1730839584; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wJyMqwPMjPmPi5Jq2cvTimVnEwLKv1Tu1X/bYTSfjaA=;
        b=1P67kI4g12yI2HYvP8MLyi2otzg5J3dFajgHgbJ2dK6HGLCXXuGCQ8FkkGQkj0Y61m
         4lWHjXu2GJLh8ZDHOjpq/8NMdi5cer3pkl6PZRH/2CD/oiwalDlkA+tTUoCqDJDP3HTG
         KtPDx+GhzHdMRg0zVU84A4+hekS+JFprMiSQBAsCZ1fPKfZ/EPklQfolDzAbcVBbUPsr
         CiDGzxKlX5Co15JbWA+tu8uZHfWqeTPzP5okGgp5cDuq+OxeE304oxPCSpO67DQ9B102
         xM84DLPL7AEwGDa/O51K1nzAlht1w/gpxzsj+A8+9R57Ah/bYxliHJttiJvE7YZMbjAs
         rIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730234784; x=1730839584;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wJyMqwPMjPmPi5Jq2cvTimVnEwLKv1Tu1X/bYTSfjaA=;
        b=mrSh12oWMWLhHkWRIZizNMXBd2GDNyG7BEYYTb5mcw7sLTnDRsrWDf0W+O25IPF/b/
         +Y76u3BP92lFyR9m8EfqX6uaA8WRb7GelEjnsILCNYGLZwlsgC6fM3jkDCvN8xM5z1BI
         I2ENtH1r1U2kpM1xVZmHLoiFWk+bJkwoyLVG4FstMWPwcGDTNaYsPuBkOeRE5ci/IB+3
         Jv6EFOo52Rgu9TT+z2WIZ7sHRPG04GGhJ3sb69SsGM53hqbZ447QQc/5yYpbJWvtImLz
         GqgSutdRIVB4n8Vz4ptY2o1nYYpfyBR8WUXrOiMWbAk3D/+/AjS9paWgZBk85zXzC0PJ
         MSfw==
X-Forwarded-Encrypted: i=1; AJvYcCXR5P3WzfBuepSdxnYtE/DjTR/8CPWzlqlnCD6/EYlLV0tGVOTyeZWXum1d0HY5+jPwUc2nWm/iLW4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLDxs9CyL5Z333VeD3ziKhKTN+Oc0C9FKV3dcogkB4tZhI/t0s
	aHdqb/JCY/bG35PVxixIrEN+I5verFBO8Bq4arwxTXLyIWVQiy/wVUXlolkCbhc=
X-Google-Smtp-Source: AGHT+IHGygLgAK8RY5HTrV4sAhs6n9uEfIRrZbFY6Pn4XambynjEgEko/5L4FIMbYTCHNWXvBvBabA==
X-Received: by 2002:a17:90a:f596:b0:2e2:b922:492 with SMTP id 98e67ed59e1d1-2e8f107a5d6mr14046760a91.17.1730234784079;
        Tue, 29 Oct 2024 13:46:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa273c7sm22567a91.24.2024.10.29.13.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 13:46:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t5t6Z-007W26-1K;
	Wed, 30 Oct 2024 07:46:19 +1100
Date: Wed, 30 Oct 2024 07:46:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: alexjlzheng@gmail.com
Cc: cem@kernel.org, djwong@kernel.org, chandanbabu@kernel.org,
	dchinner@redhat.com, zhangjiachen.jaycee@bytedance.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [PATCH] xfs: fix the judgment of whether the file already has
 extents
Message-ID: <ZyFJm7xg7Msd6eVr@dread.disaster.area>
References: <20241026180116.10536-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241026180116.10536-1-alexjlzheng@tencent.com>

On Sun, Oct 27, 2024 at 02:01:16AM +0800, alexjlzheng@gmail.com wrote:
> From: Jinliang Zheng <alexjlzheng@tencent.com>
> 
> When we call create(), lseek() and write() sequentially, offset != 0
> cannot be used as a judgment condition for whether the file already
> has extents.
> 
> This patch uses prev.br_startoff instead of offset != 0.
> 
> Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 36dd08d13293..94e7aeed9e95 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3536,7 +3536,7 @@ xfs_bmap_btalloc_at_eof(
>  	 * or it's the first allocation in a file, just try for a stripe aligned
>  	 * allocation.
>  	 */
> -	if (ap->offset) {
> +	if (ap->prev.br_startoff != NULLFILEOFF) {
>  		xfs_extlen_t	nextminlen = 0;

Makes sense, but the logic is not correct. See xfs_bmap_adjacent()
on how it sets up the ap->blkno target for exact eof bno allocation.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
