Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9E91E7C1C
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 21:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744235323; cv=none; b=LnZ+fZo8N/wokiu5BaTdtD5q0JOiJjBnFpUeaczmSB7+x7MzZs28a6RUiYkfbAgutR7mXVcZhMonnAAG/t4I9bMUDI0JQAul8jye8kJ+HyUeCpYxKVQo5dsTkVrinvBgUsjA7/0QONPoV0ndDtJLBtV7LZBQ5x4qD7plcmV8BTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744235323; c=relaxed/simple;
	bh=+8TLKMiF+bNpErNX6Ez4o7UTXkSnQp6xKCuNlphc5UY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cRdzZsiH5zSgnr9SiBIoURSucYfyVsx0gDkDS7TbBJ1ii/P4ddgwT/jbKICLR4C0bwzOfR9lm/btAC6AJOB6ABxL8W9d9gNJxFDj178fmyofpXVP2dw+9FF77VOsztvR075V8qMqytjngLbQ7Nx0H7u07/ClvZah+iEmfgsAUfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s4DokNnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s4DokNnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E257C4CEE2;
	Wed,  9 Apr 2025 21:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744235322;
	bh=+8TLKMiF+bNpErNX6Ez4o7UTXkSnQp6xKCuNlphc5UY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s4DokNnTTC6s9e/MU+kvBICgxoKECyta0PR0OoQzJDZAa21DoANBl1a4olCORWETQ
	 x5mMdaaUXiwH/qLF1wWtuoF7Emn++SVAw4hPaEAbxtXwPnixnUE5bNvqttjOq55uTM
	 62J4QoMmjix/M0LW6DpiEZEWdgSkGpwlCNa+vpF7crEdaYoWPo7/WX78EFlWg0R3Nj
	 4rMKdZcbu97xXJ9wRrhuttAKmt8GyDX1asakDo/otduMyBBZze4m5fqJs0yvwf1h0g
	 3qmtl0V1WWdav/KN8bXx3wpRxqv5qNJZs6STggM1LlUKJkQWpNCDLB1qxFyjnro/J+
	 sX97tS1SHhOTw==
Date: Wed, 9 Apr 2025 14:48:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 40/45] xfs_io: handle internal RT devices in fsmap output
Message-ID: <20250409214842.GT6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-41-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-41-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:43AM +0200, Christoph Hellwig wrote:
> Deal with the synthetic fmr_device values and the rt device offset when
> calculating RG numbers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  io/fsmap.c | 33 ++++++++++++++++++++++++++-------
>  1 file changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/io/fsmap.c b/io/fsmap.c
> index 3cc1b510316c..41f2da50f344 100644
> --- a/io/fsmap.c
> +++ b/io/fsmap.c
> @@ -247,8 +247,13 @@ dump_map_verbose(
>  				(long long)BTOBBT(agoff),
>  				(long long)BTOBBT(agoff + p->fmr_length - 1));
>  		} else if (p->fmr_device == xfs_rt_dev && fsgeo->rgcount > 0) {
> -			agno = p->fmr_physical / bperrtg;
> -			agoff = p->fmr_physical % bperrtg;
> +			uint64_t start = p->fmr_physical -
> +				fsgeo->rtstart * fsgeo->blocksize;
> +
> +			agno = start / bperrtg;
> +			if (agno < 0)
> +				agno = -1;
> +			agoff = start % bperrtg;
>  			snprintf(abuf, sizeof(abuf),
>  				"(%lld..%lld)",
>  				(long long)BTOBBT(agoff),
> @@ -326,8 +331,13 @@ dump_map_verbose(
>  				"%lld",
>  				(long long)agno);
>  		} else if (p->fmr_device == xfs_rt_dev && fsgeo->rgcount > 0) {
> -			agno = p->fmr_physical / bperrtg;
> -			agoff = p->fmr_physical % bperrtg;
> +			uint64_t start = p->fmr_physical -
> +				fsgeo->rtstart * fsgeo->blocksize;
> +
> +			agno = start / bperrtg;
> +			if (agno < 0)
> +				agno = -1;
> +			agoff = start % bperrtg;
>  			snprintf(abuf, sizeof(abuf),
>  				"(%lld..%lld)",
>  				(long long)BTOBBT(agoff),
> @@ -478,9 +488,18 @@ fsmap_f(
>  		return 0;
>  	}
>  
> -	xfs_data_dev = file->fs_path.fs_datadev;
> -	xfs_log_dev = file->fs_path.fs_logdev;
> -	xfs_rt_dev = file->fs_path.fs_rtdev;
> +	/*
> +	 * File systems with internal rt device use synthetic device values.
> +	 */
> +	if (file->geom.rtstart) {
> +		xfs_data_dev = XFS_DEV_DATA;
> +		xfs_log_dev = XFS_DEV_LOG;
> +		xfs_rt_dev = XFS_DEV_RT;
> +	} else {
> +		xfs_data_dev = file->fs_path.fs_datadev;
> +		xfs_log_dev = file->fs_path.fs_logdev;
> +		xfs_rt_dev = file->fs_path.fs_rtdev;
> +	}
>  
>  	memset(head, 0, sizeof(*head));
>  	l = head->fmh_keys;
> -- 
> 2.47.2
> 
> 
