Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7A4188A36
	for <linux-xfs@vger.kernel.org>; Tue, 17 Sep 2024 19:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726599648; cv=none; b=tRUB1sL+6mppPcY2k3a+R1vYDc1r3Kf7oztfWb/PbwGmdmU2CgyO2bs9EN57EQcw/x/UG9AErPNFe0Z5Ht6/GBGEi/8hVBuIsWxjsTxf+V8O3SqrZzmWGHj6iPlX7YGWg8NvOnMlehimXY8PZVZoet/XK7nz5AuQcswOl+WYXEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726599648; c=relaxed/simple;
	bh=QgM4ZzDoNFi08vP3ZeXLjTv0CAM+R0netaSJBKRVf3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bCE+2ms7cUOhUuBZ+N0Uo/hjZXEpR0/KYnCbTBnDBaAukeTp3P/+7qEUBt7pL49g0JV2L0DopoeTXtgWrPxZ2oR83/fGqD2jHMgF+K5XL5gAzaBex5VXzdi7lon2HJe5aaPEbvbdNI4l4GUkcM4In8RibNQ+4GrcDPEy6Cqmh9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nBVWZmtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nBVWZmtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DBAC4CEC5;
	Tue, 17 Sep 2024 19:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726599647;
	bh=QgM4ZzDoNFi08vP3ZeXLjTv0CAM+R0netaSJBKRVf3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nBVWZmtJWveU8N6rFDrhjezavo6ltU8Nc1KkCjYBEcIui6uNC8JS4acah5z6wNx34
	 2uvXrL4/8Llz7LgBRXyWZXJa6jJMtWkEJyaAlkvLEu5j8sE4CwwjjJ+xg0jcqmkGqN
	 yLqo11ecImdfJyzOzC/3yiDxru2lnEMjHDpO6aksxwnHtGTK1m5NzyKGzQgeR5zjIy
	 Uk9mScQXv9VCC71LqCNUbXRrU4f1/R6tI+Nv1+ydGy/spjjN1rvKu1sxp4nRiHPwHN
	 163qoFeBtpjG7RwvZ1dV1g06lnskfqGDToGyQEAKOtAfL3AnmhP0i1Y6oQg4PVyFiw
	 9xycw9gKFB0WA==
Date: Tue, 17 Sep 2024 12:00:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: don't use __GFP_RETRY_MAYFAIL
Message-ID: <20240917190047.GM182194@frogsfrogsfrogs>
References: <20240910042855.3480387-1-hch@lst.de>
 <20240910042855.3480387-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910042855.3480387-5-hch@lst.de>

On Tue, Sep 10, 2024 at 07:28:47AM +0300, Christoph Hellwig wrote:
> __GFP_RETRY_MAYFAIL increases the likelyhood of allocations to fail,
> which isn't really helpful during log recovery.  Remove the flag and
> stick to the default GFP_KERNEL policies.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Sounds fine to me
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 3f695100d7ab58..f6c666a87dd393 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -289,7 +289,7 @@ xfs_initialize_perag(
>  		return 0;
>  
>  	for (index = old_agcount; index < agcount; index++) {
> -		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> +		pag = kzalloc(sizeof(*pag), GFP_KERNEL);
>  		if (!pag) {
>  			error = -ENOMEM;
>  			goto out_unwind_new_pags;
> -- 
> 2.45.2
> 
> 
