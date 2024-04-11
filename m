Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7863113B789
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 03:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712806008; cv=none; b=Hm2iePz30TuwxRS01KER2V421g/sW2XHWFuR/pqVsDGe4wceOOymhviWqJR/vKwIUOrcdzW/6H3iI3HDHq0QBP4S12W7reBj0hfPxJ20Ax+uSPhqBdr8MVTFlvNKxStvx9/dQ9GGowprpXKMzsHrsTbaz7lbIjpXN+vOQQrdqLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712806008; c=relaxed/simple;
	bh=iqca/wJ/3K9fwtBA4OWyqATLmO8yMipR0YBftAVN4aU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tq6Ar0M9PkvWkM35z9Hk4VP6d5O0WO4tTM3P1XdqvH+y1bhhowrjyMGyK9xrmAp0ZlO6kGUtAZkru36WfzXKTknnW/D3VNapUAodWBSgErUhzyy1HwzzgbrYfPrVDdFD0o0VU5HQLaAMj2KWj9/V5HQc99jDWuouhNUhRD6uIUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G9drbgjj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G9drbgjj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4x9z2amguZr6bl5hbnhRoHfvylsdwNA0Yl9WXaFEv04=; b=G9drbgjjhuCv+9sllzwrmqHCHF
	yT0nBBatTL3zZqCAvyGBu7rPLf2pvVqYDdaFD1lbpF6DqNMdNqgWuuCT4b5/bcNUorAhk6JV8S7Gk
	DxzkCz8gSawiLiUxjM757SxG92sEzgEkzdjM4Ef85UMbwJMFpvLBWr3I4f7P6vBkozm6HtPqnzSnc
	oJSAAYFmocGfcU3TTxpIG54AabB6k760c6QA/OjWxQl3K1bmITi0k7VnzGZTLYpMv/BrxMNsWLf/u
	XO9d6RRCBiw2rw0K5Pa2RnGU4pwWIoqiw2hvrYsLyNtskPfJMiddDT9zBA4dwnFMX5kLxIEU9Unfi
	oe1/XGAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rul5K-0000000A98Q-0RWn;
	Thu, 11 Apr 2024 03:26:46 +0000
Date: Wed, 10 Apr 2024 20:26:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: rename xfs_da_args.attr_flags
Message-ID: <ZhdYdjXDQqNXv40Y@infradead.org>
References: <171270968374.3631393.14638451005338881895.stgit@frogsfrogsfrogs>
 <171270968435.3631393.4664304714455437765.stgit@frogsfrogsfrogs>
 <ZhYdQ90rqsMOGaa1@infradead.org>
 <20240410205528.GZ6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410205528.GZ6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 10, 2024 at 01:55:28PM -0700, Darrick J. Wong wrote:
> On Tue, Apr 09, 2024 at 10:01:55PM -0700, Christoph Hellwig wrote:
> > On Tue, Apr 09, 2024 at 05:50:07PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > This field only ever contains XATTR_{CREATE,REPLACE}, so let's change
> > > the name of the field to make the field and its values consistent.
> > 
> > So, these flags only get passed to xfs_attr_set through xfs_attr_change
> > and xfs_attr_setname, which means we should probably just pass them
> > directly as in my patch (against your whole stack) below.
> 
> Want me to reflow this through the tree, or just tack it on the end
> after (perhaps?) "xfs: fix corruptions in the directory tree" ?

If it makes your life easier feel free to add it at the end.

