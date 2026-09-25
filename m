Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933AD4052D9;
	Fri, 25 Sep 2026 23:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790378422; cv=none; b=Y/44lYI6XDUYTSpHjxbNzFGVDD6fWJLHwpmlNe7ct59BRQNWuEGSKrxC4efjyjf6gwCCdh9OWsGWW5CCZCFUNTJvWB3BjBOPqTsczWhmi862Q90LrpFIEX5KFDrfPtKe0cSloHpH5bdA5kci5gWQMjA/6+kwf9iSw6GzX3Aw2F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790378422; c=relaxed/simple;
	bh=36cCmxVwE3fsb3fUNG4uiEhVrMrFuIX9YOYN0IH8ewc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VzujR3S2gjwISoZTKdp1+Bc+OJuODeTXzSPG89nB20cSRX9BkJPWkUePZ2Xrc/B7ZoAlPztgPObDnPnnAChy+piTjNoxwjtKcmk8kppTl0KsrO8O9lpg2yVjd9T6m+iBPcNjuuRhRedNLSTK0sryIjc/lo8MBSFEro8Mm9avHvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B2KHIXNi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B2KHIXNi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 257BE1F000FF;
	Fri, 25 Sep 2026 23:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790378421;
	bh=ud+OSprfGeM+tvPnEcElGgFrsytW4zd8TTr7HTW5pA8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B2KHIXNikRDHECzvf5Zzjc+tnBRgpTFGLHVi+dAj26MQnIpjbvzvpjbVOWht4ud1g
	 Pf3LRJkemSSQceMmNwtipVo9n1arKGuvYOWP9qshU9ThyYIMQ+is2eq4YpIBGAR3Rz
	 RgbKpZHC/x5IOexil92vlcuPaDRFib2zM+PpUd8+uZb9HiTLY1g6ics3Nohk9/eIpI
	 y5QCbGCwMntRHAJbZOlW3Cm3mTPETNEvSca+MdC1IJnX5iLO863knZOiHFx9EuAv9F
	 n0VFNxX93T9Pc3N3F7w19nJhOrQbRsDRyD53mE/0NdWEzBpoILy+NjzKppBFO6h5qj
	 IUIp6iIMMzL2A==
