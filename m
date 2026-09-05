Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77BC2DECBF
	for <linux-xfs@vger.kernel.org>; Sat,  5 Sep 2026 01:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788570696; cv=none; b=fV+vGL1rppELd2PPRjq7QBRf8Ql7oTxO2KAchsZI3hcgzEMU+fCVj0fbgcoJ//xJ08DeJ93koA8yzS9oDg3+okhiDOXPrYk+PYFSf9mwOYboHZy/PUQin5H3XlzaYVWJYi8Be7P96gxECiIN81gJm+0JGSmsnu1gs/slUInCF4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788570696; c=relaxed/simple;
	bh=AuKJaxnKUO11Sbbca5zk9ZSxj2ydeGROCm0gqBqz/bs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ILgUqOlcn2dCGuv/Wm/GAlm0FQbayg4JJ4BI4M/WUygphyv5BvfZERvH5QiIl4HPyBaJCqUqhUn/gYKwW6LtSwLpouPvvJAzU9ZW0mRTpFyoe8ax09aM1HmgyPVILQfaNycxQWrpgZNx0KmyP9Zy2owQYiHxIbniRcV2LdS0dKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aYYKgRhy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aYYKgRhy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BC8801F00A3D;
	Sat,  5 Sep 2026 01:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788570694;
	bh=IbTm9eu07gHv9c68YXE0eYkKRzvimjqPxsYmsFEFGe8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aYYKgRhySUDk+vF6E4z516DAtd7UOiQ3ObioKt+TXt+LCSR5n1CgKfCkEu7xwqawh
	 JKCXcOnSXkgVip+1/zyXrILK6Fg3tlQ4ZQp4Yg6Wi88cjYuWkdwiGVaedgtFMSjO9n
	 Y6rLLIB3DDNRoW0y8cT1SSiQMcuDXC6PBw+mbroSR+l+XUTvcxxtQ9czjx+umAKunC
	 h+7ZTxBR/t9UXdw0PPDfY6lyzzIsjNmPI31uCVR+Q2Lbu9YCWsKUeGGroFsdonpj8N
	 PNbE7HYH9C8vO7bpFAsjJAXUbPmwmmhryp1cfM1qQST7fst3PkiuY4m5Yrr67124mh
	 2Y140f57STBxA==
Date: Fri, 4 Sep 2026 18:11:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anuj Gupta <anuj1072538@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH] xfs: remove unused xfs_reflink_remap_range declaration
Message-ID: <20260905011134.GH1933798@frogsfrogsfrogs>
References: <20260904123641.3028007-1-anuj1072538@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904123641.3028007-1-anuj1072538@gmail.com>

On Fri, Sep 04, 2026 at 06:06:41PM +0530, Anuj Gupta wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> The implementation was inlined into xfs_file_remap_range() by commit
> 3fc9f5e40931 ("xfs: remove xfs_reflink_remap_range"), leaving this
> declaration orphaned.
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_reflink.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 9d1ed9bb0bee..683c1841e640 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -48,9 +48,6 @@ extern int xfs_reflink_end_cow(struct xfs_inode *ip, xfs_off_t offset,
>  int xfs_reflink_end_atomic_cow(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t count);
>  extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
> -extern loff_t xfs_reflink_remap_range(struct file *file_in, loff_t pos_in,
> -		struct file *file_out, loff_t pos_out, loff_t len,
> -		unsigned int remap_flags);
>  extern int xfs_reflink_inode_has_shared_extents(struct xfs_trans *tp,
>  		struct xfs_inode *ip, bool *has_shared);
>  extern int xfs_reflink_clear_inode_flag(struct xfs_inode *ip,
> -- 
> 2.43.0
> 
> 
