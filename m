Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C40137C33
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 11:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712144596; cv=none; b=kYZtvazFRfuRFXwFTpXJqpazoDmaQDtW3YGKejnDjAsvwjLCSEgNA4JbtAU/5SNNx8+F+Nr1xXV31r7nry/UYXHOtdagUzcKaPkydmQ0hpMlSQnXUyx3jrFnMz9n78GawbX7ZzsVswyY88mlQW0hTzVSSrCGTIkfq6i1bwV1eP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712144596; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=guNakZk0yRNGEHnxPN9whVpJshP32iYk+qD/4kCcXklnJcDTSMUfq9dX3MTfOX3r/Igkl3P9zZbchuZh4WjNwqHhjvXAy27dfmFroRvaVfRzyUQAmzuWjWju2xqhVmBB6KOJNJBbCaMZIznvpZGwY+LHUu7i47oA1IhqH/0mxvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GIEW0Ry0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GIEW0Ry0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GIEW0Ry0GOz9cYSRqRZznZQnl1
	2P4XN0EOB00AwhEM49mYQ/fhSlnm1edeBZkzug4NlGc+PZbUTlFeVSobkqxNaDtp9QFzq+JOQonGO
	uon7Cb8ue+AgCzlQjwDHujRmT0jmVMe1wxJW+PyXMaj9PRFOAUxhD+oPEJ1qm8zYSeKMrN0bPh1XO
	ldV1MCZn+KcHTiU6cEuYts7XZPMGeDEzx4KqJYHKHTbJnykNAJP6eMWEps75kJM8ncvpgJuZ+wOVO
	DFq5Nk6F5JHsN+toKhapV12LGvyvxwHrc8QF8KjRmaIW27/QlU28o3e0EKZfuDYTawI4vXy1IBseX
	aJ3o6wHQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrz1L-0000000FpRe-0Wdl;
	Wed, 03 Apr 2024 11:43:11 +0000
Date: Wed, 3 Apr 2024 04:43:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v30.2 5/5] xfs: ask the dentry cache if it knows the
 parent of a directory
Message-ID: <Zg1Az85WS8ECNbWx@infradead.org>
References: <171150383515.3217994.11426825010369201405.stgit@frogsfrogsfrogs>
 <171150383612.3217994.12957852450843135792.stgit@frogsfrogsfrogs>
 <20240403050305.GS6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240403050305.GS6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