Date: Fri, 25 Sep 2026 16:20:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/21] xfs: core RT data checksum support
Message-ID: <20260925232020.GF2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-12-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:43AM +0200, Christoph Hellwig wrote:
> Support reading and writing of data checksum buffers, and generating
> and verifying the checksum.
> 
> All data checksum buffers for an open zone are pre-allocated at zone open
> time, so that we never have to read in a partially written buffer as part
> of a data write, which would otherwise impose very expensive seeks and
> stall writes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/Kconfig          |   1 +
>  fs/xfs/Makefile         |   1 +
>  fs/xfs/xfs_inode.h      |   5 +
>  fs/xfs/xfs_rtcsum.c     | 317 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_rtcsum.h     |  23 +++
>  fs/xfs/xfs_super.c      |  14 ++
>  fs/xfs/xfs_sysfs.c      |   2 +
>  fs/xfs/xfs_zone_alloc.c |  32 +++-
>  fs/xfs/xfs_zone_priv.h  |   8 +
>  9 files changed, 399 insertions(+), 4 deletions(-)
>  create mode 100644 fs/xfs/xfs_rtcsum.c
>  create mode 100644 fs/xfs/xfs_rtcsum.h
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index b99da294e9a3..424a04b507a6 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -106,6 +106,7 @@ config XFS_RT
>  	bool "XFS Realtime subvolume support"
>  	depends on XFS_FS
>  	default BLK_DEV_ZONED
> +	select CRC64
>  	help
>  	  If you say Y here you will be able to mount and use XFS filesystems
>  	  which contain a realtime subvolume.  The realtime subvolume is a
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 79ea4136fbba..0d57bf0701ec 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -142,6 +142,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
>  
>  # xfs_rtbitmap is shared with libxfs
>  xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o \
> +				   xfs_rtcsum.o \
>  				   xfs_zone_alloc.o \
>  				   xfs_zone_gc.o \
>  				   xfs_zone_info.o \
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 34c1038ebfcd..9ed2fbfe86ff 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -376,6 +376,11 @@ static inline bool xfs_inode_can_sw_atomic_write(const struct xfs_inode *ip)
>  	return xfs_can_sw_atomic_write(ip->i_mount);
>  }
>  
> +static inline bool xfs_is_rtcsum_inode(const struct xfs_inode *ip)
> +{
> +	return xfs_has_rtcsum(ip->i_mount) && XFS_IS_REALTIME_INODE(ip);
> +}
> +
>  /*
>   * In-core inode flags.
>   */
> diff --git a/fs/xfs/xfs_rtcsum.c b/fs/xfs/xfs_rtcsum.c
> new file mode 100644
> index 000000000000..7cdc5a5029eb
> --- /dev/null
> +++ b/fs/xfs/xfs_rtcsum.c
> @@ -0,0 +1,317 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2026 Christoph Hellwig.
> + */
> +#include "xfs_platform.h"
> +#include "xfs_fs.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_shared.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_bit.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
> +#include "xfs_bmap.h"
> +#include "xfs_rtgroup.h"
> +#include "xfs_rtbitmap.h"
> +#include "xfs_bmap_btree.h"
> +#include "xfs_trans.h"
> +#include "xfs_buf_item.h"
> +#include "xfs_trans_space.h"
> +#include "xfs_error.h"
> +#include "xfs_health.h"
> +#include "xfs_rtcsum.h"
> +#include "xfs_zone_priv.h"
> +#include <linux/iomap.h>
> +
> +static_assert(IOMAP_CSUM_MAX_SIZE <= XFS_RTCSUM_MAX_WRITE);
> +
> +static const char *xfs_data_csum_names[XFS_CSUM_TYPE_MAX] = {
> +	[XFS_CSUM_TYPE_CRC32C]	= "crc32c",
> +	[XFS_CSUM_TYPE_CRC64]	= "crc64",
> +};
> +
> +int
> +xfs_csum_verify(
> +	struct xfs_mount	*mp,
> +	struct bio		*bio,
> +	struct bvec_iter	*iter,
> +	void			*csum_buf,
> +	xfs_fsblock_t		bno,
> +	bool			verbose)
> +{
> +	unsigned int		bsize = mp->m_sb.sb_blocksize;
> +	unsigned int		csum_size = 1u << mp->m_rtcsum_shift;
> +	unsigned int		offset = 0;
> +	union xfs_csum		csum;
> +	union xfs_disk_csum	dsum;
> +
> +	do {
> +		struct bio_vec	bv = mp_bvec_iter_bvec(bio->bi_io_vec, *iter);
> +
> +		if (offset == 0)
> +			xfs_csum_seed(mp, &csum);
> +		bv.bv_len = min(bv.bv_len, bsize - offset);
> +		xfs_csum_gen(mp, bvec_virt(&bv), bv.bv_len, &csum);
> +		offset += bv.bv_len;
> +		if (offset == bsize) {
> +			xfs_csum_finalize(mp, &dsum, &csum);
> +			if (unlikely(memcmp(&dsum, csum_buf, csum_size) != 0))
> +				goto mismatch;
> +			bno++;
> +			csum_buf += csum_size;
> +			offset = 0;
> +		}
> +		bio_advance_iter_single(bio, iter, bv.bv_len);
> +	} while (iter->bi_size);
> +
> +	return 0;
> +
> +mismatch:
> +	if (verbose) {
> +		xfs_warn_ratelimited(mp,
> +"data csum mismatch for rtblock 0x%llx: 0x%*phN (expected 0x%*phN)",
> +			bno, csum_size, &csum, csum_size, csum_buf);
> +	}
> +	return -EIO;
> +}
> +
> +void
> +xfs_csum_generate(
> +	struct xfs_mount	*mp,
> +	struct bio		*bio,
> +	void			*csum_buf)
> +{
> +	struct bvec_iter	iter = bio->bi_iter;
> +	unsigned int		bsize = mp->m_sb.sb_blocksize;
> +	unsigned int		csum_size = 1u << mp->m_rtcsum_shift;
> +	unsigned int		offset = 0;
> +	union xfs_csum		csum;
> +
> +	do {
> +		struct bio_vec	bv = mp_bvec_iter_bvec(bio->bi_io_vec, iter);
> +
> +		if (offset == 0)
> +			xfs_csum_seed(mp, &csum);
> +		bv.bv_len = min(bv.bv_len, bsize - offset);
> +		xfs_csum_gen(mp, bvec_virt(&bv), bv.bv_len, &csum);
> +		offset += bv.bv_len;
> +		if (offset == bsize) {
> +			xfs_csum_finalize(mp, csum_buf, &csum);
> +			csum_buf += csum_size;
> +			offset = 0;
> +		}
> +		bio_advance_iter_single(bio, &iter, bv.bv_len);
> +	} while (iter.bi_size);
> +}
> +
> +/*
> + * Read the checksum buffer for @rtg/@csum_off and return it unlocked.

      Read the checksum buffer for @fsbno?

> + *
> + * We don't need to lock read access to the buffer because checksums will not
> + * change until the @rtg is reset.
> + */
> +int
> +xfs_rtcsum_read_async(
> +	struct xfs_mount	*mp,
> +	xfs_rtblock_t		fsbno,
> +	struct xfs_buf		**bpp)
> +{
> +	xfs_daddr_t		csum_daddr;
> +	struct xfs_rtgroup	*rtg;
> +	int			error;
> +
> +	rtg = xfs_rtgroup_get(mp, xfs_rtb_to_rgno(mp, fsbno));
> +	if (!rtg)
> +		return -EFSCORRUPTED;
> +	error = xfs_rtcsum_bmap(rtg, xfs_rtb_to_rgbno(mp, fsbno), &csum_daddr);
> +	if (!error)
> +		error = xfs_buf_read_async(mp->m_ddev_targp, csum_daddr,
> +				BTOBB(mp->m_rtcsum_bsize), &xfs_rtcsum_buf_ops,
> +				bpp);
> +	xfs_rtgroup_put(rtg);
> +	return error;
> +}
> +
> +/*
> + * When opening a zone for writing, do a speculative buf_get for each csum
> + * buffer.  This ensures we usually have a buffer in-memory when we actually
> + * start writing to it.
> + *
> + * Without this we'd have to read the buffer from disk, as we don't know if
> + * anyone has already written to it by the time we get to the buffer due to
> + * completion reordering.
> + *
> + * When reopening a partially written zone at mount time, just read ahead
> + * the entire csums for the zone.
> + */
> +int
> +xfs_rtcsum_open_zone(
> +	struct xfs_open_zone	*oz)
> +{
> +	struct xfs_rtgroup	*rtg = oz->oz_rtg;
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +	xfs_rgblock_t		rgbno = 0;
> +	int			i, error;
> +
> +	for (i = 0; i < oz->oz_nr_csum_bufs; i++) {
> +		xfs_daddr_t	csum_daddr;
> +		struct xfs_buf	*bp;
> +
> +		error = xfs_rtcsum_bmap(rtg, rgbno, &csum_daddr);
> +		if (error)
> +			goto out_error;
> +
> +		if (oz->oz_allocated) {
> +			error = xfs_buf_read_async(mp->m_ddev_targp, csum_daddr,
> +					BTOBB(mp->m_rtcsum_bsize),
> +					&xfs_rtcsum_buf_ops, &bp);
> +		} else {
> +			error = xfs_buf_get(mp->m_ddev_targp, csum_daddr,
> +					BTOBB(mp->m_rtcsum_bsize), &bp);
> +			if (!error) {
> +				bp->b_flags = XBF_DONE;
> +				xfs_rtfile_initialize_buf(rtg, XFS_RTGI_CSUM,
> +						bp, NULL);
> +			}
> +			xfs_buf_unlock(bp);
> +		}
> +		if (error)
> +			goto out_error;
> +		oz->oz_csum_bufs[i] = bp;
> +		rgbno += (xfs_rtcsum_payload_size(mp) /
> +			  (1u << mp->m_rtcsum_shift));
> +	}
> +
> +	return 0;
> +
> +out_error:
> +	while (--i >= 0)
> +		xfs_buf_rele(oz->oz_csum_bufs[i]);

/me wonders if this should null out oz_csum_bufs to avoid the
possibility of dangling pointers?  Though I think the only caller will
free the oz if this function returns error so it might not matter much.

--D
