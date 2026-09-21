Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD5232B99F
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 08:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979163; cv=none; b=HPK7KjMkkIXKYxrK9oRFoAHW41858YnTYd+sv7CQQ76sDRZLqhW1/jQSbkSG4XhM1OKrDQdPq4qy8T7IOwA1Qz2cT7nPGSLd5Pb4MuWrIMy5kfRKQAVL0C2NlxKzURLdVLXK6O/OifloKbEpoN2YsQ8Ajq6tcFjxL30DdkrT1B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979163; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j7/O03J0GN+OHmsWjIGBkKkuK4mm371rqQEMDgGlex5iSpt39vQIkwST7yOqljQnmRIXC3J4GeL+PzUcazAzGJmmokBrAF49GZQ8xgz0yCD4bGGbkcaqj+zUJ7n6R06jUHgtjeY6GRp9Tvur4EROLDhlGzVvPsmf8bSKi7lrjTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a5nqm61V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a5nqm61V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=a5nqm61VvdrM8r3VrOePTB3y7O
	TZUkqyHSEP3EIfeluFr16q1mroupeLEvskoW3WEXWu9KeMdHnJYk0IW3tpObrrqxy5tSEpsf63eYL
	JIFQjugLnGjIAkNSq587MufdATFgVrbV1LBFl823rwwFx2T12AO3lmSZPji2F52JWkwqFrgKWXu0u
	ENCxAoValS1Kak6i/5zhIpZYOyS37KGI7u1DTmCyvGET3+1aiw4i5NZ2ShqnMnyPeih6tWN86x/Wj
	szhqJxp6hu4z8QXjpLc+TVmqjdrZPHjTZH6/ndc5mYo40xb92wnufXtZ4pMrYHpbA7GEjEVrdSDFA
	yZR5tZPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8ZLb-00000001L71-1HWj;
	Mon, 21 Sep 2026 08:25:59 +0000
Date: Mon, 21 Sep 2026 01:25:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_scrub: terminate systemd services if the
 sysadmin unmounts
Message-ID: <arDqF52MbnyDN--k@infradead.org>
References: <178996057628.169604.16261952311237371422.stgit@frogsfrogsfrogs>
 <178996057657.169604.179721236454402577.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996057657.169604.179721236454402577.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

