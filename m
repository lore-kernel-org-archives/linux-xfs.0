Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87703CF692;
	Mon, 13 Jul 2026 08:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932499; cv=none; b=BST1oYCYtDq9b7Gk0Opwyowm+hFLODltYzpzd4DCuRAe9s2QzUWdFL+MEZ27FqvY3RMT4kh5tqVk6qbYfkVopDpVXu3UhSWRae4+ytKR3wv7U5GKYuPL19dcWz1mZAz3Wf/4//fBfDLY/R6JWsF1SfwBVDk1+QvMk9bkQZPwDbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932499; c=relaxed/simple;
	bh=QWaO34At8IbBv8u/D6bcuW1TBeK8e9RKQNITpMuJppA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQLXKv1gbfU0yD+6Z8RkqRzud/y7NeaShj1LWgvW/AffZ7EmngXTjbGx0XF7gGsMgoT9fNK9jFduiTwZsD8HZMVK0TXfWnsLQ7x8i56iZ0w6hRDhlqL7pdn7YS1b78H5+r5ymfB0yiNaGtJige0Kf7ooNUwgPujgN3bzs/SXwec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wq+WbVha; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wq+WbVha"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=q4ssskoD8oTpR9vimX1dHxRKah6WMfaSe5PpYA8uusM=; b=wq+WbVhampY7hizaaIwOd2XJ1q
	y0wvPq2iAdHQfmp4blKDPSBk1dEYt8oe1XvgDsI7n4IDBhxpraWn7rD2BLG0PE7oAchd3zYbz1DZM
	OGx5aYXgfp35RsSoijyTJMynOSz9A/6HitrLEQOxyioU7mRHRyRYLOkwtysnI8TK4Tkoy/gblqeUO
	9pCB8qY0dRD9MvevUoO2a0pumNAErBQ7bP6sQRbIRmoWufHxTQj1wRFeT5OofqOsYPfE1/hGBRdOp
	M8SO3+OzPtMybdtNBFkDBZN0s3KQuao/1Hg3ys/+sPNSC+4l1X8pEgzClAjxJxAmJSl6B3k20xFC/
	Az9Wkdvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjCKl-00000008dGJ-1HqO;
	Mon, 13 Jul 2026 08:48:15 +0000
Date: Mon, 13 Jul 2026 01:48:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org,
	hch@infradead.org, joannelkoong@gmail.com, yi.zhang@huawei.com,
	yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: Re: [PATCH v3 3/5] iomap: fix incorrect did_zero setting in
 iomap_zero_iter()
Message-ID: <alSmTw_u7CJV9_D-@infradead.org>
References: <20260713072906.1726059-1-yi.zhang@huaweicloud.com>
 <20260713072906.1726059-4-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713072906.1726059-4-yi.zhang@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 13, 2026 at 03:29:04PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> The did_zero output parameter was unconditionally set after the loop,
> which is incorrect. It should only be set when the zeroing operation
> actually completes, not when IOMAP_F_STALE is set or when
> IOMAP_F_FOLIO_BATCH is set but !folio causes the loop to break early,
> or when iomap_iter_advance() returns an error.
> 
> This causes did_zero to be incorrectly set when zeroing a clean
> unwritten extent because the loop exits early without actually zeroing
> any data.
> 
> Fix it by using a local variable to track whether any folio was actually
> zeroed, and only set did_zero after the loop if zeroing happened.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Can you add a fixes tag?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

