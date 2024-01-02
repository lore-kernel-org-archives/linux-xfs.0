Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E12F4F7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WyEKeuTx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oZsaDOREJp6Vqw8aIpMwdgGTWlrk9iZUx/knJ//8jQ8=; b=WyEKeuTxNNA8WSWRxuAJjEhFrk
	L4O6/Y3V3GjMJG7+Y1RHA+VaiinpaeFtuBPbmXcRcsmlO9bM11pwOJ59FsKdS1Z3YKQk7gl3xNKDl
	kv2Y+V1JogLdYaHo8D0fKOSzCWdL8obyG1N2o74bMY1WyHvbjKb5duRE6VDqqMkB/Q5e19JG2VScF
	FIFvNDIPjroz2KuRyhTpr+oqAp85ZNIHhoJwUWOT/NfvbRmbfD/uBCnZPG1sps+0OrhWsgNCbMkV0
	IdJhdIp+OdcVIKGWlO6paCHYwJne6/SV3wWXVV7N8z5vjVDqhOI9djlUzKBywwFW1lSSXYQB74wX3
	+uALO7PA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcBJ-007cnD-1Z;
	Tue, 02 Jan 2024 10:39:33 +0000
Date: Tue, 2 Jan 2024 02:39:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: remove unnecessary fields in xfbtree_config
Message-ID: <ZZPn5Y7NNjSkko2g@infradead.org>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
 <170404830659.1749286.12453760879570391978.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404830659.1749286.12453760879570391978.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:19:17PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Remove these fields now that we get all the info we need from the btree
> ops.

It would be great if this series could just be moved forwared to before
adding xfbtree_config so that it wouldn't need adding in the first
place?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
