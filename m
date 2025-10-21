Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667EB2877ED;
	Tue, 21 Oct 2025 14:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761058274; cv=none; b=W+Njhvultmbr/NtGUQPLf7QvU09YEJQkIt8nL+zPqNvXGcqN17BAZlo5NcWIgVySOBHff8KyYTTKQHqCUNp37DFX8bXRSvyVb02WU3/o32hDQswiqcn2de3Gy7kFxPVj4vXOfWfQAVtsyLkMU07beCvFsUbxwRXnK+NWl5XvUKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761058274; c=relaxed/simple;
	bh=4j58uT7Q9RaxMbe9w9Sd/lYEYQAeZE1sPmPoN/jramg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SHnA3JVk2lSiekAx8Gmcrs/ER0rYuWlSl32ks2KqJJg5iSVHP7hvcNBMRwY/UuIHg5X18WTSRWnHPP2G9awJHb87y/s0NthXxbCfQp1oOW4i4LCJGcH+D4MRHG1DOLktTiLHUjlmNsIWdgC+zogoZCthP2ay9PAxDcDi+AyF0a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cn8oXSr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cn8oXSr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA4DC4CEF1;
	Tue, 21 Oct 2025 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761058273;
	bh=4j58uT7Q9RaxMbe9w9Sd/lYEYQAeZE1sPmPoN/jramg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cn8oXSr7AB9lkN7l/rANcOok3/1OdG622CRbwrL+nWhUhIRwNTXnV5FcZWiWiCt5Q
	 /AnsyeSIQG4GeV+dCTcciBIgyAxW4i3qcUszQXeVbZRVNSOZwvEztRSgHG0RACRl6l
	 0+5Wfes0lnreqWHqKrxHmE5eUFCAc0HfD6h9/N3SSDaVHfnrYmIHaedbnAwYoWt/Zl
	 hiQwmxl+XW21CsZcRFnMWNVrcQqsZbb6fgQbhynWn7la0HObJWvVphgGQ8WVuIc/tD
	 rOEXPrG0Kb3Q1lHaP/NtRvMC0QOjt4wXaTemELaOBgpS6RjTKZu1uJQ6e6cSXMh6mv
	 dmthJBixlr7TA==
Date: Tue, 21 Oct 2025 07:51:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kriish Sharma <kriish.sharma2006@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linuxfoundation.org,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com
Subject: Re: [PATCH] xfs: use kmalloc_array() instead of kmalloc() for map
 allocation
Message-ID: <20251021145113.GI3356773@frogsfrogsfrogs>
References: <20251018194528.1871298-1-kriish.sharma2006@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018194528.1871298-1-kriish.sharma2006@gmail.com>

On Sat, Oct 18, 2025 at 07:45:28PM +0000, Kriish Sharma wrote:
> Using kmalloc_array() better reflects the intent to allocate an array of
> map entries, and improves consistency with similar allocations across the
> kernel.
> 
> No functional change intended.
> 
> Signed-off-by: Kriish Sharma <kriish.sharma2006@gmail.com>
> ---
>  fs/xfs/xfs_qm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 23ba84ec919a..34ec61e455ff 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1218,7 +1218,7 @@ xfs_qm_reset_dqcounts_buf(
>  	if (qip->i_nblocks == 0)
>  		return 0;
>  
> -	map = kmalloc(XFS_DQITER_MAP_SIZE * sizeof(*map),
> +	map = kmalloc_array(XFS_DQITER_MAP_SIZE, sizeof(*map),

Why would we replace a constant that can be computed at compile time
with a dynamic computation that is now fallible despite NOFAIL?

--D

>  			GFP_KERNEL | __GFP_NOFAIL);
>  
>  	lblkno = 0;
> -- 
> 2.34.1
> 
> 
