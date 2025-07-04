Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C1A22DF9E;
	Fri,  4 Jul 2025 08:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619173; cv=none; b=m50hDBnw89I+iz1WodgbTssBITEujTenAc9pNQUj4ilpNM+3XHewduVjuwoZ1aBTjcz683PwwXp9m1W+BzjK3/CmpwErwdPQC51Q7XTuKch7unOx3QZC8Ff4y0ENctQ+A/Z84+LD51l+vpCwiw/Xt7HQhWOXFyKmbEnl2MEnqvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619173; c=relaxed/simple;
	bh=DW6ZZg7OqmfmNQY4yfB0bhS9zFryDvFWDls1s/E6PpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mc8xLOuB7FGjscaBLzJScZlY9pCi3DqYjN1PvsedG+8OI/Dca1ht4SAf/AyOVk9qKtUyo3th5UrlQ0bkbekF0629aQ6uHgQRFjVWLCMtwelaDsFbJfZtFz9gBp+/TxPG/G79t560sS9an+1eNayXqrn4IBMoA4/PzFFcL4y6+fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/d0hYb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/d0hYb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A4DC4CEE3;
	Fri,  4 Jul 2025 08:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751619173;
	bh=DW6ZZg7OqmfmNQY4yfB0bhS9zFryDvFWDls1s/E6PpU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P/d0hYb/Fs3sF9qfGqEbKMwGxOobdAyP8B5XQ9OPbNP58vYJuonHTl72lXpspxIRJ
	 cQb8GaO7vUvDY8dYI0Dql+UBXrDzIGbHGf5m/PVKTAc7zSu6OW9cfoBbqyJ+qQfvNi
	 +N11mLRlJBQrGWCwDgvTb4yNPUU0rS6W9hKBAwq3GZAlYaCPKymf9HtqxJ+gpANOPH
	 HAeXNpoV7R2P9ouFzG6KXkBI0OWdLlui3PcG7eB5+3uk18rWG7mwC8Q5RhUuQ40p0A
	 KSJUCi/BqdmG6wKZq6t7uei6N01xLx4+arywBe+AtcZhiHCceRl+Ww0sv6cXOvXRje
	 xw1CD4wwYCGiw==
Date: Fri, 4 Jul 2025 10:52:48 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	djwong@kernel.org, skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev, 
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] fs/xfs: replace strncpy with memtostr_pad()
Message-ID: <y5d46toqsrrbqfxfioo5yqo532tzqh3f2arsidbe4gq4w3jdqp@rktbxszwtsbh>
References: <nrq9MPwFBIHZRQzC6iAdiUz7uvBdbqKNxdfM8Jus8lTDZCwtPkFMjtJ1V5mkcpX0YX34TYNOddSEOgsXngLtHQ==@protonmail.internalid>
 <20250704072604.13605-1-pranav.tyagi03@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704072604.13605-1-pranav.tyagi03@gmail.com>

On Fri, Jul 04, 2025 at 12:56:04PM +0530, Pranav Tyagi wrote:
> Replace the deprecated strncpy() with memtostr_pad(). This also avoids
> the need for separate zeroing using memset(). Mark sb_fname buffer with
> __nonstring as its size is XFSLABEL_MAX and so no terminating NULL for
> sb_fname.
> 
> Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202506300953.8b18c4e0-lkp@intel.com

Hi Pranav.

Please Read the kernel-test-robot email:

"
If you fix the issue in a separate patch/commit (i.e. not just a new
version of the same patch/commit), kindly add following tags...
"

Those tags shouldn't be added here as you are not fixing anything, your
previous patch have not been committed.

Cheers,
Carlos

> ---
>  fs/xfs/libxfs/xfs_format.h | 2 +-
>  fs/xfs/xfs_ioctl.c         | 3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 9566a7623365..779dac59b1f3 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -112,7 +112,7 @@ typedef struct xfs_sb {
>  	uint16_t	sb_sectsize;	/* volume sector size, bytes */
>  	uint16_t	sb_inodesize;	/* inode size, bytes */
>  	uint16_t	sb_inopblock;	/* inodes per block */
> -	char		sb_fname[XFSLABEL_MAX]; /* file system name */
> +	char		sb_fname[XFSLABEL_MAX] __nonstring; /* file system name */
>  	uint8_t		sb_blocklog;	/* log2 of sb_blocksize */
>  	uint8_t		sb_sectlog;	/* log2 of sb_sectsize */
>  	uint8_t		sb_inodelog;	/* log2 of sb_inodesize */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d250f7f74e3b..c3e8c5c1084f 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -990,9 +990,8 @@ xfs_ioc_getlabel(
>  	BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
> 
>  	/* 1 larger than sb_fname, so this ensures a trailing NUL char */
> -	memset(label, 0, sizeof(label));
>  	spin_lock(&mp->m_sb_lock);
> -	strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
> +	memtostr_pad(label, sbp->sb_fname);
>  	spin_unlock(&mp->m_sb_lock);
> 
>  	if (copy_to_user(user_label, label, sizeof(label)))
> --
> 2.49.0
> 
