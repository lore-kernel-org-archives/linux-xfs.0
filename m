Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02C91C5D47;
	Wed, 19 Feb 2025 07:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739950915; cv=none; b=kXSD9oxnIzg0pPYQMpXj8J29T8JXS1l9zoa0MHxnLe2C/TV7pbJfm4aX/VR7FpJuuLpwEI6puKl2IlV5p1KjYcnBU6PfJxdh8FGY/fHJPVMQ7Y8glKMcaVdCNVIZwUQ2B/wjwj56TtMZoDwT2dZEizMwJR7fFf2S57+s4cFWK4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739950915; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CwjlWJhdVHSYS9nqAmre7SHdRWjsy/WdR5i3Z3LMdksVzrZv1jZermL9l8Dw5PQuExXQQrxBjwOd/e2uCnxisrRRFf0B/bRJpHG7MFcIW8RGQEIKKPcUbEBeK9O7Kpa4Gy0quczrj40HhacP/wwwsf4q5N+8aCkY12Ll7kPw2LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mq6zen0O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mq6zen0O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mq6zen0OjDyPW3e03Ou/QhWCly
	/fOpr+Xhh+VxoPWox8Ewp5JBwQnc5VVCY4gpw3af8XxYzeEHjoYH5t0sL3mbl3NdsVbDoOye8YKap
	92ed7gzZosjZS5JCjT/TI8p2fhsrM9435I0paLWLdfJkB1S4OsNlolZ4GR66xmuaw6+s0PK8YsXVv
	k/rGlATEszwN+2L0mHXUM4Af1Lyd83bsrBcg8cW21G3+rVHs2QUSxwtgTcy5xUQs/IzoZnM02fYlH
	SJweGK0/TxuoUgjuOccWGIAXGcWufzG7AUeAWpPxhP/ufj9T6q7Cll4wQTrjl92P+PXGUAGkrCL1r
	BWTTFgyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeiP-0000000BJDR-0I35;
	Wed, 19 Feb 2025 07:41:53 +0000
Date: Tue, 18 Feb 2025 23:41:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/7] common/populate: create realtime refcount btree
Message-ID: <Z7WLQTPkGWvjD2Ud@infradead.org>
References: <173992591722.4081089.9486182038960980513.stgit@frogsfrogsfrogs>
 <173992591771.4081089.11279761022882150065.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591771.4081089.11279761022882150065.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

