Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E5918BC0C
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 16:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724431049; cv=none; b=qZ2hCYzxHnv5D9MA55tsxnZVPAMEXueQBVzVuSK7l5+235L6qZb4C6+W/uda8VDA8gv2IsYU9AkalCj1vOq1fZ516Mh5gb/Rd0jJ/9xOcdatjW+U0w7i/pAdahZ6HjniHMcHWH+fTNV5DPpiHMDZXjG0bUMbvYpJmIqeAutCAQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724431049; c=relaxed/simple;
	bh=6JY/37mI8rE/+vW9tzv2e68yIV0HZ9teMcMi7zB1oTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FLbgv5XukoCQIkyAcu+vOURkS5udIKPK26pisS+s2518OJwSSTejdcMfdU2Voeay0K7Gzb6iiC8Zh9ABZ1nfXX+ne1c3IKzy+G33hlKPztEzZQV7OFVf0vATR/38G0qE0FLxXWbXuBnOQqvT3RInXLSzcrVJifCLegcPeiFr9ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kRL3Ru6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kRL3Ru6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5C5C4AF0B;
	Fri, 23 Aug 2024 16:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724431049;
	bh=6JY/37mI8rE/+vW9tzv2e68yIV0HZ9teMcMi7zB1oTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kRL3Ru6mpgApkJEIB3rJzR6qgszG45lCt03GKXyvK6K8jkNTSzLuFjHFZ21S5z3zu
	 bYWHOzLsEx9tEcIH1ckXmpsoGYJtwpUNPjcZnDP5H1mn1PA7s+ORehNxuwSYTqn6av
	 YQUQHi/Do069f91/O3XBWJFgg7LtkzmGSBF9XQ6SeLv/+beA2kb2ffCG/4WihBzDAj
	 7NtYJ9LCQFZN8/h/3vVIsKEQBxNyWYde7a1dXT6lEWxXA/eMEJVmuSx9ftxt1bPQ7w
	 RwVqWoHc6QiqzIEWi6do0b5oYprLYNUEQGxc7m+tKXGcnklxerkJWhLf7rkf05wuTS
	 4fKeImvKv0ykQ==
Date: Fri, 23 Aug 2024 09:37:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 1/5] xfs: remove redundant set null for ip->i_itemp
Message-ID: <20240823163729.GE865349@frogsfrogsfrogs>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823110439.1585041-2-leo.lilong@huawei.com>

On Fri, Aug 23, 2024 at 07:04:35PM +0800, Long Li wrote:
> ip->i_itemp has been set null in xfs_inode_item_destroy(), so there is
> no need set it null again in xfs_inode_free_callback().
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>

Seems reasonable,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index cf629302d48e..a5e5e5520a3b 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -143,7 +143,6 @@ xfs_inode_free_callback(
>  		ASSERT(!test_bit(XFS_LI_IN_AIL,
>  				 &ip->i_itemp->ili_item.li_flags));
>  		xfs_inode_item_destroy(ip);
> -		ip->i_itemp = NULL;
>  	}
>  
>  	kmem_cache_free(xfs_inode_cache, ip);
> -- 
> 2.39.2
> 
> 
