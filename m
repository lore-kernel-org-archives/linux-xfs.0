Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5304B488D9C;
	Tue,  4 Aug 2026 18:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785866544; cv=none; b=JwippyS64dMnpIaaBOwgE7oSAVkvkV3csw+0KhxykE2rJb1bE4Mx37MIp5HG+lcVdM/rWrnbPoXtmpcakgoKiBkpIp0CMEsHsFXXqoJg2TOLxWo0zWg22bg/QvMHF5VnxN4qM8F6qwpMHoj0pznc2Cwfu5/GYet23NsYxbScrk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785866544; c=relaxed/simple;
	bh=CVW3dBVcE+JV7xv0YxnPa7KZR+XTKel9kx/BXIt8YeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aoeNv/+RSsoh2NWaQ6iwBLk4QzJ/vSuyhuBrn+LScVR4oilFioagYI5aS8DESDtA6PlYwmYucp/wqZBlaLu89aap29B32guSRdbAJ0tNDJ8Ohuj83YaFLpDRgEYvEmZIfyKQaoVAImNWItRFw2idS+fqtuv6gmrBehH0/jfj1pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GAGCWjPI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GAGCWjPI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DC1381F000E9;
	Tue,  4 Aug 2026 18:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785866543;
	bh=Y2NLRiGuBNOJ6Z8BI9xM1Xpil32458EDcgBYHRf5xO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GAGCWjPIAyRk1FTePZVk3ZTky9GVEGih5BCDLS3DV9UiiXAn8lz3Bki8hOXq+7RfE
	 1uswLruc72tjdUjSLt7W3WUWLokJw2cWHJ/hwndk34bsg+8KujXHysByZZ39l3ANAG
	 +ykl4oDTAOaHXoEmR0bNMKPgt8UEyIrVyYaqUFKMNsPvUfjRDkRnecChE8qKXRYfk3
	 Lzy9MLZT7WMiEDuVEbbyyX9nAN0wZ/8Yyx7xIJRw8JNNd/7SiY9ME6Pgw/ppye0xud
	 /NhvrRYpTbaBX8oLV2er1kYDmhklTapD37OwYPSrUlO97jf8Ste09csg5E4Kh9WDhO
	 GPfRMkwHGktpg==
Date: Tue, 4 Aug 2026 11:02:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v14 06/21] fsverity: don't allow setting DAX file
 attribute on fsverity files
Message-ID: <20260804180222.GK3556460@frogsfrogsfrogs>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-7-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803200820.393203-7-aalbersh@kernel.org>

On Mon, Aug 03, 2026 at 10:07:56PM +0200, Andrey Albershteyn wrote:
> When fsverity is enabled on the file, with FS_IOC_ENABLE_VERITY ioctl(),
> it checks if file has DAX enabled and fails if that's true. However, the
> opposite case is not checked.
> 
> Note, that the only other filesystem supporting DAX and fsverity is
> ext4, and ext4 does check for this case.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/file_attr.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/file_attr.c b/fs/file_attr.c
> index bfb00d256dd5..473ebbe9af31 100644
> --- a/fs/file_attr.c
> +++ b/fs/file_attr.c
> @@ -235,10 +235,15 @@ static int fileattr_set_prepare(struct inode *inode,
>  	/*
>  	 * It is only valid to set the DAX flag on regular files and
>  	 * directories on filesystems.
> +	 *
> +	 * DAX and fsverity are incompatible.
>  	 */
> -	if ((fa->fsx_xflags & FS_XFLAG_DAX) &&
> -	    !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
> -		return -EINVAL;
> +	if (fa->fsx_xflags & FS_XFLAG_DAX) {
> +		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
> +			return -EINVAL;
> +		if (old_ma->fsx_xflags & FS_XFLAG_VERITY)
> +			return -EINVAL;
> +	}
>  
>  	/* Extent size hints of zero turn off the flags. */
>  	if (fa->fsx_extsize == 0)
> @@ -246,6 +251,7 @@ static int fileattr_set_prepare(struct inode *inode,
>  	if (fa->fsx_cowextsize == 0)
>  		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
>  
> +

Unnecessary addition of a blank line?

With that removed, this makes sense to me so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	return 0;
>  }
>  
> -- 
> 2.54.0
> 
> 
