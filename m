Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9702948F846
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 14:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185819; cv=none; b=E/nntSFeQBDxLpoyetkuZa6WKlS9FwvAgqGHCfyijjqrKQS51+eCTsqJf/v7uxqivbIGIyrgLkN9P7TPCkHzesH2jaUR0Ex1PWJqoN+u3JgocizE6BT5bWrffuM/sBO7KwiKG9fhh3QfhI1BLbBuieHOdaI9rXBVodlQksAkuRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185819; c=relaxed/simple;
	bh=RpDC4fwoOJppmPQ0nKLTsquL2LUvooTUx84DMR6Jw9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z8WNubnUz/KpXHW6AJmsDcEEmtcPBd5K28bXCbLBhJ1eo7VQNVG5G9tbfudS3l0AxWktwWtBO6NLpmiY/JsNC6bjM3Eyok+DZy5XXzgrqSN15Ct3FVHbP6PJqFRxM7OFCmr6btqT0v5t8uXeEvKiCpxbCI50iehHWay6g4QLeMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kefdULjm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kefdULjm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 291A51F000E9;
	Mon, 31 Aug 2026 14:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788185818;
	bh=/pHd4uVunHb3YuiuVtl8rJUCalKiPHHIDQGvilyEC2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kefdULjmv6jrfVMpDGDnVaHXgeFytEiFS76dfShybZ555/CEiX5tMRjkSh1nLn3Px
	 kbl8tInvnzYbOliNURCr7x5i4AGt9mo7MR4/i/NKiMP6QFzp3n47SK9Zi+Yb20iIfh
	 32NZl5+dAG/fiQ7+QiwdA1tc4VUxbWYR4yqQOVGfod29ZdcJ+pNGDeJCOImmCfieWt
	 3JWSl66CeMU5Vxum+pkrWpwS7hcqKnO9QI2UQZgWqCYQY0s2lt/I7Hj0dEm9DFRJjy
	 nwJu/jPbZiBx/+1bWNWP5lqa1wHAnnrFqoxCXn/ihxOv29Dyi+q46691oEVo2LO0Rh
	 Q9Y6baDAWCb+Q==
Date: Mon, 31 Aug 2026 07:16:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: release alleged child inode on metapath unlink error
Message-ID: <20260831141657.GD6072@frogsfrogsfrogs>
References: <CGME20260831064229epcas5p3825244c86e28b11019cdd2ce90c16eff@epcas5p3.samsung.com>
 <20260831064157.758165-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064157.758165-1-anuj20.g@samsung.com>

On Mon, Aug 31, 2026 at 12:11:57PM +0530, Anuj Gupta wrote:
> If xchk_metapath_ilock_parent_and_child() fails after xchk_iget()
> succeeds, release the inode reference before returning.
> 
> Fixes: 0d2c636e489c ("xfs: repair metadata directory file path connectivity")

I have a patch just like this one in my branch so

Cc: <stable@vger.kernel.org> # v6.13
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/xfs/scrub/metapath.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
> index ff1ff762b300..79fd69d2de68 100644
> --- a/fs/xfs/scrub/metapath.c
> +++ b/fs/xfs/scrub/metapath.c
> @@ -550,6 +550,8 @@ xrep_metapath_try_unlink(
>  	}
>  	if (error) {
>  		xchk_trans_cancel(sc);
> +		if (ip)
> +			xchk_irele(sc, ip);
>  		return error;
>  	}
>  
> -- 
> 2.25.1
> 
> 
