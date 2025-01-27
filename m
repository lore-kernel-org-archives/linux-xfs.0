Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E5F55887
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 20:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738009158; cv=none; b=KyNHiLKepmeo0C/vYMJWv3u4gMPbIAT45GF+15UJunWGX5blKTviwN41ZAbluBO+L+HK7WNzF/uX3R2rAptyEO9JaTSyJIU1YFHKWwD2y1T1Jpt6SqY6wROc/JVSeBaJdvbbRcmLdwjl/+mwXijWnMaAEXZyMOXjgzxaLdWu74A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738009158; c=relaxed/simple;
	bh=FDkaA9lWqCe3vW28bpeEIRlUrNoFQoVdSrvtUF9r4gw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R2+x9esybvpxHeSP2FV/foP+gp4Pk4K7VCd7R2IoB2VJ6wpEa9COfVpguc0VJwHW+k0BTLbFzhPPnTJb47mib4Z/xYFZ+km3U0meCEyXT8nB9URwgDPZ18AzjN4XTlGPtyWOaoVaeuMYTtGaDGleb4hSPZW4V/hdVfewiIlj/aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=uTwC51Dg; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="uTwC51Dg"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2167141dfa1so86532965ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 12:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738009155; x=1738613955; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DLXSe9bd1YyYFGUEbHiR1SYedwEh5gFVIduEyseql4Q=;
        b=uTwC51DgdISqHAUitmUTZKWHO8ZVnfNlhaVLVoMTeIKvcVNtJI1CieHBnRfGyEavNz
         tfRkqYxUB3TiWyh3nYcOH0fsNqi8wJmGWfBCm059hSZdphaFuLw/T95a9bPI4YNzmFBu
         PWb3wGPybJfVnjLmRR6y1ok1rzdWDuYDa8x6eCGLPiibzi97Nc+xorwTEFWlR9oCGtDL
         cF2hMy0zG9NF/8oa57KdCuMsqFTVcRy1KLHKikJz8DY7yFFycJvR0qdD6BcDhmBtcIF2
         2Ac5oCDRyivaajAvwv2AwwQKeG9WMINX1i4AdGDiwy/RAL6LBmO7Vd4flsu3t6xSdVDD
         hkhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738009155; x=1738613955;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DLXSe9bd1YyYFGUEbHiR1SYedwEh5gFVIduEyseql4Q=;
        b=irZC8JWDXEx5R3xgXZbFQL1evRhv6dUXa3sYBqXhvwceUNKFbhfR0jM3DE4hUgbqkc
         iQq41HAq+zpRiUnoiNxKxYLtg/UiNtkD/AfxMti9Soe/OIafNGLJC8JrNKQDzoAx7KSP
         pDRwy6zTHio6f1zsqtCvOdH3PcaZGKUvWPpsinx1SaUzqoV2/VAgfyU9MMdo9MAwjVbu
         l6wC/dLs5IMwRj45FJIpCTTQxDFcuijeajed9Ec3Eucwfp3MfYKZH90Oosl5twkWCnKI
         OGM64f/GP/VEZL8T6ORf5e7wLRNxaL3jsn6SPDokKJYiqCd2o1fB6ec5AjaqtpYfbjBo
         laqg==
X-Forwarded-Encrypted: i=1; AJvYcCVkknvilKsA289rzbKIaeA2ipf7oQkFh/cn+akOS2PiYXc27XrfUfZWDgdTquS3CMI1NrGHzC6vzvM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZObj/9s6cpSpmV3yWCiN8UOskvO25kZ3G9JN2G4dVLUr9DjeK
	Ko2i6JLXbet5bB97jLO0ubI6xDCLSDnMQUm6743F9oOq0jVOWIylwKpf1dFkqaI=
X-Gm-Gg: ASbGncuEwnsnkgHf7q9HC89i59egRPu91u7oBvqO63OMv9mfkB4iW+NH4LVXbtUCqMh
	gKSyr/XXuUqtc+L0I30aScPWdRvnpiQKIh+BGIvI85lTUdYF8tXSOo5lHhFEoHehjMadt9tOaYO
	kuY5U6xfHjkV/eiSu3c5AzKMCsriVKkZjSO7NtjQxCmBIwoofuKY3psYqSjJogl+0JpcLxRBhTp
	ejeJB7YanRzzagOjIrcsvkXsr7GIl+sHyF+nm+EM34M6W04KyXP22BdPWF28fXUghDQlQMuZFpm
	Ifn0VA78VY57w+JdfDBaq5APFKkmTbc7OnEsKJPCUCoDYUCgHX4IdBsu
