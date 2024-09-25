Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0496341C71
	for <linux-xfs@vger.kernel.org>; Wed, 25 Sep 2024 14:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727275512; cv=none; b=YzHonvtT9JiCPuS2vvQmAxFg8pzRFXUNCR8+/yccacA28HyWrJSCVe2c1rJ0RJC/PWEKHspUQCcRzXPGgjOVOdg/Y9smPWyWNRkWoON3roGT0yYOOczsYXehjz34SVQv5Dt9Ixa+YhVtGWbJ56mEX8udIZBIW3Sx5GpPSS0adTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727275512; c=relaxed/simple;
	bh=rvtppgw1DEnK2KMmTO/Rg1BTeH+CbCbVt5FkNgMWj20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nuvbhgNDtP4gjEwfqWv/zyxENe8X3QFeF5zQZfYGWUx+ZVb+v1pzOEJN5jBH8ZIjos05ByvYLeW1MZntJGP4NBgXjY4a6nQ9WkJOe7jF1kTEC0NNY+3nM6eeRpn/ea9mY47OA46CYgObwqNf+bditkuxdlQHHpzt0ZB0bTzZl7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWGEkdpN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWGEkdpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AFAC4CEC3;
	Wed, 25 Sep 2024 14:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727275511;
	bh=rvtppgw1DEnK2KMmTO/Rg1BTeH+CbCbVt5FkNgMWj20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MWGEkdpNK/o8+oY0qzIz3G4Ydy0ssKtv60M34F7burfGc6NurkCAFiAf0TovjNcE1
	 /Rp7uED0/zMH8lUUUnGYUGzYb97o6c9ev9EE0yQkKNMjTe3TJzG29Iu6oQrdLfx2jD
	 esJRvI9e9bmqC2TtckRhCyOUhyc0rZxFwxAow4hHa2Y0hvMOp7ZrptoIlvUema+nXJ
	 OqkvfyiPTEf8PgTijivfy/3Gc54lI64bShQ5ttsiC5q0D8OSYsGPVE6cnaZBOQ6f/Q
	 gOpEAMJ+xvtTkFH8k8Kf1CBVFsqbseXks69ywIMSirg4vqNQO56cLqzMwN3YSBQW9/
	 Hmb3uSzuLQ3Zw==
Date: Wed, 25 Sep 2024 07:45:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH] MAINTAINERS: add Carlos Maiolino as XFS release manager
Message-ID: <20240925144510.GJ21853@frogsfrogsfrogs>
References: <20240925115512.2313780-1-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240925115512.2313780-1-chandanbabu@kernel.org>

On Wed, Sep 25, 2024 at 05:25:09PM +0530, Chandan Babu R wrote:
> I nominate Carlos Maiolino to take over linux-xfs tree maintainer role for
> upstream kernel's XFS code. He has enough experience in Linux kernel and he's
> been maintaining xfsprogs and xfsdump trees for a few years now, so he has
> sufficient experience with xfs workflow to take over this role.
> 
> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>

Thanks for all your hard work this past year, Chandan!

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7387afe8f7ea..9d6ae8df2dc3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -25297,7 +25297,7 @@ F:	include/xen/arm/swiotlb-xen.h
>  F:	include/xen/swiotlb-xen.h
>  
>  XFS FILESYSTEM
> -M:	Chandan Babu R <chandan.babu@oracle.com>
> +M:	Carlos Maiolino <cem@kernel.org>
>  R:	Darrick J. Wong <djwong@kernel.org>
>  L:	linux-xfs@vger.kernel.org
>  S:	Supported
> -- 
> 2.43.0
> 
> 
