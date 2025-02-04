Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DBE212FAC;
	Tue,  4 Feb 2025 19:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738697035; cv=none; b=RhasKwA5KadX/0lo5WgW7ikjWqMBnbjkI+bi8AKD/q1LxlRC39pBD+14SuOVsVaSTbPu153KjKe/PVgd8hDBIt2iXpWdOifOuYvia0B4s9am/KvR1QY4sbp0HAVrxm8/Hh2DBuSEQtfNnQJ7KrgYIZMtaYKd1baNebnbNghQr2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738697035; c=relaxed/simple;
	bh=Sc3EZq3B3Zm2BPXTJ7RHUln+xNczbqvz3bUxdNLt68s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/svqkzCupV8YGdrJgOcUQRFHhymGUR+gxgp5G1BoExXz6/kC6+mtRPRJIgiP263evjjvy3Mo3h7f3mB1XV2Wzx0byXvHmEhYe2wzBJMPaUxpsrlFfIMzOTazsTD9c+x1Mg2Udwo/iTQiZTWCCTgO79Hiy/hceoQIEbTIYPZmcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Whc6B3rN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Whc6B3rN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABAEC4CEDF;
	Tue,  4 Feb 2025 19:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738697034;
	bh=Sc3EZq3B3Zm2BPXTJ7RHUln+xNczbqvz3bUxdNLt68s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Whc6B3rNu6a3vlrgzrwGlhE0opUM2tqdr/tRzmvLj0j/qqSlZJNUuueyt4STO4tRZ
	 dS35WjS9Gc0AGvt7MWHXey7uKyX27u0y/ee7Nahic+FXT15xaxNQTp6fgCE7Pr7A3d
	 GmtuB+WsZRsZ4S6deheC8rJTTKIJoIndJFYdY11Tm1hh5+fKDB5bklKEbUKCkLaX6c
	 XwcQVVH0z0uZK8BN8uD1z6e/4AqGrn1c+OjqRfpGDkBoyaQYUFCw4f0K7/AmHUZT7S
	 VEL+0GlCCSDlQoT3HHPCSQV65co5MKRAmaWGbOPoj1Nf3hcSEw9RuzbNaYQwLfDJMF
	 kAen+9Jx1sjbw==
Date: Tue, 4 Feb 2025 11:23:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 04/10] iomap: lift error code check out of
 iomap_iter_advance()
Message-ID: <20250204192353.GC21808@frogsfrogsfrogs>
References: <20250204133044.80551-1-bfoster@redhat.com>
 <20250204133044.80551-5-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204133044.80551-5-bfoster@redhat.com>

On Tue, Feb 04, 2025 at 08:30:38AM -0500, Brian Foster wrote:
> The error code is only used to check whether iomap_iter() should
> terminate due to an error returned in iter.processed. Lift the check
> out of iomap_iter_advance() in preparation to make it more generic.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/iomap/iter.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> index a2ae99fe6431..fcc8d75dd22f 100644
> --- a/fs/iomap/iter.c
> +++ b/fs/iomap/iter.c
> @@ -30,8 +30,6 @@ static inline int iomap_iter_advance(struct iomap_iter *iter, s64 count)
>  	bool stale = iter->iomap.flags & IOMAP_F_STALE;
>  	int ret = 1;
>  
> -	if (count < 0)
> -		return count;
>  	if (WARN_ON_ONCE(count > iomap_length(iter)))
>  		return -EIO;
>  	iter->pos += count;
> @@ -86,6 +84,11 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
>  			return ret;
>  	}
>  
> +	if (iter->processed < 0) {
> +		iomap_iter_reset_iomap(iter);
> +		return iter->processed;

Doesn't iomap_iter_reset_iomap reset iter->processed to zero?

--D

> +	}
> +
>  	/* advance and clear state from the previous iteration */
>  	ret = iomap_iter_advance(iter, iter->processed);
>  	iomap_iter_reset_iomap(iter);
> -- 
> 2.48.1
> 
> 
