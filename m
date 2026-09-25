Received: from mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E5949B5B4
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 11:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790336663; cv=none; b=RPVsKoFTI01oUlJ5RfwBRuYpv5gGNtcyoRL23V9Trr4easXJWxG/jYlWobrqAKrWBO0DqRaF38YRrMZrLFxWobT22mycsvlw7NW6O/k4WkTWm5ECH4Zxsq89yc1fpySNfjiagfjLnzOAHNeCcSDEwRo5JddCKC0WwVE97B04HXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790336663; c=relaxed/simple;
	bh=rbXDwxxApxPYCS6++7KMtqEkbTFxj/UlCDa3UVvVbGQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YkT1LjB5j/eguUZM/K7eFulO6cv92GX+S+7LucUFm9tc6Ii8i97az+uEOdacdDqgoKmcIEEKnjUbAfmv82gNyqqSdUHh/S+S4X9WLoYO3DtbLsLdE8F32A/xaGjQjWjWSHEu6ghDe1i743/79URCATfySn+HdFd4pp996dCF0q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OYjr1Q4j; arc=none smtp.client-ip=91.218.175.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OYjr1Q4j"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=rbXDwxxApxPYCS6++7KMtqEkbTFxj/UlCDa3UVvVbGQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790336658; v=1; x=1790941458;
 b=OYjr1Q4j0/JuWKtF8QKhPWCosLEChUtqY6hWR5bIXR1bHtpGlObYX+wNELBoJahllz3qA0o/
 n6YNFXpgMbTiFyiM/bo3CTnphHK1vpDtMKtB+2CsoX4N1twNVcFsc/NysS1QZU3fvAZUohLqh83
 4p8KdyMp8vmQCJHDmIxm5t6w=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 0ef9fae0c77aa617;
	Fri, 25 Sep 2026 11:44:18 +0000
X-Mizu-Trace-ID: 0ef9fae0c77aa617
X-Migadu-Flow: FLOW_OUT
Message-ID: <41749fa7-dcfa-46f0-af0f-ed3fa5f39f15@linux.dev>
Date: Fri, 25 Sep 2026 12:44:13 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: don't limit software atomic writes by the group
 alignment
To: Pankaj Raghav <p.raghav@samsung.com>, cem@kernel.org,
 linux-xfs@vger.kernel.org
Cc: John Garry <john.g.garry@oracle.com>, "Darrick J . Wong"
 <djwong@kernel.org>, gost.dev@samsung.com, pankaj.raghav@linux.dev
References: <20260925103640.932735-1-p.raghav@samsung.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260925103640.932735-1-p.raghav@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/26 11:36, Pankaj Raghav wrote:
 > xfs_calc_group_awu_max() clamps the atomic write unit maximum to the
 > greatest power-of-two factor of the group size when the device advertises
 > atomic writes, so that allocations can be made naturally aligned for
 > REQ_ATOMIC. But that value is the software limit: it is only used when
 > reflink is enabled, and out of place writes through the COW fork have no
 > alignment requirement.

We have mkfs atomic write options for selecting atomic write limits - 
you have tried that, right?

> 
> A filesystem on a > 4TB device that advertises 16k atomic writes then reports
> an atomic write unit maximum of a single fsblock and an optimal maximum of 0,
> and rejects any larger RWF_ATOMIC write. That is worse than the same filesystem
> on a device with no atomic write support at all.
> 
> Compute the software limit from the group size alone, and apply the
> alignment constraint in xfs_get_atomic_write_max_opt() instead, which is
> what reports the size that can be offloaded to the hardware.
> 
> Results on a 8TB device with 16k hardware atomic support with 4k
> blocksize:
> 
> Before patches:
> /media/test/hello.txt:
>    stx_atomic_write_unit_min:            4096
>    stx_atomic_write_unit_max:            4096
>    stx_atomic_write_unit_max_opt:        0
>    stx_atomic_write_segments_max:        1
> 
> After patches:
> /media/test/hello.txt:
>    stx_atomic_write_unit_min:            4096
>    stx_atomic_write_unit_max:            2097152

Here the AG size may not be a multiple of 2097152B, right? If so, when 
we try to naturally align the allocation for a CoW write, even if the AG 
blocks are naturally aligned (per AG), the disk blocks may not be 
naturnally aligned - is this correct? For HW-based atomic writes, we 
want naturally aligned disk blocks.

