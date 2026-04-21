Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFA43DDDA0;
	Tue, 21 Apr 2026 21:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776807900; cv=none; b=WAFdpkcXGafGsiG5uw5sPg3NUegfBzgqbYimql9H6hXT1Zr2meAHxIEyaKN3FzXJiDGYt3BAoSIS+8iUc8xNh0/3Ndjv1rwewvhcBt1CRF/G8SXgWG7uS2IkGN49O7aHIXzAMrwQEtlWnFxidxk0gmeYUUSt9wi0/G0Ss9Jh96o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776807900; c=relaxed/simple;
	bh=oEKtrHTNxN6oxmbk4u6spR57zah8XJcPFxPsYaN+UmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jc8EXZFmS+njByXoksgkkHeTbxtOpFFuo93piOCDSQPoUF1lWC7jUEo7AD5/m3TaX8Pzc+3kc8kchttmheTYTyO1lJj0xAIbXKjCCewIHBNrOrUpHyCcuRZ2OZGQrlDomoishEoLswRuhE9CTzd87niDPlL+sNr2knZVtCrqnts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B6cMc/Oi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B6cMc/Oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A2DC2BCB0;
	Tue, 21 Apr 2026 21:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776807900;
	bh=oEKtrHTNxN6oxmbk4u6spR57zah8XJcPFxPsYaN+UmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B6cMc/Oi5S6xt9k5GF6Wj3JU1mLv2YGZcXhGk7PayrWWcXgqR/9HBgtKcqy+qPzP2
	 oapNudG8J/JXNMvF+rsb2qUeURnILnnFqM/Yv6XRXfRX8myOOMsCqQgEc3YXHKr9fZ
	 HhdVTEK1Ez8MhJEeKeNptrNMrRhJaK5xFtDeyDmgSVlMgyPJxjkPa7NwCqpffxMxuc
	 SkzCf7Bp4IMJ0/7ITVnWTOC94v+1M0BWd/jV7gLXfEdXJscn64loGONFGzwZ/OGkjY
	 qziIKK/LlzP+wmeDUwlElORYkCalPy6vwRdjkJnWr7EsEr7nt+3xNS4dmnYUR4kCqp
	 EKxG0JMdA5HRg==
Date: Tue, 21 Apr 2026 14:44:57 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	djwong@kernel.org, Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v8 03/22] ovl: use core fsverity ensure info interface
Message-ID: <20260421214457.GC37143@quark>
References: <20260420114714.1621982-1-aalbersh@kernel.org>
 <20260420114714.1621982-4-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420114714.1621982-4-aalbersh@kernel.org>

On Mon, Apr 20, 2026 at 01:46:50PM +0200, Andrey Albershteyn wrote:
>  int ovl_ensure_verity_loaded(const struct path *datapath)
>  {
>  	struct inode *inode = d_inode(datapath->dentry);
> -	struct file *filp;
>  
> -	if (!fsverity_active(inode) && IS_VERITY(inode)) {
> -		/*
> -		 * If this inode was not yet opened, the verity info hasn't been
> -		 * loaded yet, so we need to do that here to force it into memory.
> -		 */
> -		filp = kernel_file_open(datapath, O_RDONLY, current_cred());
> -		if (IS_ERR(filp))
> -			return PTR_ERR(filp);
> -		fput(filp);
> -	}
> +	if (fsverity_active(inode))
> +		return fsverity_ensure_verity_info(inode);

Not sure whether I should review this version or the version in git, but
both seem wrong.  The 'if (!fsverity_active(inode) && IS_VERITY(inode))
{' condition should stay, but fsverity_ensure_verity_info() will need to
gain a !CONFIG_FS_VERITY stub to fix the build error.

- Eric
