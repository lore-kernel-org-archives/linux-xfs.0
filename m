Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAEE3D1A8E;
	Thu, 23 Jul 2026 21:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840886; cv=none; b=Ap0l7HgC5+LhuEYoM/1qR+fQ11RMgBSjF7He3y9d2cDGphMNCuMjFwtv9zBbM+2zVoli/mBpVgg/egzLX8ys0VNMHCO+Y48hLS3zAwkd/eXgFRwdO8n/+v+fkVKJcJ6BF8J3SgGZ4U3YbpAtlIZs9Oir5gb1e7XyT4rZtT478e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840886; c=relaxed/simple;
	bh=yHEXWtrKZVm3iXX0daNwIgGPmkCspUZY5Hl2pnJRebg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2zEPsvjAxNJ7LFQhQK9WBd61Cu6xg8MP2Kx4/JXBWh47gVJxXwYYi7BWJIzjrsmLB771ckzptLP5P9XuMsIam8YP2FGMp4TpDru47N8lpUr55qlE2/C7k2mGEAkzaHpRkkC7iRl6mqEUj8LuPmhP+mzg/6t3H98WP1fZyCL5nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F/m4O74b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/m4O74b"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B1B251F000E9;
	Thu, 23 Jul 2026 21:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840878;
	bh=wRZMBmKClIsaXmAjG5gTjsktQiWn60tZO7YN3IRKvdA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F/m4O74bHCifFI0oVCfylrToJ4phKXJUoO6f1SiyIlPkJ0FndTmiyDNYL61M0u4pZ
	 Hw5dvVEsGU4iecA5C7j5DaQEU3E8qKzmJxadO/+dRWVWPXDcYP7FsjdyvMrJT7Tn0V
	 XfpOctKNp/gPQ79lRsWP1Knpq1KYBYZIPLI4iknpNXvwe2tZYBOvRBhD9v8PP0+oC3
	 XiAXdusssHNAyWShHt4CKK+hVLFRprnkanfeDrFHYiomliWgl+jo5UWhEAEQ+fSBSo
	 TpfxYne8FY2ZGLUslQocSZiBtrD5ryjFv80r1iW8EnewAftquX73xzgjR8GU8xokSG
	 SSCozCMiDp3HQ==
Date: Thu, 23 Jul 2026 14:07:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 22/22] xfs: log a message at mount time when using
 integrity protection
Message-ID: <20260723210758.GL2901224@frogsfrogsfrogs>
References: <20260723145000.116419-1-hch@lst.de>
 <20260723145000.116419-23-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723145000.116419-23-hch@lst.de>

On Thu, Jul 23, 2026 at 04:49:47PM +0200, Christoph Hellwig wrote:
> Log a message in the kernel when using T10 protection information.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Do these new log messages show up for any PI-capable device?  So if I
put the log on a PI blockdev, it'll say "Using arglebargle integrity
profile for /dev/sda" ?

The code looks ok to me so

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index e1465e950acc..744e4a94a879 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -5,6 +5,7 @@
>   */
>  #include "xfs_platform.h"
>  #include <linux/backing-dev.h>
> +#include <linux/blk-integrity.h>
>  #include <linux/dax.h>
>  
>  #include "xfs_shared.h"
> @@ -1674,6 +1675,7 @@ xfs_configure_buftarg(
>  	struct xfs_mount	*mp = btp->bt_mount;
>  
>  	if (btp->bt_bdev) {
> +		struct blk_integrity *bi = bdev_get_integrity(btp->bt_bdev);
>  		int		error;
>  
>  		error = bdev_validate_blocksize(btp->bt_bdev, sectorsize);
> @@ -1686,6 +1688,15 @@ xfs_configure_buftarg(
>  
>  		if (bdev_can_atomic_write(btp->bt_bdev))
>  			xfs_configure_buftarg_atomic_writes(btp);
> +
> +		if (!bi)
> +			;
> +		else if (btp->bt_bdev == btp->bt_mount->m_super->s_bdev)
> +			xfs_info(mp, "using %s integrity profile",
> +				blk_integrity_profile_name(bi));
> +		else
> +			xfs_info(mp, "using %s integrity profile for %pg",
> +				blk_integrity_profile_name(bi), btp->bt_bdev);
>  	}
>  
>  	btp->bt_meta_sectorsize = sectorsize;
> -- 
> 2.53.0
> 
> 
