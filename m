Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09676182A9
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oqcED6Ip"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P+F6eT1n/JUJ1EJ9Fdn/yQdfSwHFQPS7xm5UiJcJ7M8=; b=oqcED6Ip8VnxDnQYshLhfYoaBJ
	P+ylPJjBUBIw9S6B4xWVNqJWX2nnXscrZVQLG+NHJFnlwAAwao5adAffkgOXvYmynhWqt1xvYV/yE
	c+N6yF8zE0EsvlrG9Gez8KQDgkXLF+ulmfZBDHCBcEN3v6jh0QNwVTqDmSgNp+49KkdbNa9AUGKWo
	50dpILNtNCD2EnEHYOVAQNDVT9r+FInORVIw/KXCkBC1s3//b5+5rzc1bR0Y2R/g1oipOQlu1cgm3
	dPkFWNqrjdwI1TCHX4HAXZv6NTYQYPJeHocgxIMLiKHAo6n1T8NNgbOnjRFvaLcPopcwgxZgZnN3K
	2sbT0+Zg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwyh-00A8Fa-1z;
	Wed, 03 Jan 2024 08:51:55 +0000
Date: Wed, 3 Jan 2024 00:51:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 3/9] xfs: create buftarg helpers to abstract block_device
 operations
Message-ID: <ZZUgK4Ah6QJkgOyL@infradead.org>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829626.1748854.5183924360781583435.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404829626.1748854.5183924360781583435.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:14:20PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In the next few patches, we're going into introduce buffer targets that
> are not block devices.  Introduce block_device helpers so that the
> compiler can check that we're not feeding an xfile object to something
> expecting a block device.

I don't see how these helpers allow the compiler to check anything.
I also don't see any other good reason for the helpers, but maybe I'm
just missing something.

