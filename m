Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC23764A
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712728319; cv=none; b=SD49usUejhVqIGyoByzPVahAwdR8p3eDDGfkHCsx1kyHKFthsIy9w+26fGPE9b6ZBwHHnI6FqeWivqyxl9OVYNlh6oLRncl4sFKgmyLFKn/mjdYHOc2vZv0sHRBVlqcaR4kG715+pj+i5fTjBU9mnHdwuo1gZz7GKt6nq8EpXOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712728319; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZH1LSA4Fz0Ma86tbxsFJ6NAJL5qmHWyh4LWyzyfUBR91z0g9yrhDekt0N9ZEj1O0LCi4tusDczeXuEPjxR82ojT1/plKbjRl+FCefPPvPmgA0cijCtmsgcmq+pCW4x5ETGih8lT/RTJk1HMtQALMHBCZ/7/+0sQlkbQxJdxVEK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WNxzOIMt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WNxzOIMt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WNxzOIMtRHlK7ObabuzB/pYio+
	VwpYA4cqKVFaP1sc9gwVHRy+SngwOaJv52reTDwKirgtepN1kfdUjUGXnnlAqiHIWvnI74sjl01sM
	VIjlBtS6uIbTVnwB1SEIkkA+w6P5V/p911G3UvkcLMnXcE9bwd2BdgT+I7PCDNCYbrXBVKVem3voP
	VnD0+seiAq4NY4uq6IX7MpR+br8G0b8I0j74z9Caf3I0UUjEwpbwRBgMsopNPY8XYpqfMzw+TGRle
	Q+td6hTDG5zjHLm5/1TpGBVEGYi1PnWifovWvP2MaGfbhgcI0KqvvBWjc53sOJmKPuJwpIW1KZDYG
	zOfHdP4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQsH-00000005GVr-02fF;
	Wed, 10 Apr 2024 05:51:57 +0000
Date: Tue, 9 Apr 2024 22:51:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/32] xfs: pass the attr value to put_listent when
 possible
Message-ID: <ZhYo_GFU1NZrbrhk@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969957.3631889.6582034396609138645.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969957.3631889.6582034396609138645.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
