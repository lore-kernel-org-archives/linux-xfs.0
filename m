Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3A/9wk/F"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC395170B
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 21:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sUH87WP1iTL85Ea26LB3nngE8wXMh3Y2aNIipvBYEpo=; b=3A/9wk/F5o6VKPSFGqr233JVW3
	429ITMgackJYM8OvL+UziF+kymmqLXqMGRN0kniPP8cZ5TtT756+RBV3eJYodpA4QSQX/lhetMp+h
	GXG7Dbx6GG7LV+EpzdGNRajvY9PuJggWCV0aTWtuBGDenZqYAbjaQmWQzDu7JTPSHwyInzWOmVa0K
	tgOg+aJl5dCXQhccfRRYoll0uGjnT2Dy9VwzWHKw1JbQPFLKdlwH78oUHGbNL0W9Hkyex8lQrwW9o
	1Np8kwmFXMfv+yiCHdQj5/j5b2jmGbGx+KAMcvzC8CVGCY+Q/BhIV4dkgCyGOOmfqeHx7chPsXdFF
	bK1GE+pA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6lYd-008dGG-26;
	Sat, 25 Nov 2023 05:50:23 +0000
Date: Fri, 24 Nov 2023 21:50:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: add debug knobs to control btree bulk load
 slack factors
Message-ID: <ZWGLH786QzH5KpUj@infradead.org>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926609.2770816.18279950636495716216.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086926609.2770816.18279950636495716216.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 24, 2023 at 03:49:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add some debug knobs so that we can control the leaf and node block
> slack when rebuilding btrees.

Maybe expand a bit on what these "debug knows" are useful for and how
they work?

