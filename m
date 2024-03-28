Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAEF13173E
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 22:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711663489; cv=none; b=JYq/GTtlJJZzvatGjeFgkC0NCIzLR7/mUBNTLh7Xa+8ntEJaVkAMKF+jH3+16hEoyVGpm9ivxP4b1iejCn9sEvz9nI1StPiHjtFm/qfNDXVAXwUEJ7AUcuwZ4puwrUFJnCEEKU1WLIZnTmwcHGdLGkzGg2Ma/TnVze5xM0/M1GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711663489; c=relaxed/simple;
	bh=qwdbnhU2IDh168yVkDnQiAieveb+ZK1n1sjeGXSPuBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FizNrZ9AqPVUZ62HuSz9IDMg6LdJygiEQyMKZs3QmO7lBGlxy2fXrcCxtbmOtkKWAFUFV1TI/nB8SHuCW563/AXZZX9EySfP9HT1404qdhVIXog2P5VIy7mA2V5t5utWU4SEpI0De4ZwUgODfTibPsrl7e2gYXCLM32F5WkO4JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=hLYfW/k9; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="hLYfW/k9"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3688b72d08cso4661805ab.0
        for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 15:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1711663486; x=1712268286; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TUtQWGjfVeZSFumuYcDz7mi4EFybqChxCkM+ocMfTpI=;
        b=hLYfW/k9emSgvDtg6Vm4Alpcv2zEP3e9cQkotoqpPZm6mtPMS4bE8dVWhdI8GkYELF
         jouhuo6mHnJOX3PdPz9iJ4kfkELn/wBxXoWCvSXbiOQXPYYeuZ5myb/QP6ikhDxNY8w8
         0Bi7m1p/DeM3AoGUkAdAZ4FbHfcsIE80l61cVmehHTDQMxUYLRa8RNxFcioNGkPzRk1z
         TvuhXBLl0vp087FD0baFEe8zif8J+M7UZFvHTzQtD72D2qjWtqXFCHtGIYO6tA0fJt3K
         rQasRI7hRkdo/vVd8OaqQtSdVqxSlJJwq7y2Mv8OKCq8GarP1xc1qy3k3xMo4/VE6whS
         uKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711663486; x=1712268286;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TUtQWGjfVeZSFumuYcDz7mi4EFybqChxCkM+ocMfTpI=;
        b=pefPy7Jhjj77msjAKww+T7RMXMEPGYQANi4Hm5yW7TCbUAzPbHVEDGwayFjF1VUF91
         9qjLels3RVm7JOqeVrPBaNSGAFrrc8OUOT4Xu+UMQDDXwivlamXQExmfrm3tZM8Lrld/
         l4od4HDXTJ7JDzkFi21+AQR3naIZ/pZ7W9Jv7W9Gs9t+0qq7641/V7rG/hK+5ovwUe9a
         DP4jYSl/MhuGcnU5O4uYdTg/hQpE0yYtdxqtqUnXx3AEyO+PaE2mDoi1Z7qaYkbAjNDJ
         l3uRfAvaz4EDrwRllKAwdTsu6FbVA6ZdamEjnvEiA8J38PwJApIXyqYZ7nbshVtdJmoK
         nqtA==
X-Forwarded-Encrypted: i=1; AJvYcCWnQoyYePXosxQhN46PtDbQ0FzT16m5TtqfP0kU+1GFwXx+ggyC2E2B0+PdUgJMPbH8oGxHcwYolg+EdaepDHONPIQcD1pRHtPb
X-Gm-Message-State: AOJu0YxSks4jE1CBCl2QhtnHsrOel3qiK6ARmqMCtn2HUoh+fPYBU/xw
	w99UivzRiVMGfF1FsJ5SsO8ip0X4FQBe9ACCobvOkayZOdKJEZ2ipM8f31RK4bw=
X-Google-Smtp-Source: AGHT+IFvclNDmqAAyJ8kZ2YnPD2sG1CdcW1cZXRvU2FcWxZHpS1dGvbJAD2/DAB9nVCvIbkFRmdqqA==
X-Received: by 2002:a05:6e02:3092:b0:368:a502:14e3 with SMTP id bf18-20020a056e02309200b00368a50214e3mr504551ilb.21.1711663486280;
        Thu, 28 Mar 2024 15:04:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id bv6-20020a632e06000000b005ce998b9391sm1770939pgb.67.2024.03.28.15.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 15:04:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rpxrX-00DYKx-0h;
	Fri, 29 Mar 2024 09:04:43 +1100
