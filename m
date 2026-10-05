Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C4C47ACCA
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 11:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791198178; cv=none; b=j9mOkuT3L4vpDR6+1isWy+qowwGcRY7mIrEN1E/KjMQobUk8t5Wpn11pAhq8HNcc6uuFMyxU9peZbwBK3OxYiF4N5kDQb/EIthmMcgRFY9FBAOLxIp1Vfq4AllFBCBmdGX9CQGZWP1Kyjru2KTHhRFJQ+0ywtIJp81jbc/K93JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791198178; c=relaxed/simple;
	bh=4lPQ3Q7lJy3p2Yv5TmRiFx1X5SP5x6JkOGd82nNzSQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VUUv+LWbLnd+m8I6iT09YMaf/B5BN9a9jtCTQWeRpbki4zPohk+iAagzO11dT7LshwvREPvSHLL5BODCrM1nrkGa/SufQIjiTTf/gtmWLl8n/0Uo9Uslt2WwfgmlPUsuVYlkLMz3iXYAsm8jlbUqxjIH9pRh1Ual/Xjj7IUQgqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=saJU+O4I; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="saJU+O4I"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4lPQ3Q7lJy3p2Yv5TmRiFx1X5SP5x6JkOGd82nNzSQ4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791198174; v=1; x=1791802974;
 b=saJU+O4I/z1p2ghctNGYgIrBODWtFu4s0mvnRVMuKeg3d2w2LBD5a5lR8beKaOpTMjjXfMJ2
 elqVHjuSYZuR0FeEOs9TKAUgu6SVtq5LmdetVszuw2eknPpUpEXC3KP8YjgHsOG6VX+0eNtQ0lf
 ZLiX0FoTNrICdvcwXq/wFtMU=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 1725c5c189ce122b;
	Mon, 05 Oct 2026 11:02:43 +0000
X-Mizu-Trace-ID: 1725c5c189ce122b
X-Migadu-Flow: FLOW_OUT
Message-ID: <00ac6666-685f-4f00-986e-0bbb7f3920e9@linux.dev>
Date: Mon, 5 Oct 2026 12:02:39 +0100
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
> 
> mkfs caps agsize one block below 1T, so any filesystem with maximum sized
> AGs has an odd agsize. max_pow_of_two_factor() will return 1 for odd
> agsize.
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

would this be better is a common location (so that it could be reused)?

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

xfs_get_atomic_write_max() value is calculated based on HW atomic 
support. I am wondering if we should add a function to just give the max 
CoW-based atomic, and have it called here and from 
xfs_get_atomic_write_max(). Not a big deal, though.

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

unsigned int? But is there a possibility that the value in 
XFS_FSB_TO_B(mp, align_max_fsb) can exceed an unsigned int?

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

