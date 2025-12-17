Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6D6288AD
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 05:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765951064; cv=none; b=QpjOJLGo0GG1PS0bBI27cVrTY81q/OtvF9Uy5eA4qVb9FwxqwS0Vo+wYYILbfduVPcuWRwGqRIw+aES24XctHdwI0t6bn2iXpT2RhI3W7YqLU1JLXGy/bDV1Vhi6ne5ww6cN2AnBytwMoFBZwX7YR9olUno5V+2KlxMWBbPYIEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765951064; c=relaxed/simple;
	bh=KFTAFw/YrSyP9qcnrSP+UfETMqtZY074AgBYSnqTx1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8BQ7hIOuMd1V3ZxnGTAI38dSzBd5AkLM5zwYshXF7+mPLmdYg0vjOTBxsTEeg05Xx7h4xO1iz2B0RRlEnPNVg6f5riTP76dWwPF7F4poNIfdR+aj9HMoAnk/TLtVpzNyN4o2JBVpM18Gy4/je85E5H1KeYOLQt9ljLtmpfdfr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EoF+Eofz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EoF+Eofz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61719C4CEF5;
	Wed, 17 Dec 2025 05:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765951064;
	bh=KFTAFw/YrSyP9qcnrSP+UfETMqtZY074AgBYSnqTx1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EoF+EofzaiyfhclK5l6A5Sn7NzsLIKtlU2ZL7WZcLaWwc70PY3Cpm0gcSmzYfA649
	 OeRaYbuztgJAACkj2znQmJSzFPFskLbZqk1dwo8ZyKCejmG8iEirnIEcRajtX48l/1
	 NzadaH6Kv1cfjL73xXVweoZ+BJjR3dIKQqj+SQ1cYLinVp8jZB2bSIGUNfVX678vZu
	 MSNIgw1ysu/aYrENmxI2j6I9ZcEQjBXwxoQYZUfNTPBNlAjFlxbzgaFGsK0X9sK6g7
	 uclt12ATZwUNp0OZPO0aHkRV9cvvIH6dO5ORr7nyXtuBajG+UHYmix4poPW23ZcPTg
	 oOw45bEctwyuw==
Date: Tue, 16 Dec 2025 21:57:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	hch@infradead.org
Subject: Re: [PATCH v1] xfs: Fix the return value of xfs_rtcopy_summary()
Message-ID: <20251217055743.GT7725@frogsfrogsfrogs>
References: <d4209ce013895f53809467ec6728e7a68dfe0438.1765949786.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4209ce013895f53809467ec6728e7a68dfe0438.1765949786.git.nirjhar.roy.lists@gmail.com>

On Wed, Dec 17, 2025 at 11:07:42AM +0530, Nirjhar Roy (IBM) wrote:
> xfs_rtcopy_summary() should return the appropriate error code
> instead of always returning 0. The caller of this function which is
> xfs_growfs_rt_bmblock() is already handling the error.
> 
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

Looks pretty broken to me...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 6907e871fa15..bc88b965e909 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -126,7 +126,7 @@ xfs_rtcopy_summary(
>  	error = 0;
>  out:
>  	xfs_rtbuf_cache_relse(oargs);
> -	return 0;
> +	return error;
>  }
>  /*
>   * Mark an extent specified by start and len allocated.
> -- 
> 2.43.5
> 
> 
