Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E162114
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 23:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734131068; cv=none; b=XDi9TK3/qC0jn0ydhYl9xo6MFHFbM1aGwTX7ZvSGpYs2tcZxlxmMQQiL3Un+WK/NQVqW5V4Tqlidmn3WH3KQyY3QGnQtPreCfBmvtpuWDndNq5KQW+Cv0n98yvvb+J1UzsKXpgq+in8ob59R7P5A2itxOOLsCz0phXdr/Iflry8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734131068; c=relaxed/simple;
	bh=wCrv3bodaDEjPWNrzNVC8kK2DSvO/siwv2WS3zCXYig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tH3HoQYdk1qC8vCKivq5HaOQYEUlpFrUERBDm/oaNfn6/q+ly0ld1T8QseaqUPjV3Uru0ikBgXV2CYjopmhbkpMsmfH6JEZ07gzw0Cw3EsLwxJmc6O0etqtEcr+JkUuXA/dADyyKkqMBm68J2E1Laoq847WPRsNmBWIyZVamIWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7Wd+dYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7Wd+dYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDECC4CED0;
	Fri, 13 Dec 2024 23:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734131067;
	bh=wCrv3bodaDEjPWNrzNVC8kK2DSvO/siwv2WS3zCXYig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P7Wd+dYvr3sYArer7eCllj6kXtGIoPm5yCA56bd6A4q/oqLn8Xy7e3NQ60pBTFQmK
	 IGAgK97SRz6KmD9GZjoQmwY9JL7EjlvuhAutgCGrOCyokUghPHUY74504JPpichsFY
	 1o3ikajXt3ixj8YoH6Tu2wtaLRrg7MwIXXQRW88qDFjrB1TAczCo/YX/FQUofwTEv8
	 RiripFbGKPcwa6E2potAws7nM9qfU9aJmvunM0grDQpGwKdeppKhM/zNFCzPi5UzP8
	 TubPb3hwJ7gpUmHCh8vPo0QscIzysLFElugjzgecqJnNgG3U+zoYGTg2FevPV6s0gI
	 YpNFst8YIwAVA==
