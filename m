Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31F854F94
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 23:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708384877; cv=none; b=CFOGD+xKjH6yQ8zD4H/Kd6FivYYGeXr5OoLYK/G2y27XlD4wJQQYqnCk8UM1cfMdnhaMxxXBMkdr/KHNtvqg3Fi1pZC9waIlm3AY9n2d+U7ylGQkXc5LsLIf18fFd/RvPI1RgU8KsrSKefW/1U0Nz4KFJL/uZyQMEnx7Mz5ooHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708384877; c=relaxed/simple;
	bh=qIcgTnY1Aj5JDkfgs3MVTkvb10ycrkRgzk5sw87lTb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8Xa166mSicvdzEtxs2RFhgdbvgNNVsDrU+8tdplFu7kLUydIB86zArplsA5Xr2r+qdK0bONFX9re1xD+jeSD3BmypXBYeAszsQNvfCFPJ6CDxrUREzuUIJMBLXYStvikogLV+ypT3f1YnqTqDAQwHj4BnU1wb2Ri9INCtpgfIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=AAYRW9fD; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="AAYRW9fD"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d51ba18e1bso49563775ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 15:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708384875; x=1708989675; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Db+B/mE/5XVPi7lmppf781E0GXpXORoq+/YH4l6bz5E=;
        b=AAYRW9fDo7WsEq6EkExEGEWEYMzPVqeavQ7OBvLjs5zSbVK+g4y7jfile1MhEoNDpu
         RU46KznC1Z703cbJXlfQ4xXmpqorM/OoszK2ssNoL8w2bjuypbOi6vRmU5E4W+MYnFpD
         1XUo6UinDlTjyzhtbbaPmotdEJD1FBIMBzykDMK0fZyzzYdPv8lJFHyTKDpuAPW7UXzE
         hu8t/uzcVkCs3sjIkndY8IcQ5BdsWJtKt/ecTAzIu2HNro0cd5HgYE1/tZ6ANpRYOhg3
         uJ2MbvYxaIQRR5xjYqMunAYxiSoifBKrB4Y1VkrPC83uYIJVX8DpRlcHqDwYC+b3QffP
         KCkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708384875; x=1708989675;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Db+B/mE/5XVPi7lmppf781E0GXpXORoq+/YH4l6bz5E=;
        b=UPP9cKJUNR95lEoLs0Ku0EzuHMAEFxaajCw9K9T8eH/ifsRbnofCAf3+m5z0bLpj41
         DsRejTcXyhzTV+wS2uII3WNa+yZ9GhpISMjQog3aUb8wdEikrvwPTH0+M7obn4RP/P4v
         RG8Mw2p8gIehgzt9erWxM4V7NUm6RLhWEKY33U8QLQwGoYlXxmX+K6rCHB4/Bv6O3Ytf
         yUIq1bfsHy0CtDHgJvBTmTAm25uiXBJTVe4WL7GKOy7YsZQCzHP5CrfrwQkS+ItniQ2X
         WJyMXMA/9+wWz7dIo8GP3Bc6JT54pKYXjibS6MDSVy2j+XSnWgeuLMKuBziwaduyqPJb
         sdww==
X-Forwarded-Encrypted: i=1; AJvYcCVWpkk1lJ0ppyYOIWyK/G8beoxfbIXpvHrHqX8/4thhbvCIL9ZouRIC4+Y3QT8ndqRyrl6hC03zfQ3WJqdKdl+dmakdsXUhVsxa
X-Gm-Message-State: AOJu0YyOj3lS7Pa6iL9APVRnHs3UDp5zAwDbfezfzr29GmkAI1kWbm+I
	Dt024utlIyRUZ6fiq0uqrCJOYXuWRHVWfF5m34JV4tKVBtmwKX3wo3ThEu8Hx0yLtnue8Q4oZeL
	K
X-Google-Smtp-Source: AGHT+IH7bBnZxBZck3qE0sDEbm1fL4S3aPygaq6TtcZBvwXk2aWAgHy3HITCCd5OnEXKX/OCdN8nQg==
X-Received: by 2002:a17:902:da89:b0:1db:e7a7:63f4 with SMTP id j9-20020a170902da8900b001dbe7a763f4mr7501920plx.19.1708384875056;
        Mon, 19 Feb 2024 15:21:15 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id v3-20020a170902d08300b001db6c3a192bsm5017292plv.26.2024.02.19.15.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 15:21:14 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rcCwi-008ou1-18;
	Tue, 20 Feb 2024 10:21:12 +1100
Date: Tue, 20 Feb 2024 10:21:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: split xfs_mod_freecounter
Message-ID: <ZdPiaP+tApjr4K+M@dread.disaster.area>
References: <20240219063450.3032254-1-hch@lst.de>
 <20240219063450.3032254-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219063450.3032254-4-hch@lst.de>

On Mon, Feb 19, 2024 at 07:34:44AM +0100, Christoph Hellwig wrote:
> xfs_mod_freecounter has two entirely separate code paths for adding or
> subtracting from the free counters.  Only the subtract case looks at the
> rsvd flag and can return an error.
> 
> Split xfs_mod_freecounter into separate helpers for subtracting or
> adding the freecounter, and remove all the impossible to reach error
> handling for the addition case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

.....

> @@ -593,12 +593,10 @@ xfs_trans_unreserve_and_mod_sb(
>  	struct xfs_trans	*tp)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
>  	int64_t			blkdelta = 0;
>  	int64_t			rtxdelta = 0;
>  	int64_t			idelta = 0;
>  	int64_t			ifreedelta = 0;
> -	int			error;
>  
>  	/* calculate deltas */
>  	if (tp->t_blk_res > 0)
> @@ -621,10 +619,8 @@ xfs_trans_unreserve_and_mod_sb(
>  	}
>  
>  	/* apply the per-cpu counters */
> -	if (blkdelta) {
> -		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
> -		ASSERT(!error);
> -	}
> +	if (blkdelta)
> +		xfs_add_fdblocks(mp, blkdelta);
>  
>  	if (idelta)
>  		percpu_counter_add_batch(&mp->m_icount, idelta,
> @@ -633,10 +629,8 @@ xfs_trans_unreserve_and_mod_sb(
>  	if (ifreedelta)
>  		percpu_counter_add(&mp->m_ifree, ifreedelta);
>  
> -	if (rtxdelta) {
> -		error = xfs_mod_frextents(mp, rtxdelta);
> -		ASSERT(!error);
> -	}
> +	if (rtxdelta)
> +		xfs_add_frextents(mp, rtxdelta);
>  
>  	if (!(tp->t_flags & XFS_TRANS_SB_DIRTY))
>  		return;

I don't think these hunks are correct. blkdelta and rtxdelta can be
negative - they are int64_t, and they are set via
xfs_trans_mod_sb(). e.g. in xfs_ag_resv_alloc_extent() we do:

	case XFS_AG_RESV_NONE:
                field = args->wasdel ? XFS_TRANS_SB_RES_FDBLOCKS :
                                       XFS_TRANS_SB_FDBLOCKS;
                xfs_trans_mod_sb(args->tp, field, -(int64_t)args->len);
                return;
        }

Which passes a negative delta to xfs_trans_mod_sb() and adds it to
tp->t_fdblocks_delta. So that field can hold a negative number, and
now we pass a negative int64_t to xfs_add_fdblocks() as an unsigned
uint64_t.....

While it might kinda work because of implicit overflow behaviour,
it won't account allow for that block usage to correctly account
for the reserve pool usage that it should have accounted for near
ENOSPC....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
