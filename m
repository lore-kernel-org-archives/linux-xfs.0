Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5E81372;
	Thu, 10 Apr 2025 05:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744263395; cv=none; b=GD4oP9CvcpyeEMVhcITZLGZja4GwvyEJSWbzEhj0UrWc8k3SstkS7whXKzFZH/w0iP0MLyOEBp9ncK+tDp343BWO0cjQX1+iGQjApSiWnHfNvaBwIk95XTda0ICrX1XOz3sezVsG16sMAgy2m4aTr7pfndSWjF+hxZ0gx3hoNX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744263395; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rPN2slP4cJiwVESf8N29xPTsxmROtoMsVwXJPjEqWIX9n/BCTqFrAjucn6XniqH5MAHIQLqFHTBW13U3kiEtn4XahEdFMhpt7TYwSoF/h3mTJvoDzQoz3sb33iPdZIDrCflwUQbL85gs5A7H36Dcmxr8fTPt2HesnMMpFjBgk6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j/9drZXY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j/9drZXY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=j/9drZXYF+jDSLGwzXUBUS/dwo
	qzJq4oHragJiDCDOf3bIxIXkkjuBSoP5L6ZMcAGOJg+xGaNC02tDvXDqLFzGIvLwaJA4UtK9v27Ee
	VmQ8vTWGpcUxvkrNNXcOs0wYSGZR8KDTXrQjjANDWu3mgNi4+L1UHgvfA4rCT2Ypoh3TPGkRObFmr
	bVpLcweV5ZmJ0xM4Ru6IjJkvwzVDp4ljY7QI6Ov/r5tu3YWd6mcV6gqYPdTQ79vdthl+1M96+OLNY
	6TjLHCeZpVHqSdl3wvGHUFORYpe7q4ykHSk70IkK3xEfPFdGuTMMESpmO8STSKxaNy9bjGmTSyt+k
	ok5Qljag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2kaX-00000009ICb-07JE;
	Thu, 10 Apr 2025 05:36:33 +0000
Date: Wed, 9 Apr 2025 22:36:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs/792: skip test if rextsize isn't congruent with
 operation length
Message-ID: <Z_dY4H9BZ-zbJB7H@infradead.org>
References: <20250409151534.GI6274@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409151534.GI6274@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
