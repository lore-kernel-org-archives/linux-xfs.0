Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D637D44103F
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 07:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768979280; cv=none; b=LHwSjE9cWg6bjMFFopNjV7rATcb4Q0OP3zoTAiBINyeKv3TnOPyk5yJStnYp9UOwpwaiGjJH6n0W/ENHGIheXvfqDVLYRAZ/gyNe8UjHLoGzHJ2z0cdc/r80JMOeMJvUB6nvrmhrNNy1RAfCjqKABYfdYlZY+9YUj1/rXnymqI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768979280; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vmdgo9L19sQExB+UEk19pwiNWorYuUxbbTUKj91NZbi6bF4Lilnp2XvTG3ft1H9DtipBwZAWQIowJgl95GIaRBecydeG7FbPLWyHCd4XFwdVGVVC7osbccPPRnIOwSeKiOKTNBl7WRsvLNIMqX0rGxsbAnapPhGf1fCILyTQzYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pgbfvCx4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pgbfvCx4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=pgbfvCx41556qpbAnmm7rKgS/+
	LGm1Y9PH6B9Hk7gMaDDi3SlHcOydJ8IeKnag9XpxxjnLpvguYPMnWCXdptRdmsRXY6A1YcCZuPos2
	jZTc2eI5s7lgzMGjR1gehdqcfEmb0VdTEZtw4KHEOqptd7DJ5XZ1VKulSVL1kHWSpJ2mcIuqoFjPD
	OP+ZD4YGzxWCGUAS9m2r/FvdK7QAPu0mrWxa9GnYZz1AGeeSlCPoX289dqwEJwi0ChIAJxqo+iPvy
	oLln8DEjGff0rMMMHTxwZC5EG+1E9njORj5rnwQ/1F31mRHvHRdpSYqj+R6ExP439WBpKLccG9Eqf
	DgSxWklw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viSJn-00000004zGO-43gQ;
	Wed, 21 Jan 2026 07:07:55 +0000
Date: Tue, 20 Jan 2026 23:07:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_logprint: print log data to the screen in
 host-endian order
Message-ID: <aXB7S_Zt4TCW_3c0@infradead.org>
References: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
 <176893137107.1079372.3049439466012040581.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176893137107.1079372.3049439466012040581.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

