Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685A82030A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 05:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724734827; cv=none; b=aZybxUHNiHCh+zZ5VBy866czXulCV/susOa8dHYoRt2p8dS5dEqvUF/7MffKPv1VJ7GKZShJfK+N7a7Ey8rkaXJzMwW3ofyhjZYDcOhdbcP67LLfz79O64lpSbpQ/Ju+Riv8zfG56+fUGFB2E7No951kaq+AR6c6R1VJC8HjNaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724734827; c=relaxed/simple;
	bh=HYWV/+jBHl0Un9QR3B+9mSSORECMKYp522kHMdprT2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m654vmTn+OhtA2ChrItTs2LlO3gtPtXTHsGUEDjPWJb1wY70Uny68c3mld6ifrWUPZtTq+Gr8L2QcNrEWcVkh1alPykTmuGWISWw+kJoLN7W6rFx75DklsvOabuQPwMltOjTpWExwU9zZKPSnVbbBsQ752ggYtXK6FxFDIVRk74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b2pspTML; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b2pspTML"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YKtDqyBjk88kmbzyExYFtX8/mOuNLWPDvY8UAaNzNxI=; b=b2pspTML6Z95muAAPgZhpV1b+l
	IiO9d7MEBwG8veWAFxUbbavJID6Ikx/Aa18I2XXp4GcvnBxXjDrJ0yFEPJjoP04/5rrb0JVFxCO51
	Ti9juYQ23ETjP9uzorFoGRqHkwdxkIkUXsxRwKLkO6v55c09qCcizYEvHvW4B2e3Gb9DWNd5YaN1B
	ETdvCZylmo+QoOb1kWz/rBqF+RfNweyf8pNi3l1Wz3jViaL1XwWDZ9svvjDUWRLArlAJqJh+b3nyH
	JyckmQ7WBxEN4mS+418usMDiFqtfd7S1Y6dJlt4wZpvcJHbtahXU92O2LmCqBYU6Ds5oPieVh1EPg
	FEt7xoCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sioJd-00000009nPw-4AH3;
	Tue, 27 Aug 2024 05:00:25 +0000
Date: Mon, 26 Aug 2024 22:00:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/26] xfs: make the RT allocator rtgroup aware
Message-ID: <Zs1daQC3PNoGCWrX@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088886.60592.11418423460788700576.stgit@frogsfrogsfrogs>
 <ZswLBVOUvwhJZInN@dread.disaster.area>
 <20240826194028.GE865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826194028.GE865349@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 26, 2024 at 12:40:28PM -0700, Darrick J. Wong wrote:
> ..and pass the ap itself too, to remove three of the parameters?

I tried that earlier, but it breaks the allocation added from the
repair code later in your tree.  We could fake up a partial
xfs_bmalloca there, but that seemed pretty ugly.

