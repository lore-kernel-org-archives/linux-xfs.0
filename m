Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8FF367281
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 13:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811453; cv=none; b=NJng2tZ3P3aJpJAkCKmONpbjnBoVAZSwi0r3hvHUnZCH6UcSmV8h02g1WlZZF6CrJzAsPcWa8f72WlfBkSpgdkLTv0mIEKLC7r3gcbSCVUQ3fNYmD5HTQbH8wos/4CBo4KkbtOKZTfdZe8lAJ3IdeGslSinIMaPcr82rBAt16zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811453; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hUt/J/wYLFsF+Cdhhtd2l73qGuKT0p784kyPtDOM9OC3P01Qq9yFt4ThKZlU7NZVWnA53B9micg6+52XOvTpWNkngH49k5g/4N3j3tWqZDuBEi0T5LlokJj87E60rF4IqvwTc+JASOa1t5riDy8DAm5VEO0gzZz8zWZeawXZavg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LB/d+QjG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LB/d+QjG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LB/d+QjGCUpL6mRckEjtSRyWZa
	0zO5yff2s4wLSMKMJCZ/Z7wAXaTwo3uRLjXAfd20AdWrnv419+8GWRQ9hbAk/FFipZCvTr1yzcDyK
	n9zMBqCSxSVAHQ+8BarrXP/0VC7f8v2vAgdXR3uoSF6Fga0Xo7/XK88AbFv/vjGNaFK9glL5PNMF7
	0Y9ERbiEqkU91H1Tnea+BHdhahX6XnPtJoEQ0t9PNqi0ehlCG44LRxH3722/vv1IDLxY+XASDcirP
	PIqTeM8b63ah8WWlgD84BIrLcpBRCFFtHE8wxnAv2IXQZTtUDzlStQhQaaORYmnxmvV/WcA3JUK5Q
	nltHI4tQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGG0h-0000000AYkI-2XtR;
	Mon, 12 Oct 2026 13:24:11 +0000
Date: Mon, 12 Oct 2026 06:24:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] quotactl: deploy typechecked helpers
Message-ID: <aszfe7-oRmCYZUEU@infradead.org>
References: <179158948034.3720791.6624320009127284341.stgit@frogsfrogsfrogs>
 <179158948078.3720791.2234654108960438102.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179158948078.3720791.2234654108960438102.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

