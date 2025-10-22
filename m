Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5505023E347;
	Wed, 22 Oct 2025 08:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761120060; cv=none; b=qwezbWjRVfN8qOjzxD6vKjM+tAG2R0DXhWEsZWKxYRpImgR+5zphAk/tn5+7n24q+DmBJGnErlAmcSyTpcTPeWP3N6uqSYBsoEG8lnSUPh1vIgqOV3phMuECXdC2HGBrKwrpWgS2mh6a2lM6pEIP2eJnImjWddclORRKrnsPJic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761120060; c=relaxed/simple;
	bh=VF7OheSVRIF6Vo4YcOV6kZ5OyL5I8rDYD69e0v738GI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lCcwbvJLZFbnAJWb7HMjHzvFBSzcq6FCPCozQnvQC26wTIcUfXaZ7P9DR+3KhZkZ2MSJSwSk6W0IhJwxLpqrbOTs+wBgjt18n7yAOMS9SvJGf6w8g2hGvyPIQ40+wlOtUFF+WfS8/ewwWND0Gtl2ZTrAZilCL+I2czTEnalsBds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ePU9aEoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ePU9aEoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0E2C4CEF5;
	Wed, 22 Oct 2025 08:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761120059;
	bh=VF7OheSVRIF6Vo4YcOV6kZ5OyL5I8rDYD69e0v738GI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ePU9aEoZl3Vurj6lMf+Zy0Wc9GVio2t8owtB8H8iF/eedcgCVwQRrBPSDtaMDkx1x
	 f3zDfSn+988MrvSksgs+25xSMy6aRhV2bbrZy+R81hkPnqzRo4b0mvyS4BatxpSRh9
	 XNj76wjhx4RfE0JLlu3dyOjLMFhguYZiQ4jLV0oatTiY9AJn5acR3IbREtxAnuF9RX
	 hKucVAiqzrneEV4FDwNFNYt7mPvUL9grzHu9HvWgrJ3KT7ojZ1xi+aSqeHrgvcl5Vd
	 wK0aTiAkaiCAYtkXdF0o4fW0ky4dwJu3SH4VNv1p1DnZXjgvlUbhm0PQllDJQD0ksD
	 qSjAw7IZy1I+g==
Date: Wed, 22 Oct 2025 10:00:55 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: always warn about deprecated mount options
Message-ID: <dduztn5x2drvcafdcnvk6jvnmgdteh6wjnzswkrrjhrx7tcwvd@z7s5ej7lvlxs>
References: <176107133959.4152072.11526530466991879614.stgit@frogsfrogsfrogs>
 <MK77eWYpInMwgQbgEmSwJLbCh54diNy9QV2ebaTYOT2J82_b40KtfxBIvp4JLwmeM2iW_USktGAfL7bQOEuFqg==@protonmail.internalid>
 <176107134023.4152072.12787167413342928659.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176107134023.4152072.12787167413342928659.stgit@frogsfrogsfrogs>

On Tue, Oct 21, 2025 at 11:30:12AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The deprecation of the 'attr2' mount option in 6.18 wasn't entirely
> successful because nobody noticed that the kernel never printed a
> warning about attr2 being set in fstab if the only xfs filesystem is the
> root fs; the initramfs mounts the root fs with no mount options; and the
> init scripts only conveyed the fstab options by remounting the root fs.

This is a weird behavior IMHO, as far as I remember not all mount options should
necessarily work with remount and what the initramfs initially mounted
might not reflect the reality the user expects. Assuming the 'remount'
used here does not mean unmounting/mounting the root fs, but using mount
-o remount...

This is not a concern this patch should consider though, it looks fine
as-is.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Fix this by making it complain all the time.
> 
> Cc: <stable@vger.kernel.org> # v5.13
> Fixes: 92cf7d36384b99 ("xfs: Skip repetitive warnings about mount options")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_super.c |   25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e85a156dc17d16..ae9b17730eaf41 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1373,16 +1373,25 @@ suffix_kstrtoull(
>  static inline void
>  xfs_fs_warn_deprecated(
>  	struct fs_context	*fc,
> -	struct fs_parameter	*param,
> -	uint64_t		flag,
> -	bool			value)
> +	struct fs_parameter	*param)
>  {
> -	/* Don't print the warning if reconfiguring and current mount point
> -	 * already had the flag set
> +	/*
> +	 * Always warn about someone passing in a deprecated mount option.
> +	 * Previously we wouldn't print the warning if we were reconfiguring
> +	 * and current mount point already had the flag set, but that was not
> +	 * the right thing to do.
> +	 *
> +	 * Many distributions mount the root filesystem with no options in the
> +	 * initramfs and rely on mount -a to remount the root fs with the
> +	 * options in fstab.  However, the old behavior meant that there would
> +	 * never be a warning about deprecated mount options for the root fs in
> +	 * /etc/fstab.  On a single-fs system, that means no warning at all.
> +	 *
> +	 * Compounding this problem are distribution scripts that copy
> +	 * /proc/mounts to fstab, which means that we can't remove mount
> +	 * options unless we're 100% sure they have only ever been advertised
> +	 * in /proc/mounts in response to explicitly provided mount options.
>  	 */
> -	if ((fc->purpose & FS_CONTEXT_FOR_RECONFIGURE) &&
> -            !!(XFS_M(fc->root->d_sb)->m_features & flag) == value)
> -		return;
>  	xfs_warn(fc->s_fs_info, "%s mount option is deprecated.", param->key);
>  }
> 
> 
