Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F59D3093B2;
	Mon,  2 Mar 2026 16:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772468759; cv=none; b=tx6kiY6o7LLfTNGPYRLzFuoXlzsQZwXXXNx8f1ilTqRQ9hUmHp7Dkefnn/H1UkG2K9zL5I6VHIFBNuYTOIEovtagqXHsd1qu+jjZCBkW9gXP2ZdnLk9kjX1UnrrU6d4Za12xKjmyrhi5MnTUKG6mjGKgRleo4VAS1rgrpND2SJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772468759; c=relaxed/simple;
	bh=GzwGk2ixb24YVuLHmdkYUSk3g5QrbiZffKiFgiyE4eQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i3ZNxSMqN4bWguSUEAX33COTjLv3R+7iNS3m0U01cqCGz7G6l7C1IdBk/aiexCVJCeroR6thwCbUADrXmFUnEZAGb424hbAGmjxt04CbGwiR64koXouAwChf2Fh6lp6ANMolA7rQLl0GnzzKuBEeDN4kgDdG64IOn9QdnK9HOW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=siiZ1IJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="siiZ1IJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253BEC19423;
	Mon,  2 Mar 2026 16:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772468759;
	bh=GzwGk2ixb24YVuLHmdkYUSk3g5QrbiZffKiFgiyE4eQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=siiZ1IJcxU/iCRLuTbBAP3svIEquhjtN44RChhaOaOWZnpd/xJO0G2toY8aqz1KGc
	 oVTe7Hgc3fBJW3gJrbfEHE3Xrymu+4k6oBox9aLJoLDPKHc/zJ3rYcztlqmYovIiLs
	 RVQzZzC16ubU8roLzewpZPYFRJW7GacPYExwxoanqxSFu7Mk0WIz8bg7YKeLkSG+PL
	 2BIJGvPBbX9fOxc8rBAn3RwCAI9DAg/j+srEkn8p6m3SfIwmoN8ae+rTFlX4FXqdi8
	 khY8uHR71fcd47HIvHC9v3U3QbNNoXgO4saEUBz1xz1cZznyKjl00ZreN8e1httjAh
	 Hdz3nAJhtz7Fg==
Date: Mon, 2 Mar 2026 08:25:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH v2] xfs: add write pointer to xfs_rtgroup_geometry
Message-ID: <20260302162558.GJ13853@frogsfrogsfrogs>
References: <20260301003432.605428-4-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260301003432.605428-4-wilfred.opensource@gmail.com>

On Sun, Mar 01, 2026 at 10:34:35AM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> There is currently no XFS ioctl that allows userspace to retrieve the
> write pointer for a specific realtime group block for zoned XFS. On zoned
> block devices, userspace can obtain this information via zone reports from
> the underlying device. However, for zoned XFS operating on regular block
> devices, no equivalent mechanism exists.
> 
> Access to the realtime group write pointer is useful to userspace
> development and analysis tools such as Zonar [1]. So extend the existing
> struct xfs_rtgroup_geometry to add a new rg_writepointer field. This field
> is valid if XFS_RTGROUP_GEOM_WRITEPOINTER flag is set. The rg_writepointer
> field specifies the location of the current writepointer as a block offset
> into the respective rtgroup.
> 
> [1] https://lwn.net/Articles/1059364/
> Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> ---
> V1 -> V2:
> 	- Use a __u32 to instead of __u64 to store the write pointer
> 	- This, also drop the previously added padding.
> 	- Directly retun the writepointer block instead of converting
> 	  with XFS_FSB_TO_BB(), for consistentcy in struct
> 	  xfs_rtgroup_geometry (i.e rg_length is in fs blocks).

Hey, that looks better now.  Thanks for the patch!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_fs.h |  5 ++++-
>  fs/xfs/xfs_ioctl.c     | 19 +++++++++++++++++++
>  2 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index d165de607d17..185f09f327c0 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -995,7 +995,8 @@ struct xfs_rtgroup_geometry {
>  	__u32 rg_sick;		/* o: sick things in ag */
>  	__u32 rg_checked;	/* o: checked metadata in ag */
>  	__u32 rg_flags;		/* i/o: flags for this ag */
> -	__u32 rg_reserved[27];	/* o: zero */
> +	__u32 rg_writepointer;  /* o: write pointer block offset for zoned */
> +	__u32 rg_reserved[26];	/* o: zero */
>  };
>  #define XFS_RTGROUP_GEOM_SICK_SUPER	(1U << 0)  /* superblock */
>  #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
> @@ -1003,6 +1004,8 @@ struct xfs_rtgroup_geometry {
>  #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
>  #define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1U << 4)  /* reference counts */
>  
> +#define XFS_RTGROUP_GEOM_WRITEPOINTER  (1U << 0)  /* write pointer */
> +
>  /* Health monitor event domains */
>  
>  /* affects the whole fs */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index facffdc8dca8..46e234863644 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -37,12 +37,15 @@
>  #include "xfs_ioctl.h"
>  #include "xfs_xattr.h"
>  #include "xfs_rtbitmap.h"
> +#include "xfs_rtrmap_btree.h"
>  #include "xfs_file.h"
>  #include "xfs_exchrange.h"
>  #include "xfs_handle.h"
>  #include "xfs_rtgroup.h"
>  #include "xfs_healthmon.h"
>  #include "xfs_verify_media.h"
> +#include "xfs_zone_priv.h"
> +#include "xfs_zone_alloc.h"
>  
>  #include <linux/mount.h>
>  #include <linux/fileattr.h>
> @@ -413,6 +416,7 @@ xfs_ioc_rtgroup_geometry(
>  {
>  	struct xfs_rtgroup	*rtg;
>  	struct xfs_rtgroup_geometry rgeo;
> +	xfs_rgblock_t		highest_rgbno;
>  	int			error;
>  
>  	if (copy_from_user(&rgeo, arg, sizeof(rgeo)))
> @@ -433,6 +437,21 @@ xfs_ioc_rtgroup_geometry(
>  	if (error)
>  		return error;
>  
> +	if (xfs_has_zoned(mp)) {
> +		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
> +		if (rtg->rtg_open_zone) {
> +			rgeo.rg_writepointer = rtg->rtg_open_zone->oz_allocated;
> +		} else {
> +			highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
> +			if (highest_rgbno == NULLRGBLOCK)
> +				rgeo.rg_writepointer = 0;
> +			else
> +				rgeo.rg_writepointer = highest_rgbno + 1;
> +		}
> +		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
> +		rgeo.rg_flags |= XFS_RTGROUP_GEOM_WRITEPOINTER;
> +	}
> +
>  	if (copy_to_user(arg, &rgeo, sizeof(rgeo)))
>  		return -EFAULT;
>  	return 0;
> -- 
> 2.53.0
> 
> 
