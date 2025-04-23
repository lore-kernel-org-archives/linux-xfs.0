Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71933280CC8
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 15:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745423046; cv=none; b=C4EVJGkU3ftzcS4nYBWCCpKrx0J0FWG54wje3gHLKeSj0Jc0CfNXA0Mv1LPghelX1fCcstwbTW6JvTVD//c6YS8kuGF/WRnkDHHLxCM0QktiyDDt+wK2TyxSeNlQG60JQxz4nSwg1/ODUDJFzSxrlf1bXc/4JrPE6KbR+qGpmTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745423046; c=relaxed/simple;
	bh=xIZQZihDP9esUWy+q2NpD8j9I24uNwORw4xJOWFme00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lMGL+GWUuU35wra3xjObZtKuwQ2pwU9K+yzRhx3y9W5gNw337PMwjvPPpfIBpD8BS/fcVmvVOLzoEJZO/TL85YEN+RZ2vN1ib+sOcTEQ5//CvGfvjrWrQVJW3D+Nb7lxk0eF777VB+rBXhg72yzy4PFRS4/VC4+sJt4p1PzI+7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aZXDIz+Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aZXDIz+Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xIZQZihDP9esUWy+q2NpD8j9I24uNwORw4xJOWFme00=; b=aZXDIz+QX+CCm1M7Hr7Wea8uCs
	9EptMC6oqURDDIqdezodXWQiRJwXMLLamQz//yf/y0WGt8TeO69ghNpKcp0LyB9NV6MRJhV6LZfj6
	eNXMsKblKkoZ9t0UZTFAbUhwve5+ir6cfEiCEmRYYj98JQRhIed/JghmqxQQzkFb0BF8QZbU0C76q
	WY9pO5QLyTTSGuV6c2pPjWZIxBkX3uhLGMyW7XWhK+uN6wXF2EpFikECJ4tPSCNe4rNDUFRm2NkOQ
	cHu6/6Gp89aaVMmFCypoIIWWoUHUS51UzwzJLPKXwCOpxXdrR2DeiL8K6sdwVLZC7KcfrZdJvQ73P
	yx1U1AWA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u7cGZ-0000000B0Vv-2gf4;
	Wed, 23 Apr 2025 15:44:03 +0000
Date: Wed, 23 Apr 2025 08:44:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs_io: catch statx fields up to 6.15
Message-ID: <aAkKw1tC78C7sZSX@infradead.org>
References: <20250416052134.GB25675@frogsfrogsfrogs>
 <aAcz6NiFfxJHAHQ5@infradead.org>
 <20250423153123.GE25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423153123.GE25675@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 23, 2025 at 08:31:23AM -0700, Darrick J. Wong wrote:
> "Add all the new statx fields and flags that have accumulated for the
> past couple of years so they all print now." ?

Sounds good.

