Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31C76118
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zwu1JwDk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zYVNVMwlgTR5wJu9etObnK1ndDasYvUYMjzO27F7lD4=; b=Zwu1JwDkYcOZfS6NRAAbYdpBsd
	BGZB1YQDuomZMyC83/C4gIcCsTwx+WEUBsbNKHRdTaxu3xCa+7ETJfFziiOWIxvfkHbEGHe5l1M6K
	rKKW+CfDF9JhAHTG587y9RZ3HKbSh37e7Mrlv71La/Ej8sWrA1lBTeHhYk3AAe4sDGY88E6sQMeHw
	nO0a/m1Bfx3nroDi7++7W0k7RJg6iEZgd6ry91r6nUtl+pqIoGkF0uA+mcpb2kFdVXRpDX5bUUb1e
	LT7sSIBpWgPi7Nv98E81CQ3jPhI671tkisLrIc2JZtuo9IjsI93oTC+zDyVgd+LG1LwfF5WnvByog
	CQMhRWWQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLd9B-00G0vA-1C;
	Fri, 05 Jan 2024 05:53:33 +0000
Date: Thu, 4 Jan 2024 21:53:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: create a blob array data structure
Message-ID: <ZZeZXVguVfGz+wyD@infradead.org>
References: <170404835198.1753315.999170762222938046.stgit@frogsfrogsfrogs>
 <170404835229.1753315.13978723246161515244.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404835229.1753315.13978723246161515244.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:35:11PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a simple 'blob array' data structure for storage of arbitrarily
> sized metadata objects that will be used to reconstruct metadata.  For
> the intended usage (temporarily storing extended attribute names and
> values) we only have to support storing objects and retrieving them.
> Use the xfile abstraction to store the attribute information in memory
> that can be swapped out.

Can't this simply be supported by xfiles directly?  Just add a
xfile_append that writes at i_size and retuns the offset and we're done?

