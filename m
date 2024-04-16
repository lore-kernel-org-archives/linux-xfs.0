Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036B91CD06
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 05:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713244502; cv=none; b=MyBZ5lANM8XCOVVQfHwjxPMmxz7SIBFiM4NShsH8CxfiszI0GZNvmafDuWO+t1CwnDJn/iJRU+50Nxkvqiq5Ss9pyCafS61nzL3CO3jtT4YfpzVqV11HAr03J1PsMtj0w6LPP9V8bSLY96N0SHJyrkCiJW33rfndk8lFUQiP6to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713244502; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHfgw8Y0GIVD9CYMAs3yQxHh448tej2x5YlzLZ8qZr8xHWoPd5G16yFHXaU4Dy4glj0HGh9SgRhyHPbyJznWnZBJeh6NK3R0xZzP9ZsuK/ri5l4QHEa/Pb+htFwPz/PTX1t45p4tfwubvimT/y536zJ4ghcYERJP7LJrZBtnI8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cZW2ir8Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cZW2ir8Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cZW2ir8QBZP6DhQFldPCoju4Gf
	/92UudYLp61NuH6RW3pQDMalEhzGZFbzggAKZOxkOYwIQPh24DZqOAnOi2h75P2JdpCCZR/4kA4JO
	jyQUOj5dFqrHPzwBjLwukLMmhn5mz4DzuVxXKxRrr6cE+BcZBKXBjmnZPpUKitNHTL8DmnU6eufrJ
	6irqHs/eH1EIjT5GSJy+wRHxhl8wqNWlhr5wEwXRjUWx+mxfEEyUxvIBzzj4AmHtqkm9siJuObxQc
	UI7VPWDjd2DaH50oHSw94TDXHF89aMe6jS1K2vVP6H78M+vtyPP4fXZYdKWJQTFDMLUIHhLGk1K6J
	trm5xQZw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwb9o-0000000AumB-1wZq;
	Tue, 16 Apr 2024 05:15:00 +0000
Date: Mon, 15 Apr 2024 22:15:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Subject: Re: [PATCH 13/14] xfs: refactor name/value iovec validation in
 xlog_recover_attri_commit_pass2
Message-ID: <Zh4JVKEtA0O2Cjj8@infradead.org>
References: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
 <171323027281.251201.1051479206383291887.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323027281.251201.1051479206383291887.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

