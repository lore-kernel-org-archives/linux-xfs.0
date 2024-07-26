Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A31217CA06;
	Fri, 26 Jul 2024 17:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722014085; cv=none; b=XA21bHLXWE5LwVqDTBV3ccpJpkxh2iu7OHpGXpZtLYzIfwHKSD3nxD0pJo9jA4gyT+KnRfdB+p+nINBULuvqzFbAlOEZZBIkZvZ0fIrES5dtF+5H9khka24YwSRS+myhvbqaAiuYR9JkML8hyRTwHpK8P5mQeV1vksPwTe+CoKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722014085; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cm+UCW4GIt03VkGUdQ+GqwmUYi6zJeHWzo7ezmpz3935vN9aBObvCw5nA7vjj0vzZ/KBT/dRSvnR4RlGXfh2+lntyAtvZMsaCK9E4+lKAGEl6aM1Sg1w/wnWuVKTlH5cEFmbTILfbPs5L4UyMK0M9FEXokiIx/1qkvC9ifcJdDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KLZByonb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KLZByonb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KLZByonbom5RryrjsiTGokPdy4
	yIb9Ef6Sm4AEKaIjLzR+ay+9gXRkAybLWBKMLNpp6eMdKQN8Fnzf+3scpkwoG/KHwqqB2AQbJILKA
	8xUKQpfcqxN10ZlpdHgVw2UGByqN/9xLb7CORRJzTyxCqHSwj5NVBjTKe504KJH84ffR9KFpDJsdg
	5qci+k3H2Dt1D1/7ABJH5oDkg4IXimlK9DdOHnKWB0/z9XeU/s0/xrdXxr0ztvKkeZ4VZ73VcNC5y
	wYINpSycAxYRp7jhhH712OI5Ur8g1Of1RYDcac9RIuQQLYyO/GlwUEd7OwyRi/va1tbNmdcdY/w/2
	iXgdIE1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sXOWh-00000004VBH-0F8X;
	Fri, 26 Jul 2024 17:14:43 +0000
Date: Fri, 26 Jul 2024 10:14:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, Ma Xinjian <maxj.fnst@fujitsu.com>,
	fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/754: fix _fixed_by tags
Message-ID: <ZqPZgxSlLgXoWI_N@infradead.org>
References: <20240726165107.GR103020@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726165107.GR103020@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
