Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C53034252B;
	Fri, 27 Feb 2026 04:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772165180; cv=none; b=BmHuIDNA9W24jkjg4Ey9wanR8eNWa/5KQfysBjNVgdUBM4yew0ZSUZvqLKrFUmjqa5wxJtqxDCxRHt7PUDU4fMtgJNAu0KAKgwY+LFJKPeQFBo9S3mbjtQRmlTT0kW+yNpZ5mhRxCOjdFagEfZxYLRYi/JfBMDDjQEaD8N7ei1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772165180; c=relaxed/simple;
	bh=zlTWzgGorqf6/4pB7k6udAf+iACQBCgII9D46aTnEEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eKv1cYi9UmuWhw7Xgr5uIVAT6eV9WASIz1fRf1EnOte8jcYugE3asQGviduL3uWju60cWTOjLBNdeM2QVpSAMibsCQBS+bKInJy+sZ1DFDu3Rvz8nhi0PZhyDs1xpOxP7zSpFh7RP4ZQU1NzWZREHVEmHJa5t3YDR292MHq9IkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qsz0UNxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qsz0UNxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CC2C19423;
	Fri, 27 Feb 2026 04:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772165180;
	bh=zlTWzgGorqf6/4pB7k6udAf+iACQBCgII9D46aTnEEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qsz0UNxxYL6ynUKSgTjsYhnKxQKNAA943KhCDo/Mw3AcCb5/5zYP1Ndohos97xrkw
	 500gtEcjEjqtY1OaDRTMRWgkT5Jr0DDLgDDJQvFl6Iz7RwYsKeSMygbCaF03bJ31OX
	 nrLXpr9vyxbbKl0QBbfrTg8rWHkJegOvKrON9BlNc4Mii2sduaSfAkRcCTRUSbA9y6
	 avmJ994PoI2SnVw0uVfennhMyMEBaqF+0lApIcUTWPv6RKbsqUj+KH/snWcpWtSH2z
	 KoBNPccZxr1jH4rWcXFWuNJqlxv/zvR58X2jOINH00uZBqenYT/0RzTGlsX+VYKrg1
	 HkCciaziBF68Q==
Date: Thu, 26 Feb 2026 20:06:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH] xfs: add write pointer to xfs_rtgroup_geometry
Message-ID: <20260227040619.GI13853@frogsfrogsfrogs>
References: <20260227030105.822728-2-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227030105.822728-2-wilfred.opensource@gmail.com>

On Fri, Feb 27, 2026 at 01:01:06PM +1000, Wilfred Mallawa wrote:
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
> field specifies the location of the current writepointer as a sector offset
> into the respective rtgroup.
> 
> [1] https://lwn.net/Articles/1059364/
> Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h |  6 +++++-
>  fs/xfs/xfs_ioctl.c     | 20 ++++++++++++++++++++
>  2 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index d165de607d17..ca63ae67f16c 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -995,7 +995,9 @@ struct xfs_rtgroup_geometry {
>  	__u32 rg_sick;		/* o: sick things in ag */
>  	__u32 rg_checked;	/* o: checked metadata in ag */
>  	__u32 rg_flags;		/* i/o: flags for this ag */
> -	__u32 rg_reserved[27];	/* o: zero */
> +	__u32 rg_reserved0;	/* o: preserve alignment */
> +	__u64 rg_writepointer;  /* o: write pointer sector for zoned */

Hrm.  It's not possible to advance the write pointer less than a single
xfs fsblock, right?  zoned rt requires rt groups, so that means the
write pointer within a rtgroup has to be a xfs_rgblock_t (32bit) value,
so shouldn't this be a __u32 field?

(aside from that, the wp extraction code itself looks reasonable)

--D

> +	__u32 rg_reserved[24];	/* o: zero */
>  };
>  #define XFS_RTGROUP_GEOM_SICK_SUPER	(1U << 0)  /* superblock */
>  #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
> @@ -1003,6 +1005,8 @@ struct xfs_rtgroup_geometry {
>  #define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
>  #define XFS_RTGROUP_GEOM_SICK_REFCNTBT	(1U << 4)  /* reference counts */
>  
> +#define XFS_RTGROUP_GEOM_WRITEPOINTER  (1U << 0)  /* write pointer */
> +
>  /* Health monitor event domains */
>  
>  /* affects the whole fs */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index facffdc8dca8..86bd8fc0c41d 100644
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
> +	xfs_rgblock_t		highest_rgbno, write_pointer;
>  	int			error;
>  
>  	if (copy_from_user(&rgeo, arg, sizeof(rgeo)))
> @@ -433,6 +437,22 @@ xfs_ioc_rtgroup_geometry(
>  	if (error)
>  		return error;
>  
> +	if (xfs_has_zoned(mp)) {
> +		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
> +		if (rtg->rtg_open_zone) {
> +			write_pointer = rtg->rtg_open_zone->oz_allocated;
> +		} else {
> +			highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
> +			if (highest_rgbno == NULLRGBLOCK)
> +				write_pointer = 0;
> +			else
> +				write_pointer = highest_rgbno + 1;
> +		}
> +		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
> +		rgeo.rg_writepointer = XFS_FSB_TO_BB(mp, write_pointer);
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
