Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE032EB5A6
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 18:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788979964; cv=none; b=dc/pLOWZH/1q0zIDg+rimpPmssipmHMSp/G2XoZFCuzeEUZNhSg5pdmV/j4vbnutw99CBmsMwYPqcpH/0CCnHII8M3s95wuP7rvigulsvSYaFi8iCB/bLkCKoEphp2cqo3jt9HJP05rDbbnp+I3fy0x4AeMY+TCoNbY9cicv9Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788979964; c=relaxed/simple;
	bh=U26yjVxm3V8Af94ohahQRLxv/QdDRCTZ31+wariNA1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mOGzV0UtqqAalLvmNw7lmAaDFcvKs/sQaZw9TJH2V5jvaedYZfWkUhnxoboxY+yHl5NGNfxgeK8FEeXxRudEBmgQG3v4jFM9x7rmVqZOi1QLWTMW2QuAO2Q3f0H/s9U6K+FdHLWMLQQgrw+4nouvZ5OLeB0qtoa8qt8azFcIPnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/YbbfB1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/YbbfB1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8339B1F00893;
	Wed,  9 Sep 2026 18:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788979962;
	bh=brzdYwbaXPt+orJhYogPRVGpPMLAms2sG+BV/VCtDfc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V/YbbfB12bXM1g7EX7xpxmHRVGAGe5UYSe1u5rLzHqUE4/wF5djV/7CJslAtWBF40
	 smRG+SS8cZrpcImUhovhvVLN+dQU2IJM5j4btTYqXyHqAWiAizI6KJhQTmrTL3QHTN
	 4vdDAU+4x7i5WM3dqmDBWd9hiPfJ/3I91Nc/sdSAkpkVe/1Z936GupTb4NrztvJlmP
	 gaV8gqbZCAEyfvcjUoy3QV1Y+TN9M9PhR9Yer8fdIbdvqWv8klOAGkbUIX2v0blZYf
	 eOagydQNrZSjBQUHi0GdspC7bKU2qj/grS8ek/IobXgheOsBix4kd9b5Nqv7c36cHZ
	 wJb1XBPOL7QKA==
Date: Wed, 9 Sep 2026 11:52:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: convert all !XFS_RT stubs to inline functions
Message-ID: <20260909185241.GA6238@frogsfrogsfrogs>
References: <20260909060619.1101875-1-hch@lst.de>
 <20260909060619.1101875-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909060619.1101875-2-hch@lst.de>

On Wed, Sep 09, 2026 at 09:05:26AM +0300, Christoph Hellwig wrote:
> Avoid random compiler warnings about unused variables when CONFIG_XFS_RT
> is not set.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine to me.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.h | 49 ++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 43 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
> index 78a690b489ed..1d5108861acd 100644
> --- a/fs/xfs/xfs_rtalloc.h
> +++ b/fs/xfs/xfs_rtalloc.h
> @@ -46,10 +46,34 @@ int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
>  int xfs_growfs_check_rtgeom(const struct xfs_mount *mp, xfs_rfsblock_t dblocks,
>  		xfs_rfsblock_t rblocks, xfs_agblock_t rextsize);
>  #else
> -# define xfs_growfs_rt(mp,in)				(-ENOSYS)
> -# define xfs_rtalloc_reinit_frextents(m)		(0)
> -# define xfs_rtmount_readsb(mp)				(0)
> -# define xfs_rtmount_freesb(mp)				((void)0)
> +static inline int
> +xfs_growfs_rt(
> +	struct xfs_mount	*mp,
> +	struct xfs_growfs_rt	*in)
> +{
> +	return -ENOSYS;
> +}
> +
> +static inline int
> +xfs_rtalloc_reinit_frextents(
> +	struct xfs_mount	*mp)
> +{
> +	return 0;
> +}
> +
> +static inline int
> +xfs_rtmount_readsb(
> +	struct xfs_mount	*mp)
> +{
> +	return 0;
> +}
> +
> +static inline void
> +xfs_rtmount_freesb(
> +	struct xfs_mount	*mp)
> +{
> +}
> +
>  static inline int		/* error */
>  xfs_rtmount_init(
>  	xfs_mount_t	*mp)	/* file system mount structure */
> @@ -60,8 +84,21 @@ xfs_rtmount_init(
>  	xfs_warn(mp, "Not built with CONFIG_XFS_RT");
>  	return -ENOSYS;
>  }
> -# define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (-ENOSYS))
> -# define xfs_rtunmount_inodes(m)
> +
> +static inline int
> +xfs_rtmount_inodes(
> +	struct xfs_mount	*mp)
> +{
> +	if (mp->m_sb.sb_rblocks)
> +		return -ENOSYS;
> +	return 0;
> +}
> +
> +static inline void
> +xfs_rtunmount_inodes(
> +	struct xfs_mount	*mp)
> +{
> +}
>  
>  static inline int
>  xfs_growfs_check_rtgeom(const struct xfs_mount *mp,
> -- 
> 2.53.0
> 
> 
