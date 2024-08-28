Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A07618030
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 04:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724818637; cv=none; b=ZEpx/xGvx0wlfGV9YvdWGiGpOFjFjABIL18J+PBAoNMWXbPMTLkyHexXA3MfX50IbTcPOVjJG7AbwYiCOaI+f2yv6LuEWZanhLx3jGOF5xVz0eqRDXzJGpZFQJfHyo0dTWYPUtboiFtrYcvziY+MrhKJk+QQwzjHRLPLd2nBUiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724818637; c=relaxed/simple;
	bh=psSWj+zrmni917lQnzwEFPGRscJdqJgNDuVhNvDjQZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SjwQSfcDuc939Ab/CjCX0zEgh+0H2p5QQX4FVkEQGfuC4zOevKGtB1gWgF63kV+uWesgwaOTY8LEx9AAq9INkuDWzp4LJllw7IVRdKkdIKeDIfTSSP7mCBVR06Gc5QyBCFpgo7TdgSLGZUfj+6fKaIqK5mAkLw0mr3pLdxvhWSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B41E468B05; Wed, 28 Aug 2024 06:17:12 +0200 (CEST)
Date: Wed, 28 Aug 2024 06:17:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 06/10] xfs: refactor the allocation and freeing of
 incore inode fork btree roots
Message-ID: <20240828041712.GG30526@lst.de>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs> <172480131609.2291268.5922161016077004451.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131609.2291268.5922161016077004451.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +/* Allocate a new incore ifork btree root. */
> +void
> +xfs_iroot_alloc(
> +	struct xfs_inode	*ip,
> +	int			whichfork,
> +	size_t			bytes)
> +{
> +	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
> +
> +	ifp->if_broot = kmalloc(bytes,
> +				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
> +	ifp->if_broot_bytes = bytes;
> +}

.. actually.  Maybe this shuld return ifp->if_broot?  I guess that
would helpful in a few callers to directly assign that to the variable
for the root block.  Similar to what I did with xfs_idata_realloc a
while ago.

