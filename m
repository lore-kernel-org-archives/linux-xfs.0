Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98860189F57
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081300; cv=none; b=Jzbtc9OUM93Fbe1yyt1QGfT3QFzr7hogzBFUJ14s+RY2s/WxaUap2K5ZHnGsL7sPCxUmP+sx9s41luX1WXJPdu99vTNTtYMdPzSPP8Ofw94DRvlKvrMiYMJN0XEFti1Q5zIGLY0LLg/ShB3vnbmp6T1lrQ9pkJfPjpI7yMFB6IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081300; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oK3rgXyFO+wV5TdF+3VlETM9hBNsTMeVRC2sxl/mtEszKQpmTt/ZZc55xbxoQlZ57MAJuyefE+uyv19r6R+ZZOm4whnGXd4ZeIEeIS7h4Eg0Ka0VVIr0mDIwlIrMiOrW8Q9FATXt8HhWOHDETp2jrqn9Bk8VQvFnkT9OqkknJls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vTUYBgac; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vTUYBgac"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vTUYBgacRLnPiFk/OGocILxRbr
	3OMCKbADoKyhAnxonlk6JqJIbnvc/osmdiudJlq4k9ZHMKBK/y2cIjv3ZWgvoHjNH/N2aMLgn1mjw
	T0lV6O24N8ngjJ75FtLKBx5PyYytbfN+p8QYMaNZn7gh4BT8RZypsPWTLusfsrhFlDsiYLb/Ylm6k
	HBgeQc0pzsAPctmEsfFjhWDkSv3PfsE2hUphl9Z3mnF8x0NpNHvOxbtZc1bqMHAiAhHxntzxQ1yv/
	zCD3lqXt4ltiM+JTFGhCtYEHXbY98iVlHjFfjV/Sda4Xe4KiJJ4HudXpRp9qhRllYxOBp64R//AVT
	ZfeZOFuQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1lD-00000003D4y-1cky;
	Fri, 13 Dec 2024 09:14:59 +0000
Date: Fri, 13 Dec 2024 01:14:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/43] xfs: enable sharing of realtime file blocks
Message-ID: <Z1v7E_U2jX4McuCM@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124910.1182620.7183592337728397486.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405124910.1182620.7183592337728397486.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

