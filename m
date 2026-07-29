Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F3A455166
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 15:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338975; cv=none; b=gIWR66XxequWjhSmSfkZppkDUb7rG5MRKg+NCYPx+3+U8uDTUb2OH+7S4H3/w+SVjvJvG2e/i7mcTVvuRMoNfAlyMjt08BTrb5/MhLw2N6Vcdu8M+o01e5MaL7D7jqxsWKFKtTemndlr+ju06im/eEpWoLiDeRucRLoj1st+Sfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338975; c=relaxed/simple;
	bh=nLFQUoWpTHzs7t/+xhoR9zjL6jLb2LoNXYtt6BdPYHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jFsiHUbycQYnqjK1bAlyDWRI2FWi3vTAi0y0zRzaWOhhQB1zGQm90HOtyektpw4epeZjb2jtS9m1Mz9B+jpyiZCQSVO0oO0CdKbYNq8YGJhuCZSCAXIgHnniZVXCsMwhONq4hNhlBasGBy8TKdO+mBKzNsD8NAdCKZ0Ib3ouzZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dx4cKTuj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dx4cKTuj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 866CD1F000E9;
	Wed, 29 Jul 2026 15:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785338974;
	bh=PydJc/jvehuOIgra/AMxXw9TYvxKbbDMsEGUoC607Jg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dx4cKTujmGWzpBxgkw0B/XMWtkbeJBy7xWRkZM12BrapVTQRz6x18n/TIF9g99s7c
	 fMCbKlWJHFUDEtOTbRl3RXaMemRQbtgnt+HoH8GUm8xbBRGyh2DBKVhkuWU+bgwenA
	 W+EiTokp9P3cA+Yw9bzSpcUdc/sNJXkxbg3p5nm6QswUgTKZ0XQYDqyltBMrBJ+kYf
	 nlGO5+gbwo78wlNxp+SdY3gb8ckgU+LAOSUCGmu+CWN3FE+IPmwsxSZSEs98cf5wMA
	 TLueNG+T5TlKJwr2UvEYtdjvHO/mLgfsxm+Pdiecl7cnlnumcyOpHQB6Ifso9A0J93
	 LQDQc+tC9jNmg==
Date: Wed, 29 Jul 2026 08:29:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] copy: log the error number when failing to write
Message-ID: <20260729152934.GW2901224@frogsfrogsfrogs>
References: <20260729125902.2281706-1-hch@lst.de>
 <20260729125902.2281706-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729125902.2281706-2-hch@lst.de>

On Wed, Jul 29, 2026 at 02:58:56PM +0200, Christoph Hellwig wrote:
> Log the string form of the errno value to help debugging a failed write.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Good idea!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  copy/xfs_copy.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 3ba9a07e4469..ad18ceb1ac1b 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -891,8 +891,8 @@ main(int argc, char **argv)
>  			off -= XFS_MAX_SECTORSIZE;
>  			len = pwrite(target[i].fd, lb, XFS_MAX_SECTORSIZE, off);
>  			if (len < 0) {
> -				do_log(_("%s:  failed to write last block\n"),
> -					progname);
> +				do_log(_("%s:  failed to write last block: %s\n"),
> +					progname, strerror(errno));
>  				do_log(_("\tIs target \"%s\" too small?\n"),
>  					target[i].name);
>  				die_perror();
> -- 
> 2.53.0
> 
> 
