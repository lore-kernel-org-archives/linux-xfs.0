Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C4F35F16F
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 14:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773325465; cv=none; b=hjHxq397e+dlQfVUOvVxPA1sqxNCauhtUHkh4POfn5YIWGifmFQ780N7TgRgcVu5scmc1R53Fbjgmdy1w92OiqkbF01t6p13YQwRwdRH5dnz+TXY1ViDyVff9c6oQJKN9mwS/uKZeDekVqRfGUbZSU3y3ZFNDGgmXZD6QtfbkHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773325465; c=relaxed/simple;
	bh=ELU+Do2AuK/eYFKZJ0FEeR8OVJ9ZQqYmo/uD/2no3qM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ER6cwtz2TNVbdphc9EqCkOJ8abm5eUdJSla5X/zhZuGXuw7LeMMJptMN3cl8LY6hNc4CeHirI+Dj6CPytpRxm7zkJ4VWfNKzIJt0EPgbpWidjPjToahd0nXP09zew638bR8gC1EQ6wGO2FFk87kD1L0hHhOxkUvcign6GwEicSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GhH/Gs0P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GhH/Gs0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811D1C4CEF7;
	Thu, 12 Mar 2026 14:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773325464;
	bh=ELU+Do2AuK/eYFKZJ0FEeR8OVJ9ZQqYmo/uD/2no3qM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GhH/Gs0PCzjpfLCToe3W/R5BJHLvF+5FlFvixbJ/dqPb6U5m4M4Cevqz3jh41VlVa
	 ej+kL7LWYUj6R0QlZK5Yd6m0q0s91+LYoBbrF5c23Sj0LG7fWIzZEOvdwYXtUN1aTG
	 wGcJgV609iZYFlB3CdRUWTpOlbzFUW6yCnRtCI5zEOmTC7bqkD4AsO/TTSYmxysd5j
	 Ggy4eOhjr9ZBBdKlkFtXjgNrlnd50f/Zb0+0FzA9RaC+2aWIvmUuab0C7ddKZji4Xp
	 7KTdHHVQtEN8l/X3fhYrgSreIPIX5rxzL/vgSNkbYwWqdiWquljHKmiWndMkektV6P
	 31d1pYKBklSyA==
Date: Thu, 12 Mar 2026 07:24:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_io: fix fsmap help
Message-ID: <20260312142423.GH1770774@frogsfrogsfrogs>
References: <20260312065937.1156721-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312065937.1156721-1-hch@lst.de>

On Thu, Mar 12, 2026 at 07:59:36AM +0100, Christoph Hellwig wrote:
> By default fsmap prints the reverse mapping for all devices.  Update the
> help text to correctly reflect that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks good now
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  io/fsmap.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/io/fsmap.c b/io/fsmap.c
> index 005d32e500a0..83ea24d69175 100644
> --- a/io/fsmap.c
> +++ b/io/fsmap.c
> @@ -24,7 +24,8 @@ fsmap_help(void)
>  "\n"
>  " Prints the block mapping for the filesystem hosting the current file"
>  "\n"
> -" fsmap prints the map of disk blocks used by the whole filesystem.\n"
> +" fsmap prints the map of disk blocks used on a given filesystem.\n"
> +" By default, the blocks for all devices are printed.\n"
>  " When possible, owner and offset information will be included in the\n"
>  " space report.\n"
>  "\n"
> @@ -32,7 +33,7 @@ fsmap_help(void)
>  "     extent: major:minor [startblock..endblock]: owner startoffset..endoffset length\n"
>  " The owner field is either an inode number or a special value.\n"
>  " All the file offsets and disk blocks are in units of 512-byte blocks.\n"
> -" -d -- query only the data device (default).\n"
> +" -d -- query only the data device.\n"
>  " -l -- query only the log device.\n"
>  " -r -- query only the realtime device.\n"
>  " -n -- query n extents at a time.\n"
> -- 
> 2.47.3
> 
> 
