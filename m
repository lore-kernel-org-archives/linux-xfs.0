Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B5714D294
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718303897; cv=none; b=gLZSDMVxmM1XywRn4+awLPgxo69AlDutDSZouPfDRi1R4uOtL/1YTrTBcszNWoSTdtye/MNGu7l6K3jzYEHqCmokfGySAnPJJ842NaKPFnZBgNOMI6GYdVnnsgKzsuAGu4j/ljnGt4ZAd/ZXcClNVUKx4ZsPghHZe5XkS0E9IcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718303897; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=btrF/X71ghn032dv4sItdOaKwiOQyB1LH1UyV6n6ApWI0ixOUAf3QgvLnuZjL2rMi6ZpI+iOIsUriig70wikg4MlQfDpcKQNOVqOl0vX6NegXsWXhDnGY62BMJcxPG/5oyK0m52w7oiM3wV91ugQbiV18HA1Q0AO7K67GNa0tvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lB3xRWHr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lB3xRWHr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lB3xRWHroU67SsqO66dy1hIQ2A
	5WFu/zqMvEQM4xqfrh5FN1afedUa+8Yns0ZjYgmKJzLIUHu2uhn/uIywtLQLs6REOIvBBkPRAi9sd
	kPdRjj9n2ejUxgyBNn6VkTw4zm0SV2reHWWZVxa21rOrBzYMw9XGTyA4m39N1a19OdsSNHzNPHcV+
	RX9VB0fHBcjO7I2LawtYwbYhQ0h75MN3QyNvUSx+X8+qBZFrj4bnLp9qw5qUyQG6ODSznjkY2fwvj
	+cLXMosx/dc6eXkFeIqAsKRb53K+svaMvIg2iU+ZA8taKHzQyaWdR7vpuZbYKPTbNQRvvwqlnwCQc
	cevY+BUQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHpKw-000000008FM-3i0e;
	Thu, 13 Jun 2024 18:38:14 +0000
Date: Thu, 13 Jun 2024 11:38:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com
Subject: Re: [PATCH 4/4] xfs_repair: correct type of variable
 global_msgs.interval to time_t
Message-ID: <Zms8loTreGN3jj91@infradead.org>
References: <20240613181745.1052423-1-bodonnel@redhat.com>
 <20240613181745.1052423-5-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613181745.1052423-5-bodonnel@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

