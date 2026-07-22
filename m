Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492503DCDA2;
	Wed, 22 Jul 2026 08:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710149; cv=none; b=c2jFZV4J2Txq1mydhHXeeZK7AgykRQ/J+RasiSzUFX8JQXetG042JwAt9clZrEJEoQopX3DudOQnfxvNFSe3reCVT8mctNLZBuZcMQKOQ/YZlxHuH/uWFkqG42Lqh5Zv02Z95ep8dDYDxBCUMX8iQCt0GoKBrjKWPVnuHsGFaOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710149; c=relaxed/simple;
	bh=FFE+x53tzUIZd6gVGN9RGTnUCiorpLDjXO8YtWE9O5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KGWEIOlCZJu7bzQs5G47Jsh9s2odGzlJpygc7gOHtbqkkqG21VtE4yxqObUKOhrKMF+8QvTlhez76Y/SrAy0nJQUR2ezDoW33Gg8zeUoWD1ESzIClsB2eGktGToNEvbWL4hE/t/drZs2bZtQa17n3Vi7/jCAdV/VItJMPyo6xDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDewfR6T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDewfR6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D33B1F000E9;
	Wed, 22 Jul 2026 08:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784710148;
	bh=4cave/FX9ETPUxxUR4GqziXKNHTvfs1NEKm80/e+IwI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VDewfR6TmLanDAKD5izvgOBHnSpyi/CXGZUfSlyYHL9vTqwEfnpM3B1y0+/PR258A
	 0pu/XPEIHD4yhyFgVmKx2U/t7t8nK8SyC9osI2l0lngE+QGOYhoJqwlr2Lq65AbZla
	 UmbDbFj5tX1hFZxNgIdtiW7fm6yGSiK9IAE15LO73DcPgh+F7RNrXQA+co5s01eE0s
	 siRJRbsD2bGDQp+LtqdsS/t/SNf2x7lbJvc1BHBUlVE0b2wtWWaY4Fn5OXwaVFJcbF
	 H/WAitoSeLjgEFwUqoHkjMdqrpPMWsr2SmvSmc01Eb7yzfIxUDjMel248+O+Sn/Hl0
	 J5+wqt+UPPSzw==
Date: Wed, 22 Jul 2026 10:49:03 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: djwong@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix compilation warnings in xfs_sync_sb_buf when
 CONFIG_XFS_RT=n
Message-ID: <amCBowU-Q-QrGYoX@andromeda.toxiclabs.cc>
References: <20260722042841.220534-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722042841.220534-1-yun.zhou@windriver.com>

On Wed, Jul 22, 2026 at 12:28:41PM +0800, Yun Zhou wrote:
> When CONFIG_XFS_RT is disabled, xfs_log_rtsb() is a macro expanding to
> (NULL), causing 'statement with no effect' and 'variable set but not
> used' warnings.
> 
> Fix by removing the bp variable and passing xfs_trans_getsb(tp) directly
> to xfs_log_rtsb().  This is safe because xfs_log_sb() already joins the
> sb buffer to the transaction internally.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202607212237.Pzw1sr5k-lkp@intel.com/
> Fixes: b9ad0b9891dd ("xfs: don't hold buffer locks across sync transaction commit in xfs_sync_sb_buf")
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>

We don't need a fix for a patch that is still in linux-next... Merge it
against your original patch and re-send it. I'll just replace the old
patch


> ---
>  fs/xfs/libxfs/xfs_sb.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index fbb4505b1e9e..c4fa7fb0e39a 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1470,17 +1470,15 @@ xfs_sync_sb_buf(
>  	bool			update_rtsb)
>  {
>  	struct xfs_trans	*tp;
> -	struct xfs_buf		*bp;
>  	int			error;
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
>  	if (error)
>  		return error;
>  
> -	bp = xfs_trans_getsb(tp);
>  	xfs_log_sb(tp);
>  	if (update_rtsb)
> -		xfs_log_rtsb(tp, bp);
> +		(void)xfs_log_rtsb(tp, xfs_trans_getsb(tp));
>  	xfs_trans_set_sync(tp);
>  	error = xfs_trans_commit(tp);
>  	if (error)
> -- 
> 2.43.0
> 
> 
