Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A824685
	for <linux-xfs@vger.kernel.org>; Tue,  6 Aug 2024 13:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722949595; cv=none; b=D5U0VcG+rECuy0lLQn/4OJMo2yBZHKMZyc0T8q3YKivVS7lq7eJ3WZzp6ltNpKUp8QnYu32mkjEEN04S3e9VsHfarg8nNH8kHIETADQRE8p6WopQPUOUv2aZxE5pQlqwLJD3uZDYrRqXVbw6hbYbfni8Uoj8TBcYlKgSk6l5NxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722949595; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vEBHeFF4bz5d+2QTpZa/PDWQDf4P29KwTq+GBMiaQPvfMn7IhE9WCw+mRXST4RqUKEU7xmEJ7dzcVmVTc+HXG85FPOKtLs01t4Kd9iJHw2/urTDbdGYMz7s1+auNaJz5CaNNdzaN7ICjZtQCs/a0RCBOp/E6Z/Wu5PVovob60V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cdB+cq2N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cdB+cq2N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=cdB+cq2NVz5eR2PiOK+sVw6Edo
	1USXcaE5UzVekfs41MvwNxsEJRwEq5FF8N843EL5lLs0FqrWmqDzUmUKbLcf44xefpOWanjqManyX
	UzuJvks5NQy55Sj89p5xUysWBWJrkKcmhkI8uAnkh6Ec57AXRqzAfNBSW6zFd7zTpjUPzYRWxt9Fy
	gd/KQaCD6QJtrXiJz7DzdptpZeL28wlcWnzuJKpDpqbmewAfPQrKJdDiU0UF4GuwCdUjaqLtQ0jDy
	B+tLprEaitrymMQAr7tXRq8sz36UiLMPE90jox+32onGhaFyV7KC7SGVYKkd0cnbBY23d1SVLgqgv
	J0M+G+ow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sbJtZ-00000001dAX-44fl;
	Tue, 06 Aug 2024 13:06:33 +0000
Date: Tue, 6 Aug 2024 06:06:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: attr forks require attr, not attr2
Message-ID: <ZrIf2aeYwyH6uhux@infradead.org>
References: <20240805184534.GA623957@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240805184534.GA623957@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
