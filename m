Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF11147C98
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728893440; cv=none; b=Zd+S9bLwhe0gYVoQev0eQ3UnwOtH+99pbTTVmBDUKA9U3jr4FzX13p2QCb8+sXcc6wo4v52kbcpGnJinD1jKYKRlehdxbtRYVT4d+iJlOQb9qrMFatGE88qc1CMl4aJVz9oOqXSa5LxM5F7J+y8FiGaXsx9ccrRgdP3bNd/rvHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728893440; c=relaxed/simple;
	bh=PIU7P1WZao4W0AvwYPOkJ2ap4twCof7/UZ/zWFKGhSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZu5aop6CNJ4ly7NI5t7ptL45nfpICKzMbMYplDL5qAQ65r5etmyRA3s3uHxCA1mM/1i6EuxwM+y1SyolYsEpcy/gYHYq+nn7tsLJtjA0zK3mp1KTlnfKIaHRZ3KV7sEM/0EB8Xn0/9lIm7qCnMTZtAPAaz5TtmiGgZnivZuNNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VQgt00FH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VQgt00FH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5GfqfWMoZhVHcDwGv3w7AOqoZK9zr/P+cVhPrQsaCM0=; b=VQgt00FHFyrBIYh6mrfTO21NT3
	7OfpMZmvn3pG9CEONsdH92AlmvPLX3E7r+O2mn4Iqox0lD1mpfTU4y64mHjR5SAwkN8EVtdL2Zlsf
	3goL3JDLjb5E66bkbPq01Nfj5rgzDqbiTbLSQLHsK+HkTIv28pH8AyyfiXabWl3UobNzXSxDcKGIh
	pSDQWqNVSB72fvI/Y6zA2u/Gp7a2AyHh3zbDP2QglMX9YBsx12m8QPRfW/PTX3uVNJP5N8TJnpy1Z
	lcMfp7RdK2xITVm5C5zgYBQyrOwPhgRdRWfvcC0NeH4CPAEBl8hED6WkJRt4yd+RniWLZL1XNYChl
	+M9Ai5Sw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0GA2-00000004DFz-1Xdu;
	Mon, 14 Oct 2024 08:10:38 +0000
Date: Mon, 14 Oct 2024 01:10:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 32/36] xfs: fix minor bug in xfs_verify_agbno
Message-ID: <ZwzR_hEvHScYagF7@infradead.org>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644795.4178701.7276354025328848629.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860644795.4178701.7276354025328848629.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 10, 2024 at 06:10:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There's a minor bug in xfs_verify_agbno -- min_block ought to be the
> first agblock number in the AG that can be used by non-static metadata.
> Unfortunately, we set it to the last agblock of the static metadata.
> Fortunately this works due to the <= check, but this isn't technically
> correct.
> 
> Instead, change the check to < and set it to the next agblock past the
> static metadata.  This hasn't been an issue up to now, but we're going
> to move these things into the generic group struct, and this will cause
> problems with rtgroups, where min_block can be zero for an rtgroup.

I don't think this actually is a bug.  The new version is nicer, but
for AGs that always have headers at the start the existing version
works perfectly fine.  So maybe update the commit log a bit?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
