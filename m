Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7303A641B;
	Fri, 24 Jul 2026 23:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784935654; cv=none; b=PbfEa5BxiiiSt+vcvweD7bx+OE/AIHGwGpSpvuF62u49t2Nv+eVFiN/cqtfZnJHW/Brez61cUWXYpqeHy49aAeJutH80tWBn1QmVPGapD/tBpF0zu+pJAa6zQGdjFimzyLApdaYGkJ8+3Mqc2z2SuT3dSwqSubPECOpVkV6CfmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784935654; c=relaxed/simple;
	bh=2Fmnji55wqAsPktxEsT1KXDqwhZRjOph30AijhUSNWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Do/Abu1ftqIWBdeIVK5CI1pnZX6xvMGc9MgobxsV6JABuOkJuQQyblfsmvgOLT7IpstXe7j3uvrMo9EiKxvb0rBCqbMi3m4SEl3gDDY59a9JxJqMFp9eecguULrk+Rb5/p2x4iGMT1DM3EtfFwlz1G17x88xtmQLovXtYuDrvK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHkjEjgd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHkjEjgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D3E1F000E9;
	Fri, 24 Jul 2026 23:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784935653;
	bh=OgPLBeFtoOQvxkYCdbNtEOfXgM/Nsooo6ufk7hwPv1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GHkjEjgd8BlItiDBtlfYPSaMvNyrgiTibzAajHRaTWif+tYvW5MR0el1W52n3PjXt
	 OAfvzQ7M5YFoKwH/zNO4nmmaiU9eGZY193VpU5GyfX5koUhbTxSXSMIYAYqfLcrKlz
	 h3fjh83xoFz2+SbHru4y8l/VIw+rAPWpRcTKDh2vRHBn9Rh6XZuSUn0YMBtft0GaL1
	 aC9t32aiA+WDANuGHgb3vLWieO+v1IVLu03AHgn2NXaackcpdeskgxkJQ3Org8dsx8
	 7/PPjYLM/giOVt3LYRkchNB6lUAtfHFxMAgwjlNZZTVd6BEeqPsPYm3H3bcwiaGLBD
	 cAgcKJ/1zcKWw==
Date: Fri, 24 Jul 2026 16:25:40 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v13 07/23] fs,fsverity: remove check for fsverity being
 enabled in setattr_prepare()
Message-ID: <20260724232540.GA1901@sol>
References: <20260721184346.416657-1-aalbersh@kernel.org>
 <20260721184346.416657-8-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721184346.416657-8-aalbersh@kernel.org>

On Tue, Jul 21, 2026 at 08:40:44PM +0200, Andrey Albershteyn wrote:
> The check that fs-verity is available in the kernel is not necessary
> here. Filesystems could have fsverity files even without fs-verity
> module, then truncate will succeed. Previously, this would return
> EOPNOTSUPP if verity is missing, but if it's not EPERM was returned
> anyway.
> 
> Fixes: e9734653c523 ("fs,fsverity: reject size changes on fsverity files in setattr_prepare")
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/attr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/attr.c b/fs/attr.c
> index 4f437fabb7f0..71888ac903c2 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -176,7 +176,7 @@ int setattr_prepare(struct mnt_idmap *idmap, struct dentry *dentry,
>  		 * covered by the open-time check because sys_truncate() takes a
>  		 * path, not an open file.
>  		 */
> -		if (IS_ENABLED(CONFIG_FS_VERITY) && IS_VERITY(inode))
> +		if (IS_VERITY(inode))
>  			return -EPERM;

I'm confused what the commit message is trying to say.  But ignoring
that and looking at the actual diff, it looks good.  Not sure how we
missed this.

Acked-by: Eric Biggers <ebiggers@kernel.org>

Please add Cc stable as well.

- Eric
