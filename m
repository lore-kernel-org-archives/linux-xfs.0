Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C88208B2
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709140638; cv=none; b=ds4SdGXsJKxKA9blvNi/pZWhfZ4d0yUjZL+SsRGyaySJfDHRmSgRwYA3gJfT5LE1kkiWwqzpMkSX8dtpSiKvhdKge0dgFzoSKzxof46qsLL6UFaSCnws2wvc5jtPNHZKb/4zAEE+tsLp/1ZrmrkLcC4UWU5SgcsQcyLaEcb04as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709140638; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tLMonkuaDoi2rOivYqHyr+4o9V9hfwDWzxJmkT0xWLRMB9sCbmwRjzBKNz3qb5DzpM0HHpRLHMnveLo7+PuTI0aBSqix+I7S2j8C5R1pj3QhwQ4qomJqBHilBm02d/R2qviI55W4O5YqaLoWuxbpPHwmnpQhQrKPFZsvWGSWtCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=reGW4Fv9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="reGW4Fv9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=reGW4Fv9t870f1xtU+uSZnDt7m
	l9QtuQDBEitmez8X+Q+7MIXKh3onJOpZA65hCnLhfKBdfnFrUS/WiWAXrcZRk5t9rPS8GFFh4ILhF
	rw+IsfAbNfRORu56e6pafR7XMxAmfRYFxtJ6LCyitpNhe2Noy2h2gcJ2uejOE5FgHyYYHERkQMgJ+
	C4S/M3edaEctLgo/lOGQKJM2tO5hGrYkENdeK/jcjEsFARKWIBf+pIqYGkiLB0EUydZJQa5nI6cfK
	2xJIkMYbaKr+OhvbRwZF7t2WPNnRqPBZliWVFTlcxFWCInXxpthxGq7Msqr68zIY8T/NCoqPv7wf2
	5O9MnY3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNYS-0000000AG3M-2JpI;
	Wed, 28 Feb 2024 17:17:16 +0000
Date: Wed, 28 Feb 2024 09:17:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/4] xfs: scan the filesystem to repair a directory
 dotdot entry
Message-ID: <Zd9qnKwo4ESLojcG@infradead.org>
References: <170900014444.939516.15598694515763925938.stgit@frogsfrogsfrogs>
 <170900014488.939516.5368879219295258358.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900014488.939516.5368879219295258358.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
