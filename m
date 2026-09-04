Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078563E2AD7;
	Fri,  4 Sep 2026 16:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788537968; cv=none; b=ttdkDh6Rdt69n92W9mSa1l51zYLjJklBUjM0A+frEJ7kHtSu4XkY19UqneUVJ2Cdm1p1OdBBLZOwMh4Igku7hrKsbwWCTXzjTv3ADtBkiyWhiA+lWpQV749FORPgzOSoThw3//tmq0YRSvtHloNSneUZhqTd0mMWizzrPv292xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788537968; c=relaxed/simple;
	bh=wKT5Ui1EPtHOVPo2Vwsp3PWAj+c9yDv7Ium4FUQIUAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UROIXD3XseaKoA7fnfdPx/GlTEWYy+0ztIOOxZRBc4R/xGwNKcyKEuxLreAyRNoyIZzlSbPsYRVDr7ko3jI1rM6M8ksJ3zSMYjOorEDHEc7mPdUBAuxymegeUN6zdx+Y7rwuV+LCJ8HnQcG0qS1CxNz7GEm2i+HZYuBaoKdfK1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m7v47NWL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m7v47NWL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BC16C1F00A3D;
	Fri,  4 Sep 2026 16:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788537966;
	bh=mdDU4tlM62w6TFDpVrbMGhhp97tiGc1QdOq6Vx8EayM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m7v47NWLw1w/cDnwxPGbsUdDyEln6g9Vx4bOBqYAvSXG+vGPxI4GFOFRN4xATioMj
	 WBUHJrw4NkAoBWCvdtNi3XJBuREANq0/3ydfx1wQML4oyB7OhegSfJOwcE+a78g7zq
	 cYZrUJ9fuoCqW+lzP3NI+Ch4qxkk3K1VmRx3WK3Xme+O0re6dAePRCY4NSyOGfskiI
	 dpVOPhtGLfS3mVktkF0gq8zSxW0QRgTPM+GxuAIHGUuH4p/i1CRCzca4g9meVk6764
	 HVScR0//ctz35VsVxqTImsBHkLzVKHiNN0LQ0MJvgdL2OQNbs3aL7PkyHv8tz6bMoU
	 rYw8qRvU14GbQ==
Date: Fri, 4 Sep 2026 09:06:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix typos in comments
Message-ID: <20260904160606.GY1933798@frogsfrogsfrogs>
References: <20260904112909.8197-1-hemanth.selam@gmail.com>
 <20260904112909.8197-2-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904112909.8197-2-hemanth.selam@gmail.com>

