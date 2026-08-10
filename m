Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFF24137B2
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 16:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786379161; cv=none; b=eU7xs6EXcuk/DLb67GJjL0dlZDWCq8+u+BeLWs/ongB6J9MLQzFtiPlcoD1dbeUkk1a4apdo6Ir7w093Z6k4Y/9KQLX3P0DshnxatQ59zWVwDaThveGFI36L/oJJywkl+bVoYeQfvXMAQ++CpUCkf2jFfVL/Q6DQ1j0ToqkwwHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786379161; c=relaxed/simple;
	bh=ROtmnLNjQgtdK0hgUhhEzlAVxB+Zqj0NWtRQq3fW5zQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bs4bgEKpehUxA+vD/8IZk4AY58hUHhzXGISt0cHS+MWYrov+llAmXlCRYQ22N+xnJ3VO0ij0PnMAprwfVKRFuFAIMSjE0+ywsH3h80WwmX6D9VhRH6pbJGqTME5SpUw0Cy2rjBp+uv4bhwnrah7XutMSeCFWBL57oZBA1Nj1a+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mybfCEog; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mybfCEog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EED01F00A3D;
	Mon, 10 Aug 2026 16:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786379151;
	bh=yPM3fY3dIn+NpMTPJ2QDgY3x6ba/1zJcx5AlE1VUkjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mybfCEogJGsewhoJhEsGP0PlC1bqUNfrotAStOUfqhlMPwg3J0tb0ULOJ8fSB822S
	 v0w4rIPs4pqDmeZreLs7VtQgevH/P2YH/UysdfrJ7sHiLuzQlJcLE2kOfwnr5OyUWv
	 B0YcnBnuwPyETMSoyS5oJJgmoM/PLno+5lyIK9ANcXSnNze7hVaCwinuy9QnsDh83G
	 zKDXqnenBQA1z/agxH2rV2V81A4hcBmtIGQ8E+JOe78vgxXriBfddICEZd4CoeO0IY
	 DL13jgJzJayC85xtvp+pZrs4yWJhrOzsBxw8rnVw3Hwh+hwWoEvUqBlVTULO68Vf3d
	 zsV0KihyE3Dsw==
Date: Mon, 10 Aug 2026 18:25:47 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, 
	Wilfred Mallawa <wilfred.mallawa@wdc.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Hans Holmberg <hans.holmberg@wdc.com>, "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: fix zoned write iomap flags assignments
Message-ID: <ann7HKGV6GgnzDQT@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260810153759.466417-1-hch@lst.de>
 <20260810153759.466417-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810153759.466417-4-hch@lst.de>

On 2026-08-10 08:37:44, Christoph Hellwig wrote:
> Don't overwrite IOMAP_F_DIRTY with IOMAP_F_ANON_WRITE, but ensure both
> flags are set instead.
> 
> Note that in practice this is harmless as all zoned writes force a metadata
> transaction anyway, but incorrectly assigned flags are still a landmine
> that will cause problems at some point.
> 
> Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
> Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

> ---
>  fs/xfs/xfs_aops.c  | 3 +--
>  fs/xfs/xfs_iomap.c | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index c80f05507373..9506cd8d15e6 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -634,11 +634,10 @@ xfs_zoned_map_blocks(
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  
>  	wpc->iomap.type = IOMAP_MAPPED;
> -	wpc->iomap.flags = IOMAP_F_DIRTY;
>  	wpc->iomap.bdev = mp->m_rtdev_targp->bt_bdev;
>  	wpc->iomap.offset = offset;
>  	wpc->iomap.length = XFS_FSB_TO_B(mp, count_fsb);
> -	wpc->iomap.flags = IOMAP_F_ANON_WRITE;
> +	wpc->iomap.flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;

Does it make sense to set IOMAP_F_DIRTY here? I haven't found how it
could be used

-- 
- Andrey
