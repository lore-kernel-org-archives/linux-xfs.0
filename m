Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m+aCgSv2"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963EAD53
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=m+aCgSv2VPAX2JzLI5MnCnzZMf
	Lv5yquOuqtBbFAGhCSZtexwz5HH4p3tZ/WMNKTduQy3DDIcAHuD/RzwsJyLwrMwv2ig8zsk8QgokU
	9oR6RLbCZqYrym53u/t+5RlZuNs91dfKR0VtweoG8Mu5g+Lp2gCeoMSkBWteuVuVEIqW7sF3x5+aU
	zCrPQ/6BhkXpvoAuujGc+Y+pMKr+ZNH4WKgXB0HyEiIOu42cKrz8SbIds/e4l+G7EPL36x7V2JeX3
	8L/P8RSQZr2f5XTfrq9OceRtmPP0nmfN30NVs4HwL+GPgz1UrfuuaJmjYg3nV35FGRWzp+jUcSUde
	xRCnk/jQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB6vK-00Bti2-1T;
	Thu, 07 Dec 2023 05:27:46 +0000
Date: Wed, 6 Dec 2023 21:27:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: move the per-AG datatype bitmaps to separate
 files
Message-ID: <ZXFX0gxyvh/fYhWJ@infradead.org>
References: <170191665599.1181880.961660208270950504.stgit@frogsfrogsfrogs>
 <170191665649.1181880.7564445102317360980.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191665649.1181880.7564445102317360980.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

