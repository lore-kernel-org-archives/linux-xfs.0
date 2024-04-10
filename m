Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901AF1CAA9
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729703; cv=none; b=nhZgWH5Xo3KjQTlY0WwwpF0hVV70sdWWlGUWRpKTXl2CMV3zabBgDBecUQqonPHMR8+XkiI+YjJQ8PVL0sfDOS5DLS4tXOpi/YVN/Tzz+nP67xM1h4jDNUOb9pe4SJtgM4sqzDNaffRg3KxVgGnV5vVzd/9tun7iJFMutEZtKQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729703; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ncHrMCSpf2hmpfa8aZ91jlPJWS9MkVreK4BJAY7xFM+SPakSKf9Q1g7YINmuVq1ZUB/2zXNwBGxWxm0wByGUEIyJtDsT9pRvuA1bxpC1gig5SwCy3+952uwJunqNrEVti35H/4eafunfkt0I5bK7OX1E9XbG7HEc0tmCLJ06g8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1+qCEjJ2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1+qCEjJ2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=1+qCEjJ2MOaLFpU8b47/SzW3FM
	hxiECL966kX7rAM4wOdXROsCgwKM4go05xyCTks6ljby5MBtblR54j3DGVjjdIsNl+P+gI/Ck5Km2
	gRww+cIR6Z/bei12KXa70XyYBRJLDwHL/ZAzS9vNoCu8zP1ZOln9sW1PwFYnb5xh6l4vPxiJtD81+
	rUzXEmIgHzNkx5Oo4z4pKCjNuoMMnAQ0i4VrmQuWhGaUUCmZEB9vVV6a3AWMRKcKzfctUxkVZUAY5
	7Vi0bLqLUN5gKlFlZVXqIj+/iD3c2y7ruMungnHyHxxgQIX3GNUy2/QY4GHm6xrL3pNTwcSSODGTG
	Jd/ycIFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruREa-00000005LCP-3OG0;
	Wed, 10 Apr 2024 06:15:00 +0000
Date: Tue, 9 Apr 2024 23:15:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: salvage parent pointers when rebuilding xattr
 structures
Message-ID: <ZhYuZNIT1KdnQdDy@infradead.org>
References: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
 <171270970583.3632713.16977275276286469285.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270970583.3632713.16977275276286469285.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

