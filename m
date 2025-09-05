Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE21013AA2D
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 08:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757061581; cv=none; b=PlVSvNs14LlCPq30CGcCWit+ARP7ZQUFEdylHzWMdd1ajLExhMd469YEcytxmKN1aB/3f2WUM9allayfGA6y7Cwq13U8/xhsAW5Mf6I7UrRSzm21riO87T9vLjjdrDku308f4cJIqcM+DwrzC8ujb8az38EiIkeOrqBZ51hP6bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757061581; c=relaxed/simple;
	bh=McvjU4Hx0gxbV//29x39TA0X9fKT7FO8EuzdjvgIp5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XuxueLsiuMF+CDdxjNPNhUGuYyR4C1LMmuHpJQG4BS5JpDF3futkHHyuDzsIRPKNyd7kuhJxPOSut+OlXkzfEhTDj747v/B5HwKsoYcGMdlYVNa/M8sy5+WntxO4/zrHjNpL2/Ncm4rQgJ33uq7dd9uEVUMHEvz0X+hOCDZbFf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lN3N/2EQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lN3N/2EQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E911C4CEF1;
	Fri,  5 Sep 2025 08:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757061581;
	bh=McvjU4Hx0gxbV//29x39TA0X9fKT7FO8EuzdjvgIp5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lN3N/2EQSKr/0tVBO4d20vjsmw6u7BDL+TPMwJDrBvour0jLiAlfEsKpFtDwOt2Qi
	 NcxXLs0Q7Mt+7fxiobJwTR/6qVMl4nS7qd8oXq+ZuI0VmgjeTPCuFPEQT1gf1b6Dzk
	 ADeKtr5gqquzKfdHtHUNHXhBUdFycyHvClUL45BJ6xuvRs5PKV+uktAWVefr3b2mym
	 EFeJ1q2vvJygtvoehoSCNCebY989M/m6hbhBCUUhES+8n2A7UY1QOAck2NwoYDIKA7
	 8Si0M0VfhI1mZz3N/k/9gVD3bxDUDcHizVY3i8rW4TpAr/85R7gI+MjkMbAwkyfnyY
	 i6BQdmncQCn7g==
Date: Fri, 5 Sep 2025 10:39:36 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: vbabka@suse.cz, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1 4/4] xfs: enable online fsck by default in Kconfig
Message-ID: <gurvbrzfj3n5zg4fkbnufutg7ufxwb7wzpkoxvkwrvhciqynrf@yuytszfcpt2m>
References: <175691147603.1206750.9285060179974032092.stgit@frogsfrogsfrogs>
 <175691147712.1206750.10415065465026735526.stgit@frogsfrogsfrogs>
 <MBNnKrdwXz8LdW5CpiXB5fO6Kc5A0p5zuWjyFUZMHTteRqzZWblteE11y_7yCvAeSMkdmxqTKXJXn6o7B4Oz2Q==@protonmail.internalid>
 <20250904024336.GL8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904024336.GL8096@frogsfrogsfrogs>

On Wed, Sep 03, 2025 at 07:43:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Online fsck has been a part of upstream for over a year now without any
> serious problems.  Turn it on by default in time for the 2025 LTS
> kernel, and get rid of the "say N if unsure" messages for the default Y
> options.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
> v1.1: remove the "if unsure" statements
> ---
>  fs/xfs/Kconfig |   14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index bd8c073ad251ed..7b341c9de36302 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -137,7 +137,7 @@ config XFS_BTREE_IN_MEM
> 
>  config XFS_ONLINE_SCRUB
>  	bool "XFS online metadata check support"
> -	default n
> +	default y
>  	depends on XFS_FS
>  	depends on TMPFS && SHMEM
>  	select XFS_LIVE_HOOKS
> @@ -150,12 +150,8 @@ config XFS_ONLINE_SCRUB
>  	  advantage here is to look for problems proactively so that
>  	  they can be dealt with in a controlled manner.
> 
> -	  This feature is considered EXPERIMENTAL.  Use with caution!
> -
>  	  See the xfs_scrub man page in section 8 for additional information.
> 
> -	  If unsure, say N.
> -
>  config XFS_ONLINE_SCRUB_STATS
>  	bool "XFS online metadata check usage data collection"
>  	default y
> @@ -171,11 +167,9 @@ config XFS_ONLINE_SCRUB_STATS
> 
>  	  Usage data are collected in /sys/kernel/debug/xfs/scrub.
> 
> -	  If unsure, say N.
> -
>  config XFS_ONLINE_REPAIR
>  	bool "XFS online metadata repair support"
> -	default n
> +	default y
>  	depends on XFS_FS && XFS_ONLINE_SCRUB
>  	select XFS_BTREE_IN_MEM
>  	help
> @@ -186,12 +180,8 @@ config XFS_ONLINE_REPAIR
>  	  formatted with secondary metadata, such as reverse mappings and inode
>  	  parent pointers.
> 
> -	  This feature is considered EXPERIMENTAL.  Use with caution!
> -
>  	  See the xfs_scrub man page in section 8 for additional information.
> 
> -	  If unsure, say N.
> -
>  config XFS_WARN
>  	bool "XFS Verbose Warnings"
>  	depends on XFS_FS && !XFS_DEBUG
