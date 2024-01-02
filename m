Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C3AD281
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pGbUphBV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UQoGTU7JoRyo3ifbMGWQ9S6YGNKDplhgk/Nuy/nBuhg=; b=pGbUphBVxALy7RKkVWjDRAzQah
	SL1OvzN+sq/5K4YUGQKeOlDxIJ5YTqRXYa9of4pZ7qXn/NjHgm1vGhxXWtX47xqPCnO9w5w9y7yXy
	7WU1AJulUOAIhKJiAaCjdQof0QZHCz17Mluwjwog62JiSrpRzifQO/31Aak6ue5SMuzx26wvferkQ
	1+603UYGRiv8uKYWKtXZxSyhtXTYYTRAZ5S2xGznLSOZkdcGXSOY+bAsJMkvGr6c44rlT5N/gc2x9
	Nytx5UpHpxffPJcuZUEu9ZmhJIZ8FiEewa350fGGd/Z69Tn8fyWSIdapFcK2dZwSz9/JbRtQaIHNj
	6e8kOKsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKc0C-007aiK-2A;
	Tue, 02 Jan 2024 10:28:04 +0000
Date: Tue, 2 Jan 2024 02:28:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: allow blocking notifier chains with filesystem
 hooks
Message-ID: <ZZPlNOFEfG7KnEk6@infradead.org>
References: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
 <170404826571.1747630.2096311818934079737.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404826571.1747630.2096311818934079737.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:05:29PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make it so that we can switch between notifier chain implementations for
> testing purposes.  On the author's test system, calling an empty srcu
> notifier chain cost about 19ns per call, vs. 4ns for a blocking notifier
> chain.  Hm.  Might we actually want regular blocking notifiers?

Sounds like it.  But what is important is that we really shouldn't
provide both and punt the decision to the user..

