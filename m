Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B717642A94
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389374; cv=none; b=ouBPmtjo4EUSHuCs4+z7SEVez7I5Uu4UMBx0CacvsTRHKJ2EqYkNxJ1sGMIpcs6V6V6VpaKayt9p4i3r2OeArK9snqNY5YaiIpjaFZNK1JaOnf3Eo4xEzfxVgR0RN/XdPXi/UjmjhMUoMuCGUZ1Udl3aSK+UzUNyBwWP4wUko8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389374; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nv/D90fR80ooKqx2kg/HcQFt9oxbPRsBNBFqA+gAE19XBqCSgIYFmdMgL+L2iNC89gC4j6IP+b7ggizNcnuX9muOtOtOjFGxxa3hNeaBNuTZ9IWgt5Y97mBwujkojszVQWKPuxtBkkvqTRS6ss4WfUIVR3PWnly/9ghwwoRXMSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rfU4tZJS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rfU4tZJS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rfU4tZJSeeVbFwUNP3YlhECWKg
	gIbjk7dIMFLbQxSHcGmoUKMMCwkGzVM+n0b4HP5VgiMcrBmnZgn3G8lgLziuOiJwQGLAfpW9ZxGYH
	/+CAP7Zwltvf9IHIY/KydaNqZUuLWhOVRU+5LWnIZmrGF/5NKCYJLnwWLV5KsvaIF20ScYPhyGxh1
	0byTmhZE0dtQl0EuLgFhUVNWaXpEIRRpGLjsyCOcGQXvvgj6zlv6PqME8E6EIEKSmU7TXI80KLQ7j
	qhiatjzFR47sXMpeBZT5bgVNdJAGQJhZMnXoR7O21YBT3/qMeukbsI5KxMypTRSeIc/4mqvVoPXhz
	ylgBdkKQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMRp-0000000FFhT-0fAm;
	Fri, 23 Aug 2024 05:02:53 +0000
Date: Thu, 22 Aug 2024 22:02:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/24] xfs: support caching rtgroup metadata inodes
Message-ID: <ZsgX_aqZUdJYQBRy@infradead.org>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087487.59588.6672080001636292983.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437087487.59588.6672080001636292983.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

