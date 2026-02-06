Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46E92E1C6B
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 06:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770359910; cv=none; b=inA0h91AKiQkisiptcnJkv4T56I8p26Qt8k8TvEkcQJm+AIznE7Fb1YNTMN6o632h56nSd23bhSXQOwi4p5nTj+gcLOA9LI0ZdMBBBdZpfyrCnPPZUtA+WcqN0WlLKHu5KXQGC2eoq/ZuiR4X6P4LoArVMMalxtAUy8cPHo4eo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770359910; c=relaxed/simple;
	bh=n5qM7YWZ55Fc287yHdMDXdwQkRzv3nFV7f+dM6qNWv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLfvIWmEFAfsPiw8vssNul9/0wlMus1gMixX3nssr4LcR5D+fAvDoa4kjdFV55aMXcGl9R/hl7fD54Z/1nMxnTS/3YjpEivLkZs2Enzms2lbYvP4FKpaVn+Ll/JXYZsqgg2XYe8I4FaLn3dcccS+qZvTc1f5vc7bW2ehzM7YKfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JWS2CQP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JWS2CQP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30549C116C6;
	Fri,  6 Feb 2026 06:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770359910;
	bh=n5qM7YWZ55Fc287yHdMDXdwQkRzv3nFV7f+dM6qNWv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JWS2CQP46K0qFCNcv/1BhMTpaPmJtXRqMMGqyG3pee5EpLfha84brPWkaFd4+HBPF
	 6ekUhd6sM1blRyexGZSo+/u4CnASNBarrOO1gYjkqd1OwxCsQRDR7dkMwDysuHKyhu
	 px+KEvB4f05tZl1TUO28pUQXoFoWbSrv/0K9BG892QgsYVvoA1v2fTIQhMHKalo+0p
	 vbnxirF1FdbBe8U/3hcjpr/Qzjl2fx7FHjd/QMhQZAcbjFGNxR0dAi7ndA2woYCFou
	 ql/teWoF5+IyfqisDma8Ou1IRR4iPGXIi5qbv6pmd6K93TePOjxQD82cvkeS2zDids
	 X/kMwFHHBZnmw==
Date: Thu, 5 Feb 2026 22:38:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: cleanup inode counter stats
Message-ID: <20260206063829.GW7712@frogsfrogsfrogs>
References: <20260202141502.378973-1-hch@lst.de>
 <20260202141502.378973-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202141502.378973-2-hch@lst.de>

On Mon, Feb 02, 2026 at 03:14:31PM +0100, Christoph Hellwig wrote:
> Most of the are unused, so mark them as such.  Give the remaining ones
> names that match their use instead of the historic IRIX ones based on
> vnodes.  Note that the names are purely internal to the XFS code, the
> user interface is based on section names and arrays of counters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With the s/of the/of them/ typo that Nirjhar mentioned fixed, this looks
fine to me.  I've long thought those fields were unused, so I'm glad
they're finally getting cleaned out.

