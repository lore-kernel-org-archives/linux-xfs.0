Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541F1238D53
	for <linux-xfs@vger.kernel.org>; Wed, 12 Mar 2025 09:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741770857; cv=none; b=PiBRKVzPtxRHLJGGPCeOhOy4KH64BdjvZf6agd3dmWm09tcqX2vV8vC1iMTLdkQYZ9/NDRMyPeZgkFPm0bqpjOVHaPbnLSLE4kBT1iE7S34cEH4t/KyFEFGkyYJ7TWg/VuCJv7ShQO65pwdoj3sKvxh4jOcYY/Ohtt6OrBvNrdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741770857; c=relaxed/simple;
	bh=KBC7fOkggUgqzCaGgzx62K+5B0PFWfyBzRR5bQeVA/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R4z47J6BrzdwSRUPRTkvpEP3RFXc7f1Lp/8TWunvwitOXWb+QMKd5CF7XXheyz4rY+quRKpL5TAgzZUllwGpMoiySCjwtb4j/9ZIouml5ydjQNbAf21rP1TCZgs2zwW63UOIw620mZYaCyPqIv+E2FNn/ExGgwuwGuwpvIn6UAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fk72MKCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fk72MKCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AF5C4CEE3;
	Wed, 12 Mar 2025 09:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741770856;
	bh=KBC7fOkggUgqzCaGgzx62K+5B0PFWfyBzRR5bQeVA/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fk72MKCPNX3H9u2lTLS/RcFYUBPQ7ESxrIqjIcyZ+gKAmyIzHbJ32hLgjtMwx6yMx
	 vcsN7Pw4HI1Vzq8wehWv4bF91EeQR9r3tkcAvVwbGuHP9axQlRo7RdP4GfZ7W2ks+W
	 fhXKbk0i48wPQDSnhkiXVc1tpD7OBcdwvFijJ5yDcUdxYJ1RUbxSNUBVK+gAJSBik7
	 Y8SfAeze4Ckem9RyF9pHvyy7odL9xj1/72wI9QPEaQomMqQrqb/a5O0jJKqruKn6lK
	 5XSNW1Uoes4C6hr21uO11PSTXWgIptHXUF+6sE3kLrJ5Drdl00KDhuUNSfW2dM5u/r
	 9D1fIodGwxsKw==
Date: Wed, 12 Mar 2025 10:14:11 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] xfs: remove unnecessary NULL check before kvfree()
Message-ID: <tkqfwlodumie2f5vmsnsahgl4muhskegoyw45syfve76qsghhb@6lbtjw5s3g7c>
References: <IySo_CiLjmuD18-2-n_AWMvhnMyxkXYkQriJtpVjhByicX1b8jarFYq_ocna0QKIEAQtZQOlmgGo7B41CDTtJQ==@protonmail.internalid>
 <20250311071114.1037911-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250311071114.1037911-1-nichen@iscas.ac.cn>

On Tue, Mar 11, 2025 at 03:11:14PM +0800, Chen Ni wrote:
> Remove unnecessary NULL check before kvfree() reported by
> Coccinelle/coccicheck and the semantic patch at
> scripts/coccinelle/free/ifnullfree.cocci.
> 
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>

Looks fine, please rebase it on top of for-next and send a V2.

Once rebased, feel free to include:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Adding Christoph to this as he cares a lot about this code.


> ---
>  fs/xfs/xfs_rtalloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 57bef567e011..9688e8ca6915 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1144,8 +1144,7 @@ xfs_growfs_rtg(
>  			goto out_error;
>  	}
> 
> -	if (old_rsum_cache)
> -		kvfree(old_rsum_cache);
> +	kvfree(old_rsum_cache);
>  	xfs_rtgroup_rele(rtg);
>  	return 0;
> 
> --
> 2.25.1
> 
