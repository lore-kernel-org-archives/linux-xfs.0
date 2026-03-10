Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CF23BA23E
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 08:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773131309; cv=none; b=NdCwKiIKos87AIiNrKEI6T681a4iDyFoBGGyRqBTDq/S4iogrcFiFbcPWchhXKeiD7U+SmSzoyuE4J7HM2gxAjDdbk2G1yEYQicMRLRbfNtKpI7OjXhSJA7LErWI2aAnZyTiHiq1MDBrddneCFYbMpaU1e9SjwWddvSn0GbE20A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773131309; c=relaxed/simple;
	bh=yDO8M76uWfuHow2+JrSX9Pr8Ii86Qn3UXPB10QW688Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CKjc3P6qd3YUFxVJRfNj6vPMMQlNQQJn2RuGFY46p5l6cG7tKvWQTHhiYFIbJYWIPOh2GUeVj5ky/ADqQpiIZIvK0L9nsIFBM8baKSqIBDLJCC/NBMObPZm74Mcjsj6E36v52fZOH0d/85Z8S3p3YQLB2ukedyeL45LbgAgiNb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uSCuak7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uSCuak7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3ADC19423;
	Tue, 10 Mar 2026 08:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773131309;
	bh=yDO8M76uWfuHow2+JrSX9Pr8Ii86Qn3UXPB10QW688Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uSCuak7accjiCPFRbMeLqsqSrxK57zuR0WSY71+U+dsEusodBLhnqi3zc7yXlgblA
	 9LyFYxmTIOraVIiG3Gv5JrBTcMLBhJ0M0W1KIKDDQKEcxZy5HTYXg1QdDiG5QWTqLS
	 l5bwZS+vI1rAID/hfVqhnVd8u+947ZjO20wD5gF4C/XC89m30+D15R8XakpoowMJ1w
	 p0ON9t/hngEflitndC22z6hR9er+khblmVxCtYZoYxWQfLLIVhDTVlAsFozwdTCrfi
	 hBk1iOaeHwXbSrhwHFQuF83YoW+9VVeE+0v+12tYu8gdSh7trtWqYCADrA2mx5hEZh
	 V9VLSDUt9iqOw==
Date: Tue, 10 Mar 2026 09:28:24 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com, 
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH 1/2] xfs: remove redundant set null for ip->i_itemp
Message-ID: <aa_WIfmSdFg9ytVB@nidhogg.toxiclabs.cc>
References: <20260305084922.800699-1-leo.lilong@huawei.com>
 <20260305084922.800699-2-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305084922.800699-2-leo.lilong@huawei.com>

On Thu, Mar 05, 2026 at 04:49:21PM +0800, Long Li wrote:
> ip->i_itemp has been set null in xfs_inode_item_destroy(), so there is
> no need set it null again in xfs_inode_free_callback().
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/xfs_icache.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a7a09e7eec81..2040a9292ee6 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -159,7 +159,6 @@ xfs_inode_free_callback(
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
