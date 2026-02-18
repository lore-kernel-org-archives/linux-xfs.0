Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0029133CEB4
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 09:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771407714; cv=none; b=FUCMH9L532Dpa3LYP2aUk7Apg4QEXe+hzaCopRL3uTR99lYvyA2uRqBxpsgx2cuVPpPgxPC89DLaSPJSdr+PkKHnB64iX4Ub4F7eBVP9T6WZaZl66Oin+HKC1WPFGXAg6S8Ysen8lFWut+7NFbw7Bf4tEoziaAOyuqe5qRkHbqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771407714; c=relaxed/simple;
	bh=nLFeYwmb82xcBOA7C5mmfsnrhDKKkSDg8i0xcOYxOOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZcIwBjp0NeW3wfLeaaw4tk5gCWmNSCODZPP+WFCgHJYXqBatWpDOlGYd0hk3CjtsaWx2fnp1ELUESNVPuc4p/4wP9x4CvRVPAGjxDEweIt4ekCwvZkswkNPbxYUotXj3qQm1I29+uW0iIf1J1xmHpEO7CEm7IUkn+eWOzEPOn8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZRl0TaAA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eTGWIeac; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZRl0TaAA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eTGWIeac"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771407708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sdmSmWTTSUpeXTOHRqXOhAP2+YOcdNUbOwJVs26WCus=;
	b=ZRl0TaAA9g26xKPoungyMiJqyv7xsc+P1HupIbaAx4Z/7QMJfQyuRo0QkZCoG6lX7XY6CD
	wiZOTyBNVW24zV+wxoqXzPW1ryiI539BLRVmWakS0smT6Okm0x/6055y5DKj4FT2FdVXDe
	E6c7g8KGbZ4M+QVcsBqtCxkoRCIc0jw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-scH-qY56Ms2STNJJUFuP3g-1; Wed, 18 Feb 2026 04:41:47 -0500
X-MC-Unique: scH-qY56Ms2STNJJUFuP3g-1
X-Mimecast-MFC-AGG-ID: scH-qY56Ms2STNJJUFuP3g_1771407706
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43766514653so3195434f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 01:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771407706; x=1772012506; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sdmSmWTTSUpeXTOHRqXOhAP2+YOcdNUbOwJVs26WCus=;
        b=eTGWIeacHWcljSRHwS5v/ltDg+R+6236Ugf4CiVPUkM5s2uM7Is42qqV4HhidpkhGy
         KsrbRgz34RkzLRIURB6ywhZCJR66iyGcNi+6gWfc72DsA353+ORMhpUyAsaT6wNdhGb0
         X/91pDXYglLhXu095Ebm+s1+zQ/PKqGBmRqz90wxQHCFwjB3noRn0Rp17XjOfz+H+869
         Nk0PqqUXVTqw2LUAutkNzWVC+iQobn3fFPjp8oLm+wuOEEk/fjLHt4iL0+biRt2rzIa1
         50JbPXCySRSvx0un8HIEcLFdPU8hNv35Tj269nSFSKOh/kSPiTx7qdOEUtCrZ5T/Bmyt
         EwVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771407706; x=1772012506;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sdmSmWTTSUpeXTOHRqXOhAP2+YOcdNUbOwJVs26WCus=;
        b=xEv5/y4yr3neM6BbJi3tMkelPZwdJHL5FG1u4K62fXxapzFcRb4HFlOlzzafrZb72E
         7zflG+leIehkN56nrntJCzMe3WAT2FJD6+AC7FtOzoqeZkT0kOjcZhyaJcPY/50O/T8n
         b/Q9TAR/szKyP3OTx78BitLIldaOgwVjrQZFLZqMXxNfs30vaeWXMqmgmC0+Lmgg0shD
         tck5tYrHT6LZOea3i7+uWTp7OD99F/kFB5B5tVTgv2DNKaoXuUtGz8iWvuvR5uCy3oci
         g0kSXIf7PXu6IuKrfPT3omHaQpHUXubb9QsuZR6XQMAnh2prdRmy0ZeqLS6AOeksthNn
         /GJg==
X-Forwarded-Encrypted: i=1; AJvYcCU9lwUPjuPekPTfZwtwZXNR0LLQDjhkvo1IONz2rAf6Sm5Cqswx0iwKaz5zlpMJyUXBU6UK94/UP0M=@vger.kernel.org
X-Gm-Message-State: AOJu0YziXrqhH2/gonEpG5H25y3WrFDiUFbI/H/46hPANtkusDe9Htiu
	FfbnJ+FpNz34uv2EEjP9MrLQO5kILjnQRES/mMiZhxr7qUpD6rv2wC0nZxl4MXZ2EX36bQPXFQF
	rM+b2Sg2QFAPKQM+SWm5QShQF54tZABjE/S3pQHskKPlgtZjAYThqwkcbwTRm
X-Gm-Gg: AZuq6aITgrF9hCWpgDBJtkNyPpHO3eYQJGugfpAZTyvyCr+MaaEaaPlFWKJcoETidmU
	eUOWzuePruhPKPXkUY1D99CJ0iyDKFmBBHwXdcn9fRqVohUr1gwDWlHsEsb0wrNJbOVwguJnRjv
	0vukH6/bqINc0wF+eTM+8pA1M29QLBhABqxG2E5r9s4nH0ifKIPSMQU4WWUzgTb6VUAmiVuNrUK
	7mLbz0wRHC71P7Z5Gi89RrhOdn56zr6jsxKCZl/IAJTQoMtldN0QngHQ5nKMzH+ZR1R1q8E6kzk
	LxNdcUj4hOuNuI7Q4lB+4J5rLH4C1Dehv3s8YhlL0nipKZSXoQHnRtUefs2RkxXai42xGMqAFCX
	dHXg1VS71xTk=
