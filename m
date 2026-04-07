Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96AE22F01
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 11:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775559698; cv=none; b=A54zhGNrvH3QTBm0yId441Mro5GAQvVmDXcKHjRgmfbKk1e4bxqH3GMnlQjk9IKgFP763TjqKccJ83gVJjsTzcKV6EaFIMNl8U4613SCGwwwWnF5AuZ2uIp76+2raE/nSKcfZ3G4kG+cVKX2Qx7Vpef5lIPyuZwGCf7OQ37DJx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775559698; c=relaxed/simple;
	bh=M9FjySlKGONh5VQxKV0TgvXtXzrzlrY7QQ8OZVJB50I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MPUznVaXnX65FpXCVqYXLenOsXBl/+d2M0eyP6Rx7DnFDBCaBY1w1uTAuAvzjagl+nCsF4U7+nxr+m2AjT/cg6TOsS0zl4mSogNb9DDtQJTeeGuOmV8zk/LXH8PBxl9x5Tnh5LMzJ49S4QhMpSy9j5AS64P7GChcaitLLJqFrrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UA8azx6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UA8azx6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF1CC116C6;
	Tue,  7 Apr 2026 11:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775559697;
	bh=M9FjySlKGONh5VQxKV0TgvXtXzrzlrY7QQ8OZVJB50I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UA8azx6ZGUx+V0qNgk2p2L6/McfEg/yoaKkNF2j39sfoWKDy63wkcs28coChqADrM
	 NKK6ws+GvmjRFNq1E2Sc4YFcsQH5Ury8wUDDd2YC8etlINYtixixOrn5mlckkyIb6v
	 2GRBp7J6qRTD/PpwJCIOIMetxLJWCOd5BP0cLztfXDtcI5TkG61wl/dG324sB4nSG/
	 OR9ewMQBXKujDQ2OaLnLjPi4SIQhywJ4l0hcb2dRbR/ZPl7fMmiRNRrkOsgo///eU4
	 T5/2vi2mlnOtfb6Y42ZN2XwPopPGoNd/4yXfPn2qGGNMrzKVhF+l4O5d9033NJGx62
	 xZOHcaB6pTP4Q==
Date: Tue, 7 Apr 2026 13:01:33 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove a duplicate assert in xfs_setattr_size
Message-ID: <adTkBMEP1XGOmLKB@nidhogg.toxiclabs.cc>
References: <20260330131607.3904269-1-hch@lst.de>
 <20260330131607.3904269-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330131607.3904269-2-hch@lst.de>

On Mon, Mar 30, 2026 at 03:15:59PM +0200, Christoph Hellwig wrote:
> There already is an assert that checks for uid and gid changes besides a
> lot of others at the beginning of the function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/xfs_iops.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 208543e57eda..b0256a4a8aa8 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1109,7 +1109,6 @@ xfs_setattr_size(
>  		xfs_inode_clear_eofblocks_tag(ip);
>  	}
>  
> -	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
>  	setattr_copy(idmap, inode, iattr);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
> -- 
> 2.47.3
> 
