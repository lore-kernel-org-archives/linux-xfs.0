Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE98A267B6F
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 15:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744212742; cv=none; b=FsHb0p+XiqH3qYhNPU8Dk98aDyvU5zLVpP7LPplVgggU3MOvPtIPsrIkHJTbF8wlY7LYWQnxQSbldjUDxqCRZMKJuhbG5U38ULyTVVwMSlYEuWF9Dtyg3aDw3wAtbXTKvSpgbrUE6vANJjFiA+qXJX8zmFRru/1v0B2irAmxEO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744212742; c=relaxed/simple;
	bh=369caWH3up312AR2xsCyKUhZz+TkDmU/exbuDJWvRRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IBWdaKH20ui/zLUCKc3r9Zj50qF+9Hn+wZxzMAjUnE2KI57b4VUXuybak6ZnA6XIhf91qu+2Gb+reCtUHj8ILqntMSAu8fphwGryyLdkAhyPO6A1Y4OaUDWodZh96Nb7JtcrRliLzloQ/2Ro5SEYL/FRnWxpQUHR7pu2ENstNPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fZfaxmo3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fZfaxmo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358A6C4CEE2;
	Wed,  9 Apr 2025 15:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744212742;
	bh=369caWH3up312AR2xsCyKUhZz+TkDmU/exbuDJWvRRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fZfaxmo3S0dqmAECVYtTDC8lePB1fLT6Sp/r8KRs8deT+tbSAaxEQYJFFTKZyYqdi
	 kRkmcK4QLv8u85zyOlS+vkbj+GnzfNoWVCWfCzNJbaq434ACf/29P2R1QCMdsQKjGx
	 MllS1eXdvSqmA1zTa9bxI/Qpy6PHEf9ipVmNoNIrNwjfioT99GTDq+lLonyZjwBhep
	 K90klOZde54b2WMULMgW9fTyEh/CiARQyGojIaNiyFAi07ua+cPAjnlOqDKYNRa8iY
	 uN2gtQydih2fMBG3C60r1httviaATt8k//8P3ft9m23Qg3ayWw6M59Trstpvc1XVrM
	 awMTtGzJLmH9g==
Date: Wed, 9 Apr 2025 08:32:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/45] FIXUP: xfs: generalize the freespace and reserved
 blocks handling
Message-ID: <20250409153221.GS6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-3-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:05AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  include/xfs_mount.h  | 32 ++++++++++++++++++++++++++++++--
>  libxfs/libxfs_priv.h | 13 +------------
>  2 files changed, 31 insertions(+), 14 deletions(-)
> 
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index 383cba7d6e3f..e0f72fc32b25 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -63,8 +63,6 @@ typedef struct xfs_mount {
>  	xfs_sb_t		m_sb;		/* copy of fs superblock */
>  #define m_icount	m_sb.sb_icount
>  #define m_ifree		m_sb.sb_ifree
> -#define m_fdblocks	m_sb.sb_fdblocks
> -#define m_frextents	m_sb.sb_frextents
>  	spinlock_t		m_sb_lock;
>  
>  	/*
> @@ -332,6 +330,36 @@ static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
>  __XFS_UNSUPP_OPSTATE(readonly)
>  __XFS_UNSUPP_OPSTATE(shutdown)
>  
> +static inline int64_t xfs_sum_freecounter(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr)
> +{
> +	if (ctr == XC_FREE_RTEXTENTS)
> +		return mp->m_sb.sb_frextents;
> +	return mp->m_sb.sb_fdblocks;
> +}
> +
> +static inline int64_t xfs_estimate_freecounter(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr)
> +{
> +	return xfs_sum_freecounter(mp, ctr);
> +}
> +
> +static inline int xfs_compare_freecounter(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr, int64_t rhs, int32_t batch)
> +{
> +	uint64_t count;
> +
> +	if (ctr == XC_FREE_RTEXTENTS)
> +		count = mp->m_sb.sb_frextents;
> +	else
> +		count = mp->m_sb.sb_fdblocks;
> +	if (count > rhs)
> +		return 1;
> +	else if (count < rhs)
> +		return -1;
> +	return 0;
> +}
> +
>  /* don't fail on device size or AG count checks */
>  #define LIBXFS_MOUNT_DEBUGGER		(1U << 0)
>  /* report metadata corruption to stdout */
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 7e5c125b581a..cb4800de0b11 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -209,7 +209,7 @@ static inline bool WARN_ON(bool expr) {
>  }
>  
>  #define WARN_ON_ONCE(e)			WARN_ON(e)
> -#define percpu_counter_read(x)		(*x)
> +
>  #define percpu_counter_read_positive(x)	((*x) > 0 ? (*x) : 0)
>  #define percpu_counter_sum_positive(x)	((*x) > 0 ? (*x) : 0)
>  
> @@ -219,17 +219,6 @@ uint32_t get_random_u32(void);
>  #define get_random_u32()	(0)
>  #endif
>  
> -static inline int
> -__percpu_counter_compare(uint64_t *count, int64_t rhs, int32_t batch)
> -{
> -	if (*count > rhs)
> -		return 1;
> -	else if (*count < rhs)
> -		return -1;
> -	return 0;
> -}
> -
> -
>  #define PAGE_SIZE		getpagesize()
>  extern unsigned int PAGE_SHIFT;
>  
> -- 
> 2.47.2
> 
> 