>    stx_atomic_write_unit_max_opt:        4096
>    stx_atomic_write_segments_max:        1
> 
> Results on a 8TB device with 16k hardware atomic support with 16k
> blocksize:
> 
> Before patches:
> /media/test/hello.txt:
>    stx_atomic_write_unit_min:            16384
>    stx_atomic_write_unit_max:            16384
>    stx_atomic_write_unit_max_opt:        0
>    stx_atomic_write_segments_max:        1
> 
> After patches:
> /media/test/hello.txt:
>    stx_atomic_write_unit_min:            16384
>    stx_atomic_write_unit_max:            33554432
>    stx_atomic_write_unit_max_opt:        16384
>    stx_atomic_write_segments_max:        1
> 
> Fixes: 0c438dcc3150 ("xfs: add xfs_calc_atomic_write_unit_max()")
> Assisted-by: LLM
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>   fs/xfs/xfs_iops.c  | 27 ++++++++++++++++++++++-----
>   fs/xfs/xfs_mount.c | 35 ++++++++++++++++++++++++-----------
>   fs/xfs/xfs_mount.h |  2 ++
>   3 files changed, 48 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index d1306e723899..8c8b14f94ede 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -620,6 +620,12 @@ xfs_get_atomic_write_min(
>   	return 0;
>   }
>   
> +static inline enum xfs_group_type
> +xfs_inode_group_type(struct xfs_inode *ip)
> +{
> +	return XFS_IS_REALTIME_INODE(ip) ? XG_TYPE_RTG : XG_TYPE_AG;
> +}
> +
>   unsigned int
>   xfs_get_atomic_write_max(
>   	struct xfs_inode	*ip)
> @@ -642,19 +648,20 @@ xfs_get_atomic_write_max(
>   	 * then advertise a maximum size of whatever we can complete through
>   	 * that means.  Hardware support is reported via max_opt, not here.
>   	 */
> -	if (XFS_IS_REALTIME_INODE(ip))
> -		return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_RTG].awu_max);
> -	return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_AG].awu_max);
> +	return XFS_FSB_TO_B(mp, mp->m_groups[xfs_inode_group_type(ip)].awu_max);
>   }
>   
>   unsigned int
>   xfs_get_atomic_write_max_opt(
>   	struct xfs_inode	*ip)
>   {
> +	struct xfs_mount	*mp = ip->i_mount;
>   	unsigned int		awu_max = xfs_get_atomic_write_max(ip);
> +	xfs_extlen_t		align_max_fsb;
> +	unsigned int		opt;
>   
>   	/* if the max is 1x block, then just keep behaviour that opt is 0 */
> -	if (awu_max <= ip->i_mount->m_sb.sb_blocksize)
> +	if (awu_max <= mp->m_sb.sb_blocksize)
>   		return 0;
>   
>   	/*
> @@ -663,7 +670,17 @@ xfs_get_atomic_write_max_opt(
>   	 * less than our out of place write limit, but we don't want to exceed
>   	 * the awu_max.
>   	 */
> -	return min(awu_max, xfs_inode_buftarg(ip)->bt_awu_max);
> +	opt = min(awu_max, xfs_inode_buftarg(ip)->bt_awu_max);
> +
> +	/*
> +	 * REQ_ATOMIC writes also have to be naturally aligned on disk, so we
> +	 * cannot promise more than the largest extent that the allocator is
> +	 * able to align within a group.
> +	 */
> +	align_max_fsb = xfs_calc_group_awu_align_max(mp,
> +						xfs_inode_group_type(ip));
> +
> +	return min_t(xfs_fsize_t, opt, XFS_FSB_TO_B(mp, align_max_fsb));
>   }
>   
>   static void
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index be90c7b03994..b7110b3d023b 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -674,15 +674,13 @@ static inline xfs_extlen_t xfs_calc_atomic_write_max(struct xfs_mount *mp)
>   }
>   
>   /*
> - * If the underlying device advertises atomic write support, limit the size of
> - * atomic writes to the greatest power-of-two factor of the group size so
> - * that every atomic write unit aligns with the start of every group.  This is
> - * required so that the allocations for an atomic write will always be
> - * aligned compatibly with the alignment requirements of the storage.
> + * The largest out of place write is the number of blocks that user files can
> + * allocate from any group.
>    *
> - * If the device doesn't advertise atomic writes, then there are no alignment
> - * restrictions and the largest out-of-place write we can do ourselves is the
> - * number of blocks that user files can allocate from any group.
> + * This is a software limit, so it deliberately does not take the alignment
> + * requirements of the storage into account. An atomic write that cannot be
> + * handed to the device as a single naturally aligned REQ_ATOMIC bio is
> + * completed through the COW fork instead, which has no such requirement.
>    */
>   static xfs_extlen_t
>   xfs_calc_group_awu_max(
> @@ -690,15 +688,30 @@ xfs_calc_group_awu_max(
>   	enum xfs_group_type	type)
>   {
>   	struct xfs_groups	*g = &mp->m_groups[type];
> -	struct xfs_buftarg	*btp = xfs_group_type_buftarg(mp, type);
>   
>   	if (g->blocks == 0)
>   		return 0;
> -	if (btp && btp->bt_awu_min > 0)
> -		return max_pow_of_two_factor(g->blocks);
>   	return rounddown_pow_of_two(g->blocks);
>   }
>   
> +/*
> + * Compute the largest atomic write unit for which the allocator can guarantee
> + * naturally aligned extents in this group type.
> + *
> + * Hardware atomic writes have to be naturally aligned on disk.
> + */
> +xfs_extlen_t
> +xfs_calc_group_awu_align_max(
> +	struct xfs_mount	*mp,
> +	enum xfs_group_type	type)
> +{
> +	struct xfs_groups	*g = &mp->m_groups[type];
> +
> +	if (g->blocks == 0)
> +		return 0;
> +	return max_pow_of_two_factor(g->blocks);
> +}
> +
>   /* Compute the maximum atomic write unit size for each section. */
>   static inline void
>   xfs_calc_atomic_write_unit_max(
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 216a38a354e7..a2894c18e3c1 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -812,6 +812,8 @@ static inline void xfs_mod_sb_delalloc(struct xfs_mount *mp, int64_t delta)
>   
>   int xfs_set_max_atomic_write_opt(struct xfs_mount *mp,
>   		unsigned long long new_max_bytes);
> +xfs_extlen_t xfs_calc_group_awu_align_max(struct xfs_mount *mp,
> +		enum xfs_group_type type);
>   
>   static inline struct xfs_buftarg *
>   xfs_group_type_buftarg(
> 
> base-commit: 1282269a5ddb044481e7f8fd43b3195e211d5475

