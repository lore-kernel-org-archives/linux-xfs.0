Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC0E1547DE
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 21:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741208558; cv=none; b=Q+UCgTuGumbvS5hziIxtUPt7OASPSr3Ihxny5clkrJ0sPggxPLm1nZtm+iliDI0dhpcn/okT9zjrtB8r1o9eT70PgpcXasXukbP79s+n2eY+L3g7LJJ8nhxOUHi3GXn8RZ3NREetOgZrsEbX0XYRlCEfoHXLKxACHJEN1E4e4MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741208558; c=relaxed/simple;
	bh=h6/sca4Shed2i2/8Txg7TSayia74FhgPZ5dOoL5Eqx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KVs8+3xwmZxhNn7NYyWRHsMDrf2of8o8Pq6SBE2EA65LE5Lbxvjm+9xxrv90PVOXv477mqyJPh2ZJYxmEU+SYY90V/40afFj30Z/haFo2Ks6pPB+AgflP6dsJMAuHoN3ywwwPwZ80DBtqlBWJBvt7+d+NkxYNGD1mh46KZ3GOTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=eCDMVfDT; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="eCDMVfDT"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2239aa5da08so72411625ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 05 Mar 2025 13:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741208556; x=1741813356; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NB4lmw/Mf4Qe+sXf0STCCbsw01ar7L1zADZges3FjeM=;
        b=eCDMVfDTU+/5TtdKOMA5do3PLiikTB8F7YQ+bOKLaCfVeU9V8U7d5RQnjC5c347FzV
         xjRSNBVEr/D5uouML9oculguyG6ExU9IR++/fE4NvfIGvGWQJP92nfW5148aS8bTb0Z7
         8tLfRZYZ8vApmrCE3a8y6wEvHnKet570Qm5jCP4gRmQ7crbY2qe2r2wp7LqJ7a+2Kdqb
         PCEt5a044sr90qbxwcO/paFRxMTFx/Nr3JXVOL4EUdnmezByadZDfK+8Qc76lzVWAowg
         nDM23EL7WU4R7oJMpBBjRpXk1R5z90DS0FAa/rseoAY8fy8RPgqFADX20BI2ynolBhJO
         HaCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741208556; x=1741813356;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NB4lmw/Mf4Qe+sXf0STCCbsw01ar7L1zADZges3FjeM=;
        b=SRZSI7sOP5OYqWgn8Fn2BWWW1uGpCzpaNTtZNNOHVitZonYaT7n0nwmx8Tv6ls2kne
         cNhnINhXwkAZQCAtN2eMxSD8W86Dv8Euhdwumk+3sbjjU9uKpQzJ7jVXIrtY7XaBns1A
         x6I2QPCxaoDvzW2l9hLa5cnUZNe2VqRRJ7vDmetOVjADoRPU8X8bd6iLDntXzBCkE0vE
         Ze9yRUWClsMnN+hjRRLYwoORWP6c9ztd8sNAmIp67k66MHIR0KGN5rzlIjX0ptbiIeoC
         pOO/RDOKnWqfsimqHwStmpzXgzwoG0Z7V+PrAi9QxxNB4BE9rZ1elMf9kal19eLqzGh6
         qNrw==
X-Forwarded-Encrypted: i=1; AJvYcCU2yGIiC4j/NeRpFPdHZAU8yx4VpQUrMqSKQ3b8e3TWnjHgjkFj4x/XfddOsj55n/ULFchveRrkHRE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3IxSM33iScsW3VKMD8PENPkBA/NZNX/fOLPwvKgJT2ubuZb8W
	F1+CD1jdUGYBZSovNmC0SIARtzswqaE75TImor3RZQb8B8Oa+0KrLwrG5h9lJ4c=
