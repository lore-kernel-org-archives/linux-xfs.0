Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BA51990D2
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 16:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723220607; cv=none; b=lBoaI2oFfAUypk9EybuhbjVbheifJodHEKKgcUEoBsYCzHA/RgnyhlaY7eo5w02cAmcdwzpcORxmRKz0gS32xl3ww1AHK5rYSc2n5ZSC7qS0RcLiwSnFCSbG/Vi4vH5UtwwOkmdrzc8NE3EvWTFQtOLEffIk8aOnRUPigy0MsQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723220607; c=relaxed/simple;
	bh=gXHwYeBO63BjIhE708xXyezbU3LsC5A24oTHjhKGcd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3MNrsavc5IHgaSBdc7odkhKrU2rWHFUGl1WBsZ3Nr+n9YXCmZMfe5y0cx3kQe3S3IgFMWFrJGL+8Mdu91RGLhS9RrrLeU/3K1qo8uSPyLvXDZYAGfDxFL/XOdvQ5FV9+UnZS2LW4MkoQO/DW99wCHU0xCDV/LuIplDrJQTgfOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MYXf/LC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MYXf/LC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF55C32782;
	Fri,  9 Aug 2024 16:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723220606;
	bh=gXHwYeBO63BjIhE708xXyezbU3LsC5A24oTHjhKGcd0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MYXf/LC2P3af5mjaKIGNjZTKIBEQPi2VAl8P6PVUSZtqt6uSuMcFNctCY1MWnlWAt
	 Qj9dp3zPNMz6sMU/wL8JBO/Q1MZMHu9s9l1yRf4k4mXd4drOWTws9RkLDNP/MMWI8L
	 IXDXxVgiLCO0q2BhJm1TubvrvIqYZUOXUeWbONXpx0Q8CffwwJY+D080iaVJEFjJIz
	 QKcLeBPdZvNVLtGEaYsDGct7ZrUCapr2bkBekHwA82JMhMm0CyHk0eZxaNlqhHT7FO
	 Y7nJva87boAoZuAYNzmFq1Z/4JwN2kX0/nPhRIAyonMGlzdFiMTZ9oa4nqHYfouybF
	 9dVv3TLHGyXBw==
Date: Fri, 9 Aug 2024 09:23:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net, cem@kernel.org
Subject: Re: [PATCH v4] xfs_db: release ip resource before returning from
 get_next_unlinked()
Message-ID: <20240809162326.GX6051@frogsfrogsfrogs>
References: <20240809161509.357133-3-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809161509.357133-3-bodonnel@redhat.com>

On Fri, Aug 09, 2024 at 11:15:11AM -0500, Bill O'Donnell wrote:
> Fix potential memory leak in function get_next_unlinked(). Call
> libxfs_irele(ip) before exiting.
> 
> Details:
> Error: RESOURCE_LEAK (CWE-772):
> xfsprogs-6.5.0/db/iunlink.c:51:2: alloc_arg: "libxfs_iget" allocates memory that is stored into "ip".
> xfsprogs-6.5.0/db/iunlink.c:68:2: noescape: Resource "&ip->i_imap" is not freed or pointed-to in "libxfs_imap_to_bp".
> xfsprogs-6.5.0/db/iunlink.c:76:2: leaked_storage: Variable "ip" going out of scope leaks the storage it points to.
> #   74|   	libxfs_buf_relse(ino_bp);
> #   75|
> #   76|-> 	return ret;
> #   77|   bad:
> #   78|   	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> ---
> v2: cover error case.
> v3: fix coverage to not release unitialized variable.
> v4: add logic to cover error case when ip is not attained.
> ---
> db/iunlink.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/db/iunlink.c b/db/iunlink.c
> index d87562e3..98d1effc 100644
> --- a/db/iunlink.c
> +++ b/db/iunlink.c
> @@ -49,8 +49,12 @@ get_next_unlinked(
>  
>  	ino = XFS_AGINO_TO_INO(mp, agno, agino);
>  	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
> -	if (error)
> -		goto bad;
> +	if (error) {
> +		if (ip)
> +			goto bad_rele;

When does libxfs_iget return nonzero and a non-NULL ip?  Wouldn't 'goto
bad' suffice here?

--D

> +		else
> +			goto bad;
> +	}
>  
>  	if (verbose) {
>  		xfs_filblks_t	blocks, rtblks = 0;
> @@ -67,13 +71,16 @@ get_next_unlinked(
>  
>  	error = -libxfs_imap_to_bp(mp, NULL, &ip->i_imap, &ino_bp);
>  	if (error)
> -		goto bad;
> +		goto bad_rele;
>  
>  	dip = xfs_buf_offset(ino_bp, ip->i_imap.im_boffset);
>  	ret = be32_to_cpu(dip->di_next_unlinked);
>  	libxfs_buf_relse(ino_bp);
> +	libxfs_irele(ip);
>  
>  	return ret;
> +bad_rele:
> +	libxfs_irele(ip);
>  bad:
>  	dbprintf(_("AG %u agino %u: %s\n"), agno, agino, strerror(error));
>  	return NULLAGINO;
> -- 
> 2.46.0
> 
> 
