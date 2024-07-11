Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892557462
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 02:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720666327; cv=none; b=hsOhQDYW0MZEPrxH8TKNsl1OYGe3LPv24PzZMJkTScRBU4SI7UTtxs19ONEuPNogF4+r3qMdyNyzksYKJRxt5IahAAPZdqUtfedarWR4dP+2Ux9gPT+Zg0y/aFnG4I2SsBdfLiRHsJiG1F2b+4me1ADgI8/Sm4Z7S+dVbKPY9x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720666327; c=relaxed/simple;
	bh=HB+oWvrkwQktw/DxjrG1Nl0hNW1qYUoVzGnFuy2YB8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iJs7zntFjUnWW02JPfzBspjPaZO0fVZVPgiEwkNE/idx1OiLNO/1vYupX5dE0Z5N+UgObBCcr2CLPQ2gK/yIuZbI6T0iRv+0HOFrkrX6vMCaUt0lM0yj+pJt7WC8Ac/fZBSsgnrugZEX8RhVySahSW3zFJrPQYfZ10DrTuoDobg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sNSeld/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sNSeld/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED974C32781;
	Thu, 11 Jul 2024 02:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720666327;
	bh=HB+oWvrkwQktw/DxjrG1Nl0hNW1qYUoVzGnFuy2YB8g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sNSeld/dKDLMAKLBpQboiihq9w2p9p2e4S4Tn5SJ13jSMSvvQdyeIl+LEw0Eu25Ge
	 sFtBiXi99Iub2Q8Xsh0Mb+gALex+34l5bXVugJ3UEujXokzx2WZ/+gNlu0wWMmlP9V
	 R4oE6TDYJovtQMNvAJc+Ws8w8vrhz7Ex9DsBcMbTOfNaH5C/EvPnaE28NyRuoPfOpC
	 7qE5HpfAOfbJE6jzNYuYxUMeZxcP914Kt0IxZPzARNNcyLTejfp0Y2LcwWDQ2iK/5Z
	 0jYD/Xpz5Ob9RT/gehZUIpgqBd/Vaxy1jExI1tZyp56wEu6idTE9wsCb29Sr+nEGya
	 kEgTHSAp7akkg==
Date: Wed, 10 Jul 2024 19:52:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: update XFS_IOC_DIOINFO memory alignment value
Message-ID: <20240711025206.GG612460@frogsfrogsfrogs>
References: <20240711003637.2979807-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240711003637.2979807-1-david@fromorbit.com>

On Thu, Jul 11, 2024 at 10:36:37AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> As of v6.0, the DIO memory buffer alignment is no longer aligned to
> the logical sector size of the underlying block device. There is now
> a specific DMA alignment parameter that memory buffers should be
> aligned to. statx(STATX_DIOALIGN) gets this right, but
> XFS_IOC_DIOINFO does not - it still uses the older fixed alignment
> defined by the block device logical sector size.
> 
> This was found because the s390 DASD driver increased DMA alignment
> to PAGE_SIZE in commit bc792884b76f ("s390/dasd: Establish DMA
> alignment") and DIO aligned to logical sector sizes have started
> failing on kernels with that commit. Fixing the "userspace fails
> because device alignment constraints increased" issue is not XFS's
> problem, but we really should be reporting the correct device memory
> alignment in XFS_IOC_DIOINFO.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_ioctl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index f0117188f302..71eba4849e03 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1368,7 +1368,8 @@ xfs_file_ioctl(
>  		struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
>  		struct dioattr		da;
>  
> -		da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
> +		da.d_mem = bdev_dma_alignment(target->bt_bdev);

bdev_dma_alignment returns a mask, so I think you want to add one here?

Though at this point, perhaps DIOINFO should query the STATX_DIOALIGN
information so xfs doesn't have to maintain this anymore?

(Or just make a helper that statx and DIOINFO can both call?)

--D

> +		da.d_miniosz = target->bt_logical_sectorsize;
>  		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
>  
>  		if (copy_to_user(arg, &da, sizeof(da)))
> -- 
> 2.45.1
> 
> 
