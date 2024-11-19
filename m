Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CF23C463
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 16:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732033303; cv=none; b=GQwIkOLcjyuEREYwR8FIOGBMFoqor/9HaN5ObaD827AbO1BVjAWWHVems6XVl3cqtvXqD8AfPRBusBKCerC2mP0qNWSpqieicj91MC3eGSb5wfCg8wk7Vre9iyJdXAn0Yk8P6hZUC34pmprkZv8HXfJfI3kJOlCc+n+yIi9Dutc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732033303; c=relaxed/simple;
	bh=Wy0PTcinMyydjMjWOODphZ6YgTaJNAgT+6mdZYjfrno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EakbKaOHO7WwSZyyT2U+pte5X4YYeT2hoqxE1dgNQ5iynTAWLW87Wm6bOkyhWrODC3zVubtHAPXOrxpDLQIiiKOTPVYoYt9GbpgKhOxPMc2wHRpyC5lnCHuN3tHmBgR+igr5ZdZEyzcR++Rnes2hZOwePdqG5EqNgBSUDqvXic8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VoAOioX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VoAOioX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D521C4CECF;
	Tue, 19 Nov 2024 16:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732033303;
	bh=Wy0PTcinMyydjMjWOODphZ6YgTaJNAgT+6mdZYjfrno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VoAOioX0X4R5v4P5LTMT5S4lXGo1n6+LVY9JWwzr6gsA1Ppi1+NJXvVRqVNnY1lH8
	 M3Pccnq9x3xB4ieDeG9/E/gLIuIghor25m8Nl6hfdz7w+1mcfBFmtCgZra4vooodn8
	 JtJFclmk1gqZEhIdJFX+n+eg3fcffZXMnf9uma39pyhwi1nBcBcMDvtf2Fco/gQxmW
	 GYloao0ZHOIYCdrThwNvt+UpSXpaM6Mgrd8DXLCvR1UuXwK3ZoYe0sti+pQHGvCcFq
	 /ETD4KtsYsmV2+8sH0MOwbZV6f3A1+Zz8759xYVcSP3yM1veGQkihFGdCQZajuwTid
	 1dN6xwmhCkhug==
Date: Tue, 19 Nov 2024 08:21:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: use the proper conversion helpers in
 xfs_rt_check_size
Message-ID: <20241119162142.GX9438@frogsfrogsfrogs>
References: <20241119154959.1302744-1-hch@lst.de>
 <20241119154959.1302744-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119154959.1302744-3-hch@lst.de>

On Tue, Nov 19, 2024 at 04:49:48PM +0100, Christoph Hellwig wrote:
> Use the proper helpers to deal with sparse rtbno encoding.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_rtalloc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 90f4fdd47087..a991b750df81 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1233,13 +1233,13 @@ xfs_rt_check_size(
>  	struct xfs_mount	*mp,
>  	xfs_rfsblock_t		last_block)
>  {
> -	xfs_daddr_t		daddr = XFS_FSB_TO_BB(mp, last_block);
> +	xfs_daddr_t		daddr = xfs_rtb_to_daddr(mp, last_block);
>  	struct xfs_buf		*bp;
>  	int			error;
>  
> -	if (XFS_BB_TO_FSB(mp, daddr) != last_block) {
> +	if (xfs_daddr_to_rtb(mp, daddr) != last_block) {

Er... this converts the daddr to a segmented xfs_rtblock_t type, but
last_block is a non segmented xfs_rfsblock_t type.  You can't compare
the two directly.  I think the code was correct without this patch.

--D

>  		xfs_warn(mp, "RT device size overflow: %llu != %llu",
> -			XFS_BB_TO_FSB(mp, daddr), last_block);
> +			xfs_daddr_to_rtb(mp, daddr), last_block);
>  		return -EFBIG;
>  	}
>  
> -- 
> 2.45.2
> 
> 
