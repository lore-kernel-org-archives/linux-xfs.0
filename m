Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3961E495;
	Wed, 19 Jun 2024 06:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777920; cv=none; b=mG38vBF4L+uEwZga1MS5YP16suhWhH6E3ocC7EIb0hmLwsqHHWLVH9DYq/qNTbSb6baEUMJ3klaIDsgjK2MN2Zt0sXlX8lhdT3hz2LE9OELnhNp6nqAxWoh0hNaZD9C1zxmBX4sADjuJesMo3tTFCG3Vw5y1RPjoJTb57q4oC70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777920; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ap4vt82R7NKZvJPrWVOU2w+8bq7lbRoDnfOVjO3s2px/+dNGI9p2bZ88PEjQT4KRE4wzS4ze2deYM5jMoDR4VLtWhTlqV2gRYjbHXp/no59Bbfaly39xuJDLDorp8/uxaJI/kLjw9gw8aWHeYxKqbBBilHnbrN4lw5urV7YBvhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lel+BVE8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lel+BVE8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lel+BVE83HmzhCINPrUyeg1NXF
	DZwjkN2a48wJ2Q//md8oREqaIgbhf3CqtuytCQd170Tp9GnkUQGEQthtiBluOWPItRMp5q0n2v4Qo
	Uwpnll7ZEyEUn+Bb7m7Gni+wEBCppQwi1qYCl28GOowxjTgIjf5mMVEfGBdi0sbComskX1uk/rlBJ
	u+wdFaof2hXsUGN1VgyszZ+9vNkJMJ9mtF5LnVwczUuPurvTq9z2idWu936fHz2toJuO6OtWXOSlL
	gef5/YRlIRnIL1NOgKqMSTcU6xIpZ/NnEXYfh9lPmVYvlYJKiBbuLE7jl9qkO1xqKHw1GdxH1V+Jf
	f+tLrbiQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoeV-000000002Of-0CR2;
	Wed, 19 Jun 2024 06:18:39 +0000
Date: Tue, 18 Jun 2024 23:18:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] common/fuzzy: stress directory tree modifications
 with the dirtree tester
Message-ID: <ZnJ4P0l7kHW0sA6-@infradead.org>
References: <171867146313.794337.2022231429195368114.stgit@frogsfrogsfrogs>
 <171867146331.794337.1922848493796719618.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867146331.794337.1922848493796719618.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
