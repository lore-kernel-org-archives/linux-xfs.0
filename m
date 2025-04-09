Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DBA1E32A0
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 20:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744231724; cv=none; b=ahGKMgoV3V2GBvjZFC6eC15DAlIOuK4ukyowQfwQN4mv0O5n4IHnibUtKGR7B33N3g7IwIBzNM3Xs/rEhAiDbRknCNnEkZ2tPHWxk3Tv3tsOiGIK6ERom/mggrQCtH9Cq9rZxnLbr3NcibtcRwO31GCsEd9HbznAgB2jGDO3R2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744231724; c=relaxed/simple;
	bh=7jJhG9sCe+pvVCIVUt0otaaGQuq2PfBfGsH4lh/ng4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A2Qf+5BTM5m2wW4/Ja9D1+SS8/XMKZvpc0BNFnlOWQI132h1T81gBOVnJtZ6IKC3XH7LQtAvlX9NfdSdr2cLOzIQd7ShSQr8ayPY3fCDyiHaCqVcpbWpim/FRfGqn0g6W2Pptz+R80IWefbzaAd2FY0TwgVF81O9AkMkPdszxVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZshsCb71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZshsCb71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94484C4CEE2;
	Wed,  9 Apr 2025 20:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744231723;
	bh=7jJhG9sCe+pvVCIVUt0otaaGQuq2PfBfGsH4lh/ng4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZshsCb71h8xLV6kacel8ihcx2vXmM1TkFNmliRy2noWpVi4IcAYPNP3YL6wdZt/u4
	 9y1gNMha5ry8PeInInhVYvbTsvANsNr5M92s3DwaZw8zgNARtBmJMe2yNajtOk800W
	 WYoRX5rb8mr1rUrm7pLmrpeIqQl+qE4/mdA+F/dbG1AG9O8y17w6TYKcDHUzRJ4bcy
	 /x0v4EdrJM32hgXzBPQ3aB3GbOfE9Y9hDhkdnhrvnQif75dWht2fzg2a9i8P9mMIth
	 hgxFFEZmUy5pf4bwvi6Mso6sFYIuJ6HYC1OOXCdkg4soa+ZvdZuRK7JZW0tBAAOzAt
	 yWEOsQIQcNekQ==
Date: Wed, 9 Apr 2025 13:48:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 38/45] xfs_io: don't re-query fs_path information in
 fsmap_f
Message-ID: <20250409204843.GS6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-39-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-39-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:41AM +0200, Christoph Hellwig wrote:
> But reuse the information stash in "file".
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine to me.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  io/fsmap.c | 25 ++++++++-----------------
>  1 file changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/io/fsmap.c b/io/fsmap.c
> index 6de720f238bb..6a87e8972f26 100644
> --- a/io/fsmap.c
> +++ b/io/fsmap.c
> @@ -14,6 +14,7 @@
>  
>  static cmdinfo_t	fsmap_cmd;
>  static dev_t		xfs_data_dev;
> +static dev_t		xfs_log_dev;
>  static dev_t		xfs_rt_dev;
>  
>  static void
> @@ -405,8 +406,6 @@ fsmap_f(
>  	int			c;
>  	unsigned long long	nr = 0;
>  	size_t			fsblocksize, fssectsize;
> -	struct fs_path		*fs;
> -	static bool		tab_init;
>  	bool			dumped_flags = false;
>  	int			dflag, lflag, rflag;
>  
> @@ -491,15 +490,19 @@ fsmap_f(
>  		return 0;
>  	}
>  
> +	xfs_data_dev = file->fs_path.fs_datadev;
> +	xfs_log_dev = file->fs_path.fs_logdev;
> +	xfs_rt_dev = file->fs_path.fs_rtdev;
> +
>  	memset(head, 0, sizeof(*head));
>  	l = head->fmh_keys;
>  	h = head->fmh_keys + 1;
>  	if (dflag) {
> -		l->fmr_device = h->fmr_device = file->fs_path.fs_datadev;
> +		l->fmr_device = h->fmr_device = xfs_data_dev;
>  	} else if (lflag) {
> -		l->fmr_device = h->fmr_device = file->fs_path.fs_logdev;
> +		l->fmr_device = h->fmr_device = xfs_log_dev;
>  	} else if (rflag) {
> -		l->fmr_device = h->fmr_device = file->fs_path.fs_rtdev;
> +		l->fmr_device = h->fmr_device = xfs_rt_dev;
>  	} else {
>  		l->fmr_device = 0;
>  		h->fmr_device = UINT_MAX;
> @@ -510,18 +513,6 @@ fsmap_f(
>  	h->fmr_flags = UINT_MAX;
>  	h->fmr_offset = ULLONG_MAX;
>  
> -	/*
> -	 * If this is an XFS filesystem, remember the data device.
> -	 * (We report AG number/block for data device extents on XFS).
> -	 */
> -	if (!tab_init) {
> -		fs_table_initialise(0, NULL, 0, NULL);
> -		tab_init = true;
> -	}
> -	fs = fs_table_lookup(file->name, FS_MOUNT_POINT);
> -	xfs_data_dev = fs ? fs->fs_datadev : 0;
> -	xfs_rt_dev = fs ? fs->fs_rtdev : 0;
> -
>  	head->fmh_count = map_size;
>  	do {
>  		/* Get some extents */
> -- 
> 2.47.2
> 
> 