(and yes I agree that the struct layout stuff means we should just leave
the fields and maybe reuse the space some day; and not otherwise change
the struct layout)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c |  6 +++---
>  fs/xfs/xfs_stats.c  | 10 +++++-----
>  fs/xfs/xfs_stats.h  | 16 ++++++++--------
>  fs/xfs/xfs_super.c  |  4 ++--
>  4 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index dbaab4ae709f..f76c6decdaa3 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -106,7 +106,7 @@ xfs_inode_alloc(
>  	mapping_set_folio_min_order(VFS_I(ip)->i_mapping,
>  				    M_IGEO(mp)->min_folio_order);
>  
> -	XFS_STATS_INC(mp, vn_active);
> +	XFS_STATS_INC(mp, xs_inodes_active);
>  	ASSERT(atomic_read(&ip->i_pincount) == 0);
>  	ASSERT(ip->i_ino == 0);
>  
> @@ -172,7 +172,7 @@ __xfs_inode_free(
>  	/* asserts to verify all state is correct here */
>  	ASSERT(atomic_read(&ip->i_pincount) == 0);
>  	ASSERT(!ip->i_itemp || list_empty(&ip->i_itemp->ili_item.li_bio_list));
> -	XFS_STATS_DEC(ip->i_mount, vn_active);
> +	XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
>  
>  	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
>  }
> @@ -2234,7 +2234,7 @@ xfs_inode_mark_reclaimable(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	bool			need_inactive;
>  
> -	XFS_STATS_INC(mp, vn_reclaim);
> +	XFS_STATS_INC(mp, xs_inode_mark_reclaimable);
>  
>  	/*
>  	 * We should never get here with any of the reclaim flags already set.
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index 017db0361cd8..bc4a5d6dc795 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -42,7 +42,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  		{ "xstrat",		xfsstats_offset(xs_write_calls)	},
>  		{ "rw",			xfsstats_offset(xs_attr_get)	},
>  		{ "attr",		xfsstats_offset(xs_iflush_count)},
> -		{ "icluster",		xfsstats_offset(vn_active)	},
> +		{ "icluster",		xfsstats_offset(xs_inodes_active) },
>  		{ "vnodes",		xfsstats_offset(xb_get)		},
>  		{ "buf",		xfsstats_offset(xs_abtb_2)	},
>  		{ "abtb2",		xfsstats_offset(xs_abtc_2)	},
> @@ -100,15 +100,15 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  void xfs_stats_clearall(struct xfsstats __percpu *stats)
>  {
>  	int		c;
> -	uint32_t	vn_active;
> +	uint32_t	xs_inodes_active;
>  
>  	xfs_notice(NULL, "Clearing xfsstats");
>  	for_each_possible_cpu(c) {
>  		preempt_disable();
> -		/* save vn_active, it's a universal truth! */
> -		vn_active = per_cpu_ptr(stats, c)->s.vn_active;
> +		/* save xs_inodes_active, it's a universal truth! */
> +		xs_inodes_active = per_cpu_ptr(stats, c)->s.xs_inodes_active;
>  		memset(per_cpu_ptr(stats, c), 0, sizeof(*stats));
> -		per_cpu_ptr(stats, c)->s.vn_active = vn_active;
> +		per_cpu_ptr(stats, c)->s.xs_inodes_active = xs_inodes_active;
>  		preempt_enable();
>  	}
>  }
> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index 153d2381d0a8..64bc0cc18126 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -100,14 +100,14 @@ struct __xfsstats {
>  	uint32_t		xs_iflush_count;
>  	uint32_t		xs_icluster_flushcnt;
>  	uint32_t		xs_icluster_flushinode;
> -	uint32_t		vn_active;	/* # vnodes not on free lists */
> -	uint32_t		vn_alloc;	/* # times vn_alloc called */
> -	uint32_t		vn_get;		/* # times vn_get called */
> -	uint32_t		vn_hold;	/* # times vn_hold called */
> -	uint32_t		vn_rele;	/* # times vn_rele called */
> -	uint32_t		vn_reclaim;	/* # times vn_reclaim called */
> -	uint32_t		vn_remove;	/* # times vn_remove called */
> -	uint32_t		vn_free;	/* # times vn_free called */
> +	uint32_t		xs_inodes_active;
> +	uint32_t		__unused_vn_alloc;
> +	uint32_t		__unused_vn_get;
> +	uint32_t		__unused_vn_hold;
> +	uint32_t		xs_inode_destroy;
> +	uint32_t		xs_inode_destroy2; /* same as xs_inode_destroy */
> +	uint32_t		xs_inode_mark_reclaimable;
> +	uint32_t		__unused_vn_free;
>  	uint32_t		xb_get;
>  	uint32_t		xb_create;
>  	uint32_t		xb_get_locked;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 149b659e1692..3f25a0001a61 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -725,8 +725,8 @@ xfs_fs_destroy_inode(
>  	trace_xfs_destroy_inode(ip);
>  
>  	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
> -	XFS_STATS_INC(ip->i_mount, vn_rele);
> -	XFS_STATS_INC(ip->i_mount, vn_remove);
> +	XFS_STATS_INC(ip->i_mount, xs_inode_destroy);
> +	XFS_STATS_INC(ip->i_mount, xs_inode_destroy2);
>  	xfs_inode_mark_reclaimable(ip);
>  }
>  
> -- 
> 2.47.3
> 
> 
