Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552A6171A7
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388527; cv=none; b=Ifvc6Brgah0T4M/st7CCMC+a5m5dm6dEG/+rses8aVlhd+sgO6Ocua1lgp0bOMqpTbZBNCfoCIQdu1Z3no+o9uBCRAn/D0eQjOdZ1Bg0S0HcVVo8rI6bYWRA7UpCAlBOyuKNsj4TtC3F/0rQDzU4BsTayYJVgeyD6FisGvRJWuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388527; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qqnb8O1zp5r3IFQO3rwu12dDB41BKLtL6qiq8uuIgSDt3djXj79+yp18mJDRQA1MaXc1o4PahoRqPXcsflaTUgQOzt6KB82e8HjLaJ8bccJrRB3ooKZAIqBFfIirOnqvydIN3XAhLqiXO4XDs3snQ/4qc9ioXW/FHBqgzDF57Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HxChqkbP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HxChqkbP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HxChqkbPUEEKUYtDUf5ryIGvHg
	+sgf+YLbwEkW0RUsWSfgmARQ30BDbLpyx4MMybomi5NHhR1KxS2aqRCWwd1fBKz4QiDrEEjg+ARY4
	HUjLqgxmyCNKocoIxfXhlJ5VTUAOAnU/RL1tbjEFS5evYtOpkjUHKIcBFK02PjSA0E+95Lk259h3C
	zNcHMTEBqemEjPN1Cj+h74Wluo739wPEqwzs+znxuMwHsLouEbuZLj5K+NRCo3xcDJ15t5dBV9zp4
	vfxs5olbZa4xrEkh6KXMhPqaCupRNq92ySy98S1XMIvfgj7Dp/lAFWMm19csoZxJX7RF9aTmWRxQi
	4uOELJ1Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shME9-0000000FE9v-47f5;
	Fri, 23 Aug 2024 04:48:45 +0000
Date: Thu, 22 Aug 2024 21:48:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/26] xfs: do not count metadata directory files when
 doing online quotacheck
Message-ID: <ZsgUrV-zxFMB7OqL@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085452.57482.12698083966396269396.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085452.57482.12698083966396269396.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

