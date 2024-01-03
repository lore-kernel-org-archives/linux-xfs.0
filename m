Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBA018037
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 07:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lTWQCzuZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y6ec1h3i5L6jujzW8uYW6IWMyxn270gQkS6E8zmJUTk=; b=lTWQCzuZ+ZEf4NkawxBcxx24oP
	DJ9p/gGH5imrX8VwI0/JZUyfYzF+/oNLej1CL+AVE1RzjycJi1tqQhDXetazBML11TZheB2FKL9WK
	UXB+NtT+2axPZ49mFhBdDyq/zcthABeNkHQlLk6aD5iwAIYX+GJbp+a9zsZR9BaeeXBozq6rYoY2T
	RcGhgcCV98PbH8fvC/fjI8qh0fvOXGpdG9Q4H/26C3ewvjl+Z9jB8PLxlyAQ/2a1EmREXMjI5rLGQ
	glGqzahgVJRfJ+sZpT2Nwzfa7/lnPI6B5EQrrT/EwqnxyC8cKyHbAQxGgb7H220L027zdbtS+Yj+B
	UrEICtWw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKvrS-009zx5-1E;
	Wed, 03 Jan 2024 07:40:22 +0000
Date: Tue, 2 Jan 2024 23:40:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: remove unnecessary fields in xfbtree_config
Message-ID: <ZZUPZnPf0zpEwiaY@infradead.org>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
 <170404830659.1749286.12453760879570391978.stgit@frogsfrogsfrogs>
 <ZZPn5Y7NNjSkko2g@infradead.org>
 <20240103025159.GN361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103025159.GN361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 02, 2024 at 06:51:59PM -0800, Darrick J. Wong wrote:
> I can look into that, but jumping this series ahead by 15 patches might
> be a lot of work.

Skip it if it's too much work.
