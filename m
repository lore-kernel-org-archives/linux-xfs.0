Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3F92904
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 16:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711728961; cv=none; b=e96umEFPqzRqJ/tLyMEHEOPhHHcE2MTkLDhc/6uYQJGxkGHuKDGB8jvF+BhLBq24LgiR0OeLbwWDdi4+xR74yaUSH5NbR6q/bIGUL8tgJ2oMYPwTLNapkqRQA1MZeVDaoaRhS9+iTq5uZGfR+KJ/+BWAYvBtYD8pqvTmbA3Nh84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711728961; c=relaxed/simple;
	bh=NW1LEJkitrqog3Q7HQUtrtO+yb9gO0qCZXG9xRsZr5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FOpBgHVhSeX2OKp6wp5N2IK6xCmKLK/y8hudoPmcORKArLPEbevZZybRqZlGrRYfwb0N/M8DajBwWOfr2RBxK1oJMpkH5cUYIUfvhL00ATukZZ8CPmZQqPI20AxPJlqOJ8y9c4XsikZUZzCkb1W61pz/1lrknI46l7ATzTXYxzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lqQZtXoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lqQZtXoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4BAC433F1;
	Fri, 29 Mar 2024 16:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711728961;
	bh=NW1LEJkitrqog3Q7HQUtrtO+yb9gO0qCZXG9xRsZr5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lqQZtXoGYuYjWRQAtkstx7GHj7ckpEVlITwPb7WvJukp1JKCEJ2y4REhWrIaTt3k3
	 vjzsTekyBxPxvUc74Ymx2zxxAWhZhYiXbYJDX4P01Z6uq7R0kJ6mpr9NYjSpz/6iLS
	 Mil2xljISjmKOPAInTrfhTMGYgNIFn9LJG+r+FbyQe3WR2qQglRXrATNiDnA4OHpFZ
	 H5URT39hV6DuTQeah56YGmWt6gNfaSQcnIGGNnWjrqOMA2A7vQFF3TjVsFFQeikEoT
	 vTPJ2U8ndeh541d+Fney7cqTfxMS5HqttbpxlXwY+wNJIyxQOgvmOoKKtSWkvU8QYv
	 non03yNEtUm+A==
Date: Fri, 29 Mar 2024 09:16:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: consolidate the xfs_quota_reserve_blkres
 defintions
Message-ID: <20240329161600.GF6390@frogsfrogsfrogs>
References: <20240328070256.2918605-1-hch@lst.de>
 <20240328070256.2918605-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328070256.2918605-3-hch@lst.de>

On Thu, Mar 28, 2024 at 08:02:52AM +0100, Christoph Hellwig wrote:
> xfs_trans_reserve_quota_nblks is already stubbed out if quota support
> is disabled, no need for an extra xfs_quota_reserve_blkres stub.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_quota.h | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index 85a4ae1a17f672..621ea9d7cf06d9 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -123,12 +123,6 @@ extern int xfs_qm_newmount(struct xfs_mount *, uint *, uint *);
>  extern void xfs_qm_mount_quotas(struct xfs_mount *);
>  extern void xfs_qm_unmount(struct xfs_mount *);
>  extern void xfs_qm_unmount_quotas(struct xfs_mount *);
> -
> -static inline int
> -xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
> -{
> -	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
> -}
>  bool xfs_inode_near_dquot_enforcement(struct xfs_inode *ip, xfs_dqtype_t type);
>  
>  # ifdef CONFIG_XFS_LIVE_HOOKS
> @@ -187,12 +181,6 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
>  	return 0;
>  }
>  
> -static inline int
> -xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
> -{
> -	return 0;
> -}
> -
>  static inline int
>  xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
>  		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, int64_t dblocks)
> @@ -221,6 +209,12 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
>  
>  #endif /* CONFIG_XFS_QUOTA */
>  
> +static inline int
> +xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
> +{
> +	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
> +}
> +
>  static inline int
>  xfs_quota_unreserve_blkres(struct xfs_inode *ip, int64_t blocks)
>  {
> -- 
> 2.39.2
> 
> 
