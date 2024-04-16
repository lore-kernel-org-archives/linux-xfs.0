Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F209381D9
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 04:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713243380; cv=none; b=W+cBSWPdKpcZX97FWv/W7boKd7ShlrXC5yDk0+i4IoUu6WnAFGitRid0DwlKHANI0tDgLHaOTdT6CzcGbSjnrNVwVlse+kAGUGiOF1ho+AX57R8tVZPS2q2laFuezBmBd4Yiw2Y6zH3IODhEVMzoMUhpCBgn68VeU01ZoPVMDkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713243380; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qicTN/2gW0AsmG4H0HWxPnnuu/LHJECYQun1SXyojOWENZoxVQ9nOz5ed86GEK1CH7lR9H4fULILaPZ7F+Xfjl7wq6+Zu4Q4sD1netb7zXZGOUpMFWDEL79AyGl6q+ip/Kz4GLDa7u3Dq40T+EvJq7nFEuzbBvZwOFY+jNAh0N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D8fJ8dNq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D8fJ8dNq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=D8fJ8dNq6PfxnuAzoc2aWpWjVt
	PBDduMliRR0NiQ7G1BMh+Qg2tRSebqARExMmiliZgw/hmsk7bjveKyi2wVbquEpoYyD8pOca6tG0c
	i9dW/uf+TiqraiavOUj3VKJVmYJyniHBL20zNuokxiypOXC4xzQP1nfk1hVKqapgDfjm5BYz2fBPt
	iULw3nAyKyARnD47S/+G0O16E/7t0HtMjYedX7fgC1K/L+8Ql5Y7ABlSVNL0xk6zaNkyPmA5vFhZj
	x+fLEfwgCX//mfPT20ekCESyQhMQ+vpNSZaTOh+4C3FFpzxk9MnqhruWBEuZPyxvJD/EmHFaaUCfV
	qu+kfQNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwari-0000000AsDq-2zMA;
	Tue, 16 Apr 2024 04:56:18 +0000
Date: Mon, 15 Apr 2024 21:56:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, cmaiolino@redhat.com, linux-xfs@vger.kernel.org,
	hch@infradead.org
Subject: Re: [PATCH 4/4] libxfs: add a xattr_entry helper
Message-ID: <Zh4E8tPRcTjzjU-q@infradead.org>
References: <171322884095.214718.11929947909688882584.stgit@frogsfrogsfrogs>
 <171322884149.214718.12923043891090426855.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171322884149.214718.12923043891090426855.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
