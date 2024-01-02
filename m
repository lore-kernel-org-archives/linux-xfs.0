Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DE4F4FC
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P0rsQFdl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jOyJhrk6CVFS2hHUlc6/ZN/wFYfJschjWSDA3BZunbA=; b=P0rsQFdloGm7ZuJ5kSowDVYZPp
	6BHwydLaCVbv6V/M0zeGhvFYAlhkU33nW3ZyDgTfsXjrs2VCUq2MPtjFd0pnCjnbbUN9afRGhaxfB
	5IsGFqILjC2AEWsvZijMA/bsOwExOlVDz1pwXrEGWBrBI6tzxZivza/vI4x/Tbio08+NMr/8Xya+2
	QcMyjGqXU/pW7BZBvqokasidwWibZisLtGrRtA4OpiI3obAMATrlg1Qav82H3oKXz00bEJC1LqoM6
	b+CGLRvG5lkER4p8NB+PGisDZ3Dy6EIu2LeV0n5CPL9JCf8PGGfpnyU06ZQSpNZnCKlOHhbJBFc/1
	FXudqJPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcBe-007ctg-07;
	Tue, 02 Jan 2024 10:39:54 +0000
Date: Tue, 2 Jan 2024 02:39:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: move lru refs to the btree ops structure
Message-ID: <ZZPn+rNk5b6QKnk9@infradead.org>
References: <170404830995.1749557.6135790697605021363.stgit@frogsfrogsfrogs>
 <170404831021.1749557.2760974108166727419.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404831021.1749557.2760974108166727419.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:19:33PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the btree buffer LRU refcount to the btree ops structure so that we
> can eliminate the last bc_btnum switch in the generic btree code.  We're
> about to create repair-specific btree types, and we don't want that

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
