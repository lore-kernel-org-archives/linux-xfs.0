Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A1328EC
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 05:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718774756; cv=none; b=GyhQgRIw3svkzYwEHB+jGzJT4SU+ci2H20fhLWP0YI3rPs0CXLR/2EV+WUd0MOBM6Um90ISziaRmA94R+P+1K6DFqAOScJYbJDyXcC3ABNAwfVKIRzfeyIqy4lwW//DbqOayT7UX9AoDeCGvTVAoAxqP7qYbIMsfO1TKey/ePAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718774756; c=relaxed/simple;
	bh=vXzq+SL86SmCdDjr9ytvKKBQpi6xb+B7Z0vinM0y/5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OgPLTrrKlxcpdoqf7nEmK+7MkdE87KrgfgghdGO2o8ho9mk0DKJIHilwr+bBj51sf8UykP4X61PPKWXSPXqJg9ohGFYFjwBSrEr8Mjvi8wzNEmAne5h8Zj1YO3UZsvHYK+5geYN4C6MMO2Ssz8sYdp3Bqgj0WCG1tjhJ5pvMfHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WW0FZRw7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WW0FZRw7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JtNpwUjj80DlmZeoeOP4RZee/fdJgvX6ScMR2l+UO7k=; b=WW0FZRw76p1i2LjLCVE19Y1KXC
	v6WtJ8jbGhfW03GOHfO48hXC+4Lr980ankNyzZlxY1O8uXhFrlitogWAaLRlbJwfYm5AEH5YckVNp
	OjjeKNosOu/ml0DLMyi8UlItU1dnAzNWK4Wv2mWCT/hFmyYLncTLsoiodWykp7HQQhxXm8lfWu+uz
	zeIPDwnXB99LZu15tDOya292xqGDZ3JJOg2wAT4Pww0PtgXrkU/xkmoxbQFHEXbnTS47oCi0nG0y6
	ve8gGaLudikSibLnWUotw2f65alrp3uiDMKzXIYdd2KACyU59sitPJQ64zXc9BfNjXrYVwVYYzaNp
	rwiAY5EA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJnpN-0000000HVnx-1ulq;
	Wed, 19 Jun 2024 05:25:49 +0000
Date: Tue, 18 Jun 2024 22:25:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: honor init_xattrs in xfs_init_new_inode for !attr
 && attr2 fs
Message-ID: <ZnJr3fKw42EP9gPW@infradead.org>
References: <20240618232112.GF103034@frogsfrogsfrogs>
 <20240619010622.GI103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619010622.GI103034@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 18, 2024 at 06:06:22PM -0700, Darrick J. Wong wrote:
> NAK, this patch is still not correct -- if we add an attr fork here, we
> also have to xfs_add_attr().  ATTR protects attr forks in general,
> whereas ATTR2 only protects dynamic fork sizes.

Yes.  Note that I was kinda surprised we wouldn't always set the attr
bit by default in mkfs, but indeed we can create a file system without
attrs, which felt odd.

