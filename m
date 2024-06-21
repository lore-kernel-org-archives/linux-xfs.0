Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E235AEBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944463; cv=none; b=BS6UlMpYjZmH2H2KDV8k4xI3iY6wNqlpJOYHY+/dtJ29iWFlAI+jmenCZzcNTmhnDH0Y4zt+kZ2vbNFjBBlPmtzu9taBHqIiVC8ephXniQDUeIocaMrm401pxILZMob5DrWolThAhlC0CSPV99UX4UfiQkpumzXF5Niqg+I/xZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944463; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JjGO9wcK4u1o2PvkildnBsD/wGKNPoiioayFLCTc8rCIQrULjYdWZOW7mDX4JynwpPCUlM47Hds54C1mR9y1ijf2Mgg+GM9HDcICsanpkj2/0iOuuZ8po2kbn/8uKaj2GXSwC0Z9DdtoakS792ijZbxLPRpNIeS+0hB3KCdulHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AmjmtXkz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AmjmtXkz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=AmjmtXkzXekoVLNsZ3boYjb+9c
	Z3F2fo6MtLrBNXK22788VyTl6CXqUgBuScwHrNNxWyOca0UaNsWJk7HC716zwXvuGnQLfmQlJmU9b
	3Z1U6ssCV0pxGtnJtizs/8VbNXW3Gb3Z8cW4wS5seq9O65MkY1ZyDonBAolSlz/527io9oezo9Oq5
	WHoOS3sTBUC5Uz8U2OAiStrRS6r2zLEpMf8a7fo/x71FPFfbA4flZz8gbZfk1wly0YgnVpU1JdB4c
	ChJMaPC2RR1mbHsLR4IF1HhhJ/Zg+9/6lTXmTpMnPG9NkaHNLsQamgaa9myrZ0flgdg7ifhr80wSy
	za0TFdGg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKVyd-00000007edS-2MEo;
	Fri, 21 Jun 2024 04:34:19 +0000
Date: Thu, 20 Jun 2024 21:34:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: honor init_xattrs in xfs_init_new_inode for
 !ATTR fs
Message-ID: <ZnUCy645rODh3BnG@infradead.org>
References: <171892459218.3192151.10366641366672957906.stgit@frogsfrogsfrogs>
 <171892459334.3192151.413694580283882579.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892459334.3192151.413694580283882579.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

