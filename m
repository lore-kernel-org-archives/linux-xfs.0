Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7417E32B989
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 22:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773700438; cv=none; b=rjB2PcWBKl40XVYI/OCDf6ePlwk5yoeg06Yn3T43JgToI6twSPMR3XP+2hn7/vlCUdlOyFUMaZdEgIioQX3NbEnhcRnZUNo0HOoGcV56rpoEAeDf/UnV28mk9ogXqufzEO0+l56PGVYrvZtQSyx5vk6rk5aPdU3qOODMQCEeh+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773700438; c=relaxed/simple;
	bh=V2wmFzpW/dbToCDYTC1Lri5lZy2iANvoH4hFPOaLPPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLhpaoLfkYYliWh3Hsq21fVyMoZKt0N3nOkH9vjLwkACLUfc7vgANdYT2So16FfNvwCZDn5/CBocKbQHRk2ZVDJUD5ojTMdSIjnvMEVpwuuWojdoPY6VJSpoELTrWPPbA7mp/2I4o5XmbrzMztwy89P1HyylCcPreXqH59yCifI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=phEWy2Ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="phEWy2Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE03EC19421;
	Mon, 16 Mar 2026 22:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773700438;
	bh=V2wmFzpW/dbToCDYTC1Lri5lZy2iANvoH4hFPOaLPPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=phEWy2ZebspikuvVMEN7rf9NBZ/L2DyQ+XOa06LT5wPdcXHnjaAAufEa9ao3+71jd
	 JphFOX2OfD334wYo3nHzafpROQ/1RfdVY/dmkAegsfVlpzvdYKhnJqDtOUWQE+5XZZ
	 MOLN0msEGbH/pmU1cbULARyrmCL0ynUmGW57qP+zQed3xxas+OYhOvnhwFHpeK/ql+
	 Kd8V78RRmWbTqtr2jop2X1VGs4kCyQ+b72Kxv6vWX9s4kVP+iWIK4GJq7hCCHYaExF
	 dUH9n8CblaDFsni1Kvh3Ynru+i/2ZctXPWjjNTA8N4zGyAtL9HwMeCENdsxBwkh3jL
	 9MX/xl1Gm83pg==
Date: Mon, 16 Mar 2026 15:33:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH 1/3] xfs: fix possible null pointer dereference in
 xfs_attri_recover_work
Message-ID: <20260316223357.GC1770774@frogsfrogsfrogs>
References: <20260316012416.2413909-1-leo.lilong@huawei.com>
 <20260316012416.2413909-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316012416.2413909-2-leo.lilong@huawei.com>

On Mon, Mar 16, 2026 at 09:24:14AM +0800, Long Li wrote:
> When xlog_recover_iget() or xlog_recover_iget_handle() fails, ip is
> not guaranteed to be initialized. Calling xfs_irele(ip) unconditionally
> in the error path may dereference a null pointer.

Don't you need to fix the variable declaration with a null initializer
too?

--D

> Cc: <stable@vger.kernel.org> # v6.9
> Fixes: ae673f534a30 ("xfs: record inode generation in xattr update log intent items")
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_attr_item.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 354472bf45f1..3d3ac8dad519 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -653,7 +653,8 @@ xfs_attri_recover_work(
>  		break;
>  	}
>  	if (error) {
> -		xfs_irele(ip);
> +		if (ip)
> +			xfs_irele(ip);
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, attrp,
>  				sizeof(*attrp));
>  		return ERR_PTR(-EFSCORRUPTED);
> -- 
> 2.39.2
> 
> 
