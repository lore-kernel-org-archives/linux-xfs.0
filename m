Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E9C9465
	for <linux-xfs@vger.kernel.org>; Thu, 21 Dec 2023 05:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pHnqH0XX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=pHnqH0XXb6JE5W14UI/4lnreG9
	xQJlmgk3P3j60MM5YCslLHpwXBsNVp3rPLCFpN4R8KBdz1nwnhPhWBFg6aZy6vjB8ezQSPQkCZ45y
	aIUCHC5qEi6qXCPDyGfJeWlw1weO2zo30CqDmPeyIO3I3YKn9zHesQFuleW8/3bKOt5CQAh8Z+Jql
	6PETcF46Hkhb2K7/CLrByq4MXRJkHCRHnqb8SQVtmRrRk6I1yRyUaUC88VsyJ6cWCBXdytbnDiF0u
	ApF6TjjUW2Tu13j7GYr0wAD1aSf8FPg4yTt9PUlT6dfkDDrpvn+3/ckx+pfls/PiFFV4oE9SplHaR
	Ek6rwlAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rGBd9-001kHH-01;
	Thu, 21 Dec 2023 05:29:59 +0000
Date: Wed, 20 Dec 2023 21:29:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_copy: distinguish short writes to EOD from
 runtime errors
Message-ID: <ZYPNVkGJyV25UKmr@infradead.org>
References: <170309218362.1607770.1848898546436984000.stgit@frogsfrogsfrogs>
 <170309218403.1607770.4299633539281504295.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170309218403.1607770.4299633539281504295.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

