Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE6B18DF73
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 20:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741207842; cv=none; b=TTYQWNPg+yXqlFYSwFqaq38hsXXsPFjj/FBVQAOu//lhsqYVhbPR+QPrGu+JYftLPUMqhgAhfq0xFAxYgb1VPeTfOjZe3q059Fm4VU7oyJO55hMtHiSuhb87Pj5ksn+yjxfTdalle9ZCjXyRdbD13nwU4oisOzv0JuukWEQTwkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741207842; c=relaxed/simple;
	bh=8ygR5ouoHUviIf7adIUneOULaSML1e7gWPbjVlMAhJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BmEGdiZhFprR5DjMpD2Axk5PITCdZvXp+GK3hEArELdvi7Enyx3i1TMX1nrJdaIptheWo7JouIlmalcIwki/gkmDXDsx630ABP3YZt3t0U3Lg6CrRc7LofgVhiZ6tkHwerhbBJPjsBQtKfEita0xEvTiEp5VAFcotBiDKbytwiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=FvfIZGYT; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="FvfIZGYT"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22409077c06so6715115ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 05 Mar 2025 12:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741207840; x=1741812640; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sm9wpwFHmeQAUhLiwKO+NiYv21GbjDSZ7A2fAKxsgVc=;
        b=FvfIZGYT/iAdd6ZyEvMpHVQk4UcK7sbGu0oonhB2mTjf7VaBP7oN7P3hiKY97J4V9U
         XLA9O3y5oiqGm8vve2UbQk176XOpH9hONufYYsT0kk3eKVpRDPF1q2Kzz1gUHmMwf5AC
         bp/6Xf5XshqITav/zpJi5Ms+1LcTlsG9JvwjyViQVS/ll8caUrIVvOs3sGIF79jYZ+TP
         TAbv0KoNr/WWcjaXt6NFuUQrWh1xSSkyy46cgecKh70PYR+WmFhxx4CDRF7PVWnIO85T
         S93DdGKujvwsdEQxbNJqKpC0vzXxJ6LN4lXmQS29k7S/grqhIvAthl/EcdAw9/Qc90vf
         sj8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741207840; x=1741812640;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sm9wpwFHmeQAUhLiwKO+NiYv21GbjDSZ7A2fAKxsgVc=;
        b=cAm9+fsNGfHaCJNEkwvrglkKOce2RS0PRfg1QMwoVtRywGFG1K05uzU5ZEU3HjBW73
         nDyJALBlijoWlReK5kmLSz4Hs6D3xKyZ6ug/R2izosFCOrT4A8PGixuP0GZZvuzhASYl
         qeLkLwRKRTrEK8y8j1CWJL3aVJqnIIMJKcCeOfR0DZL1T7daF69Bdd29/yLTbbA1Ao52
         x/7Av8Imk5u3UNLeNhU8KxiN3pP818gVcJUv1HQ2b/lRXzDFuRaqThJeu4lDYaRtkX4P
         wJJaPnAe2v/XgnXMz+9kp/iIO9zoCFYjHj8GZk71r/kEbESmvM29UazwgrLidwDQJBC+
         BcSw==
X-Forwarded-Encrypted: i=1; AJvYcCVNzeiwgOFT1xUeIQdJVvGfati9kv9uO4+bL12XZgVWA8N4tr39j5VzFagpL2GkY7q2lfp3q0V4BEw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXPh2yjtjs1N7vrfKdh9/4LliV+3c/iniOKT+ge/ZNRvoVfVg7
	7JDeTDz7LZUzPAEQcPKLO9kTrI+NXo/2wH2n4HrBCQ7q9W/IW1HM/xa0EGhuBC4=
X-Gm-Gg: ASbGnctI2qmfBe/HWPuawO1X+ON2Qa4ZvmCElx6pFnSvYGBpvW7ydREN7Ah/sMNTobL
	fimmGszhzLm8sSqiiUWsar92PxqW8NSnv6u7hHh/a1RJESF/5/hJVSWjwPzargW7VX77uvWUluP
	RCbedytDz/b2fsblUNyeV5cj+Z79vw6mxRLTDG1yRd0cbzfANXH+4yvuWBw6SPtffp/wKmgz+QP
	nLCget1b+0UKpmSf0ZFOYF6zNAvUzFW2lHtCjCcZPgslmgur2G4Wcou3ttlQq0hy7mTrg3Ot6qy
	T2t1mP/W9DzZw96jTg3EBgjRXfDuxIS66Ng8whxVMumqxhIGhgDGC2rw2AX3wFD/72AYt6kOTaN
	5EtcsYuRXr1LeRTjVPeXn
X-Google-Smtp-Source: AGHT+IF+RbsyPZv/saFM8eJaY+BVj4/oBarMuc1G73L2IW00UVYrdzpBLPglvDLiK5TRdQ+MkWUcMw==
X-Received: by 2002:a17:902:f644:b0:223:6436:72c7 with SMTP id d9443c01a7336-223f1d1d277mr77942595ad.48.1741207840423;
        Wed, 05 Mar 2025 12:50:40 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223fdb476e5sm10724895ad.179.2025.03.05.12.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 12:50:39 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tpvhN-00000009K5S-07ii;
	Thu, 06 Mar 2025 07:50:37 +1100
Date: Thu, 6 Mar 2025 07:50:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: convert buffer cache to use high order folios
Message-ID: <Z8i5HSS1ppbtQiJc@dread.disaster.area>
References: <20250305140532.158563-1-hch@lst.de>
 <20250305140532.158563-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305140532.158563-8-hch@lst.de>

