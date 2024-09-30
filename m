Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C1118FC9F
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 12:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727700990; cv=none; b=BMvfinHGtF6bZmSc83sSshcbO9Thg1n8fSvErtgsI/w27JfIrFMjqVc7NuZ0hUmez7LwnPzBCJujbznsrtvhVHcJ4FpKff+J82qcyvyDiwxB9iZk8Wx0dnIlbrT7A+4nU0o07E7naPXwef8eiwgjjmJhAWuvNoWFWKT2QfHoBCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727700990; c=relaxed/simple;
	bh=wsoDJKCxPmNd6Tsrk/Se0CGLtBmgcYKmgTXQuk03+E0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IwSjnhS6olCF2Xb3Yo/PBSMb7i+x1U/nOu0ZoSBxPpeqTURGBap/N9QbsKZJsK3EK/7VuWu4rb7fhCGaDqQv0+GTBCSZleVksLghoYWEqx01aUxE5kURxTA3yqQmFGD+H/rO0Meq91fzyhWHpeHwoKaZfSLxxzhlNrRoju5u/dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BzWbJhFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BzWbJhFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C66C4CECD;
	Mon, 30 Sep 2024 12:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727700989;
	bh=wsoDJKCxPmNd6Tsrk/Se0CGLtBmgcYKmgTXQuk03+E0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BzWbJhFKiaNhEzik3OwRAmosm6im0hq7O8J0lU0Uhr8P3O+CwXFuZQfIetzvo7dk5
	 BjkN2J2TVNBHYaYdoVrDg6GChZL2inW/xldZS9M/rVVM1DOa2jZChdMcZipNwNyJqS
	 NVkvk0W0/aV4gEMPGWLotfGE7TXqCSv572GoCRtA2pzVBcyTfV/dcL9OY/YF01Nb7I
	 mpDsAh7zi8GR7I9YLaQ/1BP7B5oWQ/0XzMhw3xqiCB62DZWMXBH1lPhR6teUrMoDTq
	 BRoPOC69/CG6BRmDnRoX95HzDua4+LVif7lfjZYdonOt2xvVO12Rtt0Rdaz8pvLtvZ
	 /dph2GDfAIZhg==
Date: Mon, 30 Sep 2024 14:55:47 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, chandanbabu@kernel.org, linux-xfs@vger.kernel.org, 
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [next] xfs: remove the redundant xfs_alloc_log_agf
Message-ID: <5zvq7ax2ih27chjwl65keftyplz3bzyz4deblrnq4xe5pvoudb@va4yxbk7tqkb>
References: <20240930104217.2184941-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930104217.2184941-1-leo.lilong@huawei.com>

Hello.

What do you mean with the [next] tag in the subject, instead of usual [PATCH]
tag?

On Mon, Sep 30, 2024 at 06:42:17PM GMT, Long Li wrote:
> There are two invocations of xfs_alloc_log_agf in xfs_alloc_put_freelist.
> The AGF does not change between the two calls. Although this does not pose
> any practical problems, it seems like a small mistake. Therefore, fix it
> by removing the first xfs_alloc_log_agf invocation.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 59326f84f6a5..cce32b2f3ffd 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3159,8 +3159,6 @@ xfs_alloc_put_freelist(
>  		logflags |= XFS_AGF_BTREEBLKS;
>  	}
>  
> -	xfs_alloc_log_agf(tp, agbp, logflags);
> -

Hmm.. Isn't this logged twice because of lazy-count?


Carlos


>  	ASSERT(be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp));
>  
>  	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
> -- 
> 2.39.2
> 
> 
