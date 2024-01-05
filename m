Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3793D5243
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BXhU/Jzx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BXhU/JzxCwxPV6GZy9L9Y5O7Rq
	4XGZBzhE0dXYBHJA1CEm3fLcuhfofLrnre0Yv5WV1sf18/SBA+VmnMHkPGQZhCZBNowuGXN1nU9QV
	62Gg1bBlieCy0p81fH72hlvirDHIIIhqR7Tg3Osd84SR67JB5aLoucnxIN4U7aiNkj5obPph1UclX
	klgUxKfhfeG2nRpeOn0961d5k41+cqFVOcyHXZMT/YfdoSggoiZJIz6J+a5Un7dTGBnOc+nF2Kdg2
	BHmCHDznPpN1v86iMxXfYqOLg04znmD6BvuuZ/7pPNpOSpvJHuaUCUznZ0aldxdOewX0lbm+BB0Cp
	VQJtkWMA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcFh-00FwXB-2k;
	Fri, 05 Jan 2024 04:56:13 +0000
Date: Thu, 4 Jan 2024 20:56:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs_scrub: don't report media errors for space with
 unknowable owner
Message-ID: <ZZeL7YXuLw7zD4W6@infradead.org>
References: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
 <170404998673.1797322.18151501437365003721.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404998673.1797322.18151501437365003721.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
