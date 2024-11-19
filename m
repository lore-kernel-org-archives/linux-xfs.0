Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C322563
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 05:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731995060; cv=none; b=nDsoOAWeViEj9P+bRwWsV11G9ixnnzWzxr/sGhOFlpyMFoFKrqR9aIj4v4WZk8wY1WzOxR/+S4yMODPQlAY+Jr8GKRKjuA1fQCdA/MlriYqijhCEliDa+R1ve82mLJ8aC3mZCTqIsS9gYND+p1FI599zZAf6zGcJ9sNNr+Ek5ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731995060; c=relaxed/simple;
	bh=IkVmcrKD7/BGu3eINJYM1EOkJAoDPCVjlwxFId9tpzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rs//73s0FzFb4fdpijkthtY4DOajmK0wIHht/j5zw29EcQVL+aPp75dScgpuFrs/lQRHsN6oVlPiGyrW+civAxXchm5+prjx97fjcqEptDUgHx8fDxBn3gW8oyjap1b2ZJoJA/sVLXkLJbibf6Un2TGozPqn46PIMmxGrgt0l/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZRLe3PJI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZRLe3PJI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=04vBqLXnutpawhW5Z6EIJuDN9w1/Wrs41yl8rnif2nE=; b=ZRLe3PJIL4H8SEz3WtIQ2YNmmH
	4DgsVUY6gjwUHpVKhkyyzXJz69GBBqYZDVZn/iEBoF7za3xVzDyiFxhz08BVVbCsiR8AAbB2Mb2sY
	T+CP2tiF7AwMC4MOg0o3Zo4WbP144ahsS8wkA8/E//XAy0z/xm8NM3Yi4JEEC0IrxdJJbLoVPZzJZ
	zLyW7c0YBMANBATGt74yOR+vz3XFEQW/mtRpk5IxvCgRc9IGkofBOmrqlHZwFBVRS7AlTvpchensy
	muXvspGvMMv8wq+VhOtkXXMmB+ISXcBesniuzdr3c7pXJysr8KicI72Hy5TGKfH7um6PLbzlU98xj
	j3BJyOrg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDH29-0000000BRi9-2unX;
	Tue, 19 Nov 2024 05:44:17 +0000
Date: Mon, 18 Nov 2024 21:44:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: metapath scrubber should use the already
 loaded inodes
Message-ID: <ZzwlsdYLPEl8hXhS@infradead.org>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
 <173197084448.911325.8377209709944240957.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197084448.911325.8377209709944240957.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 18, 2024 at 03:05:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't waste time in xchk_setup_metapath_dqinode doing a second lookup of
> the quota inodes, just grab them from the quotainfo structure.  The
> whole point of this scrubber is to make sure that the dirents exist, so
> it's completely silly to do lookups.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

