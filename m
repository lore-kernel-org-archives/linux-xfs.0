Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EA020E03F;
	Mon, 13 Oct 2025 16:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760373132; cv=none; b=BTPgQHub36Y8vpqtAyKyscRlEOL/kW4WIHAq97OsJDciKkcvKQXlYSz57Urdnh4ideEYixDiYh4FHqP/bcbRwajHS7Y2nQcU/Jnqu3oT4zjCiTV+GGKI41suLaqD+xyxhbpchLEPu26UwwZCnt6zyr6MsNuBxOXEc47UqozYh80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760373132; c=relaxed/simple;
	bh=zr+bgcqER/5+Q21aZCKAJkLYSWYNHpUeL80F/57ebhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QsdEuvOfKudpOLk2Wm1biMkc491jtbxDrFjJBDfkzXE51ctFECluftuZwugm/8n7T5p0uLnXuYENvtX3MPvewylJjVQJakZYF5SNITX1UUQeimXis59vw9BXZ1PLMVsfuf260+d0rohjMM/hyRUqZ+5zVeZlobVxBVnynXiwnk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j7Bi9ZXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j7Bi9ZXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF30BC4CEE7;
	Mon, 13 Oct 2025 16:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760373131;
	bh=zr+bgcqER/5+Q21aZCKAJkLYSWYNHpUeL80F/57ebhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j7Bi9ZXe3wMKsjur72biwT2HOE6t15YMLyr6HqlZ4U2jfwtPMHGrBL3bq4aLUK/UU
	 1kwR4lcAN/+2gkkd9A9x7kzk2/tych2NuvXMf+vhLOOhiziTcEiJkKB6+iSkRegK8w
	 z8NyH2lLB6Uzg5HALpmfxaG8zjNv4P+rWn8MitacfaWe2aKKEwLigSg3y5A2Awb7WU
	 +FKBWAiC29ryJuXHgDHLm6HiFeVDEjaqAttj0Yh8S9qIzZFj7TW8kjcsFHtbpwxexj
	 xUMZMRA+sls4awyTenRx/3QHvj6QAczWWDu07C0pmMaGTjBNWxVsOjA+vdgWJCh618
	 2kfBV+aeju2hg==
Date: Mon, 13 Oct 2025 09:32:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: XFS_ONLINE_SCRUB_STATS should depend on DEBUG_FS
Message-ID: <20251013163211.GL6188@frogsfrogsfrogs>
References: <69104b397a62ea3149c932bd3a9ed6fc7e4e91a0.1760345180.git.geert@linux-m68k.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69104b397a62ea3149c932bd3a9ed6fc7e4e91a0.1760345180.git.geert@linux-m68k.org>

On Mon, Oct 13, 2025 at 10:48:46AM +0200, Geert Uytterhoeven wrote:
> Currently, XFS_ONLINE_SCRUB_STATS selects DEBUG_FS.  However, DEBUG_FS
> is meant for debugging, and people may want to disable it on production
> systems.  Since commit 0ff51a1fd786f47b ("xfs: enable online fsck by
> default in Kconfig")), XFS_ONLINE_SCRUB_STATS is enabled by default,
> forcing DEBUG_FS enabled too.
> 
> Fix this by replacing the selection of DEBUG_FS by a dependency on
> DEBUG_FS, which is what most other options controlling the gathering and
> exposing of statistics do.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  fs/xfs/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index 8930d5254e1da61d..402cf7aad5ca93ab 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -156,7 +156,7 @@ config XFS_ONLINE_SCRUB_STATS
>  	bool "XFS online metadata check usage data collection"
>  	default y
>  	depends on XFS_ONLINE_SCRUB
> -	select DEBUG_FS
> +	depends on DEBUG_FS

Looks ok to me, though I wonder why there are so many "select DEBUG_FS"
in the kernel?

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	help
>  	  If you say Y here, the kernel will gather usage data about
>  	  the online metadata check subsystem.  This includes the number
> -- 
> 2.43.0
> 
> 
