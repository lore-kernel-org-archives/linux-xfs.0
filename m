Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A1E4A33
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 21:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741209613; cv=none; b=IJUx+H4hX4ZebQsgWv3iL+pt+g8Dt5yab+25ajWA7RNuPd/yacCmkm3QvF5RclbX4Gg53Apy+X0w4rZgwqkHe/4JUf3qqK19EPEr+hUpGxC1bW3ZdjPQy/lpFpOxRglRO5LfvBKWj2CS5QmpARpIKciroT8PA6FwW1TNFwoKeXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741209613; c=relaxed/simple;
	bh=KixwN7JaBAmw1mTB9VTBTyZbtMAZIuOmualc2mZ6Q7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCPunUM74Jts8oaFnZVXjs81AokagTaC71TZRviEfmvjm8F4/yLM39r7JskIEGdlijYV8lTsnnE1H5LSl0FqJwK+IyDKCXUVJ38FDBfuLg59YS/HF+V7aVYTO8ZkPbH15GG9JWBlOm0XwQz5G17a1GRxVhKPbZ3CgLp6yLmnXSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Wzm1daSj; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Wzm1daSj"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22382657540so93016175ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 05 Mar 2025 13:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741209611; x=1741814411; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+4mjfo56Ozb6CHAoPW5LT3YgPVfBencjSgTXbvWI+84=;
        b=Wzm1daSjP1lUs3MIr9TXZAIEXglCx3Jp0ARMNVUtRCQLJSx2spIWh5XA7C+ruBis7z
         MSncQBjrwdgNI6OxPwDXtwQn8lnV/nyM9cSdd5nH+vy6MKHp0ugS/9iK/IwCMdqaQP4t
         PG8FmP+7n/JxiuBRcQCDJIdQw4WSWBe0QqsaB5tK53kybzKcc4DuGNxJaNRjEN1xpvo6
         gycpOjTv8otobd7A1DfzEtUS8jrcjA8fxhO/34tgMA7bUfgKHScWtppHVgcBFsIfHEBf
         nJwC19axsRrb/NlUKMBT85tX7WJvZpJLrQwDbUXLOsgViZV8hJSXZdrZ1B2//bavU4nw
         c27A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741209611; x=1741814411;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+4mjfo56Ozb6CHAoPW5LT3YgPVfBencjSgTXbvWI+84=;
        b=LzE4KGIeJBfKd1xhcHR9UMfBHIfkuOCGaujTUOwn9NmFvp5Jh42m988Y64H7fNruzY
         0iO8KpfEEaAXeIXPJtqq50BxohBMnhndn329a3fKCJ4nk+5TD8eyjNSw9wwhgsA06GFF
         GGKshUpyOEsrNx3hHv39BUNUT1q5vKkXzR4xQvvFn6E9vE28ihWn549pk4/HprYkGuFG
         ozgzxTtxyY1OgCGcU7lqsZUZRLV72TraP/Umg+OwwhskLZ399wRbd2NhXq2TO6QEzssb
         +4Zh0nMyDsEYHp+EzdzgjBcYlPE1aP9++0mHF4LdVnYlA2L8k0/3gVupn1V0BOukQCPy
         K/ng==
X-Forwarded-Encrypted: i=1; AJvYcCWD26e5hDrvHVRNgTqMVNY4jTmfEGmw8gT2klE5OxUhaSpMpzFVnyjXUqdpw7Rm1mQNTXSqHF/ZlKw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfwIYhrcHy6ve9f+pIck0UWARaWdGgtT8QfsPOsPll7Z7e6GST
	ZD35FzjJNcZeRLy//fpWrX7OIW1beBqMgu88mtkf2YecACY52HR6KJ61L5ceEeU=
X-Gm-Gg: ASbGnct5yOvdf7h8b0OzLr8lhyY4/Lncam8H1mb+1OtQoAtNRA1Ek6mJkOQBpXGGOI9
	36Nkv/QFoqb1Ls9fhRrlQQh1c2SnZq2oioopOBo4ofhGD2Aa9D5N0AniDjRBSitOto+gqKDW4XH
	BG+PsN5bQuly4U98oKACwPNH3YuJKmspYiqh0RYEAyZR608xDxwfTDXRSw8jMFRjJBz5OFI+skz
	4ERUdxFWYgvJDN/T072V3UHOVqrXQAD1LIyXze1eQteKVkJ9l//YAyASceBXuNUZ8SqNxxCXJMs
	hsx5h7P1uUO/gxQFBDp4sr7QAATf5Iv83k8rsHCcuSH0INxVm36ZSnxJPcvh3VPPlrSFcUsic+I
	kBDjCtwyav3ls1bjSsFu8
