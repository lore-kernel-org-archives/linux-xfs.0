Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9503FBA2
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709140600; cv=none; b=YZck+mWlAJTTTbsFEN6cuzh3ZTaCSACUMN5MonfLz8sci3mBbRYYWgBF7Hd7DiMjKPTlMkNBhnTkHaiUBPsb02Pacon7OXe5p7A9vxHK6KS1ON+PHRgcqpyPy0Ky1LN5eqMm0om9SV/dM+703tO1saZaol7EP2CeSViILyrhqAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709140600; c=relaxed/simple;
	bh=ZFC4EGAIk1lAGkk4mTIWQe4+n/bGiYHXOpchdVPE+sA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rarZeU9bll8yO19V6CC33Gm3REtQv9+SfZqOJwDTVMBkL6QxNz9xC4d1H4RH4mSGO0UXXnC0ruQJOBOe5KQW2s2P06Q7DWKsB/SphYlXtlySgC1Tf2tPhsGgVJtoEZxyT8FCKxm32F2H5tDhp2+dlAhONDBr9sdg2AXpI0Zma0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Kb0CcBWX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Kb0CcBWX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lb8J8ltBTYX3ZMTwN/jh+D/yWQgP4/Z2ZCNyGQAurBU=; b=Kb0CcBWXWiP9d5XD2Ei/lqGRBT
	PPJZfK03madVr9aedXJ6yHetfLNdPKvpym201G3ff4sU7fTAJBMOlYFCdSoBW8xPQjK7Zr4cc+CLk
	ak/6QEqbekuJiC5eSqm3zfW4Av2BuvQrdk4RFOg19I8KM8nD3Mkoisk12IOrruvXfrebpew2c1WiY
	Ox0z353C0CK++VaY2w08YIEO+73vey/dTtSlqjoCHXttFv046fwiJM0zVeXSdwMnPd+8GaImoYTNQ
	z8O6JVJK0AoVVQhOXxfyVTguxe+aEgWRug038MN4x3rnf5sgIlXbjZlgVb/Gdh5ttrBWglq1vSGYq
	i+N81V8A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNXq-0000000AFzx-3hVI;
	Wed, 28 Feb 2024 17:16:38 +0000
Date: Wed, 28 Feb 2024 09:16:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/4] xfs: online repair of directories
Message-ID: <Zd9qdpZU_er8nXdj@infradead.org>
References: <170900014444.939516.15598694515763925938.stgit@frogsfrogsfrogs>
 <170900014471.939516.1582493895006132993.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900014471.939516.1582493895006132993.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 26, 2024 at 06:31:01PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a directory looks like it's in bad shape, try to sift through the
> rubble to find whatever directory entries we can, scan the directory
> tree for the parent (if needed), stage the new directory contents in a
> temporary file and use the atomic extent swapping mechanism to commit
> the results in bulk.  As a side effect of this patch, directory
> inactivation will be able to purge any leftover dir blocks.

I would have split xfs_inactive_dir and it's caller into a separate
prep patch, but if you want to keep that together that's probably
fine as it's completely unrelated functionality.

> + * Legacy Locking Issues
> + * ---------------------
> + *
> + * Prior to Linux 6.5, if /a, /a/b, and /c were all directories, the VFS would
> + * not take i_rwsem on /a/b for a "mv /a/b /c/" operation.  This meant that
> + * only b's ILOCK protected b's dotdot update.  b's IOLOCK was not taken,
> + * unlike every other dotdot update (link, remove, mkdir).  If the repair code
> + * dropped the ILOCK, we it was required either to revalidate the dotdot entry
> + * or to use dirent hooks to capture updates from other threads.
> + */

How does this matter here?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
