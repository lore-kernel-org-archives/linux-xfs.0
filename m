Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B872F14A8D
	for <linux-xfs@vger.kernel.org>; Fri, 16 Feb 2024 07:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708067642; cv=none; b=sQehRtb587xzek9fCCVwvbCDSxJu94IUcxkO+4o2djzHv4/6JsVMdtkVxYox5Neq6CjaDkllYcr+OI53ykZ7YH/X5U2uryQmqcrP260oJCCCAXjA8Vl+f1RNF0vhi31AfOfohKZkMrm6BXclYLJH9fBuTGtKh3dK2M2cT8abatk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708067642; c=relaxed/simple;
	bh=mh+5j05A0iu00Ue2cBP2TYQ7CKHaOKInZKjlgk+GNlQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fwLqb6aFDZEjPszakWNwSfpzS0OWf5dbPP78x4Df6cbRsUbyigsQk7zq/+VXPj23BYShaR7Exh8VAd5S0b96C3ZoK8RRYMRF+dzxSKmMjICGpPfNdLEVh6IcueGGsMDrEwDWdPJNFruz374vxi9oUBz7it+nBF6XP8hZ15mKsX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w0Q6g5Ay; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w0Q6g5Ay"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-607ec539525so9354077b3.0
        for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 23:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708067640; x=1708672440; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fl1Nnwwt1Iw6MB9TRmkKxycKApOS/hToxGMtYRxh2Bk=;
        b=w0Q6g5Ay9as1CwZdlmPhYBvQvQaYvwu36k2UKMcCGWq5cjq0Bf821CJ7Pdm6iPD/7I
         h27vz9nQAyr8pRx8SMghnf0K+YmdtFWBuRpzw8dLrxC9s1zC+VMp0yc3FoCOXvqrVC1d
         duaoauUFs1o1i1BHDBJ3Tq/AdhJqu1lHxdIuLEUW1c09oURIOZGZw0XLJeb768STmaj1
         TL8mxLi5mrDyf/8EcJ70BebZzl/zSjua8P2Dq8FP9+tIxthhSfSqTwjplAm9yknCpL3J
         fCCn4VWbC3GL9thvDVCF4+yaQKRrppV60FyEjACdAucyNW/iZbEKGxvw2upaI8ntWBud
         WeQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708067640; x=1708672440;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fl1Nnwwt1Iw6MB9TRmkKxycKApOS/hToxGMtYRxh2Bk=;
        b=hs7JdlzSEAW1D6J8s5TJwOGFHoO4kupg7gtYMQv2hjPeN461iJKWbLEqksGDtGZdWb
         OmiwXEfJHDm6Lm1DlsbQmwivNJuFGlqqlUH6tm3w3qRjVj1gWi3Mxi/HKl+4+X1zPvFj
         G5lCJg+SAo8Cnsy4VURYxx7cXjNgDx94JRdkq4NQxy5psGrIPPjGXYwfc1NcNg1e5i4k
         51JlniKInLHtM7VyAFAYR9/Jxq7/XJHmSvcyO7WoaM/8vA1qlpnRBsnZmZpvzrY+gtTM
         iUz1da8kJhFdPADCbYiMNw5XzpEoy+CMJ+UDznFFfE5kkh8L1JsV1aNsVcwXgLgN+rlR
         tDrg==
X-Forwarded-Encrypted: i=1; AJvYcCV0YtHRuKwxAXJf0M43Y7woBXFST6yl5Jw6O+qgj6My5o3nJQDhrvBuxeVdeox7lXre+0K8XER6Vr78AHES8xYVC3mtmnzEoANd
X-Gm-Message-State: AOJu0YwFpgCxPlSL/Y39xtd2NyOK3vLz5QV3nm2BMp4/gsFp6Qcel14K
	RUeCZXF4u1uriytGAWxMzInoBiudJTR7tylNrvFlYs/k/yGRyAyMOkKEYzVzZg==
X-Google-Smtp-Source: AGHT+IHQXBygKVY+3o1Oh9WEFcmDSpRmo15pPlLAd7Q37IfMN6zmt/CFgRRxWVCWRR/2+18/7RaMTw==
X-Received: by 2002:a0d:cc48:0:b0:607:855f:599d with SMTP id o69-20020a0dcc48000000b00607855f599dmr4064915ywd.14.1708067638057;
        Thu, 15 Feb 2024 23:13:58 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id i123-20020a816d81000000b0060795309574sm236649ywc.79.2024.02.15.23.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 23:13:57 -0800 (PST)
Date: Thu, 15 Feb 2024 23:13:55 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Christoph Hellwig <hch@lst.de>
cc: Chandan Babu R <chandan.babu@oracle.com>, 
    "Darrick J. Wong" <djwong@kernel.org>, Hugh Dickins <hughd@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH 13/20] xfs: don't allow highmem pages in xfile mappings
