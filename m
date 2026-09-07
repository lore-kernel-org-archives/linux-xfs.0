Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFA838F250;
	Mon,  7 Sep 2026 06:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762007; cv=none; b=s0kF1fzXuCmLfoob+Fd7FL1/ix+sFVCjwStUrJwptabGR1fnzjcdDXZUqxdOwSfjnEScEY7mRyZshJ+XAD+eP86fOB0bkP9J3PcOTetpSMyTdmtXQRnKbZk2kRuFpJSpHy7QPXsLUbmIrrUjk8KkWgpmcY4Aa/g/KENnfAUUKLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762007; c=relaxed/simple;
	bh=EpTwUgzYUI+VT7l5NAx2oOc8rFo+fwEIT+ORuMKp3IY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aRRRHDePMQA0OpD0z7X3USH/rCXfShX+4/eSrizF9GYJ6KiSL4181SAtT9Iad26g4bhh1qHPCqV6D0oO/7iq1CJm2waU/XXXO5ICu2A5EdxME3p2H2e3oqSS6dQwiJIdAM4IObvRy6FOYwE+Hye0Icv1h9x0ZaLxJNAxRmifsHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LI/POFGs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LI/POFGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EE91F00A3A;
	Mon,  7 Sep 2026 06:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788762005;
	bh=35m7H9HS+mlaq5Q27CFMZWaXSkYQOwdOB9qmm0HiASY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LI/POFGsueX5riioVdpleTGnencWxC/vTNfVOiQWHT3X0qAjKRMdBV8HHqf7LK0Yt
	 Jfv9FI5tiVXuEIedXwdnLpWse0JgsEKIFjSAuwKW4+G+bISqZD0XqY7Ql/DS4Qrz9U
	 mdTaVkAfcajYcRDevNVvGHClUFxV9EwOxrwSWEEHXnYu/lZckCH9BLXcEHEKTRyaDF
	 YTvTivlXL4J5sp/Pe7ztmUMx6/THbSGvi9KOgqrV1jrm6rVAekL4Ug0gNRx2kqeHT6
	 oMvr5lmbnxchEEVliPtD51Mz6B6e+dB+ShgK426RQ2+RjUzEJMMwEUpAHUQv8aYKN1
	 OaidIP2SEAbnA==
Date: Mon, 7 Sep 2026 08:20:00 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: dgc@kernel.org, djwong@kernel.org, hch@lst.de, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, yangerkun@huawei.com, 
	chengzhihao1@huawei.com, wozizhi@huawei.com
Subject: Re: [PATCH V2] xfs: remove several unused and never-implemented
 declarations
Message-ID: <ap5XiYSFR93gZOGl@andromeda.toxiclabs.cc>
References: <20260905010354.142327-1-wozizhi@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905010354.142327-1-wozizhi@huaweicloud.com>

