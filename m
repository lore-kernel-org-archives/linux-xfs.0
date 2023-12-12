Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bN1w3pMh"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8B0CE
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 21:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XrK2GZvvg+q7+eUa0D1Oupjk8Nu9tcvIEM7twQLLVk8=; b=bN1w3pMh1fsXwLkZFzxYDfQ5jb
	2cg8qHdo+wTZfZVkimsKZB9LAZih2+ehjR1+ZJo+QdojKvGcnxfr+tmT6FBcTO1zbG+7Moi/4UYUP
	qq2lNCEnJxwYqD00GqRuDKtb5reNXM9S0OqfwKP+midbE7lZiMMbHMV5tBMcPH3R2M2XKyU8rHDy9
	2DPrErtiiXuna0IABml20IVQc1k7uSN5V8JYTPgmx3VpHxkjwpkTH+MJShUHv1QAyW4/Jx2sMMPfG
	K+aMtKzYZ91a6L47r6Bw5bV/Nh2+UeF0p+T3o/rWuPg7egrFF3NRBbFOh+oaONbNk39OhSR7FW4wa
	PNpNoh4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rCvRm-00Anr3-1h;
	Tue, 12 Dec 2023 05:36:46 +0000
Date: Mon, 11 Dec 2023 21:36:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: repair inode records
Message-ID: <ZXfxbsxl1bRwnoSO@infradead.org>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666171.1182270.14955183758137681010.stgit@frogsfrogsfrogs>
 <ZXFbHDCxAkFq1OXT@infradead.org>
 <20231211200458.GU361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211200458.GU361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 11, 2023 at 12:04:58PM -0800, Darrick J. Wong wrote:
> > Otherwise I'm still a bit worried about the symlink pointing to ?
> > and suspect we need a clear and documented strategy for things that
> > can change data for applications before doing something like that.
> 
> For a brief second I thought about adding another ZAPPED health flag,
> like I just did for the data/attr forks.  Then I realized that for
> symbolic link targets this doesn't make sense because we've lost the
> target data so there's no extended recovery that can be applied.
> 
> Unfortunately this leaves me stuck because targets are arbitrary null
> terminated strings, so there's no bulletproof way to communicate "target
> has been lost, do not try to follow this path" without risking that the
> same directory actually contains a file with that name.
> 
> At this point, we can't even iget the dead symlink to find the parent
> pointers so we can delete the inode from the directory tree, so that's
> also not an option.

Can't we have a zapped flag that:

  a) let's it pass the verifier
  b) but returns -EIO on any non-scrub access?
