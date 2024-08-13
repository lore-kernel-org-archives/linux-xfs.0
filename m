Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE3022089
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 05:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723528020; cv=none; b=GBUc4pbOwZ1cFw8hVjieOqhe40E38vhAtQgLhqr/Fd9q1R5xRBWbGPInut17jGRpb60K5GcAXUZwXnIfK9yiewmAeWvBaGBXFvHjpwIAjgySrTDuxi6yzAk04FGZX7PIv87WYmZINaeaprv6IgmomwCRvo441MIvSCE+/30Jsbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723528020; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dkeMFAcgEG+IzErSizwaVH7LM4JgPZT8cIeBgo1vAMTWyJSXzlKRUlzLkk/ra3nh+sJ5fLwkiSfHUVlDdB1pXQdBIoceRs7g7OFKrAtJJt3f8k9jnO7XY00xbWBdzE1AL3QmlKhwiVkRChCYPRHOZKn9cyQU0uhCKb7sl1oViFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b8bSSrDS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b8bSSrDS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=b8bSSrDS5tYRjYzis0dxGj0kaj
	8VTp5mS5vXqzyzlnKIfmnNrg3WkLQl5jnT6rVj21xNSv5d6F40wSEy/3Dwb/5bgd5LMqPiE5QEBHX
	FABCzEk7kUcBPElBXvqYNwmett0HmqPho4CzCNLB4nJZNYSl8Gr0qho91Dap/iLe6nef1Dv2awmZv
	g5siAGKCjDWIyC7pdkRQ8UD9/hnTVp4gKk/0Blj/QeTdurTaPQTSMFVWlwDyZy0ByaB9ZPTf5nFKH
	qqPaslSniy3vNfzBRxIGRsaCs24NqfK2kpa+ARGxBsUhZry149wzcgNQhGhkpztRHr78b0NlLrLDs
	8viYtdyg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdkN1-00000002U26-0THb;
	Tue, 13 Aug 2024 05:46:59 +0000
Date: Mon, 12 Aug 2024 22:46:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>, kjell.m.randa@gmail.com,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix di_onlink checking for V1/V2 inodes
Message-ID: <ZrrzUw55-UQZ649j@infradead.org>
References: <20240812224009.GD6051@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812224009.GD6051@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

