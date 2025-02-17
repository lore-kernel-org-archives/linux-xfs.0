Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE641A0BFD
	for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2025 21:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739827922; cv=none; b=JgINOSKE2o4UM5n3vxKPvFIK3eyrL78iCBipy3VdpB+U2q3DwvE6y+8n1wiuimZj4BOxBz0m6RZ9V2bvHDDVtaZLp1PpNZUjHm855SrSd3oKX9tL7gKMadydCqgS5SkFIN/YhOYfcjMuaoo0tnMegk5H8UAcaM3I4JVE2C5ccvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739827922; c=relaxed/simple;
	bh=5Z3w6D6rLKLuQ6zEjNL6ikv+CipM0JHOZMCbXFfqNBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z9JLnzs3CcJ4Yrnof3ZVjljeoaxjOKTDsUiyPRpHhlzZnU2eFDaOFcFZsMfLvu4FfzODxpWBOb7uqUBHdAughEDfdujT53BxmI9Y1xd/6y2tLReAc2BL+K1Ndmrr6iNB14hwg746gF6UvmcFygbfIcJWqGa853ydvoUQdugSBP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=iSnbtykA; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="iSnbtykA"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2fc3fa00323so5063140a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2025 13:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1739827919; x=1740432719; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QhTfy1/ybvgYfqGEX8d/5gFaFMopC4YNbC7hGVBL/4c=;
        b=iSnbtykAPgeoaamX/D5Xv39Q6ZYYIHEVE4zgMl66cwZvyQ48oaYzC/IgKLS86w/HD5
         CKBcfACcqxE79g5417jqRYfPLcOSB6GqY0F0IGgHXLJSrAsw+pHW+/BrFDI6sARK9/gu
         Ykml65dgc1/utgt1Fmn5RhHyRVJuUcEvZU3xJchUB3WXLYnbSu+ReTOwGxknLjjSZHeX
         98GJwsv/gTKG2lH8c9qcf91n5QTxQQ0DqQEQLYYDOqXZmgxu6lKi/Skz8q+fHbi/IGsU
         A5VQDVfWr3DZcIo3115AKKu7y5dD6S6IG87n4slcw011eIp41wnUCyXKCC04ss9B4jwe
         KEEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739827919; x=1740432719;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QhTfy1/ybvgYfqGEX8d/5gFaFMopC4YNbC7hGVBL/4c=;
        b=Tsu4hbTQVuifXgyMxGizcFg+ticrLeZEgSpMCyNvwap32Z/C68xUOTLbRtJH7wWOKP
         2kSzeM8Qcabmh7vyOAaOyxB0WzQjsYoIxwxaWe8X2w+JZUGcfUyoulOBrG5JYKxzkr4d
         hf46zDKHNUEt6rYpT4hJDRS0VuSWCOpMsSaOXxfD5W96OKrxQaVNjh0zGWclD9LTrQft
         YwEj8bOjP0BE/orjf/F3ybTCPUOTqXaMWJ7MqedsEzZWuRgijudoeZkNHMx6/KXrq0zv
         bjqrSvhnAMJ2KrGCSytfnE7S657dRQlbBGw+RvUSzRDfDJh5u3qII/lsby5lRBQxS1rF
         nraw==
X-Forwarded-Encrypted: i=1; AJvYcCXRIQXyGLkuuvh82Yq9U7kpjmAg3lYlpkb4Mmj06FIxqPKU0FOBwRj2XlP0hyuWAwEJutYyj9JpF4A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyhTbf5Rwq+x/FqURxmvXTgbBbUrqddZcLOIy9RZDFNEWVTrgd
	cHyME+iKSLW1YgplGyZZAOEoJmMxFjvByWS1l7bF4oZe1a+OoMDFmCE73GmLMSI=
