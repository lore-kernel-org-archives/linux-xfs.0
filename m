Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5A63DC4DE;
	Tue,  7 Jul 2026 16:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783441595; cv=none; b=Et9t8si+82RcogBhY0hKWUD2JWLRkkLGUNqAtu/7yEC5DXfEk86WGxTA3RYmkZ+jyuE1Wj/uxz8Xf0dvnX29weaBDzodTTWuFxsL4R8qbSiULx6ahbi+YBStZCxupTORfL4bZ9yCQcaxHzcYsj+9d44hRYzzZCVxELxh5v9Ab5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783441595; c=relaxed/simple;
	bh=lum5oeeKCD4j/cVHFO5EYn5OGnCmsGq/4VrmC0+tlKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TMLOX289a+c41XxAKpHemhUZtrYys384vSi8OtXmh4aHjEDsKSPtI5dWLuFL4RJ/t1wdJ54GC14pZ7kFyW3HRl0lizuoaOyZnV9v2U9Kf7jdxTYu+bWdYby0rnONxl1GfhHgW4gBBqnqluMDT1HMUe/7nJhv9UZzsOv7i1p8gts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NQcTEwww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NQcTEwww"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E58CF1F000E9;
	Tue,  7 Jul 2026 16:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783441593;
	bh=GDe7gdGCabcFLR64SO8DuLlpyHiRrqEMVntPhFZcxgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NQcTEwwwWNH8TiJ+SB/K9f6lNXgnVY043BoTNTweySZHxWxLyJvuEKP49/yugJyDb
	 k618a2Yew1Vjj4bcv9Fc5ZSysoTXTSQkec3MjzSduNKq/cHhAJho2XnmQ70QsPQLfo
	 piUrt+7Zp6zCkd3GAo/GKNO1oj19yqEte7onuWZSJbjVQ01INxb0VuK4XIvgHTcpkp
	 MoC3PTfzXeJjVS/qMWpC8TA2MRfMnupCXEKmnrekr4MvdxpvWjnSUKs3ioapL6BUmI
	 ElAN733m+rPUcrByV0Bx3bOsFhLqgiCfTu02RfrgXHhTSZOkvkr7Rr0E9+U5VGDKIe
	 Pj4ZGxSmBOUYA==
Date: Tue, 7 Jul 2026 09:26:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	Chandan Babu R <chandanrlinux@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: bound inode fork length against the fork size
 during log recovery
Message-ID: <20260707162632.GY9392@frogsfrogsfrogs>
References: <20260707135843.3213352-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707135843.3213352-1-qwe.aldo@gmail.com>

On Tue, Jul 07, 2026 at 10:58:43AM -0300, Aldo Ariel Panzardo wrote:
> xlog_recover_inode_commit_pass2() copies an inode log item's data/attr
> fork region into the inode buffer using the on-log region length without
> bounding it against the fork capacity, e.g.:
> 
> 	len = item->ri_buf[2].iov_len;
> 	memcpy(XFS_DFORK_DPTR(dip), src, len);
> 
> The only guard is an ASSERT, which is a no-op on production kernels
> (CONFIG_XFS_DEBUG off), and xfs_dinode_verify() runs only after the copy.
> A crafted image with a dirty log can therefore drive a heap out-of-bounds
> write at mount time. The XFS_ILOG_DBROOT sibling already passes
> XFS_DFORK_DSIZE as a bound; the DDATA/DEXT and ADATA/AEXT memcpy paths
> did not.
> 
> Reject the log item with -EFSCORRUPTED when the region length exceeds the
> destination fork size.
> 
> Fixes: 658fa68b6f34 ("xfs: refactor log recovery inode item dispatch for pass2 commit functions")
> Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

This is a bug fix, it should engage the LTS backporting process:
Cc: <stable@vger.kernel.org> # v5.8

> ---
>  fs/xfs/xfs_inode_item_recover.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 169a8fe3bf0a..388d3a8dbd31 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -510,6 +510,10 @@ xlog_recover_inode_commit_pass2(
>  	switch (fields & XFS_ILOG_DFORK) {
>  	case XFS_ILOG_DDATA:
>  	case XFS_ILOG_DEXT:
> +		if (len > XFS_DFORK_DSIZE(dip, mp)) {
> +			error = -EFSCORRUPTED;
> +			goto out_release;
> +		}

But in any case this is new validation code, which means that it should
go at the top the function before we memcpy anything into the ondisk
inode.

--D

>  		memcpy(XFS_DFORK_DPTR(dip), src, len);
>  		break;
>  
> @@ -545,8 +549,11 @@ xlog_recover_inode_commit_pass2(
>  		switch (in_f->ilf_fields & XFS_ILOG_AFORK) {
>  		case XFS_ILOG_ADATA:
>  		case XFS_ILOG_AEXT:
> +			if (len > XFS_DFORK_ASIZE(dip, mp)) {
> +				error = -EFSCORRUPTED;
> +				goto out_release;
> +			}
>  			dest = XFS_DFORK_APTR(dip);
> -			ASSERT(len <= XFS_DFORK_ASIZE(dip, mp));
>  			memcpy(dest, src, len);
>  			break;
>  
> -- 
> 2.43.0
> 
> 
