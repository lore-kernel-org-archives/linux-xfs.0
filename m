Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CCF296BB8
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 22:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764629253; cv=none; b=cBppOnIp30f0EvmPP8KrPh0Zla0Tlu/7Hsm3IYua7EGEKfX56igolmWqhxgWF+GUDuX12k8pf6hrgo8IYKtL9R/2AXI4u3LA2i+uuozCFtT+iVDxNN6r1EjkMJlxs5s0tOA+WgmKpdbhP69mBzArdbHTmS1YVVlXTcPvdy35zs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764629253; c=relaxed/simple;
	bh=FRrRt5jlrKpcOn7OEk9d1/FRv5fNy2EUj726o51xp6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jO3aocLrirc8w5RiDA3dS6589tqEggj5QgyAMkASBUqvlhSzBdZs6V7KM7+Lnrnn2aBgDXyXDqoWHLg/xpYYYOsRxofoHQ2R6XHKG2oH9nkZyZEjuj751xourIt2TN7v9X3y5YecZeGQ90elXL7kMKhXvzrokYFpDtXbDO+xxQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RNDk9Et0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RNDk9Et0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E79C116C6;
	Mon,  1 Dec 2025 22:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764629252;
	bh=FRrRt5jlrKpcOn7OEk9d1/FRv5fNy2EUj726o51xp6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RNDk9Et0mOo1sEogcrVz/MNlVtm/qzCWCEiyiPFlK+o/rmijMpLIBhDbNoCfSI1H5
	 QEtzJ6wg7W+UMo2/V15iX4IhcNziBVu8DkaSHVCPRRTHY5gTz+tYONGsjphX/USth9
	 4gep+KXPGoZAt/QM+xZpP5QmGsTBthYbM5nxW/Pc+cyzxodc3xOsgccw2I3kqMpkbc
	 6xUPWVSOgogUtaMPWdYrHSMUkaEV17a8JMUvXcITD76/UIlcu5Zjge/MnvekBqhgyk
	 v4Q0SIX5Wc8I03qlnVAhXfF8ZIO2CLFvx0/EqICIJrgbW4QKnrBJ1PFREg8n1DqGaO
	 K+cykHHdad1tQ==
Date: Mon, 1 Dec 2025 14:47:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] repair: factor out a process_dinode_metafile helper
Message-ID: <20251201224731.GD89472@frogsfrogsfrogs>
References: <20251128063719.1495736-1-hch@lst.de>
 <20251128063719.1495736-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128063719.1495736-4-hch@lst.de>

On Fri, Nov 28, 2025 at 07:37:01AM +0100, Christoph Hellwig wrote:
> Split the metafile logic from process_dinode_int into a separate
> helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  repair/dinode.c | 87 ++++++++++++++++++++++++++-----------------------
>  1 file changed, 47 insertions(+), 40 deletions(-)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index fd40fdcce665..f77c8e86c6f1 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2948,6 +2948,52 @@ _("Bad CoW extent size hint %u on inode %" PRIu64 ", "),
>  	}
>  }
>  
> +/*
> + * We always rebuild the metadata directory tree during phase 6, so we mark all
> + * directory blocks and other metadata files whose contents we don't want to
> + * save to be zapped.
> + *
> + * Currently, there are no metadata files that use xattrs, so we always drop the
> + * xattr blocks of metadata files.  Parent pointers will be rebuilt during
> + * phase 6.
> + */
> +static bool
> +process_dinode_metafile(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno,
> +	xfs_agino_t		agino,
> +	xfs_ino_t		lino,
> +	enum xr_ino_type	type)
> +{
> +	struct ino_tree_node	*irec = find_inode_rec(mp, agno, agino);
> +	int			off = get_inode_offset(mp, lino, irec);
> +
> +	set_inode_is_meta(irec, off);
> +
> +	switch (type) {
> +	case XR_INO_RTBITMAP:
> +	case XR_INO_RTSUM:
> +		/*
> +		 * RT bitmap and summary files are always recreated when
> +		 * rtgroups are enabled.  For older filesystems, they exist at
> +		 * fixed locations and cannot be zapped.
> +		 */
> +		if (xfs_has_rtgroups(mp))
> +			return true;
> +		return false;
> +	case XR_INO_UQUOTA:
> +	case XR_INO_GQUOTA:
> +	case XR_INO_PQUOTA:
> +		/*
> +		 * Quota checking and repair doesn't happen until phase7, so
> +		 * preserve quota inodes and their contents for later.
> +		 */
> +		return false;
> +	default:
> +		return true;
> +	}
> +}
> +
>  /*
>   * returns 0 if the inode is ok, 1 if the inode is corrupt
>   * check_dups can be set to 1 *only* when called by the
> @@ -3563,48 +3609,9 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  	/* Does this inode think it was metadata? */
>  	if (dino->di_version >= 3 &&
>  	    (dino->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA))) {
> -		struct ino_tree_node	*irec;
> -		int			off;
> -
> -		irec = find_inode_rec(mp, agno, ino);
> -		off = get_inode_offset(mp, lino, irec);
> -		set_inode_is_meta(irec, off);
>  		is_meta = true;
> -
> -		/*
> -		 * We always rebuild the metadata directory tree during phase
> -		 * 6, so we use this flag to get all the directory blocks
> -		 * marked as free, and any other metadata files whose contents
> -		 * we don't want to save.
> -		 *
> -		 * Currently, there are no metadata files that use xattrs, so
> -		 * we always drop the xattr blocks of metadata files.  Parent
> -		 * pointers will be rebuilt during phase 6.
> -		 */
> -		switch (type) {
> -		case XR_INO_RTBITMAP:
> -		case XR_INO_RTSUM:
> -			/*
> -			 * rt bitmap and summary files are always recreated
> -			 * when rtgroups are enabled.  For older filesystems,
> -			 * they exist at fixed locations and cannot be zapped.
> -			 */
> -			if (xfs_has_rtgroups(mp))
> -				zap_metadata = true;
> -			break;
> -		case XR_INO_UQUOTA:
> -		case XR_INO_GQUOTA:
> -		case XR_INO_PQUOTA:
> -			/*
> -			 * Quota checking and repair doesn't happen until
> -			 * phase7, so preserve quota inodes and their contents
> -			 * for later.
> -			 */
> -			break;
> -		default:
> +		if (process_dinode_metafile(mp, agno, ino, lino, type))
>  			zap_metadata = true;
> -			break;
> -		}
>  	}
>  
>  	/*
> -- 
> 2.47.3
> 
> 
