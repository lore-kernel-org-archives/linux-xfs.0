Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993B713CA95
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 06:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731913020; cv=none; b=Ouwa1wBD0VVFalK3F2MxPPqAJnbhfK3Upsre66BuiKqzbpEwxAojcy+FMcnO5QLjMwGpVECM7kVtTjCVMhKK62SYCzdxKXq8duOxo9l1GGqraQeiu6GOZTSllGJbTl4kLC52ULPrQj/JntDS5Z3zLnK0dkm+c83bEOGcA3SO4RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731913020; c=relaxed/simple;
	bh=owPRpU6dLj8clgLWp9PVq9lcig/A8f9svqCFbITIAuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JsZxktF/ypU4vKjWc6UMrXYXnYmId6nnMQa0erltTjfJACU2J18XG3oZuJK+S007AHxZEk/P1kzTs+aOV/F/N0UXUqHpAdx7riTMwzWdXrQGMz1X9rK7gJoIV+cJM1IfUYvbGiMCDP2aDbLTWfo93heO68c1CBZ42UFI2slUtok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LJIhELQt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LJIhELQt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yZjo7HbvjkssmimZDrBfIvxDXMUh5yWP2zDTlBmQAis=; b=LJIhELQtvaUbSdTBPY44whoHGh
	tDYsif2LCMlFPpXgKFd15YDtuWHqZlCWh9afCsp8kKBLNQgvpUMVauGavu1ZjbLlaz6sE97doq/zI
	C/ahJSnwCK/ml6Czb/3m5V3AqJbRsSNlaxVpPJiJvL6K3uzg5yMy2HEhBepfzIEElHueSMFhQKmQY
	wtpdxf+GrKKLwsdSzbSM+ddM0fDExE6M6dTdsAxQwHyjWn9rNbIUgX/GXtHP4oJtf04CrlWGATFT2
	QvkSLIxnT3gnDBxcsvc21MRpu4cR/uRJWdNm7ghoLO3GI6OJB20scvgpNke8NygpzilgAU361nKtu
	5gZLGRkA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tCvgx-00000008aKR-0NTE;
	Mon, 18 Nov 2024 06:56:59 +0000
Date: Sun, 17 Nov 2024 22:56:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Long Li <leo.lilong@huawei.com>, brauner@kernel.org, djwong@kernel.org,
	cem@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <ZzrlO_jEz9WdBcAF@infradead.org>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <ZzTQPdE5V155Soui@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzTQPdE5V155Soui@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 13, 2024 at 11:13:49AM -0500, Brian Foster wrote:
> >  static bool
> >  iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
> >  {
> > +	size_t size = iomap_ioend_extent_size(ioend);
> > +
> 
> The function name is kind of misleading IMO because this may not
> necessarily reflect "extent size." Maybe something like
> _ioend_size_aligned() would be more accurate..?

Agreed.  What also would be useful is a comment describing the
function and why io_size is not aligned.

> 1. It kind of feels like a landmine in an area where block alignment is
> typically expected. I wonder if a rename to something like io_bytes
> would help at all with that.

Fine with me.

> Another randomish idea might be to define a flag like
> IOMAP_F_EOF_TRIMMED for ioends that are trimmed to EOF. Then perhaps we
> could make an explicit decision not to grow or merge such ioends, and
> let the associated code use io_size as is.

I don't think such a branch is any cheaper than the rounding..

