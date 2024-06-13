Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772367E1
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 05:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718255285; cv=none; b=e2H+IKGYXBjSSVAj/e+cXqwqtckfKOnfIeFIH3PQWbWP+MEkZ67BmH8jD7K7yZoSGtcI8M9C2csQCyXH4RMaWYePcd+bVeCd5MZaCKPeOY+XWbDDnBwVctf2o8FITI4J/Yt7rpfv2/koHtk2GdazGf2RSbDPsRTPqzbjnqjIXIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718255285; c=relaxed/simple;
	bh=lKZIIn8RKDTeIML/LbJS4yUG4c66l2mCpCNIYc/1VdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2VGDRC9blJuDnlxVPTwZR14s4zFSOLZXMfJ9++cRC2nLREdU1giUOlied6szetHUA8ZcDvcroFiI7CdsWoSYvLvvqmj0kM7P9laPd9HzH9uoJ+m8HEW5eYZpzi+CwGpDEO8SJd1An51XYpLut+IjwgxrHEg1256/j6Z0eeyN3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CA65E68AFE; Thu, 13 Jun 2024 07:07:59 +0200 (CEST)
Date: Thu, 13 Jun 2024 07:07:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: verify buffer, inode, and dquot items every
 tx commit
Message-ID: <20240613050759.GD17048@lst.de>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs> <171821431846.3202459.15525351478656391595.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171821431846.3202459.15525351478656391595.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 12, 2024 at 10:47:50AM -0700, Darrick J. Wong wrote:
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_dinode	*dip;
> +	xfs_failaddr_t		fa;
> +
> +	dip = kzalloc(mp->m_sb.sb_inodesize, GFP_KERNEL | GFP_NOFS);
> +	if (!dip) {
> +		ASSERT(dip != NULL);
> +		return;
> +	}
> +
> +	xfs_inode_to_disk(ip, dip, 0);
> +	xfs_dinode_calc_crc(mp, dip);
> +	fa = xfs_dinode_verify(mp, ip->i_ino, dip);
> +	if (fa) {
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> +				sizeof(*dip), fa);
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		ASSERT(fa == NULL);
> +	}
> +	kfree(dip);

Doing abother malloc and per committed inode feels awfully expensive.

Overall this feels like the wrong tradeoff, at least for generic
debug builds.
