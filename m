Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFBE12EBF6;
	Thu,  7 Mar 2024 16:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709827985; cv=none; b=FFnufvFdzioBHqXOIjEgcvL/DTumtzmFTKOK8qGQEjjjAmM1+dex+W0D79rTbPCfBI9vlXJ22nTVLIj0W6qn83B/xDPB6M/S3k79Zf3kZChgC4w+QYLBNoxrmlrArWXhkD/afex+C80/Nip6GugC+fV72jCH8a4VEIOi5Yp0LE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709827985; c=relaxed/simple;
	bh=xC1nCyIdKfL4m5uxzrpTcUTAtu9QopfH5IwbC6GR/Jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kHMUe9eJvH+9saNXF6z2bGcb79uU+ANyFzASogpxJPRZTG64RsI3ZKn6wo/xtvXOnya85hpsE3TYT9DQ3wx/kthtuwj6UEHLgToEZ30hSjRuENdcgqjIVuMe14nKWK62xxiC/L630A670PjztJQIFAkjzr9Yob/26pGSOibZSog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvRGLSAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvRGLSAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E22CC433F1;
	Thu,  7 Mar 2024 16:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709827984;
	bh=xC1nCyIdKfL4m5uxzrpTcUTAtu9QopfH5IwbC6GR/Jc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hvRGLSAaI+Dj1v8Ns8E2YMT/aIg2qkVtfF41SYs2ai/Lb+l4FNRN9zdrwfKA2fP+a
	 JIMn/Zw4oX9/RtaPWJ6LCgN/u5/D0Usfs1Jeo78MwSebqSqIFbFmqaUWUEGJogQM10
	 4ZGQLEJbtcWbaQ5sIM7jvdSYQr/M+TZmlXG5Kh4Zlt7agYYkpajiGg7PcgJfs+pKTA
	 +DqlSsogpGznDgdfoTVj8kEzUNOJpiRVwSrEin//Pn52BowxeD7IcRCO1Bwd8XV+qO
	 6C8xCwPl68C5746bJ0zNfF1Rzn2MnJqR9kawwW0PczkzAAMAVIsRLaMDBTliLIvWM4
	 1PQ2Or2UF3N8g==
Date: Thu, 7 Mar 2024 09:13:01 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Chandan Babu R <chandanbabu@kernel.org>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] ext4: switch to using blk_next_discard_bio directly
Message-ID: <ZennjRhWR2PVtoGU@kbusch-mbp>
References: <20240307151157.466013-1-hch@lst.de>
 <20240307151157.466013-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307151157.466013-7-hch@lst.de>

On Thu, Mar 07, 2024 at 08:11:53AM -0700, Christoph Hellwig wrote:
> @@ -3840,12 +3840,16 @@ static inline int ext4_issue_discard(struct super_block *sb,
>  	trace_ext4_discard_blocks(sb,
>  			(unsigned long long) discard_block, count);
>  	if (biop) {

Does this 'if' case even need to exist? It looks unreachable since there
are only two callers of ext4_issue_discard(), and they both set 'biop'
to NULL. It looks like the last remaining caller using 'biop' was
removed with 55cdd0af2bc5ffc ("ext4: get discard out of jbd2 commit
kthread contex")

> -		return __blkdev_issue_discard(sb->s_bdev,
> -			(sector_t)discard_block << (sb->s_blocksize_bits - 9),
> -			(sector_t)count << (sb->s_blocksize_bits - 9),
> -			GFP_NOFS, biop);
> -	} else
> -		return sb_issue_discard(sb, discard_block, count, GFP_NOFS, 0);
> +		unsigned int sshift = (sb->s_blocksize_bits - SECTOR_SHIFT);
> +		sector_t sector = (sector_t)discard_block << sshift;
> +		sector_t nr_sects = (sector_t)count << sshift;
> +
> +		while (blk_next_discard_bio(sb->s_bdev, biop, &sector,
> +				&nr_sects, GFP_NOFS))
> +			;

This pattern is repeated often in this series, so perhaps a helper
function for this common use case.
