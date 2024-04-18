Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3381EB46
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 04:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713414393; cv=none; b=Ub9hi1pzIzk3dIx8vXX92ermQ+potZyZqgFbhkepGwQ/4aJzOOJDtC6Oc1XGm0yiCFUnYsDk4Sbmq/T5Jt09+RwyzDPd3u+VlQphx54OXcsYc/QPSz+N30Qf4jULvhrZcnwM9mhAuHVlB1ppfZXkZPOpQz8JpQ7xSljA+tJtYlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713414393; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQCi+eCF35N+SGOzMS/Z7E7tHqCHALFr5sJ2gFTnRecUtKFIjNOs/cqkFKZuaoIh0rtFEu2RsdcOtRAlrBRKgNtHyFRR00B4MUjYmVyctQaxkMbNo5tggGHb2irWDrFsFACCzhddwWlxdFpCuGO0rtzBUlH7qLXZixI8PJo7zFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JNlOXbVG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JNlOXbVG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JNlOXbVGIFOy/HKzAOjEv7UkJC
	pf9H9WU8v95ADRRMVaWQdzBJNJZcwlPBGQQuBzN5zgQyBPCppOqmA66BKkmTwwnAZsj71+L9IUKES
	MCnmkOfcJM8fjG59pUzCKT1V7YtzL+pCM/v0CybYWQaX23ohXGISgPsVOY/8lhxpic0bGktLxdWZS
	WiZz2HNwgaPuQLejUC6I3ZKEN4wSbvt5vVVFJrIUt/eSzRa96KZoSjBosEUM5iDWrq/Lk1llHfB+6
	5rE5OlHCxEeA3MOCYEXifsdQyycUoj58E67gcxpTQPZocenLRsIsb/PY9cdgf1xS7qN+cTdv1IiRt
	WbdFBl6w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxJLz-00000000tg6-01Xi;
	Thu, 18 Apr 2024 04:26:31 +0000
Date: Wed, 17 Apr 2024 21:26:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	hch@infradead.org
Subject: Re: [PATCH v4 2/4] xfs_repair: make duration take time_t
Message-ID: <ZiCg9s6KHQ_oJ9d6@infradead.org>
References: <20240417161646.963612-1-aalbersh@redhat.com>
 <20240417161646.963612-3-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417161646.963612-3-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