Date: Fri, 13 Dec 2024 15:04:27 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 43/43] xfs: export zone stats in /proc/*/mountstats
Message-ID: <20241213230427.GD6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-44-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-44-hch@lst.de>

On Wed, Dec 11, 2024 at 09:55:08AM +0100, Christoph Hellwig wrote:
> From: Hans Holmberg <hans.holmberg@wdc.com>
> 
> Add the per-zone life time hint and the used block distribution
> for fully written zones, grouping reclaimable zones in fixed-percentage
> buckets spanning 0..9%, 10..19% and full zones as 100% used as well as a
> few statistics about the zone allocator and open and reclaimable zones
> in /proc/*/mountstats.
> 
> This gives good insight into data fragmentation and data placement
> success rate.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Co-developed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/Makefile         |   1 +
>  fs/xfs/xfs_super.c      |   4 ++
>  fs/xfs/xfs_zone_alloc.h |   1 +
>  fs/xfs/xfs_zone_info.c  | 120 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 126 insertions(+)
>  create mode 100644 fs/xfs/xfs_zone_info.c
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index e38838409271..5bf501cf8271 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -140,6 +140,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
>  xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o \
>  				   xfs_zone_alloc.o \
>  				   xfs_zone_gc.o \
> +				   xfs_zone_info.o \
>  				   xfs_zone_space_resv.o
>  
>  xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 47468623fdc6..df384c4de192 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1243,6 +1243,10 @@ xfs_fs_show_stats(
>  	struct seq_file		*m,
>  	struct dentry		*root)
>  {
> +	struct xfs_mount	*mp = XFS_M(root->d_sb);
> +
> +	if (xfs_has_zoned(mp) && IS_ENABLED(CONFIG_XFS_RT))
> +		xfs_zoned_show_stats(m, mp);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
> index 44fa1594f73e..94ab32826c83 100644
> --- a/fs/xfs/xfs_zone_alloc.h
> +++ b/fs/xfs/xfs_zone_alloc.h
> @@ -34,6 +34,7 @@ void xfs_mark_rtg_boundary(struct iomap_ioend *ioend);
>  
>  uint64_t xfs_zoned_default_resblks(struct xfs_mount *mp,
>  		enum xfs_free_counter ctr);
> +void xfs_zoned_show_stats(struct seq_file *m, struct xfs_mount *mp);
>  
>  #ifdef CONFIG_XFS_RT
>  int xfs_mount_zones(struct xfs_mount *mp);
> diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
> new file mode 100644
> index 000000000000..689c9acb24d7
> --- /dev/null
> +++ b/fs/xfs/xfs_zone_info.c
> @@ -0,0 +1,120 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2023-2024 Christoph Hellwig.
> + * Copyright (c) 2024, Western Digital Corporation or its affiliates.
> + */
> +#include "xfs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
> +#include "xfs_rtgroup.h"
> +#include "xfs_zone_alloc.h"
> +#include "xfs_zone_priv.h"
> +
> +static const char xfs_write_hint_shorthand[6][16] = {
> +	"NOT_SET", "NONE", "SHORT", "MEDIUM", "LONG", "EXTREME"};
> +
> +static inline const char *
> +xfs_write_hint_to_str(
> +	uint8_t			write_hint)
> +{
> +	if (write_hint > WRITE_LIFE_EXTREME)
> +		return "UNKNOWN";
> +	return xfs_write_hint_shorthand[write_hint];
> +}
> +
> +static void
> +xfs_show_open_zone(
> +	struct seq_file		*m,
> +	struct xfs_open_zone	*oz)
> +{
> +	seq_printf(m, "\t  zone %d, wp %u, written %u, used %u, hint %s\n",
> +		rtg_rgno(oz->oz_rtg),
> +		oz->oz_write_pointer, oz->oz_written,
> +		rtg_rmap(oz->oz_rtg)->i_used_blocks,
> +		xfs_write_hint_to_str(oz->oz_write_hint));
> +}
> +
> +#define XFS_USED_BUCKETS	10
> +#define XFS_USED_BUCKET_PCT	(100 / XFS_USED_BUCKETS)
> +
> +static unsigned int
> +xfs_zone_to_bucket(
> +	struct xfs_rtgroup      *rtg)
> +{
> +	return div_u64(rtg_rmap(rtg)->i_used_blocks * XFS_USED_BUCKETS,
> +			rtg->rtg_extents);
> +}
> +
> +static void
> +xfs_show_full_zone_used_distribution(
> +	struct seq_file         *m,
> +	struct xfs_mount        *mp)
> +{
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	XA_STATE		(xas, &mp->m_groups[XG_TYPE_RTG].xa, 0);
> +	unsigned int            buckets[XFS_USED_BUCKETS] = {0};
> +	unsigned int		reclaimable = 0, full, i;
> +	struct xfs_rtgroup      *rtg;
> +
> +	lockdep_assert_held(&zi->zi_zone_list_lock);
> +
> +	rcu_read_lock();
> +	xas_for_each_marked(&xas, rtg, ULONG_MAX, XFS_RTG_RECLAIMABLE) {
> +		buckets[xfs_zone_to_bucket(rtg)]++;
> +		reclaimable++;
> +	}
> +	rcu_read_unlock();
> +
> +	for (i = 0; i < XFS_USED_BUCKETS; i++)
> +		seq_printf(m, "\t  %2u..%2u%%: %u\n", i * XFS_USED_BUCKET_PCT,
> +				(i + 1) * XFS_USED_BUCKET_PCT - 1, buckets[i]);
> +
> +	full = mp->m_sb.sb_rgcount;
> +	if (zi->zi_open_gc_zone)
> +		full--;
> +	full -= zi->zi_nr_open_zones;
> +	full -= atomic_read(&zi->zi_nr_free_zones);
> +	full -= reclaimable;
> +
> +	seq_printf(m, "\t     100%%: %u\n", full);
> +}
> +
> +void
> +xfs_zoned_show_stats(
> +	struct seq_file		*m,
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	struct xfs_open_zone	*oz;
> +
> +	seq_puts(m, "\n");
> +
> +	seq_printf(m, "\tuser free blocks: %lld\n",
> +		xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS));
> +	seq_printf(m, "\treserved free blocks: %lld\n",
> +		mp->m_resblks[XC_FREE_RTEXTENTS].avail);
> +	seq_printf(m, "\tuser available blocks: %lld\n",
> +		xfs_sum_freecounter(mp, XC_FREE_RTAVAILABLE));
> +	seq_printf(m, "\treserved available blocks: %lld\n",
> +		mp->m_resblks[XC_FREE_RTAVAILABLE].avail);
> +	seq_printf(m, "\treservations required: %d\n",
> +		!list_empty_careful(&zi->zi_reclaim_reservations));

Might want to mention that these are zoned rt stats, not for the data
device.

--D

> +	seq_printf(m, "\tGC required: %d\n",
> +		xfs_zoned_need_gc(mp));
> +
> +	spin_lock(&zi->zi_zone_list_lock);
> +	seq_printf(m, "\tfree zones: %d\n", atomic_read(&zi->zi_nr_free_zones));
> +	seq_puts(m, "\topen zones:\n");
> +	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry)
> +		xfs_show_open_zone(m, oz);
> +	if (zi->zi_open_gc_zone) {
> +		seq_puts(m, "\topen gc zone:\n");
> +		xfs_show_open_zone(m, zi->zi_open_gc_zone);
> +	}
> +	seq_puts(m, "\tused blocks distribution (fully written zones):\n");
> +	xfs_show_full_zone_used_distribution(m, mp);
> +	spin_unlock(&zi->zi_zone_list_lock);
> +}
> -- 
> 2.45.2
> 
> 
