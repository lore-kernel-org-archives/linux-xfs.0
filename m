Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE273ADBB4
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 10:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037554; cv=none; b=nMaxgJUQn3QecBFf7UHBmpMDti3qXriPijwKhhd2XzywRJwnGssI3ZJreSu2uqBCYNl/AE4ATVvgoqX67t1nWc9Lh7SAE2nUekUcMxgV7WcT1PXZbubTxNif0elO1n+5QupCtWt8U2wf39fqTgSeM8gSMSYBOVeUk60tGNoQ6qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037554; c=relaxed/simple;
	bh=TWgBlRaVXLTtLjOmAuVvSAmywddg0l61Fc/+fKsNUVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H3KP/S+URxLccXDVgGOi29eTK34mMNV64vpW+3irUaTdcn6cJIBbwjXfUhJJrUINUP3nFcz1Z8YxkQKdcwcrJfYWwaroLgWgk/bso4LSIomDnK4pwQwXYBR58TnGMCJQr/OyF6dENreei8LJtjdA+PV6Edo6PGye1G2/4GSfBE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V24Y4oJg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V24Y4oJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D941D1F000FF;
	Thu, 10 Sep 2026 10:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789037552;
	bh=UXPi+z3HUSDQiT1ezutmVeefzpGF2q0YwI/U/PLmfAA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V24Y4oJgImynOS09pQsEKK0ABmTO2OTFsQBL6UEVGRKzkFwHdxNGxVBLNwdZZKQmr
	 QVMLFZWJXHWMgvAxjvcWkk+90/qw/M3la+hswfdRRGSZyhfsaxys1Kj+nDriPllyMU
	 MG3tdRwSgeWx6GoibPvUiLSEJNp1PrdDowRiZv9bEr6+4jmYlsmrU/eop1TsdaHYjW
	 Oopx/7s4f/NxpcmSWGZ7mJFwcM3/qgYPsNB/rtaX8/bV5xKUP3dbS1wOSlsaTbN51T
	 aE5e8o1sp5jp2bPyynMPuGVMlyXSSxB/MywyIqdcHC8t88aWgyNn+F7otYRZxzjrB1
	 ZPXy7MmLAHz8Q==
Date: Thu, 10 Sep 2026 12:52:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: convert all !XFS_RT stubs to inline functions
Message-ID: <aqKLCEHV7KYnSl0D@andromeda.toxiclabs.cc>
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
> ---
>  fs/xfs/xfs_rtalloc.h | 49 ++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 43 insertions(+), 6 deletions(-)

This looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Regarding rebasing 7.4, we still have plenty of time to do that, I will
do it once Linus pulls in the next fixes so it won't mess up with hashes
on for-next. Then I can rebase 7.4 on top of the new -rc once the
patches gets in.


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
