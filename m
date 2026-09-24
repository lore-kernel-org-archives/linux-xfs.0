Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F203D0C18
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 05:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790228996; cv=none; b=AfIYQjjmhP/4GEoQfnxNtO2iedHkyTlk6xdTbMZMQHEG7sWR3MtXWA0VHZOAKkvdYKNCsdiAYl3xLYkvPeK37kwzS3jSpV7+04pYsK5GgGQeewEjXNof565XWzNyrkPkzzP7GYvlnOJD4RNWnKfvHbGYUsAudKP/fq3zfA0XDzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790228996; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nAVLlNAcxLqFgkx2E+hV504F/JR1fL3rXFkPQbQ3pGrg9zVG00syRSWnm/HEcZMM//zfLLEl5AmY+y+QPbwht2M4ZlnX5RJlbnol3mDbGmw3Y7R864UMfNOT0vFDgAbHJmNrevzZRFX8U11ikA2OHNMZaK2sdii7BDA/xeR1O2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0evI6ilQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0evI6ilQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=0evI6ilQFnoLKYRqCSWYJBqIN5
	sIxgfxxgjDLYw0v1zwKbH0VgywyOyg4gjXCvrEfNP3BxilJcVLBYOfdPjfA6xLKqcX3R94D7UnGRG
	QB5q4l5UKitCcvcZg3+hWPSo9Yit43TnzScA4UHLp79bCE1YeHbJFhNLc5r7wh3KAP83tjP0m/nLL
	OksF0scxZkge+22iUKTrSZ0f+4E92XSgl3tapSuicH8FRrGqgE94D0Jv+HQRuAESGGw02GHAF8BAH
	mABHemkkoXC36y3bj0uYMJE9g5bi8pQTIqAV1FJNkJEm5xI7aE/Qquv/SDGF+3/wsgdJjF7exHcwn
	JkUl+Uuw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9cLA-0000000A5JC-2wky;
	Thu, 24 Sep 2026 05:49:52 +0000
Date: Wed, 23 Sep 2026 22:49:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: reinitialize dquot block if non-first dquot
 can't load
Message-ID: <arS6AM2eANvG4CfE@infradead.org>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159628.1875436.12664781946205413707.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179014159628.1875436.12664781946205413707.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

