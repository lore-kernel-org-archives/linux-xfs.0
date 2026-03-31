Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B9228DC4;
	Tue, 31 Mar 2026 15:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774969520; cv=none; b=fcp3+AtCmhNh1TDWV4KoeC8/4oLEftj2/O8a+TKd3/HA2Y/PeXgzlnyQBrcjeQqv+/TjKNOUpT1pgi7tDXCbZHt/saU8DOSReleWfxReWnG7Gzrw0/HBLkE5b7ttxCBZIq8cvUkAHLWN1hWKtII8u/SQvUi3+goD7McFkfaCWZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774969520; c=relaxed/simple;
	bh=+JfymAP68hAasYs/AXs4g8n06pHFIJWv3hjyEzuJeqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lnT8a8w0MrL574hCCOLAZ0PvGAM6A+PEnPU/hSiv97Wy68ME7lespVxsuPOeddEz9e+0pLOY/JED1o6fWxj2VhdE/Xd50/61Z9BocN7HPibk4z8CGOjt8+0HeqRkOK24jFj8NL7X46aciPyRXA74Li0iNKWmz4pQys8T2jZqZAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PrBa4VdF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PrBa4VdF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CFx+ROqAgF2F2bM/D58mSlwE/AxkxKNr+qeMBL+2Kso=; b=PrBa4VdFt8XHPFuQXDpshtWR3K
	udwVkmxuDsEQ9tcZaacR1UXsLCDQnVGNi4a6oH13p7bq47N6XhzJ6jFiNsBlF1yQFJyo3XFzeXgBF
	KUgmUfIsgGMAj+uNISMz0QiDaZhQWagmeASL6NNcwCPMVN5Bs9RlndRq7K838Rw1QPXq3CB/OzxbO
	Qvhuau8KzN+yBu6REsX6/fpVIBPP8+5N81o3QMjw2Nxf5rkB6cxTnwX/a2wfDaf22QbuEyqbJIA7e
	PiMDtsfJvZZU6JfKlYq4/O+RZDC8uuDGVCtgy8yKtDdjtC2oFc70N0ddNKFqolSiU4XTfwrJyUyUo
	UPBmvjAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7aeb-0000000D932-2pn1;
	Tue, 31 Mar 2026 15:05:17 +0000
Date: Tue, 31 Mar 2026 08:05:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix integer overflow in busy extent sort
 comparator
Message-ID: <acvirV507y7CrQ8G@infradead.org>
References: <20260328173407.43057-4-ytohnuki@amazon.com>
 <20260328173407.43057-6-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260328173407.43057-6-ytohnuki@amazon.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Mar 28, 2026 at 05:34:10PM +0000, Yuto Ohnuki wrote:
> xfs_extent_busy_ag_cmp() subtracts two uint32_t values (group
> numbers and block numbers) and returns the result as s32. When
> the difference exceeds INT_MAX, the result overflows and the sort
> order is corrupted.
> 
> Use cmp_int() instead, as was done in commit 362c49098086 ("xfs:
> fix integer overflow in bmap intent sort comparator").

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

