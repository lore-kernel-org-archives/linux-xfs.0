Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA29713B798
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 14:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709045290; cv=none; b=tXdXgW9INiZZ3PYM3JeYM+hR+CGlp+ozt+SD48bllSRX6PADR9C8pdD3T8QvDIvgL6sxY+OIM/K1NZ4wt9JCvyC7xv4AiRJ+c4eOzrj8cYiUAX/fqTWIiQajLRCtgtHvMFIf4F7al0MeKCSqyDKEl+wLJrmsOLTWA9HK08144UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709045290; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n9QLNbC33M5v/qI6t1jXM0RDxMgI8PjofPZHNeOPImmtjNjknaqQKY5ZfvlYxw3mico8T0s/FTVTID2TBermWAzwsAepq0Ee1CHdIW/xakKpt1fDl9PzaqBDCtmWW4shnoQnm9h6pdGYe8rpa8ZvpBIBak4kxxX8lRWCiVHfHMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RnlPbhF6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RnlPbhF6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=RnlPbhF6vzUEgkZgwLoKKSgTsN
	vIfqwW4rMjG3/PTWVxRWKTYH72N45eDYeoQhVy8xc9eZUJVjH/6MqNGMCGNJLsxIg+zcW3oMCSO59
	SLl4vwSdYSw6V7h4ZRUd08nsUsoyC877cZvuY49qbmYY1lQnDFjLET9niqqcKhYlWzLsXjveHJcmN
	eWUeSFPfv0zVTEt6+LtBnT4Y9oYcAVtazQ+Iby51YTcwMgvXEmj9lLHykSNYMWqJxQdc1Qr5e71ei
	CenQJP7Kao1XvUfbCsoKnfN1TyAyU6N5IFCJeYNCmI2CH+q5lfwyRxD94SvW/HGqUB3QqSsDAQjJG
	/ID02JcQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reykX-00000005ddO-3mOq;
	Tue, 27 Feb 2024 14:48:05 +0000
Date: Tue, 27 Feb 2024 06:48:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 1/2] xfs: xfs_btree_bload_prep_block() should use
 __GFP_NOFAIL
Message-ID: <Zd32JRCQsFGnr-30@infradead.org>
References: <20240227001135.718165-1-david@fromorbit.com>
 <20240227001135.718165-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227001135.718165-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
