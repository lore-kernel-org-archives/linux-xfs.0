Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D8C13D8A0
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 01:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738890145; cv=none; b=cp+htSt/dHkA74xSXVc+pKNWACHX1ZH4nVkHM2NY8CSOVOQ3JniMeynVGmSMXEAdNlmeicKKas0YEr808l732+jaRvZg5/nlKjACGUqvbhzBgtXrgIZQvov9fbTIAyWR44KKFZj1z9Gk2KO1QG3xIiflg4LEZ31uF/wx5Hcx5gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738890145; c=relaxed/simple;
	bh=4hsR6Tc+xssF0IDtmruDOtby6sWZD+8U3GYAS7XqVSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l4ssPK8tiiUBkiX4hSFH0ozlfhwJp2adT1nKxpAwveocjk22yiFZBLx+FdokJ9cvhCwIlF4OPBAE7ir4xXq5STbLk7l/ne5ihIXmpaPrfFya04xU+5olk1jjphbCd+EFCci2FCDwMwiYkq/73r95wG7/BZv5/qJGhFupGBglPOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nue6g9rI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nue6g9rI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12155C4CEE0;
	Fri,  7 Feb 2025 01:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738890145;
	bh=4hsR6Tc+xssF0IDtmruDOtby6sWZD+8U3GYAS7XqVSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nue6g9rIBsjlH9S/BaDFDKWddG4zgRHiQ9dvc6K3vtuOHZ5On8KoyrqwZ0Opzx6eC
	 HnD9v/bnnbVRbRAlTFGmuMjEcbmRtwrajeRZw76xv0e+eSu9m01il1MO2tlW4w0uco
	 X7MtbDXBSQGbJ0seArWD97KWEm5eOhzzjpBmfnZAIdwBEXkKRkXBXB3Jht4PkRCZzo
	 EhV7rnI8PBUcQCdoUI2nYm9Pwaf2rxlBDaUw+qQnkdDynhgfiwy3N0KPHmgbNSMOR9
	 8L3DMpJ0JwEaYDQ05ffD4JvG/y1mQ1XNwyZHOZ8CcqWZsLm4vYz3OXcUjZQgNEuDm8
	 YOkp8xtCSJOjQ==
Date: Thu, 6 Feb 2025 17:02:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/43] xfs: export zone stats in /proc/*/mountstats
Message-ID: <20250207010224.GF21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-42-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-42-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:57AM +0100, Christoph Hellwig wrote:
> From: Hans Holmberg <hans.holmberg@wdc.com>
> 
> Add the per-zone life time hint and the used block distribution
> for fully written zones, grouping reclaimable zones in fixed-percentage
> buckets spanning 0..9%, 10..19% and full zones as 100% used as well as a
> few statistics about the zone allocator and open and reclaimable zones
> in /proc/*/mountstats.

I'm kinda surprised you didn't export this via sysfs, but then
remembered that Greg has strict rules against tabular data and whatnot.

> This gives good insight into data fragmentation and data placement
> success rate.

I hope it's worth exporting a bunch of stringly-structured data. ;)

Past me would've asked if we could just export some json and let
userspace pick that up, but today me learned about the horrors of json
and how it represents integers, stumbling over trailing commas, etc.

Is any of this getting wired up into a zone-top tool?
The /proc dump looks ok to me...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Co-developed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/Makefile         |   1 +
>  fs/xfs/xfs_super.c      |   4 ++
>  fs/xfs/xfs_zone_alloc.h |   1 +
>  fs/xfs/xfs_zone_info.c  | 105 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 111 insertions(+)
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
> index 134859a3719d..877332ffd84b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1262,6 +1262,10 @@ xfs_fs_show_stats(
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
> index 1269390bfcda..ecf39106704c 100644
> --- a/fs/xfs/xfs_zone_alloc.h
> +++ b/fs/xfs/xfs_zone_alloc.h
> @@ -44,6 +44,7 @@ void xfs_mark_rtg_boundary(struct iomap_ioend *ioend);
>  
>  uint64_t xfs_zoned_default_resblks(struct xfs_mount *mp,
>  		enum xfs_free_counter ctr);
> +void xfs_zoned_show_stats(struct seq_file *m, struct xfs_mount *mp);
>  
>  #ifdef CONFIG_XFS_RT
>  int xfs_mount_zones(struct xfs_mount *mp);
> diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
> new file mode 100644
> index 000000000000..7ba0a5931c99
> --- /dev/null
> +++ b/fs/xfs/xfs_zone_info.c
> @@ -0,0 +1,105 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2023-2025 Christoph Hellwig.
> + * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
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
> +static void
> +xfs_show_full_zone_used_distribution(
> +	struct seq_file         *m,
> +	struct xfs_mount        *mp)
> +{
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	unsigned int		reclaimable = 0, full, i;
> +
> +	spin_lock(&zi->zi_used_buckets_lock);
> +	for (i = 0; i < XFS_ZONE_USED_BUCKETS; i++) {
> +		unsigned int entries = zi->zi_used_bucket_entries[i];
> +
> +		seq_printf(m, "\t  %2u..%2u%%: %u\n",
> +				i * (100 / XFS_ZONE_USED_BUCKETS),
> +				(i + 1) * (100 / XFS_ZONE_USED_BUCKETS) - 1,
> +				entries);
> +		reclaimable += entries;
> +	}
> +	spin_unlock(&zi->zi_used_buckets_lock);
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
> +	seq_printf(m, "\tuser free RT blocks: %lld\n",
> +		xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS));
> +	seq_printf(m, "\treserved free RT blocks: %lld\n",
> +		mp->m_resblks[XC_FREE_RTEXTENTS].avail);
> +	seq_printf(m, "\tuser available RT blocks: %lld\n",
> +		xfs_sum_freecounter(mp, XC_FREE_RTAVAILABLE));
> +	seq_printf(m, "\treserved available RT blocks: %lld\n",
> +		mp->m_resblks[XC_FREE_RTAVAILABLE].avail);
> +	seq_printf(m, "\tRT reservations required: %d\n",
> +		!list_empty_careful(&zi->zi_reclaim_reservations));
> +	seq_printf(m, "\tRT GC required: %d\n",
> +		xfs_zoned_need_gc(mp));
> +
> +	seq_printf(m, "\tfree zones: %d\n", atomic_read(&zi->zi_nr_free_zones));
> +	seq_puts(m, "\topen zones:\n");
> +	spin_lock(&zi->zi_open_zones_lock);
> +	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry)
> +		xfs_show_open_zone(m, oz);
> +	if (zi->zi_open_gc_zone) {
> +		seq_puts(m, "\topen gc zone:\n");
> +		xfs_show_open_zone(m, zi->zi_open_gc_zone);
> +	}
> +	spin_unlock(&zi->zi_open_zones_lock);
> +	seq_puts(m, "\tused blocks distribution (fully written zones):\n");
> +	xfs_show_full_zone_used_distribution(m, mp);
> +}
> -- 
> 2.45.2
> 
> 
