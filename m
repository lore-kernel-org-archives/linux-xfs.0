Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C662556B8C
	for <linux-xfs@vger.kernel.org>; Sat, 21 Dec 2024 08:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734768538; cv=none; b=MHVkjNoin6BirwC9dDpTCJDP6fCO3ea9RWPJEuJHDAj2Ci8WY8mn8SQO+WCOHm/ov6lgoOlxKPTbC1Wg8WRw+w1lobzJC44ADWOIgHC25Oow8SBAR0A7408qbSe86+sn94HVBiHA2RyfTibd7r9g/ma46lLuiUy8DIFcTyZ4vG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734768538; c=relaxed/simple;
	bh=vt6w9mQn6wR3XJA6H3Omm7f9cHOtER0lKZwxs/HfR0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CDYngdFsH/DqeSt1LFFaAzUw9QLTypuJU6MS/E7r5Jop6aQx64G1gPsFa0eo+QG+KRZRqXzWwa5KsNcIJCbmmIhPvN/U3bC1pKLcy2rqKnz5/TCCdDX6IH7u+hAXLhJqVudv7IE4qDprGzOo3G09cMxPsMArp3+fCMY+20RmWIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CZga7cJp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CZga7cJp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lwwwkrHN1VK4v4RE2dScY43pqCTKGomlzKf8wZ+axD4=; b=CZga7cJpKquuKZmpnTQIR6Ql2F
	92DYm2wDC2zz4R68HVauDHSZjt7p5sCIVqOqO3/cp4C8ZbvINTXQcQzrMbSbBK3HkuaRM+A3brM6G
	+Fo7ipDBIchblpnZGILaOek0q1Y06/vPCuI+5AsMpJTzi7csNlrcuRpamivBjltfRlpF/mLKfKGHr
	PGEJzpxA8w0qzE775qEN/WXSxr9HjbR7VsWoXI6G3JBoIdzEY4mKyQGwW72Gtzs88cW0VUd1Ic7Wm
	WWAljb0V+6aY8SpGsxlBH356azIsogmbN5Jl8HIrDNpurGY9kQH5K5pW/1uEZGKTO0SUGIVEeC6gD
	MBBOCnrg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tOuXg-00000006iAC-0Og3;
	Sat, 21 Dec 2024 08:08:56 +0000
Date: Sat, 21 Dec 2024 00:08:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	david@fromorbit.com, yi.zhang@huawei.com, houtao1@huawei.com,
	yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH 2/2] xfs: remove bp->b_error check in
 xfs_attr3_root_inactive
Message-ID: <Z2Z3mLjW7KXQKexP@infradead.org>
References: <20241221063043.106037-1-leo.lilong@huawei.com>
 <20241221063043.106037-3-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241221063043.106037-3-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Dec 21, 2024 at 02:30:43PM +0800, Long Li wrote:
> The xfs_da3_node_read earlier in the function will catch most cases of
> incoming on-disk corruption, which makes this check mostly redundant,
> unless someone corrupts the buffer and the AIL pushes it out to disk
> while the buffer's unlocked.
> 
> In the first case we'll never reach this check, and in the second case
> the AIL will shut down the log, at which point checking b_error becomes
> meaningless. Remove the check to make the code consistent with most other
> xfs_trans_get_buf() callers in XFS.

Hmm. I don't really understand the commit log.  The b_error check
is right after a call to xfs_trans_get_buf_map.  xfs_trans_get_buf_map
either reads the buffer from disk using xfs_buf_get_map which propagates
b_error, or finds it in the transaction, where whoever read it from
disk should have done the same.  So I think the change looks fine,
but I don't think the commit log really explains it very well.

