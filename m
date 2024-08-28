Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98832156875
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 21:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724881838; cv=none; b=OLxMy37WBBMajMHFyT2+l4K6I90aYgdOFCmyRDJJCcpw2ZxH17DaCcJr4coqiDhLx6cePqB/GxncMxQOs5wvOobSyKOKXb7W0zVucNNDLUIkM8KjeCzfUiSlLk6Azv6z4onj2L87LmWVaVqxoQKdy0sA+GuGVLpthtWNCMuY/Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724881838; c=relaxed/simple;
	bh=iAm4yZKToqjYYsW8vJPuL/RvULyDitkZVEbhN1QEJFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IHa4Ev4xvxeRV3m7U9EdnDA+NvvPpKzWzxELEWVhHllTWFTPcG9iUPfQ7z+ou3TbhDAjd/44OF/8UYCeV5zboDWbRTRuJ9YcI25RuIPAI9OAYzkkP2+gK9/a5L+1CK82E8KJJCJd3fgbtAUUVAwZmWLC8PwjoNJwF+ztF7hqC0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TmjaMGiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TmjaMGiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E610C4CEC0;
	Wed, 28 Aug 2024 21:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724881838;
	bh=iAm4yZKToqjYYsW8vJPuL/RvULyDitkZVEbhN1QEJFI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TmjaMGiP4Dd5JffgSfFYD9Ef9emiY+F8zHLbFSlPmgG19hYEhceVOVNmco+OkgEYs
	 XSUe6xwiucsCySoEkZsb3gteNER0sW8IG2zlF9oO54LEAIdxSlpOngTMxqz4jmTvG0
	 wWLVoa3ULKYIOpOsJeCf31vnf3uwtdbtk80+InfbbkUd/v5EsTYJN5szhuoL0xr2d8
	 uAQYrLvzbJuOhzwTknQCNI6zz7iTby5sfClUO5VthQNMVyOzQGveMU7CQ9p10vjKU9
	 NP/hzUDAHHHxB37L6qaxBdQY/6M5IBqRU3Jsu2RQE48DOAcbz/4xaEw+6qiQTGP+Lp
	 3KOy+T7gqmifw==
Date: Wed, 28 Aug 2024 14:50:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: refactor the allocation and freeing of incore
 inode fork btree roots
Message-ID: <20240828215037.GA6224@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
 <172480131609.2291268.5922161016077004451.stgit@frogsfrogsfrogs>
 <20240828041712.GG30526@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828041712.GG30526@lst.de>

On Wed, Aug 28, 2024 at 06:17:12AM +0200, Christoph Hellwig wrote:
> > +/* Allocate a new incore ifork btree root. */
> > +void
> > +xfs_iroot_alloc(
> > +	struct xfs_inode	*ip,
> > +	int			whichfork,
> > +	size_t			bytes)
> > +{
> > +	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
> > +
> > +	ifp->if_broot = kmalloc(bytes,
> > +				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
> > +	ifp->if_broot_bytes = bytes;
> > +}
> 
> .. actually.  Maybe this shuld return ifp->if_broot?  I guess that
> would helpful in a few callers to directly assign that to the variable
> for the root block.  Similar to what I did with xfs_idata_realloc a
> while ago.

Yeah, that would be useful later on.  I'll change that now.

--D