On Sat, Sep 05, 2026 at 09:03:54AM +0800, Zizhi Wo wrote:
> From: Zizhi Wo <wozizhi@huawei.com>
> 
> Over time a number of function declarations in various headers have become
> stale: either their implementations were removed when their last callers
> went away, or they were never implemented in the first place. None of them
> refer to anything anymore.
> 
> Remove the following dead declarations and the unused stub:
> 
> - xlog_assign_tail_lsn() and xlog_assign_tail_lsn_locked()
> - xfs_iext_realloc()
> - xfs_buf_iodone()
> - xfs_scrub_tester() and xfs_scrub_setup_inode_bmap_data() (never
>   implemented placeholders)
> - the !CONFIG_XFS_ONLINE_REPAIR stub of xrep_tempfile_iolock_both()
> 
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> v2:
>  - Squash the individual cleanup patches into a single patch, as suggested
>    by Carlos.
>  - Drop the former patch 4, since an equivalent change has already been
>    merged upstream.
>  - Remove the "Assisted-by:" tag.
> 
> v1: https://lore.kernel.org/all/20260904060648.1966130-1-wozizhi@huaweicloud.com/
> 
>  fs/xfs/scrub/common.h   | 1 -
>  fs/xfs/scrub/scrub.h    | 1 -
>  fs/xfs/scrub/tempfile.h | 4 ----
>  fs/xfs/xfs_buf_item.h   | 1 -
>  fs/xfs/xfs_inode.h      | 1 -
>  fs/xfs/xfs_log.h        | 2 --
>  6 files changed, 10 deletions(-)
> 
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index 9d627fd50687..f0f073a93413 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -74,7 +74,6 @@ int xchk_setup_ag_rmapbt(struct xfs_scrub *sc);
>  int xchk_setup_ag_refcountbt(struct xfs_scrub *sc);
>  int xchk_setup_inode(struct xfs_scrub *sc);
>  int xchk_setup_inode_bmap(struct xfs_scrub *sc);
> -int xchk_setup_inode_bmap_data(struct xfs_scrub *sc);
>  int xchk_setup_directory(struct xfs_scrub *sc);
>  int xchk_setup_xattr(struct xfs_scrub *sc);
>  int xchk_setup_symlink(struct xfs_scrub *sc);
> diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> index 6d7d3523b71f..737a5d6db15f 100644
> --- a/fs/xfs/scrub/scrub.h
> +++ b/fs/xfs/scrub/scrub.h
> @@ -261,7 +261,6 @@ static inline int xchk_nothing(struct xfs_scrub *sc)
>  }
>  
>  /* Metadata scrubbers */
> -int xchk_tester(struct xfs_scrub *sc);
>  int xchk_superblock(struct xfs_scrub *sc);
>  int xchk_agf(struct xfs_scrub *sc);
>  int xchk_agfl(struct xfs_scrub *sc);
> diff --git a/fs/xfs/scrub/tempfile.h b/fs/xfs/scrub/tempfile.h
> index 71c1b54599c3..d44ed43bafe0 100644
> --- a/fs/xfs/scrub/tempfile.h
> +++ b/fs/xfs/scrub/tempfile.h
> @@ -39,10 +39,6 @@ int xrep_tempfile_roll_trans(struct xfs_scrub *sc);
>  void xrep_tempfile_copyout_local(struct xfs_scrub *sc, int whichfork);
>  bool xrep_is_tempfile(const struct xfs_inode *ip);
>  #else
> -static inline void xrep_tempfile_iolock_both(struct xfs_scrub *sc)
> -{
> -	xchk_ilock(sc, XFS_IOLOCK_EXCL);
> -}
>  # define xrep_is_tempfile(ip)		(false)
>  # define xrep_tempfile_adjust_directory_tree(sc)	(0)
>  # define xrep_tempfile_rele(sc)
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 3159325dd17b..28c79989d725 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -60,7 +60,6 @@ static inline void xfs_buf_dquot_iodone(struct xfs_buf *bp)
>  {
>  }
>  #endif /* CONFIG_XFS_QUOTA */
> -void	xfs_buf_iodone(struct xfs_buf *);
>  bool	xfs_buf_log_check_iovec(struct kvec *iovec);
>  
>  unsigned int xfs_buf_inval_log_space(unsigned int map_count,
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 34c1038ebfcd..1602027cd0aa 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -585,7 +585,6 @@ uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
>  int		xfs_ifree(struct xfs_trans *, struct xfs_inode *);
>  int		xfs_itruncate_extents_flags(struct xfs_trans **,
>  				struct xfs_inode *, int, xfs_fsize_t, int);
> -void		xfs_iext_realloc(xfs_inode_t *, int, int);
>  
>  int		xfs_log_force_inode(struct xfs_inode *ip);
>  void		xfs_iunpin_wait(xfs_inode_t *);
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index ca66429bf6c9..f715695e8fcb 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -105,8 +105,6 @@ int	  xfs_log_mount(struct xfs_mount	*mp,
>  			int		 	num_bblocks);
>  int	  xfs_log_mount_finish(struct xfs_mount *mp);
>  void	xfs_log_mount_cancel(struct xfs_mount *);
> -xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
> -xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
>  void	xfs_log_space_wake(struct xfs_mount *mp);
>  int	xfs_log_reserve(struct xfs_mount *mp, int length, int count,
>  			struct xlog_ticket **ticket, bool permanent);
> -- 
> 2.52.0
> 
