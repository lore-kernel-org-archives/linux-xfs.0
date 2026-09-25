Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A693CC32D;
	Fri, 25 Sep 2026 04:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790312291; cv=none; b=IxsPtixZch9GfKXElSVcJoqCKbsWtDF4xPfuLYW3owMp/x1y5AF0VrXfiD9fFs3Pwj0gfHJEzPNl6WqzbiK6HOY6W5edCm8/0cBz/WoaTZBvIum3cxQcaaEDPgIWmArl8jxa833l/slmMv9JN/ypouxR7S+V30ywLHNIhPxe5sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790312291; c=relaxed/simple;
	bh=r+GCm7StFikjwvfzJITOm6bhZ+Ui48jBS0ZIGmOe3hs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KH5Tin/GgAQwafYIDLfBIB6hvYut7taATssY2EiMsI96EeWGVe6uyr9ASIBEWY2F5CItyrtauG/QJh/CB5OML/stVpw2XCrlEyuoVJwBmeG9Iqhpxd60BlhumF1Fsb0zvxyyxV8F4tM5wp2JA8d8XtFXPZPFdDSjLCcubfyb4Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i2DBgLS4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i2DBgLS4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r+GCm7StFikjwvfzJITOm6bhZ+Ui48jBS0ZIGmOe3hs=; b=i2DBgLS4+2xTzS5WbwH4ICSuzA
	uUNhk122bupwu9vAjivtApX5kCH7M4HaD2K39Bg6ijT+srTyzNMY4zu7mtiVK/Zq+H/smNTrVsnjW
	WLVZFEzdlh+u000uEGDT1lEXq9blnSQxITzzwKiJNoD0+/e/oMGqXwXhpK5gJjzM0pIOQ2dJmsAy8
	zScxTKfCMjDa1DnxBB6mQpIjWFzKGqkP5iRiyXrpsBHYe+QEG/7ccmpCkDpH9vcSCCJPn7hVtgh4z
	qyDX/XDP892NVqyycKOKTZXzuJ0epmOy5ntZ0d9egfr0IhEQfFd0M4U2K3/fjN24J4Y3p36wBvmX1
	fbIMqaSg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9y0f-0000000CfFi-3caI;
	Fri, 25 Sep 2026 04:58:09 +0000
Date: Thu, 24 Sep 2026 21:58:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/805: skip this test if we can't mount the
 filesystem
Message-ID: <arX_YZb_Gmxrx3zb@infradead.org>
References: <20260924060245.GE6253@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924060245.GE6253@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I think my version of this is better - we really should never
use the scratch helpers unless using a real scratch fs.

