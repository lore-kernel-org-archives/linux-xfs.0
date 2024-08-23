Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B538D259C
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724387443; cv=none; b=swCgjlheXrOVwbUgN2x2nE9sg6yeAH6fQqhsrM0Db4ow/FRDb+G5LJWl6uwKZCNrWjh3t2rV8/VxXROG6fQC9ZB0tjeaXb9qKpP4uN3DBHbRyo4kH889ywWkQiF+tNVG3XSs3+8h+xtfldgLaMBgx9yHdrw5ZdQ+uv6npMC7PmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724387443; c=relaxed/simple;
	bh=MzhR+MBdGcoUtBdX7kRLcaJNfzG1X40TL024CL5H//g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H40BJQZMHsvseS04pfL0LIIAzBxIq5jGNoCd1lHcyN04U8NOEaJ8+9Orws77Juk41OlVHkYs1X26XIue9Nyi80RECK9eEvMwMvpNJFUW4UvVpMb5nkYJWy0BRn2xi/iQfahvX01aBWbUGj/iK0ILTYlUwoDtDjDdJs+UwWRwzi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oWKCYYds; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oWKCYYds"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OgqLuIciH2dztMiOez+u+U/A9FB3cmwWm55E6v2FOpw=; b=oWKCYYdsw1LbV43LXmtIjOCqpw
	6Bgi0yJ+UH/CkfmopsxfwAuIvXUn4XS039Up83G+pCkia1HXWlQajZ+oICLX7aZXq8npwwPA+CWmF
	j08g/YI3UNRvmDfZO3P6E+lZD5q40Br33E81xifD66yms9dVwcV3HvcTSqRFsrm6m6HbtigGxR/12
	xzYW3fz2u9IG/7isC2sKtLuTqjqAKRg0+gqTUHzUds9Rmn4mjqrkqvJjJYO+NsUCr/nhyFGs49G4q
	KlpCFXMCrCuEaOkwXoNE5/bcn09GQN/BSWBup7q0FQQD4YTQo2DYPIstjHH0c/1X5RZrPtzAU1V/a
	jacj/J5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shLwf-0000000FCLO-1Y6o;
	Fri, 23 Aug 2024 04:30:41 +0000
Date: Thu, 22 Aug 2024 21:30:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/26] xfs: define the on-disk format for the metadir
 feature
Message-ID: <ZsgQcQhyYaMQixco@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085186.57482.15004588749775866677.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085186.57482.15004588749775866677.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 05:02:25PM -0700, Darrick J. Wong wrote:
> +static inline bool xfs_sb_version_hasmetadir(const struct xfs_sb *sbp)
> +{
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&

This is copy and paste from the other xfs_sb_version_* helpers,
but there really is no need for the braces here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
