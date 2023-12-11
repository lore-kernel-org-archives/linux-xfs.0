Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDC252F9C
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 20:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u7+4YmbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5C3C433C8;
	Mon, 11 Dec 2023 20:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702325099;
	bh=CgQPMyUX1z2x+ibuulMb9T9m6y9fWqPUVHPUwe+t8x4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u7+4YmbTHIecBKZgJACoY2sh4pw+mEKmiVKii/h+SgQdt0tkhw0rTOossYiiQtEwr
	 e7NF4Le4gB2gEzll8/8mm5TKSlCtbcsQFPC5jST0iqEIk7/3/YvWjgWm5vpLsy5qpR
	 NShV/dLS24+yXXAS/RAJOEVO7igHWA6cu1xsqXCM3gPKWFwH+LoaDZELbD6Ad1wP3i
	 DviyrTNRmcrzjXH0iLUqC7KjPeeYjuFMYRNg1qoNKa+QVU1NF7zIaenFAsH9OaQDvy
	 lc1zSA2kvC9hHeqaTesphGK+S4OQyHlrYsfbPK5jLapf0qIy+GEcjOUnNGZlWxozGc
	 f3SX98FCe4U8Q==
Date: Mon, 11 Dec 2023 12:04:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: repair inode records
Message-ID: <20231211200458.GU361584@frogsfrogsfrogs>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666171.1182270.14955183758137681010.stgit@frogsfrogsfrogs>
 <ZXFbHDCxAkFq1OXT@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXFbHDCxAkFq1OXT@infradead.org>

On Wed, Dec 06, 2023 at 09:41:48PM -0800, Christoph Hellwig wrote:
> On Wed, Dec 06, 2023 at 06:42:44PM -0800, Darrick J. Wong wrote:
> >  #define XFS_DFORK_DPTR(dip) \
> > -	((char *)dip + xfs_dinode_size(dip->di_version))
> > +	((void *)dip + xfs_dinode_size(dip->di_version))
> >  #define XFS_DFORK_APTR(dip)	\
> >  	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
> >  #define XFS_DFORK_PTR(dip,w)	\
> 
> > +	if (XFS_DFORK_BOFF(dip) >= mp->m_sb.sb_inodesize)
> >  		xchk_ino_set_corrupt(sc, ino);
> 
> This should be a prep patch.

Done.

> Otherwise I'm still a bit worried about the symlink pointing to ?
> and suspect we need a clear and documented strategy for things that
> can change data for applications before doing something like that.

For a brief second I thought about adding another ZAPPED health flag,
like I just did for the data/attr forks.  Then I realized that for
symbolic link targets this doesn't make sense because we've lost the
target data so there's no extended recovery that can be applied.

Unfortunately this leaves me stuck because targets are arbitrary null
terminated strings, so there's no bulletproof way to communicate "target
has been lost, do not try to follow this path" without risking that the
same directory actually contains a file with that name.

At this point, we can't even iget the dead symlink to find the parent
pointers so we can delete the inode from the directory tree, so that's
also not an option.

> The rest looks good to me.

Oh good. :)

--D
