Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976EF1B85D0;
	Wed, 19 Feb 2025 05:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944693; cv=none; b=ihPz3Jre0uGgV5gI5xhXhBc5l8YeIOFwWGpsBd6etqInqli5lDZoFPQuf1Zr1BpbAwg3BKtJXRMA0pG4UYc9fUlob34nAxzy04/uAL85ewE8bFsCpzVCBBPuOYAnQIgpXWaLsQrc+6UiLkpc6Bs9tQiGipE82djvLz6kCmdPZZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944693; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G7bQYyu51cNvh7E2S6Kwb5tkIXcuDEFIVRs8Ak5j1hK+jr7gemdeaqu1eF1QjVqF2fSYfAQ5W1iZ2l8KzXO8gy+XNhW60SXjGh8diXryY+CWKzzWtGFfmyFoSXIJ58pUoxmVE0cE0ikmeMKMeAF+uIyA5PGWyOctmNC4eLk9dhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mKgtYCYV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mKgtYCYV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=mKgtYCYVPquBs0kN+dfeAy22rd
	15+nIvL0wnss8RBrrzK0+PT6BfqKAxHR9Nf6iFNACv1W/EPXcAndI+StawKtT3Ik/k8H8AJS7eV6c
	KMvJ5sMW6qQvUXYJmKLf1J62JthNGVTKICsYWV4oeHj1xSLQuwvTxYq8Ul7euhIgMLfOXx0MBbdZ9
	uEFO6CKhh8SLHKtRyzRbFp5Khuo4j+F4kBoiTYsgbguCGJ0vTAE6md2Bskp6JDbR6E18KzR0U8NB3
	S7V/tQaAR9I2nyrLbSGXZG5wHoMfpUWUJxbzSAeu0UAwqNshxhdAsFC0Jzq4vYhFPOTRTZU7X8Aqv
	egvYos6w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkd64-0000000Ay9g-1Uu9;
	Wed, 19 Feb 2025 05:58:12 +0000
Date: Tue, 18 Feb 2025 21:58:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 05/12] misc: rename the dangerous_norepair group to
 fuzzers_norepair
Message-ID: <Z7Vy9CIpLtcOwzy6@infradead.org>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
 <173992587496.4078254.14824377885868657428.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992587496.4078254.14824377885868657428.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

