Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D789A1527B4
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 06:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731996550; cv=none; b=tWA5n2iaDLwpbOcsy6f16/LSFt+/rgLs+U2z5969uiNmtvIvBdIk+1aOWG1tG80lJF8zQR5jlQM3EnicR2yY+w3accVvHFTN8J0Hn9EfvxYnECsoGEfngBceSuqrzUpu0Dw7p3fzhoy5avMlQJMLL4CPr5lZlnY8CeQoI4NJVvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731996550; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T7PvBTKDY+/NnymgoUzSB0x4Rhqd/29REtTWHrLJMmwWs7k66+679io6G8HYpVEIK1EICFiv3AcnA+HamjC/TGNRqZGPwViC4BDY0rXPQbAaOlfpi1HNOyZw4zOJzzuYnrvjpRpMLvA3hOjqP3FVrrfxiiyAbTZwxUtKzhaok28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K8qptP5u; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K8qptP5u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=K8qptP5uQyrfGeIo64tz4h5KJ6
	lvnZh0JFI56dwGbLe9/J4al8xu8kRjb7LrVL+VQPUDBErtexet5JzmMFjIsIhpeRyaHimuxngre84
	RDME1O8KvMR2mjQ3Bz6xS+3Z8TLwpaYiET5dO4HbJioIATosdXvBHVfve/rPCwaXowHGcrWE2eQVy
	ValW3p18nDHWJVPzihRDbCCuF+DSxvU7PsTBTRAUN0r8amqXhRZgoISmV8sC5PC4Y0RcyHv3GGtaN
	+USP9zSGfGWjPyJBnbIg5MCe80KF2AM9RCjLmRKDozM+dApo/7x30GvNggS9fqaGHQqHrEJTNw2EH
	4S+PmW0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDHQC-0000000BUnp-2Bcm;
	Tue, 19 Nov 2024 06:09:08 +0000
Date: Mon, 18 Nov 2024 22:09:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: synthesize incore inode tree records
 when required
Message-ID: <ZzwrhGbXaWetNewR@infradead.org>
References: <173197107006.920975.13789855653344370340.stgit@frogsfrogsfrogs>
 <173197107039.920975.2579223976323116080.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197107039.920975.2579223976323116080.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
