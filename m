Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E5E12E4A
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 04:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713243345; cv=none; b=f+rcLTPM+KQt2J5Eed+DvnEK03t4bYskxAwM2ULpbt7dzcpSOvR4qu980P+8HSwSTDXas4bbb4fznWqntlCHaVpvBEMaU8WkwgwwCUgc2PYtvyHcP1lWq/M0puRi4a5B05mE96oT/PYmvXf2CiIRlN8WNmw2nXoc7JnngETihpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713243345; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=buBbKy4eVnCCRZ5BPM8yR6jTiFYRb4n1dvM7A0zqjlS3+p0ltxnJbLYJgXAzS0XE2mq+xsh5zsxbdNcGkWI8pJiFK2BMbbrN2vp0Ov/DZxpwJ8s0lvxf1zli3eE6QdIrOZXKnteiSGxMbyLoh2xhcXQp72wOss4QYvT4XLWBpTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PL0ZsGCw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PL0ZsGCw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=PL0ZsGCwBTpZlO8fuDfLonySge
	4/i3uL5iFkjKwj6hBiQncNa+ZIp8AJUC0yvijDCECrtrvz5Z0D7lC529Aocdxzj2szu4p/ljUNayb
	8Dd5coOXJxltGTTag+OrWdInN7jXJ0c5q03YY641M1nx+EAsH8kBWdxuPelCAg/kQhRQDqnYfMH1G
	ExPbrWybfWtvqs2rfnFu2hWDwS2KbqvTljA6cGR21gxILc9pJzLakwqZ+jLgQw13X9d/ax4eRBvTZ
	OuOMFYBBNWpT7Ho0bwD+ky1T2SGHlFRme8gZGGCVRliZ6V2stfz0F+HCRks34pchJTnxuD2tKlNoh
	3k2KocrA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwarA-0000000As6r-1RHY;
	Tue, 16 Apr 2024 04:55:44 +0000
Date: Mon, 15 Apr 2024 21:55:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, cmaiolino@redhat.com, linux-xfs@vger.kernel.org,
	hch@infradead.org
Subject: Re: [PATCH 2/4] libxfs: add a bi_entry helper
Message-ID: <Zh4E0L29R3_LjIK9@infradead.org>
References: <171322884095.214718.11929947909688882584.stgit@frogsfrogsfrogs>
 <171322884124.214718.3562041695530689827.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171322884124.214718.3562041695530689827.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

