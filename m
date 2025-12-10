Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671C6266B6B
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 17:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765386730; cv=none; b=RLUUgP7IlrN8Z705HiqUkRyD0OeqxNbASyCDbsn3l/JQ7YGq0Nvk34ENgWST9o+h8HgW1ln/BzfyLuU+cgKnkq27RtIwieOoRD6HSteaFuyePmG2BETPvIytWUehIN3kXZyeVkN5kQy5C2lRgVA9/eGQaJEmqYaK6ARcCtNT5Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765386730; c=relaxed/simple;
	bh=q+2G+U6BpJLX1Z/0Jsa39HPxOnPyaRSQ+Uck+sOSfns=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=s7eN6uwtfihx0JNtEbMSmNOkPpRKLXIQ1NtLsvbslIFJZosUemjB2B55uha0TtcinAXKGGSCEr/G4EVVApej8cjkMhwVFYCOG2Zz5LSMB2Utm+IlfTT/0cOJ4anFBMK9+mrQu0NSVcaWCpQxUr8DqhJxl42rQ19RAB3BXGP9o7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gj8NJPiP; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hm3ORAX8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gj8NJPiP";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hm3ORAX8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765386727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ajtU3yfJbX06BLmikcUePQ/6Tt1KKMvvS1DqwC86HA=;
	b=Gj8NJPiPKDfH0N5FXvbMQb6AeFJ72bg0PgYvBXPSt7mFPKX1RlsEZKEgQ/7g6hMLqJLaQC
	pXTmzoL8JAatgNfTyAvg4OoDXl2ZUU9dAHHMr8qlDyu5kH0b2PSWdG3fJpTF8uwAYJD0qj
	jHR1OAynO37daDTuD4mKzBGg5p/vIj4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-E50m8my_PQe7DcOO5R02zA-1; Wed, 10 Dec 2025 12:12:06 -0500
X-MC-Unique: E50m8my_PQe7DcOO5R02zA-1
X-Mimecast-MFC-AGG-ID: E50m8my_PQe7DcOO5R02zA_1765386725
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42b2b642287so3565015f8f.2
        for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 09:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765386725; x=1765991525; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8ajtU3yfJbX06BLmikcUePQ/6Tt1KKMvvS1DqwC86HA=;
        b=Hm3ORAX83b2gAf9Iv+MF2aWUCiKptW6P/UVQIqgTkXnjnFyr4fdxXRY54Y2UIfspjy
         XYWXUyAybfguOFfYxC4Loe3D7HhERF+1Wjl34XTjzktfxQjrbpfZow8/NaW8UOZCYBmx
         2nObyV5KWCl3nGLtx+IiFC4oWglGUuhxnSnJpVI4J3v1fj0BsSHRuDObXwrpK7Qxf0+U
         eD3CeH3KU0ZZF4Ig3ojMXagdbLCFiWPqm+0C6GjLf18Uqb/pLqGdL3Xbrau4YFBjn7nk
         Uhur2EQpG7tczTJjLoJQpK/pXcV/cX0LWFXJfY6bAMSld2hYIeXiRD8GaIqVqB6HG50f
         pYYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765386725; x=1765991525;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ajtU3yfJbX06BLmikcUePQ/6Tt1KKMvvS1DqwC86HA=;
        b=o4R9jKIC5MoRVNxlrj6GUoOHZCOufhe772hc7gj36y553B/d3cBRAVsxZG/rz8If+t
         GfYwkHtrCv76H5Mukpz0DPhlf00qB+Xo75kqiybMybFsRB+QCValAOD+rkldhs9pBbTg
         1mpbKkggeCPazcqrcNOMEYQDbjJvIQNGHqokQk93VW1XI4w32WvXR63FeYXhUHD3WSxo
         GFQzXqYSEjNLzfd4ZcCcqIaJM55u0cvI8SNn37tVfCJPz8k0CLU+51yJPAhrS2BcsQU7
         FSexN+HoCiyVa/eGmVfsGGFxbPIHctW6GtIN6LV5p2GNV8zkFk5yxXzx2hG438aJPFOI
         q5cQ==
X-Forwarded-Encrypted: i=1; AJvYcCUiCUYUCJ/Y8u+25ng3EwYNe2pk3b6RbjOekF8Hal0cUP7Ll8/IpKsCKh8C2bfqGAmhYWZ2qB16B3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJZoXhbEMDu+O4+3QAp5igYJy0F62eVJT5z9lEhIzB7bB/AK/L
	U7nWYeItXyLhSEzrrbDeVx042fwRL68B3a0X8Kg6kA0JSjybeIcbg7PqG0Gs7GiokviJRIXdNyb
	lE9D1uYoQQuq//OYvzrOG8baBGmScsr+KVaHJ2rIyhjM+OBSM0Xe/7fQy4uR0Pw==