In-Reply-To: <20240129143502.189370-14-hch@lst.de>
Message-ID: <f3df6aa8-2085-4342-088f-83257848845e@google.com>
References: <20240129143502.189370-1-hch@lst.de> <20240129143502.189370-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 29 Jan 2024, Christoph Hellwig wrote:

> XFS is generally used on 64-bit, non-highmem platforms and xfile
> mappings are accessed all the time.  Reduce our pain by not allowing
> any highmem mappings in the xfile page cache and remove all the kmap
> calls for it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/xfarray.c |  3 +--
>  fs/xfs/scrub/xfile.c   | 21 +++++++++------------
>  2 files changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
> index 95ac14bceeadd6..d0f98a43b2ba0a 100644
> --- a/fs/xfs/scrub/xfarray.c
> +++ b/fs/xfs/scrub/xfarray.c
> @@ -580,7 +580,7 @@ xfarray_sort_get_page(
>  	 * xfile pages must never be mapped into userspace, so we skip the
>  	 * dcache flush when mapping the page.
>  	 */
> -	si->page_kaddr = kmap_local_page(si->xfpage.page);
> +	si->page_kaddr = page_address(si->xfpage.page);
>  	return 0;
>  }
>  
> @@ -592,7 +592,6 @@ xfarray_sort_put_page(
>  	if (!si->page_kaddr)
>  		return 0;
>  
> -	kunmap_local(si->page_kaddr);
>  	si->page_kaddr = NULL;
>  
>  	return xfile_put_page(si->array->xfile, &si->xfpage);
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index 7e915385ef0011..a669ebbbc02d1d 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -77,6 +77,12 @@ xfile_create(
>  	inode = file_inode(xf->file);
>  	lockdep_set_class(&inode->i_rwsem, &xfile_i_mutex_key);
>  
> +	/*
> +	 * We don't want to bother with kmapping data during repair, so don't
> +	 * allow highmem pages to back this mapping.
> +	 */
> +	mapping_set_gfp_mask(inode->i_mapping, GFP_KERNEL);

I had been going to point you to inode_nohighmem(inode), which is how
that is usually done.  But I share Matthew's uncertainty about cpusets
and the __GFP_HARDWALL inside GFP_USER: you may well be right to stick
with GFP_KERNEL, just as you've done it here.  I suppose it depends on
whether you see this as a system operation or a user-invoked operation.

I did also think that perhaps you could mask off __GFP_FS here, to
avoid having to remember those memalloc_nofs_save()s elsewhere; but
that's probably a bad idea, I doubt anywhere else does it that way.

So, no change required, but I wanted to think about it.

Hugh

> +
>  	trace_xfile_create(xf);
>  
>  	*xfilep = xf;
> @@ -126,7 +132,6 @@ xfile_load(
>  
>  	pflags = memalloc_nofs_save();
>  	while (count > 0) {
> -		void		*p, *kaddr;
>  		unsigned int	len;
>  
>  		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
> @@ -153,10 +158,7 @@ xfile_load(
>  		 * xfile pages must never be mapped into userspace, so
>  		 * we skip the dcache flush.
>  		 */
> -		kaddr = kmap_local_page(page);
> -		p = kaddr + offset_in_page(pos);
> -		memcpy(buf, p, len);
> -		kunmap_local(kaddr);
> +		memcpy(buf, page_address(page) + offset_in_page(pos), len);
>  		put_page(page);
>  
>  advance:
> @@ -221,14 +223,13 @@ xfile_store(
>  		 * the dcache flush.  If the page is not uptodate, zero it
>  		 * before writing data.
>  		 */
> -		kaddr = kmap_local_page(page);
> +		kaddr = page_address(page);
>  		if (!PageUptodate(page)) {
>  			memset(kaddr, 0, PAGE_SIZE);
>  			SetPageUptodate(page);
>  		}
>  		p = kaddr + offset_in_page(pos);
>  		memcpy(p, buf, len);
> -		kunmap_local(kaddr);
>  
>  		ret = aops->write_end(NULL, mapping, pos, len, len, page,
>  				fsdata);
> @@ -314,11 +315,7 @@ xfile_get_page(
>  	 * to the caller and make sure the backing store will hold on to them.
>  	 */
>  	if (!PageUptodate(page)) {
> -		void	*kaddr;
> -
> -		kaddr = kmap_local_page(page);
> -		memset(kaddr, 0, PAGE_SIZE);
> -		kunmap_local(kaddr);
> +		memset(page_address(page), 0, PAGE_SIZE);
>  		SetPageUptodate(page);
>  	}
>  
> -- 
> 2.39.2
