Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD803F39FA
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 23:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790378842; cv=none; b=MBcG434SzKhJ1zj17uKH9jHrA7Ygq35oQHTxWf+zyjImwD7kGffl3k5WWUWX5A+SaxMBvrhb4VHXPiyB9GtedkudA/A+om/yTZ9B8ZNbiHI4ry3fzZk/bDgFi2ox5iui5lJOXMkfqXV/4qCh5EWK9ah2J8zDzW134AbW3Dto5Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790378842; c=relaxed/simple;
	bh=nTJ7f7S+Qqm3oydXUfanvJaHQXR2fMZQc93m8b67k8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BiUIC0YWycU4ATK5VkJKDRmGMXhPz/yzBteoyu5zIo+YlLwVPrIfx63AlnFr0jTjdfOH25cCF/rraphQ97p6kHuOcXgDe+SecSKS/MMu0aXL8TkSzkeN2KJW8bz+mJPHlo+KkkWnrG4qldpkrvM3+3uZYozLsdkiH/HVPlYu1xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwBvHIeJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwBvHIeJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C14E11F000FF;
	Fri, 25 Sep 2026 23:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790378840;
	bh=qMQxxeH3ZU+7OgMc95+87ZKhlsF2ewh6x5Z5qlIfVAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jwBvHIeJd7sY8I0aYxyWKZ0BS3gfUHJ58XpRehzgKCqsKY0BgsLEqGnmyxxQb4JbR
	 2EdH4Rk7rSqFOlPn6VdbtKb1Pp2HGjrVT+lT0ToKlBx5iueXKSyiEObSQLb5LL7ff2
	 HgQMmwCMNxbcfKuVI3VH11GWwCD5AEy2J+A7DfA8ncKvWdTWWaLzZzgaIvO9ng2PvH
	 HaUHV+OvuYL9ECIHAXXj8BE7tIC+H1yh8yGtEauxPWxR96HPEVs+qaJNZNm5qdqWbo
	 ul6dec6IVXICKSRf63atreoSERZmI2Lc1DmPMtWw1K5JsoHn1NmpxDXjr0pOOgoKSE
	 +/su4NH1f01vw==
Date: Fri, 25 Sep 2026 16:27:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/32] libxfs: remove a spurious xfs_rtbitmap.h include
 in xfs_sb.c
Message-ID: <20260925232720.GI2705364@frogsfrogsfrogs>
References: <20260924100512.2733748-1-hch@lst.de>
 <20260924100512.2733748-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100512.2733748-6-hch@lst.de>

On Thu, Sep 24, 2026 at 12:03:55PM +0200, Christoph Hellwig wrote:
> This fully resyncs with the kernel version.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/xfs_sb.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
> index ea99f8b5eee5..cccbcd153316 100644
> --- a/libxfs/xfs_sb.c
> +++ b/libxfs/xfs_sb.c
> @@ -27,7 +27,6 @@
>  #include "xfs_rtgroup.h"
>  #include "xfs_rtrmap_btree.h"
>  #include "xfs_rtrefcount_btree.h"
> -#include "xfs_rtbitmap.h"
>  
>  /*
>   * Physical superblock buffer manipulations. Shared with libxfs in userspace.
> -- 
> 2.53.0
> 
> 