X-Gm-Gg: ASbGnctEZoGaWpvYBzsafpgI8m3hLNJQf1T2Mrc+SU5WuN0OHSHWJR6Cw9rkwmIwJRx
	gtzEMocz38SR4b9aSTVOHgAYHO2in3IgSGN8J7b28MMLO1gc4rRW9Thhuu+Eq9camm6qqLgGm97
	GqWX8oiAyxxXx99RzpGHb4N9m+1Vw4MCiXEtuEcBrfliLXh3tCksGG0k5nnUUAIXOaOJAYfA6vn
	HHO1FlNedrffJIA8z3z0K2Ww1pdHRH7ZROEAPbyBlLmmvJFiI5xSyM76Nuj/egi/nsy6q3qk03M
	M8o76t5wxki8v48bsWWAq71rEfZ3sgLkapk9M3Eb7Qev0OoXaXM9FLgnJMKMLo7l84oMA/B6FGK
	yZdvJvU8WuNT/ZRvHvOFJ
X-Google-Smtp-Source: AGHT+IG0XA6HrcLAYApsgDTzhbNp/LD9idECyjvPRs/4nKR9g2saDa/1/bHBVPwwCBcyeHTQ7oBEYA==
X-Received: by 2002:a05:6a00:338d:b0:736:755b:8311 with SMTP id d2e1a72fcca58-73682c89e14mr6902452b3a.16.1741208556139;
        Wed, 05 Mar 2025 13:02:36 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73629d05137sm10621387b3a.180.2025.03.05.13.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 13:02:35 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tpvsv-00000009KS2-0bQF;
	Thu, 06 Mar 2025 08:02:33 +1100
Date: Thu, 6 Mar 2025 08:02:33 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: remove the kmalloc to page allocator fallback
Message-ID: <Z8i76YPOvLgFt1Dq@dread.disaster.area>
References: <20250305140532.158563-1-hch@lst.de>
 <20250305140532.158563-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305140532.158563-7-hch@lst.de>

On Wed, Mar 05, 2025 at 07:05:23AM -0700, Christoph Hellwig wrote:
> Since commit 59bb47985c1d ("mm, sl[aou]b: guarantee natural alignment
> for kmalloc(power-of-two)", kmalloc and friends guarantee that power of
> two sized allocations are naturally aligned.  Limit our use of kmalloc
> for buffers to these power of two sizes and remove the fallback to
> the page allocator for this case, but keep a check in addition to
> trusting the slab allocator to get the alignment right.
> 
> Also refactor the kmalloc path to reuse various calculations for the
> size and gfp flags.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> @@ -300,18 +300,22 @@ xfs_buf_alloc_backing_mem(
>  	if (xfs_buftarg_is_mem(bp->b_target))
>  		return xmbuf_map_page(bp);
>  
> -	/*
> -	 * For buffers that fit entirely within a single page, first attempt to
> -	 * allocate the memory from the heap to minimise memory usage.  If we
> -	 * can't get heap memory for these small buffers, we fall back to using
> -	 * the page allocator.
> -	 */
> -	if (size < PAGE_SIZE && xfs_buf_alloc_kmem(new_bp, flags) == 0)
> -		return 0;
> +	/* Assure zeroed buffer for non-read cases. */
> +	if (!(flags & XBF_READ))
> +		gfp_mask |= __GFP_ZERO;

We should probably drop this zeroing altogether.

The higher level code cannot assume a buffer gained for write has
been zeroed by the xfs_trans_get_buf() path contains zeros. e.g. if
the buffer was in cache when the get_buf() call occurs, it
will contain the whatever was in the buffer, not zeros. This occurs
even if the buffer was STALE in cache at the time of the get()
operation.

Hence callers must always initialise the entire buffer themselves
(and they do!), hence allocating zeroed buffers when we are going
to zero it ourselves anyway is really unnecessary overhead...

This may not matter for 4kB block size filesystems, but it may make
a difference for 64kB block size filesystems, especially when we are
only doing a get() on the buffer to mark it stale in a transaction
and never actually use the contents of it...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