X-Google-Smtp-Source: AGHT+IFYLj84UpFt1rGVJXgbmefLQ32OCzDVF4gCbYYorbXIgH/LGtGReEf1b5+P3qoOUZ3BFJ/X6g==
X-Received: by 2002:a17:903:230a:b0:220:ca39:d453 with SMTP id d9443c01a7336-223f1c81e80mr71858745ad.17.1741209611260;
        Wed, 05 Mar 2025 13:20:11 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501d2791sm117268745ad.12.2025.03.05.13.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 13:20:10 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tpw9w-00000009KdC-0xbZ;
	Thu, 06 Mar 2025 08:20:08 +1100
Date: Thu, 6 Mar 2025 08:20:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: use vmalloc instead of vm_map_area for buffer
 backing memory
Message-ID: <Z8jACLtp5X98ShBR@dread.disaster.area>
References: <20250305140532.158563-1-hch@lst.de>
 <20250305140532.158563-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305140532.158563-11-hch@lst.de>

On Wed, Mar 05, 2025 at 07:05:27AM -0700, Christoph Hellwig wrote:
> The fallback buffer allocation path currently open codes a suboptimal
> version of vmalloc to allocate pages that are then mapped into
> vmalloc space.  Switch to using vmalloc instead, which uses all the
> optimizations in the common vmalloc code, and removes the need to
> track the backing pages in the xfs_buf structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....

> @@ -1500,29 +1373,43 @@ static void
>  xfs_buf_submit_bio(
>  	struct xfs_buf		*bp)
>  {
> -	unsigned int		size = BBTOB(bp->b_length);
> -	unsigned int		map = 0, p;
> +	unsigned int		map = 0;
>  	struct blk_plug		plug;
>  	struct bio		*bio;
>  
> -	bio = bio_alloc(bp->b_target->bt_bdev, bp->b_page_count,
> -			xfs_buf_bio_op(bp), GFP_NOIO);
> -	bio->bi_private = bp;
> -	bio->bi_end_io = xfs_buf_bio_end_io;
> +	if (is_vmalloc_addr(bp->b_addr)) {
> +		unsigned int	size = BBTOB(bp->b_length);
> +		unsigned int	alloc_size = roundup(size, PAGE_SIZE);
> +		void		*data = bp->b_addr;
>  
> -	if (bp->b_page_count == 1) {
> -		__bio_add_page(bio, virt_to_page(bp->b_addr), size,
> -				offset_in_page(bp->b_addr));
> -	} else {
> -		for (p = 0; p < bp->b_page_count; p++)
> -			__bio_add_page(bio, bp->b_pages[p], PAGE_SIZE, 0);
> -		bio->bi_iter.bi_size = size; /* limit to the actual size used */
> +		bio = bio_alloc(bp->b_target->bt_bdev, alloc_size >> PAGE_SHIFT,
> +				xfs_buf_bio_op(bp), GFP_NOIO);
> +
> +		do {
> +			unsigned int	len = min(size, PAGE_SIZE);
>  
> -		if (is_vmalloc_addr(bp->b_addr))
> -			flush_kernel_vmap_range(bp->b_addr,
> -					xfs_buf_vmap_len(bp));
> +			ASSERT(offset_in_page(data) == 0);
> +			__bio_add_page(bio, vmalloc_to_page(data), len, 0);
> +			data += len;
> +			size -= len;
> +		} while (size);
> +
> +		flush_kernel_vmap_range(bp->b_addr, alloc_size);
> +	} else {
> +		/*
> +		 * Single folio or slab allocation.  Must be contiguous and thus
> +		 * only a single bvec is needed.
> +		 */
> +		bio = bio_alloc(bp->b_target->bt_bdev, 1, xfs_buf_bio_op(bp),
> +				GFP_NOIO);
> +		__bio_add_page(bio, virt_to_page(bp->b_addr),
> +				BBTOB(bp->b_length),
> +				offset_in_page(bp->b_addr));
>  	}

How does offset_in_page() work with a high order folio? It can only
return a value between 0 and (PAGE_SIZE - 1). i.e. shouldn't this
be:

		folio = kmem_to_folio(bp->b_addr);

		bio_add_folio_nofail(bio, folio, BBTOB(bp->b_length),
				offset_in_folio(folio, bp->b_addr));


-Dave.
-- 
Dave Chinner
david@fromorbit.com
