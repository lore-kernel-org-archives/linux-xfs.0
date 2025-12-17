Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D088F33DEFC
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 16:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765988880; cv=none; b=YWEUHBS0U+DqQUNMKHR/zdND2nWfRenSuSuYv/Sl3d46kTyHDqGav2kmJIt5/zs2UdzNXMlD0yR69QoVHJbedLK/Us0sZHz6BVcTn0ZSCkjzxpD+dB0TH9div60Bw5D04kOZtL7QT0QKNnZuc+IrIleuxheKD62eAQSUDZYu4Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765988880; c=relaxed/simple;
	bh=PGJlgUkmbyE9ytXPd/1kUL2YqLNQriu257FtNoL3VDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=igE13xYnPRlWNU5O5VLRfNcy+Jq/14VDfhIVmCVLDG5s+ZYZ+cFT46v6QrJiGHqMjuBX30HvICtrgglOd+XRaSHrT02Blcyq7ZSqdud+cm/R6sahaW1r3R5SzZMh2YAs56uFWb3l2hlbvG5DRCgrl9vsz9UMWAo0URwa/iObv5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXKPw1Sw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXKPw1Sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433C8C4CEF5;
	Wed, 17 Dec 2025 16:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765988879;
	bh=PGJlgUkmbyE9ytXPd/1kUL2YqLNQriu257FtNoL3VDs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nXKPw1SwvUBFOEuxNMFTvs5EFBhCdXzwcBOF2AzLZVlWkm7D6xMtVD/fjZLGwz8QT
	 qmSI/27/ielrZPFe8nK/aBNeQXgXGJRf53q1HkB1m3j9pEsnogjKcOwbLlYAuyah00
	 wpZItO37kqKsc2S5gm93zO83uBaNp5z6Xq1qq6WxC1elCipOxtpMuF+9AW7TR6b20a
	 iWac0u5Iodihom8y+2136QPXfvGhPjhK1k4NU+cWCgf43vo7DKQZhvUtoHecGCbID+
	 8gZ1nvggLjUHNrypVyI6vnM2iE8N7mscwGDeGigbQIQ8Xc/0Q73r03LZYVtAjntTKC
	 cmjRVdSWKXZHA==
Date: Wed, 17 Dec 2025 08:27:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	hch@infradead.org
Subject: Re: [PATCH v2] xfs: Fix the return value of xfs_rtcopy_summary()
Message-ID: <20251217162758.GV7725@frogsfrogsfrogs>
References: <c6b04ec9ae584af62317d4c1bcf3f84dfab74be0.1765982438.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6b04ec9ae584af62317d4c1bcf3f84dfab74be0.1765982438.git.nirjhar.roy.lists@gmail.com>

On Wed, Dec 17, 2025 at 08:11:33PM +0530, Nirjhar Roy (IBM) wrote:
> xfs_rtcopy_summary() should return the appropriate error code
> instead of always returning 0. The caller of this function which is
> xfs_growfs_rt_bmblock() is already handling the error.
> 

Please add
Cc: <stable@vger.kernel.org> # v6.7

so this can be autobackported

--D

> Fixes: e94b53ff699c ("xfs: cache last bitmap block in realtime allocator")
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_rtalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 6907e871fa15..bc88b965e909 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -126,7 +126,7 @@ xfs_rtcopy_summary(
>  	error = 0;
>  out:
>  	xfs_rtbuf_cache_relse(oargs);
> -	return 0;
> +	return error;
>  }
>  /*
>   * Mark an extent specified by start and len allocated.
> -- 
> 2.43.5
> 
> 
