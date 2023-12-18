Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2360737889
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 12:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/VisHO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2810C433C8;
	Mon, 18 Dec 2023 12:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702903912;
	bh=K4D2H9rUf4wyQ70NIURJS2YDkUes1+ov+0XB1Y+SMI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P/VisHO0ffFEXAWbomiTQFUL8jkNv7jWQ1elGEbm+OcQTciTCod6Bk1piXbENVFHA
	 y+PEWmq5rUhQi/0ZAfhNDfBJ/tx3U3m/STT2TsBlaWPw2RF8mY5WffDgid+aGcBtmL
	 +fpkESyIRFCjCTtf7TDsQYbHYbOyiFt+aextKzXb+Irt9ofXCAw4+ZPN76nVpIi5d3
	 a8zXe4zPOxYybaF+Te12f2yrTHlxRyhWJPNgK2ozyZw8AybLI7ro4xLc5Cg/uDuV5o
	 Vqj19QWDPUPMwKWnSAThrmWS1sJHwF8mHo9eQ6K3/qUlyCwRSzrfrIzRH42nrC17+q
	 oLrJs71/QzfyA==
Date: Mon, 18 Dec 2023 13:51:47 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/23] libxfs: remove dead size < 0 checks in libxfs_init
Message-ID: <tjw72xdjhqm7uthawvk5lxghain5cguqldlbcnlgb5xefonkno@5r4xzwwl6n37>
References: <20231211163742.837427-1-hch@lst.de>
 <OnLZiDUcLnVq1NHB9phtPnhC2lQ8EH3h44VJPD-HdSyqU-AeXwonDSb807GwmzM6kDUB3GmxH1QjpILt3nbpaQ==@protonmail.internalid>
 <20231211163742.837427-18-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-18-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:36PM +0100, Christoph Hellwig wrote:
> libxfs_init initializes the device size to 0 at the start of the function
> and libxfs_open_device never sets the size to a negativ value.  Remove
> these checks as they are dead code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  libxfs/init.c | 15 ---------------
>  1 file changed, 15 deletions(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 5be6f8cf1..87193c3a6 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -329,21 +329,6 @@ libxfs_init(struct libxfs_init *a)
>  		platform_findsizes(dname, a->rtfd, &a->rtsize, &a->rtbsize);
>  	}
> 
> -	if (a->dsize < 0) {
> -		fprintf(stderr, _("%s: can't get size for data subvolume\n"),
> -			progname);
> -		goto done;
> -	}
> -	if (a->logBBsize < 0) {
> -		fprintf(stderr, _("%s: can't get size for log subvolume\n"),
> -			progname);
> -		goto done;
> -	}
> -	if (a->rtsize < 0) {
> -		fprintf(stderr, _("%s: can't get size for realtime subvolume\n"),
> -			progname);
> -		goto done;
> -	}
>  	if (!libxfs_bhash_size)
>  		libxfs_bhash_size = LIBXFS_BHASHSIZE(sbp);
>  	libxfs_bcache = cache_init(a->bcache_flags, libxfs_bhash_size,
> --
> 2.39.2
> 
