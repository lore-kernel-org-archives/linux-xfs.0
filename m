Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3702188737
	for <linux-xfs@vger.kernel.org>; Wed,  9 Oct 2024 08:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728461134; cv=none; b=S+1xVuv7EqMzD4jRFyQKcFL0oo5kARjHBPswDsd8BUcNBNLvS0OeeCqDXscplHAr8yFPgJHlHHMBnCYkCuEYXuWUm5P9JtY/+qrhqaHrCB32mf9ct5IuEl/PaPsQ4/q7r4oYEa0l4VMfbjNbOL1WUYk/ob2qaa9F+RhsnltZiGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728461134; c=relaxed/simple;
	bh=WcBLUHvOmU6myP/gfI0+Gj8akfppDE2BaWPtjns/XA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdIYC1DVIi46PQBCqly/cxQS+OOfnPu2JZQ6PDl/cRu3nSr8k1KxJ2vKyb3b3vAudym/U5dJ8GiV9Bvzs44pq2O2CUucTzhzKzzxjUrb6yvp+PVCCh+hE89NpDzdp8jTKQA6dDTTAiXUVBniat+XISjzN8psEhOTAPRZ8ZFXd6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Fiv3Z0GJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fiv3Z0GJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F8W2BvTCB23krSDBFllPgLRu8rkjZ5J4JGWzO5e7jQ4=; b=Fiv3Z0GJeQKxRbZcrJalzd8/hk
	4bnRRcHlINbCFWwdBTTFaymucPtT/oZVOUR2a8Nx5H2IySGTSfIRx77iOlDlxmQz7eTJ6tLVMQBe4
	2mM3zQ7cmD7qdskJw1rQtw9lhfK3FqoN4QXmRHDKL2pBMjryNa0ooEN36Hvtf1CHyrs24RUuuGWb6
	htKraVZe6PiIEDYRPT7/YiCr6lRolf0lZx2YZDuXIN1sssTQi1kfCiBlcp+05EH/Z6kfWLkjkFh5E
	iv1xT2WRP9ayQf8iiIk+X0Lt8hBRsLoUQFjWkEhpKJr00T7G83gkv4wa2miNFYZ7T8CZymasqC/ey
	eBjG6XvA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1syRhM-00000008N3g-0uYd;
	Wed, 09 Oct 2024 08:05:32 +0000
Date: Wed, 9 Oct 2024 01:05:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, sandeen@sandeen.net
Subject: Re: [RFC 2/4] xfs: transaction support for sb_agblocks updates
Message-ID: <ZwY5TGnmqq91xsSJ@infradead.org>
References: <20241008131348.81013-1-bfoster@redhat.com>
 <20241008131348.81013-3-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008131348.81013-3-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 08, 2024 at 09:13:46AM -0400, Brian Foster wrote:
> Support transactional changes to superblock agblocks and related
> fields.

The growfs log recovery fix requires moving all the growfs sb updates
out of the transaction deltas.  (It also despertely needs a review or
two)
