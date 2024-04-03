Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C751C280
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 03:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712116451; cv=none; b=gWhVAz0AkqMqQoR8hOocvfiM5eVmQCiAZo/bCMoJR9YO9sVAhJUCNhviZAEfyguzIiTw7B3M2m5j1tjyOtuZdtSk+TQ4hrfKp40nR9z/D/X4pdfr6kMhY9eXqBxVm/5YDskhp0Yv6D9ovSGfRJe19vEgI//tOTB4HKJZpPGQx9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712116451; c=relaxed/simple;
	bh=pOC8VHwuRo3RCCFTwHkPDG1lJju3NP55I0etqwL6NUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ufp24dklM9kdUwHtEz+0O98LbCrXODmCQmuTlCL81rrs826oEwJLwKXvGFJgj3z4eqUeLCMhZtQkYgcQtHelbJS/3YpdFakvAXdvuJaz1WdBk6FVDT8HjpQ6nwupjuYghTHoF5K2BNymzXaT2c/WbSzABogQBeJr1sLlkuOeW74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0zh/mc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0zh/mc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA22C433C7;
	Wed,  3 Apr 2024 03:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712116450;
	bh=pOC8VHwuRo3RCCFTwHkPDG1lJju3NP55I0etqwL6NUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E0zh/mc77CMySe+NVyafaugZGpM1AHUX8xBR1epmjIuOZTTbY4jDvBXpkRea+2WWr
	 QIJ2x6P3Y8qcLXx1st9O6l9XM+b0k6NbUJlTheqMragmDHGuHT4mblCtEGOMcBIhdC
	 AauAG31KLV4d7PYe/xi+F9ut+hneD/i+Ki2e5VhfAVm6VMWJ1yC/43k0R9vBn8pL6e
	 Cr3lbi+qq45AQcXr+vTV7X2PaV+VPLWp6QtSH2J32wGMZK30uFdnt1tuP1IvWRgOq3
	 vs3lD1aPG+kScq91jyYv7gdKO0gbcnTG3+bsl5FP9/K4KaZZruwy91g1k/6mw2mJhy
	 OewlmiukFCQnw==
Date: Tue, 2 Apr 2024 20:54:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: remove unused is_rt_data_fork() function
Message-ID: <20240403035410.GN6390@frogsfrogsfrogs>
References: <20240402213541.1199959-1-david@fromorbit.com>
 <20240402213541.1199959-5-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402213541.1199959-5-david@fromorbit.com>

On Wed, Apr 03, 2024 at 08:28:31AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Sparse warns that is_rt_data_fork() is unused. Indeed, it is a
> static inline function that isn't used in the file it is defined in.
> It looks like xfs_ifork_is_realtime() has superceded this function,
> so remove it and get rid of the sparse warning.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/rmap_repair.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
> index e8e07b683eab..7e73ddfb3d44 100644
> --- a/fs/xfs/scrub/rmap_repair.c
> +++ b/fs/xfs/scrub/rmap_repair.c
> @@ -432,14 +432,6 @@ xrep_rmap_scan_iroot_btree(
>  	return error;
>  }
>  
> -static inline bool
> -is_rt_data_fork(
> -	struct xfs_inode	*ip,
> -	int			whichfork)
> -{
> -	return XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK;
> -}
> -
>  /*
>   * Iterate the block mapping btree to collect rmap records for anything in this
>   * fork that matches the AG.  Sets @mappings_done to true if we've scanned the
> -- 
> 2.43.0
> 
> 
