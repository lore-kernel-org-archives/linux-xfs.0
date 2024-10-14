Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139C6156237
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728894262; cv=none; b=WTKJBCK6Se/pGOqpp4OR+fVAzk26Jkz4TOI0UuTs5frlmlT0tGGlel+crYyhtzL9WLVW6lfrN4jDR9OBYCvYJlOpDaDkrlhjkm40wKs7AbYHxus14YYLXs4A3h14nK2cKGkOatsMQ33e7CW6Lv3/ENbS1doZ8QTbZqFVQqYwRqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728894262; c=relaxed/simple;
	bh=hXiiUm24+ZrvyrlZumJzU+GRk3qoGbd35S96jnR6C04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f/HZ5LHiemxScbaiQQQNpM4BzkWAWeZr2IfN4OPBrSYdv9KR8B2W1uwlZgHDCOEAZUpOCk5x2DtlJ7G9cPPVJ6QA3hyhmqg8T4/9eNyJdiGJXtZAlBHtPfZbb/kX+fmDzMPhu/UuipUPxLRD2IIUeTk7vvNEYj/opoad97ayCZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GBl41G+z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GBl41G+z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6s7opn/6vu1gW19gNHPidvZkUoTGuFhu9LN3S3sZJQo=; b=GBl41G+zAoxhHTnY/ipGwsOeUm
	AwkVx1JvPcfE9c/PwEz/ODw0dCFtyypCz0fUum8QAO08gSHAbJHMdeFneWNt18keqPbI/Vio1+2ba
	xrHagzD7kdHT2sQkCSNeDS24tFARkQeOa45b0u0TZp908WkB8Nj5IJIS9XuXeTeuz1FaQ16/lHd43
	SflPjsQDjRFJh2DyQlkm3+UU76esZnQofCWu/Sw3QqGToeYFtTeB5a0s84/UpqL9VHzTcKYvAUZIu
	QtBEkKQEBd0JoHKUBjzs7PGqrbiimeGd8iwlyMGX50B6PtjSZJ02kjSJrrWxdr0++kdEPB36ENh2b
	qr6FDRhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0GNH-00000004GFp-1tcQ;
	Mon, 14 Oct 2024 08:24:19 +0000
Date: Mon, 14 Oct 2024 01:24:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/6] xfs: fix chown with rt quota
Message-ID: <ZwzVMxg-Z0qtuL2v@infradead.org>
References: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
 <172860645695.4180109.15774707176031680844.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860645695.4180109.15774707176031680844.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 10, 2024 at 06:12:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make chown's quota adjustments work with realtime files.

Maybe explain how you made it work here?

> @@ -1393,18 +1393,17 @@ xfs_qm_dqusage_adjust(
>  
>  	ASSERT(ip->i_delayed_blks == 0);
>  
> +	lock_mode = xfs_ilock_data_map_shared(ip);
>  	if (XFS_IS_REALTIME_INODE(ip)) {
> -		struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
> -
>  		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
> -		if (error)
> +		if (error) {
> +			xfs_iunlock(ip, lock_mode);
>  			goto error0;
> -
> -		xfs_bmap_count_leaves(ifp, &rtblks);
> +		}

So this obviously was missing locking :)

>  	}
> -
> -	nblks = (xfs_qcnt_t)ip->i_nblocks - rtblks;
> +	xfs_inode_count_blocks(tp, ip, &nblks, &rtblks);
>  	xfs_iflags_clear(ip, XFS_IQUOTAUNCHECKED);
> +	xfs_iunlock(ip, lock_mode);

But this now also forces lockign for !rt file systems, I guess
we don't really care about an extra ilock roundtrip in chown,
though.

The changes itself look good, but a useful commit log would be nice:

Reviewed-by: Christoph Hellwig <hch@lst.de>