On Fri, Sep 04, 2026 at 04:59:03PM +0530, Hemanth Selam wrote:
> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag.h        | 2 +-
>  fs/xfs/libxfs/xfs_alloc.c     | 4 ++--
>  fs/xfs/libxfs/xfs_attr_leaf.c | 2 +-
>  fs/xfs/libxfs/xfs_errortag.h  | 2 +-
>  fs/xfs/libxfs/xfs_format.h    | 2 +-
>  fs/xfs/scrub/dirtree.c        | 2 +-
>  fs/xfs/xfs_inode.c            | 2 +-
>  fs/xfs/xfs_log_cil.c          | 2 +-
>  fs/xfs/xfs_platform.h         | 2 +-
>  9 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index fd22fe598931..ee636b66a72f 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -207,7 +207,7 @@ xfs_perag_next(
>  }
>  
>  /*
> - * Per-ag geometry infomation and validation
> + * Per-ag geometry information and validation
>   */
>  xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
>  void xfs_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index d99602bcc16f..f762dcce8d13 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3487,7 +3487,7 @@ xfs_alloc_read_agf(
>  }
>  
>  /*
> - * Pre-proces allocation arguments to set initial state that we don't require
> + * Pre-process allocation arguments to set initial state that we don't require
>   * callers to set up correctly, as well as bounds check the allocation args
>   * that are set up.
>   */
> @@ -3608,7 +3608,7 @@ xfs_alloc_vextent_finish(
>  	 * ABBA AGF deadlocks because a future allocation attempt in this
>  	 * transaction may attempt to lock a lower number AGF.
>  	 *
> -	 * We can't release the AGF until the transaction is commited, so at
> +	 * We can't release the AGF until the transaction is committed, so at
>  	 * this point we must update the "first allocation" tracker to point at
>  	 * this AG if the tracker is empty or points to a lower AG. This allows
>  	 * the next allocation attempt to be modified appropriately to avoid
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b6288395f853..2c80f4fd0b78 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1715,7 +1715,7 @@ xfs_attr3_leaf_add_work(
>  			/*
>  			 * This freemap entry starts at the old end of the
>  			 * leaf entry array, so we need to adjust its base
> -			 * upward to accomodate the larger array.
> +			 * upward to accommodate the larger array.
>  			 */
>  			diff = sizeof(struct xfs_attr_leaf_entry);
>  		} else if (ichdr->freemap[i].size > 0 &&
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 6de207fed2d8..f0c83f1f0b3b 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -83,7 +83,7 @@
>  #define XFS_RANDOM_DEFAULT				100
>  
>  /*
> - * Table of errror injection knobs.  The parameters to the XFS_ERRTAG macro are:
> + * Table of error injection knobs.  The parameters to the XFS_ERRTAG macro are:
>   *   1. The XFS_ERRTAG_ flag but without the prefix;
>   *   2. The name of the sysfs knob; and
>   *   3. The default value for the knob.
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index dd0ed046fbe9..1a7a7e60a170 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1051,7 +1051,7 @@ enum xfs_dinode_fmt {
>   * block is 1KB in size.
>   *
>   * With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and
> - * with 1KB sized blocks, a file can reach upto,
> + * with 1KB sized blocks, a file can reach up to,
>   * 1KB * (2^31) = 2TB
>   *
>   * This is much larger than the theoretical maximum size of a directory
> diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
> index b2cf6e5439d9..469ba30670f0 100644
> --- a/fs/xfs/scrub/dirtree.c
> +++ b/fs/xfs/scrub/dirtree.c
> @@ -994,7 +994,7 @@ xchk_dirtree(
>  	return error;
>  }
>  
> -/* Does the directory targetted by this scrub have no parents? */
> +/* Does the directory targeted by this scrub have no parents? */
>  bool
>  xchk_dirtree_parentless(const struct xchk_dirtree *dl)
>  {
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 030a7c8f2c12..621513d7215e 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2669,7 +2669,7 @@ xfs_irele(
>  }
>  
>  /*
> - * Ensure all commited transactions touching the inode are written to the log.
> + * Ensure all committed transactions touching the inode are written to the log.
>   */
>  int
>  xfs_log_force_inode(
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 639f875a8fb2..defd121690f5 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1369,7 +1369,7 @@ xlog_cil_cleanup_whiteouts(
>   * allocation context. However, we do not want to block on memory reclaim
>   * recursing back into the filesystem because this push may have been triggered
>   * by memory reclaim itself. Hence we really need to run under full GFP_NOFS
> - * contraints here.
> + * constraints here.
>   */
>  static void
>  xlog_cil_push_work(
> diff --git a/fs/xfs/xfs_platform.h b/fs/xfs/xfs_platform.h
> index 5d542e95fe44..745d715b4c64 100644
> --- a/fs/xfs/xfs_platform.h
> +++ b/fs/xfs/xfs_platform.h
> @@ -153,7 +153,7 @@ static inline void delay(long ticks)
>  /*
>   * XFS wrapper structure for sysfs support. It depends on external data
>   * structures and is embedded in various internal data structures to implement
> - * the XFS sysfs object heirarchy. Define it here for broad access throughout
> + * the XFS sysfs object hierarchy. Define it here for broad access throughout
>   * the codebase.
>   */
>  struct xfs_kobj {
> -- 
> 2.48.1
> 
> 
