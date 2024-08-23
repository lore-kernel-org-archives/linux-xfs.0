Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B97171A7
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388575; cv=none; b=D/kWIdrzjAieacRAtsj2kbMJnbQnpTcKfvHTnXCbWePOn3BsGBmhEtQ4AGdyMCZIs+5rJYkrG3xgTvbUfaaZrAIsiNblu/BOV6boIqtWoxIrELJ6XrWjzide0G32lL5SllJmLhJroRTsac5UyrR4EYWWywkHH4NXMDxWff8Rd/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388575; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XEFTHX14myt2E8d0/InF3RMCuvKTrKz0KClNhJBe7aUjwwedDMRKQ+tyXtrVr9BOyJ1e/QZVKfgvnzb6XwxcRyCWvMzZ6Hmz2VixZZs0qO1H3trW1t2z7GLeMWxd9v7Zu4fyWQy4x8bTh4o6IJCxIY4NJHSeI61+zgKKW9ctnOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aMEgpgw0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aMEgpgw0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=aMEgpgw0jdbaddsmTUOJkTbV0q
	g4VhwyK7A26Kv/B6NjHBuRrFFMwU3ytCV8/sVAUb0zHVwX0LDwc2L2lGLNtEUM3EKb9FP38h3TGTz
	XwgZx51X4kQZlMrgtKh7r3lrUaNmQlT9juNfbY2fhLj0bSShA2I0/7UB8byG7kxFUVtwsFp2Jv2nP
	lbktrVIQgvNor9tCwl6ytV8GFZOcoTGgXPMg1lqpUSX8MOg6J6J2EaGmxl1r9hre8MGyj/h2K8jz+
	AvVTcwk3TrT2f6ys2h97MwW+NuBB/lfAuRzgD9io8a7zNzAZLsUKMTGdwARRZPxcYVcAdsskmpSlv
	j2X92PtQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMEw-0000000FECy-1Mfv;
	Fri, 23 Aug 2024 04:49:34 +0000
Date: Thu, 22 Aug 2024 21:49:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/26] xfs: don't fail repairs on metadata files with no
 attr fork
Message-ID: <ZsgU3n2BcaYSW-XR@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085468.57482.3631281958745114225.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085468.57482.3631281958745114225.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

