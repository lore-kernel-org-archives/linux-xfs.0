Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2757F33555F
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 16:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773678099; cv=none; b=K86q7qLRl4AIom0OQRfffnydhlW+AjPOiwiwk0Ufn73vcOvmASYzV3y/4OKtALsFVBg+Jyjbp1LQD1qJxhFuu4VN2iJyxHtxeEYOgtmQzb4AeX9SQEZu371jhZHNTwH/aEzCFn4uQAv1qvQJT21B8lrucZ7HSXaqdIrd8ouTAWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773678099; c=relaxed/simple;
	bh=ai1m6kD7Fx0MGVJ2TeRUaZACQymODiWZMFuzVXJ5jIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HdXfjD6Pv/KZfa6V78hnYVGxH8SnBMtkMACMzEUmJLaObXCH0EMWm+ihLwaJT2dXwRud6VbXQb443tA8lJfHlCXYFwLk5d/4K91fMKDUFHDMgBBL1KNiIOTvUX6tBSWu5v+EToOS6nmWzjj1eGnFeY8IERwjs0LoNsmUPYV/ut8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PIggXrz2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PIggXrz2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6iIOjt+frVv59VcI1HjeguSQw9AlDvqw+D+Ny3yWsdw=; b=PIggXrz2u4mw6cCTmijLxs5zPr
	hJ1nhwefzzp+kckWj4RRKGQSUtdAjRT5ilkuw6b95AWPeyVbcORBuVHV5EiwTgQQOtLnGR87BaX8Q
	lHlhvvbZqoaK2Ck+jychzIj4kYFsybSG3/DMCu/mVwKFJh+iHDbtYzosVwNsftlrZOTSNvZwj7wMq
	IGNAhnOO2qr1JP5NQ70h41yJv+dwW9b4M+eVoAcWjp905CjP29LGF4ajKZ6TQj5A0uqJGVtNfOU0F
	n5AHnq8JYUYzj2qVQX2iqlcYyI5SIV32hVe35lEw/kqmWmc4+0yBQKFqwB+3s3Dzqe+6qwDXEwAds
	wf/VmrGw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w2AhF-00000004RTz-3Fws;
	Mon, 16 Mar 2026 16:21:37 +0000
Date: Mon, 16 Mar 2026 09:21:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/28] mkfs: enable online repair if all backrefs are
 enabled
Message-ID: <abguES2dZ4Bcky5K@infradead.org>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401930.1183235.5546361742527693533.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311401930.1183235.5546361742527693533.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

It looks like this makes xfs/805 unhappy, as it does not expect
autofsck to be set by default.

>  1 file changed, 9 insertions(+)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 527a662f3ac858..f859626afdda36 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -6296,6 +6296,15 @@ main(
>  	if (mp->m_sb.sb_agcount > 1)
>  		rewrite_secondary_superblocks(mp);
>  
> +	/*
> +	 * If the filesystem has full backreferences and the user didn't
> +	 * express an autofsck preference, enable online repair because they
> +	 * might as well get some useful functionality from the extra metadata.
> +	 */
> +	if (cli.autofsck == FSPROP_AUTOFSCK_UNSET &&
> +	    cli.sb_feat.rmapbt && cli.sb_feat.parent_pointers)
> +		cli.autofsck = FSPROP_AUTOFSCK_REPAIR;
> +
>  	if (cli.autofsck != FSPROP_AUTOFSCK_UNSET)
>  		set_autofsck(mp, &cli);
>  
> 
> 
---end quoted text---
