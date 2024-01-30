Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417DF56458
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 08:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706602680; cv=none; b=GjDPYcUDfinD4qznt0YsFXVr8lf23NrqBkJfWnwj4JVXkNfKLooZ4hTVwyKi4Hc2ukEl4EliPdpQkIPZ3rHkPme069NXCbkDbWTZ++NyiwHwi+XHVs7MxiWJu99CuUgULnek6gUo0b0BaQn9XNDr1QU7mWTSWtTvLyB9i+GbL3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706602680; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jidafhhM+rvbfHVybaSjdr+R80O10S2UQdPQaCwHx7eYjFz2U8NS4GjYvKt223sydQQgz7jTBGImhV9H7TmW74Ia1F9nXnmbAoxCncszm8pjY6k+14TUVDSJpz2oDvanAv+addpdq0Lor8cmGcBdccli83mq+YOFswvYK8u37Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P0VTCddg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P0VTCddg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=P0VTCddgWIMwBAeRixsiPQxyVG
	+mQIavSeB8yYPk1ccbRktfkX0BoiqcdEiUZVIPWAXGXQrmu9ST6a3VQPhQIvpxNEpxHWi5EmJGbbb
	whuntpyrfCTIte6PRGyRPU/lWvoTuYQ9BPXu4OCs4ubv9J3YkV6zznF1B7xRYFMWh5iDhg2bmy8mK
	UD67yJivDVGF+ZbfSSvWx/ygYXgSij9qdICcpXdH4XLiRHplVKGE6jdCSJRRbz4kllv5EVzXALKf9
	BczF5r8CnAeuP4xTj00BngVDhFIT6eDrrEotUpoFGTWs+2jbpP+fFAwPWLeWWVbbget1VEgNCyG5v
	zjJGYUvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUjJe-0000000FfTt-47jr;
	Tue, 30 Jan 2024 08:17:58 +0000
Date: Tue, 30 Jan 2024 00:17:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/8] xfs: implement live quotacheck inode scan
Message-ID: <Zbiwtr42fLJQM80F@infradead.org>
References: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
 <170659062834.3353369.12045189266475900429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170659062834.3353369.12045189266475900429.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
