Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437B8BA33;
	Wed,  5 Mar 2025 02:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741141314; cv=none; b=SkTkY8JOBWA2VJsWMV2TpSkm45sPE+I0qpPB7MUgAnFAGnCbAizXpUHwKwjli1q0UVrHZ6qVZCUvOuLBa+X7GlLMVgaqxBQRDNKhwTOBSsPCQrHMPXTTV7Ml3sNC6mRVVKkq2VHQwoHftzlXbQZfh7MnOP1beO0wOprSYK+NHS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741141314; c=relaxed/simple;
	bh=UO/TvK4vKOHMd2HwznLJIieYDqfvKmx0FSgvO5v2Y/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQqi737GXXpbt3/NyfQQ3+xmSM+4VlUoa/Ce2tuSMY8BG2z6RKYOHVuL5vYx/+bbnwAzqTOTRoQmWtdr+5XLHFfu1wj1fWkfRh1fnP+RVycy4yLClPeeYdkKGHZu6AiFttZlySDmAEat3u6aEX3LerEnLvIDdmE1CXeAZF7C95w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cy8R0kju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cy8R0kju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEA6C4CEE5;
	Wed,  5 Mar 2025 02:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741141313;
	bh=UO/TvK4vKOHMd2HwznLJIieYDqfvKmx0FSgvO5v2Y/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cy8R0kjukfj4USuc6R+O+CL6gF0wlG6SeDI8udpTBzIFwHkLFRxXc2VLh6EOvG/lu
	 KQCIoDWErXR8jSwhWIvROBt0u7xqX9cznPNq4CVSQC4Be7lqmfTtn1zD6K+Vdmjlpt
	 mlFckezMHilur50GFlGZhXEi5SqJxYYxfsPxGYwjmTZ950pBIFpPDDfYSH3cocix2m
	 G4jtoJUCGRhHP2QPzOP6JbXLhrzSpu12OgJfirexaFSS/H2KwGL60I8iBSK/yfs7Oh
	 qN8jbTSDe8zqNYhSBI7t2Ae5TXvmsOUWRGrET4v5LmLrVMwPQ9yZF+8w1qa3gfxn19
	 7GDxbNhZtdrVQ==
Date: Tue, 4 Mar 2025 18:21:53 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Carlos Maiolino <cem@kernel.org>, linux-hardening@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Replace deprecated strncpy() with strscpy()
Message-ID: <20250305022153.GC2803771@frogsfrogsfrogs>
References: <20250305011020.160220-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305011020.160220-2-thorsten.blum@linux.dev>

On Wed, Mar 05, 2025 at 02:10:21AM +0100, Thorsten Blum wrote:
> strncpy() is deprecated for NUL-terminated destination buffers. Use
> strscpy() instead and remove the manual NUL-termination.
> 
> No functional changes intended.
> 
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  fs/xfs/xfs_xattr.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 0f641a9091ec..9f9a866ab803 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -243,9 +243,7 @@ __xfs_xattr_put_listent(
>  	offset = context->buffer + context->count;
>  	memcpy(offset, prefix, prefix_len);
>  	offset += prefix_len;
> -	strncpy(offset, (char *)name, namelen);			/* real name */
> -	offset += namelen;
> -	*offset = '\0';
> +	strscpy(offset, (char *)name, namelen + 1);		/* real name */

Please read the list archives before you post:
https://lore.kernel.org/linux-xfs/20230211050641.GA2118932@ceph-admin/

If anything, memcpy() would be appropriate here.

--D

>  
>  compute_size:
>  	context->count += prefix_len + namelen + 1;
> -- 
> 2.48.1
> 
