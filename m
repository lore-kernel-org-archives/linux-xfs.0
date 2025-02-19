Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AABD17A2F0;
	Wed, 19 Feb 2025 07:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739950322; cv=none; b=kt0Ud4nJVRlNtlGWw21NqeMnqvZe4H8Et6VRMZyJSQqe5tJPOEStmObpfj/Z7Aa2a/H7SFGCrP6PKHDMgW8/ErmlTYVAkvju2y8kObd3igKPdixfd/aMR9L4J/h0o6JH9SauV85QC7E4xtgqo9JGV39PLUKXjXubnoSOXaQo2wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739950322; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eq2sxs6wsIwBW60Swv6cQaGzTRu9ZccVkroIh6+ANShiYSfXhC6ocV3fBLBN0S16st9o9ElcOLhOg2mwhVLiONoBEJApmuIr4dfm0WtftoeO8qrBvu10b6y8BWDbh62WbUjKrznx1saOCLxPqAWitk+D1cNtUmhMkzGbMEKvgNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BYDrYjqr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BYDrYjqr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BYDrYjqr8V7PI22EeCtJiMJHyG
	yJuX8KlalGpFUZr3CvIVGk4N7PsXQo6mTuiNjx23d6uSdnSluP/lFA/ROvPFy6qb/DWiRHfoCIgnO
	GvR1Q3sQ3twSqnpbL55JMvK+6L3Ev/DOnd2dWxVNwwrdljml71jLlkRxTytMR6gHzJQcbVqZQlxJI
	PQsmJBAzGldIJEjl8qVcW7vZtIKtTmcXe3/W7UhoqZ5DEZ792g/XiTitkVsXwxQ1M1UFH59ZVQNCt
	UrPRf6mH2UvDYya6wzc1A7pAkgn/j/jLilyYDsDofPHCx0EV8F6zOdXWtjMBQ7kt4vq7bke9FmmXw
	AY0rCgQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeYr-0000000BGLT-18ff;
	Wed, 19 Feb 2025 07:32:01 +0000
Date: Tue, 18 Feb 2025 23:32:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 11/13] populate: adjust rtrmap calculations for rtgroups
Message-ID: <Z7WI8TaUFk5s_0gO@infradead.org>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
 <173992591313.4080556.12323562393894296677.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591313.4080556.12323562393894296677.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

