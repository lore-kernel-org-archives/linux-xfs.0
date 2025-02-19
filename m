Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355FC1AF0DC;
	Wed, 19 Feb 2025 05:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944776; cv=none; b=iVnOocJEqWuRUI7tGgCFRz6duL5+NvIl+H8FYlNzGWR6U3m8DTziFivdzTZ9Fmpov1ZsqdZmV+r40/PHTeF8c22Jryq/DhDg3bc5ff94u1oe6KZzCNqdwS4B7LSYII2qQKaZxY6Jmup2zsWXI+9bDyCMobQcxVC1Xjkp4wSUicU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944776; c=relaxed/simple;
	bh=lf9zR9+VLBpcnBcTO5hC2X1xd76c+lx0DtnXrIIPfiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wyd653caBguVoN927WjhsEdBVgi/c5FkvTnzdy9PrZcGZZk7shzqGSVCSC06hIGhsbOmFSttkNFvimxhutKbcrLc/ODhq5PbPNfwCB7WIFRNSvJpQ20tqIVc5HLVv/QecxoruU8SRFHMahIy4OP8dUsiEvo/smxcDeEieu6feew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G+gPvEWo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G+gPvEWo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wZb0O9nvf1I7yRprBF91Ci8PxjEV8/g6Kk5GlIlotJY=; b=G+gPvEWofFc9APD9IWDEzRkLTL
	90A4EYC+1kKMN2xuSZyvbhQm22j/qmNyoM6qVwjVFLwNHBF2moY/V7/KxQRu6cy91vnCZh/bqHCFy
	KJH/1+AYI1IwI8IQPql3egYyt6ELYhoy8e631YqYe+pQwMi2yIxAOvgSdcNQJzE1r4thSmee/zU70
	toWh/5UJRDqmMQK3x8Q69U3+8Sr31i2B57B9QbhjXzExtoFfBzd1gImujcnNkS+qb6MRgx4onGoA4
	G6oPUMvEgaawA7O4zMHcFZu6z8wyRozWOcgVmKedcViDgKPmYcwXiOXsW7Bp9GIc3l1GxI5hupJFF
	dtJPD29A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkd7O-0000000AyMB-31Sk;
	Wed, 19 Feb 2025 05:59:34 +0000
Date: Tue, 18 Feb 2025 21:59:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 08/12] misc: fix misclassification of verifier fuzz tests
Message-ID: <Z7VzRnVCgtMn3MyD@infradead.org>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
 <173992587551.4078254.1109177653377657721.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992587551.4078254.1109177653377657721.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 04:52:24PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> All the tests in the "fuzzers_norepair" group do not test xfs_scrub.
> Therefore, we should remove them all from 'dangerous_scrub' group.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

