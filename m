Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5311376E9
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388176; cv=none; b=sDK6HtApkx22CR2KJY7TmbF7iS9wzort6IEHY1kfwfPyeU2c4P9/Suu8JYjiduC7uC8ns9ECQ6gCWLJq1dd2YHSOQ6jtAiQP+jvTtiAyI+0utDxK9wXlOS8tTHRQx39OpxAF2qpWYb0P5r85Z9d7Jma3YB+hZkXtAkmumiU9nFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388176; c=relaxed/simple;
	bh=A2WZ3qRD1Q7MWb3F0NMoZVn6jzk5JhSivGKIo+9cSyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F+DtWNbrLQOiacuuvGbnkIMZ86yyHtXAJ6UiFuCuOdXuY/+IIBur1RkECOeox/pkPMuTHxjseQU1PtkxLB8/zbSMFAf1G9d0gOamekYXLxDkCNunk1RuvukNU+WNfeL/fTTo2DQg/RguKtZXWe411ZNQBwpg+JTIGInk5Zsv7bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yk8rRj2d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yk8rRj2d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZqiUXtti4+eBgDWNA5flWKYPsINhcG32SztpPMONTX0=; b=yk8rRj2dnMvMsUQ3h2NPF87hUK
	4Gql3O9tbVs30AQqHcC9qhzAOk/AU4r2335YdhV0LKO7L4Fp+XKgTSYow7djYmeu70xAh/VCMaidS
	xacVAk3siSVnn9A6NH5YcVnRPyGxdQIFpjoctQcLZDQRwsoXQ787gzwigrPnH4eyH7MNL22QUQYlE
	HPlHnMttduxh+YpW2XnecjIvhmnx8CIY3OWVNeF2SlVqItavZIAqca0dfsGDIx5qzVCAzdgXX58+f
	D+UkNmSQCmGInrgq8FjP3i6hMkZpPKq3MckT2wipe87qeLTdkceb1GWT/9et8/SywuQ8o2vNOIuqC
	c3U1Wupg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shM8U-0000000FDfT-1L2d;
	Fri, 23 Aug 2024 04:42:54 +0000
Date: Thu, 22 Aug 2024 21:42:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/26] xfs: adjust xfs_bmap_add_attrfork for metadir
Message-ID: <ZsgTTm_ddTVHpIOT@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085399.57482.13597899118907300765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085399.57482.13597899118907300765.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 05:05:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Online repair might use the xfs_bmap_add_attrfork to repair a file in
> the metadata directory tree if (say) the metadata file lacks the correct
> parent pointers.  In that case, it is not correct to check that the file
> is dqattached -- metadata files must be not have /any/ dquot attached at
> all.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

