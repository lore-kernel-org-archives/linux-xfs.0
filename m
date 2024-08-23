Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B6F55E53
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 18:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724436772; cv=none; b=ARz90i9H/P4c55D7WjuKAnVog/USdZabjpXi7XvrR5c6TfvEJJXEEUG26oub2Dpne499kfYR6kq5kcUxRcels07Cpc0UXQiQhmkTxO2UUxR0gDIzMbfWPUTtHBH9qfIRFtHvyEko+UZHndZt8+cdO8tdcL0tQR7g1ga1H6Cn/sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724436772; c=relaxed/simple;
	bh=lBZu/039C7Ij19SzzIMPGpbqD5X2edMsmowvpkeYnzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c1cU6qX5kkov3A1CxkJG1ceCjKd8NCaObfC9xfq4QuxUgj/FSY6xSKD6n4LgYHeweTdTMHn/nmidrK4JghKrYRz/mKxrkqgsPQAgdhKLlGM3ylMCcCYcbZS4q3hyn+NJp3gQ7/k5j83tz3qULT2dec5dZQUIcRK0ISb2/Wy7xyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YyNR4Fvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YyNR4Fvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A20C32786;
	Fri, 23 Aug 2024 18:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724436771;
	bh=lBZu/039C7Ij19SzzIMPGpbqD5X2edMsmowvpkeYnzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YyNR4FvyRz19DUYIL5Mtw21kYWevNP9FwiRr3vxgtkilQQQe3hPDOYmvm21HlS+60
	 Pvhr2vghMEQcQSVFdAy/N9hSRvhmCHYOgxAsED+Vm+A+RB4DsNWSwX6MtTutJOkZKI
	 F90Mv0c94Pk9JGv9JRPwLc1zlZn/doNs1BYvPGGJJvtrgsVzoTTOJqcrgCfLxMQbfX
	 czeV/kB6ZUjrxozLc+CamxUIxSJo9fb3tt3wnXByZ/78chVhiYfu8ke76UA8hPd6AF
	 OR53TP0z7Kp5DXycWEKZhxwXtenK/Fp3bicTVUath5Ls76MEN8pw08wNQmuERAsT9F
	 tzxiOT7UY3djg==
Date: Fri, 23 Aug 2024 11:12:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/26] xfs: define the format of rt groups
Message-ID: <20240823181251.GO865349@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088534.60592.14072619855969226822.stgit@frogsfrogsfrogs>
 <ZsgZ6ND3UFA0bGl-@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsgZ6ND3UFA0bGl-@infradead.org>

On Thu, Aug 22, 2024 at 10:11:04PM -0700, Christoph Hellwig wrote:
> On Thu, Aug 22, 2024 at 05:21:25PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Define the ondisk format of realtime group metadata, and a superblock
> > for realtime volumes.  rt supers are protected by a separate rocompat
> > bit so that we can leave them off if the rt device is zoned.
> 
> We actually killed the flag again and just kept the separate helper
> to check for it.
> 
> > Add a xfs_sb_version_hasrtgroups so that xfs_repair knows how to zero
> > the tail of superblocks.
> 
> .. and merged the rtgroup and metadir flags, so while this helper
> still exists (and will get lots of use to make the code readable),
> that particular use case is gone now.

I'll just delete this sentence since xfs_sb_version_hasmetadir is in
another patch anyway.

> > -#define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
> > -#define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
> > -#define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
> > -#define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
> > +#define XFS_SB_FEAT_RO_COMPAT_FINOBT	(1 << 0)  /* free inode btree */
> > +#define XFS_SB_FEAT_RO_COMPAT_RMAPBT	(1 << 1)  /* reverse map btree */
> > +#define XFS_SB_FEAT_RO_COMPAT_REFLINK	(1 << 2)  /* reflinked files */
> > +#define XFS_SB_FEAT_RO_COMPAT_INOBTCNT	(1 << 3)  /* inobt block counts */
> 
> That also means the above is just a spurious unrelated cleanup now.
> Still useful, but maybe it should go into a sepaarate patch?  Or just
> don't bother.  Btw, one day we should clearly mark all our on-disk
> bitmaps as unsigned.

Eh, I'll drop it and make the next new rocompat feature do it.

> > +	if (xfs_has_rtgroups(nmp))
> > +		nmp->m_sb.sb_rgcount =
> > +			howmany_64(nmp->m_sb.sb_rextents, nmp->m_sb.sb_rgextents);
> 
> 		nmp->m_sb.sb_rgcount = howmany_64(nmp->m_sb.sb_rextents,
> 						nmp->m_sb.sb_rgextents);

Done.

> to avoid the overly long line.
> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
