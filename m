Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2222D593E
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 15:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781192928; cv=none; b=qg351tdMlO+dulfHEAVZiAg5cRajewhvB6C+YHzBptT6kl2dpa2bB5cwlQdjYz+YRcqECMVZ/HEGLnG7FtTSRHB6Uyo/4DrDoCMVZQCmSt9HUyNLRlJiS+GfK9OD0NzjyM+HlTydV7iS+fQQwdlxQ8ynn+1JcUy/L4cOLAOPigo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781192928; c=relaxed/simple;
	bh=7VF3RZFpBqLjOKtqpllJbyRc9VorOe3YVBH3Fl8CEzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NGE/18dvRkW3WTAoaPsjeJFHOWDqsMC2AZt7ASLAjLXP5jqnIdHckTWtqL0XIfs2r00UfCmnvwXLyOb5iMVsPH7KnP6Ok8sODupacx4EuFOXR3Cg3+jPp5RDukdHtSiytKzJylvfIvPkVuhM+Sxquo1ofUIL7vjiW4F980Ry2es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Buc/hKf2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Buc/hKf2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D22C71F00893;
	Thu, 11 Jun 2026 15:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781192926;
	bh=JZGVW3BDed9IWk9CdZIBgo59zyqXopdvEuc3iWBkC00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Buc/hKf2Gnd92OhujcGAZxSn+YqJaDsAW2EWV/1wp+IiYR+zuXKKcMbpIEiANu7ae
	 WFYJE3cUFDAnb3/qZd43IZmwLAIOJWSI3UFZow7xQIfrRFNOU+YZ687WAwfo+mFGx/
	 0QUj1u84erXvl/UnFvLij8/FLThUjOqfhQpGPIq/Kgz/hMnT+5DOoavkBRZaPWXyDs
	 Wsv3S6j7b7N+94SnZNsm1fxEXEjnAuqDGsLQ8XvIIuT6XdlBf9X19E4i2ovdip2fJ9
	 hXCfpT1SaAIb2phVsiADIKNgfZ6uLqFMtbdVOZ6XiBxrDwHYUTFFJ1LRkFn6x8kMqU
	 AtwGfBJEHICFA==
Date: Thu, 11 Jun 2026 08:48:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: move XFS_LSN_CMP to xfs_log_format.h
Message-ID: <20260611154846.GL6078@frogsfrogsfrogs>
References: <20260608050451.1203492-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608050451.1203492-1-hch@lst.de>

On Mon, Jun 08, 2026 at 07:04:51AM +0200, Christoph Hellwig wrote:
> Because CYCLE_LSN/BLOCK_LSN are defined in xfs_log_format.h, XFS_LSN_CMP
> forces a xfs_log_format.h dependency in xfs_log.h.  Move XFS_LSN_CMP
> to xfs_log_format.h and drop the macro/inline indirection to clean up
> our header mess a little bit.
> 
> This also helps xfsprogs, which doesn't have xfs_log.h, but needs
> XFS_LSN_CMP.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense, since the only use of XFS_LSN_CMP in xfsprogs is in
libxfs/xfs_defer.c.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_log_format.h | 13 +++++++++++++
>  fs/xfs/libxfs/xfs_parent.c     |  1 -
>  fs/xfs/xfs_log.h               | 17 -----------------
>  3 files changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 3f5a24dda907..a4e1b3eb425c 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -52,6 +52,19 @@ typedef uint32_t xlog_tid_t;
>  #define CYCLE_LSN(lsn) ((uint)((lsn)>>32))
>  #define BLOCK_LSN(lsn) ((uint)(lsn))
>  
> +/*
> + * By comparing each component, we don't have to worry about extra endian issues
> + * in treating two 32 bit numbers as one 64 bit number
> + */
> +static inline xfs_lsn_t XFS_LSN_CMP(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
> +{
> +	if (CYCLE_LSN(lsn1) != CYCLE_LSN(lsn2))
> +		return CYCLE_LSN(lsn1) < CYCLE_LSN(lsn2) ? -999 : 999;
> +	if (BLOCK_LSN(lsn1) != BLOCK_LSN(lsn2))
> +		return BLOCK_LSN(lsn1) < BLOCK_LSN(lsn2) ? -999 : 999;
> +	return 0;
> +}
> +
>  /* this is used in a spot where we might otherwise double-endian-flip */
>  #define CYCLE_LSN_DISK(lsn) (((__be32 *)&(lsn))[0])
>  
> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
> index 3509cc4b2175..a902d6871ea0 100644
> --- a/fs/xfs/libxfs/xfs_parent.c
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -23,7 +23,6 @@
>  #include "xfs_attr_sf.h"
>  #include "xfs_bmap.h"
>  #include "xfs_defer.h"
> -#include "xfs_log.h"
>  #include "xfs_xattr.h"
>  #include "xfs_parent.h"
>  #include "xfs_trans_space.h"
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 0f23812b0b31..ca66429bf6c9 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -80,23 +80,6 @@ xlog_format_copy(
>  	return buf;
>  }
>  
> -/*
> - * By comparing each component, we don't have to worry about extra
> - * endian issues in treating two 32 bit numbers as one 64 bit number
> - */
> -static inline xfs_lsn_t	_lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
> -{
> -	if (CYCLE_LSN(lsn1) != CYCLE_LSN(lsn2))
> -		return (CYCLE_LSN(lsn1)<CYCLE_LSN(lsn2))? -999 : 999;
> -
> -	if (BLOCK_LSN(lsn1) != BLOCK_LSN(lsn2))
> -		return (BLOCK_LSN(lsn1)<BLOCK_LSN(lsn2))? -999 : 999;
> -
> -	return 0;
> -}
> -
> -#define	XFS_LSN_CMP(x,y) _lsn_cmp(x,y)
> -
>  /*
>   * Flags to xfs_log_force()
>   *
> -- 
> 2.53.0
> 
> 
