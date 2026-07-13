Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916A93BF676;
	Mon, 13 Jul 2026 08:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932550; cv=none; b=p5iN2TJ4BVHNerFg9nKH80S4KWy0xwlUQZmXl5ChHeI/8gi/gFUAahkAQQhytYSivJr4TsyFF/DTEs8qknGDt39o4ZStC+0aNmfLzTrBemAh+vYtyZUAheQR3/N+r0PzaPF02K+IxeMLrsTHkWHqaEa8Btla/yE8mGUAMlEtulA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932550; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dGGAaXbgsu0FJYyas1txgtv6ZAF3rPynU/yhvXSv9Ap/K95f4VPfsVmeAtiRW9rpevHh/PQIZYfQnLiAGEL/OegOdToQ+pc9BaXr4vYOtV10w6UMA28j8C/+A2mH3M4+vd5JZ2+eTJvmJuy/sX9OzCIn/ocBt8NVP6HkQ39BnZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ctt6iov8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ctt6iov8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Ctt6iov8XlyZ5qweUkDc2AMakv
	1cquxBIKMtidre6tqOBfQMFC4JdkLEwWsUTaQlkFp6wWOdSiv3oQyNqdAquV5Gse5ZKpgikOFUW59
	LfcJ+xw0+kxvCGFiv5xFp8SKurUL2u0J4LkyeFxqcKGjJffQKsLeoUvkJS2p3SkJVFxW6bwDkr/29
	JC6VlnilcS5dDW+QLnRduSY/Zk71wY99TWODyrZMLg34dKfWHifY1tnC2VDp8Iw28ggsnKRNWg7nx
	DAdQuDOFwDN6SzE0nKdoOna42hUG6i90lFOJBfbR/a+dRLCzpRVeps3gMRkOoyjaL3mS5dae+8PHx
	9vYReOfQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjCLY-00000008dLa-3uYr;
	Mon, 13 Jul 2026 08:49:04 +0000
Date: Mon, 13 Jul 2026 01:49:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org,
	hch@infradead.org, joannelkoong@gmail.com, yi.zhang@huawei.com,
	yizhang089@gmail.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: Re: [PATCH v3 5/5] iomap: add comments for
 ifs_clear/set_range_dirty()
Message-ID: <alSmgEpoqRruwoh7@infradead.org>
References: <20260713072906.1726059-1-yi.zhang@huaweicloud.com>
 <20260713072906.1726059-6-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713072906.1726059-6-yi.zhang@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

