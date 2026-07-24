Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741E64334DB
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 16:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784912201; cv=none; b=WCnboZoHNK8i79XrIIEzkwX6eIdQPldu/gHQdATwrL+oXJ7Ti08lEfBFxLiUx/hjP0n8sPxeiVaaVvDU0+4G+U7EWRCJ46UIBvwn9xbb1/SdEh27NEmeqfaNF1T7pRGTEg+VL8KLmOBpXjaaXupf4yd+nMC1PmKh6F3jME+vt3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784912201; c=relaxed/simple;
	bh=Y2KZsVk17CpaIe5lQ3k/yD6HMhhhtQ9pnyl1fsQ7egI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lMn2mu4tKk5DZlm2atNJb9WvbOx71JPEzOCle3KHmLDil8lExKkL/1+ZItLOzDQiC1a/ZkxlkUXJwjua2e8a8q3nvppDy0pBoqU6xv5o2D+3Fsp4kqKSAuAyAvczhgCZZMxPdd1UM1KwfS4As/FL9BOWXsLxibDDsCY3IjQzpIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqHcLCB+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqHcLCB+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1A66A1F000E9;
	Fri, 24 Jul 2026 16:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784912197;
	bh=beD+UXxSLcx89EDjmJiqWOxLBfD23KV5doa191N2bLU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PqHcLCB+P/fbsN+hDFbA82r+KyYbVAZqUc7N77BGGTKJOL9kPdusVRTI8XfsMKLoe
	 GbQoUlRA1oVzlhoY0qEfz7U0HiUnRN0xdPm0S4RF/0LfMnhkxBHCuzoUL8d9i3yQVZ
	 npbhFDiLNJahz6IbxJQ6n8uV3HGL3cJkOOLiMUoMimvKamnFo7EDPKH/yiZhJ3PWsv
	 uxet589Fm6MGrFGVL9KvIEhNE9xI6cNMs/O852vHiy+pSVgGTEXojRYzoyB0nxSFaP
	 lRyX5gHv31aqAClH4BixU7PldWdRfIpIorYEda3z+Oo6v0T88jT4b60FYWWU7qaoQP
	 8gXKcvnn34jhw==
Date: Fri, 24 Jul 2026 09:56:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: don't reverify buffers in
 xfs_buf_readahead_map
Message-ID: <20260724165636.GV2901224@frogsfrogsfrogs>
References: <20260715145147.95654-1-hch@lst.de>
 <20260715145147.95654-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715145147.95654-9-hch@lst.de>

On Wed, Jul 15, 2026 at 04:51:01PM +0200, Christoph Hellwig wrote:
> xfs_buf_read_map calls xfs_buf_reverify to ensure the verifier has run
> for a buffer before the data can be used when an earlier readahead read
> the data before the buf_ops were assigned.
> 
> There is no point in doing this in xfs_buf_readahead_map for a buffer
> already in memory as a later xfs_buf_read will do the same and can
> actually propagate the error to the caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 2a0a19172847..4430da3259f1 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -760,7 +760,6 @@ xfs_buf_readahead_map(
>  	trace_xfs_buf_readahead(bp, 0, _RET_IP_);
>  
>  	if (bp->b_flags & XBF_DONE) {
> -		xfs_buf_reverify(bp, ops);

Agreed, there's no point in tripping the verifiers and logging a bunch
of complaints twice.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  		xfs_buf_relse(bp);
>  		return;
>  	}
> -- 
> 2.53.0
> 
> 
