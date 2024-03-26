Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999DB12AAD7
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711432679; cv=none; b=bcz4UKjR+BhwZsU7zyp5gPnTeB0TJo4QqOcNHEEIXaUqhXhhuCzbWHK9f1rHAOa2ICp7EeoLIH8mw13IqZLQSLqJV3Pn1SoxSuvnJ/G3LAvQnLE2ZG7ttHDM9dlaOutNOpErcWm1YgIz8Z0jzlMyxdS1dEcK3FQOudVGXgk5dfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711432679; c=relaxed/simple;
	bh=A/yWtYikOHSdHqMvGVB9vmU89/I2ydbOSVkeAQAAtS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/e8rgBopXvD2mpcus9fN8PQpXtzsxAFID6H1QQEHaixdKuWVpbvNSBEL0GrfkTWcg8YIjPAchgW6EwBmjZmOACiC+QGPPNjxnf9/fCWtvae+pIRK4PDOEvTeUD/EdM9bNfRNKcjAWqs8G6sVGWD2tQRFOMiaQZbkWZbbxnMYeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fHOA6iZ/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fHOA6iZ/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0fMSGsQ0WfYX9cG0h66K8K7n77Yt5o/FUptZPqPp4/o=; b=fHOA6iZ/lo+wC/90eZ99WpkZXy
	L0E5J20393EUHZwBJgMbFscFrbSQd+MSVEi+Tka8j0AsNBBhofRaL9r+WTnMaLaNu0Cl+C9YSy1t8
	f2hsfsbULJdhCEECYi8NYTa8aVdiO4oY26cTCmKo46bUmdUzhRD5uFzCDlM6CL+FOiSe43hIKaKe/
	udHT4cFjUzngaS+qQd/GI4v6m4451NOpj8iU9xc0IqVhKURFb53AP7dOQbGO2yXowcR86V4FIywu0
	A6UPZr+e7DYBP8mFB0RERYjKjyOfV9RSqN6PloABQUHmgsqjwIGc0yHbqXqKXsfyDYI4Zzon5lmo4
	pq8EBsKw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozos-00000003Cd4-0LfZ;
	Tue, 26 Mar 2024 05:57:58 +0000
Date: Mon, 25 Mar 2024 22:57:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_repair: define an in-memory btree for storing
 refcount bag info
Message-ID: <ZgJj5Y2ORvXhKSXR@infradead.org>
References: <171142135076.2220204.9878243275175160383.stgit@frogsfrogsfrogs>
 <171142135095.2220204.16042670537695757647.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142135095.2220204.16042670537695757647.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 25, 2024 at 09:01:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a new in-memory btree type so that we can store refcount bag info
> in a much more memory-efficient format.

There's probably a reason to not just shared this directly with the
kernel?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