X-Gm-Gg: AY/fxX7sB5yHugLAO1AcCqViBWZrZo2NAfXvAuFxlWVRh4/WjT0yNlMCp5k6MGJqMj5
	TVkqdOvx9jO/ecQCLsKIOW7cy0tLJ2KrBTrKgo8Yhq/DwXgJNXs6KaX83p5GQFnzqRmJ/8pl0My
	bs287sOeu8GuvFckq3TnX8M1yYqiOmtSMjoko45b91BMOBYdV/5GXBFXgOD0+aG2FIi++sjEYsB
	mKo42hmidW4v+Mmjk/AfXco1KBKGjchU8EU4X1szmLYNZcPCT66SRP39i8GBl80pfBXOiob6Nc1
	1/By2KiOB38JWLY/pzpz+A0iYhz0ur0OI1r31h3sguLeHNG0yg0DlTAkLO/g7OIvCrzWrDVJGHC
	XOaErnK06eMwU9cn5P0DgteHskEnTKirAeiKDy+34So+0ehH/bAGZu8cR4qg=
X-Received: by 2002:a5d:5f91:0:b0:429:d1a8:3fa2 with SMTP id ffacd0b85a97d-42fa3b17092mr3315987f8f.48.1765386724823;
        Wed, 10 Dec 2025 09:12:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IExCXlgcWY7yBdco5ZpK1NFXlvlTRlygsYWJNZD8Qo0xz2z2qNLT3h+7nj8AJhe/t1VfpQnNg==
X-Received: by 2002:a5d:5f91:0:b0:429:d1a8:3fa2 with SMTP id ffacd0b85a97d-42fa3b17092mr3315940f8f.48.1765386724378;
        Wed, 10 Dec 2025 09:12:04 -0800 (PST)
Received: from rh (p200300f6af498100e5be2e2bdb5254b6.dip0.t-ipconnect.de. [2003:f6:af49:8100:e5be:2e2b:db52:54b6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42fa8b9b20dsm27930f8f.38.2025.12.10.09.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 09:12:03 -0800 (PST)
Date: Wed, 10 Dec 2025 18:12:02 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
cc: Keith Busch <kbusch@kernel.org>, 
    "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, 
    "iommu@lists.linux.dev" <iommu@lists.linux.dev>, 
    Robin Murphy <robin.murphy@arm.com>, 
    "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
    "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
    Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, 
    Will Deacon <will@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
    Leon Romanovsky <leon@kernel.org>
Subject: Re: WARNING: drivers/iommu/io-pgtable-arm.c:639
In-Reply-To: <2fcc9d30-42e8-4382-bbbc-a3f66016f368@nvidia.com>
Message-ID: <0eec3806-c002-54d5-95a9-7fa201c6b921@redhat.com>
References: <170120f7-dd2c-4d2a-d6fc-ac4c82afefd7@redhat.com> <4386e0f7-9e45-41d2-8236-7133d6d00610@arm.com> <99e12a04-d23f-f9e7-b02e-770e0012a794@redhat.com> <30ae8fc4-94ff-4467-835e-28b4a4dfcd8f@nvidia.com> <aTjxleV96jE3PIBh@kbusch-mbp>
 <2fcc9d30-42e8-4382-bbbc-a3f66016f368@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 10 Dec 2025, Chaitanya Kulkarni wrote:
> (+ Leon Romanovsky)
>
> On 12/9/25 20:05, Keith Busch wrote:
>> On Wed, Dec 10, 2025 at 02:30:50AM +0000, Chaitanya Kulkarni wrote:
>>> @@ -126,17 +126,26 @@ static bool blk_rq_dma_map_iova(struct request *req, struct device *dma_dev,
>>>    		error = dma_iova_link(dma_dev, state, vec->paddr, mapped,
>>>    				vec->len, dir, attrs);
>>>    		if (error)
>>> -			break;
>>> +			goto out_unlink;
>>>    		mapped += vec->len;
>>>    	} while (blk_map_iter_next(req, &iter->iter, vec));
>>>
>>>    	error = dma_iova_sync(dma_dev, state, 0, mapped);
>>> -	if (error) {
>>> -		iter->status = errno_to_blk_status(error);
>>> -		return false;
>>> -	}
>>> +	if (error)
>>> +		goto out_unlink;
>>>
>>>    	return true;
>>> +
>>> +out_unlink:
>>> +	/*
>>> +	 * Unlink any partial mapping to avoid unmap mismatch later.
>>> +	 * If we mapped some bytes but not all, we must clean up now
>>> +	 * to prevent attempting to unmap more than was actually mapped.
>>> +	 */
>>> +	if (mapped)
>>> +		dma_iova_unlink(dma_dev, state, 0, mapped, dir, attrs);
>>> +	iter->status = errno_to_blk_status(error);
>>> +	return false;
>>>    }
>> It does look like a bug to continue on when dma_iova_link() fails as the
>> caller thinks the entire mapping was successful, but I think you also
>> need to call dma_iova_free() to undo the earlier dma_iova_try_alloc(),
>> otherwise iova space is leaked.
>
> Thanks for catching that, see updated version of this patch [1].
>
>> I'm a bit doubtful this error condition was hit though: this sequence
>> is largely the same as it was in v6.18 before the regression. The only
>> difference since then should just be for handling P2P DMA across a host
>> bridge, which I don't think applies to the reported bug since that's a
>> pretty unusual thing to do.
>
> That's why I've asked reporter to test it.
>
> Either way, IMO both of the patches are still needed.
>

The patch Keith posted fixes the issue for me. Should I do another run
with only these 2 applied?

