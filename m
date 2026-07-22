Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8F9472541
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2026 15:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784734287; cv=none; b=kc+qxlTOvaUDmycfg4Oz+0kB1+I7aBA9wLFjb2rQ5Z+lTDACQ5uRlUB82V6GN0I6kbgoPHXCHM0O8KyvOxSzenjmkQDU41mmPFyP4VnuD/RIOw1h+3dexGDZWvZCBce6kXBnwLHam0FqTX9q3q1FexAtyg7q5TgPVt9fyPiP6/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784734287; c=relaxed/simple;
	bh=Ch1+KRN6HpQg2QQt1UjjVfQiwzRd/W/CedVISmT71Y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RyLkqfNVXBc2s97UcSMD1lY8RXv/AXd5vejpvuyEoHx6uBhwMnWHvFMrM7cVftb9YDhWZcp93OcsWQAz7TSjmc5SrX4onIYZtAUsWOz4fRVj1sm27TQ+5RmPPOwaL62BVlM0IhCNh+Uyc/EBMm85Fs5Vqv5JkeTw9bn+xzp5+c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iREJEBni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iREJEBni"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B32331F000E9;
	Wed, 22 Jul 2026 15:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784734285;
	bh=2rqZkgZaylTXQyYGX5Tth1TE7y7nQyCrUSMTnfEnyCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iREJEBnikR4S66sz5O+pcHkKQHDBRqcRVt3dD+NOChZJRw55V9buMTeshjxMsWXbG
	 zZRQiTUPfg/Vr+WSrd6l7LM/5NV14+o7yi/a4c//I0r4TnUfMcuuCxSw8fiPEaB520
	 ywWLniPoZeWJmNRu3ZUbSJ2RAFps/voX4OYvJXQtfQa9tQiDFvA0hKGVIv6K7DhVl3
	 B51GuKQsFcLuPb123c7cAShF4GY2U+J/A2DvVGbY61XS06q0pxjTP+0sbgVpCjDibg
	 IBsQIQvF/yhMAMthS/lxiOwRGYwNPnvekdc4UhAoEdbkFOQV7zrflrGBonaz6GldXR
	 VQYTRSU0H7VXg==
Date: Wed, 22 Jul 2026 08:31:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH] xfs: fix inverted clearance of inode junk flags
Message-ID: <20260722153125.GA7380@frogsfrogsfrogs>
References: <20260722091801.503245-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722091801.503245-1-aalbersh@kernel.org>

On Wed, Jul 22, 2026 at 11:17:59AM +0200, Andrey Albershteyn wrote:
> sashiko.dev noticed that these checks clear all the valid flags instead
> of invalid. This probably was never hit as it only executed on invalid
> flag presence.
> 
> Fixes: 2d295fe65776 ("xfs: repair inode records")
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Heh, I have an identical patch in my pending fixes branch.  That makes
things easy:
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/inode_repair.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> index 3ec41c198351..3fc9a12b494a 100644
> --- a/fs/xfs/scrub/inode_repair.c
> +++ b/fs/xfs/scrub/inode_repair.c
> @@ -1797,7 +1797,7 @@ xrep_inode_flags(
>  
>  	/* Clear junk flags */
>  	if (sc->ip->i_diflags & ~XFS_DIFLAG_ANY)
> -		sc->ip->i_diflags &= ~XFS_DIFLAG_ANY;
> +		sc->ip->i_diflags &= XFS_DIFLAG_ANY;
>  
>  	/* NEWRTBM only applies to realtime bitmaps */
>  	if (I_INO(sc->ip) == sc->mp->m_sb.sb_rbmino)
> @@ -1828,7 +1828,7 @@ xrep_inode_flags(
>  
>  	/* Clear junk flags. */
>  	if (sc->ip->i_diflags2 & ~XFS_DIFLAG2_ANY)
> -		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_ANY;
> +		sc->ip->i_diflags2 &= XFS_DIFLAG2_ANY;
>  
>  	/* No reflink flag unless we support it and it's a file. */
>  	if (!xfs_has_reflink(sc->mp) || !S_ISREG(mode))
> -- 
> 2.54.0
> 
> 
