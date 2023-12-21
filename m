Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9D29479
	for <linux-xfs@vger.kernel.org>; Thu, 21 Dec 2023 05:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qiBdbPdS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vCZVKk2v44ZcQ1xrnkfM9J+KAgcXDGFSYJJZ4UCahxY=; b=qiBdbPdSXRxHHmtWvg6aveQnvP
	lKSXj8Ex51IGAqCXPZIVnHdqOB6RINWW4t9zoPPB2ZfntkuW8Ygb5QQvH4zobtuKgq3sXOyUeAkLu
	7BoyPBySygL/K8+X5tVtgNpeDs6wA7tpIPubvz6s76qf3FJXoQGKnvqI48FpEKJ9NdTDwQlhz4F9q
	u1yxV9Hi5/mq/2UeJ9OspvAr9wq83Ig+A6ESGLPZS89RQER8NYB6E8l7v1qOdZUOOYobQeaYTgbKe
	YcSP/uBsW9LTvKDg+ZA/Kpw9wFOs7wDve4D4UVSTQa6ct2wOgP3UmtVU4UNYNhsOl5AY5FP9JOURv
	L7pTxKnw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rGBdm-001kKx-1g;
	Thu, 21 Dec 2023 05:30:38 +0000
Date: Wed, 20 Dec 2023 21:30:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_copy: actually do directio writes to block
 devices
Message-ID: <ZYPNfkuIn/CPl7Pw@infradead.org>
References: <170309218362.1607770.1848898546436984000.stgit@frogsfrogsfrogs>
 <170309218416.1607770.6525312328250244890.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170309218416.1607770.6525312328250244890.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 20, 2023 at 09:12:28AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Not sure why block device targets don't get O_DIRECT in !buffered mode,
> but it's misleading when the copy completes instantly only to stall
> forever due to fsync-on-close.  Adjust the "write last sector" code to
> allocate a properly aligned buffer.
> 
> In removing the onstack buffer for EOD writes, this also corrects the
> buffer being larger than necessary -- the old code declared an array of
> 32768 pointers, whereas all we really need is an aligned 32768-byte
> buffer.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
