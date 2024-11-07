Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CD114293
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 07:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730964803; cv=none; b=bbvgOtIzL+XlYI3yuTOKjhDd5G6w9cAM4kIWmgVMR5wNHiPCrdYc2koeM/ANUIsGeXrfGtDTHmA6ERIKrCuHr27T8wUm098FSUm3Ehn8BlBSNp+ryz+5VQLQpVNwuDtGZ8+sAkKHuU2Hks7EgPEtO/ATlD1Jz9vx91hX94BY8eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730964803; c=relaxed/simple;
	bh=u73yOj8X3tZnFqPcK+xiNeFAOZ3OWL6WOTMHqcEdWQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LLPjpF6GtaI6SgQhuTJHbwi3nfF8prX7i2KdxnYYz3p2qL/cDDZ9qPUy5v6uF5yUVpWn533/4q7s14wvWZ/MT5QSsHYQ+7j+LQoGEW2BxqDbGAGGBttBNbmKXDOVGS7Zn/fmeeFgpukR7/cbe8dR1Rkhjyh1pTnG8bjMoKXSF/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8AA0C227AA8; Thu,  7 Nov 2024 08:33:18 +0100 (CET)
Date: Thu, 7 Nov 2024 08:33:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/4] design: document realtime groups
Message-ID: <20241107073318.GF4408@lst.de>
References: <173092059696.2883258.7093773656482973762.stgit@frogsfrogsfrogs> <173092059729.2883258.3327326591290447581.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173092059729.2883258.3327326591290447581.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

> --- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> +++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> @@ -106,6 +106,10 @@ struct xfs_sb
>  	xfs_lsn_t		sb_lsn;
>  	uuid_t			sb_meta_uuid;
>  	xfs_ino_t		sb_metadirino;
> +	xfs_rgnumber_t		sb_rgcount;
> +	xfs_rgblock_t		sb_rgextents;
> +	uint8_t			sb_rgblklog;
> +	uint8_t			sb_pad[7];

And following on with my ranting about existing bits theme from the
previous review:  why are we documenting the in-memory xfs_sb here
and not the on-disk xfs_dsb?

> +| +XFS_SB_FEAT_RO_COMPAT_RTSB+ |
> +Realtime superblock.  The first rt extent in rt group zero contains a superblock
> +header that can be used to identify the realtime device.  See the section about
> +the xref:Realtime_Group_Superblocks[realtime group superblocks] for more
> +information.

This is actually gone now.

> +*sb_rgcount*::
> +Count of realtime groups in the filesystem, if the
> ++XFS_SB_FEAT_INCOMPAT_RTGROUPS+ feature is enabled.

... will be zero if XFS_SB_FEAT_INCOMPAT_RTGROUPS is set, but no
realtime subvolume exists

?

