Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68322493646
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 04:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787546865; cv=none; b=ZN/q31Kc2Yqqw27ZWUZi67knxGbhoPHIm+ZXtLOWB8X+t45t3A7oRJeCLTwDX2LkkDeM4be08cruYaGLIu6tH3l22MJznu7cXU+yhczTp3Dfygw71ea4dq6HdE0eZHOzHF2dinm1USVmV3WsCexplUpHH90///i2j5wRh6EIixo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787546865; c=relaxed/simple;
	bh=gbe8RZ63hgZAL+rff4ykV7XOTiFCmbBKDqWjeziRDCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jfEMOKm/NvTH1e74+XurqdDItQYRU2wqoNMeKYX+Q7wzL6+4I0wyiAls2+2PEfJs8jC/ka9ut5U9V7ZzOJNyOoJ87MVNv5Ip7qG0wxIfiXdUZht93iZvZCETXuEk8WDm+uKH5IQCnjztAXRuVyP5xkcvhZ7QFnTEHo3WMMxHedg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jOoTxYMH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jOoTxYMH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gbe8RZ63hgZAL+rff4ykV7XOTiFCmbBKDqWjeziRDCM=; b=jOoTxYMHvu3PchvEwhmBpkOAem
	0knlUEgqQ2OVHGmiebM9DoJGe7j56rnkFk0Bp2yiN62Xs4lo8aBDp47Ow42dUc1TdSJIgH5uxlMUb
	201smirdj929ZRLHFQK9HN3Zq/8txXRjvHWyo1HzYxFRtVDYKUYnKy1bFALO7cd67BWnNN+/NTroc
	Nrsr8JpO8k0KAND75zrPjUPxoCDiCMNErWsQBTf6x/juIxrlyEcHtH6++sjJ0UrBBhDMyKzaogRzm
	7A/8kUfyRLuasIUCnB1uvHEn0BG3cCoIT8B/egDB7M2vPYm5k3Irg5uxH0/GNKlaN3P9tkxZUtfdp
	9TPqfDsg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyMb0-0000000FuyN-0PFy;
	Mon, 24 Aug 2026 04:47:42 +0000
Date: Sun, 23 Aug 2026 21:47:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix reclaimed page accounting in xfs_buf_free
Message-ID: <aovM7hOwkqmZn9ae@infradead.org>
References: <bf0a3369-f788-4519-9883-8d01d42631e5@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf0a3369-f788-4519-9883-8d01d42631e5@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Aug 21, 2026 at 05:03:37PM -0500, Eric Sandeen wrote:
> To obtain nr. of pages in "size" bytes, we need howmany(size, PAGE_SIZE)
> not howmany(size, PAGE_SHIFT). This over-reports reclaim by orders of
> magnitude, up to 4096x on a 64k page system.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

