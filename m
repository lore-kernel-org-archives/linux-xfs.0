Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A83C21CC64
	for <linux-xfs@vger.kernel.org>; Sat, 10 Jan 2026 01:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768008321; cv=none; b=AMtUO2uR2zONB14k7MC6SmF8HJpcn8ZeyKAYwP5mgAyFWg3UMJRBVDHFafAZf2d0aDh+WRug6uOIJMFytdd1ZMOdk+g4LhXzywtL4aJdRl8X31dQK73XMf5BYcLfmMKvvOttMQAehtvl8nY/ngL4in5IymFav6Opw5/Jtd4c5sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768008321; c=relaxed/simple;
	bh=E+XIu1dzYyu4VNdArFeirnzhyMvwByIvxV80G0MnCiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PQbyLX0V1EFNaoLA+HMzbDjBgssSrsPR/qatIEJ2Cp8y6j7pk0skyX2txyScCzCjsq2xrohjcIpne7OMcQTln/3VTRA+MQzYqslJCS+mni9N1/DYp4Fi6xu9YyOXUNWL7Q9Y9C09bL8IRqW2Rwkd6RqoCOK+R10RAZW2B8tQAZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTjV9w42; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTjV9w42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD264C4CEF1;
	Sat, 10 Jan 2026 01:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768008320;
	bh=E+XIu1dzYyu4VNdArFeirnzhyMvwByIvxV80G0MnCiQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bTjV9w42MGqlf2LRnyNjCZcIVcJqByDwVRgojHx+Si3E1krZQYBO6iu1u8Z1haXMT
	 eXFopJXDrffrT3hTd2W+I7vUY9kDXQsS1CmzKrGL5fSR4iBxypm7gXAIh9QZrA1htd
	 KXvxVgExRzv6Bdy8B2ta7E/oDtw+9jNuVbdbLvj9nydLhdTiY+XfSdSOYshXKJJ700
	 GK7QLIFJMDFy+iP/WWxa5/dSU79CHU0CUZud3JaN7rqvXBzwJQGoUOgvqMGmQqzHh+
	 4jl3HgKkAz1XFSmKUyfFD6rx+QvYQcKuDV7pmJmnF6hA2vEXwwnMFFkNUme4wEo34q
	 r0LmCn1CwYv8A==
Date: Fri, 9 Jan 2026 17:25:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: check that used blocks are smaller than the
 write pointer
Message-ID: <20260110012520.GY15551@frogsfrogsfrogs>
References: <20260109172139.2410399-1-hch@lst.de>
 <20260109172139.2410399-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109172139.2410399-6-hch@lst.de>

On Fri, Jan 09, 2026 at 06:20:50PM +0100, Christoph Hellwig wrote:
> Any used block must have been written, this reject used blocks > write
> pointer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Oops, we missed that :/
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_alloc.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index d8df219fd3b4..00260f70242f 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -1033,6 +1033,13 @@ xfs_init_zone(
>  		return -EFSCORRUPTED;
>  	}
>  
> +	if (used > write_pointer) {
> +		xfs_warn(mp,
> +"zone %u has used counter (0x%x) larger than write pointer (0x%x).",
> +			 rtg_rgno(rtg), used, write_pointer);
> +		return -EFSCORRUPTED;
> +	}
> +
>  	if (write_pointer == 0 && used != 0) {
>  		xfs_warn(mp, "empty zone %u has non-zero used counter (0x%x).",
>  			rtg_rgno(rtg), used);
> -- 
> 2.47.3
> 
> 