X-Received: by 2002:a05:6000:4383:b0:435:e3bd:5838 with SMTP id ffacd0b85a97d-43958e0ef8fmr2196992f8f.25.1771407706085;
        Wed, 18 Feb 2026 01:41:46 -0800 (PST)
X-Received: by 2002:a05:6000:4383:b0:435:e3bd:5838 with SMTP id ffacd0b85a97d-43958e0ef8fmr2196913f8f.25.1771407705479;
        Wed, 18 Feb 2026 01:41:45 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796abd259sm42708002f8f.24.2026.02.18.01.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 01:41:45 -0800 (PST)
Date: Wed, 18 Feb 2026 10:41:14 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	djwong@kernel.org
Subject: Re: [PATCH v3 11/35] iomap: allow filesystem to read fsverity
 metadata beyound EOF
Message-ID: <hfteu6bonpv7djecbf3d6ekh56ktgcl4c2lvtjtrjfetzaq5dw@scsrvxx5rgig>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-12-aalbersh@kernel.org>
 <20260218063606.GD8600@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218063606.GD8600@lst.de>

> I've looked at the modifications to iomap_read_folio_iter over the entire
> series.  First comment is that it probably makes sense to have one patch
> modifying this logic instead of multiple. 

Sure, I will merge them

> I also think the final result
> can be improved quite a bit by a better code structure, see the patch
> below against your full series.  I've left three XXX comments with
> questions that are probably easier to ask there in the code then
> separately, I hope this works for you.

Thanks for the patch! This looks better I will change to this

> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 9468c5d60b23..48c572d549aa 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -534,47 +534,53 @@ static int iomap_read_folio_iter(struct iomap_iter *iter,
>  			return 0;
>  
>  		/*
> -		 * We hits this for two case:
> -		 * 1. No need to go further, the hole after fsverity descriptor
> -		 * is the end of the fsverity metadata. No ctx->vi means we are
> -		 * reading folio with descriptor.
> -		 * 2. This folio contains merkle tree blocks which need to be
> -		 * synthesized and fsverity descriptor. Skip these blocks as we
> -		 * don't know how to synthesize them yet.
> +		 * Handling of fsverity "holes". We hits this for two case:
> +		 *   1. No need to go further, the hole after fsverity
> +		 *	descriptor is the end of the fsverity metadata.
> +		 *
> +		 *	No ctx->vi means we are reading a folio with descriptor.
> +		 *	XXX: what does descriptor mean here?  Also how do we
> +		 *	even end up with this case?  I can't see how this can
> +		 *	happe based on the caller?

fsverity descriptor. This is basically the case as for EOF folio.
Descriptor is the end of the fsverity metadata region. If we have 1k
fs blocks (= merkle blocks) we can have [descriptor | hole ] folio.
As we are not limited by i_size here, iomap_block_needs_zeroing()
won't fire to zero this hole. So, this case is to mark this tail as
uptodate.

We have holes in the tree and hole after descriptor. Hole after
descriptor is just a marker of the end of the metadata region. And
holes in the tree need to be synthesized. In both cases
IOMAP_F_FSVERITY is set.

On the first read we treat them both the same - mark uptodate and
continue. We can not synthesize tree holes without descriptor and
aren't interested in post descriptor data.

On the second read we already have descriptor, so this case is only
to mark the rest of the descriptor's folio as uptodate.

I think this could be split into two cases by checking if (poff +
plen) cover everything to the folio end. This means that we didn't
get the case with tree holes and descriptor in one folio.

1k fs blocks, 4k page:
[merkle block | tree hole | tree hole | descriptor]

> +		 *
> +		 *   2. This folio contains merkle tree blocks which need to be
> +		 *	synthesized and fsverity descriptor.
>  		 */
>  		if ((iomap->flags & IOMAP_F_FSVERITY) &&
> -		    (iomap->type == IOMAP_HOLE) &&
> -		    !(ctx->vi)) {
> -			iomap_set_range_uptodate(folio, poff, plen);
> -			return iomap_iter_advance(iter, plen);
> -		}
> +		    iomap->type == IOMAP_HOLE) {
> +		    	if (!ctx->vi) {
> +				iomap_set_range_uptodate(folio, poff, plen);
> +				/*
> +				 * XXX: why return to the caller early here?
> +				 */

To not hit hole in the tree (which means synthesize the block). The
fsverity_folio_zero_hash() case.

> +				return iomap_iter_advance(iter, plen);
> +			}
>  
> -		/* zero post-eof blocks as the page may be mapped */
> -		if (iomap_block_needs_zeroing(iter, pos) &&
> -		    !(iomap->flags & IOMAP_F_FSVERITY)) {
> +			/*
> +			 * Synthesize the hash value for a zeroed folio if we
> +			 * are reading merkle tree blocks.
> +			 */
> +			fsverity_folio_zero_hash(folio, poff, plen, ctx->vi);
> +			iomap_set_range_uptodate(folio, poff, plen);
> +		} else if (iomap_block_needs_zeroing(iter, pos) &&
> +			   /*
> +			    * XXX: do we still need the IOMAP_F_FSVERITY check
> +			    * here, or is this all covered by the above one?
> +			    */

Yes, this seems to be not necessary anymore

> +			   !(iomap->flags & IOMAP_F_FSVERITY)) {
> +			/* zero post-eof blocks as the page may be mapped */
>  			folio_zero_range(folio, poff, plen);
>  			if (fsverity_active(iter->inode) &&
>  			    !fsverity_verify_blocks(ctx->vi, folio, plen, poff))
>  				return -EIO;
>  			iomap_set_range_uptodate(folio, poff, plen);

-- 
- Andrey

