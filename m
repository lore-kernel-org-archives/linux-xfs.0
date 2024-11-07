Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FA01F130F
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 15:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730994988; cv=none; b=jUmki/ibxK4/NSd15pYOIcPN7bZzXMBkBdXPR21qYUY51pXgJeNcbyYVDfYG0GMYbYq9NOOVTR2kjNfJ97qqX2Fhaob4E/soSNN3lhU4ZmHN81U8HPRsoQ0AgbvAj9o5QBRatmtU3qceNR6NDoDyuVJ1vx3AKeuQ2yRhGJ10oBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730994988; c=relaxed/simple;
	bh=Cg6RGBoFjiI6ZuR32OZDTH5Am9szjiQ0k8mVDHpN/A4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EfdJ4quX2jTvGzquqVOax1WmcexQlKdTQ97iAVk6b2yDJ8uJ1wTxb3j+B7b4+DQYnZM4rNrxshhfaIzJBiarntylZbP+p5X70v8CDyTdEcGtRUMGrXtOI7BcNeWTieqsRL+uISSVR0U/OLIEEj1ThUh197P7LlSHIqzoe/PvfyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/Rbc8AI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/Rbc8AI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B98C4CECC;
	Thu,  7 Nov 2024 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730994986;
	bh=Cg6RGBoFjiI6ZuR32OZDTH5Am9szjiQ0k8mVDHpN/A4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V/Rbc8AIY/kOJTq3eZ8M3SgQve3ZRWwLoZFJRuU8nABNgflUc3gMKCVA29PkHAvq7
	 La2SiZF0/69BgmLize3XayKWaPJZDTF/EsE4dgr50hkM9hJsKXh17F42HYo27jlsm5
	 6z6z++8mfMbfSCKvybceEJ19d0BtmEgvr/3ZVqeZeQy7S23KuGfukm0+9lWGuEKcHT
	 eZZvufjNCaEDPTYbDOiPz4aUfSVSBp1G4s0owk4OFXeaxPAlISycE8ppl6lmFIt7NG
	 W1Lr0hWynctrblBF9pA2acSgRuMdiLAg+uEFnK5LVpsgkRWmfW6Alqu15T+IRnzayP
	 O5yU3Lw7NfOPA==
Date: Thu, 7 Nov 2024 07:56:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] design: document the changes required to handle
 metadata directories
Message-ID: <20241107155625.GP2386201@frogsfrogsfrogs>
References: <173092059330.2883162.3635720032055054907.stgit@frogsfrogsfrogs>
 <173092059344.2883162.8918515986395693634.stgit@frogsfrogsfrogs>
 <20241107072953.GD4408@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107072953.GD4408@lst.de>

On Thu, Nov 07, 2024 at 08:29:53AM +0100, Christoph Hellwig wrote:
> On Wed, Nov 06, 2024 at 11:18:38AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Document the ondisk format changes for metadata directories.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  .../allocation_groups.asciidoc                     |   14 +-
> >  .../internal_inodes.asciidoc                       |  113 ++++++++++++++++++++
> >  .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |   22 ++++
> >  3 files changed, 142 insertions(+), 7 deletions(-)
> > 
> > 
> > diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> > index d7fd63ea20a646..ec59519dc2ffc1 100644
> > --- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> > +++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> > @@ -105,7 +105,7 @@ struct xfs_sb
> >  	xfs_ino_t		sb_pquotino;
> >  	xfs_lsn_t		sb_lsn;
> >  	uuid_t			sb_meta_uuid;
> > -	xfs_ino_t		sb_rrmapino;
> > +	xfs_ino_t		sb_metadirino;
> >  };
> 
> Not new here, but I find it a bit odd that the super block is documented
> in allocation_groups.asciidoc.

Me too.  superblock.asciidoc?

> The change itself looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