On Wed, Mar 05, 2025 at 07:05:24AM -0700, Christoph Hellwig wrote:
> Now that we have the buffer cache using the folio API, we can extend
> the use of folios to allocate high order folios for multi-page
> buffers rather than an array of single pages that are then vmapped
> into a contiguous range.
> 
> This creates a new type of single folio buffers that can have arbitrary
> order in addition to the existing multi-folio buffers made up of many
> single page folios that get vmapped.  The single folio is for now
> stashed into the existing b_pages array, but that will go away entirely
> later in the series and remove the temporary page vs folio typing issues
> that only work because the two structures currently can be used largely
> interchangeable.
> 
> The code that allocates buffers will optimistically attempt a high
> order folio allocation as a fast path if the buffer size is a power
> of two and thus fits into a folio. If this high order allocation
> fails, then we fall back to the existing multi-folio allocation
> code. This now forms the slow allocation path, and hopefully will be
> largely unused in normal conditions except for buffers with size
> that are not a power of two like larger remote xattrs.
> 
> This should improve performance of large buffer operations (e.g.
> large directory block sizes) as we should now mostly avoid the
> expense of vmapping large buffers (and the vmap lock contention that
> can occur) as well as avoid the runtime pressure that frequently
> accessing kernel vmapped pages put on the TLBs.
> 
> Based on a patch from Dave Chinner <dchinner@redhat.com>, but mutilated
> beyond recognition.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 52 ++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 46 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 073246d4352f..f0666ef57bd2 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -203,9 +203,9 @@ xfs_buf_free_pages(
>  
>  	for (i = 0; i < bp->b_page_count; i++) {
>  		if (bp->b_pages[i])
> -			__free_page(bp->b_pages[i]);
> +			folio_put(page_folio(bp->b_pages[i]));
>  	}
> -	mm_account_reclaimed_pages(bp->b_page_count);
> +	mm_account_reclaimed_pages(howmany(BBTOB(bp->b_length), PAGE_SIZE));
>  
>  	if (bp->b_pages != bp->b_page_array)
>  		kfree(bp->b_pages);
> @@ -277,12 +277,17 @@ xfs_buf_alloc_kmem(
>   * For tmpfs-backed buffers used by in-memory btrees this directly maps the
>   * tmpfs page cache folios.
>   *
> - * For real file system buffers there are two different kinds backing memory:
> + * For real file system buffers there are three different kinds backing memory:
>   *
>   * The first type backs the buffer by a kmalloc allocation.  This is done for
>   * less than PAGE_SIZE allocations to avoid wasting memory.
>   *
> - * The second type of buffer is the multi-page buffer. These are always made
> + * The second type is a single folio buffer - this may be a high order folio or
> + * just a single page sized folio, but either way they get treated the same way
> + * by the rest of the code - the buffer memory spans a single contiguous memory
> + * region that we don't have to map and unmap to access the data directly.
> + *
> + * The third type of buffer is the multi-page buffer. These are always made
>   * up of single pages so that they can be fed to vmap_ram() to return a
>   * contiguous memory region we can access the data through, or mark it as
>   * XBF_UNMAPPED and access the data directly through individual page_address()
> @@ -295,6 +300,7 @@ xfs_buf_alloc_backing_mem(
>  {
>  	size_t		size = BBTOB(bp->b_length);
>  	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
> +	struct folio	*folio;
>  	long		filled = 0;
>  
>  	if (xfs_buftarg_is_mem(bp->b_target))
> @@ -316,7 +322,41 @@ xfs_buf_alloc_backing_mem(
>  	if (size < PAGE_SIZE && is_power_of_2(size))
>  		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
>  
> -	/* Make sure that we have a page list */
> +	/*
> +	 * Don't bother with the retry loop for single PAGE allocations: vmalloc
> +	 * won't do any better.
> +	 */
> +	if (size <= PAGE_SIZE)
> +		gfp_mask |= __GFP_NOFAIL;
> +
> +	/*
> +	 * Optimistically attempt a single high order folio allocation for
> +	 * larger than PAGE_SIZE buffers.
> +	 *
> +	 * Allocating a high order folio makes the assumption that buffers are a
> +	 * power-of-2 size, matching the power-of-2 folios sizes available.
> +	 *
> +	 * The exception here are user xattr data buffers, which can be arbitrarily
> +	 * sized up to 64kB plus structure metadata, skip straight to the vmalloc
> +	 * path for them instead of wasting memory here.
> +	 */
> +	if (size > PAGE_SIZE && !is_power_of_2(size))
> +		goto fallback;
> +	folio = folio_alloc(gfp_mask, get_order(size));

The only thing extra that I would do here is take a leaf from the
kmalloc() call in xlog_kvmalloc() and turn off direct reclaim for
this allocation because >= 32kB allocations are considered "costly"
and so will enter the compaction code if direct reclaim is enabled.

Given that we fall back to vmalloc, clearing __GFP_DIRECT_RECLAIM
and setting __GFP_NORETRY here means that we don't burn lots of CPU
on memory compaction if there is no high order folios available for
immediate allocation. And on a busy machine, compaction is likely to
fail frequently and so this is all wasted CPU time.

This may be one of the reasons why you don't see any change in real
performance with 64kB directory blocks - we spend more time in
folio allocation because of compaction overhead than we gain back
from avoiding the use of vmapped buffers....

i.e.
	if (size > PAGE_SIZE) {
		if (!is_power_of_2(size))
			goto fallback;
		gfp_mask ~= __GFP_DIRECT_RECLAIM;
		gfp_mask |= __GFP_NORETRY;
	}
	folio = folio_alloc(gfp_mask, get_order(size));

-Dave.
-- 
Dave Chinner
david@fromorbit.com
