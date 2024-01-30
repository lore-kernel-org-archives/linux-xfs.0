Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E1753E26
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 08:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706602608; cv=none; b=WQ/VFNw3X1LcdoMXOn4h9bsSI34xxbs/s4mq3iWA7rEG0xRYEkNaCvSfY23U6NRliZenD/GGujlr3Lxng+i0MxbABkI+1cN7OnsJtWxV5gIfXFKWH/KSQFjdEoHsqyeuO2XXheEStV1OW1p0SwygKBdSJCDj6xjBeDlMTjO5MS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706602608; c=relaxed/simple;
	bh=NST3K9LgoPN2tZh4oV9s+59ACowEgDF+SmffgjFXzDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T+ufunHVWLp9ePZf3Sb2twbMzYQAqcElK8167KSfo3Y8hkEw/mVdc3tvSN0Qo5iS5YvVeCzOLFIKH8Qd+UfQ6+mIE60WIHlxjJ9nffPOKiCq4K41U4kKeWieXXW+AQiSHU8FhSPJ4LMHp1xdBl5oGfF2Pk+Oyxo5X0KN6EIslq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jdgxqiLj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jdgxqiLj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NST3K9LgoPN2tZh4oV9s+59ACowEgDF+SmffgjFXzDI=; b=jdgxqiLjsotyV2RvHfkfkOWZA9
	KKssxmm5PFHdS30X+swLzaJGtxll0Bow6bEUMe9fJSE1m+qX5TODwLeo4dbU0+u/bFfwUj+HXBKLJ
	BbOBuDK0WILoTapr5Bb/NLzXELn0a6egp0BchnM5Aynh3WomAyXglRIB31k/e4bccfs5rb4XoKPwf
	tkvsJdEe6QQyamr/gBr8p+bRr0N6QbLt3l9Mt4+9B+EqccuCgO6+qQOCurjSFNrcXLjEta+zSwK+G
	J1xuCJlOKQizywhzWfKpdclvSQnQqPu4PgQzB95k80Mem3Y3JsXXlmiKvEx6bJcov5dcRVO8j8eyw
	6nRN08hg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUjIU-0000000FfBv-3It7;
	Tue, 30 Jan 2024 08:16:46 +0000
Date: Tue, 30 Jan 2024 00:16:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/8] xfs: create a helper to count per-device inode block
 usage
Message-ID: <Zbiwbl7u_InTyfZB@infradead.org>
References: <170659062732.3353369.13810986670900011827.stgit@frogsfrogsfrogs>
 <170659062802.3353369.11902244582318302459.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170659062802.3353369.11902244582318302459.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Not a fan of the name calling, but the patch looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
