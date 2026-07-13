Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682A5355803;
	Mon, 13 Jul 2026 08:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932464; cv=none; b=N7zMD6VjEkceto334q/qo9cgYvi+bxOlF1iFFoTwOZcZJBpCFIZ13iVzKF4fexNK+clXHn2lcm/J9cnr9/03WAZcpyXjbSAOFHFrTXuouW1pAVYhYN0Z9uhj7Urxv3uVCU/9uGfiapTIPAdna6M4xth1nBB0omt/X0XjnXDP3+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932464; c=relaxed/simple;
	bh=K0yZdIfe2f0SkpnOB47uwFF36dYYdDp8Tb3VVPzodAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WG3lWasVx7EAEjUNUw+QV7rN9+eCbg/NQ+tW1g9CpPR0qHXAlRpmywwbrHreqINqfurwG5gBCrLMOAuwQ9Xp4vwuX//5h2RCzyu3JDnD1OPPkrnr/NTTw9iqoU2+AloeyfX27Ft2lF5PVX2dQvdO4VS452/8GAjD/rohfyKkDiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wiE+wt5O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wiE+wt5O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=K0yZdIfe2f0SkpnOB47uwFF36dYYdDp8Tb3VVPzodAE=; b=wiE+wt5OEJvXSXzzDJZgvF+nSS
	832VEMfH1qnrZuVSH6Hr/6j08VgCWwwdSZO25SUuVzQmJQF/si9vy4TVXcyqnMKyrhfM43SZ7U+Jt
	chQyplP6ZcwuyW0N5aEvz0jUeyTl8BRYQ54SVuJW6Kb6smER2Z9T3RtmlLyyaiRg87aAiwiAwtsFb
	oKvec/OE6FFl0oHTtbdqnXXlGofZWUqQoA8hp6Yh87uhQXFjPnxFCXoiPVz2HDRyRTLcUhNyrBvNo
	vf5FuaqWCvooKJDhci93L77dcr9KwE14wO6EJRCkPmLmSQ3OrnXMN6TS8LfA20PsA0R/jl9kdxKx4
	We0rarMw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjCKD-00000008dEP-1Q0r;
	Mon, 13 Jul 2026 08:47:41 +0000
Date: Mon, 13 Jul 2026 01:47:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org,
	hch@infradead.org, joannelkoong@gmail.com, yi.zhang@huawei.com,
	yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: Re: [PATCH v3 2/5] iomap: support invalidating partial folios
Message-ID: <alSmLfvpehKh690P@infradead.org>
References: <20260713072906.1726059-1-yi.zhang@huaweicloud.com>
 <20260713072906.1726059-3-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713072906.1726059-3-yi.zhang@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 13, 2026 at 03:29:03PM +0800, Zhang Yi wrote:
> However, the implementation of FALLOC_FL_ZERO_RANGE in ext4 depends on
> the support for invalidating partial folios. When ext4 partially zeroes
> out a dirty and unwritten folio, it does not perform a flush first like
> XFS. Therefore, if the dirty bits of the corresponding area cannot be
> cleared, the zeroed area after writeback remains in the written state
> rather than reverting to the unwritten state. Fix this by supporting
> invalidation of partial folios.

This sounds like we could use this to avoid the flush in
zero_range/truncate in xfs as well?

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

