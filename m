Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF60ED2F3
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 10:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C2PcM1h1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/joYxKkr7sqMPCPCNhVtRGUOUNkb8cKp1Cu+Azo911w=; b=C2PcM1h1XesKDRjRnSbkRhoJga
	dduMuxmmhoVc5K6Ad+LYxSTpHWludxk397s8Ab/dzIIryp2JND+SsYWQXqJUH4KthZwd+yv1vYJ46
	a9M3Vpgi/skxexpZQDdCqBcKA0mEGbtIYRzHjWT9//OMUVSuKheshsrYhxn/kIIAvrsZ9nJiMAWjI
	+dtY2W3nZAIXpIrPSQnUjj2sns8nUjA9NKQf17+btV7QeeNDvAQOKwnhz+Yeo7uGHYEykCwkxDjkh
	u+Pf18Phu3Ns1AG9F9gehji+kVTzJtDTKyhCFNzrKyiNARGP1GO2+4WiguSlP5I6vMw78MDHssTo+
	dRO3He9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKc1m-007arw-0G;
	Tue, 02 Jan 2024 10:29:42 +0000
Date: Tue, 2 Jan 2024 02:29:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: repair file modes by scanning for a dirent
 pointing to us
Message-ID: <ZZPllihxlutug6c9@infradead.org>
References: <170404826964.1747851.15684326001874060927.stgit@frogsfrogsfrogs>
 <170404827036.1747851.13795742426040350228.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404827036.1747851.13795742426040350228.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:07:18PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> An earlier version of this patch ("xfs: repair obviously broken inode
> modes") tried to reset the di_mode of a file by guessing it from the
> data fork format and/or data block 0 contents.  Christoph didn't like
> this approach because it opens the possibility that users could craft a
> file to look like a directory and trick online repair into turning the
> mode into S_IFDIR.

I find the commit message here really weird.  What I want doesn't
matter.  If what I say makes sense (I hope it does, if it doesn't please
push back) then we should document thing based on the cross-checked
facts and assumptions I provided.  If not we should not be doing this
at at all.

