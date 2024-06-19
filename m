Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A245F4A1D;
	Wed, 19 Jun 2024 06:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777453; cv=none; b=uPjR5Q8JNEB5s9VMY79l6C+Fal7keM/VMkGv+mguu20k6mNyNeWT775B2wtrjmID3oO6Nfi1T9Yw2qtJwpO0LMl6kd2QLsSlom2SOhWRkWc1JjdVjRI0GK8dgxVpNgx35XfNZNZkVhawAbmcHM3CB9I9Xv5C/gKUKgnmbCUULTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777453; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RxadTjRQtWIJa2nPjRYcd+pFGRRzhn1FPWMpmK6cHYQIkxfvTY/IUhezEu9ZJLpXw9Tqb2f4Ao0zcIBLACpJ/D/mtLVsvbhBAifit8gexPcqHEyxJVNqPtgdnwebPlTOmvz6FQcsRMuKNRfqKAwMCYz4Xsfrnywskfb1uZOMbNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nGpVsLK2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nGpVsLK2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=nGpVsLK2Ew3cXyixExUnu0Ml8D
	Bd1uPMy1n/Z4Ev9o0wTrmXiBD6OoAvkLAfV3pWiYyj3mQqd2gGzyPSwPlIjTvP0KSE0MT3GIjgzee
	Z4GdumGT8ZZ5wT+Gr8Tb4XvOzrdaCNDVBdzBDZMUGe1yI2LR4KJUy9vELoBvOK1rHtIu54OTjeYsq
	vj1SyCKuQmXvdqmOPPLiYWD7GvZas1Jlz8etvK9uxezTKQTV/TKzLMWUaXeAA4nusPl1l83hCfSZk
	EcgR3ITxCGDA+PbCSmROfYOA3A4tJ71FnJUkJ3n/R+uzTuQd14wMpNtILB3LeGtoCjvXo8EMk93AO
	XQbVM0Aw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoWy-000000001EV-0TMt;
	Wed, 19 Jun 2024 06:10:52 +0000
Date: Tue, 18 Jun 2024 23:10:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs/206: screen out exchange-range from golden
 output
Message-ID: <ZnJ2bKnFLkBTcVkY@infradead.org>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145436.793463.8960807127589028072.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145436.793463.8960807127589028072.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
