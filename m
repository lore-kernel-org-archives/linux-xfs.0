Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA19B374758
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 08:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779956206; cv=none; b=WZl7VylbKhiT6VFlVoMQWG9SF3864CG0aiZW+sleBlorzJyQEBx6ehc8rOPZzpZL52t9yi90uqKhayGACGyzeBEW7LrwVXAQ3K2RN1oNo/q3JnM/e1im98VFKp9owwGwZBxiVFWHI4Fq4vJfKoEeEypZxFEdoJGYuouQVhpgY+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779956206; c=relaxed/simple;
	bh=tGACxxDAezXFxs40/Wq67WPPfSE/9iAU9Q6Do3p/hGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LYJDblfJ/Z1uelzoEgwyDlh5TLrVE/WxlAp3v14It80rJ9yEQ+gXYgeXcCjGSMulo4M50bDsF6NhfurxDUw5/sZG1WB+YBBJOkDq1fzzcY4c1ar6FCjr90oYMOxSs3i7j546ddnVcMA1o3dFpS85lw/NfqnO1t+Wf948ONmXZ64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ii1IyXsG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ii1IyXsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2291F000E9;
	Thu, 28 May 2026 08:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779956203;
	bh=tReJ97uazVaGNBcGdihclR3ztxM0v4+/rHa6WuXQuRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ii1IyXsG5okEAnFOj3ynidnACzwGG/AgRPGvGlRQRHWTyDNrbUTrs3a58TtNhMPil
	 DcXpsTxAt2WocAMPAKiK2Y28Nm/XYHfd7KgfZadypiibuMyX74fieUvqtO1yDg/sP9
	 Su6wVO7V++xy6XJR2npkXvCbtohI/UPQtkKb7xd4Iddm/hn4e7nK1111Q8WeTCImor
	 F+MRQreM+QaC3tcq2Mq/xO7ulLYViUOJj3412OfqE99jIJ6CufG7PW6U7Pl8DKN4oq
	 5Si6fbGZ2rwmy4PF7+3h2Fuo/CUG61KI2O5637ZyAbR9zslQndCDyArCfdPw5P4c5A
	 yQmQqONZdviPw==
Date: Thu, 28 May 2026 10:16:38 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: drop the experimental warning for the zoned
 allocator
Message-ID: <ahf5xvxtpZe7vouY@nidhogg.toxiclabs.cc>
References: <20260527123941.2319377-1-hch@lst.de>
 <20260527123941.2319377-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527123941.2319377-4-hch@lst.de>

On Wed, May 27, 2026 at 02:39:30PM +0200, Christoph Hellwig wrote:
> The zoned allocator has been released with 6.15 on May 25, 2025.  It has
> seen constant maintenance and improvements and no major issues, so
> promote it out of the experimental category.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Agreed, I'll queue this one to 7.2 merge window.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_message.c | 4 ----
>  fs/xfs/xfs_message.h | 1 -
>  fs/xfs/xfs_mount.h   | 2 --
>  fs/xfs/xfs_super.c   | 1 -
>  4 files changed, 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index fd297082aeb8..0243e509a468 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -149,10 +149,6 @@ xfs_warn_experimental(
>  			.opstate	= XFS_OPSTATE_WARNED_LARP,
>  			.name		= "logged extended attributes",
>  		},
> -		[XFS_EXPERIMENTAL_ZONED] = {
> -			.opstate	= XFS_OPSTATE_WARNED_ZONED,
> -			.name		= "zoned RT device",
> -		},
>  	};
>  	ASSERT(feat >= 0 && feat < XFS_EXPERIMENTAL_MAX);
>  	BUILD_BUG_ON(ARRAY_SIZE(features) != XFS_EXPERIMENTAL_MAX);
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index 49b0ef40d299..811b885f41c3 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -93,7 +93,6 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
>  enum xfs_experimental_feat {
>  	XFS_EXPERIMENTAL_SHRINK,
>  	XFS_EXPERIMENTAL_LARP,
> -	XFS_EXPERIMENTAL_ZONED,
>  
>  	XFS_EXPERIMENTAL_MAX,
>  };
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index d964bae096ef..66a02d1b9ad7 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -580,8 +580,6 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
>  #define XFS_OPSTATE_WARNED_METADIR	17
>  /* Filesystem should use qflags to determine quotaon status */
>  #define XFS_OPSTATE_RESUMING_QUOTAON	18
> -/* Kernel has logged a warning about zoned RT device being used on this fs. */
> -#define XFS_OPSTATE_WARNED_ZONED	19
>  /* (Zoned) GC is in progress */
>  #define XFS_OPSTATE_ZONEGC_RUNNING	20
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f8de44443e81..eac7f9503805 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1901,7 +1901,6 @@ xfs_fs_fill_super(
>  			error = -EINVAL;
>  			goto out_filestream_unmount;
>  		}
> -		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_ZONED);
>  	}
>  
>  	if (xfs_has_reflink(mp)) {
> -- 
> 2.53.0
> 
> 