X-Google-Smtp-Source: AGHT+IGa+gI4PYfROBcyoFhX6RhQcH9Tx0oOSn2BgUW/k1/BNZVb/iSiNBkqtP8omV05emRPRQvS5A==
X-Received: by 2002:a17:902:ced2:b0:215:ae61:27ca with SMTP id d9443c01a7336-21dcc57d128mr8348905ad.26.1738009155162;
        Mon, 27 Jan 2025 12:19:15 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da414142asm68027515ad.148.2025.01.27.12.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 12:19:14 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tcVZf-0000000BIhl-2UYH;
	Tue, 28 Jan 2025 07:19:11 +1100
Date: Tue, 28 Jan 2025 07:19:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, djwong@kernel.org, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, "Lai, Yi" <yi1.lai@linux.intel.com>
Subject: Re: [PATCH] xfs: remove xfs_buf_cache.bc_lock
Message-ID: <Z5fqPyqU4KTSMGyh@dread.disaster.area>
References: <20250127150539.601009-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127150539.601009-1-hch@lst.de>

On Mon, Jan 27, 2025 at 04:05:39PM +0100, Christoph Hellwig wrote:
> xfs_buf_cache.bc_lock serializes adding buffers to and removing them from
> the hashtable.  But as the rhashtable code already uses fine grained
> internal locking for inserts and removals the extra protection isn't
> actually required.
> 
> It also happens to fix a lock order inversion vs b_lock added by the
> recent lookup race fix.
> 
> Fixes: ee10f6fcdb96 ("xfs: fix buffer lookup vs release race")
> Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 20 ++++++++------------
>  fs/xfs/xfs_buf.h |  1 -
>  2 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index d1d4a0a22e13..1fffa2990bd9 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -41,8 +41,7 @@ struct kmem_cache *xfs_buf_cache;
>   *
>   * xfs_buf_rele:
>   *	b_lock
> - *	  pag_buf_lock
> - *	    lru_lock
> + *	  lru_lock
>   *
>   * xfs_buftarg_drain_rele
>   *	lru_lock
> @@ -502,7 +501,6 @@ int
>  xfs_buf_cache_init(
>  	struct xfs_buf_cache	*bch)
>  {
> -	spin_lock_init(&bch->bc_lock);
>  	return rhashtable_init(&bch->bc_hash, &xfs_buf_hash_params);
>  }
>  
> @@ -652,17 +650,20 @@ xfs_buf_find_insert(
>  	if (error)
>  		goto out_free_buf;
>  
> -	spin_lock(&bch->bc_lock);
> +	/* The new buffer keeps the perag reference until it is freed. */
> +	new_bp->b_pag = pag;
> +
> +	rcu_read_lock();
>  	bp = rhashtable_lookup_get_insert_fast(&bch->bc_hash,
>  			&new_bp->b_rhash_head, xfs_buf_hash_params);
>  	if (IS_ERR(bp)) {
> +		rcu_read_unlock();
>  		error = PTR_ERR(bp);
> -		spin_unlock(&bch->bc_lock);
>  		goto out_free_buf;
>  	}
>  	if (bp && xfs_buf_try_hold(bp)) {
>  		/* found an existing buffer */
> -		spin_unlock(&bch->bc_lock);
> +		rcu_read_unlock();
>  		error = xfs_buf_find_lock(bp, flags);
>  		if (error)
>  			xfs_buf_rele(bp);

Ok, so now we can get racing inserts, which means this can find
the buffer that has just been inserted by another thread in this
same function. Or, indeed, and xfs_buf_lookup() call. What prevents
those racing tasks from using this buffer before the task that
inserted it can use it?

I think that the the buffer lock being initialised to "held" and
b_hold being initialised to 1 make this all work correctly, but
comments that explicitly spell out why RCU inserts are safe
(both in xfs_buf_alloc() for the init values and here) would be
appreciated.

> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 7e73663c5d4a..3b4ed42e11c0 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -80,7 +80,6 @@ typedef unsigned int xfs_buf_flags_t;
>  #define XFS_BSTATE_IN_FLIGHT	 (1 << 1)	/* I/O in flight */
>  
>  struct xfs_buf_cache {
> -	spinlock_t		bc_lock;
>  	struct rhashtable	bc_hash;
>  };

At this point, the struct xfs_buf_cache structure can go away,
right?  (separate patch and all that...)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
