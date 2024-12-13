Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3336F1552FC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074270; cv=none; b=BCJehacBWcQTde5IWMhYY3vVMe4hW4g1X5D3Z54RFMul7+Gr1Mg+W02tSjkHqEMpM5UvXVZ4dPRoWmAqluvwlGRLCSdLPCxwklaO+xjiJ3tVCsFCfbldBSqeOxLPJ2O6MRa3qAmcVsOKqsutLq3v7HHoZRdn/QCCvPwE4esVGqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074270; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k+VRBJETa39/56He5HJcK6vZtq74T+03xLL4/LBsY7PKWe/NLAJfiBhrFf/KsU2P5voTlJxCjX8RbyTl5gqsWCh/bFrnGsMMjgZ4NCE0m/AFbgso3MNGqGQrBUhmBO5qNJo1TMzQEGVs2f76s6uws+Koi1jDdzXm2n6p+6nWYO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZQBocqYX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZQBocqYX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZQBocqYXZ4OjI1BB0WLsoS0Zfv
	HpArbUIjDu2kTbxOTiikgHrXI1aMTAR5yDApq0pnwE+EO7FZNntIe1fwEtYPgqQHc/tso4D7rBcWj
	1DmmqmQzCtrS1mDOiPRz2zwTDNm7KR134swamBQiIvwXxy6YAMA3J+sumfHg2nWwAQnWQwbqu3dkL
	2rpaWZl9w/7hcKc9fzgS8CjvcP4znrnnV6Izw8WSr7xC2FwXkCmcycb31L4JEQx4DOChZvveC4nip
	QIJAwjlNhu++nCeKunCLFFLETJ+lt5MHQyKx5Wbq63Pd1/a8mLRcBe6ySDvrPHbUfRPR3KN4e8ri2
	YGObrJ+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzvo-00000002wgv-38lO;
	Fri, 13 Dec 2024 07:17:48 +0000
Date: Thu, 12 Dec 2024 23:17:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/37] xfs: scrub the metadir path of rt rmap btree files
Message-ID: <Z1vfnLqBVOhitav4@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123744.1181370.14108227241545412092.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123744.1181370.14108227241545412092.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

