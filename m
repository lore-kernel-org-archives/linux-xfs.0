Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78C31FDA
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 22:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764629333; cv=none; b=EywLlewZyN2HQoEBxbLnClEuKLVmGVQFyckPsTiA5/74lPfvvsBKs2ul0nOIKFHGbW2aBL4+gSHLZW8qEY/TzNZzDoxZSynRXqlaKvVsKwYV3zAN5dgGkvb2eXlCKOhyOgL0F/fL207V+owQjo6py1tQHkH58ujxayLBtTBNZ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764629333; c=relaxed/simple;
	bh=jXfzAkRHivcT8jRLRVHU+GKJEQjAnfGYQt2V2afXu2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c28S0mLw7tI4GbFDjD3vaigJn3u8BgkHCTG0cLKkyXACK7d93WdgoJspD6qZnGPYtYAhp97kBz5R18K3QiNpqxdI5tMTDB9YnhBILCwi5jlGrguxIIhtWEtOJQGISm7QoALvXzZ1acJbomSas7WngQ+nw1Bg6dFzlVuG8U8xQ4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h6flurKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h6flurKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FC1C4CEF1;
	Mon,  1 Dec 2025 22:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764629333;
	bh=jXfzAkRHivcT8jRLRVHU+GKJEQjAnfGYQt2V2afXu2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h6flurKP2CKbL0CE2Z87nV12GWSIX4+xNZ29hnF+JRuWdJDcYCvsX0mCsrX1a3sRG
	 MiOch6EBs1nP3MoM7iqaAj4pKkNSKU46UOKUk0WlDfkFHx/BNsL0ohF9mlBv26IJV8
	 eTiNiOPr5jaJ4lkLSWSF2FvIkny2R1XgE2eoJDQNd6xPb3tKl7VU1sAYkbjKH3Ytir
	 FXIodWFhKo2bsLiz4evw6tXY7fkbvVOQjOmbG3vFYuxTeKyaIv901R6xo5xDoFQt5s
	 23wUqypd7JE+MyepXfVLMLat/ivxENCFDAG6gMjYwysKFEPOW0u5iblCA4uw4Fcf4P
	 ZmbwVzmC21PkA==
Date: Mon, 1 Dec 2025 14:48:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] repair: enhance process_dinode_metafile
Message-ID: <20251201224852.GE89472@frogsfrogsfrogs>
References: <20251128063719.1495736-1-hch@lst.de>
 <20251128063719.1495736-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128063719.1495736-5-hch@lst.de>

On Fri, Nov 28, 2025 at 07:37:02AM +0100, Christoph Hellwig wrote:
> Explicitly list the destiny of each metafile inode type, and warn about
> unexpected types instead of just silently zapping them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  repair/dinode.c | 36 +++++++++++++++++++++++-------------
>  1 file changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index f77c8e86c6f1..695ce0410395 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2963,7 +2963,8 @@ process_dinode_metafile(
>  	xfs_agnumber_t		agno,
>  	xfs_agino_t		agino,
>  	xfs_ino_t		lino,
> -	enum xr_ino_type	type)
> +	enum xr_ino_type	type,
> +	bool			*zap_metadata)
>  {
>  	struct ino_tree_node	*irec = find_inode_rec(mp, agno, agino);
>  	int			off = get_inode_offset(mp, lino, irec);
> @@ -2971,16 +2972,6 @@ process_dinode_metafile(
>  	set_inode_is_meta(irec, off);
>  
>  	switch (type) {
> -	case XR_INO_RTBITMAP:
> -	case XR_INO_RTSUM:
> -		/*
> -		 * RT bitmap and summary files are always recreated when
> -		 * rtgroups are enabled.  For older filesystems, they exist at
> -		 * fixed locations and cannot be zapped.
> -		 */
> -		if (xfs_has_rtgroups(mp))
> -			return true;
> -		return false;
>  	case XR_INO_UQUOTA:
>  	case XR_INO_GQUOTA:
>  	case XR_INO_PQUOTA:
> @@ -2989,7 +2980,25 @@ process_dinode_metafile(
>  		 * preserve quota inodes and their contents for later.
>  		 */
>  		return false;
> +	case XR_INO_DIR:
> +	case XR_INO_RTBITMAP:
> +	case XR_INO_RTSUM:
> +	case XR_INO_RTRMAP:
> +	case XR_INO_RTREFC:
> +		/*
> +		 * These are always recreated.  Note that for pre-metadir file
> +		 * systems, the RT bitmap and summary inodes need to be
> +		 * preserved, but we'll never end up here for them.
> +		 */
> +		*zap_metadata = true;

Heh.  I remember agonizing over this a looooong time ago.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +		return false;
>  	default:
> +		do_warn(_("unexpected %s inode %" PRIu64 " with metadata flag"),
> +				xr_ino_type_name[type], lino);
> +		if (!no_modify)
> +			do_warn(_(" will zap\n"));
> +		else
> +			do_warn(_(" would zap\n"));
>  		return true;
>  	}
>  }
> @@ -3610,8 +3619,9 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  	if (dino->di_version >= 3 &&
>  	    (dino->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA))) {
>  		is_meta = true;
> -		if (process_dinode_metafile(mp, agno, ino, lino, type))
> -			zap_metadata = true;
> +		if (process_dinode_metafile(mp, agno, ino, lino, type,
> +				&zap_metadata))
> +			goto bad_out;
>  	}
>  
>  	/*
> -- 
> 2.47.3
> 
> 
