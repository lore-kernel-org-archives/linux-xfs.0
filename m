Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115F2567F
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MzgrYm75"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I88A3gNv5IHH4g2umZPMiYkrZPgAH8jPiNtnnHbtJ8U=; b=MzgrYm75EhW2UW2puMJjfoEEHW
	CmVVKcWchatXGrtLMnDg1HGnp5OHeWIEg0Q4RGDo+djdwLs9C2rqcOWJpKtTerlbXHK5qhxmaRj42
	j8Buh7gEQAB9XgUMzn30Pk7MKSjGpO/V8OV4JTwscxsEceWPe/9UdrlXZyAWw/ZudscPzpZFoZJuk
	iTGzLOMGSgqhQJ7SYiGhQPVGoyKUHMg/Gu58K9XZPla0RttXcphxvSitlN2yONL/Dxa4G3xl/Mhhj
	NhpB61PX9BtqLQCnDVWkr+gG2lfQ8ZyhgUUGmbyYi9q+2ggz9nTeQmuMe56lG5H0EESLi+VB3SjpI
	iMLJ2n6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLd4U-00G0Xj-2B;
	Fri, 05 Jan 2024 05:48:42 +0000
Date: Thu, 4 Jan 2024 21:48:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: create a helper to decide if a file mapping
 targets the rt volume
Message-ID: <ZZeYOvVG8texvtfu@infradead.org>
References: <170404830071.1749125.16096260756312609957.stgit@frogsfrogsfrogs>
 <170404830098.1749125.5760205126330237337.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404830098.1749125.5760205126330237337.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:16:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a helper so that we can stop open-coding this decision
> everywhere.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
