Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C979C198831
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 07:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730964598; cv=none; b=CruHTlG6ZxEnCQQwEIal8MufQo9UKPO0NflDDPPblhyoaG7HMNilzc6IHJ/iL0NAxqigOfhsnqDpaDoWAdaNuC6W/FWkMnSy6vZMtVLD/R6pZwpetK+IxCtxe8ECM+NBV/+NG/y+o7b7rtCDTg0vTSIjiUsD6vDcA7WgpPBq7jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730964598; c=relaxed/simple;
	bh=mSVSXHE48osBiCsX9U0kr4Yj9As1Dj8YbAA1inb3ExU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0tEbaU4kN+qg0J7Rqw2KcHWGaR8lYd52qIeIImlec/8shfEj1ddqd4W5On02KJDHDckBhoYgpaR+aBjT74chQnfkR9VJndsInmmgAuCq56m9b7K8qr81IhyFoWoAKbTvZ8NTXzQQVfwWjIIuOvRkJtjZqEwntmQ2cqSm8u18R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 13F07227AA8; Thu,  7 Nov 2024 08:29:54 +0100 (CET)
Date: Thu, 7 Nov 2024 08:29:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/1] design: document the changes required to handle
 metadata directories
Message-ID: <20241107072953.GD4408@lst.de>
References: <173092059330.2883162.3635720032055054907.stgit@frogsfrogsfrogs> <173092059344.2883162.8918515986395693634.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173092059344.2883162.8918515986395693634.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 06, 2024 at 11:18:38AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Document the ondisk format changes for metadata directories.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  .../allocation_groups.asciidoc                     |   14 +-
>  .../internal_inodes.asciidoc                       |  113 ++++++++++++++++++++
>  .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |   22 ++++
>  3 files changed, 142 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> index d7fd63ea20a646..ec59519dc2ffc1 100644
> --- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> +++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> @@ -105,7 +105,7 @@ struct xfs_sb
>  	xfs_ino_t		sb_pquotino;
>  	xfs_lsn_t		sb_lsn;
>  	uuid_t			sb_meta_uuid;
> -	xfs_ino_t		sb_rrmapino;
> +	xfs_ino_t		sb_metadirino;
>  };

Not new here, but I find it a bit odd that the super block is documented
in allocation_groups.asciidoc.

The change itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
