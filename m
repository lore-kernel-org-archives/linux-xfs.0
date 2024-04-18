Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF7853AC
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 04:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713414210; cv=none; b=IB1Xfv3VAX+yX0EK9PXemj5yzj/mfqutGziFpry/lELiVYzZRxQt4vnQaDEh+qR2Gigj5p47JWsyxjxWTCQVDNVp9EENnBMaTO4iyz8113z9xfJREG81mgVVoZb6I9ZR1r4Dz4c5Gjy7obpf/k6TQwSxXgQjabrdCAuYpb7493Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713414210; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ae6vyoJtqsSvgjpYHETdFzOe0Qc7NQNSVkuJAL/PbH0eQQYvpo1tyc+dELAvRPJkiAtNCUyCSxhZR1DgltMudGCOpCfwcZKGkj0lFH8SGmYDd6NRlmhl6uKa9HHZKAW5USyfwIqsWmKLZcV+vvu2OSDKARsvHhtfN75g6iLK3TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MubXdXsm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MubXdXsm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=MubXdXsmyzNMoHCD3o2kdr/Gdz
	4qLc+l7M4xWkR+HqY0B9P2B1wDVYzgjezmnJYw01dij19FR/XlKXG5C9tKwTISCo1yHwqjuq9fDnK
	QfK3UkfKk4TTEYQ3OLfq1yJ0rlt83dSKb9qHAtd5kkWWqcDot4Q+mK4r45BBuqH0uCSTT0qYouDaP
	yDhEJN1gahzPGm+75fPJjqbGGAHcBrCnnctr0OYsmw9T7oEEStQYGkCu7cQfCRCyofAeooPyAyobR
	441Gfgupy2K7mbiKWUIZadSOvUVtuwHoIBjqlQiGeEChcJak308LiQXAlTuFgGWV+qxv5WEbbdvQq
	CC/CD4Bg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxJJ2-00000000tH6-23H3;
	Thu, 18 Apr 2024 04:23:28 +0000
Date: Wed, 17 Apr 2024 21:23:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/4] xfs: drop the scrub file's iolock when transaction
 allocation fails
Message-ID: <ZiCgQCZWLBGv2Ytz@infradead.org>
References: <171339555949.2000000.17126642990842191341.stgit@frogsfrogsfrogs>
 <171339555978.2000000.9920658450385469752.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171339555978.2000000.9920658450385469752.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