X-Gm-Gg: ASbGncsE6yocsywdfPDOO3RBA/EwLNoXG6v6oJKWCizq2dGzC5rHxpfwbE+zAnoGddz
	oFpo/8655ICIjWJsmTlX22RwI+apoA2W9hh2OOXoa7IvZNHKCMb5uSXd8KV63yDLspt2BDUnBf3
	fAk1qr9uqmdurH3HrZOHr59ZJEJN7oHpunecd3Q6gVwPLgCb24RIJg9ClBQiFv0FSnKXdkvJrOy
	9ZBZ26cQ4D2mTsVAA2psd5zVY3L209sROUo0UcYV2u+rW16I5L4NFDI8gebpiaGXJ5gHGo2sQvR
	aAxfI1hdIS7l+JXwBlRyUlo/Fw5hMCvkdfqLJRZ5vv08psZBEsUTDM6YQq9NL23FbGo=
X-Google-Smtp-Source: AGHT+IGWbBJAtL2UtKSWCS6Jd9Ns/0Md8Y1s79IB++xb28sgasLU0+0/qaH46F3zNCw25wym7QqlJQ==
X-Received: by 2002:a17:90b:3b4b:b0:2ee:fdf3:390d with SMTP id 98e67ed59e1d1-2fc4115087fmr15333822a91.31.1739827918683;
        Mon, 17 Feb 2025 13:31:58 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d53491d4sm76091525ad.4.2025.02.17.13.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 13:31:58 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tk8iZ-00000002XxN-2C1Y;
	Tue, 18 Feb 2025 08:31:55 +1100
Date: Tue, 18 Feb 2025 08:31:55 +1100
From: Dave Chinner <david@fromorbit.com>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, Neil Brown <neilb@suse.de>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [RFC] mm: alloc_pages_bulk: remove assumption of populating only
 NULL elements
Message-ID: <Z7Oqy2j4xew7FW9Z@dread.disaster.area>
References: <20250217123127.3674033-1-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250217123127.3674033-1-linyunsheng@huawei.com>

On Mon, Feb 17, 2025 at 08:31:23PM +0800, Yunsheng Lin wrote:
> As mentioned in [1], it seems odd to check NULL elements in
> the middle of page bulk allocating, and it seems caller can
> do a better job of bulk allocating pages into a whole array
> sequentially without checking NULL elements first before
> doing the page bulk allocation.
....

IMO, the new API is a poor one, and you've demonstrated it clearly
in this patch.

.....

> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 15bb790359f8..9e1ce0ab9c35 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -377,16 +377,17 @@ xfs_buf_alloc_pages(
>  	 * least one extra page.
>  	 */
>  	for (;;) {
> -		long	last = filled;
> +		long	alloc;
>  
> -		filled = alloc_pages_bulk(gfp_mask, bp->b_page_count,
> -					  bp->b_pages);
> +		alloc = alloc_pages_bulk(gfp_mask, bp->b_page_count - refill,
> +					 bp->b_pages + refill);
> +		refill += alloc;
>  		if (filled == bp->b_page_count) {
>  			XFS_STATS_INC(bp->b_mount, xb_page_found);
>  			break;
>  		}
>  
> -		if (filled != last)
> +		if (alloc)
>  			continue;

You didn't even compile this code - refill is not defined
anywhere.

Even if it did complile, you clearly didn't test it. The logic is
broken (what updates filled?) and will result in the first
allocation attempt succeeding and then falling into an endless retry
loop.

i.e. you stepped on the API landmine of your own creation where
it is impossible to tell the difference between alloc_pages_bulk()
returning "memory allocation failed, you need to retry" and
it returning "array is full, nothing more to allocate". Both these
cases now return 0.

The existing code returns nr_populated in both cases, so it doesn't
matter why alloc_pages_bulk() returns with nr_populated != full, it
is very clear that we still need to allocate more memory to fill it.

The whole point of the existing API is to prevent callers from
making stupid, hard to spot logic mistakes like this. Forcing
callers to track both empty slots and how full the array is itself,
whilst also constraining where in the array empty slots can occur
greatly reduces both the safety and functionality that
alloc_pages_bulk() provides. Anyone that has code that wants to
steal a random page from the array and then refill it now has a heap
more complex code to add to their allocator wrapper.

IOWs, you just demonstrated why the existing API is more desirable
than a highly constrained, slightly faster API that requires callers
to get every detail right. i.e. it's hard to get it wrong with the
existing API, yet it's so easy to make mistakes with the proposed
API that the patch proposing the change has serious bugs in it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
