Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D81C495524
	for <linux-xfs@vger.kernel.org>; Fri, 14 Aug 2026 18:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786733670; cv=none; b=e77Qrd7PCIB20EP45ZB+gZTfpstV6jJT0h8OqtBLDN/tneQQCxzj4xLQPKPbyuV2MqxgoQPfsje08Ajozs/pQk06hMbsU/ZgNLazwtfw5DcB9qMm8SNLi+14QZc0SW1rBg8xDsg7+FEyD9ryy4f/MqWEbjuuVAxmHhwtljwF67s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786733670; c=relaxed/simple;
	bh=SEgbkQtm1SGAer5c8fwqoVSNRebGQ6MVLPcpsYlen48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YRXEtRG5rHyuhx+veZXJ/9Hf4SloML/TwRX3TOuCpAx+QqxfPLdpFdZcIaoSodfVPuz/745EnfD8tybWAI5jROrz+uRtNWUNkK0aRVcWee3icfK2nQanCVlZBBSR9gGGpamwBDk+c/lgshe+NLIkvDTbWj5xpRwySEcj4VjxPT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NFxHEHCg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFxHEHCg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E309D1F000E9;
	Fri, 14 Aug 2026 18:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786733669;
	bh=niPua/dqWsvO73XYyd2TdQ9ZEgAEqYx0CJI49oOkgqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NFxHEHCgiaGAOLOJ7Ug5g3b7VRBMLlnX0sqYeuyIm5E4NoEcgzarTYunph7bmHWEW
	 rpNXW2xUXiWeYxMuZK8kmf7eoXZFjiCm7bH9xI3nHdU4ZrjLHFOecDtPSUbqVjh2S8
	 vtnw6f7wizhcfnZ3rfbFqLzld0WK6dCin8x441rGlUr7r/jLQeyAgXEzk3G5x+jWOo
	 ZuNS3gotfrouobfq4qNXw3SZj32Jq9YPt2TS9gPR6P4vkVdV+0fXf35XXbvJW+iM76
	 A8cbbQy/GF8Hpl0d5r6D5xdQvtBzXUGZAWyHWywqIaAdDar3Kyk+Zu/KPgak+j82h8
	 D//n06snxuCfA==
Date: Fri, 14 Aug 2026 11:54:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Matt Fleming <matt@readmodwrite.com>
Subject: Re: [PATCH v2 1/3] xfs: set minleft correctly for sparse chunk
 errortag allocation
Message-ID: <20260814185428.GJ3556460@frogsfrogsfrogs>
References: <20260814132239.271492-1-bfoster@redhat.com>
 <20260814132239.271492-2-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814132239.271492-2-bfoster@redhat.com>

On Fri, Aug 14, 2026 at 09:22:37AM -0400, Brian Foster wrote:
> The errortag instrumentation for forced sparse chunk allocation
> jumps straight to the allocation path without setting args.minleft.
> minleft is unconditionally set to ->inobt_maxlevels for the normal
> allocation path. Lift the assignment to the initial args setup so
> it covers all possible paths.
> 
> Assisted-by: LLM
> Fixes: 1cdadee11f8d ("xfs: randomly do sparse inode allocations in DEBUG mode")
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>

This makes sense to me;
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index ffcdd1f691fd..633b2d6e42c5 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -733,6 +733,10 @@ xfs_ialloc_ag_alloc(
>  							igeo->maxicount)
>  		return -ENOSPC;
>  	args.minlen = args.maxlen = igeo->ialloc_blks;
> +
> +	/* Allow space for the inode btree to split. */
> +	args.minleft = igeo->inobt_maxlevels;
> +
>  	/*
>  	 * First try to allocate inodes contiguous with the last-allocated
>  	 * chunk of inodes.  If the filesystem is striped, this will fill
> @@ -764,8 +768,6 @@ xfs_ialloc_ag_alloc(
>  		args.alignment = 1;
>  		args.minalignslop = igeo->cluster_align - 1;
>  
> -		/* Allow space for the inode btree to split. */
> -		args.minleft = igeo->inobt_maxlevels;
>  		error = xfs_alloc_vextent_exact_bno(&args,
>  				xfs_agbno_to_fsb(pag, args.agbno));
>  		if (error)
> @@ -804,10 +806,6 @@ xfs_ialloc_ag_alloc(
>  		 * Allocate a fixed-size extent of inodes.
>  		 */
>  		args.prod = 1;
> -		/*
> -		 * Allow space for the inode btree to split.
> -		 */
> -		args.minleft = igeo->inobt_maxlevels;
>  		error = xfs_alloc_vextent_near_bno(&args,
>  				xfs_agbno_to_fsb(pag,
>  					be32_to_cpu(agi->agi_root)));
> -- 
> 2.55.0
> 
> 
