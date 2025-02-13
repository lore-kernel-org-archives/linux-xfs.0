Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6962054F2
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420627; cv=none; b=H/kQQXytVu2Sn2dOMk847ZOkY8musRqdJd5of31q3G7TLL9yPgef3/e9RwJonZQs1zTqklFNkzLJtIGIiq6qTCRoAw1UJUgH93ThnHV1qpastg1LRHcTGfQK5nbdj9qykP1B1SIQbFZNrY6IOGq5+i0sniwV1IOD9KfHl1qD4kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420627; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQiA54NR7PDJAMx/sEEcQH8tYPreMTzM5QkbwiUr0QB3Tw9D/ssXzurPiZIvo7hncFaJJawq3hy1pcVQPSbphBnuNOAU3AeqBdhWdinb9FXMKtkh8dbijzs++3PixWsJDwbFMwZeigVEMPgyI2qW61jr9mlFIAr/gaoL32fWx84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NMeal3bv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NMeal3bv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=NMeal3bvLHce0MtiGXY0RxCQU6
	WI/QDbY1hJd8wjASmN6fOuJR5ST9OCujubduBf4OBgAiyrg8yNvzBdbHbOdEFwQHLsKFcick3OFMb
	BoDb4z9rilR5kX6VcwdK0wXWPuxkxRKl2kAYIFVm2ech+xnwUbPT3udWDlCroCVy0UFLLq0PeYWfF
	GdPysrgivSKkNNzgtUw8gNmHp8+vQ39VvUQ7XPREJe9eg1ox48K2/r0/P3uIaWMrH4Kk+0EKKaeK/
	seUdpXCBHxiZGX7TjlBnJOkpKu5Reu5HlitIgwhf0hw186OTBS0MUApawzRwObRwRAe981/cTVZ0x
	JZPxKdFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQlN-00000009i4f-21U0;
	Thu, 13 Feb 2025 04:23:45 +0000
Date: Wed, 12 Feb 2025 20:23:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/22] xfs_db: add rtrefcount reservations to the rgresv
 command
Message-ID: <Z61z0bqp0wBWEwEK@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089070.2741962.16480973892880802520.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089070.2741962.16480973892880802520.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

