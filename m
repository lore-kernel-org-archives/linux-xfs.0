Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7DA2153E1;
	Thu,  9 Jan 2025 09:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736415571; cv=none; b=pL4vUYFdydPGBtBzgTElRbkyYvTKoeOJ+Zlpbgyax5yJDijLKqS3sBv3QPCY8tHVUR4ah9Hv4Lqdrr2Qqmd2LKa7atLiiIMXAAlLJhcC+xcgShrP3L5ADt6l2G4hgD6NI5AeFXF1UErDahyAkhSqDO53r4pZUvXuzNdfWYkXj6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736415571; c=relaxed/simple;
	bh=R4HzmAhYOWclja8jiOwi+tr9IhC7PnTpkrBdj9Olul0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0otlf5RuAYFz/Dy9mwXGAyp9xxSWS21f/s3g89F5SKwZ3Bu04RdpwQ4yjsyl7dQlf9zPnPUzkChkzSqJZq4A58OkXliFT+aRj+ckHARsxHUad6GHCDUOFGT45yBRltrLLWzWQ+ZmEj3BgBElXvbZwOIAuhoBx+mlCpEzS2klR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qvd0zMxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qvd0zMxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F5DC4CED2;
	Thu,  9 Jan 2025 09:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736415569;
	bh=R4HzmAhYOWclja8jiOwi+tr9IhC7PnTpkrBdj9Olul0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qvd0zMxlwprXlWGGFjx12Nrgcy8Gy5XtTwUGYCWWrjdJzfl5F0OqL2gXRENNYFhbp
	 MaIsyhOjjIBz88tpiz1EMrI8YTZnX1ib8MAjThjdrMHHdEowZxfmsDXu55NDDujciy
	 DaXnn1ydWmKr1uY7gtZJJkBTakjQf/OHG9T5DmrS6OFHgjQ+dEsM/UBXtyimM2u7iE
	 oWWde7mMTKTSOH0IqUz+fG2uW7U/xI+3qo6OHiEBrjJZWzrgfcXDfaNKVn4V4Rn3OG
	 iqrlovF7J2xVWC3COkmtX529YQcYlOWZ5Aen5Agv7yEtC6GUfsCvIdvCRtojcv73tl
	 aC2DMnistFwQQ==
Date: Thu, 9 Jan 2025 10:39:25 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Pei Xiao <xiaopei01@kylinos.cn>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] xfs: use kmemdup() to replace kmalloc + memcpy
Message-ID: <7c3kfhrtjpxrw44u44pow2un3q463w3qkiend2j374ixjqtfvb@rl33jhp7cmmu>
References: <37bbe1eb5f72685e54abb1ee6b50eaff788ecd93.1735268963.git.xiaopei01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37bbe1eb5f72685e54abb1ee6b50eaff788ecd93.1735268963.git.xiaopei01@kylinos.cn>

On Fri, Dec 27, 2024 at 11:11:13AM +0800, Pei Xiao wrote:
> cocci warnings:
>     fs/xfs/libxfs/xfs_dir2.c:336:15-22: WARNING opportunity for kmemdup

https://lore.kernel.org/all/20241217225811.2437150-4-mtodorovac69@gmail.com/

> 
> Fixes: 30f712c9dd69 ("libxfs: move source files")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202412260425.O3CDUhIi-lkp@intel.com/
> Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
> ---
>  fs/xfs/libxfs/xfs_dir2.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 202468223bf9..24251e42bdeb 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -379,12 +379,11 @@ xfs_dir_cilookup_result(
>  					!(args->op_flags & XFS_DA_OP_CILOOKUP))
>  		return -EEXIST;
>  
> -	args->value = kmalloc(len,
> +	args->value = kmemdup(name, len,
>  			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_RETRY_MAYFAIL);
>  	if (!args->value)
>  		return -ENOMEM;
>  
> -	memcpy(args->value, name, len);
>  	args->valuelen = len;
>  	return -EEXIST;
>  }
> -- 
> 2.25.1
> 
> 
