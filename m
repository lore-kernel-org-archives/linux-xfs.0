Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3976A3595B
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 08:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764317739; cv=none; b=CYtSmdU08E2VZLtBlSCsh+Qk4o5dsS814I/SGfK7E6olOUp1nJggNJrCeFWx0jk9PZO02nJljgbcveqCr0RuAf0VpF+j6mdVWR1DhgzPQWrVefXGzRe2n+CzCLsHAfmP1BUfRQIpIYF9DBmvSoFbgrpIllNFyCCgDqKaHXv6thM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764317739; c=relaxed/simple;
	bh=ArwfXIeJJwnT4qwea3NJJb59WuviFkvFhOg+1saRJvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lEgYhz8DUcYyhv996MZkMsJRdWbOE79RHcKdU4DN+kwPXP3IBufqsGlBL4UGjxUejPjFIPRzPhqjnJ7C2pNtM/P2oh+cIw7CXUnwg2/q/fFRljB1qbzE6CLhnbhvm0fqi/3ikjeypj6ulCrCfRUhPJEqrpWNaqXxgIVd/kI/DtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k2uEmW6J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k2uEmW6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44163C4CEF1;
	Fri, 28 Nov 2025 08:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764317738;
	bh=ArwfXIeJJwnT4qwea3NJJb59WuviFkvFhOg+1saRJvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k2uEmW6J5ysUW6B2OAoMyyWJ6+caY/rPjzdk5kuHxYP1H5Yg5T8oBMMy+14e8narK
	 Aj4NNRxq8hpEEKKOmbmkgs6MVYZNuCW0sFDx3vVY85iZnmcokl6xW27ggloqRMPDVC
	 X0euMTGOk4mB891dSlCHjCylePv7mzUu4SP9eCkEFOHCfVA81yQbGTovZ65rH83oKL
	 5tIJiJZQKiy4A82RZzB8As5crqOzDCeC1+odXWzyo33JqQkASsd/wij3f4zTaFIhf4
	 ZA62q7Os3VE4iiCu+UCOQM1hu4mo4jYeLMGOq0dvheheR2RHiQyBg+nvkTZXj5lzN0
	 Va0/6D4DZRZeg==
Date: Fri, 28 Nov 2025 09:15:34 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] repair: enhance process_dinode_metafile
Message-ID: <e5ldi3iunbxl4buq7v6cotylxfd22uhdq2lf2pldyrm55b2ou3@7sq2uv5u7v2o>
References: <20251128063719.1495736-1-hch@lst.de>
 <FocUxB56pg--lstcef8fdjrK3tXU6Zpiq7PPbxOAEXYZ8ffiPGJUVWzjDosLu2WcNrdFBQKwUHSfbfrsunWl1A==@protonmail.internalid>
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

		Perhaps worth adding an assertion to catch a pre-metadir
		reaching here for whatever reason and zapping RT
		bitmap and summary?


Other than that, LGTM

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> +		 */
> +		*zap_metadata = true;
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


> -}
>  	}
> 
>  	/*
> --
> 2.47.3
> 
> 