Date: Fri, 29 Mar 2024 09:04:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: simplify iext overflow checking and upgrade
Message-ID: <ZgXpewa/XiT7w4wY@dread.disaster.area>
References: <20240328070256.2918605-1-hch@lst.de>
 <20240328070256.2918605-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328070256.2918605-5-hch@lst.de>

On Thu, Mar 28, 2024 at 08:02:54AM +0100, Christoph Hellwig wrote:
> Currently the calls to xfs_iext_count_may_overflow and
> xfs_iext_count_upgrade are always paired.  Merge them into a single
> function to simplify the callers and the actual check and upgrade
> logic itself.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.c       |  5 +--
>  fs/xfs/libxfs/xfs_bmap.c       |  5 +--
>  fs/xfs/libxfs/xfs_inode_fork.c | 62 ++++++++++++++++------------------
>  fs/xfs/libxfs/xfs_inode_fork.h |  4 +--
>  fs/xfs/xfs_bmap_item.c         |  4 +--
>  fs/xfs/xfs_bmap_util.c         | 24 +++----------
>  fs/xfs/xfs_dquot.c             |  5 +--
>  fs/xfs/xfs_iomap.c             |  9 ++---
>  fs/xfs/xfs_reflink.c           |  9 ++---
>  fs/xfs/xfs_rtalloc.c           |  5 +--
>  10 files changed, 44 insertions(+), 88 deletions(-)

....

> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 7d660a9739090a..235c41eca5edd7 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -765,53 +765,49 @@ xfs_ifork_verify_local_attr(
>  	return 0;
>  }
>  
> +/*
> + * Check if the inode fork supports adding nr_to_add more extents.
> + *
> + * If it doesn't but we can upgrade it to large extent counters, do the upgrade.
> + * If we can't upgrade or are already using big counters but still can't fit the
> + * additional extents, return -EFBIG.
> + */
>  int
> -xfs_iext_count_may_overflow(
> +xfs_iext_count_upgrade(
> +	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	int			whichfork,
> -	int			nr_to_add)
> +	uint			nr_to_add)
>  {
> +	struct xfs_mount	*mp = ip->i_mount;
> +	bool			has_large =
> +		xfs_inode_has_large_extent_counts(ip);
>  	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
>  	uint64_t		max_exts;
>  	uint64_t		nr_exts;
>  
> +	ASSERT(nr_to_add <= XFS_MAX_EXTCNT_UPGRADE_NR);
> +
>  	if (whichfork == XFS_COW_FORK)
>  		return 0;
>  
> -	max_exts = xfs_iext_max_nextents(xfs_inode_has_large_extent_counts(ip),
> -				whichfork);
> -
> -	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> -		max_exts = 10;
> -
>  	nr_exts = ifp->if_nextents + nr_to_add;
> -	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
> +	if (nr_exts < ifp->if_nextents) {
> +		/* no point in upgrading if if_nextents overflows */
>  		return -EFBIG;
> +	}
>  
> -	return 0;
> -}
> -
> -/*
> - * Upgrade this inode's extent counter fields to be able to handle a potential
> - * increase in the extent count by nr_to_add.  Normally this is the same
> - * quantity that caused xfs_iext_count_may_overflow() to return -EFBIG.
> - */
> -int
> -xfs_iext_count_upgrade(
> -	struct xfs_trans	*tp,
> -	struct xfs_inode	*ip,
> -	uint			nr_to_add)
> -{
> -	ASSERT(nr_to_add <= XFS_MAX_EXTCNT_UPGRADE_NR);
> -
> -	if (!xfs_has_large_extent_counts(ip->i_mount) ||
> -	    xfs_inode_has_large_extent_counts(ip) ||
> -	    XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> -		return -EFBIG;
> -
> -	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
> -	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -
> +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> +		max_exts = 10;
> +	else
> +		max_exts = xfs_iext_max_nextents(has_large, whichfork);
> +	if (nr_exts > max_exts) {
> +		if (has_large || !xfs_has_large_extent_counts(mp) ||
> +		    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> +			return -EFBIG;
> +		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
> +		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	}

IIUC, testing the error tag twice won't always give the same result.
I think this will be more reliable, and it self-documents the error
injection case better:

	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS) &&
	    nr_exts > 10))
		return -EFBIG;

	if (nr_exts > xfs_iext_max_nextents(has_large, whichfork)) {
		if (has_large || !xfs_has_large_extent_counts(mp))
			return -EFBIG;
		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
	}
	return 0;

-Dave.
-- 
Dave Chinner
david@fromorbit.com
